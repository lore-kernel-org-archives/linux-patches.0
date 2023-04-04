Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245BF28F3
	for <patches@lists.linux.dev>; Tue,  4 Apr 2023 17:21:43 +0000 (UTC)
Received: by mail-pl1-f179.google.com with SMTP id iw3so31977656plb.6
        for <patches@lists.linux.dev>; Tue, 04 Apr 2023 10:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680628902; x=1683220902;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZiBMCUFMw1ZDjB+YrQkeZxAt4DJ2+vedDb0Fa2LgdvQ=;
        b=kGCKFdF1iNrmyIH2cBWz0Q7pkjddKmSppklppuCOY8LbV7b69uEhrel4aS+73Uy+E0
         9LB5IUGOHpJL40tPrbFJs//NQGHzk65YP6fETCejP1/st7X4HqTFMWM9q5f10ALilMuU
         NbTqoqFNC7JvmY4P+uc+O+ivIWaW1DLEyY5pOjNoaZehIgXEw46g51nYiiap7vXO1B/N
         fTmXo9/GYEoNAWhvbm/tkVafIvAY1kIXbEROuibRmmkhQtQKsyQDP8BMdk3fd40vqbYV
         wfNOPHNo0w6qejQr5c3qwFRTvyJxSeeK4XhzZx6sRmU9x25wfrO1DEJGh7Ezve1fb+ih
         9VgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680628902; x=1683220902;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZiBMCUFMw1ZDjB+YrQkeZxAt4DJ2+vedDb0Fa2LgdvQ=;
        b=6qDFs0xLnTMtY0NoC05pDXa9OTRsB3X27zyTsReP0V3YRbHlIIc4FEXM6plTLoY5GX
         zvtOvEugfJCsFxTz23wK4hh6f1jpk07zdhEbfLYXOMN4GnZaZMAin2rj34cWEd6BH888
         gqd3I3xJMzE4RHDB3Eaya4XsKuzdzBs6LFh96+JgEw0OYJpbyQ4k2euYSVhHOcZd1iJj
         +259JXIcf08MN0iPJCrCBBszjv3HRDrYN+ZpxuWW/7qAWHeHLdLwBhHFNN/eDpnH9pw9
         PEnxaEKBtIajQ6QaEtrrcmSlGAEE1uNvf6JItkdOYu0oRqZKxDOlzr4yPXIrFuSaR3EX
         Xdlg==
X-Gm-Message-State: AAQBX9froNYcPsG+hyA1KKJeTdf6KzfFEx12Mjm2J2TayaQZmKGYwRZZ
	7qArmnK1Sdnz1uHGoc335qo=
X-Google-Smtp-Source: AKy350aVMal1RU9eiSmBLW0rJxH/MrWDy+/ZJBHjFSrh5IJ8d5fjaHlNLVfbMVxA5NfnCN2G7OkWZw==
X-Received: by 2002:a17:902:e353:b0:1a0:428b:d8c5 with SMTP id p19-20020a170902e35300b001a0428bd8c5mr2914493plc.45.1680628902448;
        Tue, 04 Apr 2023 10:21:42 -0700 (PDT)
Received: from [10.69.71.131] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g14-20020a1709029f8e00b00198b01b412csm8544231plq.303.2023.04.04.10.21.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 10:21:41 -0700 (PDT)
Message-ID: <052a7a73-ea48-a4ff-f8cb-b30a40ac4b70@gmail.com>
Date: Tue, 4 Apr 2023 10:21:39 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH 5.4 000/104] 5.4.240-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230403140403.549815164@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230403140403.549815164@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/3/2023 7:07 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.240 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.240-rc1.gz
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
