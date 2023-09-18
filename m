Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC44B266DC
	for <patches@lists.linux.dev>; Mon, 18 Sep 2023 18:10:05 +0000 (UTC)
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-68fbd31d9deso4406788b3a.3
        for <patches@lists.linux.dev>; Mon, 18 Sep 2023 11:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695060605; x=1695665405; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6maznjEXgWDHtf3uPCnCDUhsx4nCL1qmfuNmzcDHoYs=;
        b=bQuyISperzzWOG4ypR4Ke+MiU8Vo8LBpsT+ZQqmz2ZlIz89TPa6GZsk+rsFOC2bzUX
         bu4VX7oyYJ9ISKz3NGOG8a5eacfOX/DXwi2EKk4tGcvqDV6QA5U/P1ETuIIed2b8xzLk
         MXRQkV1Mx74Xx6q8NShdh8FLP/If4yWCu2Deu3vDU0kjNRczZ7AI6sxIp+ABfkJLyu4R
         1ThPPyNYwYDXPacFXGg+9bpHpW5m+weryzSq3sD0RGkc8guYNz+4GcGdCZbKtGY6d3h3
         7QBmHCy1XaH/zmNsPYc5MC7mJwd2G5oLVgVrQtqrTUL/mtv6650aIFbAWvo6kIrcZBUC
         BxOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695060605; x=1695665405;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6maznjEXgWDHtf3uPCnCDUhsx4nCL1qmfuNmzcDHoYs=;
        b=X4rDbNAVv8qQpZdiL2bqlAMYy+vr6HHSxHkZB1HIJ45y2YS7Y1YL4bUWQb/Vu+g09r
         1Lt2KSsAYFUJqfUNOQsg68GJ6OvHZQ/pPVRddMFYisfcbzSQIZM4yG1ry9Tt1fp5cnhz
         8bz8vijEZy9NAS1nJpOIEIby/miAm5tCSBMnOfZe50IDak2MaJvB8Mc6dCBLUeQ/TBKM
         QNAYehgVmFBb7ytHX0kodYkSPOneWRx0JZcOdDaB5c7DGaYi+4D5bSuOXvD3OyHI/qQw
         tkdHr8CDe6/fvq9skb+fQ/iY7yUW5Xsd8dTZUZLx78fYXUAI/CtKJfnHEXO9/l4rATV9
         pZGg==
X-Gm-Message-State: AOJu0Yw2KHs55ia18PerlUy4T9zNg/29zgqAIMtC4BLptJAwuUxSx5Gg
	BwCohnWLq9meSCGKo5QvdJc=
X-Google-Smtp-Source: AGHT+IHPHNj2H2G7P5W1DsuqTkz5X25XRN2Oiv+LRznZx5p1RsnN4Ts0LllmXBFdo/bKA45M5il7uA==
X-Received: by 2002:a05:6a21:a103:b0:154:d3ac:2063 with SMTP id aq3-20020a056a21a10300b00154d3ac2063mr7008057pzc.27.1695060604872;
        Mon, 18 Sep 2023 11:10:04 -0700 (PDT)
Received: from [10.67.49.139] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id c10-20020a62e80a000000b0064fd4a6b306sm7402910pfi.76.2023.09.18.11.10.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Sep 2023 11:10:04 -0700 (PDT)
Message-ID: <936cf5f4-1025-02a8-6bd2-dff755fa9ed7@gmail.com>
Date: Mon, 18 Sep 2023 11:10:02 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.15 000/511] 5.15.132-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20230917191113.831992765@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/17/2023 12:07 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.132 release.
> There are 511 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 19 Sep 2023 19:10:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.132-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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

