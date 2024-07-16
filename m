Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E91041C7F
	for <patches@lists.linux.dev>; Tue, 16 Jul 2024 20:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721160792; cv=none; b=uwBE8nepGPXdFshBVVHjcToM9xECE12WK2/N+l25YooTvpiPwU+zOGN4mpuNa3MxcoFwDHkhrtch4370rqHAHy+A98b0rLyP0gIpECRTgnq4/SGiik0SkLoLPMb9iXEcwuORHC22D2EJwViLC8CoMVtN3jdckuJX/oso0dhZ+9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721160792; c=relaxed/simple;
	bh=CGrm8RHo76L6boYTF0+0Rl0nppKvtCF9KQ5wF6EEpjA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j45hfl/SRCPAK03Mh5htw+BkeMxfhstHh5GO77GDb4o/tUzZk6zhy7OT/vqa2gk6hcIFVYZe5K2kv5d78PTuMUvQiPmgbBpTUYSUIG4rC6kNADIlN9tyZeua1IQw0gbb1RklvWKuLuhLbl98U4mmB+B3QvCE+LsOVPVjrWvVXXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id D3E6E1C009C; Tue, 16 Jul 2024 22:13:09 +0200 (CEST)
Date: Tue, 16 Jul 2024 22:13:09 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.9 000/143] 6.9.10-rc1 review
Message-ID: <ZpbUVWCwCqeSezfS@duo.ucw.cz>
References: <20240716152755.980289992@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T4mFiTXWRoaVH1CL"
Content-Disposition: inline
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>


--T4mFiTXWRoaVH1CL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.9.10 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.9.y

6.6, 5.15, 5.4 pass our testing, too:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.6.y
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.15.y
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.4.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--T4mFiTXWRoaVH1CL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZpbUVQAKCRAw5/Bqldv6
8lzIAKCXwUfS1GCmsT4hwtlDTXOH72ZE5QCfQ9lkJgomA/DGluD5veNfoYhf1Xk=
=eT5N
-----END PGP SIGNATURE-----

--T4mFiTXWRoaVH1CL--
