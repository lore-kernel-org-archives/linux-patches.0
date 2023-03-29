Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF1DAFE2
	for <patches@lists.linux.dev>; Wed, 29 Mar 2023 12:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1680093931; x=1711629931;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cukQmgxAG+VTZdX0jlNhMge1f4ECwtBcvqgzQqaFGj0=;
  b=imr8iq4Vr10xyPm5HX+Q/X4DwtabexpC350dsRsFLLpi6sC779SIXW0r
   kNshEwNFCFbvR+DUd3VXB9DZpVVlnInrvch/w3St7mYB/oJYzehsxdaVh
   BgOniFYWYHItYcvmRvUsXQ/6GV5NnHu8nmKpdN8nliDb0MavZRoTgnXCI
   /xziUIOdTUMg6T+3kaE0+RbsExXge5kou31w+69aqpeQmtkx9yjnOLy67
   DIVnnSBPaxBw6zU7WWL6xEOMiGxkIyB0VZ+iom2a3dsBTKwxM9KYEa/nK
   q8ao8mBiVDIaeHsJAi9va/flyd8YtxyJckySRlk6I96SzTMz8P4snyTeQ
   g==;
X-IronPort-AV: E=Sophos;i="5.98,300,1673938800"; 
   d="asc'?scan'208";a="144483518"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Mar 2023 05:45:28 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 29 Mar 2023 05:45:28 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Wed, 29 Mar 2023 05:45:25 -0700
Date: Wed, 29 Mar 2023 13:45:12 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>
Subject: Re: [PATCH 6.2 000/240] 6.2.9-rc1 review
Message-ID: <3d21953f-7b60-4650-b9e9-438f45cde8d0@spud>
References: <20230328142619.643313678@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="FAzB7HwGpvW87Uc5"
Content-Disposition: inline
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>

--FAzB7HwGpvW87Uc5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 28, 2023 at 04:39:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.9 release.
> There are 240 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Nothing unexpected testing wise on our RISC-V stuff..
Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--FAzB7HwGpvW87Uc5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZCQy2AAKCRB4tDGHoIJi
0vY1AP9wJpeSfm3cEuOrHzfqbzErLpYa9f9/3zAy1MlW3k+gFQEAiFOwWKhMsVfi
trse0uh+JRoFe8yoiv4MHLWjRjhNmQA=
=OLmW
-----END PGP SIGNATURE-----

--FAzB7HwGpvW87Uc5--
