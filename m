Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D52DC28E2
	for <patches@lists.linux.dev>; Tue, 23 Aug 2022 21:32:25 +0000 (UTC)
Received: by mail-pj1-f49.google.com with SMTP id r14-20020a17090a4dce00b001faa76931beso18483002pjl.1
        for <patches@lists.linux.dev>; Tue, 23 Aug 2022 14:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flatmax-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=9Tyv/HjGt+kTjHUdJpqzUz7hlqhqn6nz07i1wBSdcbE=;
        b=JJpoekHIwEOPtlFjvUifgeyZ4xG06w29FzXSUvKRjB4FUkO7GrtmJZQFl3D/OQKJiD
         eM8aqGg+O7ONgMqFzDMWoPgMsMA26qqrI8PKcABs+EXPRkdMVA9n2oqlKGjU7qRRgXGO
         YEhnhWEPA8IoVaiiQ9rJjdDMARUcfZWX1P6c5OAeF9Mpt74wEkftvT9AwsP+yPw0oQ2k
         2vBigX/9W+ZVwjkfLTYFYuFm8+T74lB5A64oObWHz4ZSKvb7fRezV93OonDPOtVdBBQd
         0eWL6sN10RkE5UyK2hQMDB2aLSo3c1jMqVzqEct+zpzfrswUhYiksW3nXHbJFjL576JC
         KxTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=9Tyv/HjGt+kTjHUdJpqzUz7hlqhqn6nz07i1wBSdcbE=;
        b=vGWO+G0F4V4S3YPnVTDb4OikPUyfHb8AAfFoxk1HZAGd1hZPEeY2Yf+rrI3W6iz3+X
         TTcVCD+ARIMDueyavHUUi10KewuClaSfX9k6XM+WGEkKi5dCT5Um8Wzemw/EeimkGnoz
         NUqgL7OzXCnGSub09NxpUn5T1U+Yvvc0ck/dwt2Qm+3piilPvcnaxCSRhRDHAB9R8k0Y
         VFml/y+5ONuUfa4AwG9pA93mOgUkxeNDcHoS7aoZZSP48tEMc75RjC3P+ed0zeCA0z7s
         Cl3yO4e4ikEJLEl0v+8KVEL0L/UOp/8Ki9s8mEOx66XgA517nh4i2FLFRxXydTKtzxWW
         N+3g==
X-Gm-Message-State: ACgBeo3bZ7wnJFBHrkgooklMwYUOgKCqB5n4kHtuK1Efl+vOlOwSMoKH
	nJE9OCTTUcTns/f7WI0DQtxoDA==
X-Google-Smtp-Source: AA6agR7aPxzoh7iUSiuk4HHIHeu/lkhIEPudRf53d8nKUbpXo0mZZmRJu+VQtJVnVAPQNEFyYH+yEQ==
X-Received: by 2002:a17:90a:6001:b0:1fa:e851:3480 with SMTP id y1-20020a17090a600100b001fae8513480mr5098001pji.153.1661290345218;
        Tue, 23 Aug 2022 14:32:25 -0700 (PDT)
Received: from ?IPV6:2406:3400:213:70c0:5c76:4280:5b6b:9ce0? ([2406:3400:213:70c0:5c76:4280:5b6b:9ce0])
        by smtp.gmail.com with ESMTPSA id i62-20020a626d41000000b0052d27ccea39sm11712035pfc.19.2022.08.23.14.32.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Aug 2022 14:32:24 -0700 (PDT)
Message-ID: <38754fa6-5d1f-ed9b-9c31-7a443c968cad@flatmax.com>
Date: Wed, 24 Aug 2022 07:32:18 +1000
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

This patch looks good.

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
