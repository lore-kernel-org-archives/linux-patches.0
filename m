Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC2880639;
	Mon, 10 Jun 2024 14:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718028532; cv=none; b=leEV+ws25F2pJHXTJg1i1bIQLsCDkXl9qOO1XeASlgKHNVbEVpEkEOzf/SfjJpCl5bpshS09YmvPdJKANB6XuM4wAyBm26sJ+l0g+nYeEoFJ6CN0iu9xAgYsY+MPAnAdKFcgevPI4/TjSFhnQzSRXC1PGI3XdyR9/X6wYpCjtdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718028532; c=relaxed/simple;
	bh=HSsioY+DUoQtToi7T6Hh/koklrpUxkv2OYPn8xxif0Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A1RqYhMjN29LCKF+eX/Es5qL6FhY+g67Vb743c7agts/3N6W80SR3f1j1XUcaWEj3gS3UP/CB9LayDWuppBdAOBBZE0VMjEXEVDTzJ/ODyJ9mCjahS7e1QIKnL4qOQmhe2WHUuiKCjrYcWXjlisRbWaMert7PqHWjouKd6IwnCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gvW/yfvn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gvW/yfvn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C750C2BBFC;
	Mon, 10 Jun 2024 14:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718028531;
	bh=HSsioY+DUoQtToi7T6Hh/koklrpUxkv2OYPn8xxif0Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gvW/yfvnVVF/pkREooiIDZ1FI4C5x3vvT2A54r91ticyZRqEW29bBRuDEw13FSstm
	 tjLkbyjzI97e1HFpwrMBEyIcSj8kGohHJPWryHjie/fUox8+m18iuKlBA1MvtBKqG8
	 cKpxYebuC1ev4qi935yx7A0HZolW5c3BzAf7+oX10f99MVtP4+xzEocm+bG6tzw0tA
	 y0ntrvBXP9+cdj7HkfZJDxPi2OHDASR6BAvyZ+7duNGjXPirTiW7D1v5NxHcAGUdNK
	 /g9hC13yMpupkpIn9R+mHF/bcV/yN/x2ccmAk79Oy17Jz9587UMoqVFus5yijFYMKw
	 spQ1MNpeXt9vg==
Date: Mon, 10 Jun 2024 15:08:46 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.9 000/368] 6.9.4-rc2 review
Message-ID: <ZmcI7jNPBAvhWguf@finisterre.sirena.org.uk>
References: <20240609113803.338372290@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="xunVDCio8iCemgtI"
Content-Disposition: inline
In-Reply-To: <20240609113803.338372290@linuxfoundation.org>
X-Cookie: Your love life will be... interesting.


--xunVDCio8iCemgtI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 09, 2024 at 01:41:29PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.4 release.
> There are 368 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--xunVDCio8iCemgtI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZnCOsACgkQJNaLcl1U
h9A3TAf9FQcphJn/FTC9Q/K1GB0ioBOtJ7KGH3KtsBdEP1aGM5Ugds1+stlsayRJ
bce2aYm1ErHQO6L0P2NJKInRDCvxztoG+jGdn1TFUfljV5t6oT12pNxFfSxxdP1y
/Q8J6++Mvq3eHKUN3fFLkHSsxgaW0L2bxon1c7gWY5GqKTwScLnWf7kTpKYz2C0e
L+RMPqzbRnsyxyMhGaEJF64YhsBxBRhQPrOqKX6dsDCiz2AG4BTb+wFHBVsodU7P
1n1NiwWD9kWNIWYPoRHFWRcaqZ8hPLUOocQ8NlN+BAZosZ19a7kkj+thyzGfTymb
/CNzURw1kuIDC3jZ0GkLoXPPgZmjRQ==
=kJsI
-----END PGP SIGNATURE-----

--xunVDCio8iCemgtI--
