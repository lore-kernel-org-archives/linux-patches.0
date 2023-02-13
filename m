Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07854AD39
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 20:07:09 +0000 (UTC)
Received: by mail-pg1-f175.google.com with SMTP id v3so8875540pgh.4
        for <patches@lists.linux.dev>; Mon, 13 Feb 2023 12:07:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VUlLPxnydlbsCnEsOBCMLuxerluJh+TD51PKhmBbyBo=;
        b=OdYWl6WiWHYOKoRjuhdVdnodyVWZz0PAiTLiPhGC43aYFL1GsfkQCp7SmUQeLTiuPL
         dWF/CODn6Sjj6j6vhRk/XdmR1Cu+sXeNDk6VpU1bQPTxp7PCmKVzcp0jAXcOBnZhD/ab
         E6/asf4JFZYZCDXGWInrYZN3TXgt1J1K4xOei28IzaHfI2dM0ssZ8GmJyoHuLxN8jSTn
         SY+jfBUc/mcB9NGGijeogxYuOX4llnuTQTBz0Vn9g5CS22MY3woA6w+gAN/IWSlDmn8f
         vIrODZd8tUVXfc3l3hpFQv6kvS3UeiJBW7fMip0qQMksSC/mQ/3b/CIDZ0HEcFVK66Q1
         IsuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VUlLPxnydlbsCnEsOBCMLuxerluJh+TD51PKhmBbyBo=;
        b=nG/IYh2BF0P9ieN0SS0T5IjTnpcCKfINHaO4RlWNoTfT2FBij2pWj/Sq0qnx6b6jfr
         Sl5akVOKmxJ1COnUw4HlDxzOVf8s7vtAf4taT8UVAS1DXdr+XKiEcoqmpMcj3AY3qcTv
         8WizhUozjHhk7h6OUre277MZpI9VvqbJjv2A1L5xAbarmc5Ih1kvHk3Rsq/ZnNw0o0yN
         aQYDliVstaCS9lhKgzQQwt63Xrx0KSqSFQUsgBbjLnWCQRdsF1hkWO2+ce1qG8ri41ug
         GadapV/KEqBKyxffBxFugc4+kgirPA0X5ciVmRwfLJnK3+iUp5HGecz6Sbm6H/ebwGtD
         9mvA==
X-Gm-Message-State: AO0yUKW0YbUnyauMIx63q1Zl9TS8p3c67hQQvAGPAON/dEFf5Rwdl1Lb
	tkSSEedO9KD06XUY7yVypqg=
X-Google-Smtp-Source: AK7set/Ih0MR7DO60kpkQvKkq9+m+/wyU3kGHFmz6J/ZGAvvEBVgtlCAEISqcdNJ2oi6JyGFGfs3Xg==
X-Received: by 2002:a05:6a00:5e:b0:5a8:bd95:6575 with SMTP id i30-20020a056a00005e00b005a8bd956575mr3493345pfk.23.1676318829435;
        Mon, 13 Feb 2023 12:07:09 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x27-20020aa793bb000000b005a8b4dcd21asm2739336pff.15.2023.02.13.12.07.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Feb 2023 12:07:08 -0800 (PST)
Message-ID: <b5a8e85a-28a1-f59c-9bdd-377cadd9d11e@gmail.com>
Date: Mon, 13 Feb 2023 12:07:06 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.15 00/67] 5.15.94-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230213144732.336342050@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/13/23 06:48, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.94 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Feb 2023 14:46:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.94-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

