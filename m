Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31FC351C1A;
	Tue,  3 Mar 2026 18:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772561979; cv=none; b=RZyvmCtTHnTGOtxBLqe9B6w0FBFJByjZfaL7WhqklrBSgAGhQ2JOoSAs0pYCQTEJus3x5vE0T+qB3UIwT4N2xs1cZ5SPX0ko9pnVg/Sxgn+JrDTWyVxlJbp5kK4u/v1rvLrqWkWpoMJ7/cbWiJZbXKy2CPCsLfshlDD3YsaQAt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772561979; c=relaxed/simple;
	bh=TjaKyUFWpk5wQ96hQrz4ajVi0UYkHwtxqyusk+pob0g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tOKbRFCwaR6TF4OnX1Z2o/CTHkYr9xX8ipizi8uRpmYRjIPSSA3ibm34dIc9MhUk0DMKDLZH6+pIRKe3JTBjmotUqJh2W87T31pbjyABIZdyDdMtFCt0E7w9f8l1i3pQDyV0CJTD8jkMP9HybNelqDL6XoL98SFL9AFXQEWn8GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LoBAJHYt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LoBAJHYt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D7D8C116C6;
	Tue,  3 Mar 2026 18:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772561978;
	bh=TjaKyUFWpk5wQ96hQrz4ajVi0UYkHwtxqyusk+pob0g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LoBAJHYtwYqv/Q47/2/ZVS0SufTVVhjvWPNNHKO0i8IkZOosDvB8MjtYrsR8gaQJr
	 5rbp7D9AuaV41yHZQmn5U33izp0U+80P2J9x26bYkyXBh3j+kv5cZgygs3Sb1HUgvc
	 +wsnChUhs7qQWbokGi6QmxJS0hlHJrP3oDylb6tR6NbEMBpmhQCPJu3wDCh7W8ne0q
	 u3bRKUr71mWz2WB4fkccAJg7nG9D0aK5CoRWaDwsds4/ifh9nVsc4EH1Vl/UfHr8Xm
	 xOJg7BxYQuC5fpTxlP18cCkNyk+Jo3ti6Qm1B94FMJjaUWVyIaLBXIgxHW+hzWBx7W
	 eYfbnRvlb1cXQ==
Date: Tue, 3 Mar 2026 18:19:31 +0000
From: Mark Brown <broonie@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	gregkh@linuxfoundation.org, patches@lists.linux.dev,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.19 000/850] 6.19.6-rc2 review
Message-ID: <2c284e20-1e75-4a6d-a41f-7b1e258264d2@sirena.org.uk>
References: <20260302160834.2518716-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ciq823Ti/9LOO70T"
Content-Disposition: inline
In-Reply-To: <20260302160834.2518716-1-sashal@kernel.org>
X-Cookie: Use the Force, Luke.


--ciq823Ti/9LOO70T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 02, 2026 at 11:08:34AM -0500, Sasha Levin wrote:
>=20
> This is the start of the stable review cycle for the 6.19.6 release.
> There are 850 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--ciq823Ti/9LOO70T
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmmnJjIACgkQJNaLcl1U
h9Cg0gf/Tvs0+InnDsrf/Gix4rDbXXxU//OJNlBrn+Fi8hUH/pbKea91Hw4Wwi3r
yjdI0dzwfdMxtAIRxaifuxsQ8iqDMM3u6ETtdFyuf/oxRcIQh+YKL7IM2+WdeNdN
aha0F6iZlcuK0QnJ6MxrOqS0cP1xr7tICVPPhq9aAuULCQSiKjfSM6f+CXZXEoLH
8xz949r+p7ixYkIQ+p/8+Z0YWWgTU5Lj1GS/evqS2uEEAXX6AOj5Ss3qhO0DOF/n
+dqts2LQKy+W2PMeCICMGvuleslSmCqLM1vZ/ZDYnsZ1LLTN+5Zh2F+CMdZibYLN
0O6hPvOaLzQMNGzQTu0O98L2BWC95w==
=sr5t
-----END PGP SIGNATURE-----

--ciq823Ti/9LOO70T--
