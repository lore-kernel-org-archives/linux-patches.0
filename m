Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D8842E84B;
	Mon, 19 Feb 2024 12:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708346457; cv=none; b=OUsjKxfjquEduCZJqsjqNMcEyq9kMJy1xVMAYQHBBhoWSaQtBDgZ1VfHQPupA34E/6jdTSTp78Mx795b5wUaYGOI/Qa2J3WGy9aegGFePc23NXWmAG91raeSt9hqpOZCqONeicLAdUqJsaLQQjSTKs3LKjS0SHPGo4ZuS7Uzibg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708346457; c=relaxed/simple;
	bh=jmUJdSB2wU6KkGmGrk17u59RAa2VCuLrN+wGh9mjQaY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AC1qSYyax+ZspUHm86be6o3LJT5KzOznlNNMYCObzgHw5I8qMXO/rkT0JYaZrOLN4h0t0hVvkyll1Njp1ivbXXwlbIiGLLbujcqZFTJjVz6NU2d16IYb9QO6YNOoztJN/amT9d9Az5drT0fttDjB1R+a6Uc3AQgpCTFJWkFM7uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cFGrfpxD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cFGrfpxD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9348EC433F1;
	Mon, 19 Feb 2024 12:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708346457;
	bh=jmUJdSB2wU6KkGmGrk17u59RAa2VCuLrN+wGh9mjQaY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cFGrfpxD9iyYviPM8m0AMsgQf830hA1J0hDu2ujwF18rOIxWuc6a+281xM6MqjTE3
	 zqwLD7u1wcSFwDfkhKlD7j091JlzBZ3fy6zczzcevB13irF3gSlzSUHGCKJYi1dvam
	 sFvdS12XKWqhgWBxyT6+oLVos883WApZwfdCUfPbB2jXmFZK2JfIJuiWa3tfnewfIq
	 AlXj3h7L6MLzYbKl1JHEVJxIKuj/pJDZCCLT6A14NjLKlNpUsL97RgX1JBfFVy707Y
	 x5NkRRr5gncVDhjzMXQ87BFBUDJOobqPe/V6vZXS36uoPC7CuXmEF39qUKTirfaCVb
	 lF57FOCzO9ECw==
Date: Mon, 19 Feb 2024 12:40:52 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>, stable@vger.kernel.org,
	patches@lists.linux.dev, Frank Wang <frank.wang@rock-chips.com>,
	Badhri Jagan Sridharan <badhri@google.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 6.7 093/124] Revert "usb: typec: tcpm: fix cc role at
 port reset"
Message-ID: <e8b11fc8-6c01-41a1-97a7-9269fa95a990@sirena.org.uk>
References: <20240213171853.722912593@linuxfoundation.org>
 <20240213171856.446249309@linuxfoundation.org>
 <571afc70-dd77-4678-bdd0-673e15cdd5ad@leemhuis.info>
 <2024021630-unfold-landmine-5999@gregkh>
 <ZdDS4drripFkFqJp@finisterre.sirena.org.uk>
 <2024021752-shorty-unwarlike-671d@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="g6abbpMPWngrT1kv"
Content-Disposition: inline
In-Reply-To: <2024021752-shorty-unwarlike-671d@gregkh>
X-Cookie: Kleeneness is next to Godelness.


--g6abbpMPWngrT1kv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Feb 17, 2024 at 05:11:28PM +0100, Greg Kroah-Hartman wrote:
> On Sat, Feb 17, 2024 at 03:38:09PM +0000, Mark Brown wrote:

> > This getting backported to older stables is breaking at least this board
> > in those stables, and I would tend to rate a "remove all power from the
> > system" bug at the very high end of the severity scale while the
> > reverted patch was there for six months and several kernel releases.

> Ok, that's different, I'll queue your revert for the revert up on Monday
> and get this fixed up as that's not ok.

Thanks.

--g6abbpMPWngrT1kv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmXTTFMACgkQJNaLcl1U
h9CcPAf+LVZsc2yMDhWMF8suAnLDi71brnuD9Saj3OVqr+fjoLe8nFT+0Hzgd8h0
RSmibiD+K8FhMLx2V39AI9CCxkFMW0bd6xHNbhLaK0ThvnOItic4ywudQgKFirnm
uH94foFXtuAEoVzu8ZRby0JCY+2ynOj5ZBPm9sVBnH/u0npZWmUoJQyIuuGVDCMX
okp9dFnl6Mgwnnb3H293Dn/50CNeGckeOPI47ZtwBr1SrpsfyviYsZWn3Qp02Jv0
je1LhPn+1Ijpzeu6HkJzJNge/K5bJG/iLE/NUaGKUCfb0Y2TfeT3+LsW7ArGYs5q
4C+lwTzxFYc2xaPBn+2ir4oEKbkG3Q==
=VWxf
-----END PGP SIGNATURE-----

--g6abbpMPWngrT1kv--
