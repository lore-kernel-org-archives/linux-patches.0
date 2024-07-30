Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846F9145A11
	for <patches@lists.linux.dev>; Tue, 30 Jul 2024 22:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722380074; cv=none; b=PRCzmnW96nq+1nt+dftdLrSCD/ZujK8zzT30UddxeIBUTuVZf4J2HVD/AiDRK9y/xt6lA0Z25lvIXG6avIjk/er1ghxjK3XakMstOjXGrXfgmOO2cH++k97vmrLWg0vr9gwxGH6HrUY/+XlZL751JdUEr9D9nUDLQ3TIyfSbccc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722380074; c=relaxed/simple;
	bh=dwwEUbUzgWL5vS5biiRn9oO1+11MCQQo5aKWpvA6bqE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BL6G4pMN5n8s5WCSwk03m8dfFRNOStVTta2gM94f02MoTygt4+BLBx/c1IA4sR6B0a/6jIJcGaRen47VbFlLOAo2aQvVoUMtiNKfE5j7Ri2kMwYF11tHDyXzKi0HvVX34bwkh8SrZMQqYbt0KicCYRJAmnGLWm8/p/vT9mMAPaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CZcPDbN5; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CZcPDbN5"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-6b5f46191b5so27499346d6.3
        for <patches@lists.linux.dev>; Tue, 30 Jul 2024 15:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722380072; x=1722984872; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9tG4ibj1e6Js89Q0K69BYaWj3uwGB1GC2b5DG+Nb0V8=;
        b=CZcPDbN5AcJmsH7Mbb9NDwBGJXI6cy7sjClPHS+ONYxMw6JBxXAOr2BUcHsb86jIsW
         PQfpepzNisRN7U6lsphSxnnfK0QyZe83HGuptFHBHGVSEly+6UCuK6GgCGcJoofiPJh2
         tLh8RXB6+6je8D08rW6s1Ini37kWQjKIW41EGIiB6zjI0ntczltkSGpvLjStwDmNAJat
         JzqP9xhG1ZcFhI36364zRvBaOj+FZ3DDZSDL3LTUqTsmFg2msTEvygdaMMbS678LKaBj
         i5ODPANXfTO3zdpdKip+G29Yxgt028SbbCvkE8E1Lt1qci0t6wz2TloQK0XW9L5PYSWa
         Or2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722380072; x=1722984872;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9tG4ibj1e6Js89Q0K69BYaWj3uwGB1GC2b5DG+Nb0V8=;
        b=CZNcyQ8Z/daOy6Fs2VadnXut/VTLwzQ/Ix/7TxDQM+ILltTCqLo+g0DekbGAe+lO8a
         AYeALBYtnM3xrTkYzPYSk4BE8G72B5VnxKQFM+mxHifd4nUbUGP1hRmKeyoDeNic+yxI
         FljVf+DDg8eK2sd7X8miriOEBn3Ep3bw4JP1m/U5NQdNWg1HlL0j+PlLIE/dE1mixLqC
         U2lj5dzZQFpH197/lKBafZeI+56P8LPOxFyaxqDFYFtb/ovKmzjf2C6ruvw0EFIYANNK
         lr9S3fLOaw2EiczGOq0nqJaPHvGj1tN1jDnLhHq1VTasYuMwjiHQLg2mRcoCKdVGMpqs
         9vAg==
X-Gm-Message-State: AOJu0Yx+H5QNPkWgsnpNFUlHLIDMYEMHhdDg20xvoNGaIHnECk8lSmoH
	1/gKuskn2vBWQfp6NaXgFVpMYu7+GdXqpwqZcBi6PcUKOWVyJJ5n
X-Google-Smtp-Source: AGHT+IFGRAi4mVeDyJj/FKJYt1axQZPWTQGevsa8iIP75abxnaROHuKfpSs+p+ytCVHUtGmDutX88g==
X-Received: by 2002:a05:6214:1307:b0:6b0:789f:9ce2 with SMTP id 6a1803df08f44-6bb5599f07fmr176892356d6.2.1722380072396;
        Tue, 30 Jul 2024 15:54:32 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 6a1803df08f44-6bb3fa94e70sm67155976d6.83.2024.07.30.15.54.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jul 2024 15:54:31 -0700 (PDT)
Message-ID: <10b0a584-e07d-4fb9-99a4-6359563c1e47@gmail.com>
Date: Tue, 30 Jul 2024 15:54:26 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/568] 6.6.44-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240730151639.792277039@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/24 08:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.44 release.
> There are 568 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 01 Aug 2024 15:14:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.44-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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

