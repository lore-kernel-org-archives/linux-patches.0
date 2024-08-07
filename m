Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271A813E409
	for <patches@lists.linux.dev>; Wed,  7 Aug 2024 21:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723066229; cv=none; b=sbQv3av95AhDapn/z6uke0MHRIDgMtFkUfS3QJBG3xJHoEPKcmWjDyYtsfEEYizUc9g8jh38MWtxljzg530YdyiZ2Ntix2yGTFRGg0jhGroo0/WXxT/9ewhjUrPJ7D9mo6fMyS5vLkWcXxjbwkWpv8hM+nzNqTPW60ePS1tvj1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723066229; c=relaxed/simple;
	bh=S2WUcIEsA6+3ppym2CRAnEQy1XpPkseZ+RkrsXGrgM4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=crCMYCiYkcnypGRGjy8Csmh1TN4IfsHI9JluL+arbJm+I4+UAdjXe1ZQmtjzeiIKUQ8poYaEGj0n2Rg2N5q8QO+m6PFgbxhHPFQwBzDgeHp2SRXFJ6PyeGo6EAsWl6tRJ6T9qf5r1EQzoxEBIZ7nY0JCtu4OYfyLVfsSqV7w86w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V44qAD1Q; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V44qAD1Q"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1fc60c3ead4so3474745ad.0
        for <patches@lists.linux.dev>; Wed, 07 Aug 2024 14:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723066227; x=1723671027; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uQCkeRXbqsoC6TGsNWXjN9AhH2OGAT8bTLYitR2KHqw=;
        b=V44qAD1Q5+2mJgz5JUzYe3NtPDGvZbJ6HEUuvbdIOcVTNOUhdxuhx8Vr/PQCE/KCZ0
         sgfCj8MtJi4u5OwWrx57LTO73LKRpm6xoAOmcdS4AV/pLFoqci4z0kXGj03MFZCzmLim
         Uto0X8X9SE8w9Fo11vgEHaqtq2ybE+esMD2m0V93lfGWVEMmgip+z9srB9IyWKv72und
         mPUnnsee97LVtWrRwoS1bfW7g+Q78v480baneRD4iJTGPwYWpwYGO7MhPDzJP6trqJAc
         7HYh+delU0Lk19Z6jS7lyuOerppNDx+DZtgbeW2ON6QDynhBRD7Wrw8m7nuGnvh9aXMS
         9Maw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723066227; x=1723671027;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uQCkeRXbqsoC6TGsNWXjN9AhH2OGAT8bTLYitR2KHqw=;
        b=jOAJzAP5kMtD1ubsJPZU6tnjjTd/IVRK0HYyNHpmcnZy/3mcGMoSbtyVOqezDZNMDD
         e9bSoRNenajyje4LzDm2O/rVIJCOu9iWxrTYP3soZCtt9PewzyqMrSZCYpsxpU8CBSNX
         tuWWfvjBP97kdDKgiCjcGH4TITxyKCRFXaq3hAd5rNL0DP4SwOlrYqOXXJbVQnSABOwu
         0Zq9Q76wWJZ8G3FRDJ9CP49xFvJF3sqQEZFduFxz6OmdO6Vi6oYqqXZwNqlIw5rTh1y9
         vlTjqx/cs5n5jUjLWZCgq29t97iRYyM1M5BgvD1mnTpF6RH0LiVDdBieCE5AAu1/6RKE
         /UHA==
X-Gm-Message-State: AOJu0YwX34Z9bpL9UjbnZWRC8ZPqp+Wxv7/2fFwicO73wZ7EuWvmw/qI
	trh0H9BU5iilV0mCjjgQ8bKFa13apVJtQFOlYNKe7X/auCUjVUGh
X-Google-Smtp-Source: AGHT+IEz/VuQPyBI274b+xhvDuQNnkMCKoXQr+SkjlteNH0ShrF/hfNYRP42/6H7rVpizZs+Bi8zBQ==
X-Received: by 2002:a17:902:e88e:b0:1fb:35c7:8ea4 with SMTP id d9443c01a7336-1ff5727c893mr221732745ad.2.1723066227115;
        Wed, 07 Aug 2024 14:30:27 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-1ff58f19d0csm111280265ad.2.2024.08.07.14.30.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Aug 2024 14:30:26 -0700 (PDT)
Message-ID: <ec2c5de9-830f-41f8-879c-39d19771edf5@gmail.com>
Date: Wed, 7 Aug 2024 14:30:24 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/121] 6.6.45-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240807150019.412911622@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/7/24 07:58, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.45 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 09 Aug 2024 14:59:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.45-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENEIRC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

