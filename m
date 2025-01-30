Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9994A35
	for <patches@lists.linux.dev>; Thu, 30 Jan 2025 20:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738268694; cv=none; b=Vr7w1jLWhRZb5A968Z5cF0qyPU2eDLMKJFWCgV0KKNFUs8h/lPY8IK4MfdkChciMAk4WlhiA6zOd1JPx1Nc/Pb4N+ylMEmD/iVfRXOcsdd8xFVqZr0V++d/Lf4SqXTJszuCqsKheWkA9PRE2t9Nf/7nfysVo5iO3H9CTTtAzj1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738268694; c=relaxed/simple;
	bh=yFI2K7k1DYXfkT8AOWYfMld5LKYdMpO4AcfHcfiC+Rk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xq/QfHY7dEipCgQ5tvRVRtOD5soX12nqpbcqlMoTiOneEyB6/0EjjmPp782z+9Cheps5xE9T53VXad7Gm+0L6QrdHCoBMxHoO5+ieA6ppvj/upeUO1dCQ+ca7MQ6JIXSD9/n7sd3bbSULYTb8lwdqo5R/nK5maTTIXQC6x57yzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bjfXJr7O; arc=none smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bjfXJr7O"
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-3ebbe804913so353177b6e.0
        for <patches@lists.linux.dev>; Thu, 30 Jan 2025 12:24:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738268692; x=1738873492; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=MSZrxWZoTLP5LT/YGVk/BMp7ULLcYj5MlBHfkghYdjk=;
        b=bjfXJr7O0AYaj0/xovNFfjeHTMRfy8Thl/RNNxrykLPX8bA2wo59asWv3newdfN+z7
         Ugv6f/QGJSMKU8XeuHmdN5P4iy7jlbJ2djZoUfQYz1uFifV6oyAxCgYUI1Nzf7ZdYmPQ
         vc7I7k/0QnyaT71W8a9pH2Cw44aTxeNLl6Ossn90L65f6HJfSBXx2x8284ySqC2eQScv
         GwzuwUJeWaEEC+UPvs5wcVlIfNd7CaJAYNJTCqsnIPD6cQEmT0q3K9phMd6PGfy03WKW
         8MQnjLhkNKusNg6avgb2jDffjiI4u/2+guYtCrSE6XTZRtyTq5wB5JDTYSF8hd/BPtYX
         NWrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738268692; x=1738873492;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MSZrxWZoTLP5LT/YGVk/BMp7ULLcYj5MlBHfkghYdjk=;
        b=IPrxEP1dTpOy3qP0dvwgQGEQG2XG3pyYmO1nObEGXPvjTt4OVUzUOQFhVsMQ8EwGaM
         bTRhjplZStFx8tZG3IqrsWrTA4w3Pgqmb/CFDB6agODqceju8I/LvG7TgnJD6AkkviOV
         wyif1UP/HOJ4MSvDFIsOzV2Id5ON66iC8kVBq2EJR6/CPVS5xQj41hgHNhOZ1FsezW0Y
         a25j9GxuQuCUElv39Zb/FnhQdLJp6oWXGFwNFfxPPmOMXqP6sjYwsAaUX9bTUajNuO5d
         W7u/dtxcz0BqlugiR/VZEcp3U2ZbX2QHv/ibNCYK3xSfH68OwqzXqJY9a+B5Iw+J3wvH
         3ZJQ==
X-Gm-Message-State: AOJu0YwPaUm8LWdP2BqTjNlx1EawzDrIFSwtr7flPFduLdyTrkBO1cpI
	Q7yzWAmJoMH+8VryqEkU2W8s1DffhMjDSU4tVIafOItRgsBAFpbu
X-Gm-Gg: ASbGncsTEXjDzZQarHATMLOPJDHZCUjLyWk8ldvZ5eAeg/ORjk+P4uukUoOz9Je7gYD
	O14AjGAV1Lkrreof2zEfOhUGcV3MEwhQLsSNq2903+otaI0Pw/hIysdypzMUBV+ZvNqfjfZZFu9
	KqRR4QDlDyb3Cwsnh0y7zjIGKYJQVhR3opr1aKNJiJarEjZK6jmgYWJ6b/fq96261GncQjgwxf9
	dTKg6xj+39eocZPV4zTaMJtTGqNs6/JyC2qRoECfLcSgZ6B9YeFsQA2DVgzwlEmcyLu6mWp6NGE
	/Dj77EIi7gjMP2POn0n48Hk6E2Om2iDYtjcaB2QWG7I=
X-Google-Smtp-Source: AGHT+IH+wdR8z/my3k+Wtg9bRozw/6mpj2un8CmOp1PD/NwoijSOx6W5JZiGI0j06z7YWKK8abFg5g==
X-Received: by 2002:a05:6808:2f0b:b0:3eb:3b6e:a73c with SMTP id 5614622812f47-3f323a158f2mr6695042b6e.1.1738268691896;
        Thu, 30 Jan 2025 12:24:51 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3f33365be5dsm406349b6e.33.2025.01.30.12.24.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jan 2025 12:24:50 -0800 (PST)
Message-ID: <8d436706-d9ee-4a63-8110-a9c2e67c84a2@gmail.com>
Date: Thu, 30 Jan 2025 12:24:47 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 00/91] 5.4.290-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250130140133.662535583@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/30/25 06:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.290 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Feb 2025 14:01:13 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.290-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
