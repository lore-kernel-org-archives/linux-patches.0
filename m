Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E051C5486;
	Fri, 31 Jan 2025 13:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738331016; cv=none; b=GjMgK1gdFUGoL7n+MKFzhy6XB56PmUy7zTddSL1ghQM8Nnq+NIRXJb6z90RuVSqowotDCrKCqCtRZgpMe234yVGsmFta6VA037eWVft2din340FlLHtFgvv1wOAZa+cDNRb3QuybhfWvhfySRtfY7uMeL2xzxs8Sv5BdsoBIyRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738331016; c=relaxed/simple;
	bh=Wvv6FFYOwOC4/578aeyYizzDwedLKRkV5V4edJxFKQg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=orYWBMqZ9BZKbxO2uD7hv+JVQJ/eKxCsMXmVYLpvdKmFxHBrFqNeqKDMJrpRlUnmp+nUwNBJrIjpZ5xghfcnoZzW7Wyxznhn9LfAitBLMwRqpZlyyR6TUq/dOvoiYBZDj5vgZRyJJlu3QLDYk5iyZGlo3QUpKx2wq8PKciTuHrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=stT2LwCn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="stT2LwCn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0DEAC4CED1;
	Fri, 31 Jan 2025 13:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738331015;
	bh=Wvv6FFYOwOC4/578aeyYizzDwedLKRkV5V4edJxFKQg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=stT2LwCnSXSHSS/8fJJ1nkSW7279xHnxVNxUprFzjy1BHXM457GotyMyaQ8HqntnN
	 xyFH8KOlmA2vLPJhKFc4SvoQnca+ct0faqps2wGxtW05lpqf2RblvdWR7GV44nfZJ0
	 j8vnPIj/LQdV/92F4ePtxPpH75Y+5diCR1o25icBl0UBYNMxgUqb4s19s82cw9b9XT
	 fJ3KMCeEF8HuNqTswvioK1z5jBdANZpVoiJlg4QtAz0itgzN27eF+93+fVeD5C1MCu
	 w0Nq3thZMBF/yIIEkbG8LSBYTo/4mzUl77dSrRFiIsbOkYUXxwVxjs6UezSfvON9V1
	 0L+tju6t/aiLA==
Date: Fri, 31 Jan 2025 13:43:23 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.13 00/25] 6.13.1-rc1 review
Message-ID: <Z5zTe35ACYQ8UP2t@finisterre.sirena.org.uk>
References: <20250130133456.914329400@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Vne8qjNMRWO4S6BF"
Content-Disposition: inline
In-Reply-To: <20250130133456.914329400@linuxfoundation.org>
X-Cookie: Editing is a rewording activity.


--Vne8qjNMRWO4S6BF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 30, 2025 at 02:58:46PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.1 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--Vne8qjNMRWO4S6BF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmec03gACgkQJNaLcl1U
h9DiUwf9ECXyCBLpd5toRynjseaFJDHtNU57BmNX21f6ufjbuRw0oPdDggBDjaAj
SdwtRO0vH3tXa6IHWJJA564Hay5t9uWTvsgkETtFDGSKkuKxIy3iRJHOORLUb+SV
/NdFYEIsPMY4Fn6dfhfGl5WcJKfgQnIMirl+6LCCpzQMEkkxktPhiZVHPliip4Y6
1P4hgQRlYuLUr0o4pahRJ3bcOlZmbc0533rBYNDkCepTqy/QoCtCDVO3IaCiamf0
jhnuMzsj14rZq07tmwM3e6ccTnOwIVrp3YwjE9LzrYIWX3m8Cyb/lfZcRtXHzi3D
IdWZXbHTbT6b4NZKm0wDbNh5yZ+pJQ==
=c7rA
-----END PGP SIGNATURE-----

--Vne8qjNMRWO4S6BF--
