Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B9B302142
	for <patches@lists.linux.dev>; Tue, 14 Oct 2025 09:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760435264; cv=none; b=Ykvoq6AFA2JzsRQn7NgNRdx8o47KjWaDtz5K5xzJPTVg17frP8QE7/y+VaKTS4FeoSPBS8KPCezGNUt9KGMCcg+X237iVYU2UZij/byZC36A0voBK/GFt7o4YVidaE9W16fJq7mQHk1ekhLBVvK3G9ZdFgGKHcMlO8GVOiEWnYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760435264; c=relaxed/simple;
	bh=gg0Y24dIYAZ/9swvc+xXneDSBAfqAXZZmkspIAVYI2k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ri5aZE9sWAzqSvtyMa5H5ZviF+tkVNJEm1Q7S4jnuoNx3sKotWerOIELhG2py8CZOPGUAUrpd3TUKZDjxdWVfn/+jlyLChRTXV2iQaTEmZKEDzEXzZnGuiN1zjJL1yyd0P7nDsa2OjlcXTpnCLhUjFdvJG3CsKPI9hg2cM/P8pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NmnUQ7LX; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NmnUQ7LX"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-57e03279bfeso6278413e87.0
        for <patches@lists.linux.dev>; Tue, 14 Oct 2025 02:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760435261; x=1761040061; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/4ZOiD6PpdYn3ZevBQxNWr0OZs11i+ipFFLHeOHI1Bg=;
        b=NmnUQ7LXTc6y3J76cgwN6OxJw/bc25POdlpvM2S88e1P13Z7ccNh5a6gpEZEJQRRsT
         j1Yr+ORM0ugbX+4y/w5xdhcxQ5SgwaBn3LGfT25AeK92uefOtUk1mq7cT6atAPFPgMkO
         Mtkca5HQLMfFUwcbf5x2Cz/azjvtxvedRRfiyD/+EBRW6Zqr1UNry4T40Tx4h8kIdZMK
         XlBUirupy9RIE/a2hV3CAfVLigk58gDoWt/rAAFbmwBBhHWJow4EY2Mw9xsjAf5cnHaF
         ypYs3/bhJqOkBalV6wk/hZOzwh11GkXph/PMjJNG8+Z+YqIdjUmSDvGAVKKJGaXvY516
         ROtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760435261; x=1761040061;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/4ZOiD6PpdYn3ZevBQxNWr0OZs11i+ipFFLHeOHI1Bg=;
        b=vzH4tKYknT25mpS/7Tm7gWh2tPAyzmaEYrifAqYpDk2k0nir93tFiD9OcUocghnbf4
         wI7ZXO7Cf1YEfEvvUav/XqxLLcyPp8mw0ILDXC3jvG9Nip6pWsivo3r9+xo1tpu/j4Z9
         h6M6r2NRdy4w97zPj5sPhWoP7wfNbaKnqkAw8y8+kmdavyutKfvzyi+PC7t868TNnf7B
         n4hqnbmS5OAX3GqxqNLHlf1KayVRb+wdAeeDDMLxGlQn3YG9iIIy4dGVN+hRyfn6pbZ3
         FNkR9iyjsjL+fANn+Zf5E5fWbH4KTrhBivJb3lniiVPSFHpbfam8oLoi71aeL1S0JfWs
         dQFQ==
X-Forwarded-Encrypted: i=1; AJvYcCVB+zkqHqo3PkQM0ei7Lo5w/7RPyCy5GB03yqrE5ScVW/uaXiJn5HRTq4kiRGbJ7glfRpq89Yry@lists.linux.dev
X-Gm-Message-State: AOJu0Yx7QIOHetj8BIAU45Vc5uDeLSD/nEgJxUkX3By6o5tzGTnvngFH
	6WQfGAq5kwkNJxyxPDLMpEW/sGsgu8tC3/vpH8Y3u5PEpSySt/5ag1laz7K65URGw9mZJzsNloI
	5tiWbUiN1T5ulRQ51URNtTOqCvWbvWr4=
X-Gm-Gg: ASbGncuMX2VlNNXHBVc5oNo3ARYaUFSzcvIZXHqY+LsOUPBOmCnw5/x9ZNlsxSIuz+S
	NCH/vG8zhviosQxwzfQzunWZOGJbYLjh+0bhtKhy+BrlgjETFwp24R9OS+OQIkaDcZSRNC/Lr/L
	I+N7/5WpfXmxbc2fMc/MmxLVfQuIUBsDg32LnYfLuF02HL5pRdUZx56d2J/FQbIFZbgEAcb7GoF
	ev2O5IDHJeHu1v63OBXFmnJS8zQQhVcJoYP7MP5PoM2OTdot8cG0YM8V/c8yqQMxfIqBQ==
X-Google-Smtp-Source: AGHT+IHZa0dg20bxTZleVf8/nqgXxeWzjDoLOqtzcYvlJbfHC0d5D8BumL4rdNdePi72Zvo3aOThOpktfOFcMoXIPSc=
X-Received: by 2002:a05:6512:4004:b0:57b:2783:6d3b with SMTP id
 2adb3069b0e04-5905e28d7f7mr7752126e87.20.1760435260750; Tue, 14 Oct 2025
 02:47:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251013144411.274874080@linuxfoundation.org>
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Tue, 14 Oct 2025 15:17:29 +0530
X-Gm-Features: AS18NWAUa6UI1O8c9zp05XyFaeYEUd0eTcQl_Kt5SBjjdEaOPLRH23oVpWjCIEc
Message-ID: <CAC-m1rrMw=16q7h_jVUkQkxv3scTrBZQ=ctyG_yz7GzhNTx1NA@mail.gmail.com>
Subject: Re: [PATCH 6.17 000/563] 6.17.3-rc1 review
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

Hiii Greg,

On Mon, Oct 13, 2025 at 9:29=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.17.3 release.
> There are 563 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 15 Oct 2025 14:42:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.17.3-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------

Build and boot tested 6.17.3-rc1 using qemu-x86_64. The kernel was
successfully built and booted in a virtualized environment without any
issues.

Build
kernel: 6.17.1-rc1
git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc=
.git
git commit: 99cf54e7bd2fde42d75c71b54fb3652adea2e7a4

Tested-by: Dileep Malepu <dileep.debian@gmail.com>

Best regards
Dileep Malepu.
