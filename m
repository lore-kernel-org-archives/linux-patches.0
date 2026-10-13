Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A9B54DAC6
	for <patches@lists.linux.dev>; Tue, 13 Oct 2026 22:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791930129; cv=none; b=BW85IcXoCsZ/iU4Q7I9g6ntNCRODUp62vdSJL5s4E5oDzKe4FIIzjhr18m8QczMvYjc36oWINzznuRhB6M4+WSyxA9G1rannAs5acfy6soZA5K4qJA8oidsYuSLs9s2MxrtKen6vsF/aqIaHnn7WD5HvSPq62VIO3PGOYdP/5ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791930129; c=relaxed/simple;
	bh=i/NPyVftPT0T12Rd9vFHPH/Apd81QBDPn2/gafvAB8w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sL7vtzgdzwyYALjdRjvucmPzNH+Ts4c3H+f8Tng3OcBo0kCu0u2TYJsBqjQ+AERGRH16x8vAX7U43i2HNM/UvrA5cAAIxTTS2ymZQ+vxg61WG8x0WLqTaWLlgu+hlfNaDyi7FfcnMgul9wfBmDUyIBhsleetxay004x4SE2SBXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kegd89AC; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kegd89AC"
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-8256106635eso1762195a34.0
        for <patches@lists.linux.dev>; Tue, 13 Oct 2026 15:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1791930126; x=1792534926; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KmKTSpwOIU42qw50Al/lTDECXTvDeMIBF7vVv/OZdxw=;
        b=Kegd89ACRlb8ls1ZYvgZkbDe/XYsziTBEzKNcSL5r81hdgCL/VKXU7LltOOb650Zau
         jlk7/hJrj/wAQLi2ecgnCLzNPq5GVubJ9Ko+azVqebpV9qrYpBHtVllaz+O8dIGJ+/54
         vViPl90gDGYLMPCJEjBH69xM4bRyHkNQmse+U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791930126; x=1792534926;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KmKTSpwOIU42qw50Al/lTDECXTvDeMIBF7vVv/OZdxw=;
        b=j+6wMXI8SUQvGlxZONqBAQRtoc4E+obpOrJYAkxM9tdJPbgR+f+xO35Nf97wlZhjPU
         trxW5Szmkqegkfo7PF2eHjOvOIvgqzPD4R5K42PgO7rvMCQIryS5Y/65G5uibKNFR8Yp
         aPUSeQ6ZtqZwT7iso7uPhzoz9xsAcz0R/KCGT5zH1CcS32BAv93t6mQBp0agIjva3Ywm
         TFlWRAUpkrfApu++qEQx24wHTs7cyiig1HqGdvlxM9NAbM4IjIo2AENpb8GdjqwAt2gl
         W+FgM/I2IDeRsoHKIKhbur5NgsZPXKO2tx5l8FczVg38pDB5DOR3iaAKrW0jDMDhGnNd
         s94Q==
X-Gm-Message-State: AFq9FYIsJ2Ffbsz/U6QIwkBbuwykYrirbRBGbUy9ufB5YkNPSaG6tLHC
	frt5+BM2UiSXM6C00q/5d+iGUwlx+byku+AFZ8p5sDfGB3lmCeN3W1KwCKYV1Q1IgFs=
X-Gm-Gg: AYBFou3woc3go498s5+Lw2H4RV8Xa/lo48VX55lWe9KqcovpxtkX/ACLaAO1GjrD9gP
	Rh5HrbTciNRWfF+5mGwwrsuLEOXNmqunR+YFGqTduGz/VF2MCG9OEmC+l0m7+kMv/ynn1XeVTNM
	U8yGds6Lu64FyDiQz1+jrNhxvfkdhjxCSblqoIGUGj6L0XOj3CONyl0qZ+U0RTX3K2vr/Yd34B6
	HPZoi+jyiLV+efyTW1IsWonGcz94MVT8ASVehwy2Hzbi8d56tmb9Qqr6Ukl+M+nD7Ixds/ab4P3
	j/0+RqLYnHqw69773sEHqE2MeHijBcHSK/KG8ECN25M3ofgxHkwQcFG6nperfr+RQechx9teyaM
	xnnGghGf4vgm8xVR5h6GkHiDLZZmZJm4HLr9HkERWFvAPjHUz2vkOsBD+sVpYuxMZjw89+0cpxa
	X0zYDlwYp81VBMK4kFVa9TVEvOM3oTPFfjdnqDSli+h8JdbuBwITth0un5loQ5dzxAQEtsr4WuN
	FQ/yPBjonaKp/bvwQ==
X-Received: by 2002:a05:6808:1241:b0:4f6:808e:3838 with SMTP id 5614622812f47-50c582328f9mr13009581b6e.52.1791930126129;
        Tue, 13 Oct 2026 15:22:06 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-50c0c5fe7d0sm15210133b6e.2.2026.10.13.15.22.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2026 15:22:05 -0700 (PDT)
Message-ID: <d204bc9c-531c-45c8-9959-9ffa1aa691f9@linuxfoundation.org>
Date: Tue, 13 Oct 2026 16:22:01 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 000/281] 7.2.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/13/26 05:35, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.11 release.
> There are 281 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 15 Oct 2026 11:28:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
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
