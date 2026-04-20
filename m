Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B8A37FF77
	for <patches@lists.linux.dev>; Mon, 20 Apr 2026 17:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776705185; cv=none; b=Tnz1DhxKKrnuR22FHAfOMP9t8BuCGUv0TQag2RsqvzmKIdPQhz/EBUSKNu1TzvyC+V1arA+d5OLrjw+sJ6PpOY5aqj4TLJrkI99JIhLUXNsFguSVGGXrN8aJ3oNnHqCrmmL42tD2waQgmNzlxK01Bp1qUZxJlIO1Px2YC674d7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776705185; c=relaxed/simple;
	bh=sNwBkCu0yCcSfgkhjXDaH72xkksLZyxARQi/uB3xU5M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OVOrSEvLYAzwPMrBBOQTVDwK6GUYrAt9WcyUorQg8/M5dETidzO/l57IvHV4bG2W2G5024rcR+rhdfDJZnS7SrDSDTig4UHZ18I5BPAbyEscXHMp3fWMtH2Eo0f07z9hDswQN8TrdWGGLeu0vEwpk4xJvWedTolTJ6Ulj44IX+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RihDZ51h; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RihDZ51h"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-8d68f702851so397470885a.0
        for <patches@lists.linux.dev>; Mon, 20 Apr 2026 10:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776705182; x=1777309982; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DScRbgqG1JwMR9u/LCfclB/57bY2SHk8XxzxiX3DR3A=;
        b=RihDZ51h7p9QWWJAmX2Z94maef9agWv2LhnzgdVFFSsnDfZ45SSLsnrji++B/qt6p7
         2jXtQUKvs0F9qXE+v/4FvU35Km3CrZGqelCmJJMsY0fNlOhCaKOH9/5Vgq/1MNT9HNVZ
         i3tAghLcLtIZOuGj6+aYwkmhUlxIg/X/U/lw2TkuIH7Lx1ViIzk9Du4aI3BxxXkx/Upp
         9WIH0uv6Co+JhK+JLJPa2WxtjdXKbPAZRmcTs9L2QZPuAznMTaf9U223L6YMyMSIQSQ+
         4R2QGf8ftpkhwfmlhQrmwyGZ+yA7RFR3TCewe+mLUafkJRQxETLZm9F2cju/XSqcMfiM
         1f6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776705182; x=1777309982;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DScRbgqG1JwMR9u/LCfclB/57bY2SHk8XxzxiX3DR3A=;
        b=hxpggN9Yr8veL/AbfGng72g+aRhaGL83c00WlDCCHxUbsm45bib95c3H6LLNi+qw6M
         T+ChEEKA1EQIa/Rxwj4F+JYpB8zl5br0mB7UmOAsExcKAv0NwEyIRuO4RparBfldSjY7
         pQ+Nvypl9Hwifks8WYBj72eK5d76T4MMzeq5B8TMoKp2AW1bKdAwIUjB3GiEvbJyZ0RM
         UPuklS/tEbzrViIdvS0/v2oFL3Vdrtnj5K/Tzx9ZL7k+h7OHk38q+jtLYUmxACIXdOL+
         qRAxFwQzfdAd6SV6/z04Gh2CgP4rrA3FjdIUoJGzONGmDMzSfgvSF7bzYvgUNk2sw8iP
         gHCA==
X-Gm-Message-State: AOJu0Yz1C9A8w61G7q24n8YgK2fj7WRuxtzqM8BOLe15BD4H3r4f9rkj
	BKriR8GJRjObPey/ibSAuxPGGh6SByInIzEMLPiGz2EF1zvycl/WdC1E
X-Gm-Gg: AeBDietjffpKXZkhb5YnGvEp0x7Vt8oHWHw3wj87gCBHTjHsW5a5grZoxhucD+GmEdR
	19js1V3VC6e3oY1b8nOY06A0IcA7W0cCjG/56W457xVIRpidvymTxfVNeqkPhGKZnDIf+XOX3nc
	g5MRQUno4d9517vsjkmQ0wmhQ639bgCHB7ZVDC7Nt2/9yEqc8NwfsnCk9ZIxNc7Vb+MoLIztvi/
	9naCw/sbogZd5QMBwm9mDcL+VZJ/oLIr7uS4Il1YbxusSnSemdbJEW+2Xpvi83QgTngDuIAmIC5
	i+syZQ4MzvB3w1ODwhmO/WV8NDUnMF/kw6o8ZieyafFSZ9JpkJHe3pX6u/cnTKw8d9gHNxqN2us
	qdmUZf3eGpgmOuUo6QJk20ul6PlyO2KmrcOuhMvsukpvDu2qH0ztHiE6DVWW7YMeTz0uWE8top5
	YiBeSmuqqVfgQfRycOk6dSJtbPGYaiaEhYBq0O+TV/L4vojA==
X-Received: by 2002:a05:620a:4456:b0:8cf:e1c9:b286 with SMTP id af79cd13be357-8e78ed5dd31mr2013867485a.2.1776705182384;
        Mon, 20 Apr 2026 10:13:02 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8e7d5fe90a4sm874099385a.9.2026.04.20.10.12.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2026 10:13:01 -0700 (PDT)
Message-ID: <d8e99823-9296-4b9c-a26d-acb16d58ad68@gmail.com>
Date: Mon, 20 Apr 2026 10:12:58 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/162] 6.12.83-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260420153927.006696811@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/20/26 08:40, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.83 release.
> There are 162 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Apr 2026 15:38:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.83-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
