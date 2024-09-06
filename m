Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585AA11CAF
	for <patches@lists.linux.dev>; Fri,  6 Sep 2024 00:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725582076; cv=none; b=Hl+y9ov9AAmItD+kYuhFc5Viwrg2cGu/Qs1/kqpaVUl6+smPJ3smCDEBkEGaQm3cu9pJjRWhls/m2DwNjCXGqk7cx9qSYAoKm1f9vecSsWaw+xjsXs1tPXQtIDFap/D6QvyN2CUpsctsUbckPxyM7kWv32bHFaLpvXU4NuJeOMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725582076; c=relaxed/simple;
	bh=owTR+a0uY+nKjkw0GbPFXLIcZhI8MxnMvnqAe5CWDhA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Lo7/hKLSY4+inzEwqp1pEcsWC8Z/qs3GwmHVqmgOx5H9xDyeshGIupK+Lbixbci9eajHRWGsyCEIjZYBtdpk0vGLyomCmda19dQtXolz7YISHDDv1SY5UAbXMQb3c7HiPMgWoT0jprbzZG5Y3DG64uYK07Elln9xqqV4Wpy0YCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A+RpVswB; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A+RpVswB"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7178df70f28so1230887b3a.2
        for <patches@lists.linux.dev>; Thu, 05 Sep 2024 17:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1725582074; x=1726186874; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AutCiUe8QcaHzt6zZlpNdtcoMSCN8KlIsK8hvG2I9jE=;
        b=A+RpVswBufONCruW+3tMQYc/zcSGFIWsScqUywnOMYced6F+m3eRMVm/yq4WfgKwTx
         U57HvgSa1qYjWs3hIQBLY26IedSQVmXzBn20UNDz6BFyBIkYkF2C5PfxikidTU4GS5Yu
         srg1ci7aXp06M0P+tcqXGP8NfOGAAg7PjpRRg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725582074; x=1726186874;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AutCiUe8QcaHzt6zZlpNdtcoMSCN8KlIsK8hvG2I9jE=;
        b=DbVyEE+F33SbaczWclYUN5PcrKkQ4IFihGQK2wUbxGtRIecpfOLq+eXJo7k/OtxzCF
         EfJdZ2XMVdHmimN+xw5k4yJV8D4sweLJ8THXn5UqBLCwSZpXdhznY+HwlbLHHwAMEKP/
         //uFxb6hAQL/WIE71G2b/wzK96R/Qk65wQ4NBddH0TopNaluh34z/yAYiMl59tUHdCXk
         dceosH2k6d29bEwz1pDsEI4j/ET4VfxPpPAB5ON9o2o995fUAu/S95NG5CQphcEggxeG
         6cHzGBVnAlZf7sY55oEpUk1vAJdC8R49HlmDl5LL3/ksEZAorzZwGcdKV3RpgEpq1T7r
         OJ1A==
X-Gm-Message-State: AOJu0YylauJinSDUBMgk1zxigOH3fkEiz8ioSGDaQfPQw4b6UREhdlLG
	9ltghzj8efOa6ca1f+UqJrexDlPirXw/4YA6nPYNrD6XZIp77E/RboGTNsu9hkg=
X-Google-Smtp-Source: AGHT+IHL5DQmqDs0xR0qRNRgvtwm405Z12O4psQBNLfl+Fy2KC516a+TBgAQgdkhSe+GEQBfilqryw==
X-Received: by 2002:a05:6a00:9194:b0:717:8dd1:c309 with SMTP id d2e1a72fcca58-718d5e1d033mr982487b3a.9.1725582074494;
        Thu, 05 Sep 2024 17:21:14 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7d4fbd8da85sm3932700a12.37.2024.09.05.17.21.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Sep 2024 17:21:14 -0700 (PDT)
Message-ID: <dd107d79-35d6-490f-9c0c-d824f32dcdc1@linuxfoundation.org>
Date: Thu, 5 Sep 2024 18:21:12 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/132] 6.6.50-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/5/24 03:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.50 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 07 Sep 2024 09:36:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.50-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
