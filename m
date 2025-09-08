Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393A621B9C0
	for <patches@lists.linux.dev>; Mon,  8 Sep 2025 03:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757302933; cv=none; b=SYoPWpX/TSdLdTVHEqsoXEMsnKhihILV6QWYBqj+sGoHGU9GQf1YXYWRPETecaxmiLh9BqHRARMUtTvuzM/Iaet/63Po2gM9WiclNrQ5attn62bFYvVWUInRRZgJwZsx3ujIvKMZVjGwB4KF+tFELbZERaWUcHE4qAMpcrNeKrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757302933; c=relaxed/simple;
	bh=5M+38OXF1flKK/pe3Rn3PNxUJNkR9P158X1yqECK7ow=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JL7jHwJ/o60studBDbTfhQQSFvzytxBPsVZhIoQ4djADsnGFAbm3FrL1nPHhn5fujzGxFjXJqREBjXxyxoe1vnMp9ZrM5iiJWhtrAtm/4YD4hgWqQ508eGsEcBe59hgb5K+v1COjof916ZWXcCS4tV4LY6Fse9/hrVx5bu9T24E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mjbbe5l+; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mjbbe5l+"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7728a8862ccso3434310b3a.0
        for <patches@lists.linux.dev>; Sun, 07 Sep 2025 20:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757302931; x=1757907731; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U+1e+0HUdg61yWjXPaBCQjQfa2BpP6AkAEc+WzyDYgQ=;
        b=Mjbbe5l+S4V4nlARFvnWcD7EfzC4YmSb5rNG+1QcVOkhT21qbibcsyzbD4cddaNkOJ
         qa0lWqPVziBtFUgG04p/Z0y4coq5NNX7Cb3Ay1Zk/UIkTWysDdke1l7i2B691sEr3u1T
         W0u0UggBN+A4gOfNdV+FwaM6reV0mmQpx90OuoFkYcixQgZ26n0+k2CvIGHQQZwxZo2v
         f11BLU7O3S5dtOLq7RSvt7DiV/vPYPDQ3Y+GRd5T2ovqLuKwY436B5KHfvfYxj6wVC6/
         wKT7y13LsPeqr4pTFqV7kj8uvCnxsFEsJMLEEfje0w6204w0C2axPcZi5fiEfxREGALe
         lClA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757302931; x=1757907731;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U+1e+0HUdg61yWjXPaBCQjQfa2BpP6AkAEc+WzyDYgQ=;
        b=Nl6N3ojZW6VkWMecJnm3Q6Wa1kIIvleFawTC/Tg0TvarYNIRHovr1F5AUGKm5yOQzr
         I0zL1SWUnuiB18S+/qajg71MB6mXEUuiRl/Pf2ynwhmWeevkh9Cy3cWKe+dMNUnwG6H9
         WnKkrX+B7GvGl9kNdjOvmDR20nCW3JRa9UAKMdDFplfZj8HHMWnlL/Ys2W1RtjQaz51d
         VsDr6MhGkU5mYmokFrPA1/ThSa7u9VgyB0nvS7RO9wEojk+0DQBr8/P8XaW8g9XvqHy2
         1W7jf1jz21aMUzNAklN78kKhyZtlJ7x7r/TqaD1r3rPDb8Sa9B+uCoQOFE2k/iMgLMlS
         wihA==
X-Gm-Message-State: AOJu0YzJ7wpi3lGrSnsoa7TtiGzJ+d51o5mi/er2/sNjKN/GxNTlxQ92
	PyRx6zOCB5r5FIiAaZhqkaJubsFhPhV8/AISWpjnze2+QoQoj9kzG9I+
X-Gm-Gg: ASbGnctZOWDnMKFRDjHtus/aGZZqkxlMnYZnO28XZhGFqT8aRurVz0Wy9UIPhEEyjTV
	nyY/mJhewwXpPl5JH/vUtU2U8W5nWdFKzGKvNPoufXTYt6NHkyDMES1o6zzlOTAmi6cE4ffkZWb
	cBlzNtPiG/dGwKwL9zn3aqO/A7Ptomd/47cR4sEJOxauQ825FhhIJMYE/jJKE2G6pjYS+uKxBqK
	En9rMhBbY/HV6/dUtj2+ecwTN7JnWSbf4DWcKKHD37IRL+KPJibMWFz0EHRxrB49Q+iXC/Qh5W/
	bQ1jeBQW5t4lMmWnoALK308sDX/katU1da3chVMhYBfle5p6JpK7GEZeMwU4KTGSF4+ZdjpQowA
	Y4TwaVmvfMcrsIFGzHzvK9pK3ogacxFi2vLXV9x07ZyIxgH2kkAbiwLA9I9znIx26
X-Google-Smtp-Source: AGHT+IFym9/ZyWlFSAtj45FEcnWbuZrDZ7vdDlfKQgVCfxByEEg/FOXBUbqQlwPkP1QsceSJ5oG9xg==
X-Received: by 2002:a05:6a20:1611:b0:249:467e:ba70 with SMTP id adf61e73a8af0-2537d380c42mr9254262637.24.1757302931335;
        Sun, 07 Sep 2025 20:42:11 -0700 (PDT)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b4fb15f50d6sm11545588a12.0.2025.09.07.20.42.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Sep 2025 20:42:10 -0700 (PDT)
Message-ID: <b807385f-91cb-4fb6-a0d4-52d240ae2757@gmail.com>
Date: Sun, 7 Sep 2025 20:42:09 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/175] 6.12.46-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250907195614.892725141@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/7/2025 12:56 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.46 release.
> There are 175 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.46-rc1.gz
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

