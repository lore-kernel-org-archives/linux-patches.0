Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963542D592C;
	Thu, 21 May 2026 10:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779359799; cv=none; b=WCmsqFnPvAZ3AjLmfC2R7FcyLkQWYzEbt2QRDYjFLVHTjn2oK7oEE9weVg0BHXO8ImaYuG7aNZGCKGqFCOCj43cl8/TB5MXFudIeld5gT/jDeUhYUsWwknfxZ3SLG3uF1qKcqw8UFnJ7y3Jwbm8r8OqaMP8S9xkiYKLGnR/IBE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779359799; c=relaxed/simple;
	bh=lT694LUQcNuNUQts83lz7iE/KOeyWYwYiWOw1clq610=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=euuNtxx3+JM0bTtoIPRG0tvHREbLvIMIXl+iFl13BNOZNNnmP6/8gmsYdte3203RGvyedNkT8EFs7o9QfqrtrbZdIZssWAz7cPg9mJYqpauzKD2/HKCDzfATA5QqXodGAgrnf53CXe3g/2IbAF6CDjE4ejDIfaAl4mlmnr4XNN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CcRluV1t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CcRluV1t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FBB01F000E9;
	Thu, 21 May 2026 10:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779359798;
	bh=fzXsCz4tTymA8FWZzVvMuDK+lLrMOyGIaNNHeDQlQIs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CcRluV1tCnHIGq471X6DA87Nb123am6+PHh0SQ8QAUBbdj1KBCxpk17tq8nPnLf1X
	 mRa4ZZ4sAJ7tMkNvDMy6mg3G0bu9PoAWarjoZvDTscEk/uGU2sP+qL6QeUcClzlUvd
	 ew9fEksOyT/6yqQ9hOWZ+3IJEv6vDBAVoSiWflyzlgt1G56412VOoMzc4PuNVRPqt0
	 nzDEcLwKkTGEaoZYyNmtEjy8rMwXe0DSqrcTLWlmmbCJqUaFAoJf67GCqakv+e9XCN
	 JGXu9tKxefUCko591sKzfZVItnASt8KidXw1osYGUYyuFcRqPe2gDxxUTyg/PVIM9C
	 iKUPH7dXp4kwg==
Date: Thu, 21 May 2026 11:36:32 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.6 000/508] 6.6.141-rc1 review
Message-ID: <6cae3e36-1f3c-41d5-9cad-70b204b81543@sirena.org.uk>
References: <20260520162058.573354582@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="wBdGH3gItbluViUi"
Content-Disposition: inline
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
X-Cookie: No shirt, no shoes, no service.


--wBdGH3gItbluViUi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 20, 2026 at 06:17:03PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.141 release.
> There are 508 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--wBdGH3gItbluViUi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoO4C8ACgkQJNaLcl1U
h9BJyQf/ZslQqREgX0HIG1Pn3h61J+/TGD5PHsLOdlAjadHi9MFmU3UKhJjpznzI
qI+mVqUH3cV2YxRckWfOUuukoINPOeAyN24hthynZNzALzF+4yANB6NlPf4W53EQ
WelwxtZX5yBVxdQ842A2BxUi0+V0PvwjaXU4vd64R3/CcJJ+mqfF5qY8EzwWKPIt
x7vHXqAj4HMXdziCwQ7+NNP/MJPePpIcPIL/lWX3Zk1lkH8yEC/IvklnE7EFsWHp
JJVlBx4jlK5CyB43j4rsjsbBJicDz0sbtuc/dXIWhrMjStoEOk4Bhcnn3a7L4RdS
ed5lGvWpK4CYjGSP95mTa1E1WX7V0Q==
=jGR7
-----END PGP SIGNATURE-----

--wBdGH3gItbluViUi--
