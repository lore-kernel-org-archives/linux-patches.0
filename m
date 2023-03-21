Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C686FC4
	for <patches@lists.linux.dev>; Tue, 21 Mar 2023 08:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1679388200; x=1710924200;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=btMS0huDMUYhEmGuZe82nAyhxOj5XzUpq5NA/2S108g=;
  b=0vC1rV3To9qPML6pjRTRcnAtTd8C2euNSDGU4Xuna+b2U1g4lKTzDGWu
   bUknPhFg7E0RrX8FjSs3VhIQ3wLU96puQfPyNTp2wAd4vM0j9mdcBVNn5
   ZZhlBVFOY1Knb8Fz35C+9LUUQh6y0QleU61P/pCsCbwnrUz+FMuX5sq9q
   C0luV2dUEuW7SE9uAXL0S0nKRhqqlyA1XrNwLCdSEKfgZdnV+HQZFYV1k
   AccK8qCfSHqYg1ELRgPY6DXpVSTVSPOK2gmkrnUyJwoil2IhUJVeKfkcc
   s/who+gCsczATl4p8aEMWMj3TWXAjYqHLa0qXq09thZuliEHDbUvhrkdQ
   w==;
X-IronPort-AV: E=Sophos;i="5.98,278,1673938800"; 
   d="asc'?scan'208";a="143082697"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Mar 2023 01:43:11 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 21 Mar 2023 01:43:11 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Tue, 21 Mar 2023 01:43:09 -0700
Date: Tue, 21 Mar 2023 08:42:39 +0000
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>
Subject: Re: [PATCH 6.1 000/198] 6.1.21-rc1 review
Message-ID: <174b5c37-b4cc-4ec4-89f1-8eca4ccd3043@spud>
References: <20230320145507.420176832@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="3ranM69fegQ07Uvr"
Content-Disposition: inline
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>

--3ranM69fegQ07Uvr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 20, 2023 at 03:52:18PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.21 release.
> There are 198 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--3ranM69fegQ07Uvr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZBlt8AAKCRB4tDGHoIJi
0osqAQCXp7XGbmO3waPebaOqtK+o/IFEysCgiDT7zf72nI9BGwEA0mQccjPondSp
o1T13gT3EdwtFKCNYQ0yXOVc4mTLTQA=
=g0Vt
-----END PGP SIGNATURE-----

--3ranM69fegQ07Uvr--
