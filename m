Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25E917994D
	for <patches@lists.linux.dev>; Tue, 28 May 2024 20:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716929860; cv=none; b=hapWRsJetwsTqy03kG/J49RCLQaEC55qkfHhG2F+MmZDhZFt9sUMS7T+7aN0oxTQZ1MqqH3a18WKu31TMydKvg3rZB7CJAJqYOOuSFOz57FZ9e2f4DeyFdCxjfmLVZbt9OlOv+8YDCNP3hnBs8UnJRQZdaCJW45e21PyJMnk2PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716929860; c=relaxed/simple;
	bh=Y3ZBHOPIu2u+nsoWmsODdBPCJTITCXogegxmExBptRM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s/3IsAFgr6wB6EIZWhoJfBfPFGZG8mv5syYEOFSp5rfRTYbsQNFrnyqR4OPzBXaRZkGrmisj08oh2U6ttLn5reooccs3OUWccm9NYU6Mp3TREn1qnjJ26+Lr5IaeXfW8i8SVYvtRoPc637iCAraRb0nXO7ZWLIIPCD5qKZJyL/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fkcMlxAb; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fkcMlxAb"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6f8edde1013so1099077b3a.2
        for <patches@lists.linux.dev>; Tue, 28 May 2024 13:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716929859; x=1717534659; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7mRas9wPp85C5J0VZDAcnXYBCgiC2lkr+yBEWsgNvL0=;
        b=fkcMlxAbzAPc35dtv51fxBKCXVJ/rTREvJkmhUyjnVnAPxAfF3HvhL1sUB+0YNViCK
         Ons3tOurGF9VB9t8ImUEv+gR5UTpFrG9DaWIf2ezmxl959fIGDBo6No0bBuGiFKHgyZw
         Wf2aG0f7KVtYJ17YkV4U7SLJmRj2vilNUNd0nC/HZm5mc6S6uQLgYP1trV9YnZTLyH6F
         utpfGimsgLzQiAEDvPOs81CHRsFDU7hcT68gMCTugj0+cVTXZD0zqYe2tmGQ7o9zEs/q
         jR3+3x5eV9ONVjbI8uG6CJDumIrPOaEhGj6w9PG1BSDjO/FfhVOmjWotH+AdD29lEFbq
         weog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716929859; x=1717534659;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7mRas9wPp85C5J0VZDAcnXYBCgiC2lkr+yBEWsgNvL0=;
        b=MY7eEjtskDaRwlB6zHwufFpNwcyXeijFAFYPVBdnzXqhBf1dcwm0kXHzHcvC0OlLqJ
         JzGeUFAaEBTgfWMaKk5fCgZjjDdY4+8sk7AyATPEdNVoKV2uIkVErGcFCRcu4kUgZJX0
         hrBRS48weG+WOsDmspcIILsvdZFF4FIUlEds3idsTJiqnNjYm6tjOjQ5ZaQxsatIZMQw
         5B5hTjQ06TAW6kd4yA6xjMj+7nWbcp2vKxSp1YaSABuV6SLiZjFF4KNyxdYcqMjFMuXP
         lHcAfx37qtmUDKYIZf2rV/hUTfUwniqScjgaFVpJZijRowwK2TDaStn8qsM4T1RgbH5H
         MuBg==
X-Gm-Message-State: AOJu0YzHnwjhpCG4WwhNH+Uk7ntcsEW6C9qvetYN1ocYOxd/v0CFaerX
	EJn8CUHFc0JggUFmOmHWhT+kqqnb4a9pcKKiQC9VKICSpjQ/UR5e
X-Google-Smtp-Source: AGHT+IGpXKGory1d47XZFSfaFNvBieFbxtFg+9wadqc1f3Pz8HegJA9FkiEvGJSY7Wy1L0L9p/FO+w==
X-Received: by 2002:a05:6a00:6c91:b0:6f6:d789:285 with SMTP id d2e1a72fcca58-6f8f308f94amr15921761b3a.10.1716929858781;
        Tue, 28 May 2024 13:57:38 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-6f8fc155bfbsm6843362b3a.74.2024.05.28.13.57.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 May 2024 13:57:38 -0700 (PDT)
Message-ID: <6fa88a74-4c21-4d43-9961-9808438c2319@gmail.com>
Date: Tue, 28 May 2024 13:57:36 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.8 000/493] 6.8.12-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240527185626.546110716@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/27/24 11:50, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.8.12 release.
> There are 493 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 May 2024 18:53:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.8.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.8.y
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

