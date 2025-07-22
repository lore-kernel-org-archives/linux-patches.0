Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49CE28640A
	for <patches@lists.linux.dev>; Tue, 22 Jul 2025 21:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753219334; cv=none; b=L1n83/VFLA6UqC/JVpz2vVXNLFhcWZdI67wHwUn6cxMvv01wj8l/kgc7TLvZGX9Src8ljKIHuyZPHHagDhlbCJkbpesoVK3LiEANk9KxXP8oo14wl249s90o/9MATaLWGEWtWdIpLRWjdlT9gIgqvznBL204hxzq5MGcaOvc0Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753219334; c=relaxed/simple;
	bh=kRmeUWYh6EGVUzw8lu1fepCuY34yWYJEXR7sLZcqSFs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qU2abM1WRBhOp/IY5i5/rziv/joYvOp6W3M6OiIWh89fJ3kxw6pas55najX5qLx2mK77rte8Q9awOwP6a9YShzJwDaQF6HM1WNSNWVw1A7a/5LhYrxdZ7T1IJqLTGpkTDlgOhGjzaol6LkxFOCE1zlNyQkT7nCDYrt1w1VSUU3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dKIkiM8M; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dKIkiM8M"
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-87c11fd5364so168486439f.1
        for <patches@lists.linux.dev>; Tue, 22 Jul 2025 14:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1753219330; x=1753824130; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=23EjP8BqsKxCkxGPOHLawUuEVZik+m90LNaYybWi94Q=;
        b=dKIkiM8MS5/fOL6xRiVbvqnWZoRiwLz4msRxBP3KKRm+7GkETnTwWvqEc9QapG6SPH
         puJUeG84Iq0Zh8UJ2KD8B+yEZ27EcBQZkaP2K16Gcohkp96I2VLTYdzLPbGn3ugF114f
         XPPjXyJIO+5N8r5ugzC16G9RtpRI/78i6gJi0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753219330; x=1753824130;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=23EjP8BqsKxCkxGPOHLawUuEVZik+m90LNaYybWi94Q=;
        b=mj7Z0/ZfpT0QquPfqk1tDvU7SlaPxVvkxbU17LBK1gPRSHBU4sPVvftHrKOi9KAtM6
         DU0Rctxer7KzdZNt0eUDpcEO81DYGcE7yvC4hzGupfavQNVhZo6qh65CxsgT5ClDNDop
         YLCy8IVmnEy9usA1ibrIN79GNcrsK9YTEhuD3ib1mroocZkhhRcLK/tD1tB15gEpFTbV
         ZwiOFZtCAeBZwFsrmRbcG9oG6a78fk6cp4gDWUC+2PUj3d3f2kwDKxgdjOrRvFok5EP0
         nmg+cbDszJYzrUuW6EXBet8pLakVaknKsoTpHIjkF/62odezFNJxphXYiMb6qIevCUh/
         CZ/g==
X-Gm-Message-State: AOJu0YzQBWf4Tz41u5hZ846JF5+QbdeFDghe3C/zAPHErTuRmvrbsc/2
	rQa6m8gBJkXvlvsTUU6SViHxzt6IkSAoWTkUGVAly9u5PWgqZFOZe0mshk9bNCPwIBI=
X-Gm-Gg: ASbGnctAamEjydQ3As0MhoSnDZVwXIsz5eyfTN/Tq9StZCV0YZPlRjt88V8F0OCfPt+
	CaH1VP7JpgnZPEiojwqrhWEy1M42KUqOWedM216G++Mrb3DlgI9DUU16CRvEa6K+nkuDtsM7ztj
	i1BB4Wh0ymjjhjL7eO9cH94zP/n30jhPVLa9Y5th2WcUIZFpom9AdofCm39LDF/4I8pQrttal6C
	7MwwVqYGHL68d3tfXtc/aouBwp1YlkyWtqNSzjQ3C+iKmaEno44NB9W7kqRyNi2V6bYff5XvTmR
	U32N7SXQQaBflCw6GEI6cMs6XHH7rSpKETzrqovhKc56FfFSRGvcO6F6S3XuXfv0kA3zPzhokQo
	DRHBMXJk3M8+dmMteUWTO37G8y5cPW4MNKQ==
X-Google-Smtp-Source: AGHT+IHksoSUIDYhxq/5D669iNhvWPBnTdjsS7dJioKuBS1uJBE8Dnogw1moyMiqkJxW15JCNVn5hQ==
X-Received: by 2002:a05:6602:3a0d:b0:875:ba1e:4d7e with SMTP id ca18e2360f4ac-87c64fbb367mr137690039f.6.1753219329825;
        Tue, 22 Jul 2025 14:22:09 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-87c0e1b2929sm322754539f.0.2025.07.22.14.22.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jul 2025 14:22:09 -0700 (PDT)
Message-ID: <90113087-cf90-4c95-ad6a-168ec1563031@linuxfoundation.org>
Date: Tue, 22 Jul 2025 15:22:07 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/158] 6.12.40-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/22/25 07:43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.40 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 24 Jul 2025 13:43:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.40-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
