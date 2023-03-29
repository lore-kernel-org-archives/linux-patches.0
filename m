Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100567B
	for <patches@lists.linux.dev>; Wed, 29 Mar 2023 10:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1680086531; x=1711622531;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VdBcrgySIdL/WPuWoMsxsQA2x/dh18nj8WQEpF5gTGI=;
  b=B0a27AtQ8gFCosbbguXoasdCHaGiU9wxk7oK7WrucwbNqp6gwKO51J0Z
   PyftkZEAOSy/Ikk6NWEyp7c5yp511kpO6NvYFhs+y6D+Qd+rysNvTJSVW
   KaFJsVdbrE3Y+NxwadePwTIUCzEc+qCbnHfvLZs1zA3qsNk4iiSZiRryp
   5i2HJ86CjDZXXqiXopBgv4JceFYPGzo9LRIhDE7Kj2yfybYLKxiM16FEs
   mIA7k1bJUuWSWLrAvvZiMruDFQVcdc4QzwGjbzetcaD2cuJKEhHc4e46b
   xnDutmkQvsVMoAEgDPuJ0SlzzjJmiU4A8iS7xuOiqHEFkXwFzI0yEwla7
   w==;
X-IronPort-AV: E=Sophos;i="5.98,300,1673938800"; 
   d="asc'?scan'208";a="203988039"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Mar 2023 03:41:02 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 29 Mar 2023 03:40:59 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Wed, 29 Mar 2023 03:40:56 -0700
Date: Wed, 29 Mar 2023 11:40:43 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>
Subject: Re: [PATCH 6.1 000/224] 6.1.22-rc1 review
Message-ID: <fc8625b8-ce07-4089-8d03-512914aa1bad@spud>
References: <20230328142617.205414124@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="gry5cg9km3M0xT/2"
Content-Disposition: inline
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>

--gry5cg9km3M0xT/2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 28, 2023 at 04:39:56PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.22 release.
> There are 224 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Looks grand on our RISC-V stuff, thanks.
Tested-by: Conor Dooley <conor.dooley@microchip.com>

--gry5cg9km3M0xT/2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZCQVqwAKCRB4tDGHoIJi
0iOxAQCab9SurRZBZIuLt6aBKrvXH3xW0zTSp3rRTtrvjc3PFwEApJuDc7pVVvFH
6FOEiPQkOGlYDkMcO0r+ra5XMIIPIQQ=
=PXbV
-----END PGP SIGNATURE-----

--gry5cg9km3M0xT/2--
