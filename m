Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0464D3672AE
	for <patches@lists.linux.dev>; Tue, 12 May 2026 22:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778626530; cv=pass; b=d3hxc5DxLZcjzkzpwgJIZwcW6+2BfIjeNWQRwnMkGZXEYxk+PQGdg1yx9GZRNl6lRddfCZiTP0MQzCRaw8Un348pAMPJhGb386kogpLPe/VFmkE4RwM22/6N0fP7UXd6ffYXDOg22NLcpjRyOV/0n/bC3g1D3hvYTW11STSHxS4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778626530; c=relaxed/simple;
	bh=S/8xYr2qBUJROI9hkbGruR/a0izB/rCJKi4uVl1GFdk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VFQFpq9MMAjrIQmHxxdkGzQBYWRGGjpo9n+DqIc3S5kfnBQVCMef+ygBmVK4dY85KmVwUohPVKHZPWqg1EiSMLssNGrP6jCzgDXfIFVUriYgozmo4GyGz+Gx1sMlrlfL3dvZzDURbSIAZjtkZStcsej7xLMJ7VruAE9bWL6k51o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=Z1HI3K34; arc=pass smtp.client-ip=74.125.82.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="Z1HI3K34"
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-1330d6bb78dso2723937c88.1
        for <patches@lists.linux.dev>; Tue, 12 May 2026 15:55:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778626528; cv=none;
        d=google.com; s=arc-20240605;
        b=dMRpnlnFjSrHABqoUoPmgtcnECmp+hghm2yyqSArCCQd4WKPUCIsWl3tfYmqugoLVI
         d1QKPhDNc+LZQGDj4J8ZVsXoKlyJaPTHq7HhPOjRKvpzPWfA2tMH61CyOtYGIoEvYxo+
         GP9lUmX/KUW+nzEGbBAgu87moOmOT4EydZVy9xOkZMc9N8E1Afx3devtUEQeI+0TrMcl
         SA34EMkruN+7ksEY1gDvsQxFFMqlOyUwx2Ju8RD66jrDsL1aOtDB9FnBItcVclsBguj6
         tKtkq0z0fYPQfBTlnd/uYr+A2DHtuB09246Xusi9wFRVdw9Xgsc1mONGsa3nJq6NXMPF
         Yirw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=osP2QW83srUvnh83MA3e0QzljFt7mZWU8/KmTxKofhA=;
        fh=3Oxf6Gfh3TtaPAi76bmdl9m+XJwIjk2d2xGYHHPsEBA=;
        b=HWyIT4WWC2DZMGiyCyGxqKpMXGyyRWVzg2+3x11DtvYhWC0oNz87ySgn9Lv+9mLy73
         d2WHc0UhuULtP6RzihG6HHq5C0n5FM3PjtWTwLob7ah8igdIajoZUXG4821tMSWPqjB8
         9vXFG3DI2JaZ+IRkBOdh51QM2hdmCXKdhkcVwwerFwaUFOOEqwvz5dn7i35pLZA9p6mM
         TOOwOe2Ra2QONYLn7DuZ6mdgBGo9gEQR6wbIGB65RkuDpHU/cXEg521COHg7h8Qsgsm+
         fd/A5Fk6hWgxbxj3QQzOiNLjNgh+bJoTIdTnmNJWMirD6ImNMQ1XqxN51gKjYrk8DHqI
         JjOQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1778626528; x=1779231328; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=osP2QW83srUvnh83MA3e0QzljFt7mZWU8/KmTxKofhA=;
        b=Z1HI3K34LXCdjRfOpVdqxHln9RHlmJ64998fOIC0PLLQvs9D7gb9CQ1QRGPAvDtuUz
         NmWj9XynP5QjfzAqS9CJGdMzFuR1ayUI/SvV7KptNsq6Pf5QKwCJRreVZUsfVNneZxVK
         4eKi0u8vdN4y5rWsDzN6w2Wi7yTc+Jk8LWbrLvtIG8SYL1v0+wRLlI18tuVdVhFNNwWq
         I2AtCDNHbKSglL7WcAf7b+5Bj9ecdCvj+QW83T6UjaHfDO90WC+Ps0j6eS8GRSK628al
         IcHbYM2bD503e6drs81EJ5OAKcs0QcgGcHi/s4qtAMrqO41zdyBrvKZoemrHg+YAmu8H
         m8/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778626528; x=1779231328;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=osP2QW83srUvnh83MA3e0QzljFt7mZWU8/KmTxKofhA=;
        b=NI8FUTIDWmGH11lEzA4yw2ASBYUAshZDgxB+YEQLuWM2C9FrKx1Abxhx9hCbjk6nVQ
         jDnF3txeWDPmMsSReaqw+9cjMLfvHTnuGG/tbz4mCLaV16BmrKJYlBnDSbzcTM6r0jcE
         r4DGNitYP0T+7zIlroEOrJAHLxyoxezSQ1xFBefsss6o4sJlF4Ul/yRGYw+v9OpalccZ
         Ln3FQ2b7R6jsxtRKrIvZpGRFUuIPbonPlBfnF//B6gSAtuQp5D6Al4eeRxj5c0sUHUNQ
         spR7t/ghN9/IGobgDI5mhCLwXP824qg4Gh7EqXh4c4hIVFkAXhIG45tWRUP3u0s9HbvW
         j0Ew==
X-Forwarded-Encrypted: i=1; AFNElJ/3vbiPp8RVA+NGkPtKVTpUOukVZm4CNRpaRX2hinpN2hkNSnoABV9Gix7dS7Sb9QeN/dXmnuu3@lists.linux.dev
X-Gm-Message-State: AOJu0YwfoGcGeNwYtRyHcP/3um44jgWE0Ugm40JZ/rTAUXC7KxJ7z+vx
	178mSdoRJIDxzt7UrQhX1OfCsmzhObkNs80IHIYPB6ay13RlGb5gDtQ2hmlEy5/Z3fduf1c0PoX
	ekskhfWmguOJgZn8zod8w4S2g2YZHLw/62cfyzH3Crw==
X-Gm-Gg: Acq92OGROAuCYS9iAq6Enwq8mZLi8p/koaRqMNHSZHbHarVh4uKV5/vcpEuuipaOHX3
	A223sy+Kr2yiIx9PQ2bjlZKlFDHCicLK3jRQzGQ+iwmMfMVqNBz/+mx0WVpEG23SkoTFefP3T3I
	OVtJAwAKRHk33jUhv8dTKjORJToYRAjfjn55xOCa6npYPy9Vte8ysIlBR1zaIxPCMawQN0zcTWu
	eN2bnN6zc1V0SftP59T/6gxuhhpG1B8Ld50kJ/D7cYvS+nvEJDZIqWgUefR2siM6OoDateHsSeL
	ZV6W75/Zc/4KvyvW++U=
X-Received: by 2002:a05:7022:23a3:b0:130:5c90:5a22 with SMTP id
 a92af1059eb24-13439c5c5c2mr479359c88.42.1778626528035; Tue, 12 May 2026
 15:55:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260512173940.117428952@linuxfoundation.org>
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 13 May 2026 07:55:12 +0900
X-Gm-Features: AVHnY4K2KcmH6SMv5nbszxWAJHYCYUuAZUZ1H_5ZyjBhf2SFJveWBXhRVOgr0Es
Message-ID: <CAKL4bV74cBU8twT=QGDUStrYsgu1eDy-s1+D5RJZH2ka+VqGwQ@mail.gmail.com>
Subject: Re: [PATCH 7.0 000/307] 7.0.7-rc1 review
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

Hi Greg

On Wed, May 13, 2026 at 3:15=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.0.7 release.
> There are 307 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 14 May 2026 17:38:03 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.0.7-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Linux version 7.0.7-rc1 tested.

Build error.

Error log (some output is in the native language (Japanese))

  CC      kernel/sched/build_policy.o
In file included from kernel/sched/build_policy.c:62:
kernel/sched/ext.c: =E9=96=A2=E6=95=B0 =E2=80=98bypass_lb_cpu=E2=80=99 =E5=
=86=85:
kernel/sched/ext.c:4019:35: error: =E2=80=98donor_rq=E2=80=99 undeclared (f=
irst use in
this function); did you mean =E2=80=98donee_rq=E2=80=99?
 4019 |                 if (task_rq(p) !=3D donor_rq)
      |                                   ^~~~~~~~
      |                                   donee_rq
kernel/sched/ext.c:4019:35: note: =E6=9C=AA=E5=AE=A3=E8=A8=80=E3=81=AE=E8=
=AD=98=E5=88=A5=E5=AD=90=E3=81=AF=E5=87=BA=E7=8F=BE=E3=81=97=E3=81=9F=E5=90=
=84=E9=96=A2=E6=95=B0=E5=86=85=E3=81=A7=E4=B8=80=E5=9B=9E=E3=81=AE=E3=81=BF=
=E5=A0=B1=E5=91=8A=E3=81=95=E3=82=8C=E3=81=BE=E3=81=99
make[4]: *** [scripts/Makefile.build:289: kernel/sched/build_policy.o] =E3=
=82=A8=E3=83=A9=E3=83=BC 1
make[3]: *** [scripts/Makefile.build:548: kernel/sched] =E3=82=A8=E3=83=A9=
=E3=83=BC 2
make[2]: *** [scripts/Makefile.build:548: kernel] =E3=82=A8=E3=83=A9=E3=83=
=BC 2
make[1]: *** [/home/takeshi/kernelbuild/linux-stable-rc/Makefile:2108: .] =
=E3=82=A8=E3=83=A9=E3=83=BC 2
make: *** [Makefile:248: __sub-make] =E3=82=A8=E3=83=A9=E3=83=BC 2

Following the error log, I corrected line 4019 and tried building
again, and this time the build was successful.
We successfully booted and tested the modified kernel.

Due to time constraints, I omitted the investigation using git bisect,
but the suspected commits are presumed to be the following.
eb5b997dadc51746b5db031be1e9e7c19646c317

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
