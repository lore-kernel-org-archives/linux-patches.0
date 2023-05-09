Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA741096E
	for <patches@lists.linux.dev>; Tue,  9 May 2023 12:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1683635132; x=1715171132;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ijkGrW+2rpFL4Y0gLu0veMBivtrLnsxJY0JGpTtZ9Bk=;
  b=cd5IrANdkZFtLU6U4ckBnV+8SH9a6t+O36Dx/aAfOjl5vthZ1b1C3NA7
   WicIB4UyZvWs4xrJYxAXwb4gKYuweIkfPaAEeNpiDQotveT2SHND4wsAA
   o4I62oq5QG7537vGKr3FCSThz5eh/pV7IxtRO8HqiKsy3qvTlkIlisrTp
   QI+Iyg2lil17t0KP2H2NuwRERUTRvbGFEQnaVtaYpSrn27KfKyhZAu1iN
   wP0guVO8sk2U/nJn17afGLBv0TDV/rx6NmwsT/tjbKMV0DOV2acGMZzNd
   ofzUuqnAleeNllMH+29p/dFK5PqltA2bnamn5oA+/9ka0yA3MTf6Gk9lC
   Q==;
X-IronPort-AV: E=Sophos;i="5.99,262,1677567600"; 
   d="asc'?scan'208";a="210342933"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 May 2023 05:25:26 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 9 May 2023 05:25:25 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Tue, 9 May 2023 05:25:22 -0700
Date: Tue, 9 May 2023 13:25:03 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>
Subject: Re: [PATCH 6.3 000/694] 6.3.2-rc2 review
Message-ID: <20230509-reheat-enclosure-c0f8fcf7f157@wendy>
References: <20230509030705.399628514@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="9nh3UvsGBTT76EVo"
Content-Disposition: inline
In-Reply-To: <20230509030705.399628514@linuxfoundation.org>

--9nh3UvsGBTT76EVo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 09, 2023 at 05:26:44AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.2 release.
> There are 694 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--9nh3UvsGBTT76EVo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZFo7nwAKCRB4tDGHoIJi
0rXdAQCStlcR0Mkfx/k9Pb/1gFsKOiO1GZCFh66yXngIdynN/QEAyex3G0ZVNS/F
qe2nUILynK5mjBX5La5rIPAZCi7NAQw=
=MJU6
-----END PGP SIGNATURE-----

--9nh3UvsGBTT76EVo--
