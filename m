Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3091422CBF4;
	Wed, 21 May 2025 18:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747853699; cv=none; b=OLNGAg5Pw5xWFt0p/lTXwxdg5bct6wlCdyA42oMxN5cWpMb16gXqMJTiwJoCYH55PaUGBHYo+skavu5JsaASzZjrAuPQxjgUvcMtq3G7Spv49C67SlbvgmSdSUxuswMnJJDT1yzUaiuaS6OsrEFbOcEpFRocaDR85PT5qmMHLFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747853699; c=relaxed/simple;
	bh=a3n/34e7SRsnBPGRdr70RzSSPEoc1i0q2gRQkHOCwHw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xf2N9S/b3c5k3gUB+Q0e16cHIAHJK32VsiTJtPT4k+1eYYYdtN+VBtv42iWtWJHtMzSRLaUzO59NHVghW7QWj05Iwy+nGh9WGRZ2yYsX42cT0MtQ2qJ6dMOlmDhAehVDtNIPNne9kGNxAHS00i3jYWVChCr9EY7m2HvWxbiWNPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d2bM7S9H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d2bM7S9H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A440C4CEE4;
	Wed, 21 May 2025 18:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747853698;
	bh=a3n/34e7SRsnBPGRdr70RzSSPEoc1i0q2gRQkHOCwHw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d2bM7S9H0E7KOPKt7dVX9046K+4e3FtnfX9A9Z7Pcs5G9lXqzzif1mF8ro82dmJ+7
	 iuNvMxhZo5b+FHQ5Xj+3AuocR/O8G6yiruzVFHuM57XilpDSQWstPHoSXO/O6pUGMw
	 vKn6zVNubCu0YtJT0zAWCe2JBxtUsRv4o/HyD79+GehJJ6Txfylaass+58TNCMqMjS
	 Cg+KD9aOnSqOXBwSSlz3WEhBpElghyG5/qZkeHmxkAt62UuLTCzdh99YQGJH6amLmY
	 CJYHS10FUJ3cupyDoOBGnGC+eTzBkpl0vRuWTcWnzfRnfmYcauEZyrOkBNzbUlS8Ss
	 Q6SF3c71Kra8Q==
Date: Wed, 21 May 2025 19:54:52 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 5.15 00/59] 5.15.184-rc1 review
Message-ID: <427fd881-f883-4386-86b0-50ae8fdbf891@sirena.org.uk>
References: <20250520125753.836407405@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="D4NXQu56x9rVx058"
Content-Disposition: inline
In-Reply-To: <20250520125753.836407405@linuxfoundation.org>
X-Cookie: 42


--D4NXQu56x9rVx058
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 20, 2025 at 03:49:51PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.184 release.
> There are 59 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--D4NXQu56x9rVx058
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmguIXsACgkQJNaLcl1U
h9D41wf8D/Ed4pPd3SGej8OSoDQslgbuJPK8kr2/eHfauxdMCw2UBW6rsRFNW80a
lBUh5ibw5G8S7TYcSDe8pSOFFUf+IEG9U9ViszxtsNr94PWeGmXqVTEfCGObP/x2
r5E/QfiDQwvHr/m3sqHorGJcswjEeewZrT3IC8PevwAtOx4/nOneEDJgr+1/gj+y
ed55VbiAT1piuYiejCXbECSw9fE6dcY7fI5bQnYMvoxwI2QGxoxdQ/37Dhc6Txhx
IAljP5rn6KfdQFp/BrgzAm2jXxG6gSWUosll7hhLSCD1rEPPuxukIjIt+BK6SsNx
g1HnhqWU10qBLk43mW67/yMS/5qFjg==
=Js5s
-----END PGP SIGNATURE-----

--D4NXQu56x9rVx058--
