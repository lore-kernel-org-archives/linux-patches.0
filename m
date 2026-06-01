Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67103DCDA3
	for <patches@lists.linux.dev>; Mon,  1 Jun 2026 17:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780334071; cv=none; b=O4sw2q2djFg/QXDDeVyzribclUkG75gtIdMEP6Vmy3qo3uAwKmiZ1RVK/opceQ9zSeALA2stJAWAzMgdAlngK5DwXEATI8nqFZxroPCS4Jx9ctgSpDKS0jqVeJKez00khpUr/Yxj18ipUxKnpfeSMEudOrxHaKBfVR0900Z7nRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780334071; c=relaxed/simple;
	bh=Arcw7RDu6YnvHHrozBQqErDjIv0rUN+ZLgIh1ITCFS0=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=hX4t925trnBhpMaIH9EnWhFpH4xU5JDfIjiPtTUFx+0jYE+BYaiNbhu//QcnWK7FG8UUN7M/2+89IOUr6s8tRmGMyGqrUCB5k4wrytNdgsI7qaOi6bMgST21DF8FvAgOtB7+wfjYmXR+YSAv15RyGVOmIuICuW0PrrBFRihrFgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qn9DNBAL; arc=none smtp.client-ip=209.85.217.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qn9DNBAL"
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-6c3b507a4fbso1071111137.2
        for <patches@lists.linux.dev>; Mon, 01 Jun 2026 10:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780334070; x=1780938870; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+RyRi+i9cRJsqRIFBEtxCh34w8MgyXpxo3mgchnEBr8=;
        b=Qn9DNBALml3Uugs3evwvdVLpPHSGLXdywD0ejQ3VgmMl8YKnxU/I7rLiyED4YyDWwQ
         B4GeBBiTCMlmR6EqzLi58sb61qo/NaYQsWQ7le3Y7gTa7PNYuSFClgW/HASWi3HbCkTV
         fPsPQbodu1/+cxg1zOXcPdKl/l6VO1daZr8OA7ppHhqf24/C05d0EPvcJdkXLk60zlmw
         tXigsiLx3fE7F47Le+Fkk0fo9hZl0GnXRP12abAlkuH7ooT8qjN6dP0c2sMTp56LrDIZ
         akGe9du1UmHQw4mzVzYoolsdCxeJKguVWY3DdMLTA4iYsYK9S6Czllh+DfSk4eWlzwi0
         qp9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780334070; x=1780938870;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+RyRi+i9cRJsqRIFBEtxCh34w8MgyXpxo3mgchnEBr8=;
        b=Gpenix+ws3sTvUUvFrM3YCbS0H7T5/AoQIRX6krkGkq6ux8B1cs+uSp9VJ47WP9yaX
         cWr2Dfm07kbMXZxqZNHGBuhh6qUnGr63Fc5sMXTQHXz9ihHL1atQKQxzqTMsBEtcYzWd
         DMZhn4k9MFzVX/a3EzRgCg3tbLzABa621jqh1/isvegf6OwWd8F5hCtZ4ebR8Ux2jHVd
         CF9xEgejvlyi6EZlF7uxUfuq0jf9UDHMpmpBbH0P55JO4uqlumcxOuEmlHqI/951eGv+
         S4CIoniGydeYGkmC5pzCsmmD70SBZBI2p2+rAJ/pvnSVac64efC4TEI1ymXCPoOrxUZj
         KVBA==
X-Gm-Message-State: AOJu0YzWaMsf09gxx0JdwkTyhi8ubR5/AZyEnkie1FVsWmUN2WXkMjbE
	auAFyGusiwX3M31YvCICIwwH2G2d+b9zN0ScbnO03/+Lff1o6QqKRJBt
X-Gm-Gg: Acq92OG9l88dJ+CefBGDYfTQKOh7KQgdLD8JyXKNllW1e0c7B0XrjLADjhHw/IPDcMW
	fhddqlrG9wWu5wszp9xxy0yhYRAr8YlUKuBxejA2MZDYSZYQC0O+gjdzH0MFBrmdgINKt05mtJo
	P2cLvsR2CtOvBtDcqIAMGyGECScuazlcERQ/XFhda96/CoQ7ApQokRDt1+z9JrHqCNXW/P0i1LY
	BQplhBbmg69NI+OxSpsxci+y+hWiw82ngL7wfPGKTMspvt/xiXDC37RWbHf2aGnrv2XV8UyXXTU
	GUhH+p7RkojwL5HZvDIf6/zaPt/Je0Vp+wkKuScHHmSbNGC8LHcfxNTid598r8Ol+qt6li2Z8Ql
	279UrKg1UQWGSimQXceiRxFYij3g3SRA3NBy6FvGNfmhvRRFpPWJcwS7qYV8dF1PAFfRTS4kcl6
	TDRAS3Hrq4pX6bkEl7AJbCt9qfo9sY0cSWmjGO5dfZBLIgHYeh9qk2QiFQa14d
X-Received: by 2002:a05:6102:9d8:b0:62f:4553:7a28 with SMTP id ada2fe7eead31-6c69e741a2fmr5254418137.21.1780334069540;
        Mon, 01 Jun 2026 10:14:29 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ccea061e87sm97982576d6.12.2026.06.01.10.14.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2026 10:14:28 -0700 (PDT)
Message-ID: <893c1c66-bcce-40d9-95e5-42adee11b6ef@gmail.com>
Date: Mon, 1 Jun 2026 10:14:25 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.15 000/776] 5.15.209-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260530160240.228940103@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/30/2026 8:55 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.209 release.
> There are 776 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 01 Jun 2026 16:01:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.209-rc1.gz
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

