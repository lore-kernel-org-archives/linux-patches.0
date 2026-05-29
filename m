Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D3B373C1A
	for <patches@lists.linux.dev>; Fri, 29 May 2026 19:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780083114; cv=none; b=HazcX8l63gYtGe7ykhAABTWzo9sF9IMKt+P/Js1uo+XB1zbWaMHT5fz7HlyjvAsXJjHkBWH/Jv5tQnWmVt77yJxjP0O6zb71aZe7I4Dbkgn/S2vkixS3hSmtNt+k+ugoPSpwkyMsOfQj0MEqL7f21AxApd6kjUFaPQ3w5aSGniQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780083114; c=relaxed/simple;
	bh=rmivC7Vsnlq0Bffptwm2fb6KzeUULgpxpo2pG0XYk+s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i7iDpft5ZNu38wbCH3seYgXhq9lBefOXkdihT9OIs3MaoYSVF3I1q+5xU0PPXRU+SxQZ8705Dj862G1HJ0Uw8YBvGykGVbQgn75H3hTPKyt1hPsHL/MWUkO137iwkWUwUn3UL0UU3gUScToQ8iX7Nl6MqIvkvghBw09tTIEdWaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AnjbMEQI; arc=none smtp.client-ip=74.125.82.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AnjbMEQI"
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-137d452574cso471393c88.0
        for <patches@lists.linux.dev>; Fri, 29 May 2026 12:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780083112; x=1780687912; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PEjW67BYxgfB8TQaCwi5eVTcJeJmSm68YAXf2XxNoog=;
        b=AnjbMEQIUIkmxyA1YaRCINAOAdWm3Wh2K268EGPE6PGFrdb0nWx20cfHj5Qwpr1Yul
         XeewgrJEYV363n5kAOmoDCCtUD/Lvv87/V550lzuqUNY42yN6pLzxZ+dC08ltnzIsi36
         AbbgAWjgBXKaUlqcc6rVS5hmfpd2pjWoHHIJU6RjEd6OBNEo0Bw9gcTgZOiXW4TxtEoo
         SkKI6Y6KRa3iyNp0oJpjE0yJg8fkACFGfGC17ovfzRSWPfGFNUhkIPzb1xEgsOSf5Gw3
         C+r8pqgy8zh9DEEBU2+KJBEFJLcEV6+ElNrKSyfNBqcHC8HyUPXe//eSChar82G6SD8v
         uH2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780083112; x=1780687912;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PEjW67BYxgfB8TQaCwi5eVTcJeJmSm68YAXf2XxNoog=;
        b=XMRc9wa7BNn0SSeQx4bQ0AvqOFdWkjJgTiCJh7+xnVJSlt7F6ym2/j6wze0vh4m8fm
         3T4iSft+faO1zwS5CScn02SW1PvdZGQvqjazsYVDFPNN3s+RfA88eB0M0nHAsLb4WVoE
         d9w8Qi5uWEWyhhUnxfhjGFSB9mc3jF++7sEvioe9UXRLFRTJtw6uxg2UkdiwdXxQrkmF
         1STuDqoUqX6zLMJXQCvtsKc2rC9GacCwqdUeUM8q6SpKqHly2iqZRKWoOXc2Ohsz1H5n
         VOnVDY7Tr8XCGIDj1TaAxW8EtVBeu+3z5hZxtFtpKb3M8piBoJgla9uAAPc025b6ItG1
         B22A==
X-Gm-Message-State: AOJu0YwXk2wuXZo9WAmKGU0JygmQMcJxGnb388BDJrjifSTSaxkweHaX
	TNXo0HkEbdw9bA7kL4F2LfqMfKHg++iPcuHECU8xAfBSh+latrwbphT5
X-Gm-Gg: Acq92OH6Q+K3h4R7am3hzhWR2pI37Tx7kOtTM+yhngg15OOThO05VSOMribmlxN8Lc6
	t/n1IP8jgryuvnd4HZ3gVJ83M/m29fWnG8C3pww0sCYcSJqXIAXKVwLc61W5TUWz20JI4158Iy0
	vdPD/lXrEurM6uLiCC9KQG5GGD7ytRcKHP8c6dtYZbhD8VeWjf+Nmq2JiRzXbKzKPUzypeZLi/5
	WrqBnO99bD7Wq4xEo+D1WEmw0DRo0Wh6QLP0SacJvpYYJuNpM8CO2cETVInlDiI6Zjeh6F7faFX
	8pqkOB8hMBRxJi8y3HoJAxyg5t/1laGegYZMDt3qu3+3id1faBa2c06Gdvkif+lh/d63hBEez/z
	SU6zPlZKr8wZulxGaGahrsOmtWpHPdwwYROvBlMZAluzD4A8lYbJLqdtlj8N0Ap2gRm10JHWdgr
	OPDrrNON99tazczr+BMkFdCaxh0w/1a9OY+9KiZg5MBKxsf0e33ndVVvNaFOzQ5hYdw6le4P8=
X-Received: by 2002:a05:7022:f418:b0:12d:ff1b:92f5 with SMTP id a92af1059eb24-137d4283a00mr455015c88.28.1780083112008;
        Fri, 29 May 2026 12:31:52 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-137b36af6edsm1788667c88.5.2026.05.29.12.31.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2026 12:31:51 -0700 (PDT)
Message-ID: <58e9bcb4-f73f-4687-a497-511cd9786ca1@gmail.com>
Date: Fri, 29 May 2026 12:31:49 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/377] 6.18.34-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260528194638.371537336@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/28/26 12:43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.34 release.
> There are 377 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 30 May 2026 19:45:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.34-rc1.gz
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
