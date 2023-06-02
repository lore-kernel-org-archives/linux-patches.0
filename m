Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902AA3D6D
	for <patches@lists.linux.dev>; Fri,  2 Jun 2023 07:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1685689320; x=1717225320;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=d4JG/BkDFywtb3I5VV9TtSjO2u/0Kdo7FRtTZx9miGQ=;
  b=RI9IkoDSJtV2+Kn/MmQUMMBjivIJpZtgDEiHoacJvImYn3m2YV7Nlttn
   1sewrFFbaWBIZRuYXNLWCDuicsHj2qdCTDH3MmoEM7AAoln3Iey5mz8hI
   Hf0I4VHxCWMTSC2GpRQLPes52Ro8mq2YqQnTgfAg/1iIiqSQUkTSmx85w
   dzNvWrQA8l/+sXs403xFQTEBvC/XpKk7dovy5rNEG+5YQeU8MBZQMieJh
   7abKu566cOMFV/L8RteUT6zIQnYwHzRBQLRhxqFhNzolYZQcqpa9Ii/XM
   OTdZ+y30/2ddI/jAcUdLCukl9N2vkTZPYQ89GPRMED7bAi7fWM5+4sisw
   Q==;
X-IronPort-AV: E=Sophos;i="6.00,212,1681196400"; 
   d="asc'?scan'208";a="218514510"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Jun 2023 00:00:46 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 2 Jun 2023 00:00:46 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Fri, 2 Jun 2023 00:00:44 -0700
Date: Fri, 2 Jun 2023 08:00:20 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>
Subject: Re: [PATCH 6.1 00/39] 6.1.32-rc2 review
Message-ID: <20230602-unweave-entire-fc3f63a18162@wendy>
References: <20230601143327.479886832@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="nWrFjptjSZE3Ob8K"
Content-Disposition: inline
In-Reply-To: <20230601143327.479886832@linuxfoundation.org>

--nWrFjptjSZE3Ob8K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 01, 2023 at 03:35:57PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.32 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--nWrFjptjSZE3Ob8K
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZHmTgQAKCRB4tDGHoIJi
0tgLAQCKu1JzuYbRLUmLKfB/0HiulyP6YLm+03/RAEhoeCt1EAD9GbMVAFp9KQoJ
40lt9L+TbD13NE+cK4I44jwxnbSCeAk=
=o8d/
-----END PGP SIGNATURE-----

--nWrFjptjSZE3Ob8K--
