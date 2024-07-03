Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D8F133402;
	Wed,  3 Jul 2024 13:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720013821; cv=none; b=Mcrf5hiGyA85psfpHd/xuHeko+4+e/Qi7SYez+/ujhu6hqoHrHnGnLzPWbkhguQkVU+lpGsjqBLapiDh00OS/fYCEKBs3ngO6f+qWfZACwY+yofnABqCuoqtQZl1Kmnw39zi2dVzh3uu/FV4oOxnqwnDxDWl3E+5TT0vUGIEnxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720013821; c=relaxed/simple;
	bh=Xg2B/k8wbPalATjdhpcB8WSYw7d3xeRmS+ezD3oxVUA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ohlMHnaHzEkridBIThmorPj2dKEcXjjWXQ5jY4tATXl4w7jiqfhabv3L4UdbDZu3YQTS5tKZaXIzod0wQaV/bJg75eqLUmWTpxe1/2IfxxpkRTxTTbED3Xpr1lnVy8lI8QfvOYl16Q3ubPPy55bu0NtlHXAqTKBZNzlkzpCc7kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e/T0EmgY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e/T0EmgY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FB2DC2BD10;
	Wed,  3 Jul 2024 13:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720013821;
	bh=Xg2B/k8wbPalATjdhpcB8WSYw7d3xeRmS+ezD3oxVUA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=e/T0EmgYALpA6JLk+wWQW9ZGAUOzzOzzT2/+008rep7Bb21z8oOtbvGOxDSRQ0Pgm
	 fjl2jAyfSRZNOcyHHtcXoW9Yks5oM1Ojk5BdeMxr7Z7A3S/qUIXipNXfQ7S8jG1psQ
	 IkuIrTd4wT84tDGNHJ/XjISGall2g4DOenzD4nZEaLwVEPWVQmcuMHFLqG9W99S04r
	 vNkLu2Q8jaKpPE20hX40cfMj8VZb5Cu4NTPehEQSrBv82ToqxpgbyuT6GHfuAdI/lp
	 Ui207eREEDworfh23KcYAIcWoFQdpkkeqiyVPz9u5CljmpZDORn2lFq3qvwB0t7K2x
	 lW74bvUKO1FOg==
Date: Wed, 3 Jul 2024 14:36:56 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 067/356] selftests/mm: log a consistent test name
 for check_compaction
Message-ID: <2a39df32-73ea-43fe-84ba-e840ba3dc835@sirena.org.uk>
References: <20240703102913.093882413@linuxfoundation.org>
 <20240703102915.636328702@linuxfoundation.org>
 <416ea8e5-f3e0-47b3-93c2-34a67c474d8f@sirena.org.uk>
 <2024070349-convent-quiver-dc57@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="gFdnuIFqiqK0kjup"
Content-Disposition: inline
In-Reply-To: <2024070349-convent-quiver-dc57@gregkh>
X-Cookie: There is a fly on your nose.


--gFdnuIFqiqK0kjup
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 03, 2024 at 02:52:14PM +0200, Greg Kroah-Hartman wrote:
> On Wed, Jul 03, 2024 at 01:02:18PM +0100, Mark Brown wrote:
> > On Wed, Jul 03, 2024 at 12:36:43PM +0200, Greg Kroah-Hartman wrote:

> > > Refactor the logging to use a consistent name when printing the result of
> > > the test, printing the existing messages as diagnostic information instead
> > > so they are still available for people trying to interpret the results.

> > I'm not convinced that this is a good stable candidate, it will change
> > the output people are seeing in their test environment which might be an
> > undesirable change.

> Did it change the output in a breaking way in the other stable trees and
> normal releases that happened with this commit in it?

Yes, it'd affect other releases - I didn't notice it going into other
stables (I tend to review the AUTOSEL stuff a lot more carefully than
things you send out since you normally only pick things that are Cc
stable but AUTOSEL has some wild stuff).  The output tended to be stable
for a given test setup so it's likely that if you're just looking for
the same test results in a stable release you'd see these tests getting
renamed on you.

--gFdnuIFqiqK0kjup
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmaFU/cACgkQJNaLcl1U
h9DHHggAgimVJ+Owuz2RaGvecLyB0HckPzjBpP8wnVgBbaHctThC6eCxPT0fnBCy
wv1IIVK4rodMc+1sFRlzL/u8JrAjo4Uquz1RAufMACHID+uRxB8HJEiKYKdJNLgl
tJWZeITEDV5bfgMX/r+DG2zFv88sL5Pn3KJnu6bfsZURAk81f/xRQdsFW/1yw4pm
5Lb7VpUCplKOHvi4M6nZ42dxtRLO6C+o5+wUEZWm2inZdpHWTAe3xiEuPUUNopIj
ahTZ59MogZr+bu6bWEhqo5A9b3dhE79lhr33ciYh03hh3Ya/jfNfzIRnvC6MqSx7
N2sMswSievV0vpA7MJ5OdMk++Qe/5A==
=HEyL
-----END PGP SIGNATURE-----

--gFdnuIFqiqK0kjup--
