Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC362E2EF3;
	Wed, 20 Aug 2025 11:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755688775; cv=none; b=l6njFnGxTzfH0H/zei2GA6g5Ie49tpGMq6hpinX7e0GtWCCRhrvm159ibCpEuMJIiBdS+aTJd+nN5FMMaaDOO2uYh74EujK543unmoWpBaFv3xvMCfa4QywBRg5xYfPiBOnzvzegw/RXfBP3ZIsQuqPvaYXjznv0KPXCXsp+ybU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755688775; c=relaxed/simple;
	bh=HZ1UmbfBEdSuruy4sfEDaCmVWP8/cDwiG6wdSg1+g6o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AyB/m8DrdDwIGHyIXTLycwn2zxL+OIajM40jeG6P04pHRegqH2F/66onpBw9/zZ7Qiyxa+kaLGBhHypW8qD4btGisShH1ksChBKlpIFx1V6ayv0pPXuScBC3zpPTILyKvmTnrg+fIwUTAtrZ0Xd/iTKC74FfgAdKf9pVfkhOKMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WrcproSX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WrcproSX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E78C4CEEB;
	Wed, 20 Aug 2025 11:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755688773;
	bh=HZ1UmbfBEdSuruy4sfEDaCmVWP8/cDwiG6wdSg1+g6o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WrcproSXywr6Ysf2KoE6zgJO5GtNfhpm1e7Pc1fBcsC6SaqO66+i6axs02MPeUdz+
	 yccubA/57ZBo7JudBGZe6RCRRosxbbTo41NOQZrQyNQoGCLHCDHWRSq8lV52s9Wfl0
	 micvfZLpjrQglH4it7F6PirI0nIfXkr184im+Y4HHDj0BCvFBYxn8bGwhLTVxVsp4C
	 Fw+myoHg6KK9VDZ35dTVWYicxmjKw2A7FzUsRkXKOsmtcAtbYRE7si7Lpf8fdUY5WT
	 OyhYpRVGDOLiQ/IpPh6EHRY8TeYs2TVHTgyqLcFfgvUcc1jN7JZOCxTxYSsS2oEs7P
	 bakg5naWMP9Gg==
Date: Wed, 20 Aug 2025 12:19:27 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, achill@achill.org
Subject: Re: [PATCH 6.15 000/509] 6.15.11-rc2 review
Message-ID: <c6232128-6bc5-4f84-af15-43e2fce6d619@sirena.org.uk>
References: <20250819122834.836683687@linuxfoundation.org>
 <bb8ebf36-fb7c-470c-89e7-e6607460c973@sirena.org.uk>
 <2025082058-imprint-capital-e12c@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="gCIrQor9P1IRuS2f"
Content-Disposition: inline
In-Reply-To: <2025082058-imprint-capital-e12c@gregkh>
X-Cookie: Semper Fi, dude.


--gCIrQor9P1IRuS2f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 20, 2025 at 01:14:14PM +0200, Greg Kroah-Hartman wrote:
> On Wed, Aug 20, 2025 at 11:57:57AM +0100, Mark Brown wrote:

> > # first bad commit: [3b03bb96f7485981aa3c59b26b4d3a1c700ba9f3] eventpoll: Fix semi-unbounded recursion

> I thought the LTP test was going to be fixed, what happened to that?

I have no recollection of being looped into that discussion so this is
still exactly the same LTP image as I was running before.  Do you have
any references, is this something that's in a released LTP?

--gCIrQor9P1IRuS2f
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmilrz4ACgkQJNaLcl1U
h9Dx0gf/QipnVFFXAiaLAFpy9ZbGypIH+R0dVvTCdvnTBwp+XTfm8HlEBa3n1S6H
H65VjvKAnKh/7fjjDJPh2Ed2HTgqT1N9gw7iL5nX4nz3GpCCz+mG4gDQLJss/CXh
9WW8DHci2tMmnYUrKyYj3dwzId3tzRSFPTYL79w1LMFOyAzqFQXfwB9FT8/YIusS
u5qKDX8vroEFkJYFkEl/YlULHJfF26RRrF2/wYtnP9XWVITybktwYspDxAtd0pHT
g2AtrC68Oaza2uhW2wuVozwLMEyjVULijkUoTF2Z36rwhjwUCsmM4HvwEPHRTe0e
YTx4B0RIRPgEwJeWuBmYAW+ZOm74oQ==
=Kvcl
-----END PGP SIGNATURE-----

--gCIrQor9P1IRuS2f--
