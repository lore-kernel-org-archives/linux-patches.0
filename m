Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A702534E750
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 19:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761679465; cv=none; b=oAqYiYX7tBSyZBN14/zOPBKWXRWGP1AYx80J3cmO4C+dIswRVy/WlKGS6m31ZTi8jemV8c+Bk1YZ4Xa1VAp8u8bImRpp6YM0Qy1VB2KqhCWlbvExIxn0bSx4bUeNRxNEhLbpaoep2GGjTQrppPFyURr21UL6zrOZvEaRrnRnEUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761679465; c=relaxed/simple;
	bh=FNuV2ylpbQgdnCFLqngDIR4alG7qnXMuPBXZqxFBQnM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EGQBQAdn+biDXvV4v8G5nBFksseDhjmW/fXmyHT65UgLfXZ4R6DqWSyKjsR8EaYfTpcEYYazMMBHPqWmH5BNCRm8TkgH85ICiwFAXVN3faMNIoCCTpEpTFmvIMf/mc9HAKfvYVdk02tULrfN1MpsK0QUTvgJYE0LIB3UZZcwKSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZJFZ2oiX; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZJFZ2oiX"
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-430c773eec6so60832255ab.0
        for <patches@lists.linux.dev>; Tue, 28 Oct 2025 12:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1761679463; x=1762284263; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=58Awx0bGuwSF6D/6xs0Bpv4Ns1WT5VljbxJNAptjXQI=;
        b=ZJFZ2oiXq1p55blHyfMFbwW34Us9uTY6dTiFUDO1R12Hc6NdtP0HJAPoT20HUgqaIW
         YMQ0Ul1DzMFhFrAT/Lwg//D+A9xkCPPNjKkUEYpT+tAjx5Ogn43ajNPyo0Np5DrIOES5
         xzvEDOB87PZ+l+80cCl7sid/8rZW5BWNM2vTY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761679463; x=1762284263;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=58Awx0bGuwSF6D/6xs0Bpv4Ns1WT5VljbxJNAptjXQI=;
        b=wwINgjBgyR8k0BVgBfu3Sw/zqvol+pI0ljL5hQNmko9OxNg/P1lR3AbiH8FqE2ssQI
         6Gxli+cYtc6GF4QEVeXYOEYx0XTXsTFTdhZJyohO+frgkLpUZ0C1Ri8cKwwxLTRVDbT9
         ihWfGQBSvVB7X/ZVbjADZBce5fk6N5LH8h34VfJzYAbJ3u4PFNzti8GtWB+pFosXub3x
         HoT4YxbmumuqELqYVvbfH0mHUwz+s60tWfF+oZUfmwszhfVQx+IBQiVeJBsTtxwuWO9m
         ECKhwm1V6OaGtittPIWdZ41tci4LPEl706JCGuYIt/eeN9NGpiEB8umPWegYaeabgCf9
         ZMLQ==
X-Gm-Message-State: AOJu0YwF0yjGc5nphYJocFPnx8Q5YKWrzz7/9+eaBhuVTOtj5veaCPId
	TSm/ja3MJlkLRfMQ+28hxNB+DI5jgRDtaHvWgpjsV+xDO3zmv/4ZUBHlk8jXpSS/nPY=
X-Gm-Gg: ASbGncvW8kyeKPL+Djpt7n4Mn7FQF8t1/5QeXrq9bfhJUWAtpUvGBcy6CnCRzwjkf0o
	zc3vA2zBoJF2MgpTgAcB3e7fy8mzWVMPvoktwp1DknzpfZCIP7yNQGXDAd2W2I3qgSLtBv4Q1Od
	IzZr9Mg7uViS7FQH9iYUqktDTjOopN5RQy+qzL5xXmfeYlSfAoBEVm7wuqZXyhz/2UvJ9kanCCJ
	gltDFVjMXt7Qfo90Ug8KJlnKurUS6UKvix5FnEovR+FURRLrNi7ZPztJ6x/p162Eab9s8U+1vIH
	Qmr273C5+Mld3X7NXDQD7zDTaYsM+vsZx3X/NAVEp2ORkHQd4Mrjm8iX7gfVNeR/9BIUzkg9XnB
	bZOLNyw6v8U3d3+Ot7YJ95E5SqEDgwMaTNLgIsDMYKlkGnAlL3prGk23qd2e5UJrdPrNYQGVC9W
	H1j98IytgNt0N+teGo6rj5yEc=
X-Google-Smtp-Source: AGHT+IGaEFpRntODdNU7RTyaoyOhPbbt53aEcNEoUCMwoRku4C5s3OW5tIb5fHWdKQylLZZKXgEf/A==
X-Received: by 2002:a05:6e02:3983:b0:432:108f:427a with SMTP id e9e14a558f8ab-432f906651fmr5016915ab.32.1761679462694;
        Tue, 28 Oct 2025 12:24:22 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-431f688c355sm45945015ab.28.2025.10.28.12.24.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Oct 2025 12:24:22 -0700 (PDT)
Message-ID: <58e41cac-eae7-474a-97ce-2f1a084383d3@linuxfoundation.org>
Date: Tue, 28 Oct 2025 13:24:21 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 000/184] 6.17.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/27/25 12:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.6 release.
> There are 184 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
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
