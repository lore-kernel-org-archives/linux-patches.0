Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1BA190473
	for <patches@lists.linux.dev>; Wed, 15 Apr 2026 18:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776278763; cv=pass; b=K5rkGS1B/9dlwrrSjgHPJBt2MJIpJ7NmYnQXoCXO2a0LGs06pc4osLhUqJjE1FlJ3NZUyft1aoYq7DtojWcu6VABj7S9BIN3Yg584QyOREBgptQXDB0ppx7PC+hmSlueZwCBmnxkpooTJ3NzVF68EfXVfEV9GQydJXyKdyiOESI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776278763; c=relaxed/simple;
	bh=tiVxsaCqWWNVXpTWfTarr3wP5tbbpKx//jfudX8htKA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l75xIeMQOKhJILJjAYr3CivuMWJdKnrdBFPNXmfARxqRUvB2w4OnpEE4QqZx7NCZh6xahEIYPyY7oHszP4vB8W0tn27wnabOTmBmoUzdK2HW/S7n8ttIo7HNWqnk5rqYAtljfUW+PxFuNQBXcLuQ7ry/bwT3e6m//Wlou+vMi0I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Sn8Carog; arc=pass smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sn8Carog"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-38ddd8d3b7fso53144041fa.3
        for <patches@lists.linux.dev>; Wed, 15 Apr 2026 11:46:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776278760; cv=none;
        d=google.com; s=arc-20240605;
        b=it3cFv6/8wiIR8pbCgYNau0yKNlpxYuPYojasnJrlWJtfUZg/7iWc3s3tIKw/KEx5Z
         zwwJb/ebqbUJYT9tc0WScYYTfamWU3IswOyBIlbrrH4OHJoCjaaGVIGScATW3znUIgDd
         UKXNdt/muFN0zcOSASlc5Z+1ao+k1I1RFj2RxoOrbjPaUkW5alo/YGhoGKxCUpiV4pUA
         n6kNlazeXJl5V4UoIoZNXRhZYRBdHKtVgQ933JjJ0ciClqG+Gc4ta3bVQwH8/5EQ1rz/
         pTpyBFnu1wW3wD7903cdB6gk6noWgDzen02n3AMs1Z1hxMY6the52CZIq/ZwW1FN7jCq
         BSaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=F9g437KW9i1Y5CVsW3NswmQ5hVUE5gVydtz7VdJHyHk=;
        fh=hCnKhGpG+3kcmm2MmglGDX20ntDjMm/btUzQSHDx1Tg=;
        b=Zw2BaVyTVuygkGjaChxJINYsQVkrneR11S6bB7hb+VYyHdIxuSa2+90x/NkBGWkUMz
         QVKvb8As0O7PBp1b8VkNtToNrMg7XtSZCaca4chkIEXR4l0kImQ8R8Fa27OGxnaUmF3Q
         5XMRqdVWb+EW5IYowK6hXnyDddozYbfvcrA5+pzsoCbMKeJwS7hbbJcOxJxo26KlqnAa
         MMvdlVRn7mXTn7u7yu1sq/MCxUGgAQv2u5hSGIkCAP8HYn5Ys1p1xn5+XdS19DNsPgc9
         0tDROvFllQ6XRZYU+lUuz8iSo5mRI0t80K08cwxo+iEGKLqG3U6q9PttcOffo6dAGqSH
         Vxew==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776278760; x=1776883560; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F9g437KW9i1Y5CVsW3NswmQ5hVUE5gVydtz7VdJHyHk=;
        b=Sn8CarogPpkj+pPHxCpw+d0XzAxpQPpeAu2cm4ZirVwgn5EQSjWHqQw3DdM4GBHMMI
         ygqvsv89eLviNrlipD8lxID+BcM1yd8wo3a2Lw2C+kc2JZUCNO0iXRsPjA5gkzNpk5ep
         q1V3jz/rBNcJaEuSZNHcvY2X06kK8UZRV8H6dVlSmTXumAbmg0LpubOKkADD5uPO8LBn
         MWA4xFNAqFImwbCmFro1ruFMrZrFr+0zkJ3g1xHEmJLK093Qhl1YnpJtlwbs5PRDmekr
         SrR5BrnVLlxjvNz2UGK+NI47bH0vugM+YXQodpPygs8VTOG9kz0esHbjYtC8nS3YGVlJ
         X8xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776278760; x=1776883560;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=F9g437KW9i1Y5CVsW3NswmQ5hVUE5gVydtz7VdJHyHk=;
        b=UFFUFqGBq+2+QLsX8QTRB4sxi1K91UJZYMlXjJ9kf/zplXQrjwEDKjvSnA+5pbryae
         9G74OSNrpyYrsNUpOIRNamjtGyotllZeNbUim6L2ZP0cka5maSiNYmU23MBXu65JU+4D
         jlTsQPMS10NixB5FLUpjDTI+3ISITVNj8iQk2q5bTV1z4DhbgjD0Zq6LOgUP4kWbR1MF
         EJ7EtVQiutDX2B7rliM7mkCLtoyxm+fdhWtZHXzEVybBDuqpy4lEcXN/+1H1+4qeBScX
         MzL9+OX2YoK2wYvH6EW3OiV9FazdDrDgMT86P5sLrULCW27n4TytYf0wbOwnhK/JYo2y
         k7bw==
X-Forwarded-Encrypted: i=1; AFNElJ+Q/jd0euXDPbRIw/0oVQ53oCA5hoQuMMGXiCESJjmvpQWt/VA4gGkFDnqd4lClvcfI75Hy1yRK@lists.linux.dev
X-Gm-Message-State: AOJu0Yzv0Z8OihkQDlnvp5zSsnCjH+zO4JjelJ+eIIpDq3npOv4Cu5w8
	02daqF4wxOX+ALBg28nQec0ZnacSDzagheM9re5hLtPhWXZcTqNb8fdLfIKyOfOzqhdFb0dmQXm
	M/G5fS7qbEwgZoin3kYpf8ncvurWAVXk=
X-Gm-Gg: AeBDieuhATJmqeiSpte21qOTxI8rRfnHalnCSiBEw5msNEc9E7FDTPLwoZV5JpjPOxG
	f3OPnfljfJgCDSSbJ4HR+7+nqdIqZvLrgQtTlyGPNC9FQ1lHrekVMvxmMAbn1N6bedRgO+d/tQP
	xjwV5MSUBMXiomSTmJc4LSQaaaMc33KnRASDlqWQodYYCOO+SN8TFNDpTLq3KBIfPoAwvVymqlL
	VvXmOhV/Cl1/kXTGsEhGmyK99RGLDXtskbfr9FGCVHsDlptTd6qru+2qtNds0EDnS5OSevFG54O
	jugJWk3yIh2EmxWxJSGdH2s+JqOyiAcYc95akLXF
X-Received: by 2002:a05:6512:401f:b0:5a4:3b6:94ea with SMTP id
 2adb3069b0e04-5a403b695fbmr3569578e87.23.1776278760065; Wed, 15 Apr 2026
 11:46:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260413155728.181580293@linuxfoundation.org>
In-Reply-To: <20260413155728.181580293@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Thu, 16 Apr 2026 00:15:48 +0530
X-Gm-Features: AQROBzDNmmvUj0bf_HHHuzj1RxKBrvQQTZsJ5hhR7f3hm9lmYe2rHCu3RAhKov8
Message-ID: <CAC-m1rpkx4eDitQ=F7r=5JEJ+FxHaw3ONP-6rmuzs-KzjNwCcw@mail.gmail.com>
Subject: Re: [PATCH 6.12 00/70] 6.12.82-rc1 review
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

On Mon, Apr 13, 2026 at 9:52=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.82 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.82-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------
Build and Boot Report  6.12.82-rc1

I built and tested Linux kernel version 6.12.82 using the default configura=
tions
on both x86_64 and arm64 architectures in a virtualized environment.

The kernel compiled successfully on both architectures and booted
without issues.
I did not observe any regressions or new warnings in dmesg during boot.

Kernel version: 6.12.82-rc1
Configurations tested: x86_64_defconfig, defconfig
Architectures tested: x86_64, arm64
Kernel source: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux=
-stable-rc.git
Commit: f4ef43b0a8c401bcd6d40e3eefd2ac504f23fd00


Tested-by: Dileep Malepu <dileep.debian@gmail.com>

Best regards,
Dileep Malepu.
