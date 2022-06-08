Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9D3320A;
	Wed,  8 Jun 2022 17:13:07 +0000 (UTC)
Received: by mail-wr1-f44.google.com with SMTP id k19so29193052wrd.8;
        Wed, 08 Jun 2022 10:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=v+GRs44ZAaCp+LmoA0Cy0UHC9B5TNPhLzc4XBlKlRTo=;
        b=hD81EXZWqyx/co7W/gf5GnU9GUtXPEgMAioMsT+GWekm+tuav8KGKCdXziFPvH04/6
         9Xu6DxyqjAF6hPIBZwu0EceEN4x3pASI87/zXb8nQd2YshEUp+eeJ7kz6FyJKAUs0iDb
         MWjIW2CKumSxIj53VjH4e35KJ86gPUUQC7JlXXfyDfBz1rto663/xVAR7BmWYi9hw3NY
         Oq1Wcn7Lnuq1e1sx80VkHjscYbJD91L0WcoDOTdzFhrretv3w6o4vrlssMzaCiw54GPp
         DKP7qDgxrAzl+rEthXs9qYFpt03+KCUR3ixggR9S9/qYBoAzc1dQ+c8Jgifa5niLyhzT
         3OHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=v+GRs44ZAaCp+LmoA0Cy0UHC9B5TNPhLzc4XBlKlRTo=;
        b=Fj+XUUTWzuElI5OxMGY2B1BFuOQ6ZO13IT/gjNlKStwkRRiBg241chiRnTD8eRCW5M
         7tH2qKTlpOvWF7TS80gIu/aeax05KRAXNkYH3HiyLPIQ01ShSRBEf2Vn3/VErdlXSNvJ
         ojt6S4jhy+MBQB5bLocT9YkWZZW0rwkRjbW8i/JjA0tgYntdgkHPcE9g7igiYK3MN8Fc
         sEe1432xEcXpAcIirY2GkvKpOLepTPYbjtI68Pf7ohiPenZIuTIhYv/pAn4pEwvg0PN0
         zj+fTEfd+3GYWJetRY07hFxAsxNCWLafDB8Q2PbYCGcb2MtAUpzQpqCIXvDvqYiRTiPW
         Xqcw==
X-Gm-Message-State: AOAM531gF8ViGLuYemUGywtZGUBRqFTpfIOviSZBPEyu5ca1dK9hjr2y
	tHxqxmUu8uBjpqdEFKqIQm0=
X-Google-Smtp-Source: ABdhPJwkgF72nHBSu7q9qGTg8h+atXBju2MmrOTs/inNaJwRb7OsEfkkDX6uot0cngO8WakstveCDw==
X-Received: by 2002:adf:b644:0:b0:210:1fde:a513 with SMTP id i4-20020adfb644000000b002101fdea513mr36197690wre.604.1654708385227;
        Wed, 08 Jun 2022 10:13:05 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:58e:6120:8c0d:a21d:4424:54a3? ([2a01:e0a:58e:6120:8c0d:a21d:4424:54a3])
        by smtp.gmail.com with ESMTPSA id m9-20020a05600c4f4900b003973435c517sm23631084wmq.0.2022.06.08.10.13.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jun 2022 10:13:04 -0700 (PDT)
Message-ID: <51542057-4b25-7897-b2a0-d5027af869ea@gmail.com>
Date: Wed, 8 Jun 2022 19:13:01 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] mmc: sdhci-brcmstb: Initialize base_clk to NULL in
 sdhci_brcmstb_probe()
Content-Language: en-US
To: Nathan Chancellor <nathan@kernel.org>,
 Adrian Hunter <adrian.hunter@intel.com>, Al Cooper <alcooperx@gmail.com>,
 Ulf Hansson <ulf.hansson@linaro.org>, Kamal Dasu <kdasu.kdev@gmail.com>,
 Florian Fainelli <f.fainelli@gmail.com>
Cc: bcm-kernel-feedback-list@broadcom.com,
 Nick Desaulniers <ndesaulniers@google.com>, Tom Rix <trix@redhat.com>,
 Justin Stitt <jstitt007@gmail.com>, Dan Carpenter
 <dan.carpenter@oracle.com>, linux-mmc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, llvm@lists.linux.dev,
 patches@lists.linux.dev, kernel test robot <lkp@intel.com>
References: <20220608152757.82529-1-nathan@kernel.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220608152757.82529-1-nathan@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/8/2022 5:27 PM, Nathan Chancellor wrote:
> Clang warns a few times along the lines of:
> 
>    drivers/mmc/host/sdhci-brcmstb.c:302:6: warning: variable 'base_clk' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
>            if (res)
>                ^~~
>    drivers/mmc/host/sdhci-brcmstb.c:376:24: note: uninitialized use occurs here
>            clk_disable_unprepare(base_clk);
>                                  ^~~~~~~~
> 
> base_clk is used in the error path before it is initialized. Initialize
> it to NULL, as clk_disable_unprepare() calls clk_disable() and
> clk_unprepare(), which both handle NULL pointers gracefully.
> 
> Fixes: 2cecaac1b21c ("mmc: sdhci-brcmstb: Add ability to increase max clock rate for 72116b0")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1650
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
