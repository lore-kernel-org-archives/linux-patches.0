Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B31F20F08C
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 19:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761679532; cv=none; b=juKM3cbsA/s9dVKSxTvOy6dYBq3qvFQhy7HvTYOsQ+ZRyS6vHrUXuo/9pElJEfFz1L3foFoi4bdi7WafJAjBN4w4GPlsus5xejob5Ogph1/3gRm8jRPkBhLrySqULwlfjMOy02n7t708EiNFkitasIhvxsJ6J7syABJhsAFQOVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761679532; c=relaxed/simple;
	bh=6XhqGS0XEGnv3jX/pGKq/NJFCGQN3DL8eZKSvZTExYM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EUNUp7VmK4sdixC1SMyb+8pYsDFY0vRIQxa8X31046Bk8l9krX8b+Lm5/MQEkSlD+Lee2zchV88mwYNO2gnspNY2B70pIbAiuJ4jTi6+u0MUWtPJxuddfhfcda6on5r8WOsdhIIp0Yh0yZd6egjqoOTxYnLIDYA0div3ABpTX14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EXvfm9t4; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EXvfm9t4"
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-945a5a42f1eso142719039f.0
        for <patches@lists.linux.dev>; Tue, 28 Oct 2025 12:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1761679528; x=1762284328; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ntm+pSoGGrTLjw9jSc8czmANZelUc7CVhn/2fFWs9c0=;
        b=EXvfm9t4lFfe/U6SQy8ldSHmr5ocXnCWrIkyCcFMjmFuiJjtdoks3Fto7dz/Qf8pQ+
         1Nt8P9WQif6fy/nJ400t34UtV6iX/HYWBz78fdNg2An8EG8CmAm+5Rxe/Q7e7/YsHbwO
         hT1BrN6zPagjumDXo8Stx8U0NzoCHsaiVQCt0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761679528; x=1762284328;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ntm+pSoGGrTLjw9jSc8czmANZelUc7CVhn/2fFWs9c0=;
        b=Lz6VNsP0sIR8XkwIujmAaTOIGLvteViVKfeCbEeZi5PZj+WRt4KVy/WbxuO2bG7fdC
         kwg9ZvlxQSGpImv9VxrW+EDLxJEG8bNTJJPoXZKhMfli79BzxGkm1m1rm8oY3Gi0Awb6
         ghjcNX5GzhM51fpzH92vrvEt12aSGPSsy3dzNJifB5W0igjX76Os44hzErIAcw/8AOLh
         f+aNxuewTQAIYcp0LmxBUFX2uvvfS57sKrcOkEsAdqWIka3UxGlwtzDgZqVet89uBh7e
         4EhXiAJpUF6I1wAsnGB3k0RJ2baCus5a5iebBNKYhp7yv+0bd50ioAtU8A3UJSb9RKOX
         PcHA==
X-Gm-Message-State: AOJu0YzL1SS3yFjS0agDLiUPFaNOw7MJX3gwABv+Sh+ngYILoycxwuyQ
	D7mesecJK5bH0oOM7zOOlFTxxOS8kO6+9JvU6xbtPAlREQ/zwQeeOU/Hd6vyMh5aVnI=
X-Gm-Gg: ASbGncuWvKaJyhw+/v7Iaiz/V3zyToJTeQXJhLNMNCwvSXbOALhMCRZF42lUOtbm7Mj
	Hql2O2NzIaOgR7p2PTY/oYYp9Yqh0BFgwymisw0ZHUHpF99mz7+OgZS+1NblSDj7V6JhIpf/lx2
	AkUZEjPxsQoe6xBkv+Cq1gQ5lK19GSQoLi8T+KAnhvJt/P1pAvhfG+11zH3Ffhki9dbiglgKtbs
	+QR4dQMaUUsEkxgqb+Y8t+LR6tFt+iZgaUJJRTHVQB5pB6su1zj3qaEWdjMlb80MzrIdL1IaPaT
	7H7RoF9du3Zz/puAblkq1QWOApPoyNnESOixb+wFNChYehGmWkkJ+kjMOUcSaNLaR4Rc965QGbj
	offaJhqTjIt+SLADCPwBBcRuKu761m5pqaesrGmYV9Gi6wNkjNiExq3nJ9FLHhHhUFJ3AwnoMh4
	ZN31KCk8ljFgh2
X-Google-Smtp-Source: AGHT+IFiT3LediOigZFqB9hgXiOho/4NEBYFsscX1ZMleYKnQWVc995iuHoH3hsCSfQ7cCIC5sZbbw==
X-Received: by 2002:a05:6602:1613:b0:91a:695a:cb61 with SMTP id ca18e2360f4ac-945c97f0662mr94211039f.13.1761679528464;
        Tue, 28 Oct 2025 12:25:28 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-94359e32d9bsm381597739f.2.2025.10.28.12.25.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Oct 2025 12:25:28 -0700 (PDT)
Message-ID: <1db89160-7f4c-43fd-b12b-1aa624d9d09d@linuxfoundation.org>
Date: Tue, 28 Oct 2025 13:25:26 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/84] 6.6.115-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20251027183438.817309828@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20251027183438.817309828@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/27/25 12:35, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.115 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.115-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
