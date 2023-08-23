Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411E9A92F
	for <patches@lists.linux.dev>; Wed, 23 Aug 2023 09:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1692784744; x=1724320744;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=oFCFuVDKxNca05E5fCXqRQ9kJDwM/9xD9jy6ThOYG54=;
  b=X/vYp0iSu4oHd8Q70UmAx6SnnKcGOUOj/7pNOrbiCo7dr1jqLG7s1/Z3
   hmEmG0Ci4pLdqTBgWb7RFwmbxf+GguXxa3RwfP0Y3BiBf2EmcVO1IcU4A
   rvPMk5HTwaisy9YoEkiiPjXUDven2b/YgBibwi56+CdJXCByKgOF+ONJj
   KBdXm9RJ8lMo5zqpD/ucM7OihsPd+eHtciA5sXZkEIiT4Y9X+bQ8LFPTS
   eIAHeKlzvl0DZKd0j2otAuE2vLZhJQNMdBmKUzDPGvZgeYoxh03ehlbM1
   gWl1CVbectVX4SZEFlai7Gn9IFIpJwR5NUiiZn9ngg0jLraD0H50FdCxk
   Q==;
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="asc'?scan'208";a="862761"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Aug 2023 02:40:55 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 23 Aug 2023 02:40:44 -0700
Received: from wendy (10.10.85.11) by chn-vm-ex04.mchp-main.com (10.10.85.152)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Wed, 23 Aug 2023 02:40:41 -0700
Date: Wed, 23 Aug 2023 10:40:00 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>, <conor@kernel.org>
Subject: Re: [PATCH 6.4 000/234] 6.4.12-rc1 review
Message-ID: <20230823-raft-cupcake-08b8629de8ef@wendy>
References: <20230821194128.754601642@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Zd6sdzXlo28Qd3yK"
Content-Disposition: inline
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>

--Zd6sdzXlo28Qd3yK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 21, 2023 at 09:39:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.12 release.
> There are 234 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

> Mingzheng Xing <xingmingzheng@iscas.ac.cn>
>     riscv: Handle zicsr/zifencei issue between gcc and binutils

Fails to build w/ gcc-11 & binutils 2.37. Can you drop this please?
I'll go try to fix this in mainline because it is probably broken there
too.

--Zd6sdzXlo28Qd3yK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZOXT8AAKCRB4tDGHoIJi
0q5TAP9wonJfGHAO4QB04iFwvbmbLDeiZyrQ9jtTc7T/AcejeQEA08j9E4v1wjcz
fNTUuWFH8slRszJvbiG8TeyY0LvDEA8=
=1KH7
-----END PGP SIGNATURE-----

--Zd6sdzXlo28Qd3yK--
