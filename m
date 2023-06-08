Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA9E539B
	for <patches@lists.linux.dev>; Thu,  8 Jun 2023 09:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686217481; x=1717753481;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=N8BM0i5rppABoxdZHrQfySlcFcT+hRHiqGkgHCysC3w=;
  b=S7XGAo/QULs01CVM46hUeFryEq8x0hvLwY40VrWGobqEhNF6/3iZzlY4
   LVsSNoz1i7QFLd8Xxu0Lu4FyL2vW3kZuEqvJ00g6txsLHeGIjYSfzYW1b
   3h1ym8U7JeS3OadOO/6ExKZNXUVir1a0xVrx0MaokWQ930Vae+jy8ZBn/
   Qmd6hSvY6MrRW2Yzbxl/wWhynI6YQNdyZZsj/q4m2PVOhvmC/8zJZqEHx
   0N+5jzXpDAEdJif0LKbXMOYO+6AT6mHHDfdl+wAs/Hsy43McHzZC+g2qu
   URQP/t8juSvyCbU9hv3tsZJksaTfYZTD2FRFtaMkIQ57pBuOrrS2FFBJZ
   w==;
X-IronPort-AV: E=Sophos;i="6.00,226,1681196400"; 
   d="asc'?scan'208";a="219398130"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Jun 2023 02:44:38 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 8 Jun 2023 02:44:00 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Thu, 8 Jun 2023 02:43:57 -0700
Date: Thu, 8 Jun 2023 10:43:33 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>
Subject: Re: [PATCH 6.1 000/225] 6.1.33-rc1 review
Message-ID: <20230608-boss-municipal-75220d1158f9@wendy>
References: <20230607200913.334991024@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ZEKmY72Ta3DxAanB"
Content-Disposition: inline
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>

--ZEKmY72Ta3DxAanB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 07, 2023 at 10:13:13PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.33 release.
> There are 225 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

LGTM chief,
Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--ZEKmY72Ta3DxAanB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZIGixQAKCRB4tDGHoIJi
0g4OAP0admz+rz+U1D9Q80IclWoci4XliKC4AEdi2qw1ND5MJgD9FdaHOjJIjp8a
bFi+2tRcU1mZvtECVwFIXKMrkwMRGwM=
=OqD+
-----END PGP SIGNATURE-----

--ZEKmY72Ta3DxAanB--
