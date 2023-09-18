Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A7F21110
	for <patches@lists.linux.dev>; Mon, 18 Sep 2023 19:13:57 +0000 (UTC)
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-68fc9a4ebe9so4446268b3a.2
        for <patches@lists.linux.dev>; Mon, 18 Sep 2023 12:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695064437; x=1695669237; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dBgll0vV+9Vhff8vKZmdxvYEuk870/D/EdkI0S+iCj4=;
        b=Xd3OSIQXiYpCJLEKy0BraRmJpLUKIXkdXd3XWQiFPQ6pV+U518sWYk31Z1uA7eC4cz
         PgpgDzsC4pa9KIZy//Yqml6wv4L8WC3wVnHXAm+pOgfYRJ/jcXtLAY9IZn2H33KM/+hY
         V9TtndMYoA4/KallWtTS58stVE56tuiH2QoD1hfdJoGmSCImmOTBQlFLqdheZQ8B43fF
         wLH4rGfw6Tb63W4z7um5f4SmSr7NExK+cewYT9nKAkGDDs7HoemtYYf7G4VpheuuU/ch
         NE24T+/euWj79yNffq+PCKSqyssUq0ziwvLsTEgsEZir6tTFakhs+KBEo6shzmNIbFJB
         8sGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695064437; x=1695669237;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dBgll0vV+9Vhff8vKZmdxvYEuk870/D/EdkI0S+iCj4=;
        b=ksAL0UWLnbNnVJIT9ViZ0m2lGxyRFXDJ4rPn8UdOhMcUbOvyOB+eHai+8uP1hWuOEj
         ScdZMfbm8ZZAkrVfbdbT7C/7nIClAPoiSguDiOwCTWPgM9p76NAKwDimLLhXwoe7dA6f
         wqycc8Tviuk4V0XH9IA4vY8h41iIBW/1BryJcomWERsC1pn/JUOLukWvm/NSTitOfrF8
         4GSaCs1AwDQb9vGeH1/HbYsm3rdxWMYLdp6AWMu8C5bvzKvzeRwmiHldIOmOeWJr2vzI
         ZH0dTvM2IMJHBXwbPvEtxFXEuBf6WNyVf1TZ7sJ4hhzZEnFtKEQfQ9D5kTSFhP36+LAv
         1jWw==
X-Gm-Message-State: AOJu0YxStW2mMK2ujiKoimbvSVxP2AniAeDH9dgDEh+YvnTPNv0h4uU2
	Kq3PZ7jdn/zzwXKjCEto+Jk=
X-Google-Smtp-Source: AGHT+IEtPQ2gcwZwvuxi1RJu0eheIDLvUbluLfxgaER7RLlWeuh5FuziT2DXJl1qR/5NlGU6wAT+sA==
X-Received: by 2002:a05:6a00:18a5:b0:68e:2d9d:b0cc with SMTP id x37-20020a056a0018a500b0068e2d9db0ccmr13002251pfh.6.1695064437259;
        Mon, 18 Sep 2023 12:13:57 -0700 (PDT)
Received: from [10.67.49.139] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id de11-20020a056a00468b00b00686236718d8sm334088pfb.41.2023.09.18.12.13.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Sep 2023 12:13:56 -0700 (PDT)
Message-ID: <ce0230eb-8bd4-a587-c034-f390337d8b3c@gmail.com>
Date: Mon, 18 Sep 2023 12:13:54 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.5 000/285] 6.5.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20230917191051.639202302@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/17/2023 12:10 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.4 release.
> There are 285 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 19 Sep 2023 19:10:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

