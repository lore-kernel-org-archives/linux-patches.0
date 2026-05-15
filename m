Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB2637AA81
	for <patches@lists.linux.dev>; Fri, 15 May 2026 20:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778875825; cv=none; b=u4ZfLeSUmTDT8SEIKxZLDMCAEWbF6RtwxIb894IJFDBUgfj/IJlj4fAkUc63Mue62svH4uFV7UTwrq7e6GIfDuHnxa4EGbfoLRJ3v6kA3dCVkQi2XvYjxROU9n7lv2arFYR26iGeOLoog2uao6iAl5YS1Xkio/Zr/FjTz+p2pPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778875825; c=relaxed/simple;
	bh=iMr6F+XGh+agbt6BAuCgoA8GaHVB1+Ut6Yp8z1X6hPw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NjZ3ZorMCQJ38bvT7q/JSj/5ayNXzxcFpheEDZ3EPswObCUUzsB0nJ4I/C7rQpnI6y6Gs9RHjv5ErxExdsHOtMS4KpqOlRyNYqgBdBj9wuH6lpmNh3wNblYPPHYE8fxD5ELo2m4uKxZNBGhmE9PftJrUPNzUh3sw7x1vtbAD70E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XV+PGEiw; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XV+PGEiw"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-514ae601df2so1402381cf.0
        for <patches@lists.linux.dev>; Fri, 15 May 2026 13:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778875823; x=1779480623; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q3mTIxvGa3/JHUzogiVDiFKb5HJChtCasPrDO9YJqwk=;
        b=XV+PGEiw2hhD64tmricdF9CY7P8fI9uD8QOoCgwVJB8QovaA8ZuEPmIJNOVJblaBbZ
         ZW1rmz3I0tSlp347PoAb8jGiv/X7tW87T99em4pPT82eU+ZL4N4t+dKAUjNGIIs3Yih+
         kig9WjsBf4yxT5pnfy53hZKamk8B/9gtaZEQpPWdtK8bt0B0LrnD+5/+XA0iCZlY6JxZ
         XvTJfInNho1EKGqCVxl7/jKU7JySg3zCgRABobNtFFQzbIGW4TblOh4iDZlP+asjGCu7
         iIImfxA8mUvv5N3IwBN+98y+S0DS0Caw4eWsGEEpHj/bQXu1Qwv0IRYYhccZHn/Zt9c3
         hxEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778875823; x=1779480623;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q3mTIxvGa3/JHUzogiVDiFKb5HJChtCasPrDO9YJqwk=;
        b=MFveu5kqc/P0z4+g+uYGeJZiE8Onhg/ed+q6mdLl+DJR81VYvf5tcfBDRxELZBcpFl
         nqa3muKDG8c16DkqO2C4s4nBtfXZ36qhkAX+QqrS3CNSklGjqmrWlPF36StcPjoPuFmQ
         FYueOCAU/JcR6gYWbp3TEUlQzk8EbuVPA4nvC/1Ed3Lo9DR22ISwcXnaj92jAUWpPJpk
         nGAdjIHCCmjdAKfEFpTOp+A70aVOsfXZGXBmlbY2I8czNEpZSKJQxEDK4+8ShGUPpvQA
         cFGgt7bzJrO6n4jPXAnLfaS7wyKNSnHOUHEgMK/Hk2klzqts5aKqVr5gx/sANiSkRXsj
         9wTg==
X-Gm-Message-State: AOJu0YzBNzXUtrTBq5NdRAn7zw1huWL7L5BXRgnN65ucfGKRlQA8fzzq
	lZV+4O3k4coAZ42xtFuUQMmQFF+yMd9Gd2ckzvpA0rpK7h7eULZqO864
X-Gm-Gg: Acq92OHrog/+3yWQAkcRFZwoiWTdCtT8LWUsL8KIRArs+nno0Lub/27NSjygeRynoHg
	emwUXu/rvT0CrnCGeN2IEVA6rAYsRwUQ5MFL9liEeLV5sNj19fFxHB4b9hGA90ikGUAUqGnc5LO
	qZvE/O0/1pEDcPHSaAcnAQHNj2rLNWiqFAVGtFJvJbOf3HbIEqYaO3LNLm38AYWTQNNRVHkWWhg
	NBamtej/8JrF8jvq6qqm8nNVnt0oy4dmFBhx2rvB9otZh7on4GkC70R5BPf/rRHORp3kvEtOR/h
	9CUKopJzyIHqgh3cbBntkwNNTpvOG8wLAHeJ3jZh3ZMCBmrCTO+slwGPWPRoTnbY9hI/QKF/0q1
	hFy6eqX1z+yM/3YoeaJ1TIyHUFk+aaR4lgFbQaVPQRQqYSzlkWfCUf3t3zBpGB2b/wBtGgEX3lS
	CIRVthO12nRe+5/7S+MJvR6DBUmfXxcKDwJL8sBBnqqlPjw3tBBg==
X-Received: by 2002:ac8:5c92:0:b0:514:6650:eea4 with SMTP id d75a77b69052e-5165a296e10mr78269661cf.57.1778875822893;
        Fri, 15 May 2026 13:10:22 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5164581fdf9sm54220651cf.24.2026.05.15.13.10.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2026 13:10:21 -0700 (PDT)
Message-ID: <2767a740-b8c1-4bf8-ae1f-fcb3d357ff57@gmail.com>
Date: Fri, 15 May 2026 13:10:19 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/474] 6.6.140-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260515154715.053014143@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/15/26 08:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.140 release.
> There are 474 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 17 May 2026 15:46:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.140-rc1.gz
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
