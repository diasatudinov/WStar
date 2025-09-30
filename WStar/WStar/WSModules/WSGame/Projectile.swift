//
//  Projectile.swift
//  WStar
//
//


import SwiftUI
import Combine

// MARK: - Models

struct Projectile: Identifiable {
    let id = UUID()
    var position: CGPoint
    var velocity: CGVector     // points per second
    let radius: CGFloat = 6
    let owner: Owner
    enum Owner { case top, bottom }
}

struct Ship {
    var position: CGPoint
    var size: CGSize
    var hp: Int
    let maxHP: Int
    mutating func hit(_ dmg: Int = 10) { hp = max(0, hp - dmg) }
    var isAlive: Bool { hp > 0 }
}

// MARK: - ViewModel

final class VerticalBattleVM: ObservableObject {
    @Published var top = Ship(position: .zero, size: .init(width: 300, height: 200), hp: 100, maxHP: 100)
    @Published var bottom = Ship(position: .zero, size: .init(width: 300, height: 200), hp: 100, maxHP: 100)
    @Published var projectiles: [Projectile] = []
    @Published var isRunning = true
    @Published var winner: String? = nil

    private var worldSize: CGSize = .zero
    private var lastTick = Date()
    private var timer: AnyCancellable?
    private var fireAccumulatorTop: TimeInterval = 0
    private var fireAccumulatorBottom: TimeInterval = 0
    private let fireInterval: TimeInterval = 0.8
    private let projectileSpeed: CGFloat = 220  // pts/s

    func configureWorld(size: CGSize) {
        worldSize = size
        top.size    = .init(width: UIScreen.main.bounds.width, height: 380)
        bottom.size = .init(width: UIScreen.main.bounds.width + 100, height: 400)
        // Позиции: верхний — сверху по центру, нижний — снизу по центру
        top.position    = CGPoint(x: size.width * 0.5, y: top.size.height / 2 + 100)
            bottom.position = CGPoint(x: size.width * 0.5 - 50, y: size.height - bottom.size.height / 2 - 70)
        // Подстроим размеры спрайтов под ширину экрана (опционально)
        let baseW = min(96, size.width * 0.22)
//        top.size = .init(width: baseW, height: baseW)
//        bottom.size = .init(width: baseW, height: baseW)
        lastTick = Date()
        start()
    }

    func start() {
        stop()
        isRunning = true
        winner = nil
        lastTick = Date()
        timer = Timer.publish(every: 1/60, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] now in self?.tick(now: now) }
    }

    func stop() { timer?.cancel(); timer = nil }

    func reset() {
        stop()
        projectiles.removeAll()
        top.hp = top.maxHP
        bottom.hp = bottom.maxHP
        winner = nil
        start()
    }

    private func tick(now: Date) {
        guard isRunning, winner == nil else { return }
        let dt = now.timeIntervalSince(lastTick)
        lastTick = now
        guard dt > 0, dt < 0.25 else { return }

        // Fire logic
        fireAccumulatorTop += dt
        fireAccumulatorBottom += dt
        if fireAccumulatorTop >= fireInterval, top.isAlive {
            fireAccumulatorTop = 0
            spawn(from: .top)
        }
        if fireAccumulatorBottom >= fireInterval, bottom.isAlive {
            fireAccumulatorBottom = 0
            spawn(from: .bottom)
        }

        // Move projectiles
        for i in projectiles.indices {
            let v = projectiles[i].velocity
            projectiles[i].position.x += v.dx * CGFloat(dt)
            projectiles[i].position.y += v.dy * CGFloat(dt)
        }

        // Collisions & cull
        var survivors: [Projectile] = []
        for p in projectiles {
            // bounds cull
            if p.position.x < -20 || p.position.x > worldSize.width + 20 ||
               p.position.y < -20 || p.position.y > worldSize.height + 20 {
                continue
            }
            // hit detection (круг по снаряду vs прямоугольник корабля)
            if p.owner == .top {
                if hitTest(circle: p.position, r: p.radius, ship: bottom) {
                    let damagePerHit = Int.random(in: Range(8...12))
                    bottom.hit(damagePerHit)
                    continue
                }
            } else {
                if hitTest(circle: p.position, r: p.radius, ship: top) {
                    let damagePerHit = Int.random(in: Range(8...12))
                    top.hit(damagePerHit)
                    continue
                }
            }
            survivors.append(p)
        }
        projectiles = survivors

        // Check winner
        if !top.isAlive { winner = "Нижний корабль победил 🚀";  isRunning = false; }
        if !bottom.isAlive { winner = "Верхний корабль победил 🚀"; isRunning = false }
    }

    private func spawn(from side: Projectile.Owner) {
        switch side {
        case .top:
            let origin = CGPoint(x: top.position.x, y: top.position.y + top.size.height * 0.55)
            // цель — нижний; добавим небольшой рандом по X
            let dx = (bottom.position.x - top.position.x) / max(40, abs(bottom.position.y - top.position.y))
            let spreadX = CGFloat.random(in: -0.15...0.15)
            let dir = CGVector(dx: dx + spreadX, dy: 1) // вниз
            let vel = normalized(dir) * projectileSpeed
            projectiles.append(Projectile(position: origin, velocity: vel, owner: .top))
        case .bottom:
            let origin = CGPoint(x: bottom.position.x, y: bottom.position.y - bottom.size.height * 0.55)
            let dx = (top.position.x - bottom.position.x) / max(40, abs(top.position.y - bottom.position.y))
            let spreadX = CGFloat.random(in: -0.15...0.15)
            let dir = CGVector(dx: dx + spreadX, dy: -1) // вверх
            let vel = normalized(dir) * projectileSpeed
            projectiles.append(Projectile(position: origin, velocity: vel, owner: .bottom))
        }
    }

    private func hitTest(circle: CGPoint, r: CGFloat, ship: Ship) -> Bool {
        let rect = CGRect(
            x: ship.position.x - ship.size.width/2,
            y: ship.position.y - ship.size.height/2,
            width: ship.size.width, height: ship.size.height
        )
        let cx = min(max(circle.x, rect.minX), rect.maxX)
        let cy = min(max(circle.y, rect.minY), rect.maxY)
        let dx = circle.x - cx
        let dy = circle.y - cy
        return (dx*dx + dy*dy) <= r*r
    }

    // Helpers
    private func normalized(_ v: CGVector) -> CGVector {
        let l = max(0.0001, sqrt(v.dx*v.dx + v.dy*v.dy))
        return .init(dx: v.dx / l, dy: v.dy / l)
    }
}

private func * (v: CGVector, s: CGFloat) -> CGVector { .init(dx: v.dx * s, dy: v.dy * s) }

// MARK: - View

struct VerticalShipsBattleView: View {
    @StateObject private var vm = VerticalBattleVM()
    @Environment(\.presentationMode) var presentationMode
    @StateObject var shopVM = CPShopViewModel()

    var body: some View {
        ZStack {
            if let currentBg = shopVM.currentBgItem {
                Image(currentBg.image)
                    .resizable()
                    .ignoresSafeArea()
            }
            
            GeometryReader { geo in
                let size = geo.size
                Color.clear.onAppear { vm.configureWorld(size: size) }

                // Ships with images
                Image("ship_top")
                    .resizable()
                    .scaledToFit()
                    .frame(width: vm.top.size.width, height: vm.top.size.height)
                    .position(vm.top.position)
                    .shadow(radius: 6)

                Image("ship_bottom")
                    .resizable()
                    .scaledToFit()
                    .frame(width: vm.bottom.size.width, height: vm.bottom.size.height)
                    .position(vm.bottom.position)
                    .shadow(radius: 6)

                // HP bars
                VStack {
                    // Top ship HP
                    hpBar(hp: vm.top.hp, max: vm.top.maxHP, color: .cyan)
                        .padding(.top, 120)
                    Spacer()
                    // Bottom ship HP
                    hpBar(hp: vm.bottom.hp, max: vm.bottom.maxHP, color: .orange)
                        .padding(.bottom, 60)
                }
                .padding(.horizontal, 16)

                // Projectiles
                ForEach(vm.projectiles) { p in
                    Circle()
                        .fill(p.owner == .top ? Color.cyan : Color.orange)
                        .frame(width: p.radius*2, height: p.radius*2)
                        .position(p.position)
                        .shadow(radius: 3)
                }
            
                
                // Winner overlay
                if let w = vm.winner {
                    if w == "Нижний корабль победил 🚀" {
                        VStack {
                            Image(.youWinTextWS)
                                .resizable()
                                .scaledToFit()
                                .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:250)
                            
                            Image(.hundredCoinsWS)
                                .resizable()
                                .scaledToFit()
                                .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:75)
                            
                            VStack {
                                Button {
                                    ZZUser.shared.updateUserMoney(for: 100)
                                    presentationMode.wrappedValue.dismiss()
                                } label: {
                                    Image(.nextLevelTextWS)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:75)
                                }
                                
                                Button {
                                    ZZUser.shared.updateUserMoney(for: 100)
                                    presentationMode.wrappedValue.dismiss()
                                } label: {
                                    Image(.menuTextWS)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:75)
                                }
                            }
                        }.frame(maxWidth: .infinity, maxHeight: .infinity)

                    } else {
                        VStack(spacing: 70) {
                            Image(.loseTextWS)
                                .resizable()
                                .scaledToFit()
                                .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:250)
                            
                            
                            
                            VStack {
                                Button {
                                    vm.reset()
                                    vm.winner = nil
                                } label: {
                                    Image(.restartTextWS)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:75)
                                }
                                
                                Button {
                                    presentationMode.wrappedValue.dismiss()

                                } label: {
                                    Image(.menuTextWS)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:75)
                                }
                            }
                        }.frame(maxWidth: .infinity, maxHeight: .infinity)

                    }
                    
                }
            }

            
            
            VStack {
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        
                    } label: {
                        Image(.backIconWS)
                            .resizable()
                            .scaledToFit()
                            .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:60)
                    }
                    
                    Button {
                        vm.reset()
                    } label: {
                        Image(.restartBtnWS)
                            .resizable()
                            .scaledToFit()
                            .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:60)
                    }
                    
                    Spacer()
                                        
                    ZZCoinBg()
                }.padding()
                Spacer()
            }
        }
    }

    private func hpBar(hp: Int, max: Int, color: Color) -> some View {
        let ratio = CGFloat(hp) / CGFloat(max)
        return ZStack(alignment: .leading) {
            Capsule().fill(Color.white.opacity(0.15))
            Capsule().fill(color)
               // .frame(width: 180 * max(0, min(1, ratio)))
        }
        .frame(width: 180, height: 10)
        .overlay(Text("\(hp)")
                    .font(.caption2).foregroundStyle(.white.opacity(0.9)))
    }
}


#Preview {
    VerticalShipsBattleView()
}

