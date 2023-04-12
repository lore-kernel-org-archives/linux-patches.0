Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF353D78
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 12:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1681304021; x=1712840021;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zg7kFd/BtrVDt7skRSXJbiaHpkZzFwiw8o8iPI1pEJg=;
  b=chu+o82d0IiSFQEAZr9bLSwVyDjHRjxokhcpkBM+UKRlKRnHDsNV2qbW
   Y1LQxhFqE2AOz45KmjXpwSVmIebuYeyaNM9tYy7YsP2vvv8ARuAIw/XVp
   vvWcUlmIi4VnhgOPCZrmyuwWZEw5z/Ix8RcAC4+AZFh7OR8ULI2GDUanT
   9eoUwZx7Ckd8K9SQys4R12kuNdFPE3BDQRuwFmXIqX65IYTfkhAaYR2Ed
   H8Ev0wiQlm6UUezdOG+QCjXkkWExbDULi5M8AmZkfGU2YlKQHFXotQk9K
   x9IBX4NJMAmWzrs1yuZSGM24qEJDNEpq/rNW+K2nw5qnAROMaOenNpCwP
   g==;
X-IronPort-AV: E=Sophos;i="5.98,339,1673938800"; 
   d="asc'?scan'208";a="220547407"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Apr 2023 05:52:28 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 12 Apr 2023 05:52:28 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Wed, 12 Apr 2023 05:52:25 -0700
Date: Wed, 12 Apr 2023 13:52:10 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>
Subject: Re: [PATCH 6.1 000/164] 6.1.24-rc1 review
Message-ID: <20230412-headfirst-bottle-e66e4335bc5c@wendy>
References: <20230412082836.695875037@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ImYlABTTs//xW8Fa"
Content-Disposition: inline
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>

--ImYlABTTs//xW8Fa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 12, 2023 at 10:32:02AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.24 release.
> There are 164 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.


--ImYlABTTs//xW8Fa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZDapegAKCRB4tDGHoIJi
0g/XAP4gUitKVG36n7dttIwHmgERpTwDZ1TJdta2EQlhhwuNHQEAix/Ubi9A6D1U
TL4iIYOkbY67EwX4KL7+0KnKJWr9fAw=
=U6/L
-----END PGP SIGNATURE-----

--ImYlABTTs//xW8Fa--
