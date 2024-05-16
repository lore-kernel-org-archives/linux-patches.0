Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4A3145B12
	for <patches@lists.linux.dev>; Thu, 16 May 2024 12:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715863132; cv=none; b=KuQ6OL6HLoyWvO8KzgwoQLMgLIUUuQtSEuTm38sRzWUALFauxh/pz09Bk8sCxv8ZiYbpKfrOzXEsCQvictIow6O2yGG6cgtgkZALnPmGNDZ8b2O3H7cuMaX8lowrL38NUvwz0KTPUZqpCQ67ztlRaevpwOWuoWE/O5FhuoEQQFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715863132; c=relaxed/simple;
	bh=a5hZBfmTc41TFrS14NvhJkLMULRNqaDmr5dc5DzXido=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SsgX/tsNbWOYq26Viusl9guA+BzEQGkcsaJssWVjUv93R3lXUENvlf1cetKWSvAQQZyJyONtoUTz/w32gKjcyYZDMa9UrnqCLeRoNIm7F7GHvqEe6BkSrmxJ3Vtx7llDQHiFv8lMZYO+FXVw8v71ZbotomPTl8YqBFx5voLVgcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 26F1E1C0081; Thu, 16 May 2024 14:38:49 +0200 (CEST)
Date: Thu, 16 May 2024 14:38:48 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 000/111] 5.10.217-rc1 review
Message-ID: <ZkX+WBV4vJNpwX1i@duo.ucw.cz>
References: <20240514100957.114746054@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H4rAmLeXrPxSM07c"
Content-Disposition: inline
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>


--H4rAmLeXrPxSM07c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.217 release.
> There are 111 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.


> Stephen Boyd <sboyd@kernel.org>
>     clk: Don't hold prepare_lock when calling kref_put()

Stephen said in a message that this depends on other patches,
including 9d1e795f754d clk: Get runtime PM before walking tree for
clk_summary. But we don't seem to have that one. Can you double-check?

(
Date: Tue, 23 Apr 2024 12:24:51 -0700
Subject: Re: [PATCH AUTOSEL 5.4 6/8] clk: Don't hold prepare_lock when call=
ing kref_put()
)

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--H4rAmLeXrPxSM07c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZkX+WAAKCRAw5/Bqldv6
8kYyAKCLSFE//Ya2HqPFdbNCsOVBmnL96QCfdP4H9cpR/S99DZTEkL2BnyXI3dI=
=5OUA
-----END PGP SIGNATURE-----

--H4rAmLeXrPxSM07c--
