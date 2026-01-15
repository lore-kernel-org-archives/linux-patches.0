Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 835A232B9BD
	for <patches@lists.linux.dev>; Thu, 15 Jan 2026 22:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768515292; cv=none; b=jHGaJk4Q32tAWtgILZMGw8UZ6PW753Yz0dan7WeAk0vKZ6VkZPK/RQvB9v63J3/Mao+90W1wNs6u8IG1nY4wxVCm1ODVyynpfLldHuf6zF83eGLfNQqTY4TZmyUygm7sRVM6l5RlB2h0hmqX7Ke0T8HNNCwon/dYsRAKNUHBlcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768515292; c=relaxed/simple;
	bh=vYqybl/OXg4s7EVnnOq0Ov2iN5/Y0nfO6XmXgwJCpD4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ssiNfXn8UuRhuGySv5P2jPFYZCbHsVI7w2REQRaysLs0ogseL30F+s78xuD3dI4fOrIv7/akPPT3LSmDVb7TQYgbwIp9tn2AbTzU7jkZl/s6bFg9w+g9ihinuweWBg7oArJd+xu5+kO2BLAoAzBZ9kojOfO/frwB9U4xYMtEalA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ETxuc0/S; arc=none smtp.client-ip=74.125.82.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ETxuc0/S"
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-123320591a4so1494508c88.1
        for <patches@lists.linux.dev>; Thu, 15 Jan 2026 14:14:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768515290; x=1769120090; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WpivhtXYXF+CbF7riMiVosJzkbcZY0t+v9F4mqZiLjU=;
        b=ETxuc0/S0uevQQ4y8BHv+rn96QrAVdiKEMtTlXeD87X7UZCDQIVdZXAQqqH7ZlnwDW
         QwFIGD2P8iwYHppST1w5v4VDuHl3V0xeYtMEK4vCRUklj1GrVy7r8z7LllpgIcT66aOC
         ZBLI+ctVoZARtzg56VRyu7XTKyVloHBP8hQm6guqshjGLpnlE+RjuIdfEE4J27jb4Asv
         3Obb1ilcuFFLIfaOcLpH2AVO1Jws7heenaIaOv7QF/eQRcL9aanFlLkGIOtE+9tCw9Po
         tu6hUUzb+3NnELCzef5+eB2R7t0/StF1e/+r0se+fVGXPjasohapTX+o1uMG99VCTcrP
         GyVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768515290; x=1769120090;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WpivhtXYXF+CbF7riMiVosJzkbcZY0t+v9F4mqZiLjU=;
        b=JltT2TGDkVTnQ6mtGxdvhbrXVWhNCchlE/hi06uVnMU8hM1vLDI7+Y3Tzz0MRHIQpw
         godmJfN+Wd/TZM90PK/UBmp1jk9cN9X31qNDyzh6BLsPGndiyzRz9yiQx5E8HLT5LLKp
         ElNksegZktn/Ou6CFyNeomTqZZXZLnEHNi2IyUZ30xN+RwvYtOaWrgVw/hyugy1dcWB/
         Gon8EqQHOGO2RhZUrCfKZjlQhJdcPn7FVVzB/zZdm8XeOCfIvOGK9CLVx4OF3bCUDE5W
         EZdKhDQDUsYs2NTRWRve/ugP4t/mbwhDFUDfdMEu4qdXps4qQNxVF4xlsx4BQ8tG1/ym
         gV3Q==
X-Gm-Message-State: AOJu0YxWGb+XXJn56SdbFpkHOfLbSa7xgioOhgmemgKbwNI5BBbktg9R
	w63NPEMu2BPqZHCdioGt3uRkzMx/ZdKHV8IxWarAWbHLYOJOGXQLpGmb
X-Gm-Gg: AY/fxX68qLJxFF7p1hQrSCf3tlhY0IB7gEynFowfcHElPUhX0Ypdyzayig3F4s0ShDn
	fgdEDBnFci/ZwGGS9eDIplsE2RvchRyvQosCywE1Acspwyu8jo4CPgQ9QiK/bE3JMj5F7yKgJGz
	QqRWHDOHxhih8O43HUP1iRAG0A/PTbkGERf1qhCrV/mZZ8c3BV/n4bJ6CZyUlqd8hFCbtUfvPhe
	f7OZ6javmyB2nTqfdfLWawx0U+YUrbJyBPRhqPjZ0xXpzhyxRYUDLFSZ2K1I72ctRGsYokMI8Ac
	3xY26cI3UchkRWBQ+9deJ3LbJT3rFs4n6ejiLU9UOvXE6Ds2YK+jvpAVejLfT0NmgrMX+AfI5Ku
	tdK2tR9Ycyq+YLHRrYqdsWmvWRyCxpcF2Qem8swqFihLaT0onPORR6ZBwk5O4JQrOcR2HeSxg3x
	XceBM/zjPj47YRmk1NK8Ptw/bG0KfpTUQt8DsFUA==
X-Received: by 2002:a05:7022:6085:b0:11e:395:7dfc with SMTP id a92af1059eb24-1244a766f7amr1197969c88.28.1768515289267;
        Thu, 15 Jan 2026 14:14:49 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1244ad72063sm841918c88.6.2026.01.15.14.14.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jan 2026 14:14:48 -0800 (PST)
Message-ID: <4fcad9db-9dad-4fa1-9d6c-b60e253d73a6@gmail.com>
Date: Thu, 15 Jan 2026 14:14:46 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/72] 6.1.161-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260115164143.482647486@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260115164143.482647486@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/15/26 08:48, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.161 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Jan 2026 16:41:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.161-rc1.gz
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
