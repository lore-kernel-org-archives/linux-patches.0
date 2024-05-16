Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18845145B09;
	Thu, 16 May 2024 12:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715861713; cv=none; b=ORbC0fg1etuS81QgiV3VgUzcnB6PLwAfg5yy3+qYKrbTMi4ZEjYSF6X5i0xROd7UoZLd3LecWIjrxQFYRNMj4Lbqp/55MALECZ9WvNXWYqpJuphdyYIq6LFjhTxgjH8EcBB29fsJtLVDTh2g7JfO3jzg0jpje1rsZOZFkQTgMUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715861713; c=relaxed/simple;
	bh=jYUAdZb17tp2dNEYIxLWaWRVocHlMwhk4C2L3BaZEkU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n9NRKoa3iI5LRe7+qE9gdBVrJBIrHPmSsGSNwlIoE50gYttweh3zPdP//OAueHNIngyh0KlhEFZMykbyK9JBobYBVN7d5TETn2hAt/rsfrYwKV9AN+YirZXU5MJZF6jop7t1FNR6rHB4qEXS3yHbtyg6Leirlz7Q77mNI6fLajo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gffnAInN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gffnAInN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C035C113CC;
	Thu, 16 May 2024 12:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715861712;
	bh=jYUAdZb17tp2dNEYIxLWaWRVocHlMwhk4C2L3BaZEkU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gffnAInN54mFnzwYjreJIegh7KeP9CoD4TgrZMeCraqf0i35Q39UpYhQ8Hxt4gLjr
	 ODpkm5OF2nsEWZliGcIijS6AAokzIisKauFbtyh4r9lKj26w7TojgZ56xMn9QizO3x
	 fQr5+9Gd9ISo2iDtCTNzETQFgT7x+kNFGQAjYmEk7oC683Dmad+872ynVjaVjIqBac
	 HWuoBhbR6tacd4Sb+5bIMYM7XPwm+HrZpBEJjkks2mv7DNN0uj9EjjPHZDYqjJJA77
	 9mwGCAem3eH5lMABKEBo+fFehZMzP2MzD4tZPKrekoG5s2ywaXA5tXhQIFTmp5c0Xb
	 r+Ixx4brA4B4w==
Date: Thu, 16 May 2024 13:15:04 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com,
	Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 6.8 000/340] 6.8.10-rc2 review
Message-ID: <df364ff1-2329-49ba-939b-82ac0796f84a@sirena.org.uk>
References: <20240515082517.910544858@linuxfoundation.org>
 <8221e12b-4def-4faf-84c6-f2fe208a4bf3@sirena.org.uk>
 <2024051628-direness-grazing-d4ee@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="9xVrHvIclbQ11ykB"
Content-Disposition: inline
In-Reply-To: <2024051628-direness-grazing-d4ee@gregkh>
X-Cookie: I'm having a MID-WEEK CRISIS!


--9xVrHvIclbQ11ykB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 16, 2024 at 02:10:58PM +0200, Greg Kroah-Hartman wrote:
> On Wed, May 15, 2024 at 05:37:15PM +0100, Mark Brown wrote:

> > # first bad commit: [21b410a9ae24348d143dbfe3062eae67d52d5a76] eventfs: Do not differentiate the toplevel events directory

> Thanks for the bisection, I'll go drop this from 6.8 and 6.6 queues.

> Hopefully 6.9 doesn't also have this issue.

v6.9 seems fine - it smells like a missing dependency, perhaps the patch
Naresh mentioned but I didn't do any investigation myself.

--9xVrHvIclbQ11ykB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZF+McACgkQJNaLcl1U
h9CdZAgAgYVS6BJi7ZiA/O3rgvAVQahWKPIpcDNzQFQrpicPJcEqbUrRi0H0dd1j
9r0CFaLmeV1fjj+y9fgtDOb3QfBiugFy7AtfQOmKZ4SmVpAdOq6B/uV3mJZfDrCC
gfFeKBBVCv5vo24pupZLRgXgJ8kT22gbr2Sc9+6oNlfsxr64NMTNO5AQM4gZxd3y
8diVM/ealxtwWZOtk+qgyOXxImxP0U0lIcaxDF6/iVH2m3erilRGzUtLTvQ5Awfb
UZswHbuaQg/0UyhqrFOC9LupbRGWyBugvvW1BWknwO6m9cJ2NC5wuhj61aRqudgw
QMv6ymxBCVcnnoq/iFCCdYXFoZQ1SQ==
=7JDz
-----END PGP SIGNATURE-----

--9xVrHvIclbQ11ykB--
