Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0FB53EA8F
	for <patches@lists.linux.dev>; Tue, 28 Nov 2023 10:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="WtzoaYm6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1701168252; x=1732704252;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=N/NUrzO2PErprF82qE85GTu43xecUWk7SuyD+T42OuY=;
  b=WtzoaYm6pQN96g8wx0BiENVXidh3Wfak+1AmRFedIsD/MwNmVjsq0LGF
   L0B9TWaTk3CZCvKSC+VMRgF4nUSXwOgH+ZmCJt04OCKNLx5EF+v3qAT8u
   Uzljjp2SIE+A8aM1ELEzBnC1HM/Mj8gxb/ywMaWnH+w5ECX7Y3LUg3Ey2
   wnka3GeXnYgcCslDYpPmz/lP+8J39VVLDm3yKFL4zHJaodsBCqVWbGx+T
   pdzaIO4nULxDYxdIONA6vAmFjFCKqbP/nRkbCg2i/JZvzuBnAZZeijMPv
   wD/+O9r3b3sblGjBxnjbx/JZai2Wi2N7+va1loNEQ0FCw+dnv71g3Yt1y
   w==;
X-CSE-ConnectionGUID: JUteezYWQAu/qC0geM9gZw==
X-CSE-MsgGUID: 6vH2AyD3Tp+taL/nW+9jDA==
X-ThreatScanner-Verdict: Negative
X-IronPort-AV: E=Sophos;i="6.04,233,1695711600"; 
   d="asc'?scan'208";a="13171676"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Nov 2023 03:44:05 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 28 Nov 2023 03:43:41 -0700
Received: from wendy (10.10.85.11) by chn-vm-ex03.mchp-main.com (10.10.85.151)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Tue, 28 Nov 2023 03:43:38 -0700
Date: Tue, 28 Nov 2023 10:43:09 +0000
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>, <conor@kernel.org>,
	<allen.lkml@gmail.com>
Subject: Re: [PATCH 6.5 000/483] 6.5.13-rc4 review
Message-ID: <20231128-lunchbox-zigzagged-2e660e15a34b@wendy>
References: <20231126154413.975493975@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="dU+rk7O5SqGQQLzG"
Content-Disposition: inline
In-Reply-To: <20231126154413.975493975@linuxfoundation.org>

--dU+rk7O5SqGQQLzG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Nov 26, 2023 at 03:47:04PM +0000, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.13 release.
> There are 483 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Cheers,
Conor.

--dU+rk7O5SqGQQLzG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZWXEPQAKCRB4tDGHoIJi
0hQRAQC4DLmpg3eOiK+eybGDt8psf+xUpKETkKF40NgUCNWYGwD/ah5I7Ua5uI84
GXdFM7dgTNNWgZ/Tk7zXh3N8dGBFSgs=
=wkmM
-----END PGP SIGNATURE-----

--dU+rk7O5SqGQQLzG--
