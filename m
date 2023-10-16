Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557AF33988
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 18:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EGsI8S/T"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-7742da399a2so345224285a.0
        for <patches@lists.linux.dev>; Mon, 16 Oct 2023 11:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697480329; x=1698085129; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=p0+23Fn6CiP/g+dQfRG8xl52NF86Uz+lwAsDx297zss=;
        b=EGsI8S/To3FFgLTjQ0M/AIeHdW3EoW4v9VlyOP23DWMfwHDcdvqnD4U+/zUWRyeZBI
         G19b+oJjLskCai+4e+gSF2vqqsRCHrypBbX9/kXk25eu6MLxybpS4JdDPZQCPnJn9gMH
         oXhKmyCDAhp76AQUAN8YxuoQuoVTNVbJ/lI2aOAeANBUJd1dJXcxmHRnRNhVQM5tSXcx
         sWK4M6AK8RGLy6ucGHtdj6U+XUy1pXLo046cfLcyk8kUm/XkTfJiypP0oe8dQEZ3ONEt
         d0JZy6N+wNbbuXG4ZznMhHYoeDrSiyPwM0P1aIWxPzr1G8QQzVs522h9l/+pgPE2IoRR
         7Xpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697480329; x=1698085129;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p0+23Fn6CiP/g+dQfRG8xl52NF86Uz+lwAsDx297zss=;
        b=PLLv9dHZNqoYIyewPZjg7hbtyPkOjMVG7TMydgYsgtlfDhQNIeNxO+RTm0/Ul4eyqo
         QbSqGRTcOBkzJ7avrp2CSMyc9v9l+Jt+M5NppoVza71phvujvBnf9RCeOeK5V/I1tyWF
         +yV2lZZm1EqvLYMbT5H7g8MO4pncQsYmakONam48VjElHXx7QghuCclhsPDC1hVsBcP/
         Kl2lue8lPgNZEjz2tGhr11gfNqd70edq85zNbiPqDgUFaRaZELUqEb7w8gh16AF3PQ6A
         om3upnI4rzdcZOiUXRXfpTijJAhug5NGzzFqnq7EafpvdHvtdiRwcwvq6mQy0tL8kMO9
         +PPg==
X-Gm-Message-State: AOJu0YwBUAREmwj0gv//8YOu3XqTCiVeT+0/2ceT0whWr2qZP3wmifPk
	GSGhIfStZkZWyUF5LNgcgco=
X-Google-Smtp-Source: AGHT+IGMWmgLTif/PBalpBzsVrrNEHY9Pqo2S9IsbzUv3tw52i2Vpylh3QS4xSmg+q0NbiuFzKRNqA==
X-Received: by 2002:a05:620a:1359:b0:76d:95bc:7aaa with SMTP id c25-20020a05620a135900b0076d95bc7aaamr33010257qkl.29.1697480329067;
        Mon, 16 Oct 2023 11:18:49 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id dt52-20020a05620a47b400b00767721aebc0sm3202573qkb.32.2023.10.16.11.18.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Oct 2023 11:18:48 -0700 (PDT)
Message-ID: <bc778791-5923-471a-bca3-00320ac67428@gmail.com>
Date: Mon, 16 Oct 2023 11:18:43 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/131] 6.1.59-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20231016084000.050926073@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231016084000.050926073@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/16/23 01:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.59 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Oct 2023 08:39:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.59-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

