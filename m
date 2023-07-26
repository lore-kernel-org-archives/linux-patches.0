Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7720AD47
	for <patches@lists.linux.dev>; Wed, 26 Jul 2023 09:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1690363832; x=1721899832;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=l0UaXd8dxL8pcDlKqm2/iYLRu2YGyE+6AlZwryvSv9A=;
  b=aIzafDPYhcVPOj9M0zv+U1On9xdH6jQP0OKx7iO8xkLuqO+MYXXWjGz2
   4FvlPlKdkNbE45yZzG7rpMossLekK/E99Biu8HtCpMF4lPdmUOr2AyMJ8
   UDfTPsb3GTjkVdQIGyEryMH+ABXvr6dfkVxGKO0nLfl1hE6v7Aj1fL1b0
   /kAU3q8MwBQ5TUCc2rREmbUxU2ATNyZmo8/ySen6h7jM46PriQkwwKRkK
   gXUB6SWuySq3SQhJhNiFiuLyWcdq22oDZqkOd+7xfvi4LUFWt6eRmgZSR
   BqHHmEWf27xGvAS/t1Tlg5NJjMHfurniZ2eRjtFqtfVt8ZAW5S0ZS6IrK
   Q==;
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="asc'?scan'208";a="163273367"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Jul 2023 02:29:22 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 26 Jul 2023 02:29:21 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Wed, 26 Jul 2023 02:29:18 -0700
Date: Wed, 26 Jul 2023 10:28:44 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>, <conor@kernel.org>
Subject: Re: [PATCH 6.1 000/183] 6.1.42-rc1 review
Message-ID: <20230726-rockiness-gigabyte-5a7cdbcbb0bd@wendy>
References: <20230725104507.756981058@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="f1CyDS59SEKSqCi6"
Content-Disposition: inline
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>

--f1CyDS59SEKSqCi6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 25, 2023 at 12:43:48PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.42 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--f1CyDS59SEKSqCi6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZMDnTAAKCRB4tDGHoIJi
0l+sAQCBJlJFhCJ2oHjDIioOotqXhBCiUF93fXmG0HRQvs4qnwEA3Vkn+sTnjD1+
Cf0GDGcx9WxJG4YwZVjL28GWA0RyOw0=
=NZzc
-----END PGP SIGNATURE-----

--f1CyDS59SEKSqCi6--
