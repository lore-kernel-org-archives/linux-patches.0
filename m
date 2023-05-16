Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF611DDDA
	for <patches@lists.linux.dev>; Tue, 16 May 2023 12:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684240040; x=1715776040;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OWOCg4krQF0iPAAoKCL329e4qIBpOQAo3CjUNd8Xx/0=;
  b=1mYvhWvGn50NiiwlzDB9UnQ3zs5i0tMk7y65iILMUCEPgCxC79wq8M5J
   FEhMvYLxHwKHVyG8uIHPBHRTQQCD3IwKunR6O9uqgfTgO/l5fbf/Scqmp
   +NLcf15fsXUSUZyTHsHf4Q1LKBkvgIQ4OjVwcIapehQlnVKei1RktVe3O
   kGUR+6eL++jDmCD4smbihJMO93+MBaSxUGdwYpLFTp1+Re0Bsf+t46zUL
   CnVRiMdPqKxdTKKh0qhq/6kQWn5pxJ6aIY6ckBErN1662BEYkRk7VRIVO
   We1tuJv9yHmR35J0sBL5LN3f+1oYy7GFq5SNK50FjdEFDrFdssn4CPnlz
   g==;
X-IronPort-AV: E=Sophos;i="5.99,278,1677567600"; 
   d="asc'?scan'208";a="214078784"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 May 2023 05:27:17 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 16 May 2023 05:27:15 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Tue, 16 May 2023 05:27:12 -0700
Date: Tue, 16 May 2023 13:26:51 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>
Subject: Re: [PATCH 6.3 000/246] 6.3.3-rc1 review
Message-ID: <20230516-upstage-churn-cd7d524d8d51@wendy>
References: <20230515161722.610123835@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="WnZSukDCj38U/cgu"
Content-Disposition: inline
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>

--WnZSukDCj38U/cgu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 15, 2023 at 06:23:32PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.3 release.
> There are 246 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Ditto here, nothing looks out of place.
Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--WnZSukDCj38U/cgu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZGN2iwAKCRB4tDGHoIJi
0u6bAQDOIEwyks1kiuprnXGIel3Hl0BNpNMJlhW+DBdUmgNXGQEA2ZGmcf5Xyk8D
BnxrM+d2X4dKMpwJg/Z8jUGcGa2klAA=
=ajXQ
-----END PGP SIGNATURE-----

--WnZSukDCj38U/cgu--
