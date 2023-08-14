Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E4BAD29
	for <patches@lists.linux.dev>; Mon, 14 Aug 2023 13:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1692018052; x=1723554052;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=x6U2lciyWZv16l3tw5CDh4m8yiw1CZFrKicNiibj/ZU=;
  b=iz4Rh9+NKFMTXEapEiBEs9CbBKpBhy7cvH/kZl5eEnSTmdQxHhWV2H/h
   sNk4M/GRfd5Qn7t23fuyrmPpp9PJ0YpbSHU7sqokcVd20dlB2+C/bikjL
   jgvPlA7R3GTaE1kMiT3zTMS1mCCDQGjyjsD4jO1OBT8D7HBuhnu5tyANx
   BQ1kV2ElOfCAqIYxPF2h7aRhJEcltMMCI82xz+Dxmkqs+1kodevl+M48U
   S6z+4fqTza5GT0d4lV5wZHjtlbPADa53/hGzFGcyjd46UuG9xaImywdY9
   UDISS8h7LYBSxgFoW+8bynnQrzbXcRg/M4xkmGVVUTDY4DfcrnTLLCPU0
   w==;
X-IronPort-AV: E=Sophos;i="6.01,172,1684825200"; 
   d="asc'?scan'208";a="229705827"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Aug 2023 06:00:51 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 14 Aug 2023 06:00:50 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Mon, 14 Aug 2023 06:00:47 -0700
Date: Mon, 14 Aug 2023 14:00:09 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>, <conor@kernel.org>
Subject: Re: [PATCH 6.4 000/206] 6.4.11-rc1 review
Message-ID: <20230814-jimmy-march-7defc9fff112@wendy>
References: <20230813211724.969019629@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="9y0SwpsL8LCJz6Od"
Content-Disposition: inline
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>

--9y0SwpsL8LCJz6Od
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 13, 2023 at 11:16:10PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.11 release.
> There are 206 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--9y0SwpsL8LCJz6Od
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZNolWQAKCRB4tDGHoIJi
0tdaAP4i3nafwH/sM8PrBKf8CRaa139GwZ01W000uBSNlQJK9gEAxIiLslXk7hig
9fmzNbyg31OxBqnPG+99Y9OGMiP2QAI=
=MsV5
-----END PGP SIGNATURE-----

--9y0SwpsL8LCJz6Od--
