Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37FD2B9A2
	for <patches@lists.linux.dev>; Wed, 11 Sep 2024 17:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726075536; cv=none; b=SdPr8FNuqnFyMTtkWKhptIOx1duIL2mzbO+53HddURHUnHlYu+mlr8Zg9jgbVtg2Wz/AO9X23ApU2R97lyMc4SjEnAl3CEDmNMZ5qmZtziiHNfIuOBpCqeuc9FCPmzd2EL24KxM/k1VqT2u5GUJdAeJQ4sUQ0hSYbvsRT8Jnm+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726075536; c=relaxed/simple;
	bh=1DE5fZyEHazBhk4YSxji28x2nF2X7K9v2+xK+H0heYo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pIxKOCEdaVkNtuVzIPPzZkv6njpjWN4IF9xH/xDoWAXCGD8R5DXL1uWCi96rCQFHUWUnR7jib/YdR1FC/HKChlLp2c4B/umjN/FzDUK9vaOANYlV4qGLbofosSS1UzYNRiP7GOYVmC88U2ay0fpMRJRJIfitpBfPKA+FJiFzzqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dUJ4K3lU; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dUJ4K3lU"
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-82ab349320fso1693339f.1
        for <patches@lists.linux.dev>; Wed, 11 Sep 2024 10:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1726075534; x=1726680334; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BtdVX8O4R5RlEn6XgHHpJbfm7Z1QBa4ZYeeQfbViS0w=;
        b=dUJ4K3lUHAT1pE/LvQ3KCDQXB2s613WevcgNhzNNzejRxEu3zJHEKglXI6H1wdriFq
         EzbU2CLaWTd+jZ+6+LDp7Zsh3ujYy9wYVFcznMzm6BnQTFQ4RE6lWbn5HVcmNHUAnv5E
         +mGa3hZHp/2RskRF+YpLj2qYUp/pNFZ8dcYdQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726075534; x=1726680334;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BtdVX8O4R5RlEn6XgHHpJbfm7Z1QBa4ZYeeQfbViS0w=;
        b=CQuUYcDNGhTlP4ySLQmfRIKzmjF2VFjBRTSNORnFdzFc0hg/GY5fqyeLEb0o7FAnrE
         tjksH5O06/68COyGqn3xnhN8ksnTWXm0UG2k4kMq9Z97Vk3AO/Spm8NKC/8Bc72ZSflN
         noAZgx3UAPb/ch9K1RSha7ts63hkxg4c860fXEpOPMy/eOGQ/wm25cViceDJWP/D4mUl
         CBu57rU0Mq+CtDpuOF8TOT64kxORECfZ06JOFMBL/RmJvaK4dZ/SW8WP6aqAXSNA1G2Z
         1sxBfxGLRfNq3EqmeYL2vxFGaxf0SH/TQwn/R+LD5YndxIG32+OmFloOO6nKNHFfTklR
         anSQ==
X-Gm-Message-State: AOJu0YwEIbdS/i5kkuyRoDD0Az4nzoqvW6vat7oW2ju2qZKdmvdYaToT
	G4P+hiwyz2e9f4FozwLt6PYZyTvr4LytcH5WePaoVB6ICF9A2C6EsJ+k/eedzno=
X-Google-Smtp-Source: AGHT+IEzkYDwTXtn8Y+11mQQfMaw9Yt24MtITkri4cToPizDt4VvR3VXvFo4NwxfHzWwKFn8OVgcXA==
X-Received: by 2002:a05:6602:6087:b0:82b:c70f:5061 with SMTP id ca18e2360f4ac-82d1f8de413mr37458539f.7.1726075533508;
        Wed, 11 Sep 2024 10:25:33 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4d35f954537sm91790173.171.2024.09.11.10.25.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Sep 2024 10:25:32 -0700 (PDT)
Message-ID: <9bbb8370-758a-46bf-a01d-7e4d4f3c3a68@linuxfoundation.org>
Date: Wed, 11 Sep 2024 11:25:32 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/212] 5.15.167-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240911130535.165892968@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240911130535.165892968@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/11/24 07:07, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.167 release.
> There are 212 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 13 Sep 2024 13:05:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.167-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

All good without the iio/adc/ad7606 commit

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah

