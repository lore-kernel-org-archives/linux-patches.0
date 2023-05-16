Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312601DDDA
	for <patches@lists.linux.dev>; Tue, 16 May 2023 12:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684240094; x=1715776094;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JSFHhNBo3Q5iXL83yY9BoSV9Vwb6Ca/x4uu+gldcZW0=;
  b=bJ6BXCzwuXSizuWGW4mGmk5pkZtG2VeD2tgxrdY3EGj/PweAvStIQFnN
   aQMQYKonDDrcFitvhZeipxY2DlFQo3EEzczkXWTIOJ6HQW3TEY3SBejvZ
   a5XbNduTbD4wCcBjGrmT0eC87Npe5l3MimJt2w23wa2VC8xlSnlxLrE+A
   sMT+XJ1CHYY0vvF9/7qaH3iLbd7l6N3HwR5HVvO8j7s3CxjC5bS9M85Uz
   CP+Pk+Gd5lsXIBlViI34Zk5CibIdJwotZIc4KU61Cq6cWv7ukJBfyqfk/
   IJi3RCY9Y0RpXzKSmGfsMyK9FIU3Hog/pEQ948kdT39yCeFThxWfoMTwF
   Q==;
X-IronPort-AV: E=Sophos;i="5.99,278,1677567600"; 
   d="asc'?scan'208";a="152310228"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 May 2023 05:28:08 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 16 May 2023 05:28:08 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Tue, 16 May 2023 05:28:05 -0700
Date: Tue, 16 May 2023 13:27:44 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>
Subject: Re: [PATCH 6.1 000/239] 6.1.29-rc1 review
Message-ID: <20230516-blunt-sneer-9dca68322e3e@wendy>
References: <20230515161721.545370111@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="3ytfdsV2r3cBhfVZ"
Content-Disposition: inline
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>

--3ytfdsV2r3cBhfVZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 15, 2023 at 06:24:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.29 release.
> There are 239 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Looks grand here too.
Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--3ytfdsV2r3cBhfVZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZGN2wAAKCRB4tDGHoIJi
0lkwAPwMOlCmSYJNVWVgj8kGzFd8V64yvQMMnOaoQqPUd7KZDwEA9/I5XUD9Lwyr
aedluvVmH4iujCCBQMYtXZms9Lc+3wM=
=u0IC
-----END PGP SIGNATURE-----

--3ytfdsV2r3cBhfVZ--
