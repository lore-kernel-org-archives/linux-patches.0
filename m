Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4EAE2BE05E;
	Tue, 18 Aug 2026 13:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787058079; cv=none; b=IFppRpGvDpwyVXsv2WE7j68KomYI9KVS6DjkCP87NsatV8jcoen+dkz+t4YI7UPsQAReNwvEeZ4xYQbgBma4ByCAtQ/0cX+GjavULIk39knPUTiQMJpX1AuKm8wKZhyTA/sSePTu63RTE3ocockqOf74QgDLFxCx1W0Z7GDFvlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787058079; c=relaxed/simple;
	bh=ePK22UyGMrMfxMpgZGNk4/Tgsko8zq/t7o1AOFjGo/Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OeY6GOHQVJXv7zwJVNdvktWpqoaOjEnRpNvfjFkHd5mgUHg4na6yJQ/kRwhQMPRtn4ChGMUyQRm3xL7NdhWhbvs1x4pmUC5e5Cm1KHZ1eBIqkT2B++a7vv6Q91RG3gJesfe/zORqqwsObqgtrHjCCNJ/xWZ7KJJfFtZ1b1EebYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SXNCrr+0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SXNCrr+0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F151F000E9;
	Tue, 18 Aug 2026 13:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787058078;
	bh=ruZbZ4UpMR3rauPxYTna/SsBNS2aNPCTkw5uITIMFD0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SXNCrr+0HlDJU2UEteikbPnUE4iM57X0y7yOw7fBoM4Kh64PajozJ1GxB4QsQCW4/
	 wjoiW+h9D0P2rGZzJtq2qdRwDqSpxRHdiiKAcqTxVDcguxESqzeOxyHfkA8wQrGunS
	 kn0nkdzwdkzbGNPc4nYWIeFtOQFdKnizjExJrbd+4z/JTsA94VdXSk45Uu53dvHTmE
	 GkbIO/A7ELrG2006I6soPPs3vhy6xnj5ARfoQileGvflIzq+6u7Lbrs2FB+04OvWQH
	 T4YiOrU9kg8DDAqijeyjtGXMBgX4G63gi4g0B1HLj9jv9kulj8NUGpYOenQ93SzS3y
	 ixQPLtGqfngOw==
Date: Tue, 18 Aug 2026 14:01:12 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 7.1 000/271] 7.1.9-rc1 review
Message-ID: <403c879a-b5e0-463f-a9d3-6dc6b36ed6c1@sirena.org.uk>
References: <20260817132536.752504388@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="E7/FMa5C6IoUQPfO"
Content-Disposition: inline
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
X-Cookie: Smile!  You're on Candid Camera.


--E7/FMa5C6IoUQPfO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 17, 2026 at 03:28:45PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.9 release.
> There are 271 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--E7/FMa5C6IoUQPfO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqEV5cACgkQJNaLcl1U
h9AfVgf/SnpWLL6qZkhsrJCCbctoyZKv1miqW8BE5cJAUGi32hweDPu+Wweme+v6
cm7dnJ1H17mZQKaSS9v7Hi1NhAwiLTk3CQo2Qkoyg60z0NrC3h+og1YjjekXFN96
TqZKkYIVuDKRyu1jwVofangnDF/5dA9c+uVZRKJjgrdvJHhsN+rukwrZXtKsz1Pd
bMGVAp+lGbzoYRo2+3Qgs+XeW99xdqEBr0KzCJQPeSu36hCDYgeZXd2VFFlulRV+
cYUpE+uWI46iM1URPr9cL6FSkdGTJmFUQ12EfdfmQUNUeXQj+DOR1FIlh4P0h178
7JGFF7f9pI9lB1QZVqt2AYcNM41pwA==
=vSNt
-----END PGP SIGNATURE-----

--E7/FMa5C6IoUQPfO--
