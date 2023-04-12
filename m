Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0397133FD
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 12:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1681303907; x=1712839907;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Mgle8TOZj+RHhJAekpvZ/BT/yYwE38lNotj9mGkRDC0=;
  b=rqDkRlo0DJZ25LaWdHb2ac5UmgDwg50JD4WTkv8K73A7JMdvX8Mi/jSa
   14cE37i1mmo9KWK3DXb7eTnYc+vLCGC2thA8374nIjsZrHdDJSwmqWkRf
   stMRGm5rEXlA9L9x3AfW69yu+mnaUNjTs/hRLnzWWBSCOX3JpHhaAWyOw
   jeF3mPv+6pfYLbL5vGEmE2OLbpIDrdJeI2d5DsH01fDC6RbrGDzr9b2cG
   K6vSt4IALtbSZLXMpUZb8Q6QpbNS7lfLkUdrye2SUQJ2PoHbYEgD8xZzI
   3LDoBfDQW1/1WAYd50hSLlUEaftIG5HOmy5qPCBw/KlSL2fTYB0oZeNh2
   A==;
X-IronPort-AV: E=Sophos;i="5.98,339,1673938800"; 
   d="asc'?scan'208";a="206146473"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Apr 2023 05:51:45 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 12 Apr 2023 05:51:44 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Wed, 12 Apr 2023 05:51:41 -0700
Date: Wed, 12 Apr 2023 13:51:26 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>
Subject: Re: [PATCH 6.2 000/173] 6.2.11-rc1 review
Message-ID: <20230412-hardly-sepia-9a074ac2deda@wendy>
References: <20230412082838.125271466@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="1pecpxDfWI/k9n2D"
Content-Disposition: inline
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>

--1pecpxDfWI/k9n2D
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 12, 2023 at 10:32:06AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.11 release.
> There are 173 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--1pecpxDfWI/k9n2D
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZDapTQAKCRB4tDGHoIJi
0iZWAP9cGGwlvWkvJYWD46+GSWO8soa105r4HnWbWogov2vYNwD/Qs41xKhukdMj
7PtpYj8DjE63q66o06Zj85kHGv8SXA0=
=FAXU
-----END PGP SIGNATURE-----

--1pecpxDfWI/k9n2D--
