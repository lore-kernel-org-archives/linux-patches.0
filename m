Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B7A2F39AD
	for <patches@lists.linux.dev>; Tue, 11 Nov 2025 23:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762903654; cv=none; b=nqCiFYXsQtiZQwY1z1RKZjpMzwhFFy0zq4Gw2upq5CzwicEGSFdG+pt1TsjcVI7GdYWL9MsoXTP9kGXUrWN0C6IQ+j6hA8Mmy0ygIXaY+tBd/M9FOiiW4b7AhpQBpbeNc+fXnNmjFvduKL0CfOZ5Xlv4Vu1PsJ3RfDRdNxzlzhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762903654; c=relaxed/simple;
	bh=IuR5ZRXeBEMrVUdIn/c5gPLOVw4Th37CLXfP2y0VULE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JfXXQlIbYW4kf+8xPKV4grvs9vu1n5rCLhSXuP5RQI6ZqpdG1zzCpsgPf/u0F+S+pRCmyNH18qIQ7uO0HM6coyDeL1I+D/gQDf5+zZ98qGWeocN0JYkHQcx60Dmz04aTwTxhZ233rZgjpNYR8xMtRiqQjhuGjNzXZDTkxVy3HmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h869laU2; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h869laU2"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7c28bf230feso192744a34.0
        for <patches@lists.linux.dev>; Tue, 11 Nov 2025 15:27:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1762903652; x=1763508452; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O9QgRZSf+qoN7+x7rLV1kVs/iEm4M3TDqxWUlp4O9RQ=;
        b=h869laU2Hcv1G6K8wGQL8bCAZtGJpueTKKk15B7IjTR0IM0yYH2dmL+Q5p3g3rHRbz
         AX21WYZWP8zKti+FsMOVKOrI3SwhKPUB4tcvfTRubtcnPVCf+5+zlka7I8YuRQdZNxod
         b2Y4hrSV4Rvl1i+IElPbpvdrf19ktpqaZgN7A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762903652; x=1763508452;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O9QgRZSf+qoN7+x7rLV1kVs/iEm4M3TDqxWUlp4O9RQ=;
        b=PGKIrr0ITv3N8YtvOvu9FVj7QhSnkFoAyKozzTEYle1MAlcbpsTZQR621Y2oKBzxHk
         4GsRGizUFqCww2bGpu/pBMdQF8PcciendUshdB2worenYOu5YO2zsBhVScurOvXp6iXP
         Y2218IRA8Dw9FMFqNzKZLhIJTTVveBiEXTDn779kfpCdRrB0S/S+UGa79GUshS69XNXl
         A89kGIJ9lwUOd/DeQxPUhrAlxwOudT2OKWanFJcBUxMYhG77msrtlEw2bm9V53HrUg5m
         qt27JSgK85yBmwYX04XXWmX1Skwy0MLkIYNONhvYnAjSn6F5/DyQK4YgQOVHkMIEveLk
         mkWA==
X-Gm-Message-State: AOJu0YwDioOD2SEcAJFaz3nzpkXdxSJ7jTNWoKoeNMKXApo5U0/UcbGw
	5uWriGXleCrLi5OQEncASjAoL+mu1DDD/2e3N1EKiOX8ElhC0mnawMli8O83kG86pvo=
X-Gm-Gg: ASbGnctdAOeOToIdiqFXmOE0BxG30cE5NExQeGyZ0BPtzSJinjDWvAKykaMTsiBAqhb
	xnWC4kBmJsLK3+cj2wvlm9ykebto5xvrmuoSnt1SU0ybsEAJLXzpaYytUx8/ct0O3MNmDC5s0OF
	mZsQP7XCw+YZaZ7MzxR1c6pMsJ0KUhojcI3lHY0CrMndM2WI9hFaZTS+scAJzQF0EKSqFTu6Hpc
	zUwfxeoEITWClEmIUTXW5phuSdtXfWUoziOThEOaOqaE9fz4DT5nb44htCkcXKxC7790QKxAZ02
	rtDdTqxDb2IGQdvag3PgKrs/RpjkBlV8EWA+ZG01q0oTLFaLbpipJ+gi2WgRDsggGRXGKoO1SAd
	/dQ+/0y3lo0SacNK+grmyqVKsOA52+oMaW0jvVlDlhOqlCoAwZzwsGmSkehHGOzYyj/Sqg9wwue
	AYfwGosccloC9M
X-Google-Smtp-Source: AGHT+IHveGWcHvUuvrntsLVRkctV87zv6f2ES3vse/t5ppbqYjXZLjyMUEBBOSX6NbMtKYeNIAOi6w==
X-Received: by 2002:a05:6830:6d25:b0:7c5:33f5:c028 with SMTP id 46e09a7af769-7c72d4d77a8mr807476a34.8.1762903651855;
        Tue, 11 Nov 2025 15:27:31 -0800 (PST)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7c6f0f5e882sm7650941a34.8.2025.11.11.15.27.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Nov 2025 15:27:31 -0800 (PST)
Message-ID: <0c6b16e6-bee1-44c1-bd62-2c4baa22630c@linuxfoundation.org>
Date: Tue, 11 Nov 2025 16:27:30 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 000/849] 6.17.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/10/25 17:32, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.8 release.
> There are 849 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 13 Nov 2025 00:43:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.8-rc1.gz
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
