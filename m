Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85EB443144;
	Wed, 15 May 2024 16:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715790098; cv=none; b=ebJRoThFPQZ7gWoloqEAftDkSslrTkoV2XI2WuvOGGoPtXfMjN+xnbVVMFI8YExdUfZQ9XQ68h0obWpo7EW401G+XiBUyasmipZ0t39TvKsAKrKGPS+F93U4W6zFgXXRAkw/+RPwSbYuEkT1dhlRV7PyvseKPUL8MCDMJ84S8Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715790098; c=relaxed/simple;
	bh=j/DiO7Wd6xtYPXYFy/gevA07a1MmTHYcV+/lcsix9+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BugUO+QrOVVS8n6YfnWQv4fV02fMs2ZjPnSKQjfvaQQEjQAokVjGqq35onQo3648x6FM41jTuClExEQubVILQqjxHoANFm/ApWqZWqnTCHOOaMwhgRf7hFz3JcNpnZ9mmSUVBNECs6pGuJauisMdVkhmkLQgcHiSAhNKOObn/uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QjmFvKiW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QjmFvKiW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B74C116B1;
	Wed, 15 May 2024 16:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715790098;
	bh=j/DiO7Wd6xtYPXYFy/gevA07a1MmTHYcV+/lcsix9+Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QjmFvKiWzTzpNi//GtMILPSKQ8/ZwBwqFr8rnH8saO6P2JNrjcyOcc7GNUgMuAmXY
	 FcOOdp2If047fWB9aFJF7fUGMsTkxIjd7QdfqwKCkLL4iGG9eeZ175heQXg/g0cT1g
	 IDHt0TPyCZSm/ahetMC2ZpC+wFlvInuBm30f6MCRUVxjeyuChBJPDXTFkmJFZ29Uyf
	 FppTYfyldBpK9RQaDITFeF0QoYaNBBOE4IESkO5DNkazUv/10zThrF4DAeanQX6xCj
	 7QMT+heQvzibtaRfVbxxB3ivD609XH8B+tQn53+SNimys9Dceh0OhuYB6f5PeWn1lU
	 qlJiE+v60HtbQ==
Date: Wed, 15 May 2024 17:21:31 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 5.15 000/168] 5.15.159-rc2 review
Message-ID: <180e5df9-103f-4d46-8ddd-5d75e251e9a1@sirena.org.uk>
References: <20240515082414.316080594@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="A49cTM2taokuq74Z"
Content-Disposition: inline
In-Reply-To: <20240515082414.316080594@linuxfoundation.org>
X-Cookie: When in doubt, lead trump.


--A49cTM2taokuq74Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 15, 2024 at 10:27:48AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.159 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--A49cTM2taokuq74Z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZE4QoACgkQJNaLcl1U
h9AnNAf+IXPnVqCgOQTrGn2m2+5wEdRKVA2qVUbhmkGvi0BRX1nAZ+h2QVxJx80M
fVo6xM8hBD+lLLDQnRq/uNEPsaejqybg9j/R1aOuSebx4lU8v0ShFfL6GemIP74+
+BaKDhzGbRRhC8yERhwFQU4l99HdFqYgSoDhujPHjIwiCalQaLRlzLD62cNHBtnT
ecoSPd1Af2y3ZzG8Lx1MLzAKyz/RO6G+11jEZAbBasOuTUeXGK2StqZKDshE0t7o
2aFCdhBJTd2tF8eWNQEPXA1VsimPtoGnYNK6QI+iaStpja+VMLuy/1vmxja+apmu
uQam14DTfcgZ7ksrqZnCxVYWNJfWIg==
=3/g0
-----END PGP SIGNATURE-----

--A49cTM2taokuq74Z--
