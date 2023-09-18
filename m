Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B45738FA2
	for <patches@lists.linux.dev>; Mon, 18 Sep 2023 11:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1695036336; x=1726572336;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AWntqZbkSbmn/MP084Ke+21jIISRxqv10eVOLcv87Cg=;
  b=BiSIlkjgVNDgNur5Zchf6Rr+dFRuZG94BS6t5tXjEpqNPRmPyKH4InR7
   pCFPLarQobc0vqBB5lMuhhAawFr0kKZn/vBdHlOSa7nZ6n+cQdo9Poi/J
   M4abi68lC9FGTOFCxSp7YbrN6bM62ZhS/QDd8CS2K4Qu/SOh4kCmF0SFQ
   R9K0loPm/6u3hzriiEIZ7bUXgX6/tVA0O+7sskcJgzT7n3ZDkRzth/HqL
   qR1FbtXIZHQXEuS++TjJA6njMg9Zkv705rQau2ZnYRxdzK76arOMCMocG
   O6MB1MK+d2i0mPvtz2+lJPglzU38mMzaT4w4gYWgsPPonzHt+od/xut0z
   Q==;
X-CSE-ConnectionGUID: pIJvHuS8Qpmn2ZqRa9Ey8Q==
X-CSE-MsgGUID: czKlEAplTfmnmjX5f1zEGw==
X-ThreatScanner-Verdict: Negative
X-IronPort-AV: E=Sophos;i="6.02,156,1688454000"; 
   d="asc'?scan'208";a="235738003"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Sep 2023 04:25:28 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 18 Sep 2023 04:24:45 -0700
Received: from wendy (10.10.85.11) by chn-vm-ex03.mchp-main.com (10.10.85.151)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Mon, 18 Sep 2023 04:24:40 -0700
Date: Mon, 18 Sep 2023 12:24:23 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>, <conor@kernel.org>
Subject: Re: [PATCH 6.1 000/219] 6.1.54-rc1 review
Message-ID: <20230918-animal-reword-a5ec304ea2fa@wendy>
References: <20230917191040.964416434@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="L1qguHOKtswDYfDE"
Content-Disposition: inline
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>

--L1qguHOKtswDYfDE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 17, 2023 at 09:12:07PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.54 release.
> There are 219 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--L1qguHOKtswDYfDE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZQgzZwAKCRB4tDGHoIJi
0n9rAQDyO31hBrEBGohyj30+1d1XuQqiDNG/YXHlnmVow396PAEA+fI0RYn3NHCA
oPrx6vr3yfObwpH43oN6c5ToK2iUtAI=
=42Pv
-----END PGP SIGNATURE-----

--L1qguHOKtswDYfDE--
