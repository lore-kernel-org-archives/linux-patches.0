Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293893A6F19
	for <patches@lists.linux.dev>; Mon, 20 Apr 2026 17:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776706919; cv=none; b=bJJTeW2aptAIhmEIcwpC5fXWzD6P1iPCbXTjdNcZuUuoFo5jngV3Bvrmd8GwrLQKmZZwDMg0kQ9A0jbiN+wg6TSKoxCHFhvMydRJgcCC11ie6nFqwujlENOzf3zB4sYAYn3Gip3gVSwlfs4oRNdGlCPJJ1viyA/PKzbp091CXO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776706919; c=relaxed/simple;
	bh=6mi9vFMIa04wljYpzGoEMr7NIMDp0gt2cIZj3a2+bP0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pxh6rdKaBkyaV3NiPqsNM3Tf/jARCfUAn6khOVu1pQvQX90dZlT0lypBwIpjuMRX5b6+dGLxfwKwDeRhG1e7xDHOUeTCK+hwnYUmQkFayH8MR1qTQOPZBQsO1zv3vZOwGuplRweAXDDFcmDQBYqN6aDg2LfImb7+WQVg2gkXjHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i8ejejvF; arc=none smtp.client-ip=74.125.82.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i8ejejvF"
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-12c8f9846c8so1515609c88.0
        for <patches@lists.linux.dev>; Mon, 20 Apr 2026 10:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776706917; x=1777311717; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eF+5pDaN6FkJBacKO2EApxwPjev2fE092Gz+F85hoYk=;
        b=i8ejejvFKXRtiqY4aLuiihUnMbDUaONStO2BeWnDFHdjCkynInaNuE+4gmi4+4zEjw
         hOEoXr6Ok2i9BzKUyMLa0VN2Bo27nm14xR8wHoh3l5LkGgahPA5vPwLoEekP99r2M2QJ
         C7fM7vgjYaHD6NGHsooVuRnvWq3Mdw2EhfyH6KQ2LOakcRicqLw6DaOuMY6xRT+7nBd5
         8GrQUEF9CkDBe9Ry4XTV8O85fbmChb1Z1QapseEbuyHBR/X2+lg9zBUPv/iI868rJ5k8
         Mg37JdTlr57lvOCyWKGOo4+Bzvv2i4h5eGfFnioU6txVglbaCxU1RxgjTkURmEov3exj
         E4mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776706917; x=1777311717;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eF+5pDaN6FkJBacKO2EApxwPjev2fE092Gz+F85hoYk=;
        b=NINR9SS6WPT5lRLVxkt9V9qichWFIz9edqE8Mt7yh0jXA7iHVBpWM/ND1idgxyuUGM
         HCz7dXNGwXrmmdIV0ufl4EpkudZeXnR13koVR2ZmEI616dTn8HByN8BblF+K09b6F1oo
         c1TTlUcBuoXi8AANz35vjH4Yq9ntGqvnHPDGxUZx+XRjbwiXw9haJ9okx3xwUBMj2nP9
         PsibPkUDL7GSty4YhpPCTORnlp2+7qGunbuw8/3fmkLBB1thf2Pt5uDjY35iS7tmHEVn
         wDoAYgS+cwuBaBYyyflpk7c6Fjs0L83PNPVixZGhfVwFdFYhhlIXS9k1mAI9iZF/7qaI
         NPVQ==
X-Gm-Message-State: AOJu0YyrFeTI1+S4vcEM2EpFhVvxo5M/9ACpYDD9sS0+UhWbh5wTkBGJ
	uK7dVJXElmSUoMMG9bEnsB8RDB0UgWIxhFhJoDZOy5YkxiMi/ceOr+BS
X-Gm-Gg: AeBDievxiuWU+fbG2JHeNrnBZocQoDnmf++FzkNQwiLSEVxfZOUJ8H9nOP/Sc20USLg
	XcmYs/rlwXFKTHnm9vvkAqoeZnF60W5abSmAV00DwCMv6cry5Fmrb+Fct+SQJNrFFKcjjlwW5tD
	l3/WLkrUCgUxrTF1kLZ45FIVkxrKgNN/lQGhzO3mnntyXbz0bBNeyHjO+CcnQ16VDVx91bqz6Do
	WVeqN2A6Up9L95gL96Mx2Ob3wL40AV7sHLo0p/37+nfnguWEqgSt6er53ouKUcAZaRwnCWqL58y
	8q04CruCUJpGCAO41unSspGt/LXbIxbr7l3BbSgHkh3M1gy5fkr8fQycVkW+kQwmE+k0jKzz4+5
	P0MBrk+uu2cf9qNvFg9bdcsk5TdpZx8VQW7tHOofdPcBXxOTdd0iVS+IFR75sA3s85DGLI0189O
	yKP+j3N1qXWOC1ukK6c/Ph3z7UG8v2LXMjA8g7jCsIFHrWbXCNl/iGt1+zsoUZ
X-Received: by 2002:a05:7022:793:b0:12c:8cd7:d438 with SMTP id a92af1059eb24-12c8cd7dd7cmr2451612c88.9.1776706917221;
        Mon, 20 Apr 2026 10:41:57 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12c74a18a2bsm22787328c88.10.2026.04.20.10.41.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2026 10:41:56 -0700 (PDT)
Message-ID: <82329956-697c-45d9-96c3-44859ff04483@gmail.com>
Date: Mon, 20 Apr 2026 10:41:54 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 000/220] 6.19.14-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260420153934.013228280@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/20/26 08:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.14 release.
> There are 220 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Apr 2026 15:38:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
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
