//
//  ViewController.m
//  LinguisticTagger
//
//  Created by shuichi on 13/03/18.
//  Copyright (c) 2013年 Shuichi Tsutsumi. All rights reserved.
//

#import "ViewController.h"


#define kOriginalTextEn @"Apple Inc., formerly Apple Computer, Inc., is an American multinational corporation headquartered in Cupertino, California that designs, develops, and sells consumer electronics, computer software and personal computers.\n\nApple was established on April 1, 1976, by Steve Jobs, Steve Wozniak and Ronald Wayne to sell the Apple I personal computer kit. The kits were hand-built by Wozniak and first shown to the public at the Homebrew Computer Club. The Apple I was sold as a motherboard (with CPU, RAM, and basic textual-video chips), which is less than what is today considered a complete personal computer. The Apple I went on sale in July 1976 and was market-priced at $666.66 ($2,723 in 2013 dollars, adjusted for inflation.)"

#define kOriginalTextJa @"アップル（Apple Inc.）は、アメリカ合衆国カリフォルニア州クパティーノに本社を置く、インターネット、デジタル家電製品および同製品に関連するソフトウェア製品を研究・設計・製造・販売する多国籍企業である。旧名アップル･コンピュータ（Apple Computer Inc.）。\n\nハードウェア製品として、スマートフォンのiPhone、タブレット型情報端末のiPad、パーソナルコンピュータのMacintosh（Mac）シリーズ、携帯音楽プレーヤーのiPodシリーズ。ソフトウェア製品としては、オペレーティングシステムのOS X・iOSや、統合ソフトウェアのiLife。クラウドサービスとしてはiCloudなどの研究・開発・販売を行っている。"



@interface ViewController ()
@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentCtl;
@property (nonatomic, strong) NSArray *colors;
@end



@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self showAvailableSchemes];
    
    self.textView.text = kOriginalTextEn;
    
    self.colors = @[
                    [UIColor redColor],
                    [UIColor magentaColor],
                    [UIColor orangeColor],
                    [UIColor cyanColor],
                    [UIColor purpleColor],
                    [UIColor brownColor],
                    [UIColor blueColor],
                    [UIColor yellowColor],
                    ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark -------------------------------------------------------------------
#pragma mark Private

// 日本語の対応スキームをログ出力
- (void)showAvailableSchemes {

    NSArray *schemes;
    
    schemes = [NSLinguisticTagger availableTagSchemesForLanguage:@"ja"];
    
    NSLog(@"schemes for ja:%@", schemes);

    schemes = [NSLinguisticTagger availableTagSchemesForLanguage:@"en"];

    NSLog(@"schemes for en:%@", schemes);
}

- (UIColor *)colorForAtteributeForLinguisticTag:(NSString *)linguisticTag {

    // ---- LexicalClass ----

    // 名詞
    if ([linguisticTag isEqualToString:NSLinguisticTagNoun]) {
        
        return [self.colors objectAtIndex:0];
    }
    // 動詞
    else if ([linguisticTag isEqualToString:NSLinguisticTagVerb]) {
        
        return [self.colors objectAtIndex:1];
    }
    // 形容詞
    else if ([linguisticTag isEqualToString:NSLinguisticTagAdjective]) {
        
        return [self.colors objectAtIndex:2];
    }
    // 代名詞
    else if ([linguisticTag isEqualToString:NSLinguisticTagPronoun]) {
        
        return [self.colors objectAtIndex:3];
    }
    // 副詞
    else if ([linguisticTag isEqualToString:NSLinguisticTagAdverb]) {
        
        return [self.colors objectAtIndex:4];
    }
    // 接続詞
    else if ([linguisticTag isEqualToString:NSLinguisticTagConjunction]) {
        
        return [self.colors objectAtIndex:5];
    }
    // 前置詞
    else if ([linguisticTag isEqualToString:NSLinguisticTagPreposition]) {
        
        return [self.colors objectAtIndex:6];
    }
    // 助詞
    else if ([linguisticTag isEqualToString:NSLinguisticTagParticle]) {
        
        return [self.colors objectAtIndex:7];
    }

    
    // ---- NameType ----
    
    // 個人名
    if ([linguisticTag isEqualToString:NSLinguisticTagPersonalName]) {
        
        return [self.colors objectAtIndex:0];
    }
    // 地名
    else if ([linguisticTag isEqualToString:NSLinguisticTagPlaceName]) {

        return [self.colors objectAtIndex:1];
    }
    // 組織名
    else if ([linguisticTag isEqualToString:NSLinguisticTagOrganizationName]) {
        
        return [self.colors objectAtIndex:2];
    }
    
    
    // ---- Token Type ----
    
    // 単語
    if ([linguisticTag isEqualToString:NSLinguisticTagWord]) {
        
        return [self.colors objectAtIndex:0];
    }
    // 区切り文字
    else if ([linguisticTag isEqualToString:NSLinguisticTagPunctuation]) {
        
        return [UIColor whiteColor];
    }
    // ホワイトスペース
    else if ([linguisticTag isEqualToString:NSLinguisticTagWhitespace]) {
        
        return [UIColor whiteColor];
    }
    // その他
    else if ([linguisticTag isEqualToString:NSLinguisticTagOther]) {
        
        return [UIColor whiteColor];
    }
    
    return [UIColor whiteColor];
}


- (void)showTagsWithScheme:(NSString *)scheme {

    // スキーム
    NSArray *schemes = @[scheme];
    
    // NSLinguisticTaggerオブジェクトを生成
    NSLinguisticTagger *tagger;
    tagger = [[NSLinguisticTagger alloc] initWithTagSchemes:schemes
                                                    options:0];
    
    // 処理対象テキスト
    NSString *targetText = self.textView.text;
    [tagger setString:targetText];
    
    // テキストに色をつけるためにNSMutableAttributedStringを生成
    NSMutableAttributedString *formatted;
    formatted = [[NSMutableAttributedString alloc] initWithString:targetText];

    // トークンのタグを取得開始
    [tagger enumerateTagsInRange:NSMakeRange(0, targetText.length)
                          scheme:scheme
                         options:0
                      usingBlock:
     ^(NSString *tag, NSRange tokenRange, NSRange sentenceRange, BOOL *stop) {
         
         // タグに応じた色分け
         UIColor *color = [self colorForAtteributeForLinguisticTag:tag];
         [formatted addAttribute:NSForegroundColorAttributeName
                           value:color
                           range:tokenRange];
         
         NSString *currentEntity = [targetText substringWithRange:tokenRange];
         NSLog(@"%@ : %@", currentEntity, tag);
     }];

    // 色分けされたテキストを表示
    self.textView.attributedText = formatted;
}

- (void)showTagsWithCategoryWithScheme:(NSString *)scheme {
    
    NSString *targetText = self.textView.text;
    
    // テキストに色をつけるためにNSMutableAttributedStringを生成
    NSMutableAttributedString *formattedString = [[NSMutableAttributedString alloc] initWithString:targetText];
    
    // トークンのタグを取得開始
    [targetText enumerateLinguisticTagsInRange:NSMakeRange(0, targetText.length)
                                  scheme:scheme
                                 options:0
                             orthography:nil
                              usingBlock:
     ^(NSString *tag, NSRange tokenRange, NSRange sentenceRange, BOOL *stop) {
         
         // タグに応じた色分け
         UIColor *color = [self colorForAtteributeForLinguisticTag:tag];
         [formattedString addAttribute:NSForegroundColorAttributeName
                                 value:color
                                 range:tokenRange];
     }];
    
    // 色分けされたテキストを表示
    self.textView.attributedText = formattedString;
}



#pragma mark -------------------------------------------------------------------
#pragma mark IBAction

- (IBAction)segmentChanged:(UISegmentedControl *)sender {

    switch (sender.selectedSegmentIndex) {
            
        case 0:
        default:
            
            // 色分けし
            self.textView.text = kOriginalTextEn;
            
            break;
            
        case 1:
            
            // 品詞による色分け
            [self showTagsWithScheme:NSLinguisticTagSchemeLexicalClass];
            
            break;

        case 2:
            
            // 名前の種別による色分け
            [self showTagsWithScheme:NSLinguisticTagSchemeNameType];
            
            break;
    }
}

@end
