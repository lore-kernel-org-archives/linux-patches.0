Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417FB7B
	for <patches@lists.linux.dev>; Tue, 25 Apr 2023 07:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1682406220; x=1713942220;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LNM/P5bjteU89CNsy/1BnEsQcAv8z/6w82DBFllYF9A=;
  b=WcgmNz0/b0Eo5ySlEdw+3c+9JiaBqLTqJutwtCISo36gOLOwqIwBKWRu
   095O96ZX9IvR53Rgru3ZnLLZOQaJysT+peaiNEkKP6DbQhSP9y82g4wid
   l3rNU3iipAvd2Ndd0l8OISf/hoFhuQzM1lk2pUlxFdy9KdPt2envGkyXp
   qPNuwKpAa4j2/q4XOfjkLHjHrdhc7vAX4ZvPKsSKywY5QuwfPvx081YrK
   FiTGqHPOJtXtH5eaSRx/RNtbKypRTLsO6LY8g3R7PcQsl2GF28wB6kXp7
   g7CUxFoYxw+WA1iO3GLv5FzxS43wY1bUTQIKiHOFMn8P3wOrQeV9r4iYK
   A==;
X-IronPort-AV: E=Sophos;i="5.99,224,1677567600"; 
   d="asc'?scan'208";a="210552771"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Apr 2023 00:03:38 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 25 Apr 2023 00:03:38 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Tue, 25 Apr 2023 00:03:36 -0700
Date: Tue, 25 Apr 2023 08:03:18 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>
Subject: Re: [PATCH 6.2 000/110] 6.2.13-rc1 review
Message-ID: <20230425-kilometer-poach-6027ead556f1@wendy>
References: <20230424131136.142490414@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="9vQlMmaF15WcW9/H"
Content-Disposition: inline
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>

--9vQlMmaF15WcW9/H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 24, 2023 at 03:16:22PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.13 release.
> There are 110 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.


Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--9vQlMmaF15WcW9/H
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZEd7NgAKCRB4tDGHoIJi
0sruAQDWoD0FXPXbOxk3XXGRP/0XN9HsDmIyzX1mYK+vEuGFEwD/d/E5LS2lIVzz
IS/2VZsVMSEnBe6AL6XduSbE6VGT6w4=
=BEiT
-----END PGP SIGNATURE-----

--9vQlMmaF15WcW9/H--
