Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE08C23A5
	for <patches@lists.linux.dev>; Tue, 13 Jun 2023 08:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686646091; x=1718182091;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gK0JGjscBxeV5JXTkYgz7hz0xvUOrqtLXHuF/C7Qnxc=;
  b=ISAoPi+tRzd/f9ix2utLhW8DMrZEIRgKO08jujnA/2GIwvukvWivIzYy
   ZmQHb4NSvoxxYvr2TtTylC+8jiKj6l1TdJZJV7cRLj4RaiWS7kEZJJcYU
   tEHKZKLDFg9QIoNelVMI7ebZWexDkInqOGTYnkVWGuvnhhriPEncuWxln
   LlbpT8uhM0CwprteytAFCuAYbkS8qmpKlIDSOgRxVi1uXi504CwmI55/H
   Khv1hChKTQgr2ZLomc9CPkCby7MEY2UlJkRW2XKqKaWTC3J+p7gQOBNPZ
   akJVrY3w+ZxFjSKMJP6XuRtnRJI92Z9V3cS6a2GhSyDSDHQ86llMm1xIT
   Q==;
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="asc'?scan'208";a="217571430"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Jun 2023 01:48:03 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 13 Jun 2023 01:48:03 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Tue, 13 Jun 2023 01:48:01 -0700
Date: Tue, 13 Jun 2023 09:47:35 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>
Subject: Re: [PATCH 6.1 000/132] 6.1.34-rc1 review
Message-ID: <20230613-curdle-varied-0e920e75d1d9@wendy>
References: <20230612101710.279705932@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="uz0ntHTHOCy6+mM2"
Content-Disposition: inline
In-Reply-To: <20230612101710.279705932@linuxfoundation.org>

--uz0ntHTHOCy6+mM2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 12, 2023 at 12:25:34PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.34 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--uz0ntHTHOCy6+mM2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZIgtAgAKCRB4tDGHoIJi
0gzVAP9qrENM500fT8wOMA4aixSCKLr30EfO5nxMoELVF/AOKAEAnKX+vti7R3Gd
W2XNtHU+pFhDzBtnoAWB8l9rrQDrCwA=
=vvDo
-----END PGP SIGNATURE-----

--uz0ntHTHOCy6+mM2--
