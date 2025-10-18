Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7B32773F0
	for <patches@lists.linux.dev>; Sat, 18 Oct 2025 03:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760757030; cv=none; b=Wz+9VrP8SNTpm/C4feRi3MejunF0WTVVCQmdVLyIJYDIHya+cxCri87YZQF9OFTx7Rmfwg5neTHr9IWKYF/SDF6UCdewfVDos41eVj9H+W5ka7RinFHlr63B4qxc8Jfx5193Rnk6SWa1SpyGf+6Ddv4snL6E9KbuhZsx7Bwam8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760757030; c=relaxed/simple;
	bh=CJQ76v/E/PHDdYgbR8fro6XXoFI3bbatRfKPbnF54mk=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=hgW/fiWxl1a01AxwsEvxTH5zTd1uQMgALhEx/s9QS0AMfboBP/Kd0mj5DUccA3wU20CiYBW3fIAmJxBTDJtTBZq/fvORY+1ttZ3MXAk6ZcwRku5LtaP2dnIJSMm7CpS3qlljebPexOrf0m0YDRY7ZdwD6EvKLL19JzXGhO1YjSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DbamPGo4; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DbamPGo4"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b5a631b9c82so1684819a12.1
        for <patches@lists.linux.dev>; Fri, 17 Oct 2025 20:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760757028; x=1761361828; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Jf3FR3Gwahm6tMjH47zEEF5nx3T+VLl5Q8klA7mB664=;
        b=DbamPGo46gDL2960kW23IJxaGTnRXh46G+8PzD9FwlbHpCSJdxuuaOd4q7+eHb8vA3
         I1FrPy07C16V0Y0/7wC9aMQ3+llrPpNfN2VgMgdohL66QfjFX7VydDPSLiy5jezOHuzS
         uL0QWz41vzcoAS5qXO4bD2AN8AntnS5tkmbiM2+xOrH3ysePRkMpenZjBWdXW4mBdQsH
         VRHXOeo5UZ6hhKny/StaUVDnktn+NmGEPlTEipA4jnK5pCLIYrFaFVN5llKXm9siE1ur
         P8xrXJ/CbWgXuTLAlqwoRBxALC3ZTevspBh+2kc9NSqpg2o8uxcyUciteyIp3ENU1B9K
         905Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760757028; x=1761361828;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jf3FR3Gwahm6tMjH47zEEF5nx3T+VLl5Q8klA7mB664=;
        b=IX6dvKqTpT/jFuXtK5+bHbXe6OWzFYtfq3zsiZrnyXliWiEN+eZcFFCdJBWnNOwsIm
         VuIGk2epdxJ9/9CBe+LQImOLQYpL0iOLR2pSOJM3sP4lqFIdGcNwuu8Se1iDoaUlD9FZ
         +OXuYxl8jDyYhZdILYPIzs6LArhQ5MjWbxECScuyDtss3TCVZSUm20u6IUgdko/vRqkL
         HvlXbbd+h6noh8y4aAbVgVJuIQ2VgRl7nD7qYDkXLp7odkVUadFhhqmGoWl5X/kUzj8J
         dFs6P0lYiZ/2otoiutz/fi2PV8plyQz+Uegr8wIB5CJvZIq5g++kD9fIoPoLayEllgTa
         6khA==
X-Gm-Message-State: AOJu0YzskQyfKgPM+fLn0JrWRI9IrlHczLJFdNufBi+Xzzv4jpF755c0
	4AGHljhyCjyFugGT0m8SUUqvt7FLLudu24TOymDtxS8i+LH35q5RFJk/
X-Gm-Gg: ASbGnctgbDmpRl55x3A73+t1b0GN+blnuRczTL1sIW1VkLME9Rgk1q3pFz4GMjVjqGy
	hbSnFPSnh1Uuklt1CfSuhbU2OhMhvYE8xGXBRhXIWk7ywm3aJehEihQgweQWKgE0yTxkGQ6964m
	x7QpmNGdM6MKglcnXqYsAV4fi8qWSm/b9gQgc21rwZ+1hjnTBX886lrqbXelyGggy7ifDQBiI/e
	/B4DAAibWcTCykd0SYht2A+9ma1XSD/waiKtVdiqzG69/g6Uh1Fblyx3feauMszrFeGXI7JyuSJ
	AxMem0t3EaU9xwCrMgPnQJKRoRLFdjbAUPep2H4NdFbRSfg19DYpaljlAKF7I6hzLCdTlht+eyH
	+ffjyF7G4TkpHmmrdw0miK7EOy4IMxDfophk6EJfnxkOwZZo2+uWFN9JNIXC/qwRXqHEMxju/ZR
	3QLFGei8tnHIkH0w3emOBgFOjY8ABJEiKEP2UCbhp5Ww23NTvHNB8g
X-Google-Smtp-Source: AGHT+IEhbwIAKfabrUVIFmF5c3f4H0tzASZNULyMLnrkF3+58Kx389FBrjyRdsSR1s0BEE1Eo4vI4g==
X-Received: by 2002:a17:902:e549:b0:28e:756c:707e with SMTP id d9443c01a7336-290caf846e1mr76225645ad.33.1760757027966;
        Fri, 17 Oct 2025 20:10:27 -0700 (PDT)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-292471d5868sm10321445ad.60.2025.10.17.20.10.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Oct 2025 20:10:27 -0700 (PDT)
Message-ID: <a7fa59d4-7c81-407b-bd1b-d6910f647443@gmail.com>
Date: Fri, 17 Oct 2025 20:10:24 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.1 000/168] 6.1.157-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251017145129.000176255@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/17/25 07:51, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.157 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 19 Oct 2025 14:50:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.157-rc1.gz
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
