Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51D13909B3
	for <patches@lists.linux.dev>; Sun,  2 Aug 2026 08:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785660194; cv=pass; b=DCr/+dMGnxCLqSJ1Kiud0bETX+Tm4s7aL2uI4nfgyevTWmyjrxHGQtjM0/IKaYKXDmVgFAz40gNstfrey7NxAXNMhBwk3+HXY9+S/X3SLR3zHtx46zJklyEPd4DglKXkFUY+PZ9uhxFrJcSe+UjJW4zEdtus4aa8m8lh1vU4lBY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785660194; c=relaxed/simple;
	bh=Tm0k65FNbDrdx1vgSHrRVtMQQzAt2fySrdQkOW+gZyU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MkZp87JYB60qBrckOtepVLzjDAtaeZcskAarXrh6sCWZ43cK7iwHLXXXsq8XLjhmEWU60oJhZ5thncL/nHmO0QixHXQdPKxdKkAkS6dmsHbKRnLi4HKFNgAtHusJXl+E/A9nlCkmZ+O01UT8uW46tMnq5H1SiynBkOkplHxAKoc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nS1ohP0M; arc=pass smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nS1ohP0M"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c96d7933910so264838a12.0
        for <patches@lists.linux.dev>; Sun, 02 Aug 2026 01:43:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785660193; cv=none;
        d=google.com; s=arc-20260327;
        b=ip1jc6le8jYsn5AgSLZC6R/T3+clQZtttOYtI5PK6HjWyYYEH+WZgP8iqAdGscsNSO
         svi/3VXQ7kZHNecteM/kYjyDqdb3zqBbzF9+PRL9KdDV/oPRvL+r3+jBdhtwQGPuEOdV
         1VnxkFLbPd2/Esgpo0CqAoN2xh27tZd3SXgY9VUnNKI7ziQw8mRIVJ7KjLCCr+vIjk0b
         P/KFYmnx0q5PGBq2Zbr5VniTbPbMFJkiAJNmC5h//BnNRJ0LqbrcEJEw9cAo8w9C5eqH
         lzJwwoQ2cZH9VpXs02Q1q0g8LWAoPVJSE71cdOScXJ9hbfjp9FL++OXEVzFJ9CZwQ2ip
         9kiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Tm0k65FNbDrdx1vgSHrRVtMQQzAt2fySrdQkOW+gZyU=;
        fh=k4y1iEmykq/GpuZifF78orE418Mk/0CJ1ywB6V3s4jM=;
        b=jixB5L0LLuyi+5E5QyXO+Qj9fFcnuQhjiJGKcYcpUGv/1S2KaTvY9ntQkD1SWUfkX4
         WGRt4Yvdyg76mfiaxOP5bYFl3jNvHv42eaXz+REgtD8Av84G4j0iykV9ghqZA9Ytyi4f
         heZktZ5Y9hkXgb2SJa+Bs2DgKUIa7+SpzYVDks+RB8K2QIs2NRfKAdVAQRdPHDmXPzKm
         CTi+LfpovYrHecO4VZYB10JaaX6HvJU7hSw2YL1GkStxTE6fzABFg+nFmSGFEc3u+GYE
         l27plBDTE0vQPFwv7qLgxz8wpWF4G26sl5wjXRcirxfdHxqvG65qWK1EjJW8cl3s+3Ey
         2k8w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785660193; x=1786264993; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Tm0k65FNbDrdx1vgSHrRVtMQQzAt2fySrdQkOW+gZyU=;
        b=nS1ohP0MfhI4SaxV9JNROCLLhpJTu3z+saYNOHzywG3T90TM2Dp6CWqZzLRjRG/zuf
         GeeoUaa7et6UBdnol044ud9iaJLsgSLmB1Uia9B8DgKkyvUNO5fo4tjfRh+OM9MJ0AWA
         1WZyDSc3rdfHaXZtATJ8iS3+aXJTcvVNiVzYhwv1SpatQmCkBQYZQZkDkHIw7W8Wj6DS
         of62QPJ2brqAN16vvmCV9LK7RiJwkr41X6zs7TfTDR1eV8wCtPdPq3NLYTCeVdpGFLvu
         rMjnpeIMwbNvfAnK4L2xCENsCM88UzKO+YCpZi1Bf9QoYsUB9SoB3zhHQx4asKqFTCpD
         DxPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785660193; x=1786264993;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Tm0k65FNbDrdx1vgSHrRVtMQQzAt2fySrdQkOW+gZyU=;
        b=GZm/TTJ8mmaI48/VpysDzyvzaO0uJiCud1QqbACR52aq653T3HO6/Ax1IGDjODS0pW
         JMRkGm7Y/542HeaFhwzXc49H/fPUW/7FLeD4OjGXhYyJbb72MgQQo0MXZiO6axHSUZFa
         KAZ+ks0igEsfQ42njzQA1fcrG8H7+GsF/w57CmdrVLdAc/4LYzVeWAuwe/ePGwIzMX58
         3il/a86GdiqJJLk8WYV+VTgmm4y6aKxl9Ha0VsojcSgQ97+H3tO7+hOahByL6MYxUSr/
         NDYGYHYZXoP9+T/wLcSKNwnIokhRTY66owXbE7X9YG3F5pqV4axJQPnKekr8wINt+iG9
         CO9w==
X-Forwarded-Encrypted: i=1; AHgh+RoiGmzeuL22EbYPapSzIVSOm/DRD+nggfKDJK5NZavEmUU5K/3fKRg6BTfM54dUOXnLwf6ExiGt@lists.linux.dev
X-Gm-Message-State: AOJu0YzmCr6CvBJdzJah64swqayFxqlnwD663u/gny79m2+QchUSFWlh
	y+TaUL5DX+Jso+1dBUbqqS7Ewh9JPLsDwRuqsoni+fKiZUc3UWF3tKDvsyRBL3pGkzCSG5/+lxQ
	zXiPzllDPh4pY/ZZy499RphdilIXnM70=
X-Gm-Gg: AR+sD10emh4EaMHL5ph1/i6+hsq4gkVI48HV1C7ADobwXH7ONyzddsautyLE/9l+NIh
	f3kgthWxWTbdH1ZsHqxOuscu1c92yJdbKa5/2TSOCwj9UwJATSY9R7gifFZpD7TUxSAmKpv0dyC
	J1YcTjASuLFrA1Nv1/Rax8NEAvl3DvRdh/hYkFRZu9dFk9z1dQ4Awq9S+Ye/yqaG9YYOJoHdZQd
	0yCQFwMCmkASjVPld4KCuFkbVyH+tT4QeGx7kK/1Y9h85l19D0Ewr2qI3f/KvqWOirUUSAqv+M3
	KvPXZbVH0HpDDSY4Qm0TVbmBdAG+Ku9+M65evUeq/cmmWyOd1blvroQ1Ikf7jwVPUWItF1nRwqv
	KB/xLoSANQQjYUCMrSw1/luVAkaWaFsdZcttbmBd+rlm/+7m4cnFhFNlMpIeQ
X-Received: by 2002:a17:903:1450:b0:2c9:d298:6c0a with SMTP id
 d9443c01a7336-2d05246fbb8mr88691875ad.2.1785660192824; Sun, 02 Aug 2026
 01:43:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260730181717.95457-1-ojeda@kernel.org> <20260801154223.stable-0006@kernel.org>
In-Reply-To: <20260801154223.stable-0006@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 2 Aug 2026 10:42:59 +0200
X-Gm-Features: AUfX_mwSyBPjd02vvZ_CgqaO3HBOLCgHpt8D6b_pNGvF6OI_s99b49Kz6LgVuPc
Message-ID: <CANiq72kS0Ym1r5oEYcbhUDXcZ910YERpV8m3o06ebtXay52iWQ@mail.gmail.com>
Subject: Re: [PATCH 6.18 000/675] 6.18.42-rc1 review
To: Sasha Levin <sashal@kernel.org>
Cc: gregkh@linuxfoundation.org, achill@achill.org, akpm@linux-foundation.org, 
	broonie@kernel.org, conor@kernel.org, f.fainelli@gmail.com, 
	hargar@microsoft.com, jonathanh@nvidia.com, linux-kernel@vger.kernel.org, 
	linux@roeck-us.net, lkft-triage@lists.linaro.org, patches@kernelci.org, 
	patches@lists.linux.dev, pavel@nabladev.com, rwarsow@gmx.de, shuah@kernel.org, 
	sr@sladewatkins.com, stable@vger.kernel.org, sudipm.mukherjee@gmail.com, 
	torvalds@linux-foundation.org, Miguel Ojeda <ojeda@kernel.org>, 
	Joel Fernandes <joelagnelf@nvidia.com>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 2, 2026 at 12:13=E2=80=AFAM Sasha Levin <sashal@kernel.org> wro=
te:
>
> No, that was not intentional - part one got squashed into the part two
> backport by mistake on my end, which is also why the `lib` removal has
> no commit of its own to point at.
>
> I can revert and re-do if there's interest in that?

I guess it depends if there is some advantage/clarity by doing so for
the future for you, or maintainers, or people using the stable patches
etc. -- for me it is fine either way :)

i.e. I mostly mentioned it because it seemed odd and other issues
could be hiding, e.g. maybe a backporting script somewhere had a bug.

Cheers,
Miguel
