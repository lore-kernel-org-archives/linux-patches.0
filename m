Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583D91922C4
	for <patches@lists.linux.dev>; Wed,  5 Feb 2025 17:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738778363; cv=none; b=q64yWSgMWnaYqS+6XVzl0DRZbPVxFZGReRWn6oOhEMDhU2WfSo/8WB+FmQrBpnfe3hmOlCjILe+/1zx3PAB05oBqA3ygu7mc/VQv4YQqV1SP3bwv9HUecrG06wLa+giZmm4sOQbJcgL1Op9c3frvX2bCGVDWQ3tMHNAmlfZGcpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738778363; c=relaxed/simple;
	bh=b9T71eCrWsGZTSKWu5AEhCrmZi7QmAti48/sGHej60M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SrFMfmTwOTjjhw3Mbf74EOp/5yHUMpknfiCfFPJM4PJB1WPWjO9AbuH89YO7mnJgROV/6dBjrCXawWNIdxe5RTUH1szYFlAqEM3LKj5ckMsVB7jInUmPUXirR1cN1LWFjT9ZJUBXEarzjG7YKimtoY9DwYHGcRep1JplmMNEEBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VIy+NL8V; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VIy+NL8V"
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-3eb972dd8e5so29350b6e.2
        for <patches@lists.linux.dev>; Wed, 05 Feb 2025 09:59:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738778361; x=1739383161; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=6YaHC7zHfgfmlu28QNPcdEdK07lajsTvPZTWhUl88QY=;
        b=VIy+NL8VOv7XL0+cvn1USOnucjYoUKZtDmnnKKj8pYvEQpRTq8+YnHkMyM2V+PGdwg
         Cca1R4yRlkgpmbw8Uvt+Jl1UzJyEqakd39NPZylnj3fEhcmQd0ZKt8iLfGh2wWQHbhYv
         VYqPf0q+FHYMGw/8bjxnXdWBq12aFhnWFlDLnfNoVI0lcRBM0/5XmFI1nTjmli8Tj5yE
         6Q7DrCfYGGHcV060GHA98saEre65TGQ3lSqG3mH2lY7jS63jbfbI6x9d+Jrj+17pwL5Z
         1kG6m3L2L6MG0k3MQv0RYRAFTcemUYQG7H/LwFGJIcpiu/L06G54vyL8RN3fGtAEMNME
         Hptw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738778361; x=1739383161;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6YaHC7zHfgfmlu28QNPcdEdK07lajsTvPZTWhUl88QY=;
        b=QyTMegbEyH39j83Lvo818cjWGokppCxhnfUoe8Ki1TeZAv4L4hDShs/rm4/hUbTfRy
         HaS0SjLwJ/btdHWrTcYWzfKR+n90WRVJF7r1xwwcViMtTAtBP4nS/RXef5C+iuuu1qyQ
         gL9W9HprqKofyjBkEYVHBzHlr1rPW/sGE27eIaGlMQqhdKZHqAlvVTN7JEh90VMyP/Np
         yzEy9Eg0mPNV3zQU38FADgIibzRL+gOs2SHw+KNqugIpAX0gFX3z1ybzPUOLEbm5N/G/
         XDgeao8vY/KUVOXBNGbw+r3FPUdEAng5oTM5SHRIw5n2SoVoNFAIZ2lkQfnkRAeyqI9C
         EfPQ==
X-Gm-Message-State: AOJu0YzewSSm2DNFcTvv70bIWEoipF2gP/wrbCULkKuuc3N7zxgpltrc
	R1zaPfSo6qQNjp1Wtb2DezOAfH8q1ej0CC+dCTAw7ra5u3GnpNqRpwDUk7hZ
X-Gm-Gg: ASbGncvokqjtZM0ueJFCm+ZFnnTAsu3YaQjw5V4vVMFuMu1X+PZe8sPyefyUBtZ2f23
	Rqc6agshOIicJkzqyMUqQQZdqem1DjtQlFW6g+MLIv3zvp7KZZXY9HZjqFizUH2t0nnaV4mzbl+
	EvuJAm/UvobAwL0Uza6X5tn4IRJLW5TWCL1AagY2fhpQI5KnV8gIleAE14sy+qVkZnSG16x+qy0
	TiDzluki2T6/QAF5sODJZB9fkqucVPOStLwQqjoE/1Lm5spqBBk584W0LNIjI+CMX5slgk4a5Bd
	tUWbwoQgHUwGDvuPehfcVrdC+fQBtrDETN5klWzfb/4=
X-Google-Smtp-Source: AGHT+IGkpNxxBj+OWeR7r4PTJ2ETrUGVEuL26iYgX92UAJ3BeEe17n1SD9pAtFYBn93zzIXZchRg4A==
X-Received: by 2002:a05:6808:3203:b0:3e6:93f:4025 with SMTP id 5614622812f47-3f37c10ebc4mr2437502b6e.14.1738778361308;
        Wed, 05 Feb 2025 09:59:21 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-726618c8a47sm4024350a34.59.2025.02.05.09.59.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Feb 2025 09:59:20 -0800 (PST)
Message-ID: <b161c78b-8ac1-4617-bcec-0e365ee8755e@gmail.com>
Date: Wed, 5 Feb 2025 09:59:18 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.13 000/623] 6.13.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250205134456.221272033@linuxfoundation.org>
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
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/5/25 05:35, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.2 release.
> There are 623 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 Feb 2025 13:42:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
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
