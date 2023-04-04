Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8257C
	for <patches@lists.linux.dev>; Tue,  4 Apr 2023 10:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1680605538; x=1712141538;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pX0g5xweg8C2mVbKyqhWztK1Mf/XSGZ0k+3Bgdaq5Ts=;
  b=mRrZaBoQ2VPNU3rm25YNLMLMS70OeAbCtxWHbjBy771SnTV4QvFrBmOW
   Qqc9Lv6es5Nxy9LAlhpmLdB2LjyVO7bhE43Svm21+6qUGWXYWm1OmTmeA
   7hD4t3RnM+vshK53ZB3L9doB9LM0YOk3XDHY9kFTg7FKJ1lpjDrWwQGZL
   dFupC/GHo8queSLsJ+mtl03s+nJKVyDDaz6ndj2jxGe4PVya8/kBDnylF
   VkDbRCiJGKqLVP1YztbLVQHSbgXxPkPPSCO5xx31FxR/Nys0bizRMdblI
   cjno+wU4m48Ci+xjnHk8RdQBN4Ofoc85xqSbXw7kmLi+3O6b+UjHv+4Tn
   Q==;
X-IronPort-AV: E=Sophos;i="5.98,317,1673938800"; 
   d="asc'?scan'208";a="208763109"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Apr 2023 03:52:13 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 4 Apr 2023 03:52:08 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Tue, 4 Apr 2023 03:52:05 -0700
Date: Tue, 4 Apr 2023 11:51:51 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>
Subject: Re: [PATCH 6.1 000/181] 6.1.23-rc1 review
Message-ID: <20230404-4e22a0dc0fff4925c669a4c3@wendy>
References: <20230403140415.090615502@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="tvZ8Eb5ln00blsXj"
Content-Disposition: inline
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>

--tvZ8Eb5ln00blsXj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 03, 2023 at 04:07:15PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.23 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.

On our RISC-V stuff, looks as per usual.
Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--tvZ8Eb5ln00blsXj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZCwBRwAKCRB4tDGHoIJi
0oQFAPkB1KDMJ5h0lxly4c/fc2xc7JxEZT2e3CYFPrdjpjtpqQD/XtMHEoGPmx3a
yuU53n5EoHejeQrIVmPdXckUsDnD9wM=
=bPih
-----END PGP SIGNATURE-----

--tvZ8Eb5ln00blsXj--
