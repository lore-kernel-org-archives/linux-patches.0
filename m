Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7AC1DFE32;
	Tue,  3 Dec 2024 22:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733263628; cv=none; b=pYb0+9z0w3lx0tUpBOtqwgxMaCElnNgKo5DBq3wS5Ix55yP7/oZKf0y0eD26i1eKQbYxe2hm9W5L+F8qTnw2BvhaNQSzxY4+ZOqirkOT5nSTbm9t+Gjbe6lpZeplH9kyHTvt5bHnXkqoeWWLp1QgzEo+EIMm0ScrHqkri62sB64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733263628; c=relaxed/simple;
	bh=GWxYgzj4r86MI4VQEMJdPVNto4mghtr3sJjKi1+fj24=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E78QRWyAIwja0qJMANkn43qhx2IJWGtBlhmBVkFgHEzXz1TxVmfb6EOaYmKTJ/LzN07ya5FOC2yhKUsNjrHRKVnLt6PJqu2kG4kds1ER9WhN4ESEpakzqVoX6hDlVUwcGx43Jc8PQrxJoBN0drDxjwWUhI0vZR33g/Tc+IAeEwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eg05D7jk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eg05D7jk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 474C5C4CEDC;
	Tue,  3 Dec 2024 22:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733263627;
	bh=GWxYgzj4r86MI4VQEMJdPVNto4mghtr3sJjKi1+fj24=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eg05D7jkJEmi/IVmpmRDBxTmwBk1YvaFOfEv+BOMRsht40g4PkvCK5wYb34piP6ab
	 xSdV4nAgKdNsk93rUnj0GSTJFk+wRFE+oRyhCl1NRAGFtGhx7Fcdug0dMsm4BqliJf
	 2RUYdMwFpoPWX/zY9sC/Tmzu0vZ4ejwVnKrE8NzE0GDOHe/uZHrwwNld9cw0wjquZZ
	 j3aL4X140bUdl1YBqlJEmgifuvmk/Vz5Rb6BteUmR7NroP/tUjhjtUoogV5q1Xu3sJ
	 Dc9Kc1a3Bw83U8j09ZHnU2CrI+O87FFih196TnLZuDVvCjNdEx0UB8ESmr+S9aGxKr
	 246OhyCXGv7Lg==
Date: Tue, 3 Dec 2024 22:07:01 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.11 000/817] 6.11.11-rc1 review
Message-ID: <439d740a-445f-4619-bf1d-f820764239d1@sirena.org.uk>
References: <20241203143955.605130076@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="MAjN0L4Ccs+lbFi2"
Content-Disposition: inline
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
X-Cookie: Alimony is the high cost of leaving.


--MAjN0L4Ccs+lbFi2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 03, 2024 at 03:32:52PM +0100, Greg Kroah-Hartman wrote:

> This is the start of the stable review cycle for the 6.11.11 release.
> There are 817 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--MAjN0L4Ccs+lbFi2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmdPgQQACgkQJNaLcl1U
h9DLGgf/YosWKw1BrjNgEA1CmfOeT6lNQ8IKXAGm92T/pmRMYOUe/ZRjaZdMfm8u
mfFhQdOZBtFOXI2r4Ia+Vqe7kQ+8sS7wEcvNhpTJTY6R0RG3TCNVgMXc6D9WxzHI
dAUSEbY6E4ViFNn3yzX+gPF75H0HAHrySxNlH8NT5frOWgUwy55ibX/kK/8ymUkn
P3KCkXdOzpEJJwLfeVWN0HqtPUtYfjmk/DTAFcwKf4gHBNrckri72AibVc+cOCIy
gPqzrlh7H2YTibhjm6xFWjyZtl39U//WYnA7jaoLPsvUMiVC4NEFwO6PngUq8Jmx
qxXTRkJnQnI/z6MrdQkcAS3TNlRnMA==
=ppNy
-----END PGP SIGNATURE-----

--MAjN0L4Ccs+lbFi2--
