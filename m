Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D221C6B7
	for <patches@lists.linux.dev>; Tue, 16 Jul 2024 18:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721154213; cv=none; b=IYf0nRwKeEDp8tgDC6fE4B+gTRqMy2fxG0Quojtip5Nhyok3tDrCJ59Y6sYYxgm/dYcekluDiZFRlQ6Wo7ov+jrwdPfnlVLBoIlB8gQ0QEzqv90gF0xfiSud5mOizrRaYUItI5hIKgjmIvjfpNnVMjTq2CRhH6jPBYBdw3bihTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721154213; c=relaxed/simple;
	bh=BKt5xsXhkdBcvCqqnMHb4pGJ9FJn/IlmyieTO4qcx4I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HFH/13oS+Ne6OqXNJg95YGEZJMEnx9yO6Za33y0hh/HY51+JhstltFwUEbefgqIG7RKB54oZQkeYK1Vaabt3p4w0LytbhZDi7+kytaRGbkLktD1QFtNmSZPzbUrs874cw4bLI9ZW3IDt3v8+TU0pjE1IUPRG2wpwlqDfiZ45Ew0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iK8V+/Dd; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iK8V+/Dd"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-75ee39f1ffbso4052430a12.2
        for <patches@lists.linux.dev>; Tue, 16 Jul 2024 11:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721154210; x=1721759010; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hU2WUxOdEYMWjHVCKzeUA8Qq59FBn2+v28YS9SBj8kI=;
        b=iK8V+/DdJ2vyBXDAO6wORqoGyYIfvZx07nSKch2SVvZQ0N07RcOFRGaIj40AaeXMz1
         6pDkiyP0alYnHcbH2MDACFPb2F4EiBgHyCNtw0M7Dxk6sMipy1xekzqGOZ6zRZlNGDhG
         OxDYLlbqgHTdbpsZAe/SQJIQLArmi6Ix109scReT1aN2A6E2upcTp/O7hyF9TRlfLfwb
         zJa3i/7LnKbLM1j2KuLMhgl+9UuMMBYaG97+PP16bgUvkMEtNVvP5+z82MTB+nZhgUyd
         OCKN34b7Ao/kthRLEDV6TGqUkFou6+Zmh8fxDWzIPP/M2MzS78sqkiSZN2SWZh+sE1Va
         O0uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721154210; x=1721759010;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hU2WUxOdEYMWjHVCKzeUA8Qq59FBn2+v28YS9SBj8kI=;
        b=DJU965E+oJl0qX3Xxr90vafFAzFzv+H3BuONWy0vWASoWT5DC0KfJXiwX4uNWUUBbD
         ju1sVNyzizfgn2aqaZNWkMSqzQYao0Y6MJSaQaZh5fCerqt/1blFL5cUaZtevAViyYzk
         Po/z/AIDjyZF/kJ3S+jDPlJ1IfNDKm7e3+13NQ9/CQB7qqe1Wn4njBs4J06lVDkndSep
         Pq5BX/7iPwHIMg0IUKapVheqJB6mrQ1ntl4V2s7pysof/Lp11NMdRj3vvZXgf2DUNH8r
         XRtsfU0FDpdeuFN+zwc5Kjka2P42N8y0AsbY0dkAi/2e65bnIVvII4ToSdKWgcAGG3gR
         Akvg==
X-Gm-Message-State: AOJu0YwM9IWAX9SGZVDHcpCbcFV48sgF4ctPqH2AooAequp6ia4jeS2k
	cAlW1LA8YS9RytB5LhJgy16zaDWCYUV8RBmBDK1Uptc1IfgbPMV/
X-Google-Smtp-Source: AGHT+IH64YZd43c5HM2OovaMMEJBUEGZWYmx6/asMW62Jc2JJR2BQvxJy2tdoJu5j83Asvb1gdgZGg==
X-Received: by 2002:a05:6a21:9985:b0:1c0:dd3d:ef3a with SMTP id adf61e73a8af0-1c3f123ea4amr3987370637.29.1721154210077;
        Tue, 16 Jul 2024 11:23:30 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-70b7eca7545sm6651358b3a.153.2024.07.16.11.23.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jul 2024 11:23:29 -0700 (PDT)
Message-ID: <231354c7-2480-4503-857a-12946366c1df@gmail.com>
Date: Tue, 16 Jul 2024 11:23:27 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/144] 5.15.163-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240716152752.524497140@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/24 08:31, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.163 release.
> There are 144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Jul 2024 15:27:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.163-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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

