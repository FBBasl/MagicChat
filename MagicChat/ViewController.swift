//
//  ViewController.swift
//  MagicChat
//
//  Created by Асылбек Жилкайдаров on 29.05.17.
//  Copyright © 2017 Test Inc. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var scrollBG: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    //Контроллеры, которые лежат в скролл вью
    var firstReg                     = AuthenticationViewController()
    var secondReg                    = RegistrationViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerXibs()
        
        //        let blurEffect = UIBlurEffect(style: .dark)
        //        let visualEffect = UIVisualEffectView(effect: blurEffect)
        //        visualEffect.frame = view.bounds
        //        visualEffect.alpha = 0.8
        //        self.scrollBG.addSubview(visualEffect)
        
    }
    
    func registerXibs() {
        
        //регим ксибки
        firstReg                         = AuthenticationViewController(nibName: String(describing: AuthenticationViewController.self), bundle: nil)
        
        secondReg                        = RegistrationViewController(nibName: String(describing: RegistrationViewController.self), bundle: nil)
        
        
        //задаем им фрейм
        firstReg.view.frame.size.width   = (self.scrollView?.frame.size.width)!
        firstReg.view.frame.size.height  = (self.scrollView?.frame.size.height)!
        
        secondReg.view.frame.size.width  = (self.scrollView?.frame.size.width)!
        secondReg.view.frame.size.height = (self.scrollView?.frame.size.height)!
        
        
        //для второго экрана нужно задать расположение по оси X, потому что по оси x он находится правее
        secondReg.view.frame.origin.x    = self.view.frame.width
        
        //добавляем в скролл-вью экраны
        self.scrollView!.addSubview(secondReg.view)
        self.secondReg.didMove(toParentViewController: self)
        
        self.addChildViewController(firstReg)
        self.scrollView!.addSubview(firstReg.view)
        self.firstReg.didMove(toParentViewController: self);
        
        //задаю фрейм для скрол вью
        let scrollWidth: CGFloat         = 2 * self.view.frame.width
        let scrollHeight: CGFloat        = self.view.frame.height
        
        //задаем contentSize в скролл-вью, что-то типа размер внутреннего пространства
        self.scrollView!.contentSize     = CGSize(width: scrollWidth, height: scrollHeight)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        
        return true
    }
    
    
}
