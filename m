Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AABEA94B
	for <patches@lists.linux.dev>; Mon, 17 Jul 2023 11:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1689592798; x=1721128798;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Agv739FsKb/t4lRY/iTsFiStP+D83yl/GQ08JzH9gl8=;
  b=TBZF7OLGrjuh3hMct7zunT4iosPttcX+C/HUo6dT6Qx2z0eXYRd4wLJY
   5XUYk+uipch29+d41pQ+IEEQMd3896tU60jd7Ot5XA2Ke3ki/b/4fYVWK
   dk2kdL/JBUeBQVmiedh226b8032ZOA7RxbyKP/saY8s8LjpJfW23RJ2ug
   WWhXv7u16afeRswkp/EkrjAP5GFQnZJQ95bSESpR0Q0yuSjuHsG/1WHsu
   9SIckO/+0cXAy+dH9LsR3rnO68MkzedvABxJ9uzbYMlxsQBOG0JbbLVev
   xstKD2H4Y9b9U7S/VM7VaNXrOXjGhak2IxP/vKSe3/Kh3MTFk1IcHsri2
   A==;
X-IronPort-AV: E=Sophos;i="6.01,211,1684825200"; 
   d="asc'?scan'208";a="235937339"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Jul 2023 04:18:47 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 17 Jul 2023 04:18:47 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Mon, 17 Jul 2023 04:18:44 -0700
Date: Mon, 17 Jul 2023 12:18:11 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>, <conor@kernel.org>
Subject: Re: [PATCH 6.1 000/591] 6.1.39-rc1 review
Message-ID: <20230717-irritant-daily-7eb1e398ae8b@wendy>
References: <20230716194923.861634455@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="GmTatSP0oHOhqa/V"
Content-Disposition: inline
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>

--GmTatSP0oHOhqa/V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey,

On Sun, Jul 16, 2023 at 09:42:19PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.39 release.
> There are 591 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Fails to build w/ clang on RISC-V:
block/blk-cgroup.c:1238:6: error: variable 'ret' is used uninitialized whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]

Guenter already pointed out the culprit.

Other than that,
Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--GmTatSP0oHOhqa/V
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZLUjcwAKCRB4tDGHoIJi
0joBAP4mOChOU9drzaBU3WQ6oLYYDe/AZHnrBdiPXkn403OAawEAhURGaXFiU+6M
MYJzOb6fedutcQ7upIa8+Gv7KCOg2gY=
=C8TV
-----END PGP SIGNATURE-----

--GmTatSP0oHOhqa/V--
