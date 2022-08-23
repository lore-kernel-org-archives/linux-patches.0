Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC81D28E2
	for <patches@lists.linux.dev>; Tue, 23 Aug 2022 21:53:19 +0000 (UTC)
Received: by mail-pf1-f173.google.com with SMTP id x15so13812321pfp.4
        for <patches@lists.linux.dev>; Tue, 23 Aug 2022 14:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flatmax-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=FnXtIAn0IyAxdQUTX7XZR7kL9caPa6K/jTtIbR9ZQeI=;
        b=obG8zpTD+VGj/DhquSB91/B1nOh31Mf4zX+mS3y0p5WZzXTnSJmE6BQmTBA4htk1bt
         XRB+svL4DsVm3OkT5aF7hEmIk/4ALS2HX0O2/ztMnxBw49FnjkWu9FdCfnqi7jQqRU+d
         93bGDbVwtR9FlSajQpZw/u8rSYDVTNqP80KtM3yeeIfToDmxuUv9olyyqcQDpDJeWSGi
         Se31wC8WzlmZeIawaNAM86zcgRAoNetc+63r/+hXDvOEqTgzpIkonR8X/m6Zh4Os6+eX
         wJIR+cK/L+K6oi+d5tFd8eKuKOA39x2u5gtPHF2/ignKoLU990mH7UniqFXIep+6DPUG
         I9fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=FnXtIAn0IyAxdQUTX7XZR7kL9caPa6K/jTtIbR9ZQeI=;
        b=w34j6U7F7pdfJLN134oPa+53pRFTNUXaV4HOdMNKzhR5BWI3bRv41doq93xW75U5ju
         ZZN9XxeKGEnEFB7AmKZ/JlYq8bbl5zO0Didx+wSYObJyW0/WjrMTsxdlUY+TjoDcYAxN
         i6AtWTPozuimafI2J4zSSO61Ebiia3+I/SdHjBrsJwnR5Ggop2SDo1A5HKBO6cnJM6Cc
         pj628CHpj6HUZtrYEoQwW6RAXUEiPSlsQBteFYa9EmWDDbsKHadU+77cWbuRAKMFsrLE
         dYluCb57xUdjuYBI6BSvboXE5TGlciIS7a8dvEzt+Nc2j9tUIp40wnxcDNfYugcxCMeK
         FrTQ==
X-Gm-Message-State: ACgBeo2qGvQGk1d9Xfp4EdA9Q1w7SDOcZuQjASpDvslnmQAYM9iJ68yz
	bbDx9u61MMoxfKPgOF3WCnl3iQ==
X-Google-Smtp-Source: AA6agR5ZlhUCW0kK8H4ShGD2wDJdvUWRcHbYtHdfzqHhFuCrXOYakw0jq4ZSaTBUiLOaY8O66jszSA==
X-Received: by 2002:aa7:9e4b:0:b0:536:68f0:dc93 with SMTP id z11-20020aa79e4b000000b0053668f0dc93mr15058614pfq.8.1661291599070;
        Tue, 23 Aug 2022 14:53:19 -0700 (PDT)
Received: from ?IPV6:2406:3400:213:70c0:5c76:4280:5b6b:9ce0? ([2406:3400:213:70c0:5c76:4280:5b6b:9ce0])
        by smtp.gmail.com with ESMTPSA id f76-20020a62384f000000b0052f20d70845sm11232126pfa.150.2022.08.23.14.53.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Aug 2022 14:53:18 -0700 (PDT)
Message-ID: <95641765-17a4-79aa-1ce3-9cd760ed41f4@flatmax.com>
Date: Wed, 24 Aug 2022 07:53:13 +1000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2] ASoC: codes: src4xxx: Avoid clang
 -Wsometimes-uninitialized in src4xxx_hw_params()
Content-Language: en-AU
To: Nathan Chancellor <nathan@kernel.org>, Liam Girdwood
 <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>, Tom Rix <trix@redhat.com>,
 alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
 llvm@lists.linux.dev, patches@lists.linux.dev,
 kernel test robot <lkp@intel.com>,
 "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
References: <20220823151939.2493697-1-nathan@kernel.org>
From: Matt Flax <flatmax@flatmax.com>
In-Reply-To: <20220823151939.2493697-1-nathan@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

This looks good.

Reviewed-by: Matt Flax <flatmax@flatmax.com>

On 24/8/22 01:19, Nathan Chancellor wrote:
> Clang warns:
>
>    sound/soc/codecs/src4xxx.c:280:3: error: variable 'd' is used uninitialized whenever switch default is taken [-Werror,-Wsometimes-uninitialized]
>                    default:
>                    ^~~~~~~
>    sound/soc/codecs/src4xxx.c:298:59: note: uninitialized use occurs here
>                    ret = regmap_write(src4xxx->regmap, SRC4XXX_RCV_PLL_11, d);
>                                                                            ^
>    sound/soc/codecs/src4xxx.c:223:20: note: initialize the variable 'd' to silence this warning
>            int val, pj, jd, d;
>                              ^
>                              = 0
>    sound/soc/codecs/src4xxx.c:280:3: error: variable 'jd' is used uninitialized whenever switch default is taken [-Werror,-Wsometimes-uninitialized]
>                    default:
>                    ^~~~~~~
>    sound/soc/codecs/src4xxx.c:293:59: note: uninitialized use occurs here
>                    ret = regmap_write(src4xxx->regmap, SRC4XXX_RCV_PLL_10, jd);
>                                                                            ^~
>    sound/soc/codecs/src4xxx.c:223:17: note: initialize the variable 'jd' to silence this warning
>            int val, pj, jd, d;
>                          ^
>                            = 0
>    sound/soc/codecs/src4xxx.c:280:3: error: variable 'pj' is used uninitialized whenever switch default is taken [-Werror,-Wsometimes-uninitialized]
>                    default:
>                    ^~~~~~~
>    sound/soc/codecs/src4xxx.c:288:59: note: uninitialized use occurs here
>                    ret = regmap_write(src4xxx->regmap, SRC4XXX_RCV_PLL_0F, pj);
>                                                                            ^~
>    sound/soc/codecs/src4xxx.c:223:13: note: initialize the variable 'pj' to silence this warning
>            int val, pj, jd, d;
>                      ^
>                        = 0
>    3 errors generated.
>
> The datasheet does not have any default values for these regmap values
> so pick some arbitrary values and print to the user that this is the
> case to silence the warnings.
>
> Link: https://github.com/ClangBuiltLinux/linux/issues/1691
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
> Suggested-by: Matt Flax <flatmax@flatmax.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>
> v1 -> v2: https://lore.kernel.org/20220822183101.1115095-1-nathan@kernel.org/
>
> * Don't return early, just initialize the values to some arbitrary
>    numbers and try to hobble along, as other parts of the chip may be
>    functional.
>
> * Add message and comment to describe this situation.
>
>   sound/soc/codecs/src4xxx.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/sound/soc/codecs/src4xxx.c b/sound/soc/codecs/src4xxx.c
> index a8f143057b41..db4e280dd055 100644
> --- a/sound/soc/codecs/src4xxx.c
> +++ b/sound/soc/codecs/src4xxx.c
> @@ -280,9 +280,14 @@ static int src4xxx_hw_params(struct snd_pcm_substream *substream,
>   		default:
>   			/* don't error out here,
>   			 * other parts of the chip are still functional
> +			 * Dummy initialize variables to avoid
> +			 * -Wsometimes-uninitialized from clang.
>   			 */
>   			dev_info(component->dev,
> -				"Couldn't set the RCV PLL as this master clock rate is unknown\n");
> +				"Couldn't set the RCV PLL as this master clock rate is unknown. Chosen regmap values may not match real world values.\n");
> +			pj = 0x0;
> +			jd = 0xff;
> +			d = 0xff;
>   			break;
>   		}
>   		ret = regmap_write(src4xxx->regmap, SRC4XXX_RCV_PLL_0F, pj);
>
> base-commit: 94f072748337424c9cf92cd018532a34db3a5516
