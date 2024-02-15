Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7930F131731
	for <patches@lists.linux.dev>; Thu, 15 Feb 2024 16:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708015779; cv=none; b=q8ddi89czdwT/sakP+YCWpNzlV6GO7JcRh2mgUG+7ck0HJ5tVuYeq2zBIk6MpvBj3pIgB4h/ITRceqxDWsh/MQrsgWIJUB7BqbnTxkdx3SfjzOS3OhfEWu5x9ZFs7ENiKPWpHna5/lJIiwZwcrHvwXU2FboL8Mt7MUiLwF59pys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708015779; c=relaxed/simple;
	bh=nDBJprtupek6jtz+xxAg9qE3vBo3ZI3396Tj94+XKjg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NiPUUDqFL6jKdW+IpijYgpWs2c6fccgUX3L2mixJwlAnxFYyPOx6sa58wmn+xdGQ/TmwVC03gXKHZAdT1EMxnmf7epebfgKRxRZv0QP2hAH2dIwtsC4Kc2wRn1+M/q0F48hRHXKpS/jdh+t75rV0/NTLGd343jtBApSfbk4tUd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VAIIzEUj; arc=none smtp.client-ip=209.85.221.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VAIIzEUj"
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-4c0232861afso332014e0c.1
        for <patches@lists.linux.dev>; Thu, 15 Feb 2024 08:49:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708015777; x=1708620577; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/bbFkvOmHONTA1ff9N/8CU619rdiPvpvqzPbqsPJyy0=;
        b=VAIIzEUj2TKHNjGbF40uflxu71Qyw0jSo+aSnOL+QdGcrEQ4c+IsBIO/bCVUQaOwCH
         cJhG82Nmoo+UmusZ58RpJB+wgGqqFuc/EJZvuFg4YZ4YYsBmxiQOBNv6e4RkQjZNjkoA
         r/zmJS7jzH9OLJxAkkbqcF3E0mhD4CytyxQI5D6HWdtvv/+I3XiHTgBdK6VPL1cyraXb
         p7UhPu4ubXaPsWFYR6n2lsz/dUEbb/Q7k07V1hawrGjeBoV1iogdOttLBSdeTqG7qHyz
         Wn4JNtvdi8mKkE65kM9juc04Gvcd1E29chuC/Q6zP9nH5mjS5BUv3dUeR3CDcfOb5t5W
         NpnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708015777; x=1708620577;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/bbFkvOmHONTA1ff9N/8CU619rdiPvpvqzPbqsPJyy0=;
        b=DLeRpdYXtfQp6xyhvsc0hpFyibZFGEl9VI6Q9V2d4iDBbTdCK8oHhDoeVBmsLBc1B4
         uSS4w255Pdoc1Y0Q/8kUTxqmYYRdH+EiS3Q4Jb/K+RKhO01CbJgZFGtjgiLzu19Q4Yw9
         tnEvfM/4FBe7zn4cj9tYMCEn8JNrAnD2DBVlegKuve2X5zbeA3oIc2AmwftN7ttwydv0
         Aami9ayYK8tgfCBBgFDtoe/XYuQkqTX38/EoTgJK8xmi0m13mSR+apqUc6dugHKSbZbU
         Y435wI8DhrBBJ78Y1CHEcRGxgb/32vpbE0kpJkUhpuARQT+nROz0KrgEMTe7xFlpfhDV
         gzBA==
X-Forwarded-Encrypted: i=1; AJvYcCVLMCi51bIz9KaVQJhM4Op5AasH7G6CaUkDqdLPWqveoLiw49/HeMYPAtQRAVZs1GG4/Tj6UP/FDe/nyarLZ3pyJxxdh4DJ9w==
X-Gm-Message-State: AOJu0YxxZ2CZqquxXK3DdsWthXMBdNcJtvDT0VFOQg7q4PKsXO2NDWkc
	+emk3pTw+hR03ikuE3LUxvEeK3Gg/eZvnYeCl1tnOlrPJrs8tZ8SzhmuEn1ksQ3qjW77jT3nQCD
	PFCFCleyepsoG0gnIWuBp1t9aaRI=
X-Google-Smtp-Source: AGHT+IFVL8vctjaTh51mhc7/RxZwMTHNMS1gtWZUf4uRKGMewRW1zbnifsv/ppry04OIayZYguikNJJRVZIWLqu6Y14=
X-Received: by 2002:a1f:4b87:0:b0:4c0:29e5:d31f with SMTP id
 y129-20020a1f4b87000000b004c029e5d31fmr2180656vka.2.1708015777272; Thu, 15
 Feb 2024 08:49:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240214142941.551330912@linuxfoundation.org>
In-Reply-To: <20240214142941.551330912@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Thu, 15 Feb 2024 08:49:25 -0800
Message-ID: <CAOMdWSKJZFYaD3TT9fk8Cj3GSpK_pyEVrgHaXTik3n8VR7UxzA@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/65] 6.1.78-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.1.78 release.
> There are 65 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 16 Feb 2024 14:28:54 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.78-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
