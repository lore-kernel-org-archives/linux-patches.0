Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5022C841
	for <patches@lists.linux.dev>; Mon, 15 Jan 2024 12:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="Q65oHXg9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1705321298; x=1736857298;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NmerN+FsQfAGKw2XEAlxE+nSV6QgCM6XG0MoKmZuRmY=;
  b=Q65oHXg9YBU6eUI2EhYmXa13soWyWjG4bAcJpm52X/LLagy/DTrA/uXa
   aeyHT/5AxJQN3/Ow72NPGiZ6CC/od72reZqIx2FMpIJCOYqjCoW542ySm
   n0gmHFyjgrqVXo83gr5F2hDCcwyb2nZdo5P7aDyLRxq7K8Mcz1kFtpIWa
   /y7rSWEGBU4SX4jsIb/vSE//2n0IdG6YL7BASbqVGXicqu4htn1+dTK5L
   Lo1q0S0GUqgrZ5JOR+F/BIMzpItM38me9slR54Jf3lucBMTWIQpcnZdhf
   eeYYbJRf+YMC5eCtPD6V30A2EgHgl24AfsDjbEdJxN2xph79F6u40bHU0
   A==;
X-CSE-ConnectionGUID: b/ojaXNaRVWYdyjNmH4+Bg==
X-CSE-MsgGUID: rZyKQicHSvS4ShB1vJeYAA==
X-IronPort-AV: E=Sophos;i="6.04,196,1695711600"; 
   d="asc'?scan'208";a="14773083"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 15 Jan 2024 05:21:31 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 15 Jan 2024 05:21:28 -0700
Received: from wendy (10.10.85.11) by chn-vm-ex04.mchp-main.com (10.10.85.152)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35 via Frontend
 Transport; Mon, 15 Jan 2024 05:21:24 -0700
Date: Mon, 15 Jan 2024 12:20:48 +0000
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>, <conor@kernel.org>,
	<allen.lkml@gmail.com>
Subject: Re: [PATCH 6.6 0/1] 6.6.12-rc1 review
Message-ID: <20240115-customary-unlawful-73aa6e7309ee@wendy>
References: <20240113094204.275569789@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="UgufqFzkZ1oKHsCJ"
Content-Disposition: inline
In-Reply-To: <20240113094204.275569789@linuxfoundation.org>

--UgufqFzkZ1oKHsCJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 13, 2024 at 10:50:58AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.12 release.
> There are 1 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Mon, 15 Jan 2024 09:41:55 +0000.
> Anything received after that time might be too late.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Cheers,
Conor.


--UgufqFzkZ1oKHsCJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZaUjIAAKCRB4tDGHoIJi
0s7PAQDj4a5GMLgngpe0jhQVIGx/bivNTkWHxLOSGdF0swgIAgEAt+WOQtQdytZS
XvTZv874vdI7QyL69aKYhLb2NFdOmgk=
=3cRL
-----END PGP SIGNATURE-----

--UgufqFzkZ1oKHsCJ--
