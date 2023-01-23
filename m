Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0011DA21
	for <patches@lists.linux.dev>; Mon, 23 Jan 2023 08:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674461057; x=1705997057;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=CXt4xHUGCEc11v2dBCdYnBfm6ITSIKvpYk+Zn/u7vWM=;
  b=s4yWx0FAEKMkGif/KraHHmy6mtzTYoN7ZjqMAjCnKdRw004s45oRxa+o
   BZ2rmc2J7X09V8rTOR++eYHofYqSbKrysCAApA8vTwl7qoM8e8jHYgWrs
   MjotAYmoT9g7YNs1f/J3hbMhGD3kisbWqi+dvmTZLY2xSnX8eIR8zlLX5
   ANHnAfCSFWnwAF1BGP0QZ013Ifxr9e/tXs8UEzDV6wuf+27crv6SSmX5A
   lDMhAVfykHsvI0LQ/iHlFEDVyqg9fRU/XUhaYinu2N4w+etc+IBze+g4z
   PV3pS9gRJ4JYt75Jg3TCrb6VIN/K/QPSRmSXnbVn0GhpnkVjFOSZEL49l
   A==;
X-IronPort-AV: E=Sophos;i="5.97,239,1669100400"; 
   d="asc'?scan'208";a="193408657"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Jan 2023 01:04:08 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 23 Jan 2023 01:04:04 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16 via Frontend
 Transport; Mon, 23 Jan 2023 01:04:02 -0700
Date: Mon, 23 Jan 2023 08:03:38 +0000
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>
Subject: Re: [PATCH 6.1 000/193] 6.1.8-rc1 review
Message-ID: <Y84/WnTNfDibXSy7@wendy>
References: <20230122150246.321043584@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="+15ijdafIi6o+7kF"
Content-Disposition: inline
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>

--+15ijdafIi6o+7kF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Greg,

On Sun, Jan 22, 2023 at 04:02:09PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.8 release.
> There are 193 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Tue, 24 Jan 2023 15:02:08 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.8-r=
c1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-6.1.y
> and the diffstat can be found below.

For our RISC-V stuff, LGTM.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.


--+15ijdafIi6o+7kF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY84/SQAKCRB4tDGHoIJi
0sKnAQD5dGnbA0TVPGkUxviLq0FRQFKxiLgUSO5FogKv3mmv6gD+Jo3zYWpLTKPZ
8ZUcTtmNWVh2/Fe2kDVBdmeGDqYA8Ag=
=ryn4
-----END PGP SIGNATURE-----

--+15ijdafIi6o+7kF--
