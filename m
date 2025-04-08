Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9741C5F0E;
	Tue,  8 Apr 2025 15:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744124519; cv=none; b=RMI5z1WCrRgQ+0P5j0O8sOsqJvoHCuc+w7PNlY/gTHKGF7ifTb83JKhghyY38LTPtDHdYE1/L5qrFLSEgQwaeYcL6EPRbfdc/aEeYTPHdcrepAGmP96ifgsRMIaPClZQIcukoBdayelsQJ1UrqwfMLE5A3jc89wk0w6IqTN5BE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744124519; c=relaxed/simple;
	bh=tzx7Cxt+g8APcFJQDQGkcEAoJ/wSmHCI5D33TrHAK4o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pC/G/l3GVexVU7tsxOOOKi8ND7LCC2Rf5zU68pm0cdgxtdvPuY1P+JVpLGROp1RqfI1njm/erETQ2N9wHHA4XeKd8QpwSlGnOArqj3hbnXQghTw+lu18VW06F+3eni7Cayf1D/agZ3URuyEfqeOdlde/msWmhafBG/ja87iTCS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FlpYYpgj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FlpYYpgj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B931C4CEE5;
	Tue,  8 Apr 2025 15:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744124518;
	bh=tzx7Cxt+g8APcFJQDQGkcEAoJ/wSmHCI5D33TrHAK4o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FlpYYpgjCeRPhKTEwx9i2R8fxaePCMjCLEKzy/19PMPypxSsjfKfIdUKFINERJl3p
	 tkRnikSXzl7yxJa6TmhgyA/C7fndsOu5jpbN6zarsbs+T67Zhvb7flIl/OKq1i8BPz
	 awFA1fvt+lqtlxk8v9j1y8uOZ3xK7m39QyrelvbYbrMKoIYpymk4oeU2vffg/Cyacp
	 RWggO+NOt0hDg5IlHLhlr1jXDN4yCdMy3StafXUo07iKeUNqYbycJFZaSQc9Z19t6D
	 7zAWAiJ7U/2ORmV3jjeg93VZ+NNgIXIRvp2gz2Gw/yQM/8XxAel25Xp3Dr36vz2MWT
	 Gnb2KqDCZmw5w==
Date: Tue, 8 Apr 2025 16:01:52 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.12 000/423] 6.12.23-rc1 review
Message-ID: <5c330e19-79d0-4800-a118-35094fc8bb18@sirena.org.uk>
References: <20250408104845.675475678@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="jOVoemtQG2pZBf3z"
Content-Disposition: inline
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
X-Cookie: Meester, do you vant to buy a duck?


--jOVoemtQG2pZBf3z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 08, 2025 at 12:45:26PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.23 release.
> There are 423 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

This is showing the same issues as v6.13 was for me.

--jOVoemtQG2pZBf3z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmf1OmAACgkQJNaLcl1U
h9DRYwf/QMlABTdCNXUDIb92kERSOFqdaHqx1v9KkL0p1135RrfKHmUHVYCIv1+9
Rjr1oj2hxnUEQP9t3fKK2igbJ7H3PgGVjjTgtwWoLnfNfMu+SedLAi2RZCpFHfOz
JQLKjNTNdHqY2CNnKSx8nQDQTYOvJe+/wukegchTeWG/7iqbEKGgTadUfvTP9OJ2
gayD6X0uNMgte/AZGv2ozdiDCH1NTj6DiYg1+xU9qAhI8+edILGpgCRw1gERq7Z3
Ctx/TwTIIfbwKEowPi20GVtejTRwdMdMCvIAQHsfB/H73FDNmn0GdztPla+U4gBP
4J5RT+TkMjznI+M4xSKsc2QYajtayA==
=TirL
-----END PGP SIGNATURE-----

--jOVoemtQG2pZBf3z--
