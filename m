Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A367B38F9E
	for <patches@lists.linux.dev>; Tue,  9 Jan 2024 13:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="G7lhDOZw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1704807008; x=1736343008;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8aLZtE/Nh+kY7P6JEc9JNbu4E+Q6wgXQkKqqHcpi8kA=;
  b=G7lhDOZwDYz6ETMvrMhskW9zxwIRA83vVVY72MdsOOGXnWLsDD5T5Yl7
   UkUsbqgiKJYoMRQBDMpzt6juO9XVViHSEa7KTmYjF+4DhnLQH4JNpBwGt
   wzr30rH6hLRooHV8gSFA6bfu6g2DHcV2fbJCWNHH7WNMzhjewiPeoCVsr
   0IBGwRXsJjp/bDO1u76R42bbFijUte2wz7KZHoGog7L5x51Ct6rLEeGi7
   L0qBGzFXpgzSdwjIXx4kru17jyRhbIKOc0fAxNL8obKySA/ge6WqUK9if
   BOss5AYsip5pe9/aSIxMjykr914o+29uo84tkaD1SKuMc2a6COBwc6gaL
   g==;
X-CSE-ConnectionGUID: vc1Zgb4NSW6pSMb/c+2yMQ==
X-CSE-MsgGUID: 3+kM2vspQ02lDGXYD5i6Wg==
X-ThreatScanner-Verdict: Negative
X-IronPort-AV: E=Sophos;i="6.04,183,1695711600"; 
   d="asc'?scan'208";a="14905648"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Jan 2024 06:30:04 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 9 Jan 2024 06:29:45 -0700
Received: from wendy (10.10.85.11) by chn-vm-ex04.mchp-main.com (10.10.85.152)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35 via Frontend
 Transport; Tue, 9 Jan 2024 06:29:42 -0700
Date: Tue, 9 Jan 2024 13:29:07 +0000
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>, <conor@kernel.org>,
	<allen.lkml@gmail.com>
Subject: Re: [PATCH 6.6 000/124] 6.6.11-rc1 review
Message-ID: <20240109-woven-qualify-c9b4082f701e@wendy>
References: <20240108150602.976232871@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="nSe+/zeOGRhIflWG"
Content-Disposition: inline
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>

--nSe+/zeOGRhIflWG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 08, 2024 at 04:07:06PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.11 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Cheers,
Conor.

--nSe+/zeOGRhIflWG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZZ1KIwAKCRB4tDGHoIJi
0pOJAQD/J+2ADrOoX5TqtHfI+2VUGQwGknxvkH4c8gMXIjtyAgEA9Nu5rJD53+vM
RZleiX6DLME3IIJLAhBfwLPj3SfaFQ0=
=L2Mg
-----END PGP SIGNATURE-----

--nSe+/zeOGRhIflWG--
