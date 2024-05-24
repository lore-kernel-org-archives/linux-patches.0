Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3C253E31
	for <patches@lists.linux.dev>; Fri, 24 May 2024 11:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716549811; cv=none; b=nqnoxgx81cuih2JoH6M3R2rWv31MLCCJaXYGPOWZQHPY+oUfXTsrTJikBIBNz7W+XNJFAHYO2+cUQUZZwmV02YqDJIOHURU53o5KBudxPsYmJtvUhOe0DMWKIM2Vq5O5uROgYgVcf+IG6ChB1sUL0iHyPxYDBDu3otuPtVezk+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716549811; c=relaxed/simple;
	bh=FLcnBQMPP3uLOkZvPQkC2qR1hysfDBKQ9AL0Aqeke6g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RbJF1QjjpLf3RzJXWDU6tOFSO2RDNBHAfnpRZL7KaNOdJqvBPTVEbO2y8DNyyx2jdG0AruxZreiN70HwpsAD87tzqzLyYtymnxHvRAK3q+jnbiSUNKNd9r7EqGc68j6bwilBWkHUrAQHFQW3MWWgSJCZHEBGGIrsSkw9x7Qve7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 491591C0094; Fri, 24 May 2024 13:23:28 +0200 (CEST)
Date: Fri, 24 May 2024 13:23:27 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 4.19 00/18] 4.19.315-rc1 review
Message-ID: <ZlB4r1iXHRECnqjJ@duo.ucw.cz>
References: <20240523130325.727602650@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OqPx6s4Em1d9AbP3"
Content-Disposition: inline
In-Reply-To: <20240523130325.727602650@linuxfoundation.org>


--OqPx6s4Em1d9AbP3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.315 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.19.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--OqPx6s4Em1d9AbP3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZlB4rwAKCRAw5/Bqldv6
8hJVAJ9I1eEF7nJALq4K5njjrPbGa05OGgCgqH/YUm8oxbkcahEx/G6TgUwe/cI=
=yEvY
-----END PGP SIGNATURE-----

--OqPx6s4Em1d9AbP3--
