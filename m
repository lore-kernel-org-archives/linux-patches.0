Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52CC43EDAD1
	for <patches@lists.linux.dev>; Tue, 24 Mar 2026 18:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774377830; cv=pass; b=CKM69GIcDs1+G3VMcnbHjSprAHnl2Jm/Hlz1Y4b3O9nPnwzhZ7+amH94U7vVYbDbwRM8oGZOgATZ0I9xaM9jpRApqDn0/t4WUVk5DkriprTxI+V9gtJ/nd1+O3V+StruHM9OzE2SgDZvrO4I13fSwrugXGjgt+QsBd2i4QmS8UA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774377830; c=relaxed/simple;
	bh=nZxOQ4beMWV/08ZiDnYmzsFd2k0Dz2IBEN+PHtEgCy8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cvf0Bam/skWhnYRwEtcU14jMiDMf9lkfoHDYkgTB2KxiVb/kPhzVLiRqvCtUo2UIbXYRDXAfH3D5ZR9KjYAZlpaifxHCqJYDOYI7VulNmMGfn0rrBVgdnjmNpsFw1iIsJZpxW8h8HsV8K+SfbhS6ozX0jOjI0E1DKKDHOTTrVuE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lbhiJOMN; arc=pass smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lbhiJOMN"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5a13e1cfa45so4962225e87.2
        for <patches@lists.linux.dev>; Tue, 24 Mar 2026 11:43:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774377827; cv=none;
        d=google.com; s=arc-20240605;
        b=Bieu0vB7Sy6rCXdXBFdImTF41wkcpLHzVCrDR6SsCwMU/x4ALZ+KorJYYAGuyjLQ/c
         id+x6xUL+BAgk83UINQU5yXRA11sb8PeR2q2RFJnIK7NGozHWrnGuod8U7JCh8CVF9Tm
         l/OP8EziHXZQos07DmiHMeUTyeIRlC0Y2E8Chg1h4f2z+rjTwycOh3jR7kXmQa8bEpLI
         wPUjP/BXR7IHmDnAvHBn6t8jhCorFZq3ZT0j53KoynCKWQ1R5gC62g3pNX3Kpoqlp00e
         CAB1upm7lGgOIuJO/28fmI++uI6MzvkS9lb5KbPgquiHj7G2yVyyC5B+DGVAiZ5Vl6ij
         R88g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/G8eO0YKOV2qmE7vVQSycQc0H5lXwUfvvW9jfDbQN5w=;
        fh=l7HjV568og0Kzr8CbIYgyrrxB/LVfrbX9/ZP4ZzYgPc=;
        b=lnICE3yWCfT6hqeGQyC+7R0Iw7NkZePOHYJGMsfJwVNII6MqZ9SZsrftOxYHAhn6A+
         HOMLh0R0NP294e+HmLj++HGqoVTyeaiGaaKfKWvmEuTSsXXurEoq6JOwngZP8SXOsfCG
         JFENbuDc9euDY3crcOhj/ksLRr04dC3sgJ2+214ID2IY67CsEGrNG+smrQbXC0vsYPug
         ROyD3r2M/CBh0k0YAvroQuoOTKDLu8MjBg48lMcneVKBnTUC6gDlh20Joba71T78Qs9s
         +avsGrpvCmsACp1U4Z/3hiXCh2TQvH3cG0M/FjVbj8yT70aCtVzs1V0J9rdi0I7OURJy
         +FPg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774377827; x=1774982627; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/G8eO0YKOV2qmE7vVQSycQc0H5lXwUfvvW9jfDbQN5w=;
        b=lbhiJOMNf/6CEV8FXUNX6bjE7hwocZK6dWN0Q0M87soUtwRDMbzsyIUoZ/TOvpl4zJ
         na5ADTcC1fzvJ+DkvBEDA/0IPq9rYw/AtR7RBODze1gwEmN1hYWUNwZoAHRTmbSFFv6k
         zHP2lQMTB3k60ArYEKCrq5y6krpCskEpwezYLM93/ZZU7f9HZi1Uxz8f1oCdlF9uS8Gx
         /m7xytR0PzRolj9emms2jUjSiuK3Phfo4ihtIxa/EnayNXvHKF2b8rq/zcPHA9DZbVcd
         bt0P20Ao9Y1iDGXqlQl9GD/yKY3QoJfEwdbpOJBFXZNdICcrIonXzsVGVV3XmohqPfwm
         jQng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774377827; x=1774982627;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/G8eO0YKOV2qmE7vVQSycQc0H5lXwUfvvW9jfDbQN5w=;
        b=LxrGL1vJL8+ERd0IdrLxAbdOHT7Tf/2i/WZxf34BCxg0JCKUvBf1MWy5gHBeWbn4Yd
         nu4wM2fLNp4imtI1TwHMq7VkuhGn8OAxIMjd4PI/qLoHUXi92+KQTsN1HQgNnf7VU4k0
         pZ7jY7hAARoWIYwOaUEVioVBEhx5K+ycEupZQcLJO+GY2Qpzu0oWDyUCy/0fN9plz+01
         B8K24eS86DeXozRKKtOH3PsdOzZ/3RtiYW3l+AYgDrw8p/AyYaOEeVWlPm4HhCQX1GDK
         EnFd7fcIlz1546GBzBmOw0VRKED9dHX+G4x8RXKnW6ZwtJztC3uSceEftdznn+w82VK3
         +P0Q==
X-Forwarded-Encrypted: i=1; AJvYcCWz1Gq7KLlp7Mvqegvsh+NTCGPPIGuioOuPegRqlX9aaBw9FvveZNuShqkNNDEGa9zlsRbmRbWz@lists.linux.dev
X-Gm-Message-State: AOJu0YzbchWq5lANwsnfGqpqMtEdAxyX9ZbUz+pVFbBtM0VqbeNNcYr9
	f1u2R64t0kbFHrq6KUdLdbWbHp526s0UCwLG/Iues27fLwpyy2kI5QlMNnx5tZC5Vq5AjQVSEco
	PzAhrFrdAfKF2uOcQ1BNElozlyYXiBT8=
X-Gm-Gg: ATEYQzx/JgQEY7QXo/0byAhnMTLXZeLe3pWfh17O8/spyFkv4yEHbAmDYicIIQN9uJP
	W7l0IZ/StIybq149yTf8I/dMMstOf2nLfCz/soJAz9xQQeHGJXPbcLQ9iRe+ZzbqLavQwVksVJG
	IK+iaE+/XtErUESTSxDelS9ATP3f4DBu/8uC5cJzVBGf85x3CFz8na7GxyIIH9bWupfj0zp+60F
	vlY/l+5mTZAU0NefKWrkmKZ+lCfkyWD+4OmxCh15PL8wa/GGrLUQWhPgq28JShZE2uAtRvHC9uu
	qK1aNI7uRvMq2EDsvcC7KVlxnaZk/fI4WWFSagFw4RkRYgX2lCA=
X-Received: by 2002:a05:6512:2313:b0:59e:1954:1d3f with SMTP id
 2adb3069b0e04-5a29b9a5930mr234603e87.44.1774377827112; Tue, 24 Mar 2026
 11:43:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260323134504.575022936@linuxfoundation.org>
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Wed, 25 Mar 2026 00:13:34 +0530
X-Gm-Features: AQROBzAAPqxjXSoph6rC11Skwz2i81O33ecaHqPAj2L0yvVXiZNBGvv6Tkk4uq4
Message-ID: <CAC-m1rrD7ff5KMjtnXfAZkm1+ucc2iHUkXEvHeXHWduz8q+MYw@mail.gmail.com>
Subject: Re: [PATCH 6.19 000/220] 6.19.10-rc1 review
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

On Mon, Mar 23, 2026 at 7:26=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.19.10 release.
> There are 220 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.19.10-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------
Build and Boot Report for 6.19.10-rc1

Build and boot testing was performed on version 6.19.10-rc1 using the
default configuration on both x86_64 and arm64 architectures in
a virtual environment. The kernel built and booted successfully,
and no dmesg regressions were observed.

Configurations: x86_64_defconfig, defconfig
Architectures: arm64, x86_64
Kernel Source: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux=
-stable-rc.git
Commit: 5cf3b8242cca1247b6b278b778152b5e343e7d62

Tested-by: Dileep Malepu <dileep.debian@gmail.com>

Best regards,
Dileep Malepu
