Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACCD14C66
	for <patches@lists.linux.dev>; Mon, 22 Aug 2022 22:00:15 +0000 (UTC)
Received: by mail-pg1-f178.google.com with SMTP id s206so10616350pgs.3
        for <patches@lists.linux.dev>; Mon, 22 Aug 2022 15:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flatmax-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=k7QztPNY6f5UPLhFzQe/bCAaGoEOsA+9S8peUjdBlTk=;
        b=c/WEgMnCXQKbLNgvEBP8td0Sx3mSDaOuW5vJixarP5cB4HVOlwXWV7YHZNlHV6wKk1
         qap2wSHRjwj8hGabgU8iqHb7uEBpz7J82eh8P6R8Q1qRSFYIFU8aQh+1WW2j8FwiMA3A
         HQfQDT4JHh7UiHHwrVjOG6IWx19Lv7rlRPKMS3Ua4lKhD8k7mBr5pcCrF7p17wcUTG9U
         W+PsUGz0g8Sj+XTMw6EZr72lPcqggh+SUb1apuwoYAQRl6FQ+hcYt1MN/4QzCsc/B9vI
         SuTwVo2Ev6dG9sTc5hD2uIrrYKMKwf1qnd/Ihd7R5viPBb1A9MVu6SEVEoSw5IygzRXp
         IXBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=k7QztPNY6f5UPLhFzQe/bCAaGoEOsA+9S8peUjdBlTk=;
        b=fYZ7qlYLy//RuaVUjnTOPJFJF8Ohfmfoug/4DrP3ysFd7WwlHbIbJSQWP8+FZSeIMk
         kTCE47WctUrcCfqYBl4AvnGlBdxhYbVv9WdJ6w3yStujZpTE69Rye04qIR5xvyTL/u0g
         /yS8Zk9K4enWJL6If/rLaeInetVM4QHZWHfPl8SHxlHFAAASOA5KFAHJU75SLtCHlajd
         0enl2stDEOm0wKgyDG/aWmCI+ZvC08DU6Uu7wm/QEmB0pldgtaWKGtxkGD0bLcGzP1fY
         iVuOAODO6Wc+suNZAsByky7QbVgzqSwdlB1HR0yBuAoNcHsBKElQ7zjVX+1mbJnKOqEw
         Ybag==
X-Gm-Message-State: ACgBeo1Sa9lxmhhWU9M7k8czT/LMnkO/XHOz2cIM7EQNoC1+t84ueWBt
	WyvvIvqKQLdyEG88J1V4t5z4zQ==
X-Google-Smtp-Source: AA6agR6duxF3m0MIusH+8dSELwpye5RmZc+z35IyCWoipxGYYNLN70/tfTT/CqoBOD/cFCtjYZ5d9A==
X-Received: by 2002:a05:6a00:2486:b0:536:777b:6a64 with SMTP id c6-20020a056a00248600b00536777b6a64mr9649685pfv.65.1661205614943;
        Mon, 22 Aug 2022 15:00:14 -0700 (PDT)
Received: from ?IPV6:2406:3400:213:70c0:73b4:2cc5:1ada:53cd? ([2406:3400:213:70c0:73b4:2cc5:1ada:53cd])
        by smtp.gmail.com with ESMTPSA id o12-20020a170902bccc00b0016db7f49cc2sm8817503pls.115.2022.08.22.15.00.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Aug 2022 15:00:14 -0700 (PDT)
Message-ID: <72de09df-5dee-8bd0-5c91-359e4bc36ca8@flatmax.com>
Date: Tue, 23 Aug 2022 08:00:07 +1000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] ASoC: codes: src4xxx: Avoid clang
 -Wsometimes-uninitialized in src4xxx_hw_params()
Content-Language: en-AU
To: Nathan Chancellor <nathan@kernel.org>, Liam Girdwood
 <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>, Tom Rix <trix@redhat.com>,
 alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
 llvm@lists.linux.dev, patches@lists.linux.dev,
 kernel test robot <lkp@intel.com>,
 "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
References: <20220822183101.1115095-1-nathan@kernel.org>
From: Matt Flax <flatmax@flatmax.com>
In-Reply-To: <20220822183101.1115095-1-nathan@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Nathan,

On 23/8/22 04:31, Nathan Chancellor wrote:
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


If you really want to get rid of these warnings, you can use this 
default for the variables :

pj = 0x0;
jd=0xff;

d = 0xff;

It doesn't really make sense why we would choose to initialise these 
variables, but if you want to silence the preprocessor, then perhaps 
those values. Put a message that defaults are not known nor specified in 
the data sheet and these values are chosen to be unlikely matches of 
real world values - which ensures regmap updates later from an initial 
unknown chip state after refresh. All a bit messy really.


> According to the comment in the default case, other parts of the chip
> are still functional without these values so just return 0 in the
> default case to avoid using these variables uninitialized.
>
> Link: https://github.com/ClangBuiltLinux/linux/issues/1691
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>   sound/soc/codecs/src4xxx.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/sound/soc/codecs/src4xxx.c b/sound/soc/codecs/src4xxx.c
> index a8f143057b41..cf45caa4bf7f 100644
> --- a/sound/soc/codecs/src4xxx.c
> +++ b/sound/soc/codecs/src4xxx.c
> @@ -283,7 +283,7 @@ static int src4xxx_hw_params(struct snd_pcm_substream *substream,
>   			 */
>   			dev_info(component->dev,
>   				"Couldn't set the RCV PLL as this master clock rate is unknown\n");
> -			break;
> +			return 0;


Don't return here, the rest of the chip is still functional and probably 
in use. Print the dev_info and continue.



