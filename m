Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1806F1DF749;
	Tue,  8 Apr 2025 14:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744124387; cv=none; b=SsI7f2jrOWQ5nFZwIaAYXTEyHxO2k2BtL8IGlLqPqzvKnopSlF/hzc+GDoGl0lL62x+S80e9rwtFmNhktOxlVVPz7Z2IEDzNWysMa+hF3YLoiPXwb6g+fNak1aqydieUf1NNXSizVeC2B9y7pCFsPboBk+HNp2WtNhya8WkoFK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744124387; c=relaxed/simple;
	bh=mGpBDdlpCzUCARzZt617MQS26FeiQ8f4f0bNCZgFf/A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jc1yITkQBdLI5D7yLAARZVhIinIGTOW5oQnD+Hcxp1nFwR3Jo8Pq94h3ThFXkubVhPYvI9BXL8an3/EK3IK9V5bo4sw/85DK80/ixiHlatJ8VFbe/bJtgiviEK+skqTr3ng32ZakLLu5hYqOj9pf+URyx855qZ7bsfdAJxf5u+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YxVMf4Uc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YxVMf4Uc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA568C4CEE5;
	Tue,  8 Apr 2025 14:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744124386;
	bh=mGpBDdlpCzUCARzZt617MQS26FeiQ8f4f0bNCZgFf/A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YxVMf4UcBz/ibWqkzfBNlW1ZeKRj+DXKeBCaRlBbqngQsTRTh97aTYTAOCPMV0egy
	 Ull36ATqu6tMzotxoa0ldrAURbSOwrPGZlaD/xvhOPOL8zkAT+fNkeodJqJDSwZK8d
	 Fz/l6YMkPgtdCeXo9c6CUl1IoqLKbgcwrseXPA6zRE4Jm+yNJSJcEXVvDUTdVztfF6
	 qpPwBn5Qs6MFkdW21IB0TOXe2xh6kxm4ayYkP2cUnNQsYlXns343oRdcb0MlJEkt1d
	 dC/CDZsXzUb+knegYjQK4S85CKvv+++lySlxNvnMpuk2A03+fUu70HIn91UGEjh3tA
	 kWAsZbSf8iFgQ==
Date: Tue, 8 Apr 2025 15:59:40 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.14 000/731] 6.14.2-rc1 review
Message-ID: <0e5aaddf-d149-40e0-8604-b3975f3998bb@sirena.org.uk>
References: <20250408104914.247897328@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="yyEx94VUu+N/lp1V"
Content-Disposition: inline
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
X-Cookie: Meester, do you vant to buy a duck?


--yyEx94VUu+N/lp1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 08, 2025 at 12:38:17PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.2 release.
> There are 731 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

This fails to build an arm multi_v7_defconfig for me:

arm-linux-gnueabihf-ld: kernel/sched/build_utility.o: in function `partition_sched_domains_locked':
/build/stage/linux/kernel/sched/topology.c:2794:(.text+0x8dd0): undefined reference to `dl_rebuild_rd_accounting'

--yyEx94VUu+N/lp1V
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmf1OdsACgkQJNaLcl1U
h9BtpQf/TsjcPTwPlAZnC6ckQbZVTmjEigyUSnCmtIRcKciXGMv0SgVB1LOjDvWf
InCAfXWkzhe+mJSaa0MLiXjwi81A1Tn6fpv9tsvg+Y5pkRku0BhLpy8ZZbk5s2qk
L8mMsY9xHYkuIWC98lRziH/xyIu69wwUI/1BZZwlxem3m/7H1+OlKqcjTEg13Vul
JrHdOimu6t7HgdOULNs8Pa4lo2yrgxoAoTr0cKx0FaBu//1R9i5hkW5zNj0/Mx87
LYSsDHZHZOzAzbBzwnuqzcKfyLWznQT6Ytga+t08G5jY58urC/uVEtuDJRucrS2P
Pyqcc/LzFlQC6tFAaHkbDgrDTPWPRw==
=aysb
-----END PGP SIGNATURE-----

--yyEx94VUu+N/lp1V--
