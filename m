Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98DF1E1C02;
	Tue,  7 Jan 2025 12:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736253411; cv=none; b=udKId3oEa6FrV/HKFDeu2nnukGA8EJlMXTHcWPMXR6nIJxw6D+l3kibE94pgHP7vcpsuYYoWLX2HYTQZBUJwiRPk7g6iE1Q8txe+nScbImgOW9hm8uzlTMfdA9NlTkAuC8hUrgJ7oNsG21UvfXeiJePASUMS59r+RHy6QtI6+bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736253411; c=relaxed/simple;
	bh=AVACQt3e1/BFWE7RLfTIlLxQftyMwqLMmaqhfdYWBF8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZNQkVCp/NqlyrFEc6juWZXVLCa84TMjTh7iPBJAeZdWR9Dj3LaQa3bCQYqmyQWlMVrqcUbBfrQbu2p9WkyYMsh2ESi5aCbK3qIUAazm/nYy1uVnKBTp2RzsgH5CZZ3BVxU1RpR8yQaWQTmpcJoMTEs+VijxqgJzMGxKMotVrboE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZJf7LVaT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZJf7LVaT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB33CC4CEE0;
	Tue,  7 Jan 2025 12:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736253411;
	bh=AVACQt3e1/BFWE7RLfTIlLxQftyMwqLMmaqhfdYWBF8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZJf7LVaTsDRE3LqJRm17yMa1BHenmCeHbco4KIx64Q/1QD8U+IaQkFX78TqS6PREC
	 I8eCE4rWxmUlgDDrxLfXQGsBZR6cXF2/qOGIXuhtAG/2BA8SmEe2IemMaEDQPRDCkE
	 dJ2BUf0PUrHUOq+wj4SlR0RQw+W2DP8xLAj2TGVwVKoP604RaQASdFiw5xTwE9ePvp
	 5WlrSkpnCyYbBiNVnZQejI3TqU9RLa+5pK3dd3QfBv4fy4DBnKaCoKxNDdSGo9oLVH
	 89LNGQsA6Z1a15KhdvA28ZOBzpXVGhy7LbYNubiBkLv/NwrMfP1fHZl4qtkvB7BAam
	 BNwzor40PQq3A==
Date: Tue, 7 Jan 2025 12:36:45 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 5.10 000/138] 5.10.233-rc1 review
Message-ID: <c5318335-8505-45ba-bda4-e39f6b996dfe@sirena.org.uk>
References: <20250106151133.209718681@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="T9d/IDm6ZK3cjxsd"
Content-Disposition: inline
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
X-Cookie: PIZZA!!


--T9d/IDm6ZK3cjxsd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 06, 2025 at 04:15:24PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.233 release.
> There are 138 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--T9d/IDm6ZK3cjxsd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmd9H9wACgkQJNaLcl1U
h9Aqrgf9FF+cKERCqTIF49sQHXDnqXpckjhpkmSJ5CsstnNFaqn/cBFp6nW/aCdW
iIs+tDxvq/IKTeCOZBsHmIPvHdfZ053fuEnJvocRtIu9wqmhR8cbKgTdLOLa948j
q8fxu9oGD+pluhFMpN4bzbZkaNrz8m8Kw6dlBTSMMiIQAnMy9VmMI1mmD2XynnM0
4ffbq3S+D8E45wAWgOGF5kRjxwHcvSYZV4dGrUSbqmtkgvyISu8oFOaAumB/frKP
rjlPcfO3iQJNjHVHsqniHf0uNlLciboM+05O8h0L4Isc1xixzsQt3ffFUTEIw0Lg
RWGRc3MHN/LKZU7cyfRMTjTEQG1pjA==
=hJAe
-----END PGP SIGNATURE-----

--T9d/IDm6ZK3cjxsd--
