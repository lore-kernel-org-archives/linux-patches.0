Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0BE12749CF
	for <patches@lists.linux.dev>; Wed,  1 Oct 2025 16:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759335544; cv=none; b=fetqGnieTcZvIAcLYqLknHdTVmia5Q8NKneNlMJy+bshTPsgINwvUS4VCtn1WU84QNO1DPRKy6mA5IRn+0sD2UwwE6HCT4qO4N73L3Dm1cfpocU+h1iyh5QpP1iqjXcDTJFG3YfKCAjllQAZmqZ0dEeOX+88+NRAF5bOZP+RhcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759335544; c=relaxed/simple;
	bh=VfIZnBuuXwbK3IWB7Akbz8kdzqSwGJv1M2L6QUoR7uQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TAHwwldyllR1E4d8EAzJqR0binkXpFKMH5FU+wHtCtS6EEtNd9lVn3IGSqHT6CGmQoMHrZ1k56bz0Y1pr3II8lvFyPPSYBELJKV6KQR9N7AyICRcyRcINhI3dD8qhzr3WS0u5iNHCX+w0Q4iA6BpfFzruz3svLsxtTcVxglgNds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gX6VNpsG; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gX6VNpsG"
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-42571642aa7so225525ab.0
        for <patches@lists.linux.dev>; Wed, 01 Oct 2025 09:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1759335541; x=1759940341; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=310GXMr4EGkw4tBWn7jL9r751VwpOohlwnfgRE/DlJM=;
        b=gX6VNpsGLCIrH7orKr9Hx0g8RbtBVIDif2EfTqSt8E3gEAS9teQAGWL3chKXe8yI/u
         Ia1YCuQoSFMN0OpEOU6+3dNlMZmSmYR5u8EWTsh9FEwQNVXwN6eBz3dYjl/RWvB4uA8/
         cqcdAOpumCr4KcE94oLMK20nSpSBdhbKonczE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759335541; x=1759940341;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=310GXMr4EGkw4tBWn7jL9r751VwpOohlwnfgRE/DlJM=;
        b=hWmeFb/LpgPgDnr6+QM+7Iv9Wctd8Af12hhtFosj9FGkgwyhfK/ncZjq78wHybnIQ3
         xOJmYmukdValQTPCc0eWsYLnq2tk2mV8VPInznbIE1pMZ0c4dflEREqrA3rV9KXgGw4G
         HPXAj0LxXgxDmuyV+2QmovDh0TDa4HCjAzUCq1U7um/vfOESsoQ97hxytBtfjdx/wOgY
         FaKbuFfodavsggHkBLOTjQWHFOWHq3ld3D/+15GXwmWFUPZYf6N2Sropr8TOXl3BzmfA
         TRRchPVnMLYjcTXlSIAEDDKCvodh7sbCoHzoL70xeNFUAUgWR59GaOtrSCQhP/wGa8UT
         bWiw==
X-Gm-Message-State: AOJu0YzO+JTYv2KLMMXZz+kWqCDoXSThV1/eWSbRq1QXVmzpAc3aR/49
	iwyB86s7cSnQ/EEbcsEkpieNEHz5wRC6U0G5MhPv/KD/gXgFTAV4PuKNfkGV+b0X2I0=
X-Gm-Gg: ASbGncsINdqyUkzOl5/+2VUR9GZCMPJhvcipmR+lQaaHAqFY5tdp7RksB0ZNSBG4YYG
	OxZScqQ2OySoB18ip1gVTuJ5LUttOfdHY+Cr8s/Vq2nZzBOcd/yq+7hl+L25WT9+S08WGwMa/+L
	74tek7XOnNMLghq3Lwir3btBlnHP147naPTqRH74Uol6BUzjSaB7ecGHamKAsbvFvE/ujz6Fnxy
	SpffHgEf9SGuA9uo7pm62zQESbNGQjtz0S2G1oCzzRWaYpz+vygFjo4k646zKSb4PacYj/DEqW9
	Vjr2GAaSgfkrT/24eTFSJQjjZekfKz7h7x1qLsyfqfYcTdm3Iu3i/XuC7/X5tvnbe9812Q7C7PF
	8ApZGiKc/Yw3VR8LXW6UuSPkgb8EVKYdX8EbKhiOq+YA3iUco0UahoIeXN357jwpliw8WNQ==
X-Google-Smtp-Source: AGHT+IEnXWfyHiu0RepE/42DRKFrYsy1KrLdW46lG4vj8sMVf/WcdNKD770NIyGOoBca6Vs+nul+gg==
X-Received: by 2002:a05:6e02:219b:b0:427:de6d:b6ed with SMTP id e9e14a558f8ab-42d81611b33mr58944135ab.9.1759335540828;
        Wed, 01 Oct 2025 09:19:00 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-56a6508a1bfsm6995443173.18.2025.10.01.09.18.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Oct 2025 09:19:00 -0700 (PDT)
Message-ID: <09ba5f85-701f-4889-962e-f7bf5bc2dd4e@linuxfoundation.org>
Date: Wed, 1 Oct 2025 10:18:59 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/151] 5.15.194-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/30/25 08:45, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.194 release.
> There are 151 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.194-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
