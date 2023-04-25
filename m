Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63AF7B
	for <patches@lists.linux.dev>; Tue, 25 Apr 2023 07:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1682406164; x=1713942164;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0uYU44IZRgxrVlK5Tyn1icFuk/3TdFAeptiXaTucBfM=;
  b=Io7jU0vgDACql+0L8d0tRWQBsiTLRZS6oYUP/r75Jz2e4jThkHCWUTw3
   XiEoRcfJH2LgO0dB5+jN0jwhPz5JLrCzY0EevrAzvUM8n5vr2U/yO+jcH
   RxsxPrzNf8/akExlxLhyCZhZi77Wn7ymlb7ZvmKjc62xsSVdQ7j2da5YR
   zamfi/ohkNPwEj2J/kix/qaOVDkyftzMaLdDp+/yRca6iTBhdVUf5ZKfd
   SeMZ8nAAuP+21W3o+wOfFeSaoBoYRCASGV/3cXSR60OkV1HXIsuXGIGgx
   IlZ/584jjDQHvU7ciTsgntPgTITgGMKbBG8ntq1jTvOxNb3hxRL0RqEuN
   A==;
X-IronPort-AV: E=Sophos;i="5.99,224,1677567600"; 
   d="asc'?scan'208";a="211041873"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Apr 2023 00:02:37 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 25 Apr 2023 00:02:35 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Tue, 25 Apr 2023 00:02:32 -0700
Date: Tue, 25 Apr 2023 08:02:15 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>
Subject: Re: [PATCH 6.1 00/98] 6.1.26-rc1 review
Message-ID: <20230425-blog-ninetieth-ab5861b38d16@wendy>
References: <20230424131133.829259077@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="e9X7m7ankMwLleXD"
Content-Disposition: inline
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>

--e9X7m7ankMwLleXD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 24, 2023 at 03:16:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.26 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No "drama" this time around :)
Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--e9X7m7ankMwLleXD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZEd69wAKCRB4tDGHoIJi
0hAkAP0Wz37/WAYlXp4x7m8T7fkSt8qV5Vx3H2xVBFRo6w2SigD7Bvi8ZQTVeuc0
bB1s7mgT45soL/ZiS1i4KuToE2rz2wU=
=VC0T
-----END PGP SIGNATURE-----

--e9X7m7ankMwLleXD--
