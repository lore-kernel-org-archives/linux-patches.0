Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80741BEF77;
	Tue, 11 Mar 2025 13:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741699394; cv=none; b=GEzpXEzYqEnIe4XKY3CznKmoXQX4kyxxqQ4Cju49hGMX0M1sCBQKBi/JdjQeF9ldTeIgA4g20OMoQXFN8LzM7iHjH0MxhQVuYTlbsA7JG7MD3FFeGXdtjstJ1PUFeiTjx90z4q5vlMyMs5Sut1KdLSDjLEusCmmisEPWtYh3wKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741699394; c=relaxed/simple;
	bh=stCSZg1bVUYERKfj8UjTf8eb4UZHr/uQQsiuciGyyUU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AuvM/aUDGurLOPJiYF4eHzM18k5Awa04GPZ/XsvqQ6WK25GPWX3xOJtt9R+2vs0ryZn+d9BW/751HNjGLjriD+mlpg0n0FdHDPCKZt8v6OYFe5yIDE7RrbX2S6coLgCxBoWNs4f48t5ay2ODRdR6Yd6ecnz6WH8lolFnfUQLD4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H4hM+A1e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H4hM+A1e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C59B5C4CEE9;
	Tue, 11 Mar 2025 13:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741699394;
	bh=stCSZg1bVUYERKfj8UjTf8eb4UZHr/uQQsiuciGyyUU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H4hM+A1etlFalzn8eteATuPCuPGofugBvZgPG8D2NDKpQqgS6bYndY7UAUDb0HIvO
	 U6vMNZj6fE9uSA7C64nL/QdxW0TZmnPm0kAfADIFN+ys0qjKrF4nw7IgytgYcFjkOi
	 6VahFkDGOHjjpYDUbyurtjydpTHtiuK0YIccpToB0WLozxjHFKPM29kqJwZou2HlY7
	 czAPrZCwgcP+Wnk/bh2IlUrQaNutlL+ZoK/yC0YmYmF+hI27R1ohtOS4aF3aiv7Q8c
	 7Dr7Q5/rTxU6EaOAa/+BNyE30PDkt4ZRh1riNPjISAAmQ4I/rMDNginkq7Suvmroi5
	 cjYc3kftY2tkw==
Date: Tue, 11 Mar 2025 13:23:08 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.13 000/207] 6.13.7-rc1 review
Message-ID: <f301ae85-25b5-4b7e-9a4f-8d4917658c9e@sirena.org.uk>
References: <20250310170447.729440535@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="izFY2udIDIdU1Lyl"
Content-Disposition: inline
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
X-Cookie: Androphobia:


--izFY2udIDIdU1Lyl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 10, 2025 at 06:03:13PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.7 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--izFY2udIDIdU1Lyl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmfQOTsACgkQJNaLcl1U
h9DT/gf/fpXNlI4XMduESTD3lvtlbUd/ZleLVJyU/xVdYwbQOj7oKlL184/CCgmc
eKVI8BNBt32AnLMPlfoyQogbjIR99As5VTLJDVa6mLDaH9YMfy3OYPK0J6N2u/+R
faGvmvfTQ/ZjAMFzfPG6ewzWq3Ls3rDePatd28dIz/as3Sol9ceiuO+6WlpWPmY0
3oK+SHTAJ0Thxwn2PYfzQN9wz6oidpovmd2586ctRx8FCpeQennMkWAebxmJBVUr
BDX1rDXoeoUWrjYsIuG7QIoOv82JahcJfbhaJwYufjgcBo42Iru5IuQaB2orc9gr
lXWlrg9UDqhECvACzHO6Vdxivil+kw==
=jdkg
-----END PGP SIGNATURE-----

--izFY2udIDIdU1Lyl--
