Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821EE1FB8
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 22:30:30 +0000 (UTC)
Received: by mail-qt1-f175.google.com with SMTP id i20so3763676qtw.9
        for <patches@lists.linux.dev>; Mon, 12 Dec 2022 14:30:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wn7Ol+Nii+KRvjkJs021zJvmcVilYQbtbdjjj+CM3ls=;
        b=HW4KILHHyHX00+spPmp5NLS15WYIJza6zKV2kWfOIGTwOvPNWxchBNEMHUEgLI+Lvy
         lS0F4r8OfIx797KwBP3VGj5pnguA/eVfDcPNGNJPvYGOsow8P2s4EAkRhXA1Pj1BDJ6b
         JC9IveJMHA7RiES+uQ87sAG+9m/yW0seDRpu7x+TKhJtteFpJR6AWNStbKuMQa0Jw8QW
         NhTslBdOWm58I6XAso9ceCcJGuL5EujexdVMtD6aeMfSZRDt+OTSoeb4pdAK6BmSDEM6
         hk/s+/9Dem8bd1FssB3PwYcrQ/QBVjrzlaOAk55FGIdGlBfGZ3jnRQHwmvTBDrI6GVYN
         rGSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wn7Ol+Nii+KRvjkJs021zJvmcVilYQbtbdjjj+CM3ls=;
        b=ahMbtyuBbUCRwYS4nOdhC0K/ZoD6lOub7EDra2XFtV7YkpNxCNrMpG2zor600Ck4zW
         iCcTayNCSRBb7WOLzsaZBQDghBv0ziVY6MDQQjPXCHWE8kagpN0/e/sNqGuEhH3b0lDj
         0rz3Ed5Id4S9HfLcziC0HoIS8jisYFmS94xInDAd9yH95fMu6r9uYY6F3OEGG7ibQ9eE
         32yhG/fe6XVQexHj6vglV4aaKHuezOSlSrIL/tmJNhCWvXgHFN6SsVKkJimBxHH5GuWY
         0rw63+2fGw2Fc+cDfNFe9ox0S0GgDR5xEheBKab9Zq2W2m1nf0nuS+691uUEbwd0uTq+
         9GKA==
X-Gm-Message-State: ANoB5pnZ19rCGv0Q7aW4RUf8JMjXxwoca5/vi08y2ce0782ZcGjJClz7
	zThsV83PjYws61G5HQq10Qc=
X-Google-Smtp-Source: AA0mqf4Q04DmUA95Ihc5nFTAKQA0gcUbMcOVE7u04B2KcMfMSL8jzhiJocguGJ/lwYUEuowW29N4yQ==
X-Received: by 2002:ac8:68d:0:b0:3a5:f445:acf with SMTP id f13-20020ac8068d000000b003a5f4450acfmr27958303qth.67.1670884229338;
        Mon, 12 Dec 2022 14:30:29 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id fu20-20020a05622a5d9400b003a69225c2cdsm6444538qtb.56.2022.12.12.14.30.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 14:30:28 -0800 (PST)
Message-ID: <c6f01794-ee64-eaf7-1beb-74378d981ebf@gmail.com>
Date: Mon, 12 Dec 2022 14:30:20 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.4 00/67] 5.4.227-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221212130917.599345531@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221212130917.599345531@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/12/22 05:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.227 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.227-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

