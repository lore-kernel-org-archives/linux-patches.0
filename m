Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880FB4570F6;
	Thu, 23 Jul 2026 15:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784822066; cv=none; b=LD9T487j8Tri2zVzOpvCCKDUMgXEgooQQxhqDp+iExc1w4du1zeikCCmgdWb14Px7bTZBo8vHkm5jl6QedS9QVJuAXR4Cmg5hp0P2lAdSk6O4wH7I81yiHi8zLj6txgiWpbQluEj0lgm2vROvIaOuFvb74Rv+cgo7ZEkPZBajzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784822066; c=relaxed/simple;
	bh=oAAdQn2lm9BgCv8DHVbBNlDjpSwehQzZAYUZnabeFMY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sPYTFDh45YWhmq6RAbtuf4kPyuLzrNv1q2nXWAtKHPVQCqO3blDyxSwb9/cQJ9PEcoCvUJdHfV3DUX1v2PzIxcQjxj2w9la3jKkJyBAjPxMAMBbCsA5qXoQl1yqFytjVlYtDQrSK7u3wvv9octSqkKdJL7K16W4++uGmG+Qd3bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QHLE/c+7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QHLE/c+7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3FBE1F00A3A;
	Thu, 23 Jul 2026 15:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784822065;
	bh=XRhnmdoHtmo9NnNAk4JTciukS5h0FMY0NdWsHY1ryZU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QHLE/c+7Lo30apvLlFLHKWtjauPYbbxx4HFUQXtDnGi3mai5ye5UxPWHKZHfMBJw3
	 VsfUmWJwhYOam4rTVBcJIHBEYdss5JXre3xS1/W5L1G4AFTarvLDXbA0H4WZQBZOAX
	 C/DhXLHir56VRfN8MuCEVp6JjhaIRnd+N3fSXmy/2L8PyqeW2+jSWKHuatvgDRq5/R
	 3hie+xWDRLxKs5Pa9xaZW7t9gDbTCGGA7MBkzBCWUKzARXhMhsEDW3cvAPjN73sCLz
	 FMu/mpldCiwXnuipbWukknDcK+ZwiMcjlpRh/EX4j9nwC2YB9l9/DfSXH8iEO7mFcV
	 tk7tlYokSpycA==
Date: Thu, 23 Jul 2026 16:54:19 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.6 0000/1226] 6.6.145-rc2 review
Message-ID: <32a043a0-6bdf-48ba-8649-1c5539690905@sirena.org.uk>
References: <20260722143258.264584003@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ePzcJUAb9mXf34+w"
Content-Disposition: inline
In-Reply-To: <20260722143258.264584003@linuxfoundation.org>
X-Cookie: (null cookie


--ePzcJUAb9mXf34+w
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 22, 2026 at 04:33:42PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.145 release.
> There are 1226 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Looks like I'm seeing the same proc read kselftest issue as I am on
v6.12, the bisect is still running though.

--ePzcJUAb9mXf34+w
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmpiOSoACgkQJNaLcl1U
h9BrEQf/fLpmjUxny8Bz65Re5SXBCZ77uqbLRfHJc9Mvj6rUojYYuqqVjBFRwVuX
ZxshBDKXIJrTeNVdKzMyTz42vR1HsYKOj6iNj5kq/BwinLRmykQqAxFlMiTVRHTy
2iGmMdmlZ2S3EL63RLByHpnDGsLMFHmgaHG4sP4nPAjX2vyKz+VVc1S02VRZNqiU
EXDRT8pbfSyJK8th0ZSi8sUpBb3RsdwQTlC3imRFJuufoqtlp0h/Icgxtz26rXo5
JL2cqJpsdigM3FppJ2khh6JPQ8qieVFQY7iSrSI4Qk8cfJvyrx1AsDZe/hdD8KG0
ar+NoV8mblddtKpx4iSv5cPAW805Qg==
=M/cn
-----END PGP SIGNATURE-----

--ePzcJUAb9mXf34+w--
