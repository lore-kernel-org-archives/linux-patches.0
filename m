Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC241E0DE6
	for <patches@lists.linux.dev>; Tue,  7 Jan 2025 23:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736291770; cv=none; b=p/WCI/fRjvZCt/i0oPg2342E9Vog3HujQfg93Gp2KkwLBMdFUJMSa4sp/lY2kdkkHl/ttS0Z13cGoW0SyzBPD59svLFBkignAGDkxc77hCGNRq32yNWQR4eZO7U+6cdPAjSjOGxd2HxRGaQDfRNmkxOJGH0gkgCp+W00sLuBRKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736291770; c=relaxed/simple;
	bh=Y40xGJr+8Qy07UYA1aftHu5Xx5x9WHeBEJ/VXZGg47E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dwSLiLZ/8MzTWMEEKNEwvKttA/0A9uDIM68XD9NSMlIMFTxWiMTjzqGKb3EeZmroMoyRehSkiaXMvRcbZIUzhGos9c4A2Qpt57YIrmbiLl903485QXvhziZszVbgAD7wLRE8pj7nMm1OuEYCYyfO/3I+l32LT3ueOYfgbj8hqrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZMUPCamB; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZMUPCamB"
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-84cdb6fba9bso61127639f.2
        for <patches@lists.linux.dev>; Tue, 07 Jan 2025 15:16:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1736291767; x=1736896567; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tkz+oAlIsB7kUQO3nBdLz6Ks/ioiSSPBbNR2F9IzyzQ=;
        b=ZMUPCamBw1YtCEVEsuqOaZLWhD8UOc36YvdVg2u5nrAkCZDnmXgGy+GYPRlsTOxFgJ
         BDoeWBkR/mJJhw6I3zZ4YQ2AMDUaXuu72f8d2ZZr5gB+nZ8/F/il2fV8SCZdby7YRCmu
         pnaG6STEZNr2oY+oA5wNRuoeees/eD2Buf5AY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736291767; x=1736896567;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tkz+oAlIsB7kUQO3nBdLz6Ks/ioiSSPBbNR2F9IzyzQ=;
        b=N1GnetWlQFW01TMl9pHUMfjjtE2zaxz0BK8TzGEMnLPnZwz7Bt5cDVej7lcvnhF3DY
         PW/bL6QzhDjRee6ph7cRmMD6d06PXinxEFtkb9lCGrZIXFdKDtgxR8UseBq6MJjjczBl
         dRAF21V+sdJNyuINIwt6G6/QYXh/PebKo2WnkjRtGJ/XHdWrAOGn9gFP08UPub8I5Xn9
         3HeTZq9M6afSDn40Kkwu7iihhC/n1dUHLgD4HG8iCKS9kAADR0uAKRPvm7b6YLoik2Vp
         oiGNs115tlvxsFc3ls93GfGBTUtp8FffvgAcgM3D+bf+sZnnvF6I/SbZARHqd62btz+z
         k/ow==
X-Gm-Message-State: AOJu0YzzLI69uUiy3/FwI1sZXjkboXrMGkp4+Y4wQfSi+vuYvxcJ1VBc
	9aBhQF6oWUIUbBvws60FVs9gbmHCo1DJjOk/F4Vyvo4DoYd9ZsRlE4je7zWtxNo=
X-Gm-Gg: ASbGncvptZC0FgZfe2y4MPaW98LHHFWrRVeM9yNzh5hSYdAy+cB2c33xGy/XmsUtBZD
	o3wesXYw3LFeAhxGImsQR/KG1j9POz1ZnD9JSFOVXxgzb7w85ZE9Wy5BClJBf6NJI29d2f1nDGl
	OX7wfLmVG4ynvNikLAHTYByIYAis32OBlYnknuE/Oq+xelPfLngOe3NI/mmDLWNRYtCeZqbdh+O
	YkGfm8V/CBW87SjzHRg0TUFHCCa2HIWcTwbEC58hCmM3iZiE4biAlri/jPFt77RhfPm
X-Google-Smtp-Source: AGHT+IFe1SigtLgqoIISiAXp5oU/0Hxt7+fEOLTKBe4MS9n7FzMWJWdBr472Vr6VjGHqDAj5d6oI4w==
X-Received: by 2002:a05:6e02:1a6f:b0:3a7:8720:9e9f with SMTP id e9e14a558f8ab-3ce3a86a4e0mr8199665ab.2.1736291766810;
        Tue, 07 Jan 2025 15:16:06 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ce2d260971sm8859775ab.79.2025.01.07.15.16.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2025 15:16:06 -0800 (PST)
Message-ID: <01883752-11d7-4195-94e4-27719ffa2235@linuxfoundation.org>
Date: Tue, 7 Jan 2025 16:16:05 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/81] 6.1.124-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250106151129.433047073@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250106151129.433047073@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/6/25 08:15, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.124 release.
> There are 81 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.124-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
