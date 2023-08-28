Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60CF411C9D
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 13:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1693230933; x=1724766933;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zP+aR1qLi8yYPI0boF+W89QBgdXfE3+6S0i6OY6bCxA=;
  b=INBEg34DyMv1aj6xeq5ROaG22mKRZGM+JpdfmbR5W8j+ZHFPKLhE1ygO
   MQ6zUlkYZ2+jPLQ8aRxjSZ3wXXnTgLq9DYKMzFF3aAwk9jNSMUdGFb1/T
   Rh23UfMmhvxAJ9L/NBs8FlMuc5Ki/31YbatuZ/VFuOYMvDb8N2fZNuVmw
   9fKNT3kqea2p/bXEmFwPTu68AnHeDx7HQ52sxTLJyCc0MVb2huDtdexdq
   5IMvcZSH8xFjFwa4BuILqBb/sdkd8CAGuM3XT9g3KLsNu+7sa9TQGBN7L
   R2gglxh2FCYToXuFKLnw5gvpTq+ksvpSn4jWrKk65ycb+iQMgxrobP/aN
   w==;
X-IronPort-AV: E=Sophos;i="6.02,207,1688454000"; 
   d="asc'?scan'208";a="168669658"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Aug 2023 06:55:12 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 28 Aug 2023 06:54:36 -0700
Received: from wendy (10.10.85.11) by chn-vm-ex03.mchp-main.com (10.10.85.151)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Mon, 28 Aug 2023 06:54:33 -0700
Date: Mon, 28 Aug 2023 14:53:51 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>, <conor@kernel.org>
Subject: Re: [PATCH 6.1 000/122] 6.1.50-rc1 review
Message-ID: <20230828-clasp-reformat-1d6c70a835dd@wendy>
References: <20230828101156.480754469@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="+9/25Ag1w0lpe2Cj"
Content-Disposition: inline
In-Reply-To: <20230828101156.480754469@linuxfoundation.org>

--+9/25Ag1w0lpe2Cj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 28, 2023 at 12:11:55PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.50 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--+9/25Ag1w0lpe2Cj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZOym7wAKCRB4tDGHoIJi
0t/CAP99hGJt04bJe6pBAhOYBVGxtUChtUyQtPDCVKdfwkviMgD8CGUrKV+uSPhg
NnrpBgREctlIF3C+aiyuJUHcsSEMCww=
=mRPi
-----END PGP SIGNATURE-----

--+9/25Ag1w0lpe2Cj--
