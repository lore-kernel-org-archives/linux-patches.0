Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311BD1FBA
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 14:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1677162830; x=1708698830;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TdcLlbwPrbAqnbdqrVt/ZtbrBIOSSfvtTcMwq+CpbUo=;
  b=GZjPste/cBo9MYduFAwg4zIgtZcVgdzAsRTPiE1W1XASHed7/jbwoiQA
   AAnjj4+m4cvHXPMVt27kxYPukQwYsxZbqt1ZAWVoAF3yBbajrGPwFbiT/
   mxctU++CcVeyTRVvVBxyCd953GBo3MYcoP8fgME3wq7NGVOcMelTFYvRY
   Y5rvBP3wf3AfPXhvGajDUCzwRM6xjDEx4o13nIx+8WLQaK09bvSK10r61
   vo/+EmX0A2Lv/VpNaIh4y4YKZu5PiayBsSCLtmyK15tavjRx7MBCBodb4
   43Cli0+76VZCVgyZq+SUO+fZlU4pwZhZ1qPD6kuhloyEWyxPPDJC0OHbK
   w==;
X-IronPort-AV: E=Sophos;i="5.97,320,1669100400"; 
   d="asc'?scan'208";a="213363677"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Feb 2023 07:33:43 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 23 Feb 2023 07:33:42 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16 via Frontend
 Transport; Thu, 23 Feb 2023 07:33:40 -0700
Date: Thu, 23 Feb 2023 14:33:13 +0000
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>
Subject: Re: [PATCH 6.1 00/46] 6.1.14-rc1 review
Message-ID: <Y/d5KdOfh5rXUeqk@wendy>
References: <20230223130431.553657459@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="y89pGdxxUDHJUbhU"
Content-Disposition: inline
In-Reply-To: <20230223130431.553657459@linuxfoundation.org>

--y89pGdxxUDHJUbhU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 23, 2023 at 02:06:07PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.14 release.
> There are 46 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sat, 25 Feb 2023 13:04:16 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.14-=
rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-6.1.y
> and the diffstat can be found below.

> Dave Hansen <dave.hansen@linux.intel.com>
>     uaccess: Add speculation barrier to copy_from_user()

This breaks the build for me on RISC-V, you need to take f3dd0c53370e
("bpf: add missing header file include") from Linus' tree.
It was broken in mainline too, so it is probably broken everywhere you
backported it :(

Thanks,
Conor.


--y89pGdxxUDHJUbhU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY/d5HgAKCRB4tDGHoIJi
0oPNAQCHF1hz7H+ejba8MQkummME6T5j0mlx07U1M6JjNEx+XQD/RYtmDiPzp6pW
gI2X3S3tPZ56lpCyy098jne0tTMBaQ4=
=n2Cu
-----END PGP SIGNATURE-----

--y89pGdxxUDHJUbhU--
