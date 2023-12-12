Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3EF73164
	for <patches@lists.linux.dev>; Tue, 12 Dec 2023 14:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="wMwKNVVe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1702389802; x=1733925802;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UVHpXI7b7Cqzw9GQbfj+mMYjiVhCSDT4YIHqX78b+Qk=;
  b=wMwKNVVeWC10Hoz7hmvhRaIfkUCMCuGEvPiG9wiAa0DlembINDZicSIx
   BShjLE5itGd+tg3pytgHhNi6z6ymdhhckaHWFqdKXi5l+jjFQgk9sAHOi
   xoUQSMUcyS8O3+vTmPWlg0WbB6r1gtaAc9w/ARZ6JKHgPFrWW+qBt4zcd
   1cZrB74y7vKOjoPHo/R24CMfg8IEQmv4BFeHZFTQLQmItTdNFkx0o2+FR
   +YZghPLDK3XFWvILGsjgv6eXpNBP9QHTBrvtCcoQER4DtVYCmgbX+mACU
   arJ1eSxPEa+Wu2SZDhnn2aa+a3VCUuMKsd1hO0LiSEtsgHxsWDjKnm4XR
   g==;
X-CSE-ConnectionGUID: auzFoytcSquwQ2QGZYNNCA==
X-CSE-MsgGUID: Lm8nqWImQZ6zNCJcSgwaaQ==
X-ThreatScanner-Verdict: Negative
X-IronPort-AV: E=Sophos;i="6.04,270,1695711600"; 
   d="asc'?scan'208";a="180359046"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Dec 2023 07:03:12 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 12 Dec 2023 07:03:04 -0700
Received: from wendy (10.10.85.11) by chn-vm-ex02.mchp-main.com (10.10.85.144)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35 via Frontend
 Transport; Tue, 12 Dec 2023 07:03:00 -0700
Date: Tue, 12 Dec 2023 14:02:29 +0000
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>, <conor@kernel.org>,
	<allen.lkml@gmail.com>
Subject: Re: [PATCH 6.1 000/194] 6.1.68-rc1 review
Message-ID: <20231212-entertain-handshake-faad98b5651d@wendy>
References: <20231211182036.606660304@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="nl3lVUkkTkafY4QQ"
Content-Disposition: inline
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>

--nl3lVUkkTkafY4QQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 11, 2023 at 07:19:50PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.68 release.
> There are 194 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Cheers,
Conor.

--nl3lVUkkTkafY4QQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZXhn9QAKCRB4tDGHoIJi
0quGAP4gFrJmjNRPU/E8jiizYKirLQL+M3HxudtRSDBExIsB2AEAyk/NV/0ovB8U
QAPJkcqUt7OOE3F+kk1DOJ6kdDrvngs=
=U761
-----END PGP SIGNATURE-----

--nl3lVUkkTkafY4QQ--
