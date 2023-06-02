Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA8610E5
	for <patches@lists.linux.dev>; Fri,  2 Jun 2023 07:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1685689300; x=1717225300;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5HsIDP2Lxt6nJZdUdVu7PR+wHkA56EitEmtH8CnaLUc=;
  b=E2I/q6NIaMiTRLSqaabr7DEoCtITDX6Um94KcqBQXuL9ebI8DbVh97An
   VgWc43UEXXmJsmjUUK89uQyNrOuWePipXrRoB+DsOUzm5armzrLEA7lXr
   7jCLDgvjJ6fdHUMM6ZpH7Kd2BMMs4YQZXdXJApVxBShT6VoPZ1OMSNI2j
   3AZsm/PFFN4KGTi3IoheHnZObHXn6T53I23ayN2+HTjZGl3/FPWSikELz
   mzRccyIkQJFyfx4ZOsFhiXPZCktaOsBpDH4vAjuQiM7hClL72jiw9Ad8w
   23MAUwGhEDLCd/KDAIFFXlroEHomjqX+FcdV7qezfO8GG5lcPLkOCDUH/
   w==;
X-IronPort-AV: E=Sophos;i="6.00,212,1681196400"; 
   d="asc'?scan'208";a="214293338"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Jun 2023 00:01:36 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 2 Jun 2023 00:01:35 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Fri, 2 Jun 2023 00:01:33 -0700
Date: Fri, 2 Jun 2023 08:01:09 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>
Subject: Re: [PATCH 6.3 00/45] 6.3.6-rc1 review
Message-ID: <20230602-annotate-gestation-0e7846af0042@wendy>
References: <20230601131938.702671708@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="d13Qmp8CTGImzea1"
Content-Disposition: inline
In-Reply-To: <20230601131938.702671708@linuxfoundation.org>

--d13Qmp8CTGImzea1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 01, 2023 at 02:20:56PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.6 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--d13Qmp8CTGImzea1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZHmTtQAKCRB4tDGHoIJi
0jAtAQDj+LXwNx9ZseC9NwOZKJojiLWJN+DqPO7ASS+cAvaLSAD/ZMfyKDp79OxA
3yjHT03r4GZCJinf5bmTkY4FZzB+Kw0=
=N8OR
-----END PGP SIGNATURE-----

--d13Qmp8CTGImzea1--
