Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A004F1E1025
	for <patches@lists.linux.dev>; Mon,  6 Jan 2025 23:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736205499; cv=none; b=J33S6jU/59lGWGFg6N5lniTn2O1yJvtz8pSBCJbt1iPSHfOu8rLdrLr2UNOYYn6g/lDFm7weaaEvkYLKGGHjAAn/Reh0tWSce+eF2oHAXVyvmBDjsz3Yl6mMfMP9OfbLnXpYZToBkgJWBtpEAQLAV63zTLD7ZZSmuPUmjD1ZY+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736205499; c=relaxed/simple;
	bh=gO2Bm1IZF3AWN3dj/3Xdr2Av4Jtxxm2g8RH7nthTdU8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D1RV0UZtAjSSOSveWHOSs+4tYPFz71J3e7Ou9ftNSShvuFpH5zyK1tpIWMbf3GDnJDvpD5Ac084THB/Y1w0zNk3U7orwcS28qMVt4MEi38Qzim1+0s/neOzCYlK0D/YZC0l3sp7WOhT5hZsPfmjNuR8IBZGTxQl61SqvxD2fYn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gfzb98xS; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gfzb98xS"
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3a8c7b02d68so118560065ab.3
        for <patches@lists.linux.dev>; Mon, 06 Jan 2025 15:18:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1736205496; x=1736810296; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YZAGLmj9Hq6ZyNiaxFkgAyqEQnJO2cAbCGC7nBnlbbM=;
        b=gfzb98xSRr3Ryun7UZFK/qQ5DSjvFNkTSBvQiTsQ0AXyibhzUseBeGxuAG37rc6dPR
         e5kr4RRzHsTwzbmN3xCTMWjFiaoGoy8CA0FXTkrOtug/uL6fEr1Dcj5ILKKUm/kBwFKK
         lWIOyPBLYAvvSFiR7cHDqjaZvMDRgjArGWw20=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736205496; x=1736810296;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YZAGLmj9Hq6ZyNiaxFkgAyqEQnJO2cAbCGC7nBnlbbM=;
        b=pp1gpWSqZ3pzHL5xOV31I89iJd/jAwDQXXUZM3+LpIWaIDsYh9VvMZHO68JsPEZRBL
         89E8FK7ACZyc+a897/nhBaqo7xtwvLBxF/gX/Jy9DQ0Awqu4MTbNlH72+scou4MSvBtw
         ChG96iFn8FfqpGT2f/k/ZWjck61wgMhLlyB28vmUXBJJHXoDHSvC+C4qVI9isWkRv9eP
         TKQnCLjfVXghnYu0jUPJ00MT2F3jrJuJyA3qbiOx7trWqlZdk0mq1f/4B71vJcgQ0ZeJ
         Z37gXpEwK2lhWOwU2ed+QLsHUf9NEvyZFGcwkkAgc2guesIdvDRj3k0YS8xqw50nSEaq
         FFOA==
X-Gm-Message-State: AOJu0YwRBoVvCsIZOBp/Jw9FZBHVGyE0/FbnchNfJ9RJ6qlVQPIxaz8h
	Xww9l8OWqFUQ57F3/I2ix2sFryYDnzI78Jh3s0Fn5eweFx0fo+hcyDztxNmVYrc=
X-Gm-Gg: ASbGncu579P7vvUZT9CrCEyiKJo2/4KuHRS+ghM4sFW+6PjwCL1kqUDUxaLmqFRgZ0T
	bq72npkVSs89ugP4ynTdz3SGxdJFo7yJwIOB1xHV/uC/jvqJYIrttmvm0ztABuJjsbjlSDwf1TQ
	Xmf9HSpXv4tYsN7rm8d+z7/txPQNNxaBWdW+pul6REoziX48HaOMvImgsqUUaw8BsWkpL/hSeky
	KUAdxKyShru+xb+uuUm8NcOVLLYsq+EbufrZF+jmmDHZTt8Zb0+STYKrvYoslvlc6LJ
X-Google-Smtp-Source: AGHT+IHuFKZJjaLxLujpfcuZqDgfl4m/olLWGIl7JgnrVzG5vQ9yEEu78XPtGOihdsgSwtamgMbsYw==
X-Received: by 2002:a92:c24c:0:b0:3a7:c5cb:8bf3 with SMTP id e9e14a558f8ab-3c2d277f5aamr476694085ab.9.1736205496621;
        Mon, 06 Jan 2025 15:18:16 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e68c199922sm9743651173.103.2025.01.06.15.18.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jan 2025 15:18:16 -0800 (PST)
Message-ID: <5c3ac106-f18e-4237-83ff-52398839f635@linuxfoundation.org>
Date: Mon, 6 Jan 2025 16:18:15 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/156] 6.12.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/6/25 08:14, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.9 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compile failed during modpost stage:

   MODPOST Module.symvers
ERROR: modpost: "i915_gem_object_set_to_cpu_domain" [drivers/gpu/drm/i915/kvmgt.ko] undefined!
ERROR: modpost: "intel_ring_begin" [drivers/gpu/drm/i915/kvmgt.ko] undefined!
ERROR: modpost: "shmem_unpin_map" [drivers/gpu/drm/i915/kvmgt.ko] undefined!
ERROR: modpost: "intel_gvt_set_ops" [drivers/gpu/drm/i915/kvmgt.ko] undefined!
ERROR: modpost: "intel_gvt_clear_ops" [drivers/gpu/drm/i915/kvmgt.ko] undefined!
ERROR: modpost: "i915_gem_object_alloc" [drivers/gpu/drm/i915/kvmgt.ko] undefined!
ERROR: modpost: "intel_runtime_pm_get" [drivers/gpu/drm/i915/kvmgt.ko] undefined!
ERROR: modpost: "i915_gem_object_create_shmem" [drivers/gpu/drm/i915/kvmgt.ko] undefined!
ERROR: modpost: "i915_gem_object_pin_map" [drivers/gpu/drm/i915/kvmgt.ko] undefined!
ERROR: modpost: "__px_dma" [drivers/gpu/drm/i915/kvmgt.ko] undefined!

I am looking into this to find the problem commit.

thanks,
-- Shuah

