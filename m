Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6551421FF48;
	Wed,  9 Jul 2025 08:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752051016; cv=none; b=DZmrb37icHNlqR40kJJnlJP+8Xmn1S/w25mHmorcn96P4zFW2xDgN7qu62EStluEQjyahVQ4KUglSrHmCJohlPJ7NOyGWA/Gi82Zl8uxGOQLvJJXkGglAEPmvuoB/4fCOVxkBy/WY/X/a54Kn5nktLFVxa/3vGIGEJLEvY9hOrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752051016; c=relaxed/simple;
	bh=MZ3fTxayb9QH+0mAoQ2H+gidpz5HOOdRCgkyoP4xFXk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a0ZRVrBQLq0uk6o2Gu21w7Uhicln+zNfVjO25oz4bPE3NrkD/GrGvilyIVRiQhUub1KOj2sNVJP9mPYv+aSfXUThpiY/HhQdxaT8G8Z8Mbqtw2262CycgHTldJPebi0c5mKKCv8mMU5+A7/WaRdXYzt0rrUfQqTbrdiHjOyUZoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=japk8Wlv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="japk8Wlv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0087C4CEEF;
	Wed,  9 Jul 2025 08:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752051016;
	bh=MZ3fTxayb9QH+0mAoQ2H+gidpz5HOOdRCgkyoP4xFXk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=japk8WlvbQeK4SkEVw3pNyfiw1iLj1J6FrK8WV0ISZNGPlo1lJp9kJZoEPKIiLa51
	 mD4h/5nWgR0m4WiVqmy7Apn5HiBnxIXX/6sev8zZCc9aEgfmEyOZVq03KOHvnV7dwG
	 HR97LpC9NHmshOuw+ZbbUmqlOrVHd9cIM9rt4b6ilvETIYQaxN75g1rlX5wXQbdRc/
	 bBiJzPF6nHkzDbJjr6+xgGwFA35RV2MaNOteQ10z636ryH/M0V/jHbKI1zqetTy2tG
	 opITv/vd1K+UkfILePv2r773BzjCj5rrkU4K+vkB4YKdLzrXQ9eXjy7CpzA5Yap7yZ
	 lQCQ+j3qYFmTw==
Date: Wed, 9 Jul 2025 09:50:13 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.1 00/81] 6.1.144-rc2 review
Message-ID: <aG4tReesyH1dlDkx@finisterre.sirena.org.uk>
References: <20250708180901.558453595@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="LHEpxianzk80Rxc+"
Content-Disposition: inline
In-Reply-To: <20250708180901.558453595@linuxfoundation.org>
X-Cookie: Do not cut switchbacks.


--LHEpxianzk80Rxc+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 08, 2025 at 08:10:16PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.144 release.
> There are 81 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--LHEpxianzk80Rxc+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmhuLUUACgkQJNaLcl1U
h9DoiAgAgAI+elzTorEhdgX9NzRFhQgLfgBpN3nANwmxme3PePjGGVW/JSFsjIcE
IZl5C/f+CFaRDifXGd2w23i3hhCs/GzUojW+xgak4ilf4agcAt/z6yaxSR4g4YeQ
TgVlWQ2wA/YMj/O1KRA36+lewx4wnG15BZQGHYMn6fztmsntmXTOwFdKRo+sIgr9
RDtSztsxCC2G3jsDjbJfZgbH1Vnrny4seSGhrku/B1x36PGjdNmIZZrAxGVK6xWb
Ue1cxsJQVmEKIfItns9C5wS8p+jqMFwNfCZynrfJUbyaIkBPo+FLIcMS+2Ls8vFg
LoXE+7umTzGPrszwFnYk5Ex8QNa1VA==
=qFPz
-----END PGP SIGNATURE-----

--LHEpxianzk80Rxc+--
