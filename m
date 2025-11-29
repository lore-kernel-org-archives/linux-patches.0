Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBA630FC16
	for <patches@lists.linux.dev>; Sat, 29 Nov 2025 18:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764440882; cv=none; b=NDyxgIeasrLmLl1oSLfXC3S9ILwR9mgaXVcjlNvq/Q1J72EO5OwdaGIvLo3+q1Y0Bo5q+FCcCE3aASK5J3UZea5N0yQZNzyMVDSoOhXZQVOi6krk5VWSK117SLx/a9PQAiCO8MRpGWmnsgSRha8PVA+djm0gn+Gb7n8Bk4e6458=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764440882; c=relaxed/simple;
	bh=2FZMWlMhsFRsdyG8nb/9r421Iual8A70RFxKmbSV6ps=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b8xNauVxJAptSgeNQo+/WwHCNYCF+yCMWXisJgrr0f3HaDTuuSfDd2Wufr3b2R5tNz39bSQIdT/XiKzQVdl5M+IFrt3y4l/spT21ZOvDMAPMxqlWrdphnjBOByQExBkAog/+V9I63xjy/ki1NEY3uVfaSFlk+hehgPZGyiFUdw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VQjRh3si; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VQjRh3si"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-295548467c7so33452775ad.2
        for <patches@lists.linux.dev>; Sat, 29 Nov 2025 10:28:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764440881; x=1765045681; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q1ZNnmzyXK+QEuvpasXA8vnwZpIAkRyBsEqcKtTg0+0=;
        b=VQjRh3siBAKdC0h2//Z0/0Ywg5N1xHTyXPuP2CnIPmLhaTcuQYkKE2DqLQNhnDz5/C
         tohe/okhJtBTLSdi0AFpFZ2ZJwwfIKBj7LaTnjJqBpSi1ODSQd9EjoT0tSBMPn2Dq1w5
         v9j7Cuh00RGX6LMmZrf/1IJDGm4GDO/VLu/IOHmQZrN4H/WYd6FN7r2R5IZhwezjJct1
         +8RUZYIQW6jgGH2nLtH28UqJRA0MP4fLkKR3Mbtv9uSIyw0gQGhz/VwJBQ2mI5mtFaYz
         NixgeTPdEXzFnqpEzb3FvH1MZRf+gRZpUTJAxvUEjUNjz+GEVQQ3m5Gjg9dIBlbbdM9n
         xs+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764440881; x=1765045681;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q1ZNnmzyXK+QEuvpasXA8vnwZpIAkRyBsEqcKtTg0+0=;
        b=ce079Uo3vx2ZPpcNdfstZfQVrtcISymh0ucGf42m972lS8m75La+e19lJvn1sKMxGi
         PVbUB4WcgRCv1WBO4v+HoXbgZuCyzjNBNngXlCLSPs7EUus/rhynCNrrf/b0sVVfpNLn
         8D/zE5sUvIJ3tXjANzTHtTNqaO4A661FIQQ4Nw/LYYGLd6aOMrs9I83sc9sJYEC9Siec
         osKbfbDCXnFtTjv4fKmZIg3OVpmRxxt5w7nslaba0Afik3yEuMJZdZro5HfeCyoBBYYn
         HNQSaVmkyt3LGO+V5eRfOTBCzFR2o4sJef4jeFuuqcWTKWVbP07rwe9omWiP7X6Wl+YP
         N+5Q==
X-Gm-Message-State: AOJu0YyesDxALc1P5BHBts0i+9i2Ej2vIaaNunQJjACl7msLhc6NKf0i
	SQs9PItQaY1DG/gZmPdNQE1thowFwDGWJySsdV9EZtozepGKRboKttwa
X-Gm-Gg: ASbGncu/wlpRVUtx4og/5uSMYkLxW6dklkRcVSx/8RJ447XsVRhL+MSdqdLO02k0TAF
	YML8gCeCk11oYPgjPXsRHOCmztT6V8ljLXDzUWZBBqtMYktmli6Ev6PG3nsOQMZGyIVNaOZeS39
	U4dli2kuKJsu/GPhdkVl8Lc4Z/cyHM1EdDphJHCjjUQsUfYRk6FrZKQseerBDYqE+LhZffAjEug
	EYle9Ejns34Jlh8CqMKsI2M00loP5ZmZwrBB6O6bT64yob12Ilm/RS868+m/yg7R3fr8MeBG7Ff
	2a4sv5ggWk7Bpg9IuogC5Xx5hba3Ibo4o7eewEm+OJ17beHlwyxz18tomR4RpYUa4+9OecWwYiq
	F99mNQxQFJCIE/2hgDJxLY6qzLRdyYkzfeiHFX1I8x3/QJvbi7b5Gi99+bHvWIZ+5mWcjPpz/0t
	nLKP0QyFN77np6Z7ozKj3iKai0JEe68p6xGxIob4tqIRiS4rryse3I
X-Google-Smtp-Source: AGHT+IGsKBIqwjVq/z6YqD9YkTOEMz9bOaKVCUA/DGn8f4xoraR3Uunlrc8fGZpSQstawo1cRi/3Xg==
X-Received: by 2002:a05:7022:4191:b0:119:e569:fbac with SMTP id a92af1059eb24-11c9d852cc6mr24315984c88.27.1764440880585;
        Sat, 29 Nov 2025 10:28:00 -0800 (PST)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcaee7076sm33776019c88.4.2025.11.29.10.27.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Nov 2025 10:27:59 -0800 (PST)
Message-ID: <043aa312-5a2d-4fac-93d4-4fddb167526e@gmail.com>
Date: Sat, 29 Nov 2025 10:27:58 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/113] 6.12.60-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com, Sebastian Ene <sebastianene@google.com>,
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>
References: <20251127150346.125775439@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20251127150346.125775439@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/27/2025 7:04 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.60 release.
> There are 113 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Nov 2025 15:03:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.60-rc2.gz
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

