Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D9920322
	for <patches@lists.linux.dev>; Fri, 28 Nov 2025 08:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764318513; cv=none; b=Xmf/1ufwM2KwO3UNxiefMXf+YNjF2TGzvpuz1YA6fCFZKmkdM/t2T9GWA0RVo8RVTIUz+KiBqXS3jvWWuTdP75DrqZViIMwlFjb5pRzF1koUBxu67rhums+WbbP7ecs/sAW4OxLKoj9u4skMk7cjHT1D6uV9NaOZv2y6+CP07SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764318513; c=relaxed/simple;
	bh=/8MpVidaF0C2tottb6A7dUZ5ejYnmonLxpLNyjy3b9Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GjcxVZdoWNOQjIHXslnPeDGVOXRzefEgZHwyySJTD4npVw34/mG0sm6Ddn5K9NqtphG2MM2rxWh5CHfBlVdoLyWMlAzA6yjbjlwOfyAkENV1fM9IEoPz7OFgm2QNMI2otjRyY17oNHm67JOd41nDutZiOJ4Qip0uo/cluGUzkc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z3GNPB8I; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z3GNPB8I"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-59583505988so2006188e87.1
        for <patches@lists.linux.dev>; Fri, 28 Nov 2025 00:28:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764318510; x=1764923310; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JpQOTOoOF9sFuSAn+dzFUWimFlC8PZeQxb8bTh5aMpc=;
        b=Z3GNPB8I3RvRhD/wOZ98ev+UCLf72srvAB3RpoWj545XL41UAyOO68YNQKfT5/k219
         QQnHYyOQfdJI2Hq8/PfacW8JHnRMq6OKWkypB/BlDzEHxzD/ZseT+TiCxcg/aNEIJXLL
         LsBvg59J2zDVDku/GMPVdcdyRwz0i1PgRK8gwYoAVIqo6YPkOKKwkOC8/E0WDZ+Q4i8C
         AUM6bvdinxMN8jwUjrJzFVidmHm3VmJ2YMcf9jKcLWeD6EQBry+NbHyikr9NZswRbPLC
         n7qKqiOXINy6lvtDm+56TIIx8IDppYd6bnyYQXqQcdwGMEXiDwyW4bBvoFfGuleOil2H
         gWyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764318510; x=1764923310;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JpQOTOoOF9sFuSAn+dzFUWimFlC8PZeQxb8bTh5aMpc=;
        b=KLfi6kY5HugUhf2tjl/tg8WLvfBKldSGn8LnIbVky2Uv2okNxEzn3DK91KjN0jQF+X
         0V7nmgguNFQ171b6EA2Lli1EW7ReIybA0MhFivOQ+9rdJOBa+cuWoLEgQ96gTNEAUYNk
         cX0K9lFbIavkt6vgRezYsb9jYIOstkWdT/rsOO0QXwvvItdmaoPUNrE0xd8bFb3paA1e
         MBDSM0cPJNR9i+gurcTVtiu3MuSRn/ahY7OWVwVIdLj7VqEw9OSV5NjEhDo6Gwe3ygnB
         7hBpNwx7MwT8EOpWsS33n+tFowa0lq9h6PpDMjEwhsyG3VUuvexfYoeC8cPUw+R3pcyU
         T/Cg==
X-Forwarded-Encrypted: i=1; AJvYcCWXrsBaClkjqfUayXVn0yS55VVrKywaLhRPh2Q3FuQ3lEgKmCpGY9SDL0Rnd5s0AKqfBNUJeSVS@lists.linux.dev
X-Gm-Message-State: AOJu0YyZCU7SDIC6jU0/5mLp0ljKoWwPvn56oSrAFAv+MnH6ksDi3cPC
	2wgbd9xpUIsK8dnCadRm0N4/nb1X/EbBk0cmLYNHhp+zQCAqASmP9hq2Q92IuuXB0PkYW+VvZLJ
	pIXx/a+tR84dRIPGeYYziIksWm6FQnW4=
X-Gm-Gg: ASbGncufsDBLbHZEJe6d+uUa/BT2DBpZTTUn2gF+XJ1lCHvkncsHMJvF2rfVBYnKfmM
	LCUEBBU5zNtVy/PZo/fT+IIgt+4RhY+SbYGnQFiT39t5pFqZL+P860HXMNotIqAEXYQhAuvHzdu
	bBOWB0gmiDa8NfHtNpBztN17B+uMS9DC87ulYJIXKFo543XBrxgV6dkEuyIVtGK/UIFpbNhJIq8
	DexKOWR3335CqXqdskF5ABIUsuf6hbBIcVmOAm99wH+cluEaCbhNAdh8DvuENf5BR1gkUvmeHmN
	fTiLbFWDolAp95qjNnBEcq6cwit8wS3QKsINiw==
X-Google-Smtp-Source: AGHT+IHfAwSo0cIUFrGGbj2fEYULevXZsHUaUQQqiCzQnU/McOErCMAsLIvu4tf93pcqGd5RJfQKdTQbEbhuG6nMEaM=
X-Received: by 2002:ac2:4e04:0:b0:595:90ce:df8e with SMTP id
 2adb3069b0e04-596a3740821mr10010768e87.5.1764318509959; Fri, 28 Nov 2025
 00:28:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251127150346.125775439@linuxfoundation.org>
In-Reply-To: <20251127150346.125775439@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Fri, 28 Nov 2025 13:58:17 +0530
X-Gm-Features: AWmQ_bmc_K7aCanFLO7qdo2fGHzO0zxm9yMvnui6MUBzFQXyf4lOh4FX9NEdnTc
Message-ID: <CAC-m1rqSYR5ytkSvFXkbG+rdeRezjYAiVmVWMYL1F2ndkVvKyg@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/113] 6.12.60-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com, 
	Sebastian Ene <sebastianene@google.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 27, 2025 at 8:40=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.60 release.
> There are 113 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 29 Nov 2025 15:03:21 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.60-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

[ Please ignore my previous email it was in wrong format ]

Build and Boot Report for 6.12.60-rc-2

The kernel version 6.12.60 was built and boot-tested using qemu-x86_64
and qemu-arm64 with the default configuration (defconfig). The build and bo=
ot
processes completed successfully, and the kernel operated as expected
in the virtualized environments without any issues.
No dmesg regressions found.

Build Details :
Builds : arm64, x86_64
Kernel Version: 6.12.60
Configuration : defconfig
Source: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git
Commit : 375669e5645f465d87d534f0be2eef993e3c7bab

Tested-by: Dileep Malepu <dileep.debian@gmail.com>

Best regards,
Dileep Malepu
