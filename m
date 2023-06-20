Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87EEB10961
	for <patches@lists.linux.dev>; Tue, 20 Jun 2023 11:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1687260244; x=1718796244;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ObSwR3z5gLc7CWALv2Ch7IeWIRyke2xnjULZNZqbszg=;
  b=d8u/tE7TpzcT9DGPD+AUHNQTv+RKimeDU/QfE6eTQS6ke+xgBT/t4PVq
   dnP2kxpDcTMAXYLFxkh7pHp+0P2M+62ffvw1qG+UVfpL4zzCn3hYN188L
   JXauTHSZcjC/YYk8xty13V2a52in76Br86zeBItTUSu1Mf8dvzf0nAuBS
   u8+EP8RMwzpXam7L/LAW/XP/wY8L+MiadgmHT8bRpe35zpDU12dsOpQgJ
   PDpZv0tZ4sKxd+9tMYxrNOvG//kqS9jK4dEIbHiUmqK3ZZuunxFDnM1m4
   2ZfLCQfVKFLb70MBgulko6wjedJlaSoh2a96ldAxEZ6ckBKguNhF61YTH
   Q==;
X-IronPort-AV: E=Sophos;i="6.00,256,1681196400"; 
   d="asc'?scan'208";a="231095395"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Jun 2023 04:23:56 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 20 Jun 2023 04:23:56 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Tue, 20 Jun 2023 04:23:53 -0700
Date: Tue, 20 Jun 2023 12:23:27 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>
Subject: Re: [PATCH 6.1 000/166] 6.1.35-rc1 review
Message-ID: <20230620-mandate-capsize-e8dfcce96656@wendy>
References: <20230619102154.568541872@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="X5M9avvAq7l2RkVl"
Content-Disposition: inline
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>

--X5M9avvAq7l2RkVl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 19, 2023 at 12:27:57PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.35 release.
> There are 166 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Cheers,
Conor.

--X5M9avvAq7l2RkVl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZJGMLgAKCRB4tDGHoIJi
0njvAP0XYkx/pajmHmA2RE+wIYvGrRd0VoRhKQJyWeZ8viOryQD/SxOX2X5bd0qu
huJFxG1Xv4VngDi7MgDUWqTh5JSFvQQ=
=9L50
-----END PGP SIGNATURE-----

--X5M9avvAq7l2RkVl--
