Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87116539B
	for <patches@lists.linux.dev>; Thu,  8 Jun 2023 09:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686217616; x=1717753616;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=PQkE2PYehE/OtNnnTVBrgbg7pftXa1dsb+nlKsXbZTU=;
  b=ML/MQfYRxH8pjZPyNFVIwIdQP9TijiEv0K8KDA9aotU5+OsG1US6CdgX
   7kl2M9Zex/hdMp90R6naC9BbwiTCTtop/5lsE+LX3n0bsax6Lph3WPkhM
   dGjtflgmvDYiYs9SMDDZVlom4//yZhyDgbTtSsM1SG0lYg4C/FWb/wjOW
   +pbRbDRg5p4H4Cu1xJOSkeMibCnVNR52pWIgIcYYSztgsG66nMwFSY85f
   6tGjsyOSpnE4X+dpXs3bftf4QIu24vH6u+azLZ6gnRyV3KINbazCVR922
   h4hYncPpgciQxcGamNb5T/z0Own4O7Mami3V+C8rEakRGebqoP5td0bPI
   A==;
X-IronPort-AV: E=Sophos;i="6.00,226,1681196400"; 
   d="asc'?scan'208";a="217433426"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Jun 2023 02:45:46 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 8 Jun 2023 02:45:41 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Thu, 8 Jun 2023 02:45:39 -0700
Date: Thu, 8 Jun 2023 10:45:15 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>
Subject: Re: [PATCH 6.3 000/286] 6.3.7-rc1 review
Message-ID: <20230608-frame-yearbook-f025e1184e90@wendy>
References: <20230607200922.978677727@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Hu9W2xJ8P+sr9RsU"
Content-Disposition: inline
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>

--Hu9W2xJ8P+sr9RsU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 07, 2023 at 10:11:39PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.7 release.
> There are 286 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Fri, 09 Jun 2023 20:07:31 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.3.7-r=
c1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-6.3.y
> and the diffstat can be found below.

Ditto here, looks good on our RISC-V stuff.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Cheers,
Conor.

--Hu9W2xJ8P+sr9RsU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZIGjKgAKCRB4tDGHoIJi
0iWLAQDhDTzHhs0XMdhwppgi+IBIOT2Rd4g2UTps+YqVEVGzowD7BC6g96yQvYXo
XZ6UMEL5rBTk291/VR+YL9RZRG0xYws=
=zc8P
-----END PGP SIGNATURE-----

--Hu9W2xJ8P+sr9RsU--
