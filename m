Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D1F29DF0
	for <patches@lists.linux.dev>; Thu, 10 Aug 2023 10:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1691663455; x=1723199455;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=K8+CPDli4Ehy/vOFiQqyKURorvhcyrbCWewNPDz4/QA=;
  b=qGCDFZcXrnQxz4JbX+5Wu/Q1NAHUGxGDX9smF0tyIkzNJo+pK+BqbGE7
   mpUpXxVxRz65mLNDLgjdW40RMuGg4no+pSbMmMJepIAeOeLHU98a9TxV7
   Y1TG14mrBKbyzWIeQS3HNMviyXhzTTechB9Oj7j5i0Rb06/sbDzC2hzEn
   1yynGLUt+0oyBJqiLgy1eaGm3zaMuf+z3fSLvo0Yx+r37jcbVY7LLvaYR
   hvdUCtSwCRZVtetxso42BGitbGBlpIXzVKTdIZjLCgYWa7QnPRQdPubqF
   x0PA8yh4/mXl38EJMhqGcVfJsvi//ufHLvVdjo8ZohonT23bmcjUWSJ0E
   Q==;
X-IronPort-AV: E=Sophos;i="6.01,162,1684825200"; 
   d="asc'?scan'208";a="165807604"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Aug 2023 03:30:54 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 10 Aug 2023 03:30:45 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Thu, 10 Aug 2023 03:30:42 -0700
Date: Thu, 10 Aug 2023 11:30:05 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>, <conor@kernel.org>
Subject: Re: [PATCH 6.4 000/165] 6.4.10-rc1 review
Message-ID: <20230810-shininess-pencil-d32bad9520b4@wendy>
References: <20230809103642.720851262@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="sxSleVhRSRfmoBMa"
Content-Disposition: inline
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>

--sxSleVhRSRfmoBMa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 09, 2023 at 12:38:51PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.10 release.
> There are 165 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--sxSleVhRSRfmoBMa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZNS8LQAKCRB4tDGHoIJi
0mpuAP4lfrQF+M+wLtrvRmu8MfKJX2IAaxZCrsAhQyWhcHVr6QEAk8NooObFnEJd
HYWMi88u2ahlbgJibZ6YugmXbp0rZwg=
=tqQ2
-----END PGP SIGNATURE-----

--sxSleVhRSRfmoBMa--
