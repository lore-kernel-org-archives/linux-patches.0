Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C504A3D
	for <patches@lists.linux.dev>; Thu, 16 May 2024 16:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715878643; cv=none; b=eGMKOnuwBSt6yrsk7bF78EUmv5Ssc8H1K/RUKsUyJHf90YUP5H7vR85A6E1Mz2Jbjtpje4u7M4zJj1+DQ8bfseuNvzK6DJAGMCG5IKLFmjAAY5zw7fF+X/qq3LWj4ajtEmOZgWwZxDTbPHhjQmGhXJQoMuyonLddKKn2Ae+Al/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715878643; c=relaxed/simple;
	bh=eFFVQcl1g3izW1Ue47+S2VYYVJe/1FsMDD82U9A3EGc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fxSrHYs7Q3Ks/6hg0sRGss67CCxkTtm/TjaZrNsTyi4dL0Qf4OYyTOs3lkj2+UjSSuY6VgqDsZ4ZG3E4wb25EE1hzBxObP+47KrgQM5GPP4SnL4LJr+xtjzFPFgbKIQTAJRZjNG/JgDt2+qeowVVzWG14Ly8cy5MYdsH44/rzF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WXsj4J8o; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WXsj4J8o"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-5dca1efad59so356947a12.2
        for <patches@lists.linux.dev>; Thu, 16 May 2024 09:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715878642; x=1716483442; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=k2bhLOB5Q9K5+OsYlbLnqM08/oUvfJSr9geEiHh0y64=;
        b=WXsj4J8ocROG2o9GuSStFqta30yPMrwd4zteveIUsP2sKSDddn8DpSMK9WzYtnAQ1S
         K8CV58cPEZ6KLkZ9GEOYdqbgQfx4RpBDgV9v4OJHBaI8+EhLVy+zhqxWkZbdKcmenWuc
         Nqh1fTLuIkbPBW6tO04gNlgcrZHcstJMKP1a/5tR9I8w9SddvA1+RXd954bg2jDeBxmF
         FObLwGyF2V6u1wEDmVc9pVtqZfWPywuIo1pABATryxO6k7gpAo7kZfqjGsvi6yz+pWvY
         dsmijPh8CcNgMinCXHriTYw25UuBDmaHALwr/E4JbFRWrv++nxKdICyP99hJntJmDxKi
         IxRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715878642; x=1716483442;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k2bhLOB5Q9K5+OsYlbLnqM08/oUvfJSr9geEiHh0y64=;
        b=MFXnPR9+IOqCnNBNAMkQPWG5i8VhKYQJ6FjuVGdehPJFvi3SV5VFE3YPzwp4qK1voo
         0qg49LOKR5dX4NiwOVXoTQVYIECa9pAySK8BWIFaBHR3wvRalFAsxjoTBPRyh4XReBXr
         EC60FWug+5lRAEo8pOAXEtnuru8cg6WoCm+ayOpl73MRnSutxDHiKeCR9feHL1Mij9ES
         eR7VrFmR4oepT/ulmfo9j3MM8b02M1c1z/n+upM/wmBgSitapOY1X8D9v9g2kmL0C4zn
         x/CvToK2pAAa6LgXrIPaw7Zlyp7ZYkUWpJ9Y2SelkB7OteC+U9qnrf7BT5MDUCDZYqUZ
         Qy/A==
X-Gm-Message-State: AOJu0YzdTcierC7dhxvYt4DQ5NdSc7+jNFFF/X321nnt5oi8+XXzvdN5
	B4kxa02zNS/r2fECHS/khvU4jMud3JhLy89sdYk8mbJ/IqoUTnZ0
X-Google-Smtp-Source: AGHT+IHlh7QdmSS3WTCAoIXebwSunD1syWEbtM4hHp4cPjVxYk8uj2sH9HnFjZi2zCTFzp0kyKDsNw==
X-Received: by 2002:a05:6a20:43a8:b0:1af:e09d:d98 with SMTP id adf61e73a8af0-1afe09d1066mr19267558637.60.1715878641527;
        Thu, 16 May 2024 09:57:21 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-6f684d88710sm1306325b3a.80.2024.05.16.09.57.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 May 2024 09:57:20 -0700 (PDT)
Message-ID: <9086d2fb-e464-42b5-a264-1000917c6bbd@gmail.com>
Date: Thu, 16 May 2024 09:57:19 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/244] 6.1.91-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240516091232.619851361@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240516091232.619851361@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/16/24 02:13, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.91 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 May 2024 09:11:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.91-rc3.gz
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

