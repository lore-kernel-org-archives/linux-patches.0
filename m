Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2A9223339
	for <patches@lists.linux.dev>; Tue, 22 Jul 2025 21:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753219176; cv=none; b=DMG/kFFigcA+1TWLtzxeJsZ5nQ8B1HYfuIAeYPHYq1NLTw/RkGjznV/lvfD26Z82uc7P62FMtKt9tJGMaR132bImrb4cVle5mGHye4XmAndJ5sPNxGKcTOOArAkd/Xf0qUsfeEHaH4iaLFCAw+/o6a63IfoFF+WIuAquFxjEAg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753219176; c=relaxed/simple;
	bh=U5/9PrXzn3TSV36bHyqWBQ2lvhT22VgIYiPjEDLqPoQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=inLd9ftbQD5SVmBHqPI8cSrYw3EdrL7z6NOhvXSfVAH0pHXeLNEccanphw+x+xXmwII+GoXXKyVJBsvF31VvaBCeGGBQ+pNqGYt91PUYIr9HZbxtm1UwWcK4PL4YnV1KxLclN3PNnTOM0H83Xww2ce2Ck9EI1UHy2x5tT1HJzLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cVKE3NA3; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cVKE3NA3"
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3e28bf4a350so31343865ab.1
        for <patches@lists.linux.dev>; Tue, 22 Jul 2025 14:19:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1753219173; x=1753823973; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vopwzi+8eYb89OM5G9WI2DnldDqvb+R9BJJKxBuhxuo=;
        b=cVKE3NA3FmWta+ZcAJtg7YPfaYMdoqVApFO3P9HmSc1hys1gS2LNn/74t/YYuy7+Qh
         QzVrsiqF+CG+S2a9V/Tm5XWBx76L1dmTr1ooL7HWPsqN2fTsSvb0kRrv4yrpHlRXAbx8
         l1SC13DuBgFVBFc8CCVIJfEH2u947IIMZ/Mlg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753219173; x=1753823973;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vopwzi+8eYb89OM5G9WI2DnldDqvb+R9BJJKxBuhxuo=;
        b=OMhZthl5p2kypebJJ5ZLP7vl1f1fgzlzGnPIk8dzSa4DSV2L1rAeWP1eIB+AcCMceE
         +m+sYB4qmEbdHK8M1Otbes1mEQGye/qECBUmAymxzGM+YSPmR4K/eHbWBMeqlrx/MGMh
         cTbsbiUcUCVcyb5DmqIoKs+qzFjSaj9GM6thwYpOPYoH1YYuRBxcvhL4lQ3gHB3wt3Pt
         yUU0YQ6igMBZz2f/nvWXDKX4ORerxp34EtxiwK0sXJffa/9ZNracGw7BXU7EtIpRZjMo
         Bn84sLstnAyhesbtOEQFh7h5es58smZ0ckxeFXG0SMVjkqjSWeuBIm7x7q4LKZ1XizZb
         31kw==
X-Gm-Message-State: AOJu0YzW3iH+boEDFY6VoRGuZYYBUdVZGhall/267vkWjYoYghJzcBSd
	dD5xbA/1dLz9RL93OtSOOrmayqGHyHLwzf5wDwz5WFisJFAPR7HlCM1dzE2ddRfKAyQ=
X-Gm-Gg: ASbGnctG5UiDg+wSwYTj/XEB477aWaqdKC6wZtBZxRP7P8cWSVSf8nz46llihqMLYv9
	8Q68SR/I2tVpxk60b4s/y8nKWFSthiJqagvDMakKkz7idXic1KrgONtBP6oJJzmbcJ0gJLDw7sM
	sp/9l9x8Gburw0cEdnOtYeS/G9iPblQ4vKIJ9QVL2MJLXXi1EddeAEosJz4poK5rDo7mM76ZB8Q
	AjM5HWlssHnUqhsN+Ib9h9fcgEaGtHf/1Byiv3UShUzCdC0BPEF6JDrVTp21y5hMPgooaIExcau
	8iYDjWBsrHQZhV/e2gwNsQU8Sb/yk9o85FQ4ROsk0fR4zbrdnojflpUOvQ5B9N/1zrTRq996eay
	0RzjHhsdvDhFup0nm8BZAk1Mi39tQ6K9NcA==
X-Google-Smtp-Source: AGHT+IHB2kj7wAlirQpyMhdwef+1nzMVJzg7XJvQ92glYHifVsRf8s//4dpWUNN9PM2HfQM5LeL2FQ==
X-Received: by 2002:a05:6e02:4701:b0:3e2:9eac:dc01 with SMTP id e9e14a558f8ab-3e3354a23edmr11949525ab.18.1753219173467;
        Tue, 22 Jul 2025 14:19:33 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5084c804addsm2750342173.58.2025.07.22.14.19.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jul 2025 14:19:33 -0700 (PDT)
Message-ID: <b0d63011-fa27-4c21-a5a8-a2725ae935aa@linuxfoundation.org>
Date: Tue, 22 Jul 2025 15:19:31 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.15 000/187] 6.15.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/22/25 07:42, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.8 release.
> There are 187 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 24 Jul 2025 13:43:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
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
