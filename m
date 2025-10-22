Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B5915687D
	for <patches@lists.linux.dev>; Wed, 22 Oct 2025 02:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761101211; cv=none; b=jIwsyATN59P5MQOOrXI5gniyJlqwxbqgPoXByoFLgbjXGn3Er7rG0LyfYvHP7RtBtJx8ZzI165dvmiLsbrOswihR8NgwNofoe/sWJqptHK1BcgsrGEI8tPvXYR9ssvow/91iLbHH7nZaoTkqbLGl6vClquMX+Z99e7c00BPhyEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761101211; c=relaxed/simple;
	bh=a3CCCdrTWUxuRUJBdeeFVwrJgfSwekbmeg/24eUtngo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Zs/XwIyplCJYrHgjAN13nsofvuFtya4bLhWh/viYUF47o6yAUuDbTnOlZLWgkQMB8l2Id2MZG3n80SUVmvWWumkFEgSRCMuDoFZNa2AlE+URvmi0DZw1BhP67SmXYlLJcawa3dVDjK4L2HQ+kwuS9Kng/pKA0X2+C73POPadbOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UFH8t+Ww; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UFH8t+Ww"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-789fb76b466so5273553b3a.0
        for <patches@lists.linux.dev>; Tue, 21 Oct 2025 19:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761101209; x=1761706009; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PYNRDrO3CybgYbzGCrw9HtMshXI77N9IrEDAL18hksY=;
        b=UFH8t+WwmzkEvkOI+8n+wWnHYcXqvLQUUe2BvxrJ7ZoQoY2cvYUtLSQshXIxrdBpbq
         PmfveaD4/Kx9zcAVQOyvaTp+bJpV9hBBr6dYlFSW/j6f158xl5SpseOi1k4ps0B68BuX
         LmFSBUovY38tnBkJRQFyZrrgODwRMTRg7ZLDxq5iqNjEcdn+IQnYRtlh4B7Iwi37rfTp
         PZytDXRxncx83BWnTHADeF4Myd8FH99zinMe4W3xDzRbZfeATA2ObqtX9JP6ZyBJsI9a
         XhqueX6zZSScoUrtqq0A9otlV7Vu5fFeyxSOtLnchrNMOlZuvjcpYoTgsZCzHyba001G
         KpSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761101209; x=1761706009;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PYNRDrO3CybgYbzGCrw9HtMshXI77N9IrEDAL18hksY=;
        b=ikx+i2cggdNYLrGTSGAKbMrldczRtk3P3z+e4ank7vtAw4+AaL7FDUQ2lU298zlKbf
         VNrYjgn3RJg/FaPhceQzSjo66M3tFI9Mh/YLsBJDmfJuNPptusdT/jR7/SwZJLm5KDFJ
         7MO8izIaY6doI49I13RmiPQocjQPd2iZYN/lwUlz3g6T0eB3d3qG318k6azcYn4LroT3
         kS1IQCkU0xY0o2Z6Zb/D+7hFjg8qBF0GrBsEdkU21tnL7lCpg+tPBq30t1hD6R6hQ1nl
         Mtb49NlfW49qjCHcxTQVTKv3Ho0C7Q5vcY6zEop8ssuRZdQo1qlVYHIw+kEv740Ckkmw
         KQFw==
X-Gm-Message-State: AOJu0YwllrWQUeJ1qiiOmk2cZhtLNcIp2nZdR4oMzAlcfmDsGymWLj30
	eNmixLMlMuyxdrkwkEEMh7S5m8Tg7/K49wfxR460OGkGMECQB+DLQyjw
X-Gm-Gg: ASbGncsKTKHXb7ONlGqZpLxikYFaQovy9/aMqySzHN8Y32e7yfZ4Uhu0wwKWb6WgK2z
	+crpssV8HmTGxm55XjeQyTswmPqAD4qY6k3OUfnoNOjW2a3VG6I4Eu3ZsFXmpt4VWmZR7UQuSYK
	/MlkhCCxpRuxeAWHpVjJXbbYB96Y0haSZ5lDX2auAfUSo6oC3cpkWOaD0U5LHz7GKLpmSBJR1X4
	APEY/57YQdjbRZ9Wt1A/+U3927MGDqx28UNok8O4BTX4INjdzJT97XkDv6vZGilIC8bco74NPXV
	R3KFXQA7qEhQxpYvAnjiQIjq1uoVUxFds3EVZy4ubhlv3MC/0G9CZazoz1V/fTrUSAS3MF+ccsA
	itWp4SNs1au8EGL9DPwffiqYPUEsByyDHPzUaZWbgh5NPrLs1NPSE9hPbdAglSFYC/LjZ+KO9Os
	6ofF5LHwUOXXbGDxumETB7qnU05MFpRR5Ei1btwnnN6Q==
X-Google-Smtp-Source: AGHT+IHmTFutYfiBPfh6pKIFfa8WG/r+Q1etaUgtanp0pzTongAxTZzvK9UpNwlCGbPLH2M8H69kng==
X-Received: by 2002:a05:6a00:4614:b0:78c:984b:7a92 with SMTP id d2e1a72fcca58-7a220a859eemr23541047b3a.12.1761101209199;
        Tue, 21 Oct 2025 19:46:49 -0700 (PDT)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a22ff15c89sm13232037b3a.1.2025.10.21.19.46.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 19:46:48 -0700 (PDT)
Message-ID: <0f508e49-f916-4219-8743-0ee7ed12fc23@gmail.com>
Date: Tue, 21 Oct 2025 19:46:46 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/105] 6.6.114-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251021195021.492915002@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/21/2025 12:50 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.114 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Oct 2025 19:49:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.114-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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

