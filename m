Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F194F32D0C4;
	Thu,  5 Feb 2026 21:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770325784; cv=none; b=hk7cfAZW9eclV88pw1sjn6VQlrVe1UY34yj2GkO+yUYapTq5B8euCyfZ+EVt0cj9eAWKFoDKR8YX8pPTX5t8kJZA4G4Y2B/+mJlmDthZdd7B7qZuono6zcRd7mw99RxEKPGYLfLHVyLda9AAuO4GKu+FxqAM6szh95Acvd+7YQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770325784; c=relaxed/simple;
	bh=ozSFKEI79GoTdl4Ai30BuX7ki/qCvNy6lAkaQXc0be8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gx1QYZ3+DnT3XszNIi79dy3xBWuhtnGe4RkKi7QwFyH7PQ/nszV4idnHzqKb/pPiVJkuD6bV6YhD9WcnPEwGjgMNHB69iPan2m/QZ7K9kHJjveB2AQ0bONeuQdngYHsCjIAMneaBm3onadpRBJWBbO1BOI1taqEsUIQLi4E41NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BOo6omMN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BOo6omMN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 196E1C4CEF7;
	Thu,  5 Feb 2026 21:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770325783;
	bh=ozSFKEI79GoTdl4Ai30BuX7ki/qCvNy6lAkaQXc0be8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BOo6omMNOU/V7Y3wvJqieGrGTh7T7mPJ/Y7tCghO376ClRhel8CFZDM6qmtTPTiPR
	 x4l2PZgz/0PHUtpqZrIGY229PLfMIMHRYER67BfSspL+WIgOzSDk7/lIqC4DAg09q3
	 f1YD3QfRScn0J78jsm2ZbAZrS2auy/mBRabCCjque5965zP4WuyUcxpaC6keEPXtrI
	 6ot1iyRuQbWMjwTq9SARqPSJjRlCT45VV8gy3O4yDoi2haB26gPl91o7yrC6NbmMDB
	 XyUl11y1rwG8LA2gNe+We9e1kI7f/ublc8dEQV1nP9OpT2p0sNAvmJFNbsfS9gb2w/
	 LAVrEeXyLVI7A==
Date: Thu, 5 Feb 2026 21:09:37 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.1 000/276] 6.1.162-rc2 review
Message-ID: <cc9f247e-6114-4551-84a9-db465fdf4a36@sirena.org.uk>
References: <20260205143450.492803005@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="V8TIBEyu2wGfbch6"
Content-Disposition: inline
In-Reply-To: <20260205143450.492803005@linuxfoundation.org>
X-Cookie: Non-sequiturs make me eat lampshades.


--V8TIBEyu2wGfbch6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 05, 2026 at 03:44:40PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.162 release.
> There are 276 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--V8TIBEyu2wGfbch6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmmFBxAACgkQJNaLcl1U
h9CJrwf9EYlVag8HvfadlHgRLZo52PMDPFcNdhUrM6x0APXb1GfwJQOsMVrx7KU0
lDU/K6N+MGBQa7aVm4rfZryCMuN3f1Z12uxQCBKtfvImxhbOzvuvgNDbfaxS2kem
FKGIRQjhQtBXDpWOIJ1zOlw2bfTbIir1Eeer5vFraFQNvZ1nwsbYiaH9BGBXcvV+
WDD4lYnMA8sGhX9bFEw/L6m6of+xg/PdVMVFdddP8RyoAV7Cu2NXqVA9bDgcHymU
FCxXg3Zn3KPE43CrS9TQwCYzGdAJO9MxiD4j7+0zK/pxSuonSX8wcii75pCxGZha
g+2rnLN6dsePxR7HgFRM9PQekcw4jw==
=zspQ
-----END PGP SIGNATURE-----

--V8TIBEyu2wGfbch6--
