Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA2F14AD0A
	for <patches@lists.linux.dev>; Tue, 27 Feb 2024 19:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709060511; cv=none; b=MS3Q97PLYCjndt8ax5b+313gm7AMNPIVdJaHLd1qOaGdfpVT6F69uLGlOWvvB/zLfKuGFCBpdvqcuJ9+YKvg/x+bAvY98xGoJrzQcTjt6sNODIzBdSX6nq2fydmoOdQF76e1Cywv+1mG91lomJ3n+bVPjlYgu3YIeV1n1sqlipg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709060511; c=relaxed/simple;
	bh=51jtFFY8/geln0haK5sNAZr/aqnSILVfKwu6u7XLrMA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LP/a62P0lZnWBRs6z8v9rKt9FRxwHZ1G5mAQDNz2LCkbMsfrxo7AaxFCOw3IGCLIef9IsnHLvqeIBEeLln44kMMh/taeu3PcoV8J3J7SLcGJNGS525QiuctDqn9Ak/laamlfD3smDzAuwKOmfuiIXOxHfujmFvuaa6jcs5qfl6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mBxZtd3p; arc=none smtp.client-ip=209.85.221.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mBxZtd3p"
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-4cca43a118bso711833e0c.3
        for <patches@lists.linux.dev>; Tue, 27 Feb 2024 11:01:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709060507; x=1709665307; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GXY/6TLcSg2JBPkZ750KSp3lrbwIelE9us8AkMM6UHk=;
        b=mBxZtd3pAEZd9IYC5fw02IAXX3QvnDU+7gCGp6a3DGoVtLpS6iAj5kKh9gGqPtisJM
         neE4/ad+rCXOluGn9SebVSISO3C59fd+tuP9rnSwY/ztOLQSQyE/5atE9T+e/p8i+xUf
         1WPO68M1+V2/JUv6d9uIvnst556SZ7XtzE2TCkLLYFCLwY45bYYiRCMViY58zUxYNe+c
         /XNBJlFHkGP3gvd9n/AlGQPQnrdVNP8aOMFucnKGfuMF51JjpFwcoGuIDZ5rS6MiFK0i
         yzBFuQbDzBzwpgeJKtewdphOPgF1Vj2aff5oxYR5hmjYvdsCY7j1AyuMAa+z5jKuiIhe
         /NWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709060507; x=1709665307;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GXY/6TLcSg2JBPkZ750KSp3lrbwIelE9us8AkMM6UHk=;
        b=nMl41FP/KJ9uRdD+RgEOwqxfZIO6oIcX0cMftIT7B23BDIX1BwG8nKTdrZ1RBiOQnG
         DKf/jrK6D4EQ24yI0mxC3bfZJVFoScQrviWGIh+P4nz9Ver7vT7gB7+np7lrKKW1w3oJ
         AWwaPseRliAlEe2uBleqqNG9bWdVRuUJCPvACjtIli9yaqHmX7zBIPn0VhezbZlgtsWo
         Jx+Ag/ebNoQ3gjMoLif68D/cpU/oEAA8c+tJ/ShyPiBQmuSBMfYFoWq5r1CQyROB/ffM
         G0HSLAWmr3izh5PLq1yFnD+XOaAyddpV7tckh7Zb9aCSEI3f0qhFCabxEWVDWKdPckui
         qMtA==
X-Forwarded-Encrypted: i=1; AJvYcCWNgeXjwYVojn8kH7vu0EpYb2FUMCgnwXW6wSKaqTh+oUIiow6jtDOuIkhepFudrjyoeTBMAjV90kKCxZ45HL/7UQnMiG8c8w==
X-Gm-Message-State: AOJu0YzWkLpsBhtGOx3caobtRo3mBZt4uPv+xt+Y5iEVPmXpelf9QvOW
	TewWYxDq0O6syRT1cmUlKlb20HySGGmMQcwMy7agAbj2LBHwZPdzP8pKwaZp4xx2NSUsFvBGWnE
	ph2SNjf/PT6uPmfk+YCOPGBdjDIQ=
X-Google-Smtp-Source: AGHT+IFV6iRsZ58o/juvLumMNk6BhV1RC5rufpp/W8VxtAPU8kXRzSrpeZUNR9qwG0WgCSCniOJ+FoNzA/ZI0rxHhMQ=
X-Received: by 2002:a1f:d704:0:b0:4d1:34a1:c896 with SMTP id
 o4-20020a1fd704000000b004d134a1c896mr7413620vkg.8.1709060507358; Tue, 27 Feb
 2024 11:01:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240227131630.636392135@linuxfoundation.org>
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Tue, 27 Feb 2024 11:01:33 -0800
Message-ID: <CAOMdWSJyXm3+3nunLTNdAhoQX2qqj3Ftszi6LpN-Uj_yyK8G9g@mail.gmail.com>
Subject: Re: [PATCH 6.7 000/334] 6.7.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.7.7 release.
> There are 334 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 29 Feb 2024 13:15:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.7.7-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.7.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
