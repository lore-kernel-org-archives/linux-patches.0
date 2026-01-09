Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440871BF33
	for <patches@lists.linux.dev>; Fri,  9 Jan 2026 22:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767996369; cv=none; b=Xv9gd2JC7RuPowXuU0Ay/OOx3v9Vs3FRRxg1h6InvoBI2Af4dGh1uYv//sTaOMmOx3dQAzAJfDFCkm12RdCcFqlq7KlQ7JwwUhY7/UgfJFv5H8zMIxV9inRBUdsAyJm1z03iEHZl3Tcp+aaW3A/VhLCKoD9vL5gcr1aqmQTsiNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767996369; c=relaxed/simple;
	bh=swwFGWg/jJM7yv0Xw7oHtYtyit1HnAscQ4AwHOR42rI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TePYe4o0xiYnuBnIcRMP5/3pAJ4Yr6tunesImpAY9RXNSUzau/dl17rC+cl1xUDvw3cDuYcznhbIMyPEgKgtCMgCeKC48/zHD+A0Z1FSwMxwXIdJ/ZGPfqPXixHSwVSnfnr7/U2xt85M9Oqx6rukeFEZFHj1bgMnJb1f1Gpul6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CWGN2cUJ; arc=none smtp.client-ip=74.125.82.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CWGN2cUJ"
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-11f3a10dcbbso4035145c88.1
        for <patches@lists.linux.dev>; Fri, 09 Jan 2026 14:06:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767996367; x=1768601167; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=agPABsKkhvuouLEAS2GQt5eEaQkhiWfnzTAz4qrEzlo=;
        b=CWGN2cUJjkY8S0v/JaI7djvszmLA8OZE0h/fdLHuDxwZDGsF/XLYPGxnyAs7GkBLuM
         huckt82Vmb1nksaPwczSLB4516170ZoCIsVcD8pswtT7xmo9g4K0BktplfiaN9hK0OnG
         g6UPNCiNxUnSfRFrrgflLexnalb5vhU+wVOAdMz2Id/dTCwwKpiLpQl3BPYTyqwi8Xfw
         CD77POSCMJaQfbM49PlVpOO6N6xUj5yA0YlS9DgMo9cPvWmngo+5cPU1KkeLzSjCKQYl
         Ugh4Od+MgH72nkpNaZ7iCOp15ufk0zJ3og8gexd4bKLsu4iB1pQ/pHz0+k+Fp27+0yVa
         pmdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767996367; x=1768601167;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=agPABsKkhvuouLEAS2GQt5eEaQkhiWfnzTAz4qrEzlo=;
        b=fEIdMgl0kYGOB11V/c86wvFtC1UTJHY0xE+qnWA3JrEEQ9lLRo439fvVAuXlyhcX1k
         +Vusx6F+ydjK92Lxn65Fg3MiVFNKl+nAFNZHG2OggbYyDvloWN0E02GqK9QhFZRc1yfo
         GqfxRvwfzguCpwQ8ipAHiJAtoQUZG+hVDKSNd0r+HiOO6jyx4yZAjqHqaVCwUbkZnwtl
         RsLFq1bVqdP3wfotucb3MiZCBCr118sFdaikmKLPTCE4nTYv1n9hkyuI6zDnXqAmcSn2
         Fpbh/wftv+ANb1aw0uVLUHriwfNri4G9ACSsNIY3XiSJIDUUgP+HafQXhe71vkZ+iZh9
         xh4g==
X-Gm-Message-State: AOJu0YxPsKeTyEdZ5TMwAsZzoBKWeOTC+A7NhGWcBbse/g9NlU58QLSd
	Tyubu/Nzp3ie1J+xBXUr5+5zI842NS8uS3A9Rk7olFwer0RS+n/x7j1j
X-Gm-Gg: AY/fxX5Cw20ahE7xUZ4juTtzj1WmIKzc23SvrQxX9JPOuqJar3xel/S7ft69DWHjg/o
	3gHSQfMGGqVtgxqP7SrjZUFk49cCnJZdd4YvzNG7X4/sMQwkKwLZnt8i/MGP4/fgFDYChAIEgWA
	9VUV/t7AkM9Km4Ih8/froMf/aozCHTxsZVU9UxaGLCDFVkmkiY8V5zOaoapJQBSpD22cujUAHce
	/E5T1dOpSGtcWhWBviKUIBNSw7cReeQWxE4/TOqR4U05PlZqAulCuZOVbyJDjnLXwYC2g2VG4Mb
	lEx7P7jYnTD1gS+QdUVnYd36NE4pOdYDX+o8GOQN3DPzYbouFozUlLziP1od1nTWkqjSYD7UAv6
	6PbyhBQfdLKoJsintfnpGTS4OwrbbZXtfzgXZ0uwY9IHecVGSjlBILbqwcbi96zWBT7Ah0rYous
	Qc9za0atBJLVNIbOK6hVTE5AoXCvbtxiVxAezZVA==
X-Google-Smtp-Source: AGHT+IFpDvZmcjnb0/gblc368UV09XDLk6L/2cdvvznpi5MwFjdKdvzlHIWKhVg4BUbXE9DXSL3Zvw==
X-Received: by 2002:a05:7022:6096:b0:122:415:25ed with SMTP id a92af1059eb24-1220415265amr5206420c88.49.1767996367271;
        Fri, 09 Jan 2026 14:06:07 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-121f248c16fsm18561401c88.10.2026.01.09.14.06.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jan 2026 14:06:06 -0800 (PST)
Message-ID: <adb5cdc3-0a24-497a-b506-266120355e42@gmail.com>
Date: Fri, 9 Jan 2026 14:06:04 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 0/5] 6.18.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260109111950.344681501@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260109111950.344681501@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/9/26 03:44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.5 release.
> There are 5 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Jan 2026 11:19:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.5-rc1.gz
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
