Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0A0137E
	for <patches@lists.linux.dev>; Wed,  5 Jul 2023 07:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1688540962; x=1720076962;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=l73p5YJJFfIg5mKM+9EMxeRdo7h+3A+3ITUn2dbN8zk=;
  b=kYkemf8TyeOU+AUZSmpCZvEAvD6HrTArTljLkeLpQNQ1IXnGzRVJjQot
   i+TbcxKjBcf7XPsqmevavyAHcWaZ2Vq0uW8hBswATBp1U5IL8vpBY1jWi
   +hYgm8dZHCzdzcKWS0PPrF5FAvbCzUjyqkiNoggnp6mRjeC2O+voj49Qa
   6EnDUKkmEwiDulO6/CZpSx3i0cvH7mmFcEVsjAh5QnXl0dFVH+Ljq19AL
   UAzcb3j9qblx+lKU6Pno64add/nCcFrxi1xsZa6f3AO9u1mghqzio8K0r
   s3x3iajsS5CbtR8sGPBvYbRhRRzWSENXB8fSRogFbWkeanhi60rTK9c8q
   A==;
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="asc'?scan'208";a="233760148"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Jul 2023 00:09:14 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 5 Jul 2023 00:09:05 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Wed, 5 Jul 2023 00:09:02 -0700
Date: Wed, 5 Jul 2023 08:08:32 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>, <conor@kernel.org>
Subject: Re: [PATCH 6.1 00/13] 6.1.38-rc2 review
Message-ID: <20230705-gooey-humbly-577dcaf96f15@wendy>
References: <20230704084611.071971014@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="8S+27JBDQu4Xdzlx"
Content-Disposition: inline
In-Reply-To: <20230704084611.071971014@linuxfoundation.org>

--8S+27JBDQu4Xdzlx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 04, 2023 at 09:48:32AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.38 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Cheers,
Conor.

--8S+27JBDQu4Xdzlx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZKUW7AAKCRB4tDGHoIJi
0kRsAQDYn61LoLb5rgpRz8Dwk5BMGeutZ/4yn9PalgqRWBtTlQEAzMLHnPhPh9iI
V0RmRcbfLdARjkll6t4SyT7zGCJlDgQ=
=qSlY
-----END PGP SIGNATURE-----

--8S+27JBDQu4Xdzlx--
