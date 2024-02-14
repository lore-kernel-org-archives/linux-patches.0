Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7464145326
	for <patches@lists.linux.dev>; Wed, 14 Feb 2024 23:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707955051; cv=none; b=NTc6aouIxbDChRXq0U1YYW5jI0fGwT44OeSvUKgyE8M3y8SK/ibuCbWQXGNMQKgcZzIK49eUNV37VwlQkiHNaB0wtVx5NVCzq6ZEXkpSMV+gfslSyuU4ufTjsA4k942gQ4C06nLz7paqViESuH0j3d2oY7j7NlzLR1Ovv/S5vAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707955051; c=relaxed/simple;
	bh=VqSJFmpRhmAQYjXv/G4gNLTLSwvkjnB6qhWoxX234c8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LQQ46Phu41RJJByAMoMg8bO3+MUcXAwBm++NIDg/U68HMNTpINuHhW56sNFhsly2B62GbsBOoD1m5TNhEgiuyvKP8zKI8hVa/XNozoG87MV8pgE3LwHDADqtFXRaAqNBx0oUGJHLYC+IWsGI8XQIE5nwfFXHgp/E0fY2JI9RHCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F/u6UEMy; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F/u6UEMy"
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-3c02b993a5aso287305b6e.1
        for <patches@lists.linux.dev>; Wed, 14 Feb 2024 15:57:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707955048; x=1708559848; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ezJuggmm91LEsLCew+tJs/aRiavsyGNCiHmODaOsV/E=;
        b=F/u6UEMyvxot8f7hQM9Kfn29CpH0Aw+der6i9qqleCM2E4uUdyT1U7iXDQFbWrElsC
         wIpQIUBWaV78V/ik57k1xlp1zeWWzvzaws6ivQj/kIBLr0plfjEjAdEAnRFQRquXUbeI
         FFYOpahqLj5JikRysfLG6b0EyIKSz6UTIxRiCKQ+5M1N9n4MR8Qv6oYVlStNuC9pFkTU
         eKQAQYFqJq23ZocOBemHErYn31rYMu0P6zfhYGRH8WMeZvyrFnufn9FdLmu28brcQy8e
         s7XJ/tHpOxcPFEtQp5FqcaxWQVunzma9p+b6ZOmJe1PH+LiEe8RrrzVHgwmwwBtf5Gmk
         T0jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707955048; x=1708559848;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ezJuggmm91LEsLCew+tJs/aRiavsyGNCiHmODaOsV/E=;
        b=pMsut5IHfxJEcLqd8NvSZGqk+0+U23gHn8OObex6keG53f0m7zOmWRsQLTSrAF3KPB
         1u7TPYa8yLEPhXf4EWOUzDG3kAP31ZX5vHeCFhjIMshSL7YIEIy1gaNHeniHjVEYLEAe
         V6bMnY7drVtVVN/y1/Q0TaTfJ1xL6xZvULEBnqn72YbUQT2GWVgmNtXxWxg4ltxL++7V
         Rk8WBVEDK6HVHJhudCL0Ctz9bLI1g6cAyw290sJ0NCOs/caEL4VAVzOnP3RrS3yCmFbw
         m//rOcMHBnwz26IgbPGFzD2HID7juFuzP496cF9v6Zpe4mI2xd4AIUvxcZAv8qruJd4A
         2Vaw==
X-Gm-Message-State: AOJu0YwyB7lAEDO5p2feP3xQ8JoeZsa8XCbXWHMlldJMiE9jv8WRRh7Q
	YJLoPmvTVSYpRlWzBXLjZ60PgTAueXbOilGas1FPy4npunWmkQqm
X-Google-Smtp-Source: AGHT+IFmteV6QcMkwcLvoWrAbxzXbTXPEKz8uD88/kDBh4zvX4Ff7Pu096JAki/XNnJe8oo8yXlF4w==
X-Received: by 2002:a05:6808:218:b0:3c0:3b90:ae24 with SMTP id l24-20020a056808021800b003c03b90ae24mr311493oie.24.1707955048504;
        Wed, 14 Feb 2024 15:57:28 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id mv3-20020a056214338300b0068cb4ed4840sm78127qvb.62.2024.02.14.15.57.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Feb 2024 15:57:27 -0800 (PST)
Message-ID: <bfb2446f-69e6-41df-9fb3-10eb4308ea0b@gmail.com>
Date: Wed, 14 Feb 2024 15:57:24 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/65] 6.1.78-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20240214142941.551330912@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240214142941.551330912@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/24 06:30, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.78 release.
> There are 65 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 16 Feb 2024 14:28:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.78-rc2.gz
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

