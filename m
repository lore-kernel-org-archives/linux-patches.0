Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C21923BD
	for <patches@lists.linux.dev>; Wed, 28 Jun 2023 07:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1687936060; x=1719472060;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=45rv53vDLpmBo+b6q8IZyn51O/jO5mJGy41d2+wno64=;
  b=ppy4TmnatpvWcsdF0Lnv/VWMXux+o1ueljsJo3N2O8lL8xJocgx2IoSb
   WdW5vXFG8J7gi+O9bVcWKlIGS0Z/zMzIqIZN62XqHxuB0yWEawBkRnJP3
   yiOGO6JbTLFwePGy0aDeBOVc/lBBFHYlQQaHRgRvu0rmsteKDAV+8sK0l
   G3dVLy2CVfL2eLPmGFbi4Vl4eqgwzxpMmsqQtALfUQgFNpR5ILvFkm/39
   euh7wmXR8WIv9hvWqSJ2lbDX23HwXvl055pOkVMnrb8X/ua02pe/s2OAl
   tuPMm/taB0g7kSZvyYhaV2bcOv+xRbmLAcv81QxkWJUP/i2aevlbR/MR9
   w==;
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="asc'?scan'208";a="232606208"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Jun 2023 00:06:30 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 28 Jun 2023 00:06:30 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Wed, 28 Jun 2023 00:06:27 -0700
Date: Wed, 28 Jun 2023 08:05:59 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>, <conor@kernel.org>
Subject: Re: [PATCH 6.3 000/199] 6.3.10-rc1 review
Message-ID: <20230628-frays-parish-7d407edd6225@wendy>
References: <20230626180805.643662628@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="u+U0Bb1cftV7h6x0"
Content-Disposition: inline
In-Reply-To: <20230626180805.643662628@linuxfoundation.org>

--u+U0Bb1cftV7h6x0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 26, 2023 at 08:08:26PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.10 release.
> There are 199 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Cheers,
Conor.

--u+U0Bb1cftV7h6x0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZJvb1wAKCRB4tDGHoIJi
0nDQAQDNSgQkz+OpfbRbVVtB2Cg3CZWIWqMXTeLQLlp8evltHwD+JAFbjSiAX6Bs
Az9y0EiukyHgKim5EgIGIgUAAdJjHQs=
=3Vti
-----END PGP SIGNATURE-----

--u+U0Bb1cftV7h6x0--
