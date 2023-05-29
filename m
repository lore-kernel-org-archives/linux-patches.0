Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC276AB6
	for <patches@lists.linux.dev>; Mon, 29 May 2023 12:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1685361804; x=1716897804;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hXEjZRVQ8wPrJHIfwMuw1M/dTin+7ZDFe/zF+eNOlmU=;
  b=HEc+1nyub70TQlez7G3Cq6nZ2sZXp6j0bLVL3g5qKkIGuRDaQFh4t7NZ
   NLhlx6lgm3XvyNKEfV6p/5R3YfD+ysWIY6EIJPmE6R4II0o+pM9GrwKmB
   yoyaRlDPdLD0jWXmH+lcw9jl+fB7v6+qBrx8OoA5VO4AC33BV3pbajFLA
   djcgJCaROGLD2kSKpgqXebdY7BmMoIrMWMCWg/VHjR35eILDwVzMQKWS1
   29JCl1VZw3saFEGmWqZoKkSq0AMeja+nFXoibjwEsowN3H2H9I2tJJ67v
   AXMTkg1S1/c92mSQ8vPGXqFSHlQ7MNwo+1Z2kj3g7kQxoZdPKGWTSLk/H
   w==;
X-IronPort-AV: E=Sophos;i="6.00,201,1681196400"; 
   d="asc'?scan'208";a="217776096"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 May 2023 05:03:14 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 29 May 2023 05:03:11 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Mon, 29 May 2023 05:03:08 -0700
Date: Mon, 29 May 2023 13:02:45 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>
Subject: Re: [PATCH 6.3 000/127] 6.3.5-rc1 review
Message-ID: <20230529-grouped-campsite-0640cfccb101@wendy>
References: <20230528190836.161231414@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="IDZyWUJ00k0QZ0Rx"
Content-Disposition: inline
In-Reply-To: <20230528190836.161231414@linuxfoundation.org>

--IDZyWUJ00k0QZ0Rx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, May 28, 2023 at 08:09:36PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.5 release.
> There are 127 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor

--IDZyWUJ00k0QZ0Rx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZHSUZQAKCRB4tDGHoIJi
0jmFAQCGZU6EHGCB1w6XAHJ5zvcIvzgVdI3/J6AgdJaX0IJ4LAEAqsT0rD5Rm8tl
Grwwc+BbEhZSCYmb1KIQOW6EZV+ZJAA=
=etCZ
-----END PGP SIGNATURE-----

--IDZyWUJ00k0QZ0Rx--
