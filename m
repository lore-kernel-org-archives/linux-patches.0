Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E3D25DAEE
	for <patches@lists.linux.dev>; Wed,  9 Apr 2025 10:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744195974; cv=none; b=YMArUB+0s4s6uN+NZ6tXMmRq8NxNVArUn4vHZn7CR2R4Ih9Mm59ImPbiHFcOIRhUIel8PukxicDw9H83teApD0x3Uf8m3fQKaxJGtmHHEnIrMaiMIA90LBqaqVkmToyMvEG7/mpv1g0KBOzu6AweJ7/QS5CX59gJPthZd9NNMS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744195974; c=relaxed/simple;
	bh=j+uEOn94WeDJ8rRSksBy522NBpryi2/Dt/AiLrHWerw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s/qoyabI/OtX+cDn4p/eZlQc7xoF5HPF24FA1PJZGhTf2jXqfXQ5ycD6onZGlVdeXODAru+qqWNFSbo996LwKKYpfpgi8fkgOLjeBXbslrkfsiNQBqwpK3jTm0NuRPdgE6PGpneISYp4CBimAsOFq15AwcaVsoK628uU6PPp1no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=TgGIl+5V; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="TgGIl+5V"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3012a0c8496so5139642a91.2
        for <patches@lists.linux.dev>; Wed, 09 Apr 2025 03:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1744195971; x=1744800771; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GP3mLYDJdiYs49Wy/ACTrdIEYtJ1MffPrsed0RZQMck=;
        b=TgGIl+5VreJel/DMTwQELHMHKmcRdqh6RQ+QTjSEjtd+BPx6Toe1koSEKImJRxkXpd
         Iyx9XZ8jm/MomSwPTD4rK00MPjAwEQQUvyRtzAsf/x/XGcfQW65H4FmsK2YzrY0lRtcu
         ItoKhW6dqfQ8/zOyTGpmdDynk2W9dWTLPjKUjyalxyguQrFZ3PoQPIAOeUxqh3ZnqJBE
         112fC7zw+InOXzLVANZH9dEO/1TjIhSOHwrVwFen/JOMQHd9rnFOB0tGtnEsd9/mE9kp
         8Bxdy3sEQqPyFNfFH0eU06ZPug5IXCqFbUZ4RlSpjd61wG0yr58rnAK3x0xu21OY4T11
         Q8Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744195971; x=1744800771;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GP3mLYDJdiYs49Wy/ACTrdIEYtJ1MffPrsed0RZQMck=;
        b=QPVjg18IjewnWq2y67tRSGA7bR16hpGnprmpaXt7kEohvFx8H/e1dmfQaj/l30KpIt
         lOPCsy8P0HdEmnCpZVtv1M6LJ1sHSTht5ywbwSOyPDELu7n3xM6HynM/a5I2gwifLodN
         KwRcuD1y+pHCaiRkawgO54dd59rjjmDKgNn+wyeriTbYkpmXAhzLJ/wtKL0yH/SQD8p6
         6isvmheo/ud959b8aoX6FMonw5y9fPUbx61A7PFeytNR/3gBRLuaZFri96eocBYN45G2
         LAzhj/3dLC3+WiU9+jln9UlJtTIW78lwCKimMPGjLLukgM+HQWo6cArngDeJNBc2GYC1
         2nGQ==
X-Forwarded-Encrypted: i=1; AJvYcCVyPoU7eToeNOqqTHNaFkggOVg0wZvoz0bRB5xFgxZYLllf6XZgCwkjoP13g3kBPMrjVoL2+hs7@lists.linux.dev
X-Gm-Message-State: AOJu0YzCJAwM+bKBCtelTxoOOWknWnZQANha8Ufu1F0mclVX+dYTTw3S
	tSsXSAjSvuTPZh/DTqx5Gt1YdEot2rRsGMEkIOX5beiSLgY87wUlSBR9uvbgSImaGZmBZFKftl5
	7zeaeRjkaP8L6Q8u4nM5aFaAsSgdW+8dChCoinQ==
X-Gm-Gg: ASbGncv0qCRMfidYLiYYYl27S1zPfVAvocQw0/9deJD4wkIjoNQNIIYeCtqAy9BaEJR
	b0/EEBR62iTmoD7uRoHCxVbbAbxT2iMTP+0iOS/DlLuRahHruCpOSt0v0bln/fxCHQacjhZ1+Le
	bhKxCAW5IGf5JvG5ygY8LVuA==
X-Google-Smtp-Source: AGHT+IE8q2Fp7m5nIPPywP2omnIJkj+8unBb4Xhy4pc3ScTFmwB7HP+RqNqLS0Q/9/FH/M13aISBQjE/oCpdYRuqHDI=
X-Received: by 2002:a17:90b:520a:b0:2ff:58a4:9db3 with SMTP id
 98e67ed59e1d1-306dd56b573mr2623679a91.35.1744195971569; Wed, 09 Apr 2025
 03:52:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250408195232.204375459@linuxfoundation.org>
In-Reply-To: <20250408195232.204375459@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 9 Apr 2025 19:52:35 +0900
X-Gm-Features: ATxdqUECQ863JszPw4BKDGauaEHrGOh4MUsIOWrVopMSy7rYKfjkRIj4B0RxQn0
Message-ID: <CAKL4bV7inHa+o4mka+16qqdxxQvpKFj+gJ6mfi1uzHrXZp27TA@mail.gmail.com>
Subject: Re: [PATCH 6.14 000/728] 6.14.2-rc3 review
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

On Wed, Apr 9, 2025 at 4:57=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.14.2 release.
> There are 728 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Apr 2025 19:51:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.14.2-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.14.2-rc3 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.14.2-rc3rv-g5bf098994f3a
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.2.1 20250207, GNU ld (GNU
Binutils) 2.44) #1 SMP PREEMPT_DYNAMIC Wed Apr  9 18:59:40 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
