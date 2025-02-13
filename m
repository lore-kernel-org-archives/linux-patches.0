Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C15772753E7;
	Thu, 13 Feb 2025 23:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739491189; cv=none; b=rYCo9wlGQWvUgzdDcxwrEj8ZZp7wLHLHXS/JlaqtMxsni7U0rZC0sQlOaeHN4WMLlyO8ji0MNOephUDBbKKafoXs4XTlh9iYaR0VqaY105Z15W0+FbuEztbqs76Bd0o3kifIiNKoNuwQt4w1vYxD1h6U8J89VVTrfTReN/ClNEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739491189; c=relaxed/simple;
	bh=8jF4EUr3KU06ynajkmNM0841krOgFqPZEHgWbQ6Oy/4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SMluo0dEGLMtMI3f3T6gJxmoS+I8Z3A197od9lXg/jm2HbOd2RgsKCkr/Rt623c6ayZFEQByxFwX0w3+MZt44cXhyNCVmI2o+FXVKBcS+AGh/YC1b4uWOBKcurQFE/KzdCusZ5Ce/Ab2hK6bMxs86aJLq4uFJmDVHPh2mH7TMnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KVUbeXG3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KVUbeXG3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEBC0C4CED1;
	Thu, 13 Feb 2025 23:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739491189;
	bh=8jF4EUr3KU06ynajkmNM0841krOgFqPZEHgWbQ6Oy/4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KVUbeXG3VxA5NabPDiBN47ImCPohPc3Ok3hLtBiRGgIMKKxJ1SiuUxUWF6OInGHo1
	 f3y1Eb3HNzHjhwJXJ6VEdbf4DXfYKBbf8x6+Z7fqU8RGFtsU9NPquSQkQC/0X5S9/q
	 mT5085LY5df/QWii6EhkN11CFtA5Kj0tpdSQuLUk52oobTBlVAO4wneUxEiqAHCAGl
	 gJ6w/gr/47UwWzjY1q6CdqKg1XTi4qxpz1ZgtwrhucboHL28+3N8+5v6Vl3zFff/iB
	 1S5+WkRAsPz5/CoO6IgJINApqGDnsobg3FkIAuWb8NyqojFajN8PWRu852ECgeP5vM
	 JRKK/kSLdIRAg==
Date: Thu, 13 Feb 2025 23:59:43 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.12 000/422] 6.12.14-rc1 review
Message-ID: <fcd6da07-2082-411c-9575-2d0c08c13aed@sirena.org.uk>
References: <20250213142436.408121546@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="RW4xudCVzgIO1ZXh"
Content-Disposition: inline
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
X-Cookie: Take it easy, we're in a hurry.


--RW4xudCVzgIO1ZXh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 13, 2025 at 03:22:29PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.14 release.
> There are 422 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--RW4xudCVzgIO1ZXh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmeuh24ACgkQJNaLcl1U
h9CoaAf9GqVrEjD0y+bZcwonQbzzf6mT+RBaElHO1WvzytBjS5N63pn+RB10a+b9
5o2PqGBeTCQe7Qf/KNbWnQuOdbA9VWxRF9nbh2wi0eF8kdUGB3459o9BjH8nZuQ0
mBQVRnxQpAJogdvTVcjygWr50PoB6851FN0gDrDSRySS9It/ZPms6cIGfmtPRCo0
LSRrdb0cjQzdPtP8NklCrZcjfud/puXSlmUN81JtRR6o/FnMdinHwFlRAOYiyFOF
bPa2TjVx6q9LZXAuTVmgQ0HMs+jnHpZNkr/XOhdF7nMoLMEPoMm/5YGyqpgG5KvF
OaNdxEh7bPVpILDjN2rRgP90yBIdNg==
=Hh91
-----END PGP SIGNATURE-----

--RW4xudCVzgIO1ZXh--
