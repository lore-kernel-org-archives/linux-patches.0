Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355612253A7
	for <patches@lists.linux.dev>; Wed, 23 Jul 2025 03:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753240696; cv=none; b=JVrrKjofBTlfj4Ao9IDTuOBjMPa6CzQSlbcnLS4nnH/btKzU2h+sr/cETC40F8ksH6t6GBYHLYtPT1uSqbbKchhmjDvoTN7PY1W/xFW0OgB/5VNexOM7tRSDWQPK0MEfr7/VD1E109nvZ/pUlVQC+tweCOFFb2Ti5UBfFW8G5VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753240696; c=relaxed/simple;
	bh=Jj1nHlTCLCXZrelEKaT80nPdzgo7kuaJ+T2W2YJp/Z4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S0zIlBNkj3JP6Uk8w/VoiTFNG9GfqcOgYVLbRfJv2U0w2P4tE05ewR+ySUmjxsfHPEChXkRpcXmbQzl5bxYL+ig2UOBIUj0wRccDjtXHmuR+g2wAtq56WRy27zGivRp0f5EXP1BN7PrYsRTFVU+wVe7btWJ4cJpsPzc3+d4lRSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=sHRYS4OM; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="sHRYS4OM"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b34a8f69862so4825184a12.2
        for <patches@lists.linux.dev>; Tue, 22 Jul 2025 20:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1753240694; x=1753845494; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eAXZxXro2VcJVTfJJWOX/tT5LapatOe/C5I7V0PTlzg=;
        b=sHRYS4OM70SbgKlbmV/7ZRr3t9jxSNht5H/dJYeE+7VgzET2jsMq8nnDpvFNXubei4
         WDXtHEiXjJ11wURmHCp85QIpHLovxXulpDYTb169bkuOgrwgxKGpwRo9DonU3NHORXwL
         5N//NekbVFY9k8/2pUTQMInFDBRDe00S1drqn50IErXoBfBsUlJAbwPpTMV3w7Q3ZUAT
         REtUatkvvxmr1fZyuy2JiZj7kcasE+pOSiNKcwhEbKpQe8addrMaVUk2+T3yxN1bl3jz
         neCcvroUhFxcC/OvY80l8CBKvyCwTSxgF5l15Cf4+TVM8Kx5PgHUTjaywSF3RiOrxWum
         /3UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753240694; x=1753845494;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eAXZxXro2VcJVTfJJWOX/tT5LapatOe/C5I7V0PTlzg=;
        b=OoJFnYe7cqGicN/0uori6IgZOzPDye2TfLSZqzIifnx4wJwMTxwxslKPlyyLHVBxPX
         Zv/6HTw/TC5CveZrNKwvcKNoFr3X9K7EvBDhp1T9oX4LFCKin6zMLEzNmHqGHDmDjlhT
         C2ndSz/E5ib7K4pW4ayo+OiZKMznD9Xy8gFAXXra1nT6YI4YxZGePfDsn4nlxQRnLh8f
         yhBKciez1tg4dCnjtaxegen7npQf9+qRTDTw5tsXHoKbALduxdWXWRcefNfJHVinlOVL
         iXojhaq8fn6rMdH1ThTjmvQY/iwDR6ZeKpyJA5mHqMB6I49ZtHvZFiUlbYVki+fwjxU8
         VkRg==
X-Forwarded-Encrypted: i=1; AJvYcCUaYo7ikDV9TERZFuTNqL/cDi1aunMBN3Ok83VZXiX35u2qbHIT2JETWeHYxlVD84tm2lmLIRSJ@lists.linux.dev
X-Gm-Message-State: AOJu0YwmA0qxaRtakP1QI/i2AwnV1tAYDW3YcF6AGCOI8TxYLd1z2yNR
	t48TcqKd5AG1lqFgpusmpU6Ex165d6trFR/0O0TzzBTE+/UWyG2vcxX4ksiQR8+53YQX5G5hnw/
	P9NB6yAW6FCjXGUdM055T/KPwg9sGdj1CRtpwh8VPiQ==
X-Gm-Gg: ASbGnctjXOuSBK+09aH8Z91Hbvot9+tYBcULSwtXbCKmRAzoeZ5FXHy8ReNF+NGz1uz
	Oi7Ko/tp0yM7q0eufdADs8PXF/HERfE2HyMWj/dmEfBmGv7bbuOdya22U0j2tbrNEw1ZSmym3EB
	RBvE02pKrUhNCVyCZBzhRoNxIm8taCLfV6EByU/My3bnVxLX2ka43EIInc8mGyMnV9Dm6HXX4DI
	qZDqJw=
X-Google-Smtp-Source: AGHT+IHJ9ArR+zlC/SPVpA9/p1l6jmOzapJgENHOUMr26UwB+T1uLDYtBqKQ1u4M/Erz0yDMixnnER7Oae495KILO/U=
X-Received: by 2002:a17:90b:3f8f:b0:312:639:a058 with SMTP id
 98e67ed59e1d1-31e5082e792mr2407391a91.27.1753240694279; Tue, 22 Jul 2025
 20:18:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250722134345.761035548@linuxfoundation.org>
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 23 Jul 2025 12:17:58 +0900
X-Gm-Features: Ac12FXyoO9CqAAyXnvlMvvvGkmvaI8NzV2KaJHA-FgOauwXAyn_6Ibd0WmE6lJE
Message-ID: <CAKL4bV4khO3rU87Zx2khs2b_v5BatHeO09HqP2yYFeS8eKyoMA@mail.gmail.com>
Subject: Re: [PATCH 6.15 000/187] 6.15.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Tue, Jul 22, 2025 at 11:19=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.15.8 release.
> There are 187 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 24 Jul 2025 13:43:10 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.15.8-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.15.8-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.15.8-rc1rv-g81bcc8b99854
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.1.1 20250425, GNU ld (GNU
Binutils) 2.44.0) #1 SMP PREEMPT_DYNAMIC Wed Jul 23 11:14:10 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
