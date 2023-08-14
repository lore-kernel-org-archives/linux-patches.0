Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CCABA36
	for <patches@lists.linux.dev>; Mon, 14 Aug 2023 13:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1692018012; x=1723554012;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=DE9xX4dYWtBq0Su8RLmTH6uQZ23grIVCeSguhcWzu0U=;
  b=X8E+dr7e74K3s1smJ0yZpDLqQi35oYs7Hjgcv3nf0DExg7JcdjKIpff8
   Gt5Y2qq+5E2RfaRJsBaZCueqbjI9ZcEMcAfq+BcAcIWnEjL6m4+IUpKBT
   gyMoa3RZpCnC+boJEBUlMwHbIfN9jahYrJoeDrkru63p7qL51c3rgFl8I
   Wg/INcs4CznLMLvAFmXZGwQ3GHLs3k0ETXj1mT2fCCS6HJ7qR8uduqcb6
   r5hHfxp3FeGUG3hlfXLVG/dqLWASympgtm0BAiKnKfBy0oARC0PZxdqVx
   LdjgWeikrObxfrf3/tFCeSiBAm3u2H/ivLWbOgsiN6im6eqUG3ON8Frc+
   Q==;
X-IronPort-AV: E=Sophos;i="6.01,172,1684825200"; 
   d="asc'?scan'208";a="228827133"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Aug 2023 05:59:02 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 14 Aug 2023 05:59:02 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Mon, 14 Aug 2023 05:58:59 -0700
Date: Mon, 14 Aug 2023 13:58:21 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>, <conor@kernel.org>
Subject: Re: [PATCH 6.1 000/127] 6.1.45-rc1 review
Message-ID: <20230814-tamale-persecute-6878e2892a57@wendy>
References: <20230809103636.615294317@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="T26R+JCjILvdL4AG"
Content-Disposition: inline
In-Reply-To: <20230809103636.615294317@linuxfoundation.org>

--T26R+JCjILvdL4AG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 09, 2023 at 12:39:47PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.45 release.
> There are 127 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Nothing looking amiss from here..
Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--T26R+JCjILvdL4AG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZNok7QAKCRB4tDGHoIJi
0pJtAP4iI7Upu2x9EmSOWEdkMF8xma+q4BC/Pgcob/zBUzNNmgEA3gjThIDvdrId
3V+WLAx1GiySOqCFi2p1qNuh59FXmQ8=
=nF15
-----END PGP SIGNATURE-----

--T26R+JCjILvdL4AG--
