Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850C61DFE35;
	Wed, 13 Nov 2024 13:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731504593; cv=none; b=LwfCMNT0YPa7Mk6lkDT8ROiIc4HB/0MBI6jtpaYQWVUhXzUc8N5EoYjT3uAMRgxVGIoAZQ6OCzPWgZT70vzoZxVmcNZGQXlc3tOmLVMiup5vUBtaGF1pKOxvjVfHZdvCXB8HFgnOzQKV/eEWxcBcxNQk79Xb2TIPLRxX4/Pbqyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731504593; c=relaxed/simple;
	bh=wHvtxS8VQ3q4xq3v9I09VUAdm574E22RnYqzRFQhEx8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AeGaqwfsm+P/LiuXF5RQuRNIJ+O5z0Iy0X7FNTJJLyotG2Fddgrfp99F1tZjUjP4HgAY7YZIgcki6asoZ7Mm1VuNQbNKKWpOQV76fPU92WDBJnFPwxgsHjjarhuPwdiQ0KHPieeQUqB//rpSXzp4TvR+UOJ8V/iYUEHyt4pridY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HJb9nNXD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HJb9nNXD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC19C4CECD;
	Wed, 13 Nov 2024 13:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731504593;
	bh=wHvtxS8VQ3q4xq3v9I09VUAdm574E22RnYqzRFQhEx8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HJb9nNXD8O9COEThnNHO8itxfitDL4CbVoCyp3sNYNFQ00diln+Ct3QvjuDHLWnAc
	 /9gDrVkUooEdEX7hsGQALEmTfScL5MP2XTboJc7C2IR2NyFf6SpvTZ250Gl5wLQ3lE
	 D+mLVvwMlFCwFq/b2g6Qtxckry/JZ2Oa/n5dFfN/cF9epoygLMzRDER2gHs8guDDw2
	 QU5rA8mdeeB4n2PhFHQ7+ZerbTrpxN5zh2DLgrjwkPoOrxN4ntdNdvnA8e7xYNRLe5
	 1Ckvd4SU/BgCxYJex2sp29F+wughwkPoFqNW0/x1S6ysAFL5w6qgSmqBLxxhqI0o42
	 k7nZz9sm/EOog==
Date: Wed, 13 Nov 2024 13:29:49 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.1 00/98] 6.1.117-rc1 review
Message-ID: <ZzSpzVArSZPYMnNI@finisterre.sirena.org.uk>
References: <20241112101844.263449965@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="cxDIe/20v0z1JlTW"
Content-Disposition: inline
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
X-Cookie: Editing is a rewording activity.


--cxDIe/20v0z1JlTW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 12, 2024 at 11:20:15AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.117 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--cxDIe/20v0z1JlTW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmc0qcwACgkQJNaLcl1U
h9Anlwf/d/kOJuespiaJC6zMGDEO+I2lFD7pHwaTSrNQCxxbg29UtkcBFFxHIMqN
vyy+zLTx5v5jNp6yd1Tq0QsXuc4bJpymm6Sxa7OzGu9+8JN6VS0N1bfkPptn89JF
4+ik3Of+gr8uKQ7++VeDX4VO29t2Vns9wv5sJIdqtmOVQ856dhtuqaAimNMC8KE9
lOARUdeHBiAEarhPOMjEhCLBjYQHy0C4GO2pTYpaw3WtCMmngulxJ1XAE5IELyti
sHPmHVnDyWiAyzGW73sSzGxJSkBxY0Szvf1r2tOzxBTJolecOGXd+rJF7bxyW9LH
KsB6+PZ85arTho13S9w1qn+lYgUs5Q==
=Zscn
-----END PGP SIGNATURE-----

--cxDIe/20v0z1JlTW--
