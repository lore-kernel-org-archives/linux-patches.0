Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30512148850
	for <patches@lists.linux.dev>; Tue, 17 Dec 2024 19:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734465359; cv=none; b=dkhT8/qdRTse3xcHsJfN110SKlgP64u4q0XWQsskrZxQmy2UkFzVo1nzbLyvfd0tBxdXONN3hueFtY44JEdPcEYLnsQNaF51LXQIeT2TkBmV3j2j0/YMY3+/pI65F76u5Dc3PRu5JBUeFejIg5D+dVgfLUyvpUwOm4f08nqZg44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734465359; c=relaxed/simple;
	bh=mfgN5rjkEwiGMviwubi6WbdbTkxBvoPUIoTPAPveYMs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TyMjkmrY7KHsCKh+mAujJmS4SNFGyzgY3JijjZ55hpOo4FBw++JtF4UO8pl0+wmiXNQYeqn2bx3cX/eh5hZ7WrZ+fm7LYq8GW5sSO0RwJyrTrf0tfrF8xZysh+59T+kDODd59N9mwE+KqaibqkFiAxBKk/7YxSQzlteFq6PQ8m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WqZax0EL; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WqZax0EL"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2162c0f6a39so563395ad.0
        for <patches@lists.linux.dev>; Tue, 17 Dec 2024 11:55:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734465357; x=1735070157; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=kmfulnuDhPuLBz/whD5WGXWGKZ/jiZ6fTFdiIMT6aqc=;
        b=WqZax0ELx/z/oJcWtzkzR5bF1/HdnRizVh1h6eeUHw2yMUOO2UAA9rvT3U6EN1Ca85
         CIqNixL46BPdM4BnTAvljnVkSqpwIlD9H3IjLveFxwlokhJMGHnopKL9x/bbIS6l10B3
         dbj7CkYKrHy2E5SKRxgkKkVRmb0Olu1tFy/RyEX473RM5gVqeBPaK1ln+bQQtumJIrh9
         Eh+8kICvNx3fHJCElsHqRvq24Z4toWSCojzH93f7qdfhDH4wn9FYDslvTyGZg6Z573tb
         tu83Bi1BTXV2XyCyGwcKS6iezCdZ+GdbvtRpPu8bKA0nRrolKckG/Lft6bw1oLiBSjX1
         MAng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734465357; x=1735070157;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kmfulnuDhPuLBz/whD5WGXWGKZ/jiZ6fTFdiIMT6aqc=;
        b=ucwbedWwMxTtkrDj3F0UspdDl6e7GJTYBjB87HABMN1TR6UU5qhc7T2H4EwP2IpUBa
         d/+gqKYDwJ7zXVB3fgCA5N/CbYunyBnDuCo3vdUbqlGDGAtQkPTZXSC5XpidFDlq6r5S
         XvBy8Kv84TgYp6o1n8otXn3PGN7ryg9iDSuEhpEceOIgjgMzNHuwCnlPckb/cnbuI9RZ
         CchPIzOZ5aDcSaExaiuyAAUp1MMTNI8xkN7rP7YNpRWPOCAAph8RJGECUrgEj8NDXqgZ
         KjhJsCa3ZoBuBi4bh17o8YgCuw6fYg70anx5/KAPZOyCl/Z4vCpiLz5Ws8fmeLX/7JfS
         zCyw==
X-Gm-Message-State: AOJu0Yy9wJ/tFj80jSV5D7b0M6HnIiy0jTGg4wMu2agG0s0Q+W1GcV9u
	qJNE2ef+wXpwsBFIQlvZ6Nw3DvlGtITgWieR2yDicjxGOm8jYlvP
X-Gm-Gg: ASbGnctXTAl0SFYXyEzZG6n+Wl6BD1xI0ghs4sBwHO8krCiiZCpxvV79cuUGkJ83SSB
	6IOia+VkSBGLzzrrh7qFdIG3vdxUrvtwT+2nBp7oEOA8zwYd63vbCSK3eb7i5x/8RDtNmFMSuyM
	GgmmBLUqf4JM0t4fF/SnfYlplRq7YT8noi4ld4/AIoLANActJu9uMMUPMgq6iAxNGrdwFhxvE/d
	9DR0jCh46jo3pqeYW6ONSWqBnDvt27yW+wLIzLmB3Nnn/9r89lwUr54DEzksr8Fpg1qVvu9Z4R/
	X3ULGx1+
X-Google-Smtp-Source: AGHT+IGk2eT3JyTGSDidhaoWFAeKar8/3y96ZDyfBdDl+Xl0CF7LVIjcri4vxxwBl6yNWDe6vJXvuA==
X-Received: by 2002:a17:902:c944:b0:216:3e87:ca00 with SMTP id d9443c01a7336-218c9370ffbmr72104605ad.28.1734465357332;
        Tue, 17 Dec 2024 11:55:57 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-218a1dcaefesm63547845ad.58.2024.12.17.11.55.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2024 11:55:56 -0800 (PST)
Message-ID: <9368fb0c-61c4-42cb-b0ce-3d5d48356a27@gmail.com>
Date: Tue, 17 Dec 2024 11:55:49 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/76] 6.1.121-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241217170526.232803729@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 xsDiBEjPuBIRBACW9MxSJU9fvEOCTnRNqG/13rAGsj+vJqontvoDSNxRgmafP8d3nesnqPyR
 xGlkaOSDuu09rxuW+69Y2f1TzjFuGpBk4ysWOR85O2Nx8AJ6fYGCoeTbovrNlGT1M9obSFGQ
 X3IzRnWoqlfudjTO5TKoqkbOgpYqIo5n1QbEjCCwCwCg3DOH/4ug2AUUlcIT9/l3pGvoRJ0E
 AICDzi3l7pmC5IWn2n1mvP5247urtHFs/uusE827DDj3K8Upn2vYiOFMBhGsxAk6YKV6IP0d
 ZdWX6fqkJJlu9cSDvWtO1hXeHIfQIE/xcqvlRH783KrihLcsmnBqOiS6rJDO2x1eAgC8meAX
 SAgsrBhcgGl2Rl5gh/jkeA5ykwbxA/9u1eEuL70Qzt5APJmqVXR+kWvrqdBVPoUNy/tQ8mYc
 nzJJ63ng3tHhnwHXZOu8hL4nqwlYHRa9eeglXYhBqja4ZvIvCEqSmEukfivk+DlIgVoOAJbh
 qIWgvr3SIEuR6ayY3f5j0f2ejUMYlYYnKdiHXFlF9uXm1ELrb0YX4GMHz80nRmxvcmlhbiBG
 YWluZWxsaSA8Zi5mYWluZWxsaUBnbWFpbC5jb20+wncEExECADcCGyMGCwkIBwMCBBUCCAME
 FgIDAQIeAQIXgBYhBP5PoW9lJh2L2le8vWFXmRW1Y3YOBQJnYcNDAAoJEGFXmRW1Y3YOlJQA
 njc49daxP00wTmAArJ3loYUKh8o0AJ9536jLdrJe6uY4RHciEYcHkilv3M7DTQRIz7gSEBAA
 v+jT1uhH0PdWTVO3v6ClivdZDqGBhU433Tmrad0SgDYnR1DEk1HDeydpscMPNAEByo692Lti
 J18FV0qLTDEeFK5EF+46mm6l1eRvvPG49C5K94IuqplZFD4JzZCAXtIGqDOdt7o2Ci63mpdj
 kNxqCT0uoU0aElDNQYcCwiyFqnV/QHU+hTJQ14QidX3wPxd3950zeaE72dGlRdEr0G+3iIRl
 Rca5W1ktPnacrpa/YRnVOJM6KpmV/U/6/FgsHH14qZps92bfKNqWFjzKvVLW8vSBID8LpbWj
 9OjB2J4XWtY38xgeWSnKP1xGlzbzWAA7QA/dXUbTRjMER1jKLSBolsIRCerxXPW8NcXEfPKG
 AbPu6YGxUqZjBmADwOusHQyho/fnC4ZHdElxobfQCcmkQOQFgfOcjZqnF1y5M84dnISKUhGs
 EbMPAa0CGV3OUGgHATdncxjfVM6kAK7Vmk04zKxnrGITfmlaTBzQpibiEkDkYV+ZZI3oOeKK
 ZbemZ0MiLDgh9zHxveYWtE4FsMhbXcTnWP1GNs7+cBor2d1nktE7UH/wXBq3tsvOawKIRc4l
 js02kgSmSg2gRR8JxnCYutT545M/NoXp2vDprJ7ASLnLM+DdMBPoVXegGw2DfGXBTSA8re/q
 Bg9fnD36i89nX+qo186tuwQVG6JJWxlDmzcAAwUP/1eOWedUOH0Zf+v/qGOavhT20Swz5VBd
 pVepm4cppKaiM4tQI/9hVCjsiJho2ywJLgUI97jKsvgUkl8kCxt7IPKQw3vACcFw6Rtn0E8k
 80JupTp2jAs6LLwC5NhDjya8jJDgiOdvoZOu3EhQNB44E25AL+DLLHedsv+VWUdvGvi1vpiS
 GQ7qyGNeFCHudBvfcWMY7g9ZTXU2v2L+qhXxAKjXYxASjbjhFEDpUy53TrL8Tjj2tZkVJPAa
 pvQVLSx5Nxg2/G3w8HaLNf4dkDxIvniPjv25vGF+6hO7mdd20VgWPkuPnHfgso/HsymACaPQ
 ftIOGkVYXYXNwLVuOJb2aNYdoppfbcDC33sCpBld6Bt+QnBfZjne5+rw2nd7XnjaWHf+amIZ
 KKUKxpNqEQascr6Ui6yXqbMmiKX67eTTWh+8kwrRl3MZRn9o8xnXouh+MUD4w3FatkWuRiaI
 Z2/4sbjnNKVnIi/NKIbaUrKS5VqD4iKMIiibvw/2NG0HWrVDmXBmnZMsAmXP3YOYXAGDWHIX
 PAMAONnaesPEpSLJtciBmn1pTZ376m0QYJUk58RbiqlYIIs9s5PtcGv6D/gfepZuzeP9wMOr
 su5Vgh77ByHL+JcQlpBV5MLLlqsxCiupMVaUQ6BEDw4/jsv2SeX2LjG5HR65XoMKEOuC66nZ
 olVTwmAEGBECACACGwwWIQT+T6FvZSYdi9pXvL1hV5kVtWN2DgUCZ2HDiQAKCRBhV5kVtWN2
 DgrkAJ98QULsgU3kLLkYJZqcTKvwae2c5wCg0j7IN/S1pRioN0kme8oawROu72c=
In-Reply-To: <20241217170526.232803729@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/17/24 09:06, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.121 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Dec 2024 17:05:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.121-rc1.gz
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
