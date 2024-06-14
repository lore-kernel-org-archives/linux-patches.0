Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3382A9441;
	Fri, 14 Jun 2024 14:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718374473; cv=none; b=Q+ka/Ped8/N0N1iSe6rUXaWBAsHuhN5BDqjZ4gXVnRHDOO1zTNQxbrnj/0hbNyWb/SmWgpQSDmvq0rnmBs8A0diMEbkay6qtaYJ/Y7lrmDS49i+nNX/vwMJIHuKftlqgGKE1AxjCU+RseYVU2wfwT2rxhF62T1lSrdAqLhgOGZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718374473; c=relaxed/simple;
	bh=9ye5B3kfFJ2fP0P5W6CRpUID2mNS3u3dhUpAYlcZavw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YUHmUKdohx3TXlImPxRqWp47I9pr8e5bilAxCpAQCErdUSOXKoGK6JAikhVotZr1CFYJZBMuwHBaiGg4nsob9lG/HTE+S7MIv8ShLIeRwHHpNbtfpuZjjj68xHz3/RPqLRzpk+HTiNWILdLLKL1fSKggX1DvwutcvWaa2dVRe1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k8Y//sHg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k8Y//sHg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98674C2BD10;
	Fri, 14 Jun 2024 14:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718374473;
	bh=9ye5B3kfFJ2fP0P5W6CRpUID2mNS3u3dhUpAYlcZavw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k8Y//sHg/5RPKt/IlULGVMo9MvpnYctJFKryj/8li3UokCV9BMhZPPJWanLVYR+rg
	 8NQi09i57P7UZvw1a1CjdYmPmrvfbA3kkyqtlD3Q9YR84MmliWYic4wxD8pxW7UxLp
	 kWqyGw4Hyh4L6JoPqCdBYYtPompzGiHPJHQRY0TK8M9GF00Gv0T4kNT3b3nZ9o9o4L
	 B+6oJu0OVnxeYwBXeLEzkyrbxrDqcDU9uEsn85t1mQ+EXt1ToKtc+LWdrqRO0TovoM
	 uuDNVMJ9Cj5ySwySjsg7UAf/vLAI8TLIZT0WBftSPX+fWHS8TqnHnNv8UGTzGRVq8i
	 sbJsX7LoGLMow==
Date: Fri, 14 Jun 2024 15:14:29 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/137] 6.6.34-rc1 review
Message-ID: <ZmxQRa_2eIf6nnm9@finisterre.sirena.org.uk>
References: <20240613113223.281378087@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="VIXTKy+nbK36mps0"
Content-Disposition: inline
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
X-Cookie: Your love life will be... interesting.


--VIXTKy+nbK36mps0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 13, 2024 at 01:33:00PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.34 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--VIXTKy+nbK36mps0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZsUEUACgkQJNaLcl1U
h9DtYAf/Y8LdAXkrHV7sfgW2KMlZbxbnI+8eijbO/skUZ5lBDGc3YoEJF6OQAjlp
uGbV/U7foSO5c9AxxVKMM5A9POTlz2ZWrULl8SmN7Mh+OaK34muAPfyG5UuKy2G1
5Zido6l2OvYyJM9L0ZpheGMOJUp+AVi7Z9On78ftxV/bzXatfTiMpsapGqSiI9gd
7OpODN9c9LMHq590kVVa6LO5CPIIp+CgJu2gc5jIduoQEAB1FsbxTwCT0n0IhgG6
L/FmEP7+8hCX4e28Ic5JakM12s9Lhzbm3jUoq2JWh4Sw6UlfwYlHCzhsOmOhezxj
OMwcYURw3lYc2u1UG0vhcDuDJJ3+gQ==
=W6Tj
-----END PGP SIGNATURE-----

--VIXTKy+nbK36mps0--
