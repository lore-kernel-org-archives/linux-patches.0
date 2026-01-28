Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8380C30E836
	for <patches@lists.linux.dev>; Wed, 28 Jan 2026 20:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769630893; cv=none; b=XIStQgLPC7oFjn/lOz6rXqW4iybKyGJYxPtS4wIRXTdTOzAyMawQfl4fenfldom+slhPyjN9aONRgh4MT/XS7z9deRUnRucckLDkqLkjylixLiwLkKA9GSuTxTB0mkZpn3m071ThF03jrZwDOHCofIM5vftab7aKZU4Ts5Yxa6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769630893; c=relaxed/simple;
	bh=DD2lnKYsXQi8JTHAXXry/C8D52xJPkI4ktiba23CyXg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i64v3/hQn9TyBpVdwHDfRN61ATIJAD+/DEjWAXi9QX8jERa2VpPxc0FA59nVrAkjY/FJk4uqxyBWNLJbXlUKpBTyevmBonHxigsNCs/hrMVyRHXv6GZDs/Xs80bQ6n1koUDdaZ2ehgt0qUfJtPTpjX6giqkEhHCoHhpXNC5ZCW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LPjsIqEs; arc=none smtp.client-ip=74.125.82.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LPjsIqEs"
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-2b740872a01so527351eec.1
        for <patches@lists.linux.dev>; Wed, 28 Jan 2026 12:08:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769630892; x=1770235692; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4VKrgT3u8Ct9Lfwm5qvvMFzTEIzMXojRzDK6hYzoIcI=;
        b=LPjsIqEsyyAiMYAfOJlY1MBa45nkTyv7pJ1VsfmqlfqLuQeaafxyjAxqLx+y/QIsoa
         N37M9jQSMh8Q3bHOVWKxSi4UmDx8w5zfehwEe07EQdJmLEkjA3b5Tov4ksl0cUliPgAB
         09OFlYfh4nA39Z4Nlr1Cbp7GKN3Iw+uofP7Oqjc5gs0SCkuWAtRPzurQ+0CyQwJ+9JGM
         FOqJ0MrBwNiogQNh67Cc5bPBQiGQ60k3YDUfKt4b0v/VG1e1TmS/UvTFIKtAzvVzFQvK
         AkWggfB9lycqCTvcas69GGOzM00unwqb1HWdJH0esWC1tJWzRn95k8ecvN3qoUtIM/6t
         4B5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769630892; x=1770235692;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4VKrgT3u8Ct9Lfwm5qvvMFzTEIzMXojRzDK6hYzoIcI=;
        b=aldDIIUmiCbkuNRNGYMPyM83kNL1RFEl8MPq2K5jm8RU1ilOZJr10dE1g7SxiErEgQ
         cAdHSco4mhDdhOV/fOELNEG2IP/SaSL09QWPlxo6oP/HEEFCSWES4+i7RjtvtzdxyRdz
         A6pSp3XT+x0RojBrv70QiUIgNk+MRHNugfzsVoUagKJKQfWPEdqYym5APpch3aZpzY7O
         W3SbR1P/mu64tq57kfisQU6tWie3mLWvxzX0ty/zImw4tpMUfg01tPog21h5h3J3bgZQ
         SN9A1yo0oXeYvETHyXt3unLRHCKUEptnvWi5Wzf4CLgpnIdiKFFhLtw3DC2Ks2gKW5MR
         x4FQ==
X-Gm-Message-State: AOJu0Yzf8OPf2yeatB2NKWwqFk0WE6rlaSmmY1MB/0DFWMjt/OsHX8oB
	HGvvuC1HcQTqkgMsZWeuwba2BjG65ma/1Dt1IZJ0/o9VZDAg37fWTXPn
X-Gm-Gg: AZuq6aKRUDrN4Nyvf16raoiGBf4DZuAUhHfCTQx985rmNOOewx/sPsaqapnj/u7eK26
	pK/TMRqYJtjU6XuqVeDSNP6YHYkyQOh0JyhNo1ONHBCYliLNWDjtfdikz9aaOqiYqpGdLlJvKQM
	4Dgs3MHTBDs/0oJSUf/db/xAEgvl8H0X1c8j73RUNnfROtKhVDvYH7GRT0HTdqFnBmO2Z+4Ln6n
	exqghXvS12ZMZjlgXlroR348AL2PAnZs4NFMke8D/tGfRoCC/zkWMJY7+LJ4RQko5D8dWhxfpKN
	6YOCmeG0r0EBPGpxtdkCbobVaiuTPb9LQ70x+98uEXJCWvcUgJjB6vohlj+WapX4G1ofSO9X95q
	VgBlVLkxr0EfBRusYEV/ZOWP6mt8WU1J56wIXVrJOYw0nOESZ+62XS1G0AB2TbURw40y1Iyx/V9
	YC9I371ctJxl0vpymf+9he6a9X2XDlbPaEEv8Fe9msgvxw/E8+
X-Received: by 2002:a05:7300:72c5:b0:2b0:51a7:509a with SMTP id 5a478bee46e88-2b78da12271mr3671598eec.33.1769630891616;
        Wed, 28 Jan 2026 12:08:11 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b7a16cfa25sm4051993eec.5.2026.01.28.12.08.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jan 2026 12:08:10 -0800 (PST)
Message-ID: <61211800-c308-4fe5-b9ad-d33978900650@gmail.com>
Date: Wed, 28 Jan 2026 12:08:08 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/169] 6.12.68-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260128145334.006287341@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/28/26 07:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.68 release.
> There are 169 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Jan 2026 14:53:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.68-rc1.gz
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
