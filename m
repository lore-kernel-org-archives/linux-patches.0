Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62FAC2BFC69
	for <patches@lists.linux.dev>; Tue, 13 May 2025 17:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747157439; cv=none; b=PK0xT3C8GH77OQgcShkyAeziJM+n2R2qnUe5ctL8rsjOHO3HiqoFk+OB3Epn103xp+qCSnXscvwyF8oTX+/YkVKRYtyXZTwJzTnIFwGEuQcRLdplyQ19wWqqhrsWQCoTUOrsk76hNOxj3/mh5oOyilOW9FdYej9853sZd6+9Gbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747157439; c=relaxed/simple;
	bh=1iKDHQ7jXvke4sxSCXjYm0GynBjrTYyOGP275PTOFfM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b5YA8KP1zXm0x2q0EEidrXHisLFdtXz2dtkKg5rEP/CiL80NL6g7bT0qOGY0gExkLqOr96BlUgN8C7loKT6C5Q/skssoPiBLVEnnH1Ux7sOokhYkj42/m5zTkEhET3F5Uy0StfBqg99lSUliD4r+AjrSR6shEXYUfYQFyQTAjmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OpecMPbL; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OpecMPbL"
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3d91db4f0c3so30747925ab.3
        for <patches@lists.linux.dev>; Tue, 13 May 2025 10:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1747157436; x=1747762236; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3tW6PygMdjeagRmJ6icjOyCgBVvMDYmBZ2dFiMgydeM=;
        b=OpecMPbLHRg8yB26zOAHCSwz4jG1FhKOi4semJ/pxVbTI6NNAJ80WVd9CPgxeo9bqA
         H5v4ZKwM7pHAqAUNOC21rgQn8zraTW623fESy2xjPHiLJxswMAm7pPccPPgVRKjyhj0b
         HA8uwr24JCF4TmoTu5JdS0RW8yH5+OJVTFcVo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747157436; x=1747762236;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3tW6PygMdjeagRmJ6icjOyCgBVvMDYmBZ2dFiMgydeM=;
        b=AlPyHjmqpaVQmouopBCB9c2cleVoUyzS1VLh4IwtysFXap19HlF/W4FTNCbxjjf+bo
         gbFPUMq77F1MTarHUFn4H3coJvuZJriEKrDn/8Fla0ZQxUlMM/qPdCIAB3ItmqDt0iXj
         SE+CkeSqW9aOyb8TyIzy/NEjJgfCN56jPbnUnkVx017auB+9rrUSu18s+g5zuPDah220
         HXOkAZx5XW7ZhVInxBT2NMKxbtHhJ6j0lFJc7+oxWRKfl0w4sQucX/r58bcoRm/9CaCC
         86/u/rnRpXwK3/L4gnjSVkaISIPDq2UhsfJCnMUKZay48N66PKLkU2VTvp/CndimBFVj
         nw7g==
X-Gm-Message-State: AOJu0YxBUUDg3iA9h2m1GxykDfBLlEqhD94brxiCcoK9bE75QqNwg8s4
	IZsBMwxFDoK3ZIA+u6km4j5MPgmZlSZR7hosXLPs3ppnIZLSma5IvVi60nRrP8E=
X-Gm-Gg: ASbGnctn8f+Z5krGq1CP6FyvJ7ap3pfSg6tSwa5LYNeOQS2YzwCH0kwQ5SjGxVJ8Urf
	J0hxY9mJmvVisUaRDO26ML51BbS6r0uJK4HTjEJWKjuurC+ktYcAd1Fxi6yF1pvezjxZ0PQuBz6
	uVi+4I8njgaqt5FwbTPdU1Z60s7+k30RE/e6fq68mSVtPXotEiR93GQAA1Ov7bYSRUKPTbSUqaA
	kG2PIYl1Cazc5Iopd3rqev3BDNPYWnXx95BrMVkgUdZnI1uMYiV2HOq5OCLXY+jbT90her+t4S1
	w27juxvDIxJ0UlAuUQ+j+ECLOIitB1SFmsEwDUymwIiM/OdTBKF58pk7S4u8vw==
X-Google-Smtp-Source: AGHT+IF33HkKIK0AZPxW0+9c8b+moPUF3LhmDZ8Yvqpj+8WXLkf1qZtasqM1OUW5b7g99xgQbCY/hA==
X-Received: by 2002:a05:6e02:178d:b0:3d3:fdcc:8fb8 with SMTP id e9e14a558f8ab-3db6f7a04c9mr3577145ab.10.1747157436272;
        Tue, 13 May 2025 10:30:36 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fa224a1415sm2209822173.14.2025.05.13.10.30.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 10:30:35 -0700 (PDT)
Message-ID: <79f86562-af5d-474d-a971-7ae20c5cf011@linuxfoundation.org>
Date: Tue, 13 May 2025 11:30:35 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 000/197] 6.14.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/12/25 11:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.7 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 May 2025 17:19:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
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
