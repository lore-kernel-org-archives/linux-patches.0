Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com [209.85.222.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F911AAE34
	for <patches@lists.linux.dev>; Thu,  3 Oct 2024 21:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727989224; cv=none; b=Fyiwp8G6wvmrfuJqx3UBbdOhdEwq0bFFtMu3hO/W98U+Ts5WwQmP4IdvvWZF/xpLlJ4R764uLDNwjm8dEWkdyEqgxQWBVMD8O/EF5M+r5QZ+HKqnT5hCo1w2GH6XjHnl4YY++woo4jFDwT5mipXziuIK4SlLTiGkD0E+AERLtIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727989224; c=relaxed/simple;
	bh=B/mEJFQjIVDAe69T1T2az2vyC674nGoigk3NKTfT6y8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mpwEs5BBoBR0RjwG7+49foVVRvaH+qaa2qxJc+TrQYZ9wBv6cmOkrk/hEU7FCzs2CodIMRtQcfIOPAWsIlwEpb0+jQ/0xtRjus2PemUQwSkoNngSbDgSeI2Apa592jkVg5FcWHScG6tpY+gzvP/Ki++jBddic/DKF1VNzus1W8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MmIdjtzO; arc=none smtp.client-ip=209.85.222.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MmIdjtzO"
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-84eaa16442aso443923241.2
        for <patches@lists.linux.dev>; Thu, 03 Oct 2024 14:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727989221; x=1728594021; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Q2RtfrwlKWWoE8117z4p0dEnqNdI0EcSIuAVNsBuCR8=;
        b=MmIdjtzOsYlwk/HDqoR9qEE0X3tj+kYKVD8Rx4mMtKsAnJlq4kPiJXw/hjMjvamY/J
         aJwiRq7ss3JWub7asQSkR6f1PH+h6qAXyGVTma8Za3VKF9wsLEgoqgnjK+Tsxd5jPfYP
         gTAojBVi78R5rzmmrJDFHgKB+2OsKe2Mjtmw4Jemmw2xl2zaJlExCIqNFZcgeCIvkIni
         oL2CwjJ/73djHKYkwUWDgXtcx7eRZhS9+x3wRjGey7qvKi0yoZeoyF7pV/qFZ/Yrsf7X
         HOvfjz5vw5hlvkz4VQPPRV7Uax/uY9fkU3qxC5TOrqAKi7EYPWbhQxvxtT1QqRyzfdLM
         15zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727989221; x=1728594021;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q2RtfrwlKWWoE8117z4p0dEnqNdI0EcSIuAVNsBuCR8=;
        b=SZMJO2TTsPKeVgDhuHtISUv0ZvvjPpelzPUoVm071bGDpp2wGPezGpG6Vn7STooDmD
         pJ2p3KrQ6kzz873kSL6dNgXZHkefgacpoTb7U2Y8TFEcQGUEEjaFQ/nERe1Nu/aQse38
         HWoAdT2B1gyLUMhCZAL+ZCkeIzKDWflIcxz8V8e6UjyzY7sKPyKWQ/1L93GE7X/QBosk
         Y4SFOB4x5agaDw++hGmmzpJB2G4Vdr5nnA+98Mjb7jASguAztCJ2q3mOpZ7uFdPOGqku
         oX9hhQLIVvSIR8Ee4+x4RsKR1e8yS0tVbqd1jjxksjYIOuzBvEaQlZi+a++wdTy4PlXF
         dTSg==
X-Forwarded-Encrypted: i=1; AJvYcCWMmr+4rP6KT7Lm5n0+A3NrvrEszEcUztYEaTF0+iByqNlwFaTu1Zgiw2H2ZLZ2le6mUv/RIEoW@lists.linux.dev
X-Gm-Message-State: AOJu0YyUngtAA+03LLU6oeWfuksgVZGv5Z9QEZrMbSW4dOjWfnCZ8RvY
	VofMGwKUfh6nHBpmMWhffZj4UBFLX6BeIfQd9RfObYkjMn1qdzkRw0IFagcEB03Z4NFg0DL4Y9c
	7QfcS81BmmvD2+ntcn5amC25HPdY=
X-Google-Smtp-Source: AGHT+IFQt+0ncED03UA9OizCJy7paZoIVwdW5TU+6QFXLaL+7JpxsfhE2+mV6YUajDSZ36Da6FoUl9iulnMjwL7yezw=
X-Received: by 2002:a05:6102:3f44:b0:4a3:e55d:eff5 with SMTP id
 ada2fe7eead31-4a405768721mr930660137.9.1727989220991; Thu, 03 Oct 2024
 14:00:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241002125811.070689334@linuxfoundation.org>
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Thu, 3 Oct 2024 14:00:09 -0700
Message-ID: <CAOMdWSLcpMRDzmJ8qBwnz=vo2sxH8hW=sPpCTwiBbP0MZbyftA@mail.gmail.com>
Subject: Re: [PATCH 6.10 000/634] 6.10.13-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.10.13 release.
> There are 634 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 04 Oct 2024 12:56:13 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.13-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems.
No errors or regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
