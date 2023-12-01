Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E811A21A19
	for <patches@lists.linux.dev>; Fri,  1 Dec 2023 13:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="o82Ss+R9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1701436948; x=1732972948;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SFiMiObX9ZGFEyE4h8oReM51+m2Od7/qLb1KYhjjjLg=;
  b=o82Ss+R9h9t0PlA+0HiCKrg3L2kgFPpa3XMtMK3GthztDhWC3VkKLyg8
   zyWEQrnycfzQhYnPkNRMM0lnXBXvIDybBOHYqOaOoG3AXqjSw4BgEpEii
   erqbjPdOVjxV3VLJzNPkyorx14aAGxJ/s6/3ijhulIqDQ1s5VM4JrXCzP
   7Hgss9968GvOr815+bWL96UhsdAcD02xXZvUuV4IgMjjlfz9ge12xeTpm
   6JvkgUKHEIer7PNQdbejrfsavmVcPjoYMkVI+T7aJPb0yctcXIuf97Jbc
   RPAT0ZU/eLXccMLLSpsJ9lWRYmPvDtxCrJfAR/aFcCUDZ+okpR3KRjt/J
   A==;
X-CSE-ConnectionGUID: h4Jrgyr3T9i1kHEvfFr0NQ==
X-CSE-MsgGUID: QYF4eAE9TJCZvZov9yd8ew==
X-ThreatScanner-Verdict: Negative
X-IronPort-AV: E=Sophos;i="6.04,241,1695711600"; 
   d="asc'?scan'208";a="179742437"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 01 Dec 2023 06:22:22 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 1 Dec 2023 06:22:00 -0700
Received: from wendy (10.10.85.11) by chn-vm-ex03.mchp-main.com (10.10.85.151)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35 via Frontend
 Transport; Fri, 1 Dec 2023 06:21:57 -0700
Date: Fri, 1 Dec 2023 13:21:28 +0000
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>, <conor@kernel.org>,
	<allen.lkml@gmail.com>
Subject: Re: [PATCH 6.6 000/112] 6.6.4-rc1 review
Message-ID: <20231201-prize-deck-be172f77a4bb@wendy>
References: <20231130162140.298098091@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="CGVL03bvG34QNHYM"
Content-Disposition: inline
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>

--CGVL03bvG34QNHYM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 30, 2023 at 04:20:47PM +0000, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.4 release.
> There are 112 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sat, 02 Dec 2023 16:21:18 +0000.
> Anything received after that time might be too late.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Cheers,
Conor.

--CGVL03bvG34QNHYM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZWnd2AAKCRB4tDGHoIJi
0uO2AQDgaoRRvbNVU+L0vVmYKaIMArJIz6JH3K0QDUdd7M77KwD+O2iYvcBIwEeb
zZl1lG7BTtD04V/w8ec46x9ppu093wc=
=vWEC
-----END PGP SIGNATURE-----

--CGVL03bvG34QNHYM--
