Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C453B23A5
	for <patches@lists.linux.dev>; Tue, 13 Jun 2023 08:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686646162; x=1718182162;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0+c48awLSI/0CX9e9GAjVHuwkZ1cRmuijLM7ZZzCtiA=;
  b=zze2HJp/TCO5HqIaCvSW3yknO8vjBc7G7wOm2ll+dr2ds5eNHszIqE8j
   suSryYo1qZN414wBmx6IAJrhk76GC08rMibdOXgtYHEzW1uOMBFYxOZSn
   AkvOUy11elgpLmdNz5YCFJ4hP3f+gV632E7GwVuzLulgShmiIqrnDHWNn
   6SQrNu9s2KxZ2cd824FRPljj/RBpyuK3SqQox0JOGlYbXKrrstscM5XyJ
   i0UnFxuKqF/Sf3F7Xm9909I8e5MFSMgxtx6tNqY+ozR8Bmk0WBsKvVSTx
   FE69EfCiyfs03a6wUPvdJkRnonRqceRQiIQcTBZvHA7yICBjRZ/tVIpZP
   A==;
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="asc'?scan'208";a="217571653"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Jun 2023 01:49:21 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 13 Jun 2023 01:49:20 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Tue, 13 Jun 2023 01:49:18 -0700
Date: Tue, 13 Jun 2023 09:48:53 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>
Subject: Re: [PATCH 6.3 000/160] 6.3.8-rc1 review
Message-ID: <20230613-guidance-coveted-a8e584cbe2b2@wendy>
References: <20230612101715.129581706@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="dDJ5gyBZh1IgAYsH"
Content-Disposition: inline
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>

--dDJ5gyBZh1IgAYsH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 12, 2023 at 12:25:32PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.8 release.
> There are 160 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.


--dDJ5gyBZh1IgAYsH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZIgtdQAKCRB4tDGHoIJi
0ksMAP9tuDiBuXFuFp/74o3e8ST6oIaVrodvmXc3Xs8Z2b9SMwEA/aYNJ0bFUqKq
Fk8AkuVKLgekY33M7RvgHJfLeP4E+ws=
=qZZq
-----END PGP SIGNATURE-----

--dDJ5gyBZh1IgAYsH--
