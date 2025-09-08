Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 046E61FDA
	for <patches@lists.linux.dev>; Mon,  8 Sep 2025 18:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757355910; cv=none; b=YW6nrn5uuY8xzB1Dy9MVlyhlQk+r/qsf/LKNa1uEvP0n4Fj9/lUdDQa2kuSRjV2cUf76gZ2DLbOzIcKjzarfLOD8CfHCcgK6LYQ++Ke2/EKkU8vLxBfeLzrcoUIAEIc3OcVqpr1SueQcB/J5Rh2v2SQ6jZmmvcB8M8bQGIBLgno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757355910; c=relaxed/simple;
	bh=GU4hHeFvwVnk7kq2RXY5Xg8cjjx6Qu6aF+dHzVCs+uk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Cwd5qMwh+T54OyKn0NkI09ROLuO9R0PLdmW8RNIm5RvL6G3GgSK17es0mDqxv3VEnlrOI65SYu4/+T2JklP4GlwNzvJXRUy4QBoXbQP8dlQT7Mw2gEGKBx6NTgBmHCyTTRPpyeTsCpT3Ehu3VMsMDQwQY/1ACGvMJ5RdYDy/B9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=rf/2Z2YW; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rf/2Z2YW"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b520c9c291dso2818812a12.1
        for <patches@lists.linux.dev>; Mon, 08 Sep 2025 11:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1757355908; x=1757960708; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9IWBcug01b4npQiJZok8CrAZHtpv3BYuhLyiOQ73LoE=;
        b=rf/2Z2YWvyUofemuPB+ddIu2W7MZv6rlBN+94brr1sub7u1xwi5TJhoMfPs5oi5Mgf
         qb2O7lZYpbjlBAGEBR4xoNofIuesYGrUGIAA0CSkuLSimQ+K5vCGRtJ17jyESTm4iawS
         aBVnsbZGlZzK8iPev3rm7z86+zb8ZXsogMKrG5/zbk92SGWi1JRIQx04ACj1vbEAXKFP
         Rj0Q2ZnuFfzjBgwQlU7l82OWYcH5ES9WnFkEq3llcO6hmA8ou5g+3NFV4yWVWzNL1b9h
         yhQrwNVnlR2/KPSaYEDMDKKK60GD1NpOEQBVAARcU7mFfm6ZeNgQE2BlfOXr10MTwr2F
         eBQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757355908; x=1757960708;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9IWBcug01b4npQiJZok8CrAZHtpv3BYuhLyiOQ73LoE=;
        b=uBHUzK0GRwCBd8VXWogRsIaHJiQz0zLYaxpIW2/nqVPan1xmnihXKsEjKib4qGnmZL
         gH4QJ5iaJBOrXdS4EcQHrguzfG/YEnTt58gaw/9lOBPNoXYEWKi08vOvh0AEUGP40oim
         n+tWeNw+qMfDfA5F+m8N09S+fuP16z7jrkuu/bo4ZwRVleR3Eoa1hvdzenXq7JRsJ/NJ
         yfsQmpKE07RhFsizBvuHA/2cGtut7rXWgBKTF6EbK3MZCX0hM1bKPtcbarqhYxqLYL5E
         aXRLNU+SYtV74A72mlG15H68Qeb/eqkQtDtDZripD6D5722xTX5wLhYGYFIHf9M3Rqgb
         w/5Q==
X-Forwarded-Encrypted: i=1; AJvYcCX0/nHLgtdI7qx+zg7BaqgaAHE2vu24kpWPQw1L4ZppaWU5P5gUUvb55TSJCLwUM9IVvkH1/VRH@lists.linux.dev
X-Gm-Message-State: AOJu0YyMeWCcu1K2uJurDkb8OXWkBtZcu3VO+RzhEGwTmLQLTGvhXvWS
	dwX/6ge3ScxcNvp6bclvmX7spzbRiFoBXNTWppVb/Em7BFGCpaXtoi9ScYWwZPuvWqOzOkpe2Sz
	tgEbhmTXIrGZXlfS0HreRByaDUpfMiAfVOCF1djpDfg==
X-Gm-Gg: ASbGnct5Ur3umT5uIASSinkjRNfNBEoryKrGCZ2TZLHIof0FbljAxl0ruFLNJXzsRiX
	Zd969yUWyQLMlCp7TgXmtj0hOQ1CRdzZY2cScisv/Pga9xqqxtE1iaeDs/DASSKiIanKLzeGBI2
	VpIbhm9QYs5IluYsNBf5ZtXMC1Ra0GcnBNiZ7riWZQz1vgkAYEPGNsr/dtBvUv87ZC/QCPiiZyg
	8HSw1f3YtWTbG8Lcuu/mswTKv0zeDaFxqIykBWfvIRRv+yVuIQXwzN8Eg8y2gPihJbBNdRedFVL
	ZgEeydJoubY74WOhrA==
X-Google-Smtp-Source: AGHT+IHj9/tnJHkNQasTrRWqFjaqKqLyMbw17kMKkgYlBrWWXZgHdvHNrG+sKdBSH0wLKK9FFJY53g7/1x/HEEkUnRM=
X-Received: by 2002:a17:90b:3806:b0:327:dc81:b39e with SMTP id
 98e67ed59e1d1-32d43f1891amr10097489a91.13.1757355908088; Mon, 08 Sep 2025
 11:25:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250907195603.394640159@linuxfoundation.org>
In-Reply-To: <20250907195603.394640159@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Mon, 8 Sep 2025 23:54:56 +0530
X-Gm-Features: AS18NWD9pYZXIPgJSNXVjAumK8DAoDrS_GW9AD1G0s-Kl9qADSuGItB5Vl0yLJY
Message-ID: <CA+G9fYvQw_pdKz73GRytQas+ysZzRRu7u3dRHMcOhutvcE4rHA@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/64] 5.15.192-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, 
	Anders Roxell <anders.roxell@linaro.org>, Arnd Bergmann <arnd@arndb.de>, 
	Dan Carpenter <dan.carpenter@linaro.org>, "David S. Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Ben Copeland <benjamin.copeland@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 8 Sept 2025 at 01:43, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.192 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.192-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

While building Linux stable-rc 5.15.192-rc1 the arm64 allyesconfig
builds failed.

* arm64, build
  - gcc-12-allyesconfig

Regression Analysis:
- New regression? yes
- Reproducibility? yes

Build regression: stable-rc 5.15.192-rc1 arm64 allyesconfig
qede_main.c:199:35: error: initialization of void from incompatible
pointer

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

### build log
drivers/net/ethernet/qlogic/qede/qede_main.c:199:35: error:
initialization of 'void (*)(void *, u16,  u16)' {aka 'void (*)(void *,
short unsigned int,  short unsigned int)'} from incompatible pointer
type 'void (*)(void *, void *, u8)' {aka 'void (*)(void *, void *,
unsigned char)'} [-Werror=3Dincompatible-pointer-types]
  199 |                 .arfs_filter_op =3D qede_arfs_filter_op,
      |                                   ^~~~~~~~~~~~~~~~~~~

This was reported on the Linux next-20250428 tag,
https://lore.kernel.org/all/CA+G9fYs+7-Jut2PM1Z8fXOkBaBuGt0WwTUvU=3D4cu2O8i=
QdwUYw@mail.gmail.com/

## Build
* kernel: 5.15.192-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: ccdfe77d4229628515f4f822400fe6414b9861f8
* git describe: v5.15.190-99-gccdfe77d4229
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.190-99-gccdfe77d4229

## Test Regressions (compared to v5.15.190-34-g29918c0c5b35)
* arm64, build
  - gcc-12-allyesconfig

Build log: https://qa-reports.linaro.org/api/testruns/29791503/log_file/
Build details: https://regressions.linaro.org/lkft/linux-stable-rc-linux-5.=
15.y/v5.15.190-99-gccdfe77d4229/log-parser-build-gcc/gcc-compiler-drivers_n=
et_ethernet_qlogic_qede_qede_main_c-error-initialization-of-void-void-u-u-f=
rom-incompatible-pointer-type-void-void-void-u/
Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/32O3I8js=
bRRLOu0azhrfBwOPAjC/
Build config: https://storage.tuxsuite.com/public/linaro/lkft/builds/32O3I8=
jsbRRLOu0azhrfBwOPAjC/config

--
Linaro LKFT
https://lkft.linaro.org
