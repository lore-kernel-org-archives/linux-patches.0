Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C0B154B2
	for <patches@lists.linux.dev>; Tue, 27 Jun 2023 13:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1687873160; x=1719409160;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LbkL7tXxwlJdWU6yvK9qq0d59PKW1IuqSiGV1lLmpm0=;
  b=tUPQvWgCk5pQ+iDdubrZVazizHRZNJFjWqP/LTMO4NiV8+aBZKrPRVSK
   34Xo5fPno2MoeDzYNVMHmbcmT4jAzIza1XWpZcqLyY8nHZovl8d5jwNMZ
   PRBOxikOt4jP4hMQlfp2XTD6KH6V4x0mk8+PD7sH1ubZnx94pD5gaUZvf
   KhipNGFVUOELVd49SVCIuNDMjxlPtlteXepISuY7Bk9pGvomwPNoIFxfZ
   GjeF/hwzEn8vyS2tzHAZVz998ZjktbABfO7le/Vy3hSnMsDGJQrjaYo2a
   TXXJlZ/E1fjY+DZQVuIht3cX9Pe81W4gB/o1kSccpxp311uoklazNdiS+
   A==;
X-IronPort-AV: E=Sophos;i="6.01,162,1684825200"; 
   d="asc'?scan'208";a="222147104"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jun 2023 06:39:10 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 27 Jun 2023 06:38:47 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Tue, 27 Jun 2023 06:38:45 -0700
Date: Tue, 27 Jun 2023 14:38:17 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>, <conor@kernel.org>
Subject: Re: [PATCH 6.1 000/170] 6.1.36-rc1 review
Message-ID: <20230627-paying-untangled-02a11b535346@wendy>
References: <20230626180800.476539630@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="c+jIQADTZPCON90F"
Content-Disposition: inline
In-Reply-To: <20230626180800.476539630@linuxfoundation.org>

--c+jIQADTZPCON90F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 26, 2023 at 08:09:29PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.36 release.
> There are 170 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Cheers,
Conor.

--c+jIQADTZPCON90F
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZJrmSAAKCRB4tDGHoIJi
0m/kAQCZItFJPvjCZjQq6mgT6kT1CMX+57+otcs5NeszzWM10gD/e9c5NGstRzP9
FGV0I520y2b/1Y6fKCso6XXNSgY7gww=
=Q0Sj
-----END PGP SIGNATURE-----

--c+jIQADTZPCON90F--
