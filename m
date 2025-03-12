Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18031E489;
	Wed, 12 Mar 2025 12:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741782679; cv=none; b=il3hNFp2qWwQE72p5oTfE2ewSCYFHFta+G3QxCHmKsJLfNCoKJV9JdKbM1I1EnOJ8YpOSJAHj5NyVgksme0Tys6jh35EEbW2p7TkCX9VbkXygiP56JN9Q7NnZsoEaIMUwG5ctlzY2y6T9eBnN2InrcACD/Q1rFb4J1jkzzjbOGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741782679; c=relaxed/simple;
	bh=uk38x0xYwVnHEKQwByxFj/fJlgR5LnKoEU9pVaDjRuA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ckyPHs2yt/xnpoyZPoy3XI3x6qsTn0khEpN4tiZ9OG2GLmND+BFWXAFi7YmsR+IboCNyLkRC2IGswMhPaoXzz/92rRrM7OAJ/TJ6yjSOgg24VOetBVpX0zJ3Oq2ddsq3e5pFSoGwzN4dko30kS09Bq7ZJmOw618PZSjS2Figqm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H+uj3pvx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H+uj3pvx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5835DC4CEE3;
	Wed, 12 Mar 2025 12:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741782679;
	bh=uk38x0xYwVnHEKQwByxFj/fJlgR5LnKoEU9pVaDjRuA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H+uj3pvxuXV5TiXRtdocxb1zdq9E4rRRf/P1u/ELDrkKyAI3mvnZXaXyT/Tq6GCAE
	 xRrrDGkfD/nrKQv7SC1JCHIgQS3NOyv9DKao1kTpYdJajphdaDSUJBg+fWntAdzU1b
	 7mnXnZeWhAwZLPZJnTRw97TxQIR3TmbXP1drYeDtHWMi99D1fOPMsBGZQUJ6tTyNjh
	 h6KEsfbqTlR3QUjAC92lMbFQEkUKxxYOtfsIxvjLtOumVbw7FcdQTxqU8YZh939/pz
	 v/zT2OLDTVuU4c02nSCGU/aaCczvrAhgstFisOLmhEFL9B17ul4anr2rGpGlSsXipE
	 EJw9iI+bEcAJQ==
Date: Wed, 12 Mar 2025 12:31:12 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.13 000/197] 6.13.7-rc2 review
Message-ID: <441a0550-156d-4a05-8d49-f8175002978c@sirena.org.uk>
References: <20250311144241.070217339@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Ss6u7OA97U/YVIbD"
Content-Disposition: inline
In-Reply-To: <20250311144241.070217339@linuxfoundation.org>
X-Cookie: You will outgrow your usefulness.


--Ss6u7OA97U/YVIbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 11, 2025 at 03:48:06PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.7 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--Ss6u7OA97U/YVIbD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmfRfo8ACgkQJNaLcl1U
h9Bgggf9Eme7pDVEdiGWQ73Q+QReXZyFphTFjPMxZPj+OSXMN78j2kiz43Dgh/hu
16zHUENiMLEf4OYs16w+fvswWN26Ky665dcOvzLVennenOcRq1UeYgrgRnWNyI4D
ku2g775ZR4wKaC+Xp5G5Ix/4Jd1RSrukylxDAAnge3WTlu7jz8HuZ4frmq/Xyk1K
qJYBW+W8fzHNShTymvwVeApyWZEDjAQMW3DM34IcDx6Vir5v7VcfSVZapuONMfMl
1Jqsm7rwbs+45ZBRrUokVmycy1eeLmk+IuhhheZAeRzRWX5clm7ZtIRXYbjAjI1b
V/TtygobaUBLCeNFsPRJWusydzAGeg==
=8eAw
-----END PGP SIGNATURE-----

--Ss6u7OA97U/YVIbD--
