Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34AEFC01
	for <patches@lists.linux.dev>; Tue, 20 Jun 2023 10:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1687258489; x=1718794489;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6c60X4ktkiqryPjhR2YrFgEi5A5JvrABnKX4YWhKjkk=;
  b=owvkWZL8G5iBuPpVh1BvF6vgULrth5x6ilh3nkAnVZ6UZbRHN3edayJ0
   dmUsTykXWKlfXs6n9/gfZ/tmjhETLQJTgRmWrTG9K51itW7bCg+wS/q89
   J9/EwNJSUCAKSGLgGHJPVKRRFvFDo/4brL6WHc8BMYAPlU7iNXNhGl1S4
   2qfiHu8tE8ib98yENYQXpyJwMI5Pf7kVTKZJzRZmUtEZyA/8tIgKhwbcx
   vmmBOp5qKeM5FePyvRhv1lnd55IdClHJa+toGrzbrNVkc/1gBZJQlCkl8
   SRIoaM4e1DS8Zxpu+/idw2QV/WJU93OmzAevjRkywLU9Pr1IGk6zrHBgx
   w==;
X-IronPort-AV: E=Sophos;i="6.00,256,1681196400"; 
   d="asc'?scan'208";a="216812277"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Jun 2023 03:54:41 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 20 Jun 2023 03:54:03 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Tue, 20 Jun 2023 03:54:01 -0700
Date: Tue, 20 Jun 2023 11:53:34 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>
Subject: Re: [PATCH 6.3 000/187] 6.3.9-rc1 review
Message-ID: <20230620-squirt-ungloved-2ecf9b269e25@wendy>
References: <20230619102157.579823843@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ajQMbeLtm/3tD0sS"
Content-Disposition: inline
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>

--ajQMbeLtm/3tD0sS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 19, 2023 at 12:26:58PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.9 release.
> There are 187 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Cheers,
Conor.

--ajQMbeLtm/3tD0sS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZJGFLgAKCRB4tDGHoIJi
0sQWAPsFMcHjF/dOHgOA1emiRsTmHZYpSVpLD33CxSOm/vBM0gD9E89QUl1wpn8e
lcgmMF6v8YS1Mf8+fzH7v1ARMrpl9gc=
=pMl0
-----END PGP SIGNATURE-----

--ajQMbeLtm/3tD0sS--
