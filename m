Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91BFC208AD
	for <patches@lists.linux.dev>; Fri, 28 Nov 2025 08:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764318167; cv=none; b=lX0GXc7gokTigXd8hp+IkoHCub5HyCoh2XwRFyxfgDrGfEgAxru+7Ztpbhai2Nxn/MsU/fdfUTYrNLHU0o5fKFZKQGW4+JjD3QUa6dV9u68zFT22ZOuQe1Kxmqwmc6jou7SCCbZ1uSVs0XhnX8qGBNMTFDRyCfBxReK2IDCMUxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764318167; c=relaxed/simple;
	bh=7oOJGGhMrog+ToQ8/FvfvQvGeOOCMZ+IneBzQFWOz6o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b/vLe2FcJjEtm8c57YpqU3pDyp72H+l44YRHQGHBge7fJbseiRggIcMBYDwvu+Sw1NwU/+bZ5p8I5EO0M9WipUkAkMkxuiGxiyCxK+w7R5x8jOLTP6g/MNyhhfAx67R8qlNCHzOgtFVrSZlG6DMbeN5reMylz74kwYjjNB3Ptvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R9CHtB2Y; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R9CHtB2Y"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5942bac322dso1734781e87.0
        for <patches@lists.linux.dev>; Fri, 28 Nov 2025 00:22:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764318163; x=1764922963; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oHCeuj8gB2CuW6wprwhSKdOXpBDmYx45db33xCoSj/w=;
        b=R9CHtB2Y8Wrv6ZlfIAA+6raXltCHKHCGu369kPwiQFqVFpqcdRpQ0Pwki9R+VKTzGp
         Gdb+D7QF/vnzXPUts+GhgLVlBqx/E498HhGvz/zXEJATrjLQGVNa00PUxDEgwYW5JR6F
         6ujidfBAz93FrE0Y2UtCP2JhMKh/qmE1cQQcK1viUpdSHH47iPAyN2MLoVb9zeCxtql4
         dCwNX7Bq9a3FHkTHOBtdtt075OSDvsjYoijcX1hbk8J4L9lroZomccV6HT+eGsm8BgI7
         5DPMYDibVhoc2bJcyQo4QNYwvgm5j0ozoiapWB3xGnQ8BPUPQiZuCxBgMlpkMqB0Lru8
         GlBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764318163; x=1764922963;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oHCeuj8gB2CuW6wprwhSKdOXpBDmYx45db33xCoSj/w=;
        b=MXkt15i2+EmO+Q/3c6A96llSwf1T21z1xsh0yq8B/Ccm3uXWJu6/DAi0tECBONcArp
         2GazuEfwxZWQ1WhGTT6B+lAxIOI8nZ07xaYJwmc1V5RsvuuTDc+CH478MdpuVf1vUodk
         9JTz9zCfJ0LN06P84oqPZkjXbenHwQuZXZU9GIVChySKi9qlCd6jlvOgczZ2zn3mDLkN
         6z8BKqerFf+sfBPgo297/9b7p9bXHWKQ6Fo2XfeeCTMD8ElHP+vhUJcQe15SZC5qFrJh
         xfhlsO0HRmAhFDhowkV16WCIrmYI9gAciwnVn9HRaNNZsdoLcxAYAoKrK9zsdEOuFfTZ
         vNkw==
X-Forwarded-Encrypted: i=1; AJvYcCW251m1xMFZGZjcswi7Vr5K79uQSApz6sQhSIggiaRjut24Pz7nVNoXB0t+GNzZfkWYjBU7833e@lists.linux.dev
X-Gm-Message-State: AOJu0YzCfpfqkXh2/kw7vlogllWTMZ4PmY3VZXk1RdeXB6BB3uKyxrlj
	vNi1C9Lwo62eDU3eJlLwoDqt7Q6hX4ZOvFtZLOQL/UBWY6xwK2qVXjm/OIyYP4k0ZIQfBWLauqC
	fLhhR7yPhoTpcg+SfZdWDp/vd3JUe0ro=
X-Gm-Gg: ASbGncvYlRTQ3OAxO26G9c/2qOIbcHLnOvdNGsCsLWgjw62ddet0Pxzyh92KfQAQFot
	04r89+fPJ5nRhx45jM54g0yc7ldasZI77ROeVELH7lIJtuE+4vjw890QS9BOzhEZnNp0vpoHhwy
	4jLsrRylkZX2zbnbZeM/kM/ZloMNU9mu3GalMgvLgV0x/f6UxL4ALC6iRMNLJKzcLo40iQULZgN
	JW5CAF7E0QTIiIRy/s02T8Cxjga+s6790jJUFfG9rLkaCxREnD9CU5wZCUfTFZBTzNJxIWVVfjd
	+Y+ZenTfLszTvwhEa51BQcbv0f4=
X-Google-Smtp-Source: AGHT+IEE0Ltog1BqZAp6EBgcX2H5jbG0BwiSehNgXi7ObjiEkhdk1nthjYej3asc2kjkPYi+ttWpAPwjSZUDybQpYhI=
X-Received: by 2002:a05:6512:104f:b0:594:35b7:aa7 with SMTP id
 2adb3069b0e04-596a3ee53cfmr9323339e87.48.1764318162632; Fri, 28 Nov 2025
 00:22:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251127150348.216197881@linuxfoundation.org>
In-Reply-To: <20251127150348.216197881@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Fri, 28 Nov 2025 13:52:31 +0530
X-Gm-Features: AWmQ_bkJLsxwXDpSbB7s18HNg16Pz3k5EoQWRGjiTBwxrQHtrf5TCwhI-g3Cd9w
Message-ID: <CAC-m1rrQKJPKs_TvpPjbYXkHDet_Gnzw8awNHdWWRLDfq9fiiQ@mail.gmail.com>
Subject: Re: [PATCH 6.17 000/176] 6.17.10-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 27, 2025 at 8:39=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.17.10 release.
> There are 176 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 29 Nov 2025 15:03:13 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.17.10-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Build and Boot Report for 6.17.10-rc2

The kernel version 6.17.10 was built and boot-tested using qemu-x86_64
and qemu-arm64 with the default configuration (defconfig). The build and bo=
ot
processes completed successfully, and the kernel operated as expected
in the virtualized environments without any issues.
No dmesg regressions found.

Build Details :
Builds : arm64, x86_64
Kernel Version: 6.17.10
Configuration : defconfig
Source: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git
Commit : 6c8c6a34f51808e7b3dedc4227e8bd060559a0e2

Tested-by: Dileep Malepu <dileep.debian@gmail.com>

Best regards,
Dileep Malepu
