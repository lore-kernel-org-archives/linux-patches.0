Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3FDF1FBF
	for <patches@lists.linux.dev>; Wed, 21 Feb 2024 01:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708477501; cv=none; b=jbeYgrrYxr431RtHAfJ52ExkgesLmY42IlLv7Md9vG3J9Tv5XDc4Z5deTpvSpdEGO5y62yRiQSgtxjNK+B6og/oxvV7fqL5ERcePoTTgx0ZUFyCMalN8VJnzyZIURMq89nXSL5SrqhMl02WQgLSfEcmjsseZrmN9UfCYLrOlAp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708477501; c=relaxed/simple;
	bh=dEEluF2P2gR2xeqyp1Y02BIrtT0tj7h+zfXvTlij9gA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KEOqw09BMEmlDjl6Zoi+6WAo16NJVGZjl5oD5QuL8LlOgG008GWlWb3U87CKkTrW9TVElLLwfkka0A8gSvWbArTuCubx1xtokhcSeDI3DmAsqKQao5Qi1RTAQkv1xcXjNDaye/4LV4Zegudi0jRWW6OLhevk6IltxaxJo5++Nts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HDAIQwgb; arc=none smtp.client-ip=209.85.161.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HDAIQwgb"
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-59fe5b77c0cso63207eaf.0
        for <patches@lists.linux.dev>; Tue, 20 Feb 2024 17:04:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708477499; x=1709082299; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=isNEaG2qmUnKOTH5ZjP/ZpM+OEQOzCRL1IUF9BpRXmM=;
        b=HDAIQwgbjQ3Safu2HH0rm64nyGMSYHbYOVB2wFgka+8qmFOkUIde2Z3b1wOXGlCnpb
         Jk1/t1lOJOCmnCp3Mmih+7vHQsjlntIlaCjmBVXR9OhbMsvsGTvI7l52x6Mrkx0Qr88A
         R3SUKu/GJqlRl0J9UZjLe+A5N+GaJHmhNePxRYeOQK9v9i5Ap3PVdltPcECJPmr3oDiO
         a41tTaXYXPD9JLDguv4GNO7CjgnXLWWCQZsIuHRJr6nNsRL+Z8s51K1wC12OZHXxSTfr
         xMME9m3kER29MLfIWPEDc0o5TEXD7M+Va9muMRdxrpe26CxJgxVOjK3UYIUmb2wnv079
         4mrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708477499; x=1709082299;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=isNEaG2qmUnKOTH5ZjP/ZpM+OEQOzCRL1IUF9BpRXmM=;
        b=DRxabDSuRKysZOYgpXdwu+nn1lPzS/Ll8uVToniW/hDTjBULvfzGTgsQwjyOqatdxY
         N3eRuMmd6H3HdZr1F8pcszFCp8ts0HexJ7ofUGF8w/mh77BkbeXo84y7WAYxoSZf0ua0
         sk9DXbjtnVEOAkOr5OdSWX3UzXw02b3HkmD0R4P9qoXeBdRw+shOcX/rN76+PDfPALK0
         Z+eZ1oJiEFr8s4L5R1GiQkNXaOSD6aEj7oEqBEuHDRTNwOGq4l+6pTvpU6oVUbp029k0
         smWQT3iso7VkkplKiDqDGUjj4SPCtcfYuA3440xTwBEiRv3QsOeHPC82/MiYOc2Sjb4n
         LoFw==
X-Gm-Message-State: AOJu0YwPLTbOgeLkxItq+DMbc/kLq6t8r6a1gRaYY7U4mfBcq4iP2uyI
	2pe8fgxa7O6Plcb3kJJt7Lzn06zR6ddANTdfRC0Yl/WkQUd0iu2NnuiDPwbaFf4=
X-Google-Smtp-Source: AGHT+IEPSYsGXwIa99frjjxu55kRc+mJZefx8BZP63xdHJTTQr2I4XQ4GxSUQa3YlEbf6wzp0j0GLw==
X-Received: by 2002:a4a:2b52:0:b0:59c:e5c8:bdc5 with SMTP id y18-20020a4a2b52000000b0059ce5c8bdc5mr15417911ooe.3.1708477498904;
        Tue, 20 Feb 2024 17:04:58 -0800 (PST)
Received: from [192.168.17.16] ([138.84.62.70])
        by smtp.gmail.com with ESMTPSA id z6-20020a4a8086000000b0059a530f54c6sm1639833oof.10.2024.02.20.17.04.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Feb 2024 17:04:58 -0800 (PST)
Message-ID: <c873370c-c12f-4f03-a722-1ae59743089b@linaro.org>
Date: Tue, 20 Feb 2024 19:04:55 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/197] 6.1.79-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
References: <20240220204841.073267068@linuxfoundation.org>
From: =?UTF-8?Q?Daniel_D=C3=ADaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello!

On 20/02/24 2:49 p. m., Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.79 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 22 Feb 2024 20:48:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.79-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

We see a regression with PowerPC:

-----8<-----
   /builds/linux/arch/powerpc/kernel/cpu_setup_6xx.S: Assembler messages:
   /builds/linux/arch/powerpc/kernel/cpu_setup_6xx.S:124: Error: unrecognized opcode: `sym_func_start_local(setup_g2_le_hid2)'
   /builds/linux/arch/powerpc/kernel/cpu_setup_6xx.S:131: Error: unrecognized opcode: `sym_func_end(setup_g2_le_hid2)'
   make[4]: *** [/builds/linux/scripts/Makefile.build:382: arch/powerpc/kernel/cpu_setup_6xx.o] Error 1
----->8-----

This is seen only on PowerPC with GCC 8, GCC 13, Clang 17, Clang nightly, on:
* allnoconfig
* tinyconfig
* mpc83xx_defconfig
* ppc6xx_defconfig
(at least)

Reproducer:

   tuxmake \
     --runtime podman \
     --target-arch powerpc \
     --toolchain gcc-8 \
     --kconfig tinyconfig

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>


Greetings!

Daniel Díaz
daniel.diaz@linaro.org

