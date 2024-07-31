Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C281799F;
	Wed, 31 Jul 2024 15:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722441277; cv=none; b=cgs0u/EFNFARr+W6PpgS1pK77ZykuvVzJ+DY1lgCHcgpUp/rWSi/gUQ/+rkLybHwgPK7fSUXdn71nIyeTLu5I8ppbxIVtDNJyDbqE9y/n+wsXEmboIG3DLPnNuRdVUa1kC9oiOyiqfxdE58O21mNuC/sjPXCUl+tJu9FP6a2jzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722441277; c=relaxed/simple;
	bh=QB/+oRrzERp7DM97KpOzJ2rbZl1zjzVLdZiMQA3ZbIg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=thcE8ReHgdHxSc99jo6uV+0xRxYFTK/vU+ursKY/rkL/bt2knSKsnN1AdYRHRxExNX1lrwCLtp5MARRUUsXXb0pjUfplEsEi4yrtmG1zix5JjJ1I7GSSP8QbApp0Uricme/WGSe0wJlu83SWh40vML02JcuCUmjlWs7LXI9omMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Akto6h+Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Akto6h+Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A467C116B1;
	Wed, 31 Jul 2024 15:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722441276;
	bh=QB/+oRrzERp7DM97KpOzJ2rbZl1zjzVLdZiMQA3ZbIg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Akto6h+ZxZrA9Tr2b/3OKLTudUDg/9UN/tYPgKlZ2pOpH9a/1lNPLCXBFaYJVBLdD
	 Ii36GLDGzfKvUo5YZcpM+R2zW62G9j7lgcWJnMRaOwEKaO4HFkbAJP1NMxHO/o6CU8
	 PsAfxVD/TpvTHv1IBdMXyq3gu6k1zRXrS0OcklR9V+PcrzXtKJeYyHYMosRlBQkxAY
	 aFOsUTAbImzIPCmcG3VaPW0UqA136q5j3GR5QR0DUUdu/0rOryR42+B+breO8z6icL
	 khfJZ5AW4mJ9h5yNxV0y3FzjQG1brOYA1pspFkDb7y4P5F3omFFF/Xhcnv61+KUanr
	 dRjHTCD1jcGew==
Date: Wed, 31 Jul 2024 16:54:30 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.1 000/440] 6.1.103-rc3 review
Message-ID: <481386a9-e85e-4923-be7a-f95e783a112e@sirena.org.uk>
References: <20240731100057.990016666@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="gRTQ4DHMYcmn+phQ"
Content-Disposition: inline
In-Reply-To: <20240731100057.990016666@linuxfoundation.org>
X-Cookie: You are number 6!  Who is number one?


--gRTQ4DHMYcmn+phQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 31, 2024 at 12:02:57PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.103 release.
> There are 440 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--gRTQ4DHMYcmn+phQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmaqXjUACgkQJNaLcl1U
h9Anawf/Su5y8CkNmA5i1IbvNfqjeQufcLBIes9TXxqkphGmY5n25Arkz2BWk5TU
judfyZfiXxNnyAkyOX9KBUmfjiN1leoNI4NBPzdyW9GIhBd5pHIkhq1BGzuqnQQp
vTClR1ee7I4S/qpVx3eKgxjIhAkzh27NDGEIQVurrkG/SQqjpsZq6FsnnV9BQDSH
2i5ZfDDvp1Fep/t0bijahVqY355EhKZ1PPZQyigjvFpLYmiDA98oli20aCrvDRXL
9+38wKOBqlaYwXBhp5D8yIXFpIAXMPCqpin3bja2orSvdEadpxlqY06DG0SJXU9v
318DOEa4PGSpWk6nqxWJ16iSfNNybA==
=Zzhz
-----END PGP SIGNATURE-----

--gRTQ4DHMYcmn+phQ--
