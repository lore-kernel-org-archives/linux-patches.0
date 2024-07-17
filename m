Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3FCF224E8
	for <patches@lists.linux.dev>; Wed, 17 Jul 2024 20:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721248639; cv=none; b=hqRLRpevKzEJY2KEQ5WMMigqKdYAmgYxmHdXyCLEpUSWVF27rJMTWdZNWSBbNazlQ6vUKpfHFycg8i1ymfxmpKPPrrhMpgiqdamE6dACRheIC4Ec53jcv7vDyg/P9DX4t5LrtYbDGM3uZ7efwsspXoQP7OV84oJpKQ9QGPPYWAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721248639; c=relaxed/simple;
	bh=c/Rf3VkOzW10Ej6A7brjLwqRd4iYmvCUnxVt6/CofQw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uH0FT0h/gxIJj5EGlaezH/xE621ZTCL89TQFGXHttGO1bmZgDWRkTdnDr7teRdj/YWQVlszkRc1K2RKxLf2r5CqPJ6tMv6ZDAz54ROuWbz7wQh7rS2fPwN3lwIpVBzBWfUoz9iFpwLVQzE8h9YjzabcA6YfZXNjL4YPJgB9e31A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EfzTmtdP; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EfzTmtdP"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-79ef82c6344so1811385a.2
        for <patches@lists.linux.dev>; Wed, 17 Jul 2024 13:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721248637; x=1721853437; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9eHeadkJ/ycm/EEj2Bw8QXUOmorlJ8hGNchwcd5kwgo=;
        b=EfzTmtdPTyo43BkHn2Kv7rCnXa2fzH9qy9toLfF4s9RSwTXPb9d2CeEutFgteCBnzZ
         cOiK+twhoTyuIzpl7sSRmNNJue0nl/qwyXnSm5xRyxQXaDmeNTl2a0gmEgTW2EIRfrlV
         m/pKE7TtSG5lIXLdyzb9r72urgYpm3akIwCsi4m+AlBzNoq8iu8rpvQvURFrH61L0HZA
         Q19oN7916lmXRbnqhN/ErcU+AoslrjKzLwnPs2pOWKH3LNYDESJxPrQdSq56zfMqg/kO
         9us7IOGYJR/67pFgtmJ/x+XtqptQNybDb7m8Gyl2uyXN9l3DhxM/3Y+NFIqfEtZJHpev
         R4Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721248637; x=1721853437;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9eHeadkJ/ycm/EEj2Bw8QXUOmorlJ8hGNchwcd5kwgo=;
        b=id9pmvuZrKL8eIEDWKZFWGyU1rFk9WVT+4X/7M0CvepMZNMtAxP8L3eYaJMnKgPPHq
         KIncxjtJmSBj6nmY0rh1cvV4YPbRUM4KBP5wtZKkHSit8BWnsT0Cc3xgZLt2MwvkdmAX
         qzwwDskOGXSZnY2aH00+4xY8mMF3i9CsIoL3YmWlvKqEjtNh1Gh2FSpvIl9C3bo8ART6
         pHpd8Wa1TgpNqGTfWBsS6uzzOwPH1AW1o+d7C0x4iIF0WESgztewupGnyFmOJ2b8U5NH
         hJcHVJrbR93jNSvVJjSZZqMUP/7EfLgBIOnxEGkg+vlVv/TJgC+5wjAKltlJREzS68Ip
         SJ/Q==
X-Gm-Message-State: AOJu0YxvW/1ag5EwgzMvISqFnxMIg+u2UTzfbMs7ZdMmC+bzzoMC1+ar
	rALR4MHlTgYN0yuGvwvH2QziylLMb/t5/OK345deYGtedjX9EpQa
X-Google-Smtp-Source: AGHT+IH5p+ouQnr78z7HNB+2NOypqK4DdN4PPgyTFTXGMDArLdN1QusI9EcM7BN4jDrHnWeP7RfJxA==
X-Received: by 2002:a05:620a:244b:b0:79f:58e:1198 with SMTP id af79cd13be357-7a18749d57dmr290721185a.43.1721248636664;
        Wed, 17 Jul 2024 13:37:16 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id af79cd13be357-7a160bdee37sm446119885a.69.2024.07.17.13.37.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jul 2024 13:37:16 -0700 (PDT)
Message-ID: <4af8a6b1-695a-4feb-bedd-6d8aa11bd40e@gmail.com>
Date: Wed, 17 Jul 2024 13:37:12 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/109] 5.10.222-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240717063758.061781150@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240717063758.061781150@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/24 23:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.222 release.
> There are 109 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 19 Jul 2024 06:37:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.222-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

