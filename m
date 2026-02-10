Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32DA430F531;
	Tue, 10 Feb 2026 13:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770729915; cv=none; b=uQy2P51FaCfZ8qLDH0jKcxqsgaeGtxwwSECegqUXBdYokuqKA8jtq+88bSWUswlItOQnJCuMAmiCwyzmo/3v3ZKPwErn+L+WcCxSu+VD5OHKdj2d7B5KV9ZxZAukj8Pq8SjqsdtRBusuGZNey+qOjOZyNYvEqKyYmtkfzKCzW0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770729915; c=relaxed/simple;
	bh=h7kUpsqhteK6MUwegwaSA/SkJgX3pxph7nwwfBdD/A8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L2GWGW/RutvQ1H6P6Ax/o1ng4sDsuhKR1VZ8OzvQiCm/i5C4WIQeeTffiDdI2gzib9ZpgjfneaxKPub/L99sRI4jJ2ir2s6X8LdP0XrTGsAKqMzN9rgQcwIxCTpEl6QqzE/rccsqUq4UxBttZcUk/irCqewJ+FGGUOfc+KpoPYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aUTrA/8R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aUTrA/8R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4052BC116C6;
	Tue, 10 Feb 2026 13:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770729914;
	bh=h7kUpsqhteK6MUwegwaSA/SkJgX3pxph7nwwfBdD/A8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aUTrA/8RBymGLSg404CnkV7xvqqr1TOhH0rAF6yEcnNIXMEgwym7Jg12XxO2Q4AKj
	 p0k2LDz4wJMk6Ce55bkl+AwXWALjDwIPHALoaE+7XfdcheTlFHjdr3ym9cdt1LHItf
	 87IxfzLB+Ii4iriH+FxSC4jnBS1hIUGkKPgc+GKO4q/kPDYekp0RcM/UxP2qnin86a
	 H6xKa5jctaDBEhlgVg8aaseR/yK5HF4MfUBJCd6VtZUA1k5x2P7Dz0SgxEmf4KSdjc
	 4gf6oetgLK3Y9bsqbbYgZdV1NeO1ujy36oiHmqz+GSE0NHVGG9BZQYUjM5q1ycVV99
	 LXXpSSbRsKCxA==
Date: Tue, 10 Feb 2026 13:25:08 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 5.10 00/41] 5.10.250-rc1 review
Message-ID: <ed31ba5d-4dc1-4f2b-b68f-05fa06841d14@sirena.org.uk>
References: <20260209142256.797267956@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="vYGM6G1bs20oLkLA"
Content-Disposition: inline
In-Reply-To: <20260209142256.797267956@linuxfoundation.org>
X-Cookie: Spelling is a lossed art.


--vYGM6G1bs20oLkLA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 09, 2026 at 03:24:21PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.250 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--vYGM6G1bs20oLkLA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmmLMbMACgkQJNaLcl1U
h9A4OAf/cxemBJOgJtsYjTUcdfyMU1Brb91Tgw/lqOUGtOtwlmA4e5CPrffF5jpI
hLL2y4viV8aDVJXQezeuepBcOitBBrQuIkTVzNC6bQH8FvgpBKyij4oJK7b8rUgs
slBloEaJklnTW02NXTePmw7jtOt7EnQvr/Jl56Mp1eTxWvj2EUkdlG9W9UOQ50li
Xwy5CZbGHT2bgJpVdSf3PCyGVgGkPAdFpKZQ/Drpbysy70WTDSdnm2Ylqw6nm9ce
6Jqydz3oppNDGLQPzzNsQsAN57KKH9Mh8OGBkG1M2bs9iobUX8CzZXWawDejVkKq
iCTLaVpQT74DrulkYQaNrxEpQ3ZUfA==
=h0fg
-----END PGP SIGNATURE-----

--vYGM6G1bs20oLkLA--
