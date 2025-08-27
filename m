Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AFF2321F31;
	Wed, 27 Aug 2025 11:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756293262; cv=none; b=mqlNmoEgiDn3v4yUAlMqW/hMhw4q8/pM5hVTHMKHMT0TNsbzJ++fyKR6TlSk5r/l+wOt2aTtk8JLKovVlhvAC5cnE4kWbCMh9PkydTEMaAcjMdUEkVOR41XShsDBHOqqJaK+qLTCrzSy9s5CnC/Q10sKruHBa88GhZtNU9RA3RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756293262; c=relaxed/simple;
	bh=pShLqohiswwO9hylSKVYtN6SqVGQzwvs8IMm+Ncfx0o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KPuxQYNGecoMONzdmMIAYjWCuxnatDuSeDYAyeJcNTfD50t97tyI3hTzkg4IESC7+IFC2haHUGMLOaJFBviwHuGAxxR9MPZLoBIRfDUuNQ7v7FoLpzpjbN9g223X821SpJtyrL2yR9abUFlxCj35ruRFD9LKi0ORUOP+SfN4G80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ddI/7+AC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ddI/7+AC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77F73C4CEEB;
	Wed, 27 Aug 2025 11:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756293260;
	bh=pShLqohiswwO9hylSKVYtN6SqVGQzwvs8IMm+Ncfx0o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ddI/7+ACRK/EhL1Qhpyq61ygOIf30ERh+ayEipsAjAdxRqBnpClY65AAbBLWe2mhe
	 PpoUyCX5ONWCJMvSpidgo40ySiXf7JaKeEy3EBv7GflW2Ul0zhHfXGPp9a6ICKgMpA
	 guBblUeZd9Ft1CnT+SBm3uU+rOjYEgtroEN65su/cN7yNZPw1zVrHTnCm77v55Jzah
	 qwpQlNMDpbR4NSlbihYNmn8BVI5FFDSNVZ9lLAAHP6bKliw9dJmdMpsleMMrnD051+
	 e/aEsCXhKrH3vOFieXeVn7tQSOsj6frPW/1RS8wwGYCRqpewkhrqRc/TROKx5/PP9f
	 kkc1HgMsFLp2w==
Date: Wed, 27 Aug 2025 12:14:14 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, achill@achill.org
Subject: Re: [PATCH 6.16 000/457] 6.16.4-rc1 review
Message-ID: <49b80686-8395-47f6-82db-2a90dd7b54dc@sirena.org.uk>
References: <20250826110937.289866482@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ZBBARQoS2JHVh8oS"
Content-Disposition: inline
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
X-Cookie: Most people prefer certainty to truth.


--ZBBARQoS2JHVh8oS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 26, 2025 at 01:04:44PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.4 release.
> There are 457 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--ZBBARQoS2JHVh8oS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmiu6IYACgkQJNaLcl1U
h9BwVwf/WwVgFZ/EOhrpEY8ldr5RHJ1uaJlze4qsLdsUCgRTqjlzHskuqwm0C8s/
+pwBGxFzkxvXxPKE28r0lN5NxQ5ogKpHIrcctRfTty5eYm1RVtrdgMXfcZLcUnrs
2/qZWXIgDrGFrQS2ebmZghNAhwnzXQi5DzJNurEPgtXqx45GCvAJN6TWvRcDdjJ2
yMMC1UrBM1Rr+4c1v0X052U763D6Dx4mnjlGDs8Vx2oFhjuVIjP23kiX1o+CSJdl
150fyvimwTASEtykG93Mxic8Oam5H6G1e7PeF1c0wsWwKL3DtQ/j4vulO2SMqoiM
DdHdzlqcJqTv8FWoqbKdfk0VYskvJg==
=rG7Q
-----END PGP SIGNATURE-----

--ZBBARQoS2JHVh8oS--
