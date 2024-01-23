Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA7B7FBA8
	for <patches@lists.linux.dev>; Tue, 23 Jan 2024 17:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706030641; cv=none; b=lQZZeuCzeYo8+R627tUOcHEsUohcbLBF79vJDZLkyRRNgpkATHGtDDrHpBPPA4UNjEB2of37uqM5366ELeYVelMhzXiXm/7V3875B9H8MJbqsvnlrvx+nfRM0amCYQmWS/jmNX1zCx/3AA0MHdEDKK1PEfGKNNlYWmHDpFqOnYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706030641; c=relaxed/simple;
	bh=fHqmME8pyoHz1Xun5FH0Vw9OMWeDmrLlhjA4Z0zDZg8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qq/sMQbVI/gQO/hUVGRKUWsSBHw+XyS+bL5guHVEb29f31xrKM1PlOPjCQGVdsoMgw9Dm81R+jDXxUBwpzzK6V4Q21a9wlxYEFNkeihtBm9wLROZv72vbWomuBvDf//dNPkZvaDxa7oHTJWUya0vTvkV/KZmWRCojhA70EXQ95c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lInano3x; arc=none smtp.client-ip=209.85.217.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lInano3x"
Received: by mail-vs1-f53.google.com with SMTP id ada2fe7eead31-4681f304691so1120171137.2
        for <patches@lists.linux.dev>; Tue, 23 Jan 2024 09:24:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706030639; x=1706635439; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZbIPnP/gS4sttW/JGLj9iVmCxJVrwt8tNGlCVJAIhT0=;
        b=lInano3xph2R4ESqKCAxqYQ1oKcWU3APrLssucRdpDkzjU+FgrCsQWuNfris/5fmVx
         xezrsuaX1C7/IMBFE/iaVDhYfnGW15Nfi4MhvQ69Dt6iSTcLXD8TfCNxWWdGEEvue/Iz
         2PDBfiCpGZnEBzlqxAzk98PAHfQwukgjc0POfskJAm9BH6OHBLsLjX9WF8fXdZSzoOoH
         uBjHs2qw3kKazTaEprVvdNgR3AlBJ2F1G+POpU2k1c1pozII1ErcBOXOxOKaQEhQFjJF
         6FB3RDVfwQdsmLXUtGSE26DfHsNOU+mZ7Fmac7UB58xSde+jIHYxt6UXH/eBdbep6cVZ
         S6bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706030639; x=1706635439;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZbIPnP/gS4sttW/JGLj9iVmCxJVrwt8tNGlCVJAIhT0=;
        b=hQhDQQBqnhNmTa5dXQNVdIGG2nEojGGs1VFC3vL0CLvosdFlZBAooW1jrLhoCiuNVa
         kM0xTg/FyipEudeRHGHPQppCX5pr2OibRxI2Cf7YkNauaH/ph3aTcPQ7Z7uyUenQF7Lp
         FpOeVCM0uQVf8iXUcT/coe/7H459NXKumrAqT56xXZQEHztnaK5GCotOjiLq+M6HL6vu
         7yzHt2dJ+1hEIlgCFEREcbWjXXOOgtL6slUiE56CelSUj4PBsxm6w7V6QL88Nn2kgKSK
         GOTKbdYCvcjvA7sxt03tgrF4kLxYRTEuDjkiEpqDNwjh8vGEJ+F9wADts7nj8MchJG8T
         YakA==
X-Gm-Message-State: AOJu0Yx5pMDZuG5cA6J+b3xahbSVBSLzhVHFOkbE2tmtRs7rT0CdfIOG
	zuoofNNzLodLjvigTL25yHNubEUzaqc8FxEN8gwEOS7w0ZnkJGSrSBwplGj6aywH4zA86tKraWd
	n3FhqLphWZs9WdX54M2wXi8vcE8Q=
X-Google-Smtp-Source: AGHT+IEeLz+BW2MuCuMlIoPqQjchFblBCvq7lVB8bmVYcM5i1YKpyzaYdOZ1MMTmmm/aejM9ABdiQUN/z250uDRChao=
X-Received: by 2002:a05:6102:3753:b0:469:bcbe:b10b with SMTP id
 u19-20020a056102375300b00469bcbeb10bmr2305735vst.6.1706030637819; Tue, 23 Jan
 2024 09:23:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240122235751.480367507@linuxfoundation.org>
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Tue, 23 Jan 2024 09:23:46 -0800
Message-ID: <CAOMdWSJZ+2jONW3pBdwVbC4QTDPEtX9Ce7A-_FCzr2zXj70Nag@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/417] 6.1.75-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.1.75 release.
> There are 417 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 24 Jan 2024 23:56:49 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.75-rc1.gz
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
