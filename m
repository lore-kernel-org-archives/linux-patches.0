Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2EEA20DC4
	for <patches@lists.linux.dev>; Mon, 10 Jun 2024 07:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.153.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718004424; cv=none; b=b+P/fsecxRp2PEb0skb+crLcketJcgIds66k6vbq2IlQy6+vQy7OknIfSjuqE6SoWo66nw+KtuyYwgfrodw3UNLW6d/hXw9p/WhmHYgZHqJM65iGsspUdCAdeHlmHwst00oGLpX38A87f+OR1S/AxzF5p60hbLvupr4DvmIvK7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718004424; c=relaxed/simple;
	bh=Mu02qpIIbfNkG1vbaf0sAHbryalLvngOKjtH5xhgksw=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YxPYvH4hTjoSOYmfpZNibp8fKfrPVu+RXpz8PCDaHGLOqP98LKRvcldddn6oku7Kks8m3uqp2C19XUYp3goDfz5l0vGyLdrsy4XC/prMUUHzhNBdRYx7A9xKunD1NsP1sha3s75H4d+kZ+IZEz94t9lOmZWFwOuT5iVxqSCpg8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=IBa09ED6; arc=none smtp.client-ip=68.232.153.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="IBa09ED6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1718004422; x=1749540422;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Mu02qpIIbfNkG1vbaf0sAHbryalLvngOKjtH5xhgksw=;
  b=IBa09ED69HbWvD8kYj+u2BV+m3PBjji/Dhxht9XiSzp7AyhuLFC8nx8u
   q/gfiJQG5JKiAV8MJLI+XKOm4NxdtAjMQ8aQU18u6OGjr6trGK0N8l4Qw
   NIo8y8dd8kbcnWJjVkIX1z990UFOiCtnFNHG5SRMwFhhWKU64JGSSbXp3
   e+B40XSIxIzugwQ+ui0lYA+wybLunquXofgF20rk0UaTqCJ+ZbkKxq+8k
   JiDzh94AMrwaVhU68ff0SYTEAbTUgAGeRnRHviIhUxM+V9vOxnbIqlCnx
   4rhIv1/pqly1hcEZEqA+pu9wg4ls6482CVaIxW58OvyUzx0JbiZgh8b1T
   w==;
X-CSE-ConnectionGUID: aKKn8iM9RcKRRp1DVAyuvA==
X-CSE-MsgGUID: nXZf35A9SZCeXNvA4tGZZA==
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="asc'?scan'208";a="29616402"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Jun 2024 00:26:55 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 10 Jun 2024 00:26:31 -0700
Received: from wendy (10.10.85.11) by chn-vm-ex04.mchp-main.com (10.10.85.152)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35 via Frontend
 Transport; Mon, 10 Jun 2024 00:26:27 -0700
Date: Mon, 10 Jun 2024 08:26:10 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Ron Economos <re@w6rz.net>, Pavel Machek <pavel@denx.de>,
	<stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>, <conor@kernel.org>,
	<allen.lkml@gmail.com>, <broonie@kernel.org>
Subject: Re: [PATCH 6.6 000/741] 6.6.33-rc2 review
Message-ID: <20240610-scabby-bruising-110970760c41@wendy>
References: <20240609113903.732882729@linuxfoundation.org>
 <ZmYDquU9rsJ2HG9g@duo.ucw.cz>
 <ad13afda-6d20-fa88-ae7f-c1a69b1f5a40@w6rz.net>
 <2024061006-overdress-outburst-36ae@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="3sEirYnTij6UVj1H"
Content-Disposition: inline
In-Reply-To: <2024061006-overdress-outburst-36ae@gregkh>

--3sEirYnTij6UVj1H
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 10, 2024 at 08:28:29AM +0200, Greg Kroah-Hartman wrote:
> On Sun, Jun 09, 2024 at 11:21:55PM -0700, Ron Economos wrote:
> > On 6/9/24 12:34 PM, Pavel Machek wrote:
> > > Hi!
> > >=20
> > > > This is the start of the stable review cycle for the 6.6.33 release.
> > > > There are 741 patches in this series, all will be posted as a respo=
nse
> > > > to this one.  If anyone has any issues with these being applied, pl=
ease
> > > > let me know.
> > > 6.6 seems to have build problem on risc-v:

> > > arch/riscv/kernel/suspend.c:14:66: error: 'RISCV_ISA_EXT_XLINUXENVCFG=
' undeclared (first use in this function); did you mean 'RISCV_ISA_EXT_ZIFE=
NCEI'?
> > > 694
> > >     14 |         if (riscv_cpu_has_extension_unlikely(smp_processor_i=
d(), RISCV_ISA_EXT_XLINUXENVCFG))
> > > 695
> > >        |                                                             =
     ^~~~~~~~~~~~~~~~~~~~~~~~~~
> > > 696
> > >        |                                                             =
     RISCV_ISA_EXT_ZIFENCEI

> > > https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/=
7053222239
> > > https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipel=
ines/1324369118
> > >=20
> > > No problems detected on 6.8-stable and 6.1-stable.
> > >=20
> > > Best regards,
> > > 								Pavel
> >=20
> > I'm seeing the same thing here. Somehow some extra patches got slipped =
in
> > between rc1 and rc2. The new patches for RISC-V are:
> >=20
> > Samuel Holland <samuel.holland@sifive.com>
> > =A0=A0=A0 riscv: Save/restore envcfg CSR during CPU suspend
> >=20
> > commit 88b55a586b87994a33e0285c9e8881485e9b77ea
> >=20
> > Samuel Holland <samuel.holland@sifive.com>
> > =A0=A0=A0 riscv: Fix enabling cbo.zero when running in M-mode
> >=20
> > commit 8c6e096cf527d65e693bfbf00aa6791149c58552
> >=20
> > The first patch "riscv: Save/restore envcfg CSR during CPU suspend" cau=
ses
> > the build failure.
> >=20
> >=20
>=20
> Yes, these were added because they were marked as fixes for other
> commits in the series.  I'll unwind them all now as something is going
> wrong...

Really we should just backport this envcfg handling to stable, this
isn't the first (and won't be the last) issue it'll cause. I'll put a
backport of it on my todo list cos I think last time around it couldn't
be cherrypicked.

--3sEirYnTij6UVj1H
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZmaqiAAKCRB4tDGHoIJi
0v/WAQDveEGWwbePRnhY+zpzcHGsw8ZJVBW810S772hDtK6M3QEAnnXgHNrdAxGI
bzwJhDTRC5Sy/lVa+xNSucV0bsGx8wQ=
=bZeV
-----END PGP SIGNATURE-----

--3sEirYnTij6UVj1H--
