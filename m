Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A21052115
	for <patches@lists.linux.dev>; Thu, 17 Aug 2023 07:29:37 +0000 (UTC)
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-977e0fbd742so954529066b.2
        for <patches@lists.linux.dev>; Thu, 17 Aug 2023 00:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1692257375; x=1692862175;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nOJ+d25pMjeuQsrRl8LvKNCwqzu1i3KiQKGQ/abbmGA=;
        b=KHj9kJxlgGzVh8YlTYqULol7noxuqcEEcRtHkRtx+Fez3IN4tdPcTOd4uAwoWcjOm2
         wx/gb0HmirUR7xQNg1BoAMGzptwS9RajJE2aqt2m7Mv4ohDtzoDkiMCGUKgTqsfCmYcd
         o6r6E8hwTlTxafe/gRnUINHfMP4io0J1QaN1hPz5zWA49LF9zF1eOO85ey37B7cgU1v0
         XJfrhnbCUJjsDsxJz+OqA0PPEkyoUw44iHpq5mqZrp1NzvpKxd7/eRrBIm+O5EAaGtA2
         9PK/iqhhd2pjMfZUJxeeEVwCtLM99SANz5kb9wUoq74jkPPJjtTuNpPGI7yZcKFZhd7v
         BfIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692257375; x=1692862175;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nOJ+d25pMjeuQsrRl8LvKNCwqzu1i3KiQKGQ/abbmGA=;
        b=FLoYinvwOoBg5sXUTSo9ClnlXsXrUJ9RIho0cmWVqQv1M5TLaP/CeGULCXZpoFn9BS
         4oBjhMK7Ub6CmU93MWgSIZLN8NkYriS4Feo8WebMyhLKTT4KfT0SiBEj8HHyJVO80YEK
         2o7dlTlj2se4xDaZhztsYqeQnPugu9DjJHQpPIWSpIbV0R5UporBlMtdHbhbv+m67Xfj
         gv8KOAjceBH/WX3HnspFLt4qgwyuKbdDslF/QN3qed9Y7y3iq9EFt9Kn2CrKI3JUT0Cn
         /WX9vBlSD+6jd4aVpe0kOK3fo8mQ6mukZKvdl6nE1DRpqxWKNdgiZjQxlc10A7U/6IMS
         ampw==
X-Gm-Message-State: AOJu0Yx10nyznX/nrgcoxKRj/Njf9rPe7HUfAt1bINdBoPZmGKwH9pom
	e2pYLgmWOMINP7j3yH8FWLujBA==
X-Google-Smtp-Source: AGHT+IHoUseg7XR3xqv75cPWee71BqJRxVL4itNOrzkR/G51AqPMAF8h4xpYk+qJQcN4YtUyDsqbng==
X-Received: by 2002:a17:906:3110:b0:99c:55c0:acfd with SMTP id 16-20020a170906311000b0099c55c0acfdmr3022293ejx.62.1692257375687;
        Thu, 17 Aug 2023 00:29:35 -0700 (PDT)
Received: from [192.168.69.115] (mek33-h02-176-184-23-56.dsl.sta.abo.bbox.fr. [176.184.23.56])
        by smtp.gmail.com with ESMTPSA id jw13-20020a17090776ad00b0099275c59bc9sm9724407ejc.33.2023.08.17.00.29.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Aug 2023 00:29:35 -0700 (PDT)
Message-ID: <405d395f-b817-f31b-041f-823d6167e2c2@linaro.org>
Date: Thu, 17 Aug 2023 09:29:32 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.14.0
Subject: Re: [PATCH] MIPS: VDSO: Conditionally export __vdso_gettimeofday()
Content-Language: en-US
To: Nathan Chancellor <nathan@kernel.org>, tsbogend@alpha.franken.de
Cc: linux-mips@vger.kernel.org, llvm@lists.linux.dev,
 patches@lists.linux.dev, kernel test robot <lkp@intel.com>
References: <20230816-mips-vdso-cond-export-__vdso_gettimeofday-v1-1-fe725254c782@kernel.org>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230816-mips-vdso-cond-export-__vdso_gettimeofday-v1-1-fe725254c782@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Nathan,

On 16/8/23 23:59, Nathan Chancellor wrote:
> ld.lld 16.0.0 and newer defaults to '--no-undefined-version', which
> causes the following error when CONFIG_MIPS_CLOCK_VSYSCALL is not set:
> 
>    ld.lld: error: version script assignment of 'LINUX_2.6' to symbol '__vdso_gettimeofday' failed: symbol not defined
> 
> Only export __vdso_gettimeofday() when it will be present in the final
> object file, which clears up the error.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202308170532.zxFFv25c-lkp@intel.com/
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>   arch/mips/vdso/vdso.lds.S | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/arch/mips/vdso/vdso.lds.S b/arch/mips/vdso/vdso.lds.S
> index d90b65724d78..836465e3bcb8 100644
> --- a/arch/mips/vdso/vdso.lds.S
> +++ b/arch/mips/vdso/vdso.lds.S
> @@ -94,7 +94,9 @@ VERSION
>   #ifndef CONFIG_MIPS_DISABLE_VDSO
>   	global:
>   		__vdso_clock_gettime;
> +#ifdef CONFIG_MIPS_CLOCK_VSYSCALL
>   		__vdso_gettimeofday;
> +#endif

Possibly:
Fixes: 7d2aa4bb90f5 ("mips: Fix gettimeofday() in the vdso library")

Otherwise,
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

Thanks,

Phil.
