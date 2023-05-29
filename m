Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAEC36AB6
	for <patches@lists.linux.dev>; Mon, 29 May 2023 12:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1685361858; x=1716897858;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9agoXGkI07FIZqJcQYRolaaB4bHKP1ZD9xZJo5c9UGU=;
  b=HU9TfC6p5b9h7Xv6ByIwECyaQLZu3yPgeu5xyIYrlYETp9LppPfNHnd7
   UZ68mkt9gsrzB3r0oPYqAxtp1hWZo+X7/9hFyozUW14dpGLYCzeijwtQc
   gRhq9g3f5ZPDb8T5ivXc0oB8iaKmJzGqwlLQi1pq8ywFIHxHRLDxovavm
   S1QOeJXfRluGo/0Q0t5s5cYjk29uAqIASzuZanifv+syQi4svYG7/tW8C
   t8AgGGIvUmOkFtOUiXQ+5y/QmwEwG9TRm/CijuXK09AUfBotaV6e48Sl+
   HOHrFVKznm5h3WVX2xxa6iabEkWqMhQ0HRLKQEFhGHMYAkxLCrZxD4C7p
   A==;
X-IronPort-AV: E=Sophos;i="6.00,201,1681196400"; 
   d="asc'?scan'208";a="154422043"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 May 2023 05:04:14 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 29 May 2023 05:04:08 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Mon, 29 May 2023 05:04:05 -0700
Date: Mon, 29 May 2023 13:03:43 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>
Subject: Re: [PATCH 6.1 000/119] 6.1.31-rc1 review
Message-ID: <20230529-subpar-overlabor-c42e619055a8@wendy>
References: <20230528190835.386670951@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="5WMTKpVQWMZZehZ4"
Content-Disposition: inline
In-Reply-To: <20230528190835.386670951@linuxfoundation.org>

--5WMTKpVQWMZZehZ4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, May 28, 2023 at 08:10:00PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.31 release.
> There are 119 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor

--5WMTKpVQWMZZehZ4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZHSUnwAKCRB4tDGHoIJi
0iOCAQCQU1uvXkh5DbnfamFmbN4PIyuSRHvreZU77DkUJVGrEgEA4ReFSKhQ9sRq
STUQ/8sLoUIlwUFY6gfddnKv5XH5BQU=
=D1lu
-----END PGP SIGNATURE-----

--5WMTKpVQWMZZehZ4--
