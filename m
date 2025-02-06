Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891FA1A76BB
	for <patches@lists.linux.dev>; Thu,  6 Feb 2025 18:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738865873; cv=none; b=B4DFL47p3RmnsAdu+RIxw68OYNUwtnF2EojYJ+CEvQbMfFrk9iio0B5aNcJ8ut5YwSXMLniuxf/jN4A6zNPBy/pebb/Ab/m74OEfXg13wYeDspOPy1XR+nli3yhJILolrYck/Mv7uAgeUCnkeaTQvfQ5j80kecNY9w+xT57gToY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738865873; c=relaxed/simple;
	bh=GRCAegB/wH5JiqySA/UBwC45CXMIaQ+9IrhQdRxjPGI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ij/bdLuX2KOSj3tbNk1lkP3EGDLwZUkW0SFFtTfkKyTPsRCiYVmHccYiZ7gE8cbP70Xibgw/JC1bQdFFjs/hTFDZ+GIWVi/STrVuHR6+Qv3gpaP4UhsD2a1f+FIMmtXJ8xr9bQJmyWNgpKkaC+7flwx9KiooUJ+6h1lTGRaiJ/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SYlbuDHq; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SYlbuDHq"
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-71e287897ceso961085a34.0
        for <patches@lists.linux.dev>; Thu, 06 Feb 2025 10:17:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738865870; x=1739470670; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=j5XpTqIqaVSj1rGjaNE31tTcfGaWSmqchN1/36b6w9c=;
        b=SYlbuDHqoNIq1RiG7v2qCSkEclr/aZQjgphLWUcWJheloKhKiRSbc03wq48FWznBD1
         JuppYFH9jdAhtwHmvNwXAa+NeCau1LRgO2R05ZR7pPPELZ5R6161mcQuiyymVZS4klR8
         bHN+f7pohJeF6o+uTD3BnwMGLQnZY9CtVXtq33dLNaxg9oiQ3ovBpaYB6LjCIdubVQmu
         Oxkx/5CbBEuWNrC5Ptfxc6h7kf0YDBOmiL+0Jt/xn5cFAgMAlzwP3yOFHpt7pfQtskvJ
         qo0V1ccLqMJJRsFzhhqgQdcKvbSHTO8gQ//ASmL+nG5yTfFYEHq6W421LR2QrZPnoOWK
         8clA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738865870; x=1739470670;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j5XpTqIqaVSj1rGjaNE31tTcfGaWSmqchN1/36b6w9c=;
        b=IebHBhNAtQoePJszRv4QQVWOJrmxgxNceC5wuTNpen5ab2PmJ7t39DCFuUQ580xTm7
         gYDka4QKvnApdJKC7sTJ+P7NN35CE+cBiLercqUdPMH7by9o3TXFq36/GoH7344dFD2m
         eAJSArXSWJJGnuVFuRHblXcJvmLp53xWddySZCRjDqsXmc8Cc1ULOvP1IEjm7qlGPV0w
         ++64F6ZVUYyHF80/jFas8E1chlq4itugRQmklKq5aCprlzjm08Z58ie3KPF1p+j7SUTO
         GEmp523CdYU4mBD6zYftp2wFAqjmqEpiHwqwpZRl2vv/YqC9bfXhva4laWo0paAlgvpD
         yorQ==
X-Gm-Message-State: AOJu0YxbIfDblSEhCliNLpJ5LCDg0ulmMOLXmqkqiXZAbGaeOsTPjfRt
	MrqthsAej987OTH3q6HDUjihBXK9G4WYtjeHW+zyZavlekbT3Q5P
X-Gm-Gg: ASbGncsBOdswyTKiZdk+ze4Gm4SuW68E5aayhlsWlbtCURJ+JYmZosPo25NM/L6We8f
	bP+0y2XVzMAdzvXtrdsH13bNaFIxX4u90jwQ4xIGLOboA3cjJ5uufkZMMGTJqPW69fJkV7qOwv+
	hM4pnkmq6cn/rjW8d72DUiFH1r8eQ0jBTksTw8NHrSVaPMRRZ6qYJc/GBPcQHAbht5PPW809T6K
	PLwisAwNnwcW6qB+5ulvmg12a3b/oid5jY28Ek6HbvaBto5yNFiUSeZPT+OUYJx/33oo7oQZws+
	yw2ucosukbmu4k70f2V+p98XvROMRGIvcxGmT9M2Iog=
X-Google-Smtp-Source: AGHT+IFo0FDI/ET2p6lxddvx2540ogdgK8A94ZRKUDy5Dg9g1II+NC9yCDqnEgMiSpfird2yUBDjug==
X-Received: by 2002:a05:6830:7001:b0:71d:de27:8d32 with SMTP id 46e09a7af769-726b87b457bmr89740a34.2.1738865870511;
        Thu, 06 Feb 2025 10:17:50 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-726af9142c0sm398547a34.5.2025.02.06.10.17.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2025 10:17:49 -0800 (PST)
Message-ID: <cbfdc3d3-dcaa-4414-b4a3-ee614803a094@gmail.com>
Date: Thu, 6 Feb 2025 10:17:47 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/583] 6.12.13-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250206160711.563887287@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
In-Reply-To: <20250206160711.563887287@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/6/25 08:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.13 release.
> There are 583 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 08 Feb 2025 16:05:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.13-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
