Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B041E5219
	for <patches@lists.linux.dev>; Tue,  8 Apr 2025 15:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744126555; cv=none; b=EEdvm9cJtIElk0ExdrGIya0mBi4CUte0P4OEXgTtKI4x24eVLHBExxwp+40y23zlFMLaTFULOcMhTHOAJEx5lMM9urDbvXBkVPiMdy7D/FCUWqq/y4hCo9MVah4KFZzoAjyyw7VMIgWDQHcAQcCF+Wt5LONWKYQgXPQP+dtUuGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744126555; c=relaxed/simple;
	bh=S6DOC2X2/GtSJdHKZrfV8WYIYmEEczMsgL+5jkuX3do=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uCpbK3ofUTH8ZZ2gQzxPdR2inHQWUsniMIDd2WAr6De7h0CMTGnm03Vo/M13J3UeJDnKGZbfoV8EphcUfBBoRhr8AMMBTZZmNhxz0npQKS27MNQr2fnNig9zlySAPAtRQHC/E7SgDOPBJXQwHuRv8IwSF8Q1ukPDDqKqgwn2a88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gxYeqIXB; arc=none smtp.client-ip=209.85.221.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gxYeqIXB"
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-523ffbe0dbcso6007127e0c.0
        for <patches@lists.linux.dev>; Tue, 08 Apr 2025 08:35:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1744126552; x=1744731352; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BqY9nqo/bT1yXEsldnMuBK8EFrTJ4cUK70Tv0YCH5v4=;
        b=gxYeqIXBkLIcnhRBu6CU1kdl0H8F9O0jAPi4KN3xw2Fy+4H6RwC7WVgrv+P0U6Nwvn
         yX9h/CL2IphCaR0XpdbP1XfQpq5NiRZMq8vOWbYSwGUG+tmVwoyhwMFYkwa0Ok12c/dF
         2xPbts+mVMQ5L2/efbrLotAqcrO0SFiShIcraDQeOCxUhBgVlkT/km4f3SmnSHyOol8I
         QVFezPFVTlgMFwKgmyT5ZPkEFG5+XgfViUXQYPIRAbxK47K+4nAWDoEJTGPA3vO9Muns
         lq3XfxsLF+fNol9MoOz3fU1ql6MLFrPZrsC6HmslD8djbiesIFEkaHsFmxR2n7CJzKrT
         oZxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744126552; x=1744731352;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BqY9nqo/bT1yXEsldnMuBK8EFrTJ4cUK70Tv0YCH5v4=;
        b=gFz6tqRg6IYHJsQso5pvDv2+zcuWK4ACNvHrJmmuzsCOtpqLS0HP3YUmkBEaYyG2p9
         oxOzDbH2Bb89UqGSCz0l19Myf+VBnjrWeqp1eftakf8AG52WlPMaCpEEk/2ZqOdZkYRo
         8W35BXavQB21nswZiz5Psmjk7tFzQ2+GOSneUSrE/iXibfkhZPEJXbNN7sEoKpFFSlM3
         KcmsMsDZ7gXM0+4kdsOiXrjlJPV4MJ4cjoxRsHDr6tLzy83JRbRyY3eq/8ILdOMgredF
         ayHuOu1DDn+LFrp4TXe45PpBCbtupN3zkZxdqGiDNECgShOLwYzW7Tkxbskxo8cRg4CI
         AgWA==
X-Forwarded-Encrypted: i=1; AJvYcCWREsgiF3XRIUH8SkMrLf7ZG2EZE1U8HUVbU6U1EpDiSqTo7gV5NI25qvYznHQODQIrOg6fcP/j@lists.linux.dev
X-Gm-Message-State: AOJu0YwFill5iR0r8voQoA4vmtr4OwSndNhZuzliv0nx5TZG24WjInoj
	JE4PJc5S2Lit6p4e3BZ4YSyglGm3NiOrFPYXcVKMmW+lWU+SO8+OdPkePUjAhoG4wlxaOoI4bma
	OIFWSAF52LNCCP5LAz6TGdJPBEevjrPmrXDfvGA==
X-Gm-Gg: ASbGncvjUpPEO7NoVFCHeFkxkCx+I2oHlAzvpRhaaUiAnDYnTHoQeZpt5rZUu3Q38QD
	2tRVipvKAhON0Ss1avmtaV4Yoe69yW4aPLuoRbCfeB3dUkRH+04ZwSPjxfVq3ZX9JBhRikjEfES
	0fn6xS5craqzh5n+ePUK3in/95t8w2Yp8iIYi/4PSURWzamRW/olQcYrs+
X-Google-Smtp-Source: AGHT+IFQzExTa65nA0/f4X0nyU/wBDWz+iIbK1IkF+A0MydItYVQcLhe+aX9axgA7v4CkLL4+J/Ad8oezLldyzb9hYg=
X-Received: by 2002:a05:6122:20ac:b0:525:9dd5:d55a with SMTP id
 71dfb90a1353d-527730a9b14mr8923640e0c.8.1744126551943; Tue, 08 Apr 2025
 08:35:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250408104851.256868745@linuxfoundation.org>
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 8 Apr 2025 21:05:39 +0530
X-Gm-Features: ATxdqUE5K9Dlr_XtGSCpzfXdBhhJtN7jxVeLpGfJQfW41WarrWU_eZhxEWZq6W4
Message-ID: <CA+G9fYuzqN6BjRx3XTAC87qviZWMLzOX70KfJvXEX772ZHDZzQ@mail.gmail.com>
Subject: Re: [PATCH 6.13 000/499] 6.13.11-rc1 review
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

On Tue, 8 Apr 2025 at 17:41, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.13.11 release.
> There are 499 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Apr 2025 10:47:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.13.11-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.13.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Regressions on arm multi_v5_defconfig and tinyconfig builds with clang-20
and gcc-13 on the stable-rc 6.13.

First seen on the 6.13.11-rc1
Bad: 6.13.11-rc1
Good: v6.13.10

* arm, build
 - build/gcc-13-tinyconfig
 - build/clang-20-tinyconfig
 - build/clang-20-multi_v5_defconfig

Regression Analysis:
- New regression? Yes
- Reproducibility? Yes

Build regression: arm ld.lld vmlinux.lds section pattern is expected

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>


## Build log
with clang-20
ld.lld: error: ./arch/arm/kernel/vmlinux.lds:33: section pattern is expecte=
d
>>>  __vectors_lma =3D .; OVERLAY 0xffff0000 : AT(__vectors_lma) { .vectors=
 { OVERLAY_KEEP(*(.vectors)) } .vectors.bhb.loop8 { OVERLAY_KEEP(*(.vectors=
.bhb.loop8)) } .vectors.bhb.bpiall { OVERLAY_KEEP(*(.vectors.bhb.bpiall)) }=
 } __vectors_start =3D LOADADDR(.vectors); __vectors_end =3D LOADADDR(.vect=
ors) + SIZEOF(.vectors); __vectors_bhb_loop8_start =3D LOADADDR(.vectors.bh=
b.loop8); __vectors_bhb_loop8_end =3D LOADADDR(.vectors.bhb.loop8) + SIZEOF=
(.vectors.bhb.loop8); __vectors_bhb_bpiall_start =3D LOADADDR(.vectors.bhb.=
bpiall); __vectors_bhb_bpiall_end =3D LOADADDR(.vectors.bhb.bpiall) + SIZEO=
F(.vectors.bhb.bpiall); . =3D __vectors_lma + SIZEOF(.vectors) + SIZEOF(.ve=
ctors.bhb.loop8) + SIZEOF(.vectors.bhb.bpiall); __stubs_lma =3D .; .stubs A=
DDR(.vectors) + 0x1000 : AT(__stubs_lma) { *(.stubs) } __stubs_start =3D LO=
ADADDR(.stubs); __stubs_end =3D LOADADDR(.stubs) + SIZEOF(.stubs); . =3D __=
stubs_lma + SIZEOF(.stubs); PROVIDE(vector_fiq_offset =3D vector_fiq - ADDR=
(.vectors));
>>>                                                                        =
               ^
make[3]: *** [/builds/linux/scripts/Makefile.vmlinux:77: vmlinux] Error 1

and
With gcc-13
arm-linux-gnueabihf-ld:./arch/arm/kernel/vmlinux.lds:30: syntax error
make[3]: *** [/builds/linux/scripts/Makefile.vmlinux:77: vmlinux] Error 1

## Source
* Kernel version: 6.13.11-rc1
* Git tree: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
* Git sha: f1209ffbc87a3003d66f47bd6f986d1a0d154a2f
* Git describe: v6.13.10-500-gf1209ffbc87a
* Project details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.13.y/build/v6.13=
.10-500-gf1209ffbc87a/

## Build
* Build log: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.13.=
y/build/v6.13.10-500-gf1209ffbc87a/testrun/27947363/suite/build/test/clang-=
20-tinyconfig/log
* Build details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.13.y/build/v6.13=
.10-500-gf1209ffbc87a/testrun/27947363/suite/build/test/clang-20-tinyconfig=
/details/
* Build history:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.13.y/build/v6.13=
.10-500-gf1209ffbc87a/testrun/27947363/suite/build/test/clang-20-tinyconfig=
/history/
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2vRlYe=
E7ChBo7YMjumm63mifyB9/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2vRlYeE7ChBo7YMjumm6=
3mifyB9/config

## Steps to reproduce
 - tuxmake --runtime podman --target-arch arm --toolchain gcc-13
--kconfig tinyconfig

--
Linaro LKFT
https://lkft.linaro.org
