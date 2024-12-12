Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1DA822611
	for <patches@lists.linux.dev>; Thu, 12 Dec 2024 19:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734032066; cv=none; b=gDIOjlAQxvBJIIio30VXbXnkcq1a4j1E/83m9kpb5C6RF+LkQKUgEoNmuG2LDfCBSs8tKyuGekwksEkDdiEHxmWxvkqUPJBAs4Ae9SnVZHa2PaKxQzjtmZOG9rIzH9getznlAzLFvzu+PTwLarhmyeP0b3i86O2Nh/VqyArYOWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734032066; c=relaxed/simple;
	bh=XRQkEkF+swi0B2+vusGEbl3JYtBkHkVO+F1GD117yEg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=smIKus6A160YbSmUzSbIGOodqwnPuG6jEaWxWazt5g9nmSODC7Z7stGbb3gPYZ58+0ZDlm59ORGvIxrZxipJ4tytT/lTqOhLQ9NUycbw9231dUItCAmPAMl3IpF2Kr5fcj1ir5iUYAELF192mYd8QAabX14M1VqouAx52GhQUU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Rye4F4iQ; arc=none smtp.client-ip=209.85.221.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Rye4F4iQ"
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-5189a440a65so479631e0c.1
        for <patches@lists.linux.dev>; Thu, 12 Dec 2024 11:34:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1734032063; x=1734636863; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fTEkwDAcKDq4oSRBOG6s65o3vkDC0MpLM2cxo/UzhJo=;
        b=Rye4F4iQ2mDD4CxZHp3/1IviIhBPFMcAOfpeyYwTZjFDeiAG0GW0gyPC5MqAr9g7qs
         viBaUEFI+f4YXey0epeD8Wf1RWwBYo4pVn5HSQ9s4Q68eOEvOiqLDRg1qnoAjerqYZ3B
         CPCKmiao2tD7p6pT8eKw1wSyWWpxjUpdP7IOUP1FL2f21jhicuHKzePZ+PeBehdph3kj
         HVQAkQkByq9nyl3LhybPFLq8Pu4QunVu3HQJzNvUNfe0oUzlx12ak/M7tjL+X8Efxsx8
         WE+S9djwhdIkquYwplp1VZO/qWLUx5896GM0zuTL2rG1Ghc5+oJA/Oq9kFNnwc88Mqjl
         qJxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734032063; x=1734636863;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fTEkwDAcKDq4oSRBOG6s65o3vkDC0MpLM2cxo/UzhJo=;
        b=NcaMDWfJGdSivu5hDvPnJn6qqKhQBQ0E0KQi3eXCW1C4MHuZZMGiyV1dfRMwWOVKi8
         wgr/32uOIJM9PexOC0MnQ3xXWNwVrLvK+d19ijS8+nA8ZwBr0sHT/zwmlemH5ha0Pr2T
         hfb8yuIbe9R3e+rMNNHMg5XzmadZZOzRk0NnGfAd2jfusRzKTNF7uVQeB9lBGIcvp81/
         LBIUFlLrRBuHk/gpHTDRl6zu5rIXUdpPD4CFegvUR8/QL/MrRaRJPAHWShptpymowHfD
         Hm4YuRDPj1q0860MB0YdXf6W03uV56LYV2yKdSXYBZanIdYEMF7yZ3x29v+QED3DKRjh
         Bf3A==
X-Forwarded-Encrypted: i=1; AJvYcCVieLGx5gJKOCNdiiS8iHtrfN1OLbk4maB5/+8hKHn/XuJqaHUTfY/Imi+OF2BcViejERC4FFMO@lists.linux.dev
X-Gm-Message-State: AOJu0YyQ2qTgPUhpBatOM1cFt0OJVOlQzf0T0Xoc1b7Wwj3F57JDNqot
	woFtruUB5KD0EiHvljZh8+Bzew9vd//y0UcDuloGDC5U030p8n6gWouJ+PFJihgKg09VD+1nN6r
	g/ZvoW5GsJYwRiVWyUkoixJXQYbshCoVpTwpy1g==
X-Gm-Gg: ASbGncsoggpIynKqsywCJ8GFwSNNMp2pHpx1pc/CIRZCLYact1C+1AWchcUfBXe2LDd
	qxWn2KMnNV4hFtQYMJVPMkWkwZViD3tyCYG9q
X-Google-Smtp-Source: AGHT+IEwsqoADy9CLfQZU9fDxZL8sRYBnIJOakCrDckekfKDwX9cAfY7rdncozWG2knPUrR/hQUKmLlDFG4i+7pUkgw=
X-Received: by 2002:a05:6122:2004:b0:50a:d1e3:82f7 with SMTP id
 71dfb90a1353d-518ca4648bamr40974e0c.8.1734032062910; Thu, 12 Dec 2024
 11:34:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241212144306.641051666@linuxfoundation.org> <CA+G9fYuX2BsEOCZPC+2aJZ6mEh10kGY69pEQU3oo1rmK-8kTRg@mail.gmail.com>
In-Reply-To: <CA+G9fYuX2BsEOCZPC+2aJZ6mEh10kGY69pEQU3oo1rmK-8kTRg@mail.gmail.com>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 13 Dec 2024 01:04:09 +0530
Message-ID: <CA+G9fYu3SmdFKRkSDU0UV=bMs69UHx8UOeuniqTSD9haQ2yBvQ@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/466] 6.12.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, Thomas Gleixner <tglx@linutronix.de>, John Stultz <jstultz@google.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 12 Dec 2024 at 23:35, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> On Thu, 12 Dec 2024 at 20:30, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.12.5 release.
> > There are 466 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 14 Dec 2024 14:41:35 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.5-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
> The riscv builds failed on Linux stable-rc linux-6.12.y due to following build
> warnings / errors.
>
> riscv:
>   * build/gcc-13-defconfig
>   * build/clang-19-defconfig
>   * build/clang-nightly-defconfig
>   * build/gcc-8-defconfig
>
> First seen on Linux stable-rc linux-6.12.y v6.12.4-467-g3f47dc0fd5b1,
>   Good: v6.12.4
>   Bad:  6.12.5-rc1
>
>
> Build log:
> -----------
> kernel/time/timekeeping.c: In function 'timekeeping_debug_get_ns':
> kernel/time/timekeeping.c:263:17: error: too few arguments to function
> 'clocksource_delta'
>   263 |         delta = clocksource_delta(now, last, mask);
>       |                 ^~~~~~~~~~~~~~~~~
> In file included from kernel/time/timekeeping.c:30:
> kernel/time/timekeeping_internal.h:18:19: note: declared here
>    18 | static inline u64 clocksource_delta(u64 now, u64 last, u64
> mask, u64 max_delta)
>       |                   ^~~~~~~~~~~~~~~~~
> make[5]: *** [scripts/Makefile.build:229: kernel/time/timekeeping.o] Error 1

The bisect log pointing to first bad commit,

    clocksource: Make negative motion detection more robust
    commit 76031d9536a076bf023bedbdb1b4317fc801dd67 upstream.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

- Naresh
