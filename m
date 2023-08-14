Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7038BC120
	for <patches@lists.linux.dev>; Mon, 14 Aug 2023 14:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1692022036; x=1723558036;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/MFNWkqsq1K7XfpryTJ0ac/m6VwICjGCbIya+sayRsE=;
  b=JfPHltzh48WXy7PoCrzWvMSxB06hojloA9adCfIIV1NuTLzI1MrtiZFm
   d+JyKuH/awvEYewdAgQzL8LlFfS4Mke47klyiXSqbEImyHKW5T8iA3iLK
   wxFjGDChrl0jJyRFJRKOR6/cmbKWrcQhWYairSSEOK/hkoCoaLaqtzLL3
   WQ4zgdyr2TQKvx8LmNILHzAaEd1YC1Q8y1K68ZBfkrk6e/glBIUrePA8V
   EdZycKbl1fMV35TVjjttNyg1XSYhTtCs/bylS5zG1385iciWZV/34vNZL
   dEH4rHSpzDADkH5indDyJ4PB+/rCKm0FjW7dtBU55vWo8mDYgkWiAaPC5
   A==;
X-IronPort-AV: E=Sophos;i="6.01,172,1684825200"; 
   d="asc'?scan'208";a="166343655"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Aug 2023 07:07:15 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 14 Aug 2023 07:07:14 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Mon, 14 Aug 2023 07:07:11 -0700
Date: Mon, 14 Aug 2023 15:06:33 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>, <conor@kernel.org>
Subject: Re: [PATCH 6.1 000/149] 6.1.46-rc1 review
Message-ID: <20230814-immature-roamer-398c43abc0a0@wendy>
References: <20230813211718.757428827@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="BKYbhG+6ARxAenx9"
Content-Disposition: inline
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>

--BKYbhG+6ARxAenx9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 13, 2023 at 11:17:25PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.46 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

I think I replied to the wrong thing earlier for 6.1 testing..
Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--BKYbhG+6ARxAenx9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZNo06QAKCRB4tDGHoIJi
0hgKAQDMLP2kATJw24PtA4Bi5XuVhgh7wUADE15xJQMAW8bDEwD/QD+7tMnE+gm4
Rax2OYQ0kcjL2JfyT0taCMKtm/XJpgs=
=zblf
-----END PGP SIGNATURE-----

--BKYbhG+6ARxAenx9--
