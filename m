Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 425C430F80D
	for <patches@lists.linux.dev>; Tue, 10 Feb 2026 16:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770741761; cv=pass; b=IxyEPD4WXTzLfbd47wMXMFon/n1SqeYE5yHv48SWDcBPHq3zhSmPuKiitzXvjkZmzYTSccqLs8KP789rcMnsXFFUl6VfzcqFNorABEw+3T9nF2TREN5BpeiIgMoJbOIGr4wrhV8wpO/pOg0fdlErj9WmEHDbD5zUEee1FDei/Z0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770741761; c=relaxed/simple;
	bh=R27vjPThPF4gZpuO2X4CyaikTBZPoJwo+jfJS1RMcyA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HSS4/6jiGUDuyXLdrhJU2ShjgIL+TqEJUkMp3rfS4NWDhamG/dMtfdZPsexu8k6Qesj1Lmy9T5aJP1wQGCWVLwsfcaMjXPsU4SEgn+UMP2MTwVI/0BsVQbqFcJw9KPXakrXfKgCGoizvWEnGTifBL+M8hvHtjmRgst+Uv1wp860=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=csSMDLm+; arc=pass smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="csSMDLm+"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b884a84e655so166487766b.0
        for <patches@lists.linux.dev>; Tue, 10 Feb 2026 08:42:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770741759; cv=none;
        d=google.com; s=arc-20240605;
        b=UwDH+obwzQp1n8dkWpphq6wd7uqkR61YcMP6o6vBnz69LF/qtjAIAyM+Unez5yE24M
         P7L69/1vbtH6VDcs2+9aiQjbtZ4GUoCp6Elg6+hBFPQGS49aBh272pTggvwyYhyi2tnb
         yU3glQiP03gk6ehppl6LyTvBAwP/JavJtKCjWpO/mYOxZk7ISgv2wKaW409Ba+B66iq8
         /A8gTyca8tU27rHD5Sei2Kvx+SneQHxhqo7o1yCuj6iiQP06/XybQ+wl+uatvHuAisbe
         HtV8EbZVkzb4ml27cc9CZ1sGzymvM4CSqxk4qfHPUre3gLqgqX6gRHnG7RXA2AgUpbOn
         ZqWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wyp/Y3IdbKULn1kjcIoZk7XD4vO5YGxkd7qKZ8DS29U=;
        fh=VCaZd8mOqE/9NG+iGWVP9nDYnWmBMkIfZoqv9HruSuY=;
        b=DUA5BhQ5N6E4rL1pfB7W78YSP4/4u8t84E0FGyJWtf60KgdUjkiMuE6jgE2UxvivpK
         Se1QjQF+6ABLODSMGxZvBwJMzq8szORHxd123KLepd8WG6KDRIrwophz05ANfPQ+DQhD
         1X5e1ROP6X7nmL2hI7/2oG+xq7fjTNAXToDXvvjZ9D/VJi97km2/ccV3kZzcqr2DkJ6f
         i25xEfowV1F1Hv34LS00kwEQMJwrfHuU0dDiJ06hQg/JPQ4HafUfzcZNXydRiotgyHUf
         wxr7+cUQyrw8olq9LGcijlthZKNZfQfdwsp3gWWJGT4sIZAOe0GvOev5uHiTYE2bDJ8V
         c2zA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1770741759; x=1771346559; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wyp/Y3IdbKULn1kjcIoZk7XD4vO5YGxkd7qKZ8DS29U=;
        b=csSMDLm+QfZkdMePvsMlcpn2Lj3tZB/kZB3O3R4/+UCA/jE9PnmrXtwzIbmWLpEmH7
         UlL0Nxoq5tXy1GEG53o+VIfByB8JwTK47/SVbrakRN2hY7AAag4qF2ke4b+WQLkipH8B
         ALgKXGsSY9nCnwIgwp/42/i/UWjJpJ4CX3hvP0y/XNTAIftCWFrw4oJFjO3BCsZX8PC+
         hswEGiX3E54z1QvFSBL+8QlOUOJ1qCh6Xb5vpPl9DvB3+F62U1n5ft2NIFlxpwZhv2Kv
         RFbD8FJq9GQ3M6eUnT0bTHdOCjqNG6NvhMZNGQA/W2WBjyTOdGpMKu185GhRgfdnXzYy
         Yimw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770741759; x=1771346559;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wyp/Y3IdbKULn1kjcIoZk7XD4vO5YGxkd7qKZ8DS29U=;
        b=LToeE5qU9Bzq0DWf9Iv2nP1FMUfQJozWG2KeKtf+SCX8jTi5fv7aHkd5Y5nZ4bDeGq
         /bUgrOoWgKhgm8Nu1XeDO7XUkwrsGghodpvvRH3T89FxG9s6EkgqbJo7aHDxIdYJ6QOR
         P2Z2495/5LZM4nRduVAe1PVkH06GtcthyHYfnBDDVjun21p9Szh9pgn+DuSyEOUttwVE
         bYu+Job54AbgbHXgRlddi1jcvzIYSDPoNwoHpfwYvRDGJfi1Kbx4S/+rKqbF6lJOIq7P
         QzUjA6gg8KHFDmDyuCSdDsZmLtc+5O3UoYMgvJZoj8N4LctySfRGFvXiWTFROq10J0OV
         SRpw==
X-Forwarded-Encrypted: i=1; AJvYcCXvxJDl57D78KhYJcaJjWFywP8z+4edE/aEENLsXCOkku2398YpBIWfK2Rz8RFQK8rWb2jW30nQ@lists.linux.dev
X-Gm-Message-State: AOJu0YxgWYBmsSQBKokilOJty58vhnlk47pj8RirWIebQECsFv5qVCBq
	UNg7rB9lxC+ZBnstyByVJgI7P1zFpkcXHi9bNOUkqjrrsMGRFWBEng8eAZ24DRNhUJcE9LYZZ/x
	vdR87+3EKY80B+ExuAPQEpPLNcGURtoJphjrGYsKVrg==
X-Gm-Gg: AZuq6aJoR6o+kFb5re5PwFuupRadPH2hwpfJYgcmWbj5Q873TiTIT3upI4htJXakon2
	l2klzqRKj+lwMq1JkYsjqBYLm0x5CVz+EwyNJwLofe5/52i7DMsy/FYgmVn4CQ+MyiYOjoGXtq/
	rJoBtCbDqCR0Kh3Jn7VvqpFKqvt9fRIj/2+Ep0OtcrHnPQf5na0WvvxpdgY54CaGfeWqxPnrPoM
	lCDYazGGMFIf4aKyOEMcKnA5WByHShf/7iTfj0lUrHfEII82BOLdR3p+53Y/RN+F+mNbMo7lb5B
	tnPgWUjGSTsdZrbKBdW0AWYcjlXQRDqvgKljrdect0SZEwVBG9QlEMxNqD1HzHSJ1m+HDQ==
X-Received: by 2002:a17:907:849:b0:b87:720c:f182 with SMTP id
 a640c23a62f3a-b8edf173b94mr836851366b.9.1770741758598; Tue, 10 Feb 2026
 08:42:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260209142320.474120190@linuxfoundation.org> <CAG=yYwkhAAm76qUH_2dCHUp8+hGzvgT1Fm_288Z-=QRG+tAbfQ@mail.gmail.com>
 <2026021034-salt-unhearing-88b5@gregkh>
In-Reply-To: <2026021034-salt-unhearing-88b5@gregkh>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Tue, 10 Feb 2026 22:12:00 +0530
X-Gm-Features: AZwV_Qiyrx5DzjivxeQYlkKlLQf016y2YvbWZSbuIjVSoODzbueV9Z2dTXJhL0g
Message-ID: <CAG=yYwkUnCcHhB3WYXQ7kVn4VX59O67NmGQCieZkiPo8oOw+uw@mail.gmail.com>
Subject: Re: [PATCH 6.18 000/175] 6.18.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 10, 2026 at 9:13=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Feb 10, 2026 at 08:34:53PM +0530, Jeffrin Thalakkottoor wrote:
> That's good, finding one here would mean that there was a problem :)
>

> Why did you load/build this driver into the kernel?
i did not load it manually . May be  it came through  "make localmodconfig"

> Any other lp  messages or drivers loaded?
---------------screenshot--------------------------
$lsmod | grep lp
lp                     36864  0
parport                81920  3 parport_pc,lp,ppdev
-----------------screenshot-------------------------

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>

--
software engineer
rajagiri school of engineering and technology-
