//
//  ImageQualityOptions.swift
//  MarvelHeroFinder
//
//  Created by Kevin Martinez on 3/20/22.
//

import Foundation

struct ImageQualityOpt {
    
    struct portraitAspectRatio {
        static let small = "portrait_small" // 50x75px
        static let medium = "portrait_medium" // 100x150px
        static let xLarge = "portrait_xlarge" // 150x225px
        static let fantastic = "portrait_fantastic" // 168x252px
        static let uncanny = "portrait_uncanny" // 300x450px
        static let incredible = "portrait_incredible"   // 216x324px
    }
    
    struct standardSquareAspectRatio {
        static let small = "standard_small"    // 65x45px
        static let medium = "standard_medium"    // 100x100px
        static let large = "standard_large"    // 140x140px
        static let xLarge = "standard_xlarge"    // 200x200px
        static let fantastic = "standard_fantastic"    // 250x250px
        static let amazing = "standard_amazing"    // 180x180px
    }
    
    struct landscapeAspectRatio{
        
        static let small = "landscape_small"     // 120x90px
        static let medium  = "landscape_medium"    // 175x130px
        static let large = "landscape_large"     // 190x140px
        static let xLarge = "landscape_xlarge"    // 270x200px
        static let amazing = "landscape_amazing"   // 250x156px
        static let incredible = "landscape_incredible"   // 464x261px
        
    }
    
    struct fullSizeImages {
        static let detail =  "detail"    //full image, constrained to 500px wide
        // full-size image -   no variant descriptor
    }
}


//MARK: - Notes

/* Use a image with a varient ratio from the marvel API as next
 let imageURL = imageHTTP + "/" + ImageQualityOpt.incredible + "." + hero.extension
 
 use the imageQualityOpt if you don't want the full size image.
 */
