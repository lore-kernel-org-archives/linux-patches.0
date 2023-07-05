Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEAAF137E
	for <patches@lists.linux.dev>; Wed,  5 Jul 2023 07:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1688541078; x=1720077078;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ConKYiJXIY8Jw4Sc7qTfwuyKjyDkGUkguUDNtmuu4Zk=;
  b=druB6USw02WTVhKW5FvH9w7Py2twveoQvZpTlSYYQsBFoOhBpOd9PdOX
   cUZCLPLdMkprgPZpy02k1LmYrs1q7ov3B3VM7QtetB64r5/AR0iVAFcOE
   cwcy8aZ945ruC1DjR2r95RMTYImC+K4NPsqKGPQa66GI+quomd33mDp4W
   /AF41OWBIAJ2ZmAr+RkBGrMOqOWHJcqtgtM9Hc3ipGOZ89xku17C0zTzI
   euUlRqXl7gDGpMjneSUFX4+NZSNMA1hb4zjOPCqso5kelSvoXUxZwfYnV
   oXPKmqoZ9cRmAMFny/vNyDaFGFvFvPVVMY245+XD/Y3ak9scwmVVt3HjD
   g==;
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="asc'?scan'208";a="218951171"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Jul 2023 00:10:09 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 5 Jul 2023 00:09:53 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Wed, 5 Jul 2023 00:09:50 -0700
Date: Wed, 5 Jul 2023 08:09:21 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>, <conor@kernel.org>
Subject: Re: [PATCH 6.3 00/13] 6.3.12-rc1 review
Message-ID: <20230705-anyplace-clutter-42bd80a39c68@wendy>
References: <20230703184519.206275653@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="dN8mUbTyqj3Pmp0M"
Content-Disposition: inline
In-Reply-To: <20230703184519.206275653@linuxfoundation.org>

--dN8mUbTyqj3Pmp0M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 03, 2023 at 08:54:10PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.12 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Cheers,
Conor.

--dN8mUbTyqj3Pmp0M
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZKUXIAAKCRB4tDGHoIJi
0vFOAP9Bfnks3OPNhwIpLnAo0xr09+RySOHcNuQb0Z3PEXElDgEAiHO+IooplcDK
yNbdHmsxbhmaGZ59pWiMsXCMz0zCGwY=
=rNmL
-----END PGP SIGNATURE-----

--dN8mUbTyqj3Pmp0M--
