Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2DCAD47
	for <patches@lists.linux.dev>; Wed, 26 Jul 2023 09:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1690363813; x=1721899813;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VW/0RWz6OcJOAZAaREALwLaePcsp+WLwKLmTB+u9ah0=;
  b=CN/OJeFASGD1J746MtPkO962PItciDVxtktKPK1ANAjjXiP2FVgySPqx
   v7HtsU9tSJwKIMW0e5b6GCaLb0ltwTPhiLim54glwHMDfB85XLh442dDU
   7ENHYDOVJWws0JuVSaA1n3VN00Hmd8k1qZnZmusrVNEwVX+jgC0qRzVd1
   gMXVXOeDtqo2X/isbZF2jMRhyVdyhOLvF/5LoldbBeDBRXNdeTXBFhqbs
   hsJ4QOii2w+6lNwl1xboOpfrtib6vlazJFFmH5JuKtHSHrzki8N7DfEfn
   kjTZ1pltlzsyd5BDVUllc1SukT4rHs4YsyaeB6/8oe+PMBmhczIaNiaJZ
   A==;
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="asc'?scan'208";a="222289979"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Jul 2023 02:30:05 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 26 Jul 2023 02:30:04 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Wed, 26 Jul 2023 02:30:01 -0700
Date: Wed, 26 Jul 2023 10:29:27 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>, <conor@kernel.org>
Subject: Re: [PATCH 6.4 000/227] 6.4.7-rc1 review
Message-ID: <20230726-preheated-carried-ac1a34bd7a4d@wendy>
References: <20230725104514.821564989@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="abJNtELWpQ4Opme6"
Content-Disposition: inline
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>

--abJNtELWpQ4Opme6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 25, 2023 at 12:42:47PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.7 release.
> There are 227 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--abJNtELWpQ4Opme6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZMDndwAKCRB4tDGHoIJi
0g9/AP0SMHkzqogQdYkeeBflvBCt2FWwRe8w/lFrXn/a38pq0AEAj7dkaHrDxhAN
FIThd1J2wavJkGHq3MEHsN6LzE6V7QM=
=+gnl
-----END PGP SIGNATURE-----

--abJNtELWpQ4Opme6--
