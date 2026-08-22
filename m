Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38EB23264C3;
	Sat, 22 Aug 2026 12:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787401310; cv=none; b=LHo05rtxkOmjPu/qpxOsMB4EiK31YYZACapiLuYhh94LpbwPQlz76dwzqoCkxTeudYoaBVCOaw+rc5gb684P4HhSJcwmyv1Zt7SkqLbyhMJFppJTV5ZO4iF1hpye0rGl60YtOtu99F5Dnz9/pFmLqE63y2nC5y3E/trXk6bcvZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787401310; c=relaxed/simple;
	bh=Fq7qtlknymfQxCmLFBxjtD6n0GJLJrhJzbyNmhfD0eA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y5u3sidZB0tevJ/5FH+9ARhjfQrzBvRRAVCl/h/NIyGLb01q5oMIfgCTvg/RFD03ibT8DwxFa/wDEim/fbq1fKl+HkRP5LxUtWiZNU8PgZ5XWqrWztIbNkug9Y4+MzO/5nN04xkGp58/nXdbTqy+umxV2WlVLGX2l0a23/FcY14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ys7Ikpuf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ys7Ikpuf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C57901F000E9;
	Sat, 22 Aug 2026 12:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787401308;
	bh=1YlaC22DT8y/p1b+9gpnfI4ZhCF+jk4LNxeUpPeSVI8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ys7IkpufHB78JHQdQ83jtBOZ/g1tKm+c0J/1YMm4Hy7MKolU6E5I7wmDeTl4wDh2o
	 ueVLJAqICLi2NgAJ7QeiM9+gz4Xv+3uyAAn1tABTVj5rl+rjE7Hxo0TdV8R0hzR/p1
	 R/VndjHUdwPxveEObpCmdHkr3wOMSLrRVzqSuCbnTqVDXZzaGNdEvxTB7Hc4NhmwcJ
	 om4LR6mS08FU4bYE/0UwoHMdb3kCWrGjkeHx27Kl/i1pPcV9N6JPWDpRjcjF/vZnAS
	 E+emTGwZ7XacMfyGByiF8wqJZmyOK41BxgQ919YGuY4B1a3XhV3QT9Imr4T6kR8aY4
	 dUlNry65uRLmw==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 8B60A1AC527F; Sat, 22 Aug 2026 13:21:43 +0100 (BST)
Date: Sat, 22 Aug 2026 13:21:43 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/220] 6.12.105-rc1 review
Message-ID: <aomUV6kPd4rznXTn@sirena.co.uk>
References: <20260820145223.480031205@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Dr4Thp6aGXTz6lrv"
Content-Disposition: inline
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
X-Cookie: My vaseline is RUNNING...


--Dr4Thp6aGXTz6lrv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 20, 2026 at 04:53:10PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.105 release.
> There are 220 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--Dr4Thp6aGXTz6lrv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqJlFYACgkQJNaLcl1U
h9C1Rwf/aM+3Lu8iFttWS7EJrdfe0OCSbCrYNV0H27/dFXWsE0by8Y6O3QjcQB7u
p0eqUINiOl8ubIW7ANjR0IS9XokKcZN4RLWnS+N+0Xg2k/ROEZ4wErcYW3GhSuZn
eHyNtEYxb5FfSEnXEqOo9LDaYwLIuSBMPWYo7heA2dErLXyVigoj7bBY+y/OT5fS
sRZqfFJvCuGfyeiWGLcXluAEMLEBvDkhq3orX/zgSXl8dmiOYeee9r2Bm2T9O1h0
W9c/9kWf4NlnZ12JJ1ayIm1FmGJ8hOh2BRMfYeaE/PBhhi407bWQYW7NbMh4UAPL
PDuD/IHeV2itwAonM7TnolXb8cj8rA==
=kytI
-----END PGP SIGNATURE-----

--Dr4Thp6aGXTz6lrv--
