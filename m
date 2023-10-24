Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3CE4374D6
	for <patches@lists.linux.dev>; Tue, 24 Oct 2023 15:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m6QbsNdz"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-41b7fd8f458so28796801cf.0
        for <patches@lists.linux.dev>; Tue, 24 Oct 2023 08:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698163008; x=1698767808; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G3iJ9n4kZf5Fmlt/Zj0lshvC/7uIWRd7BIbE6REwALk=;
        b=m6QbsNdzjhmOpegH0dqugkGzYTLjOA5xRNKB9yA3dw+soFkIAl4/u8LQr7IVxsE+xb
         7rp02hXS6e1Dol8Rckx1ganmzi8oALW9XQO9LBtGkT/arUQiJwCooK1rRueJQVth/uaL
         boZW4zYlkaY/LUXJFNQiBL75oZBBEDmO56DAILVr2AqnbXZX9rMctdh5WOeStnFYLBLV
         w3hlTnyCE/DTlIsUv07giV1tgzIJ35uy1KGeRDMjAdXex5AXhycydAmw0tKeQhQIRJgP
         WV1xPUPjj5Vn+5kvQ4PGI4TCP7UAAs1MfunoEw/cjll4VUTcqPpl+yfecvFbC2kSFxJh
         TwPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698163008; x=1698767808;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G3iJ9n4kZf5Fmlt/Zj0lshvC/7uIWRd7BIbE6REwALk=;
        b=NKcuLKw02KydwcBvbI4sk0pFab09l22Bow2PoxmmsLXh9WDvZZxnsvtfXL3i2TLqnC
         x+De79WF5gFrn/RDmWnnHdFAOovVP83zPokZgNpHSvJozy/kkXv4JRhf5dDdwTY9wHmc
         Dp1Rnn0hkqcIEmwRszUQI+2XRg2L62NYPC/DLxHo7dxF7EHkRcI+A/sXEFT2IH/wy7nw
         5QUjbWsOzTo8DbUVJZjnQ+uNj7tzIGFSDrFNdwWW5scMkVouYR+v5DaZIv47YH+L1hBy
         cljFxQxCB+9yiZvU5bu8Lr1DycWR5c/XaSW5kHJQAQ1n1xDepdn/VHaq3b2vCoS7qlb9
         cAMA==
X-Gm-Message-State: AOJu0Yyu9gtUAF6+JCr9Zn1Gppoy2XQofYYkXwWJc3buJxWbXlVQMBfB
	ZgdUnI0hyfiYT/zoAQezJek=
X-Google-Smtp-Source: AGHT+IE1iGEuWcd/WUNh3/SL+ti517dmHtLT8RqAVaypZK3yGF8nikkVyL6c5agsMBer204IRfPWFA==
X-Received: by 2002:ac8:5e08:0:b0:418:1084:1f4 with SMTP id h8-20020ac85e08000000b00418108401f4mr14267795qtx.48.1698163008461;
        Tue, 24 Oct 2023 08:56:48 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id q8-20020ac84508000000b004198d026be6sm3582416qtn.35.2023.10.24.08.56.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Oct 2023 08:56:47 -0700 (PDT)
Message-ID: <5b5a223b-b5bf-49f1-8259-3dbedf1dafb7@gmail.com>
Date: Tue, 24 Oct 2023 08:56:44 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/199] 5.10.199-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20231024083326.219645073@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231024083326.219645073@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/24/23 01:36, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.199 release.
> There are 199 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 26 Oct 2023 08:32:45 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.199-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

