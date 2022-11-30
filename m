Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26FFD23AF
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 12:23:17 +0000 (UTC)
Received: by mail-wr1-f53.google.com with SMTP id h11so19530115wrw.13
        for <patches@lists.linux.dev>; Wed, 30 Nov 2022 04:23:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YmOlYL+T1VcRv6GwjlbPVapzopZmzHsyfLnHJwg422g=;
        b=QCk0NxAgMjKoO4MZ8ZHi9965Dj+VVNgu8hf2o4ri7t0luu+dp/7ZqfpCMg1OtndLa9
         /n4esAFm2evvBeQ2rIcbRj3N2/ZbfyB9snQK4VMcjf6v2MWVXu/FqZ8K6KIE5vaX92i2
         SAWV+NFe1eeM5IwhUUSserYBOPfFirV/797GOGfnuiVVbdfptXSlH9/imQGR1pcm/B9n
         ahUhWS1wsi43AApK+CvetjVznIv7HLh1bMjbpmHwGu/MAXT8MUZiHbhePwqr5NOllh9T
         frJVR85URP7gEJpwCbppmqhwU8sszJ7UfRhZ/yG17wvAln9AHw4AyUdwYcHaFUent4Rv
         l78w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YmOlYL+T1VcRv6GwjlbPVapzopZmzHsyfLnHJwg422g=;
        b=Vi2vW/JYLTNRPHEbZbDLEVILKV+L6nPgFn6hLvtnvKrQmXZBMQE2Yq/zzu5DhEdL5n
         J8GwhTfmMbKR1A8y4tRrHCvA8SZLH3P9gkzViNWxVOGo9ypzpC1+5Ll2cDKnB/Xlpjzz
         DK8QICRUvPrLf8V2fcKUMO7GDtI5YCfMTr8kTgct4IOYv3jjaQT3zxgmS6icp3ICpOyJ
         E3FXAnudA+IfWRl6RaMiV3HqZUvRdftdyfdBS108pEqaQh27A3THCUBty2yB2DHLGivH
         P4NIes7/eXOkyLVWyJbIRhl8MGHL6gB2u9m2H6o9sgxlKxT7zCn6C1egVMjQSX9ADrcr
         OkfQ==
X-Gm-Message-State: ANoB5pnIIsrzes4Mfaw0k2JoAgzgFPGgAfxMzxiqXtF7N6MIX4FAnJZi
	KWgSx+6d7byW2Ya1j6uPDYh1kw==
X-Google-Smtp-Source: AA0mqf50/mjoaNarDfeLyTKta3nb6bZmEZM+IvrC04UJESisouehFNwB7mVWUMM2IcSOwllHF4y3Ag==
X-Received: by 2002:a5d:456c:0:b0:236:7135:24da with SMTP id a12-20020a5d456c000000b00236713524damr37935677wrc.264.1669810995282;
        Wed, 30 Nov 2022 04:23:15 -0800 (PST)
Received: from google.com (65.0.187.35.bc.googleusercontent.com. [35.187.0.65])
        by smtp.gmail.com with ESMTPSA id o35-20020a05600c512300b003a3442f1229sm5986073wms.29.2022.11.30.04.23.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 04:23:14 -0800 (PST)
Date: Wed, 30 Nov 2022 12:23:10 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>, Nicolas Schier <nicolas@fjasle.eu>,
	Sami Tolvanen <samitolvanen@google.com>,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH 2/2] modpost: Include '.text.*' in TEXT_SECTIONS
Message-ID: <Y4dLLnc4LTX9UHaN@google.com>
References: <20221129190123.872394-1-nathan@kernel.org>
 <20221129190123.872394-3-nathan@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129190123.872394-3-nathan@kernel.org>

On Tue, Nov 29, 2022 at 12:01:23PM -0700, Nathan Chancellor wrote:
> Commit 6c730bfc894f ("modpost: handle -ffunction-sections") added
> ".text.*" to the OTHER_TEXT_SECTIONS macro to fix certain section
> mismatch warnings. Unfortunately, this makes it impossible for modpost
> to warn about section mismatchs with LTO, which implies
> '-ffunction-sections', as all functions are put in their own
> '.text.<func_name>' sections, which may still reference functions in
> sections they are not supposed to, such as __init.
> 
> Fix this by moving ".text.*" into TEXT_SECTIONS, so that configurations
> with '-ffunction-sections' will see warnings about mismatched sections.
> 
> Link: https://lore.kernel.org/Y39kI3MOtVI5BAnV@google.com/
> Reported-by: Vincent Donnefort <vdonnefort@google.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Thanks!

Tested-by: Vincent Donnefort <vdonnefort@google.com>

> ---
>  scripts/mod/modpost.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
> index 2c80da0220c3..c861beabc128 100644
> --- a/scripts/mod/modpost.c
> +++ b/scripts/mod/modpost.c
> @@ -823,10 +823,10 @@ static void check_section(const char *modname, struct elf_info *elf,
>  #define ALL_EXIT_SECTIONS EXIT_SECTIONS, ALL_XXXEXIT_SECTIONS
>  
>  #define DATA_SECTIONS ".data", ".data.rel"
> -#define TEXT_SECTIONS ".text", ".text.unlikely", ".sched.text", \
> +#define TEXT_SECTIONS ".text", ".text.*", ".sched.text", \
>  		".kprobes.text", ".cpuidle.text", ".noinstr.text"
>  #define OTHER_TEXT_SECTIONS ".ref.text", ".head.text", ".spinlock.text", \
> -		".fixup", ".entry.text", ".exception.text", ".text.*", \
> +		".fixup", ".entry.text", ".exception.text", \
>  		".coldtext", ".softirqentry.text"
>  
>  #define INIT_SECTIONS      ".init.*"
> -- 
> 2.38.1
> 
