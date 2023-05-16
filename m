Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B831C1DDDA
	for <patches@lists.linux.dev>; Tue, 16 May 2023 12:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684239986; x=1715775986;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=aAB1RI+PrfBWa9+/JpT0dOlyMXsCOTEgzEIRHIH/VVQ=;
  b=2UPUuLyUNzOcMFDjCl8Lkfq9EpmGlywwFUNb897BPCB4N5j35imuV9bM
   596GN/h5fNBmtlG7Bn/YjcoIOBWLwz1cUFhgC+C7NQId4CVZaV+ODLCDc
   KH8/WljNR+7iP3HZBiwXzFTmVwiRyUW2RQV/6442KlqoYqr6qeQKDjd+F
   izm/NZlIhHCUVZ+xo2Cq9AqP93vHsLsEYUyF8D8dARKTLa0OFvxQVxMIm
   gbJeWcx56EuPL5Oa5Y/Qb470M1nYbqFMosvm6GOJC09NXQWBvO80SXaN3
   H59pp7EHuVmLOOP9y+x0W0ZTehWKio9M8QeWBLkAeUQQ7d+Ge0ggi1XIX
   w==;
X-IronPort-AV: E=Sophos;i="5.99,278,1677567600"; 
   d="asc'?scan'208";a="225535650"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 May 2023 05:26:25 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 16 May 2023 05:26:24 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Tue, 16 May 2023 05:26:22 -0700
Date: Tue, 16 May 2023 13:26:01 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>
Subject: Re: [PATCH 6.2 000/242] 6.2.16-rc1 review
Message-ID: <20230516-semester-edgy-b26933f6a150@wendy>
References: <20230515161721.802179972@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="2qBMShf/1ne2wUJK"
Content-Disposition: inline
In-Reply-To: <20230515161721.802179972@linuxfoundation.org>

--2qBMShf/1ne2wUJK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 15, 2023 at 06:25:26PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.16 release.
> There are 242 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Nothing untoward here.
Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor

--2qBMShf/1ne2wUJK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZGN2WQAKCRB4tDGHoIJi
0ub5AP9Jo/r1xko5aR7TyQIpHj0BfhnxhiduNu6Md2mZxFj0SgD+Pg4ZTbNficLR
3VkfPdsE0z30ETmw2hg2SJm+6cUUVgY=
=LJb/
-----END PGP SIGNATURE-----

--2qBMShf/1ne2wUJK--
