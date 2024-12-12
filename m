Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0553191F85
	for <patches@lists.linux.dev>; Thu, 12 Dec 2024 19:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734033233; cv=none; b=irluCJtuR+DGCui/TmtSj8kzxcSDEEcxhH4/eAbO+Hws63dfjET3GI3I3VeT1YFsIqvHoshGi2pEWmmXFFrPbvRlqWgPhaRl7jLpW9gGiHQbZANkiT/HejDBt+bxioUm9xfgz/FsHD9Wa2Dzqg7RIZ5AOrYYkRV1mAkl8Ad5H6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734033233; c=relaxed/simple;
	bh=edRiCalX1S8i2hLiGSD/RC3UGFfIm9L1s53cMBdg0Hs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mo/8/H3TeAT5ahgFLVBKrjyXhH8dxaPzBIDKFJ/JEv0RjGEMjEjbvqTdZhxlske3lPh35b4/umaSDLSTId6GA2Y5Rdg4zZsQP/13ubtagESvj5fpvuvZwVPT5SKz92ppXyD5Hdk1+/m0aaDXOgNpv5A4wNmhWmoPKmftNFCVFY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PJgkfYzH; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PJgkfYzH"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4678cd314b6so9453391cf.3
        for <patches@lists.linux.dev>; Thu, 12 Dec 2024 11:53:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734033231; x=1734638031; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=sPlGAJkm20MaJPbgK/9Xq/stgyHGFJzZwjUSfu4XrZ0=;
        b=PJgkfYzHujLs10O7+CjNxEJv2eDJDQMCpFEy3VXnOu9Nx2B2a7JdloEL+wXBOhnWdp
         /3+avJ0Puei9tZYfENzmU6oj29omYzqkmH7aBtDL5EtJ5gCzTexZMm8hGkiz4A3U6Azg
         +VyojpdRdwygTdxQKsnOOp0Lx0cLjV0FEqIyD6ceVCFJTIT8M/wURya5spe6TuwNRAk/
         fYkxE8q4qMOc7y81CzYM5VLsZMbhMsibZr/5Wqc3n1VQc192gOe5KMzr9dTkgrWFAHBN
         FOYcYxIdCrJ2JorZgzjkmEnbivxjTKoX7gbL2SG0vhcRqUenpeh3ZlOP1QE7j+z+oQfI
         Dr9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734033231; x=1734638031;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sPlGAJkm20MaJPbgK/9Xq/stgyHGFJzZwjUSfu4XrZ0=;
        b=NKwCSjUmper9XQlDdsMjgJshrEJQqDrqJ7bLJAWbmnN4f1lu0MRY3V2uL70mryXIIs
         5A6RXyv97ahRi8CaVJw+Qo1z8+u3G1j8w/jJQnPexwAgkyu4tag5ZUccpw5jeFwjo+q5
         lDhLOOKjmOxDej8KcAc6NnLyYRbd5iq1eHj29Y7Au0RWhmrCReFc81OtGC0TEk8ZiZhf
         RLqtCdT+KMCWFsGkzbQA2KYzQ/35ugoFu9OVT8p0DIyWF3faujKd1TgbZss+LnyoonGd
         DgI6kvDoK6HgulAjJtR4G/2z+KJ4Q5XiRvWdpIWOxXlOQPvrC4FVTCSlPc5dvUrn/uJp
         XmpQ==
X-Gm-Message-State: AOJu0YwdINYKedI+S82X7lqg/+4GOQKHqLOKOGn1KOD9rfXuEDu52G5q
	mAsAm0DnDo+QDoFgOHpgSWmFE2v4alTgucWRH0l7v44x8hq6Cc4t
X-Gm-Gg: ASbGnctQE20jriXldRq737nSFRna5p3xNU1vpUdEAjRgbkwBf9SBuzF/FapHg7SDUsx
	HZQgK/tcwRIdal9lrN9GR/Wy/CwH+I7Hvgbd8ETrX69xrDZyv8MZV6gnuXZJRq7M/V4v35JowuY
	S4FH7HktKzWLHfsGNIF+vW28V0MAHF/IdDzJYxvKKlkeD5+3kkanzk4fjBjf+w1bzfo4g7DouQH
	2oeAU8DIrZZLv/R15NDZ7z90+q84hTT8GKeAGPU9jB5Mxsb7Cgdalh/Ixrv/AxRq2lT5fjKZWzC
	d1CMGM6t
X-Google-Smtp-Source: AGHT+IFvlLZUnpCLTwr3yh1PDjcpmN+9iFF2G67MAybupOGN267T8/qfQahwH4wAPyScj52vLXmP+w==
X-Received: by 2002:ac8:5748:0:b0:466:a584:69f8 with SMTP id d75a77b69052e-467a16890b8mr28184611cf.43.1734033230748;
        Thu, 12 Dec 2024 11:53:50 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4678a0edd33sm21967221cf.54.2024.12.12.11.53.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Dec 2024 11:53:49 -0800 (PST)
Message-ID: <57107aaf-55b5-4389-ba3c-6a48995d1116@gmail.com>
Date: Thu, 12 Dec 2024 11:53:40 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/321] 5.4.287-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241212144229.291682835@linuxfoundation.org>
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
 YWluZWxsaSA8Zi5mYWluZWxsaUBnbWFpbC5jb20+wn0EExECACYCGyMGCwkIBwMCBBUCCAME
 FgIDAQIeAQIXgAUCZyzoUwUJMSthbgAhCRBhV5kVtWN2DhYhBP5PoW9lJh2L2le8vWFXmRW1
 Y3YOiy4AoKaKEzMlk0vfG76W10qZBKa9/1XcAKCwzGTbxYHbVXmFXeX72TVJ1s9b2c7DTQRI
 z7gSEBAAv+jT1uhH0PdWTVO3v6ClivdZDqGBhU433Tmrad0SgDYnR1DEk1HDeydpscMPNAEB
 yo692LtiJ18FV0qLTDEeFK5EF+46mm6l1eRvvPG49C5K94IuqplZFD4JzZCAXtIGqDOdt7o2
 Ci63mpdjkNxqCT0uoU0aElDNQYcCwiyFqnV/QHU+hTJQ14QidX3wPxd3950zeaE72dGlRdEr
 0G+3iIRlRca5W1ktPnacrpa/YRnVOJM6KpmV/U/6/FgsHH14qZps92bfKNqWFjzKvVLW8vSB
 ID8LpbWj9OjB2J4XWtY38xgeWSnKP1xGlzbzWAA7QA/dXUbTRjMER1jKLSBolsIRCerxXPW8
 NcXEfPKGAbPu6YGxUqZjBmADwOusHQyho/fnC4ZHdElxobfQCcmkQOQFgfOcjZqnF1y5M84d
 nISKUhGsEbMPAa0CGV3OUGgHATdncxjfVM6kAK7Vmk04zKxnrGITfmlaTBzQpibiEkDkYV+Z
 ZI3oOeKKZbemZ0MiLDgh9zHxveYWtE4FsMhbXcTnWP1GNs7+cBor2d1nktE7UH/wXBq3tsvO
 awKIRc4ljs02kgSmSg2gRR8JxnCYutT545M/NoXp2vDprJ7ASLnLM+DdMBPoVXegGw2DfGXB
 TSA8re/qBg9fnD36i89nX+qo186tuwQVG6JJWxlDmzcAAwUP/1eOWedUOH0Zf+v/qGOavhT2
 0Swz5VBdpVepm4cppKaiM4tQI/9hVCjsiJho2ywJLgUI97jKsvgUkl8kCxt7IPKQw3vACcFw
 6Rtn0E8k80JupTp2jAs6LLwC5NhDjya8jJDgiOdvoZOu3EhQNB44E25AL+DLLHedsv+VWUdv
 Gvi1vpiSGQ7qyGNeFCHudBvfcWMY7g9ZTXU2v2L+qhXxAKjXYxASjbjhFEDpUy53TrL8Tjj2
 tZkVJPAapvQVLSx5Nxg2/G3w8HaLNf4dkDxIvniPjv25vGF+6hO7mdd20VgWPkuPnHfgso/H
 symACaPQftIOGkVYXYXNwLVuOJb2aNYdoppfbcDC33sCpBld6Bt+QnBfZjne5+rw2nd7Xnja
 WHf+amIZKKUKxpNqEQascr6Ui6yXqbMmiKX67eTTWh+8kwrRl3MZRn9o8xnXouh+MUD4w3Fa
 tkWuRiaIZ2/4sbjnNKVnIi/NKIbaUrKS5VqD4iKMIiibvw/2NG0HWrVDmXBmnZMsAmXP3YOY
 XAGDWHIXPAMAONnaesPEpSLJtciBmn1pTZ376m0QYJUk58RbiqlYIIs9s5PtcGv6D/gfepZu
 zeP9wMOrsu5Vgh77ByHL+JcQlpBV5MLLlqsxCiupMVaUQ6BEDw4/jsv2SeX2LjG5HR65XoMK
 EOuC66nZolVTwk8EGBECAA8CGwwFAlRf0vEFCR5cHd8ACgkQYVeZFbVjdg6PhQCfeesUs9l6
 Qx6pfloP9qr92xtdJ/IAoLjkajRjLFUca5S7O/4YpnqezKwn
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/12/24 06:58, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.287 release.
> There are 321 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 14 Dec 2024 14:41:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.287-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
