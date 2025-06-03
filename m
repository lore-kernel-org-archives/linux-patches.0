Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11BD023C4F8;
	Tue,  3 Jun 2025 17:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748971454; cv=none; b=jzVQdQZaXnQGtkQpi6x/3tBrIm2MjW9hxbJT6VqJZvw/6Rnkuwo3zjLM6Vomqyl3PZNABGAQFdQ2Z8zmX5mT6Od+/IdlrxUui811B02bGj3QtysFhx5sxPYqiCQlUC2NwVhq2TMFvjDkAPzCrv+YhNwF4M9tahhVXRUGs8CgxBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748971454; c=relaxed/simple;
	bh=Qxj0F9GgNws7VqbDYXrCVT04ww0pMh4YmDHVkPUe8sY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QB74jZH53Ksvi5D3GmjSnIKY10DpMKjSEYMsH6crxkbom5ujr0kUdLVFxJovw7RXzPUHZ8ifEjonOBWxE3sqzUlZC6/+IjKIFNZoEuYh61XpqukksamjBZInoYTbvMztHKhzK/+CCZ+HKTHTd57MAo+pBjuRn9ATQstDRUdWG0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eymGVV2q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eymGVV2q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28397C4CEEE;
	Tue,  3 Jun 2025 17:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748971453;
	bh=Qxj0F9GgNws7VqbDYXrCVT04ww0pMh4YmDHVkPUe8sY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eymGVV2qvZ1XGFcrV/y6+ll5sPYTNuyFoWRrrZIodK9qE/tXRdDRGZ75qNhter9ub
	 ES1gv9KVTuXnkUV1tVixuD7pTKlaGKNCU9xcKGsqPPYNsNFpvlIwW+fewZsjTP21j+
	 wikgY3cTM+rvCpDhQF73quHLaRfNSkYHkuLkn0aNl+IyD+VJeRzR1/gZ3EkENKgg9u
	 oF9QaLHPNbMWPKBl58o90V5HuMYgQXPGMww4Cg7Gf5njVyCPgcoDRRxH5o+iXwE5pU
	 qXAjFl2f54ZUArudGv9fH5OK3k/xpzAWWS4RQOhZeRlEFRlkdLHXo+BUcJzHLeZH7f
	 pt2uvJDGjNmSQ==
Date: Tue, 3 Jun 2025 18:24:06 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 5.15 000/207] 5.15.185-rc1 review
Message-ID: <3c228ebd-d25d-4057-b64c-4e0419bb99c9@sirena.org.uk>
References: <20250602134258.769974467@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="jx4HcvsQ7VzQypkS"
Content-Disposition: inline
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
X-Cookie: Avec!


--jx4HcvsQ7VzQypkS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 02, 2025 at 03:46:12PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.185 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--jx4HcvsQ7VzQypkS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmg/L7UACgkQJNaLcl1U
h9Cecwf+KyW4hHMftLVcMQY/fdvXu++kyrlKTaJQ2zxE5sj1200AnSFWaMuepg1O
Qx9ctGRpREOBMSYMIfsPee8qv5qVrWLSTf9wbLm5iNaHHtgV/zOOTDVk1bE3rrod
W0BUnQnXQKXUfnvjPt66aLcPSt2ScoAAvUzJmDv8I9NtI3Yjbf6Nnuk0jwBeCCi8
TUW8X/HXFjUlgE+T7FvtS3yHBpjG1+1IFw+nIRfSG8RnPx3BGi1r1HiKEtSxFi9u
ONEevKYFEOjKQrq4yUeABZU47p+wT1/WTBDpTTFbvYqdp0MjXprDVNz7BxSz2DJe
3ZMDu2Z9L/SkpVQ4gL1jDZKtO9AjHQ==
=wudE
-----END PGP SIGNATURE-----

--jx4HcvsQ7VzQypkS--
