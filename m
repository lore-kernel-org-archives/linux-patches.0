Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47ED41624F9;
	Fri,  7 Feb 2025 19:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738956986; cv=none; b=YtULvv04yJ1uU07jZ8RSf4gzk14DsEFCPXxsU6kGFrkeKRxVt/OvQsYwxrGMIw9oqzZq+N0uV1JKZu2sR5YAu6uXTsJn9MJ4QOuQRJcnIhyhxPso5haXDcM2PGaS/RBfVi5w1+TWpiJB8NP+gJO9rwdP7dU3VdU27mgNCxlYUAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738956986; c=relaxed/simple;
	bh=oby2pZ41GMXyHy0XTSUwX4DVmPozSJ7C6XYW7hPw4cE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YTQfnWxqzuvv4V1VEEyb+p0dEfWIy2lLHrzvsaWggqBJ4zdgv+O47lwRXple9a905OscBL70QzdSpcXA+vam7bUIll/aDg7NLDTUQOq0c575Wn2D/RRTv+qqaJixxWcchvrhnN9b2/2Ueh4lDY/xac1edn/KipB5mWIWGVT6l18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=spniwh0J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="spniwh0J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73CDFC4CED1;
	Fri,  7 Feb 2025 19:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738956985;
	bh=oby2pZ41GMXyHy0XTSUwX4DVmPozSJ7C6XYW7hPw4cE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=spniwh0J0OUsnl+NeJdMWeyjlWSPWGmf+SS1rQfJE136CgirjFvxN5MKlfdpbrTz3
	 YSuae9Uoo06UxgDIhEEuHKOcIt+Ca0zWcSDe+VBz4PBe3rQSokRhlFSnZsNJKHvBB/
	 1eXb9f7gAJ3J/Oijxd34cqM/KW+1HstxYjehDde7Gr5IWYFDLhTT6CubqGkecfMvru
	 NA8YJCbVgeLNZ+kF4qRWbAjehffPlqtq7uT/eBlGuhZQHps6OiUJawLSm3qYb1IYvk
	 hw+G/byYThLQA3lMqsA7bAcR9dRfCIXUsPuGbt82sTN2Mq0b+FXB0EFlzXdO2tSyVB
	 L6N9Fc+MlhlpQ==
Date: Fri, 7 Feb 2025 19:36:19 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.12 000/583] 6.12.13-rc2 review
Message-ID: <bc6d69d8-9261-4f8e-937f-206105b0f627@sirena.org.uk>
References: <20250206160711.563887287@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="tE8Y1lq3ctkzNdlP"
Content-Disposition: inline
In-Reply-To: <20250206160711.563887287@linuxfoundation.org>
X-Cookie: MMM-MM!!  So THIS is BIO-NEBULATION!


--tE8Y1lq3ctkzNdlP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 06, 2025 at 05:11:13PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.13 release.
> There are 583 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--tE8Y1lq3ctkzNdlP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmemYLIACgkQJNaLcl1U
h9AsMQf/cW8wDD41WZXk8q+dUFbR4rZmrOtrQAtTiNxEWX57dZcUFsRK1IIESCXE
TyltDSV/q0KGyQhqImrrZgfT1ZYl251DF9/czER3zqf9OCkeZ/6ZU+21m+nYSxEk
VRdEwpn4btHL9zTuurIoRMQXOVxaE9zwDczmsIUwEMhsLb8OSDHbW24M12ePyhrG
bxeXKpmM6NJKRXvivCL9QSnvIxl1ZXD3G7CYMUt983+F7g/SHfkHtHytupo6OoW7
AMFkOg1IMiB8cbbr7TA/Me9HQDQRbQSJJpAAn8xM1mCiEOFlWimWfKQ+c++MxqBz
F7POr3djp95OYrW4XIUME62zxqN19Q==
=f+Ja
-----END PGP SIGNATURE-----

--tE8Y1lq3ctkzNdlP--
