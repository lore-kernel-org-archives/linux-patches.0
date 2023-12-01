Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117F61EB5D
	for <patches@lists.linux.dev>; Fri,  1 Dec 2023 11:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="ePMtF47R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1701428561; x=1732964561;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=uYe92/+q2AsWj/XJIkpJZ54l5IPYR4MCNkD/UZeYmWw=;
  b=ePMtF47RqLpZyfOBx/0Vb43+ucrdkkLyl8d0GGwkwt69dpqMiUo+0AXn
   x3gdzGlP5WTPS/QAG2ziZGTfipjhLWI79FFPKvBLqMRBzELmyInX6nLpO
   4elR356iSmU4HEXRprAHZu45OatwBGP6GbW9YcfLKP5scX0dQG8VjsVSz
   JqdvftFHjrt+lZKzZNR5a84V2nlhLzg/U+8EKi9H8kpsgxufX4SAd3d3l
   wuqJCrNhL3xC5OeoOfbOKZkHDPL2/66krtVg9SrLAFprY74NuD/BwgMM7
   GAEHXHQarnoCdVWL1q6LQ8bg8TngyKAhaPaNHZjxxpb/F7QWT5STElJGz
   g==;
X-CSE-ConnectionGUID: 1g/+sIhlTqCL1F9uWMaPeg==
X-CSE-MsgGUID: 1gQ5qdcPRny2WPun9EQ0Lw==
X-ThreatScanner-Verdict: Negative
X-IronPort-AV: E=Sophos;i="6.04,241,1695711600"; 
   d="asc'?scan'208";a="12533231"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 01 Dec 2023 04:02:32 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 1 Dec 2023 04:02:03 -0700
Received: from wendy (10.10.85.11) by chn-vm-ex04.mchp-main.com (10.10.85.152)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35 via Frontend
 Transport; Fri, 1 Dec 2023 04:02:00 -0700
Date: Fri, 1 Dec 2023 11:01:31 +0000
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>, <conor@kernel.org>,
	<allen.lkml@gmail.com>
Subject: Re: [PATCH 6.1 00/82] 6.1.65-rc1 review
Message-ID: <20231201-manicure-annuity-c6f29c460878@wendy>
References: <20231130162135.977485944@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Y1RXsZqWw4Nlr+rB"
Content-Disposition: inline
In-Reply-To: <20231130162135.977485944@linuxfoundation.org>

--Y1RXsZqWw4Nlr+rB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 30, 2023 at 04:21:31PM +0000, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.65 release.
> There are 82 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sat, 02 Dec 2023 16:21:18 +0000.
> Anything received after that time might be too late.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Cheers,
Conor.

--Y1RXsZqWw4Nlr+rB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZWm9CwAKCRB4tDGHoIJi
0ucOAQCTmquaS9c+i69BPOHYxNf+7mGEk40LGA2D6UAabLaK9wD8D8D6SRHMaJZD
79QUsKox/3k+n55zZc7BJV15C4Ielg0=
=Srho
-----END PGP SIGNATURE-----

--Y1RXsZqWw4Nlr+rB--
