Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201011F76B6
	for <patches@lists.linux.dev>; Tue, 15 Oct 2024 17:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729012160; cv=none; b=Dzo6WFaPWoFdf/jPAYDdjeVF7IzLy9FT0O3mEvjB86yyg/ZWv+AxVGS+3ZD9T+I7qn7AUvhfOv6RM2AMhERzQX4inJn9or+y0K0ksaEdqOjKe7jhFbWkJO2yyvMWlC5tFEMCAve3xB9d/ebKGlhCTbPEJJVa+R1U4obG0ed0SQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729012160; c=relaxed/simple;
	bh=2jEfofjLLXsbVn3Qk7TOhtnVJiZ+0bg5SNgAIipE/0g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=effZc4FbWxScvK0lvbx39t9f2uDl3ryc+62GeetK+TWez/2Z8TNlx1e1RlYOS594rWd5l62mCzHT/Uc1WhSMM6Ogb4f/kDUyPwUSPm9iJiToUgbszZFEgx5PFbH2KL9abjyv1sEHDV8dePOVTp0L3ATu323ZNPlWC241IBXWK7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W3VNISXF; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W3VNISXF"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-7ea76a12c32so2511599a12.1
        for <patches@lists.linux.dev>; Tue, 15 Oct 2024 10:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729012158; x=1729616958; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=kZW7qPApC+YS05ogywd/EsqmtRYtB5s/YDB0f/OMcsQ=;
        b=W3VNISXFR+PRhCUauW8uX3su0euHLXrbG3WGWD9WzlzEypkPHQq13hzw5XKCiOWLx8
         ZyUJXp3smJ57fiBjAIUA3wZ6kbfx6VzWVoZ1XaOqoAv4Wqg6+YxJU3U+2xgP82nq0gN4
         2oVZmLiBWh4PwbLrQC55jvDhG2D3sB7S1z+haLUAYXhF8u3dQLa7I4zhbSm4Fx33hlvW
         09ZOOqQO9uezPMJxoxoYI1ZQCF2K/Ce+8JHO1zc42G55g9M78xcimL2fENIdobI2Q/oW
         99j5IOaA6Tf7NnJKg6X1wPtdSMCPHg6uPm+z2808uJ3/v7Zp7O/XNuePJ9KsPyTEu1xU
         oLWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729012158; x=1729616958;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kZW7qPApC+YS05ogywd/EsqmtRYtB5s/YDB0f/OMcsQ=;
        b=tw8Hul+riAE6ZhKwSw7q9/KdZYQZX1ARM3wESM2A8s3CZg2sKcBFh7/wkvoK6modkW
         IfqJyRZEyUmTIMKjIfGHL5A8uOkgO/OhJPJMYdAR2SG9OTj9VOmGwGSZkBH/PfojZSCv
         FZ7JiT32FAChS358w549vruxa2I6kPc+dIaQlBsBOgKWUavNUbXctXdIxRdI/OxTXaLh
         8o8ix/NKApiv0dRa2DgDgJPv/XD9feiFgm0hBM8Xw3YHzPRnHSBospo7XG1ckbda1Ptc
         9MS1jHFAvdz2bGEgjEDktnqm0ET1ZkSB/BeVOoFMku7iP0HA/1130tbJh2wATc7wGiul
         7tqg==
X-Gm-Message-State: AOJu0YwpNdaILhUVG0830fi0wFrJyPFsW/iKlYpQbdrzrOlCtruQQS4f
	h8g4PJT+R0hajVT7/dCDspdZfHqfcd2/o6fOvI3OBR80Ibe2bpvx
X-Google-Smtp-Source: AGHT+IFbZsTjelVTJRQ3Hukm3pqXejyaolWivijKFWjULKAapbgr3hk3GeQpZtYPgqG05KL9xliLGg==
X-Received: by 2002:a05:6a20:c997:b0:1d8:a29b:8f5e with SMTP id adf61e73a8af0-1d8bcf17375mr23459913637.17.1729012158313;
        Tue, 15 Oct 2024 10:09:18 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7ea9c6bb998sm1417200a12.8.2024.10.15.10.09.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Oct 2024 10:09:17 -0700 (PDT)
Message-ID: <43399648-ea75-4717-b155-73541deacaba@gmail.com>
Date: Tue, 15 Oct 2024 10:09:15 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/691] 5.15.168-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20241015112440.309539031@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 HGuUuzv+GKZ6nsysJw==
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/15/24 04:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.168 release.
> There are 691 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 17 Oct 2024 11:22:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.168-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

perf fails to build with:

   CC 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/util/evsel.o
util/evsel.c: In function 'evsel__set_count':
util/evsel.c:1505:14: error: 'struct perf_counts_values' has no member 
named 'lost'
  1505 |         count->lost   = lost;
       |              ^~
make[6]: *** 
[/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/build/Makefile.build:97: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/util/evsel.o] 
Error 1

seems like we need to backport upstream 
89e3106fa25fb1b626a7123dba870159d453e785 ("libperf: Handle read format 
in perf_evsel__read()") to add the 'lost' member.
-- 
Florian
