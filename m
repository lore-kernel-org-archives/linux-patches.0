Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB857B
	for <patches@lists.linux.dev>; Sat, 11 Mar 2023 19:04:26 +0000 (UTC)
Received: by mail-qt1-f180.google.com with SMTP id r5so9374256qtp.4
        for <patches@lists.linux.dev>; Sat, 11 Mar 2023 11:04:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678561465;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qE0OcNZaMEXby/ysblshEvseorXKx079Qg+DU1Nr8zQ=;
        b=keJUH41NJmmu8PGPmrslVCBBRyiiDrTtdCiJsKMtY9lalrOtdptUgDKdhFtmoTWjca
         MTkslRZRCjbv5JjeQKvv9NMxsMfkX8RpH7uCAIoOUQSmlJEyUAGLj0mxBTSy+NszNG/R
         955GcGS1uAeStSnlztgwpiojqL3x+ERifENXdo+PkKkCkLnsAbxxzzjfExi/cDr+CSOz
         CzC2r60I7zyImGyoPzcMBsxN0QbgZpWeQxMuEfdNWTXW7NFKuKKn8EYPw0pNitu1SAZR
         NOAJ1lQ6/SIw061axTq1zRrIxbeoihBed/MEA+RKQsVgxPmfjqvNTdQz7QFXCDe0bwYW
         xK2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678561465;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qE0OcNZaMEXby/ysblshEvseorXKx079Qg+DU1Nr8zQ=;
        b=awG9CG0f1RtMpwIA24WBCVdPlW5wmXYSlPdd6e65PsLJxBbkY5dCo7jzXQrpAAc6Zv
         kyks6tOZf9AOzH/Kd8pFIVX0HwzCM4Xru12TxfEEmMw6YqLY/i6Llyozlh2Tb6/TWlfK
         8Idhsjr2DvNwVETBXCBr/Q07krOUF1FUWC0uGUK8di+VFIGBB0tstfxwuogiJfAgUCSd
         vT/jDq3upuOzs0Mk8goR+us5/ft3Xtv+/ygVLIYrJNcFLh435zYffFfG6XPHqUqDu5/X
         JUcd1LTtMU5KKATYUAoDlf4IZ/gSumtjCa0ZCo0fSL+NLWiSGnPmlIgaC7zpUTeG8Ugi
         bkaQ==
X-Gm-Message-State: AO0yUKX26QU19dqPSYrSZ7hYKRVnzAoBdsWhRGbFazfg7zHXz8mgW0Pk
	2ZhJIBjCUx6NNkFi0bqTG3s=
X-Google-Smtp-Source: AK7set/d4L7vjLFMlOnUEbiUnoegZg98ozf+vnvbAnAV3hai2jR2SkkuiB58i1WP/wWrtAOtO3uEgw==
X-Received: by 2002:ac8:5e0c:0:b0:3bf:b1d6:359e with SMTP id h12-20020ac85e0c000000b003bfb1d6359emr17101800qtx.7.1678561465525;
        Sat, 11 Mar 2023 11:04:25 -0800 (PST)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id y12-20020ac8524c000000b003b643951117sm2310575qtn.38.2023.03.11.11.04.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Mar 2023 11:04:25 -0800 (PST)
Message-ID: <dd822d2d-2a17-57ac-8fb2-b572d2be5296@gmail.com>
Date: Sat, 11 Mar 2023 11:04:22 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 5.4 000/356] 5.4.235-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230311091806.500513126@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230311091806.500513126@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/11/2023 1:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.235 release.
> There are 356 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 13 Mar 2023 09:17:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.235-rc2.gz
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
