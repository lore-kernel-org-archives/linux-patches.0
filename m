Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 904D718452C
	for <patches@lists.linux.dev>; Mon,  2 Sep 2024 07:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725261049; cv=none; b=DnpRwLlFSRJy+AWTSfO744SRrs+oVGNHS5rPHIsYj4is69saKxKC/g/1QN3Vjfg8+CftIQPLF72BsgTtnxsmauXp/4LlTwa3fHQkFRrFJYM/w3bfj0DnGjNEIXGhbQ8TPNTo9CHxC1z9djiaBD4dxYl6LLRTv4g4J4Sx40uLF8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725261049; c=relaxed/simple;
	bh=ied+u+BsZFnlPHo9mm82f8X1Mb/OXfYNpbvAmlPMu4U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=prmfbTEVnA2FassJlMNtKpn4klfnGSs1+NOIu/2DK+GkATxHVvdGUDVdO1f4Iookp00c4CFKhKVaZNmGzTCA+lVy7uC8213bS8lXAAcVxs84bA/TYv+I4o92R62l//7vJLQ9CCiEtRpy1gdQo4L8c2JnxZj0Osm6z6zF/ko9RWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id F3DCD1C0082; Mon,  2 Sep 2024 09:10:45 +0200 (CEST)
Date: Mon, 2 Sep 2024 09:10:45 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 4.19 00/98] 4.19.321-rc1 review
Message-ID: <ZtVk9ZILr8jvaPeP@duo.ucw.cz>
References: <20240901160803.673617007@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QO+gC0VIOT/D335v"
Content-Disposition: inline
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>


--QO+gC0VIOT/D335v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.321 release.
> There are 98 patches in this series, all will be posted as a response
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

--QO+gC0VIOT/D335v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZtVk9QAKCRAw5/Bqldv6
8pyTAKCT8Fq4cAmzZREjayHK0LiQh0sKsgCgnycZUWLdh4wOplHVPwGBmwOkp60=
=L+lM
-----END PGP SIGNATURE-----

--QO+gC0VIOT/D335v--
