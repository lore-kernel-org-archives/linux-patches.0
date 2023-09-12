Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3818E8C18
	for <patches@lists.linux.dev>; Tue, 12 Sep 2023 12:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1694522294; x=1726058294;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=P01cDTSVf7ckurQxFxyjwgb5uJRiP/96u6vP0AxPKWE=;
  b=RC+Hd4lUpUfo98lUUfPJ5rghWeSw3Z+sEb7y59tOCsfT15g64DPjcH6q
   NzscKPsndlmdeWtt6NirNLyDdRpApx+VyybODrgeuxtXmAMvJvDPqDF6d
   J3irEq05hJGFrajUasbXu4bBjnxgyoGC1JDjKcAfFj/wHcSYFFDlHXogL
   lkCnOygw2mw4TC7ZcKfpnWEkAtN1Y3+WJlCfDMBjaafrZ2XHDIp+pUSg9
   7iFMLp3xuLXBE155x3xyrYeQjfCX5ajJm8EmjiAi4xbxSLKfBv/g8S/zB
   ex0XdSFhOF9sbni+jx6n81+aaVQQyxANO3faFqzvj/pnMOQfaJ11Scyfb
   g==;
X-CSE-ConnectionGUID: 0sNE4ZAsR22nJG2L44lBOA==
X-CSE-MsgGUID: 5nIlT3dOTH2q3yTVJBRicw==
X-ThreatScanner-Verdict: Negative
X-IronPort-AV: E=Sophos;i="6.02,139,1688454000"; 
   d="asc'?scan'208";a="171179025"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Sep 2023 05:36:49 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 12 Sep 2023 05:36:41 -0700
Received: from wendy (10.10.85.11) by chn-vm-ex02.mchp-main.com (10.10.85.144)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Tue, 12 Sep 2023 05:36:38 -0700
Date: Tue, 12 Sep 2023 13:36:22 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<srw@sladewatkins.net>, <rwarsow@gmx.de>, <conor@kernel.org>
Subject: Re: [PATCH 6.4 000/737] 6.4.16-rc1 review
Message-ID: <20230912-patchy-banknote-0982b6f505c2@wendy>
References: <20230911134650.286315610@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="lqmFod006FlLWkrC"
Content-Disposition: inline
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>

--lqmFod006FlLWkrC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 11, 2023 at 03:37:39PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.16 release.
> There are 737 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks.,
Conor.

--lqmFod006FlLWkrC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZQBbRgAKCRB4tDGHoIJi
0k7qAP9LyrhUha+vdg2Rj87nVD/4UPAd7+dYX8wHBH+qPyhUNwEAtkFzqq3VQr8y
2pdlezoiRm3eVNsCXG/ViFe78qr92QU=
=altQ
-----END PGP SIGNATURE-----

--lqmFod006FlLWkrC--
