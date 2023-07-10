Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8FE12B70
	for <patches@lists.linux.dev>; Mon, 10 Jul 2023 14:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1688999488; x=1720535488;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LOdSUAq0OWnykpn7i+mc3p2uFC+TwqqqMHbwvvn1c6Y=;
  b=Cc150WItTViR8izNGtWNUjBab7JtYXU9oLuMljKkcqb9rYutnsMLxPH2
   tbTtlCVWQkPF3HGmBSgFYqYlzMmP3csouP2xVxg9u/U1niJj6wQMrYFlC
   UmZqTavFiREBEL2TpvcFvFfWAH7McptJFoHnSXdoI1AYEY7gA9sx/5xEG
   qMlR0AsPhjTwqeGJXissYVio7LkAXK4/bYZL6oIemJvn0mqEI4TTMWHOM
   AiTE/nJ2fnNtB4r70XnF44CB/LftsQuolveBGMPo5or4+u/Hn8T8LO3ed
   micf6sbkc5GoxiVwrqWcNk4sBBz+p8A0j39Xxvk8wjlafTCfP1m+HzXt3
   A==;
X-IronPort-AV: E=Sophos;i="6.01,194,1684825200"; 
   d="asc'?scan'208";a="223957711"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Jul 2023 07:31:18 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 10 Jul 2023 07:31:18 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Mon, 10 Jul 2023 07:31:15 -0700
Date: Mon, 10 Jul 2023 15:30:45 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>, <conor@kernel.org>
Subject: Re: [PATCH 6.3 000/426] 6.3.13-rc3 review
Message-ID: <20230710-parakeet-conjure-fd252215dc84@wendy>
References: <20230710054619.475084489@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="aHlqKoYVsI68erxS"
Content-Disposition: inline
In-Reply-To: <20230710054619.475084489@linuxfoundation.org>

--aHlqKoYVsI68erxS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 10, 2023 at 07:47:20AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.13 release.
> There are 426 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CI had a wee hiccup & skipped one boot-test, but everything else looked
normal...
Tested-by: Conor Dooley <conor.dooley@microchip.com>

Cheers,
Conor.

--aHlqKoYVsI68erxS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZKwWFAAKCRB4tDGHoIJi
0skoAQDE8fqdEO0gxuNGAUHqk2owntemGPzxXEZxXBCYXZTeugD/Quwoj8kDa8Z3
+vnNj5LEO0o5wcqIk4aCGQsqHoH4Kw0=
=JgJc
-----END PGP SIGNATURE-----

--aHlqKoYVsI68erxS--
