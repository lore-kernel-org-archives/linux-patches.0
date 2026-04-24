Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D4B381AE4
	for <patches@lists.linux.dev>; Fri, 24 Apr 2026 20:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777062471; cv=none; b=Iz8kZ9937NwDSBRGYXlbF5sH/R62eDoKmom33cmwyHS5vgugJE3iNQGmj0eyVYdVVJHUZ6UX1I5kK4Qgwcoo+i69Hyd46afOpcBgPJfY25lIJf1RdjQt4XMMR2PuJ8QnHfpYp/bjj+MFHJtmk5XXbCmURcnayYcLTJK8ZSyBj0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777062471; c=relaxed/simple;
	bh=72/e5fgKea2425Wp13m68CVeq1yzKE0EtFY55hVE0uU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YGpQI7VMLHC2ZoDAPCYK4ZNAPVAGKxltVTpQlaMjCHjZMIJW5pOEA28Q/SYPa6HN8uSabHgxsl0eWoFQ+YVRk0HZVbWp7bjyaPvb4nieHV21z0vLtWE4LJqYra9d4SDkAq9jy2YvVD2ICDmp/zaUT0net9PpuqtdItxGsK7YPUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nElZnJTi; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nElZnJTi"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8a3b0242631so100734436d6.3
        for <patches@lists.linux.dev>; Fri, 24 Apr 2026 13:27:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777062470; x=1777667270; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hns6WlVS3Vqy77Haz+q8JSAZERUIlWuXdOePL/cMISI=;
        b=nElZnJTiSlCllBvePkn0dXfqm6x3XB+cab1i43t1DQmLKjBerEJjg/3kgq39Ie6q1q
         gvQ9lE9htQW5UJf9zJbodEqD8CzmIr5ePxWDMK3uLMFVSj+96dHsmG4VebX1wmZRjGrv
         BsytZ5gqPrKLSzuaeNnXNDe2JfFHM4jdBgI6wkOt83Y1kXzmc1N9EIUZzu9BedtjfIdB
         oIvIb45G/agKyI2PfWjowrW09jCf0VvZ4PrRO9kzJO9RhXNfMldrShHdZS2J+RowTS6O
         sap8BtGcKZosGgYgKVFc1vx0ka12nnNhb5NadejQrZpAjziQAks0CLdLIfeKaZb5sraN
         fchQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777062470; x=1777667270;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hns6WlVS3Vqy77Haz+q8JSAZERUIlWuXdOePL/cMISI=;
        b=TPsjQ0BRs/drdZYlXJAAB40+weJFIPo5AOLXApqgt3lbGPvajedLudWL/RipwgEOEc
         MVYDK3KHqCnE/SvKncEvGLR8q0oscc7mkKSHM0rWpah23rzm2IbRxSf7OLHanNUsNyBO
         JPEdFDz14pA9fKYAB4CXrbo8UYX37svgP6pRF+RdzGo0jnBVpmwlaKOB5zzHa9uroN2N
         t4JW0M7tVlBBtLhzQjmQ8O8kM+RbJSYdtEHLLh7eTIWA6zYda6vxSXWfGfBAscpS5qw/
         VykPagVo567kKyF2MAO9h9SsDrS+QKB9JrC2cNExoZjuD/C726XqW8s9kZ4x3Bn2VpHC
         HP9w==
X-Gm-Message-State: AOJu0Yx3h2cZeR+NEqaHWeF3m+RZZ+cCMLWQwUfui+qLsEDK3rTQzC0l
	uFlvvSRL9Jn/uYzcNk8v/pXL/KQllbavVcpeZCnpMBYzDaS79/yFk9zG
X-Gm-Gg: AeBDieuf87vIPzmKvv/YZYhbhFURwcQpJCdND1AhxfUpMN8/73zETstYcUCSOve02Ye
	CNiFxp1lzWq700wI7njC2w8hDFEY7rQZiMsn1nX7r0CMCdMShequnyecvYjEz0neEZn+P+Nwz3n
	FFxyRc5k+wCu1ods4nEWiUsB2nY637qOhADTJtiPk4vg47UFpTcDRW5EC0a3/2YfRqxF+Pafp4x
	WQC2cbAUrH0s2xtAUkwrqE8q1APV8F2n8r/cb3WNKx2ZXsP6zt3xIuSEE/b83vsn23oqaWv8nHt
	XiqZoVgDzuk189Jx+VI0bw6+NwHD95qZJ2TFb85b7wsqJScgunHiVNh44PkAA8KQVRYoSXFi9KN
	93NILfpYXp/lypw2JrNxQ6j36YOHCMfePFP4oJjD9JXsSCgO7Y5YwXxtyIuDzv7Cqz0c7SvmoOy
	JrNU9bGZa08efzNHPyoZzx3hx8lCOB1t7ekhcn8ggwgVxb68iIjl7AhuA45CIh
X-Received: by 2002:a05:6214:3385:b0:8b0:22aa:7137 with SMTP id 6a1803df08f44-8b028156be1mr549744156d6.45.1777062469640;
        Fri, 24 Apr 2026 13:27:49 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b02ac77546sm183330706d6.17.2026.04.24.13.27.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Apr 2026 13:27:48 -0700 (PDT)
Message-ID: <f16a0538-cf04-4e41-bb0a-d667281c49f9@gmail.com>
Date: Fri, 24 Apr 2026 13:27:44 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 00/55] 6.18.25-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260424132430.006424517@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260424132430.006424517@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/24/26 06:30, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.25 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Apr 2026 13:23:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.25-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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
