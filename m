Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136FB10EC
	for <patches@lists.linux.dev>; Tue, 29 Aug 2023 06:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1693290237; x=1724826237;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NFR7BS/t+ayxaaaySg2zfmb0fya/Bj6mhurY0m/cULo=;
  b=OaSQ2mjrIcxIBDvTWF1pF26T53qr0bPWRSajikxzTjjfq23E5uyeIFfe
   nXLehEu7Lv5TGSkX+A9bD27ZXwV0DSE+txqjxDPhDvtEhSyf/QgEH5rJJ
   oE2tvjqJQ68fGEHTddEGNL4OvX5NfhrSJf8jIbTdXu/+pscJ8tB+TJQsp
   29NnT2pnlcDA02MBfpQS0muvGdSe6kRit6q0kK+6tP86v8ZGILrTiy1Pk
   kApbyJhlaBeNecmGY9AESF+GULKwlRcdIH94Ms4ZkDiCtz6DvlQoBTKps
   ZH383YUWnpd267AX4UhfLdxmDbQr94a7vVowRhLGIgJhZfRMKaIve743K
   w==;
X-IronPort-AV: E=Sophos;i="6.02,208,1688454000"; 
   d="asc'?scan'208";a="232226652"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Aug 2023 23:23:50 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 28 Aug 2023 23:23:38 -0700
Received: from wendy (10.10.85.11) by chn-vm-ex04.mchp-main.com (10.10.85.152)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Mon, 28 Aug 2023 23:23:35 -0700
Date: Tue, 29 Aug 2023 07:22:53 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>, <conor@kernel.org>
Subject: Re: [PATCH 6.4 000/129] 6.4.13-rc1 review
Message-ID: <20230829-emu-talcum-cc87dd4e8fec@wendy>
References: <20230828101157.383363777@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="R+UaXppGDc0HEZYu"
Content-Disposition: inline
In-Reply-To: <20230828101157.383363777@linuxfoundation.org>

--R+UaXppGDc0HEZYu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 28, 2023 at 12:11:19PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.13 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--R+UaXppGDc0HEZYu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZO2OuAAKCRB4tDGHoIJi
0sEfAQDhCOaZZUSbJYZaLYXqsSU8F0c738rgLZWZajhvvmuq/QEAzssQnudUBdzK
epBT+r4lGnCNXBvZbrL/nmqXMaiPmwI=
=ZOxv
-----END PGP SIGNATURE-----

--R+UaXppGDc0HEZYu--
