Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76DF3500969
	for <patches@lists.linux.dev>; Fri,  9 Jan 2026 20:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767990590; cv=none; b=JvwEwbU4u8+FHws/ahnIq3P8wyeq/Xky11JijhdTpX6ewUbSMvR9ipxXDK/QTpsLMXlayDi55Wvjv8l6NqR0V+YpMjW8FW1Wkv1n3AQoUGvtHhlyM9Tjut3XvnNrxlSC0AmJ2AAeFCaNw+kxJatQ3EUvQAlB4Qd+YDUexdzRCUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767990590; c=relaxed/simple;
	bh=kPty2XSJ1GOnPe0hUHJ2MczujYNDgIh37AvEBYYQhiA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XIxEY8MB2Fm4qIyACWkIxO+apzZNcxQHddQzorQoqm2mOVTbptc/P4x18MXrj/MMGIY3+pE42FvJSlx6slVL4/Y0eHp3qp/aexs4TPabjOlkDv/h8DckzRYVPhgdDk5U4ReHdzqg76x+IJQOwjWWL89xVinR4ZVpv3Gm+aUuIhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com; spf=pass smtp.mailfrom=sladewatkins.com; dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b=RczQPr/i; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b="RczQPr/i"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-64baaa754c6so6354711a12.3
        for <patches@lists.linux.dev>; Fri, 09 Jan 2026 12:29:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.com; s=google; t=1767990587; x=1768595387; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9hxSKJhPzUKMHAOXusRtv4t4eZa8UPsCro2dFMgnySo=;
        b=RczQPr/iUdqcNu2hWbSgMqy0Nk70LkGvCYK0Ba3242355hDjLBU+M1Msd2sqqRNcFk
         B1r1yoeLk8xFhUqHkL8rvTKSMq/891pMJbEstmcuQOE29alxvrdauexRknGDG1SvUvvZ
         vmU4m5m2KG4rF8if8H0/9vNPvb8UwaulqxfX/W6Q8PJ2tzpAaSSYm++5z8Fbi7GP0fRg
         GSOBbMcBUBOX989+ELL7acTMZPwfGV1R6farpFYkAV//HIFWOrxsxY+sVZjBVsApHoZI
         /2qwjSThlkSCqcf5bN7iBz9Jz64pru9wIp3LjPJdMnwxUYmAXlaPb2pNXwK/O9UMVinB
         CceQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767990587; x=1768595387;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9hxSKJhPzUKMHAOXusRtv4t4eZa8UPsCro2dFMgnySo=;
        b=vriZK+UFOb6i1qt1g6OyIL8dk5ny3CrA8EqT9v/nKSNNXgXjehYOcISh2NeIFyfhLg
         IeXnZ0a98hHpm+CK0TWtHYDB7iALOKdTOt9BQT0NNKSyVaw4MZ2qQyDHxCTUDvoqHKPe
         gxweXSzIVU0rC2HtQOi4f44vcMT0XzWLliUlby+msHWmqj5r+UQm0QzqHqivS88hYBBi
         kyBaRrFOi0ohNvzHsnUdhVOqFEyxM6T2X5uP7wJczx5z/sjW5Lebzn+ci4secEVVEGuy
         oU5WqiVbn44SOYy1yVJITlmKWxUtgA6akYoS6YR6hW16djkw18aXoiqQfzX4tFBPaeot
         j1AQ==
X-Forwarded-Encrypted: i=1; AJvYcCUZt5rEpXcWQogcBJY8CkFrHPngRPO2hTEIfj/XAhnYcD1m1GkxTpeorMeDaexZdB6rsIS3Y5QS@lists.linux.dev
X-Gm-Message-State: AOJu0Yx2fpauG5//xujQIAQs+mIOTQiQ8j49/k2MKh0qGOhFhVFzJ3UF
	nPcqNaHg6S/oIBrxMq2tVXnZUrVHD3WG6qx9GcFHG/H+z0HJAXdjP2gOC/DQ63IeVwjFpBwRrvH
	r2Lo2+EF00hBo0m4RT6zAvc8RwbyoTo/UHwtVaNF/0abqFY3oM16usZf4Y+9AGMNwrRrh3BkSHe
	pWkZL7yoZdvFEDFt4J3ar8Ecc0URfr
X-Gm-Gg: AY/fxX6MEUVLBuvPy7C51Hz5DBN+0s+tCZgMcXktl6HBZu6CLwW+/JmYuqqi+VhVPDw
	Vq/GBEt4jX00DWsW5Hm0xOSIpEd46H5ulS0ZNlhr7noUMbXPuDl72C77N+EHc8sdK821pcG4V7p
	i0rjLCfNWy5OA/OrIgEeWee+WH1ddTBlh3xCqJ5Koa9IZypiNkFtihT1/wjUhDSvgm17KIoUqP+
	JDx5okX7nhxWu9LSwfV/zIMLATTzcb2FEZGEK5zXN4x1XJY7FPaim4NKT9SvA3I+coLk7uKmj/8
	N4zGLbSAxjx+6rZtrkTzkk4z4W9o
X-Google-Smtp-Source: AGHT+IFsQuep1RCIF48EoSLJlBaeHDB3GWCfWQfuNP9JrLNqa9W+D/xzeMk6jabguRmykg5uQ7ExPeaLegU+YdqbIEU=
X-Received: by 2002:a17:907:268b:b0:b77:1b05:a081 with SMTP id
 a640c23a62f3a-b8445283562mr1120993866b.27.1767990586444; Fri, 09 Jan 2026
 12:29:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260109112133.973195406@linuxfoundation.org>
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
From: Slade Watkins <sr@sladewatkins.com>
Date: Fri, 9 Jan 2026 15:29:33 -0500
X-Gm-Features: AZwV_QjZnM_RGVRmuEx51d4peqbKJ1XlzEdSpXr8uwc9vKqSRmCtI1k_wNRdIQg
Message-ID: <CAMC4fzLxeOHNKoRZiw1kjrf7L54-4kDPzQFx8NiyYEZOtrC97A@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/737] 6.6.120-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-SW-RGPM-AntispamServ: glowwhale.rogueportmedia.com
X-SW-RGPM-AntispamVer: Reporting (SpamAssassin 4.0.1-sladew)

On Fri, Jan 9, 2026 at 6:50=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.120 release.
> There are 737 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 11 Jan 2026 11:19:41 +0000.
> Anything received after that time might be too late.

6.6.120-rc1 built and run on my x86_64 test system (AMD Ryzen 9 9900X,
System76 thelio-mira-r4-n3). No errors or regressions.

Tested-by: Slade Watkins <sr@sladewatkins.com>

Thanks,
Slade
