Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB5A249EB
	for <patches@lists.linux.dev>; Tue, 27 Feb 2024 18:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709058412; cv=none; b=sqwNhSymHzEDX6/fJ6zoYqUe4YCs5vv/TikVNcF1LgEbdxAh5A5DMS3WGXTqX1aP+mUUExkwFpGMRazyqzbQm8YW3D/2+CYqbtmJmzwzRuzVyPwBI79C02OxmtePyAaNu0gR3zJfX5Hdj7syfbPiYgX9Wil7s3u5I8BkUmwlh5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709058412; c=relaxed/simple;
	bh=8XWj6PM1lzfc8uwHWAFHpI9lOjKvzxk1lGQOsb+8dyQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OGxvQq7Tudsaa2qDue3/DwSJ7/DpkXF5X1/JmMpGA88T6IcRLLHD3AVg8mio0AFjdbzWD4HRr4rm3ltdj34utiLeKPYLO66YjxIAQpJlVuY8EGdRq0V7dQnjakPNt5OjvcUnlLe+ukH2o9vGsE9IIq0vwecs09Et/p1v6BRxc7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ACjD/Gw5; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ACjD/Gw5"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1dcad814986so17556485ad.0
        for <patches@lists.linux.dev>; Tue, 27 Feb 2024 10:26:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709058411; x=1709663211; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6Z76EBq7m1t1xBOj0ctPbx9Wsemqc1cbGv8gFCHa6F4=;
        b=ACjD/Gw5qF20+BN4uXS2FRwCR3D2791z5K/HKCJjByIeNByh3VC3t2MZmb04/4SBXE
         gz7l1g82adJ7/Dzbo0XZ/xQHyHFxI+SOSow/lXI6dKIwCMepJS/2zuHwy4chytkVq9yc
         f5CWmOn/t2HYXAZdMuEvVSQUNq4XkVXnrpR46CzY0cxOQo4zmyjNNSQ/eMp5uxBwy0TA
         SnCJOc1dS12HAomRh4XD+KL6s2ddqgX3jROoIkspzza/R5TlBoXXCK1eIWZxE3snivLp
         OEmc2VpF68sxE1zAAot1AGN90jDhTI4z77mZ6FteASp2gwc8Giq3XHCP5TQC545jzOsk
         +ysA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709058411; x=1709663211;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6Z76EBq7m1t1xBOj0ctPbx9Wsemqc1cbGv8gFCHa6F4=;
        b=Msqf8h8BVSFIVVgoJFUvKRvJza0fhV/kUzZYCSmvNSfiBEhBCxig17c9Gxor+dgSpR
         wc1IsxON6qUabLeHKR1Nx9nj+jEucwqs/SIM5RniGfSrlPna0BDpVVEe8SAsL6/cwiPM
         dCdq2F8TgFH5IJE70DFcQYmvdwpMMfGoqaMaE9odqiAJYP0PiN/mQMNb+TP1qu2TOlSZ
         Vshh2AuKk2plTWNBZiT4fxJG6gj1kfX0E11k89yNJ9dOIbPqw25afeiQTfAhC4BbCgJ4
         sYIUoWls6p8strAAkoPWVL2v6435LajZJktU+evSck6CNHoMXJYMf1slGtWTEY9E8Z64
         NzFA==
X-Gm-Message-State: AOJu0YxmZcK66a/5i3sq6sb6dvbRPGgbNnP/l4zaMvI2KAD6JIU/vDAI
	UTEOSc/9ayOB3W5mENdxxBKWawwcRlmJ9CM7jV/cEGLTu6ZVnVIE
X-Google-Smtp-Source: AGHT+IFdU7nmUgVPR3ujHtXkL/DO8Zjq5jDL4faVgix98nSdwlnODv1Ahp1XImqWmFlIZKq64EYHsA==
X-Received: by 2002:a17:902:f690:b0:1db:f03b:6f5b with SMTP id l16-20020a170902f69000b001dbf03b6f5bmr14903685plg.56.1709058410715;
        Tue, 27 Feb 2024 10:26:50 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id lc13-20020a170902fa8d00b001d911dd145esm1807639plb.219.2024.02.27.10.26.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Feb 2024 10:26:49 -0800 (PST)
Message-ID: <ae07fe47-15cd-42d3-9992-cd5c5a3d57c6@gmail.com>
Date: Tue, 27 Feb 2024 10:26:45 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 00/84] 5.4.270-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20240227131552.864701583@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240227131552.864701583@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/27/24 05:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.270 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 29 Feb 2024 13:15:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.270-rc1.gz
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

