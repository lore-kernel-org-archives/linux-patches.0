Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA2041760
	for <patches@lists.linux.dev>; Tue,  5 Mar 2024 22:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709679067; cv=none; b=K+RizygaXs7THtjMGkTQRE5iniKfA9py4iF10IhA1aLVmCPDR8PB4zKZFDwUPZC7OhicERG43QdAjhZJLekguQ3jynttZdUv4zR/WLKOWjkiML5Xsm1D4qhCPkfy7gZFjDgxEcX8Od1aERTJTlsMGGKRK4iXI7vgqNGHiaB2Ov0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709679067; c=relaxed/simple;
	bh=IlmA7ZmBJhtoMP9Vra7fNUdyJQlao9zJE3ZYv43qqAE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l6KxBMixsKb+hhGvhh5eDkVkknbaSLesN0eDo+yvyacXviT6hTLo2SEyYP25MYuwzQmL8mKryWX371Wi1+M7p+n6ugffZdk8ppVv2KBQQIddsscCqkH6tY0zkkMI5Ub33kuOD8MJqbCEg5tpvpln/hFYTGedS6+whT3Jd4ziVvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KYKl3fYc; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KYKl3fYc"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-78838c0be0bso52054285a.3
        for <patches@lists.linux.dev>; Tue, 05 Mar 2024 14:51:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709679064; x=1710283864; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=t0uEJf59f9vnvwnqg6LNGbO20Kct5J1he93WOTJSEyc=;
        b=KYKl3fYc1Y70z8UEt1MwQdz406iYCF4r0UkowKS3MMrPIIcKHRrcidFqI7Ll9417CQ
         oMsiu16Kb+deMZ+zy4fuiIyUaSi9+Kegayfl4gb51soKMT3a1NZEDL+3fBzZ0+K7n6g3
         HsIc5GVw0vznSBC3Yhy9/Tsizv4An5CD7zZXPctO8t6tNFBP4gamv7JVVfWTPp3VUmPP
         fOE55jPV9acXGs75n/jxEJlH+yeAX1EitN+k1gF7FMknvbIOTQd+DEV02Mfed+OJw+PG
         kB48GahKgEqAVkx/IKUgeZsqr0L9fXv/pqQm77vbl1FK5dE0xbeucl4b6JdHokbvorEb
         hBpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709679064; x=1710283864;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t0uEJf59f9vnvwnqg6LNGbO20Kct5J1he93WOTJSEyc=;
        b=qjjSjGhyzS+hUD2spBHfuZ8qODcqBvMbjA8rcVFW4ZLdIQTt6zLLuU01nXmAgCn41U
         BW4YnT4X6r3kXwJ+yRxaaHQ7WodSb1slzhilk3YV4IKCKT6I9tHyeUb+W6isDXpTwUZ6
         muId3Gn75qUeQpjRt6osOlrdhe2q2KW5XOxvvlQfzWhDxNgdawZUnzdJ3Qh4mnyYXkFV
         7HVR4nwyp3Ra2O+/EWS5gIw3leoe6cfsm/04SBWWa1ACk/GXOVQ8JEp6ghml4J+fJsYV
         1zrhkvRiPt04Jep9F8wP8e1Fe4YvIE9RTVS6sAizga8d3JZ2AXtdiYhkLmUS+C7r84i7
         uobw==
X-Gm-Message-State: AOJu0Yz6TLDXg/Ny3mABmsciwDKTDQZe/bSHizuT2dprcXA/Gv/m8Rn1
	pO0F3Ra3a2OviWrGcftMyjRZd2xWK+FFz4bm6xfXabO8SYr0j7sM
X-Google-Smtp-Source: AGHT+IFGh+V+wrlCCKNXrJOo4lahUFxVZ1I2uL0xIS/nMSpZopQyBISdCbmon5yfUuT7kkCi2d9zPA==
X-Received: by 2002:a05:620a:20dc:b0:788:2476:1437 with SMTP id f28-20020a05620a20dc00b0078824761437mr3140284qka.75.1709679064596;
        Tue, 05 Mar 2024 14:51:04 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id f9-20020a05620a12e900b0078820982f68sm3417937qkl.87.2024.03.05.14.51.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Mar 2024 14:51:04 -0800 (PST)
Message-ID: <cba559a0-61ab-46eb-bcdd-26b69569b9e6@gmail.com>
Date: Tue, 5 Mar 2024 14:50:59 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/215] 6.1.81-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20240304211556.993132804@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/4/24 13:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.81 release.
> There are 215 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 Mar 2024 21:15:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.81-rc1.gz
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

