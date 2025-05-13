Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20024150997;
	Tue, 13 May 2025 09:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747129705; cv=none; b=dC/9Af3GChWGLYf71VZiJVUZhl6heWlEhQti52UMG90nEpD/kmNPVRGt08Vj+iMEkiVJc7JsA8ch1mfBDh0V5+ocUVYGeWIXohWJN4w+i3s+pIh90p9bI970uX8Qg+D02Ug5XGsCqU3YUhiyXfeRzS0Z77gJF7akY9o02a4Yb4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747129705; c=relaxed/simple;
	bh=VCClFDmWn98t6LGY59WiqwTKlWQSpuTu+3dions5oYk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iWe/vbGqaVbikE+Xoj1jCU8HUXt0KzXqgtuGR5romAgIjfr13MuFILq9ImiWsiwhlNeQ6urLA1hiO3J2naI7WRN0XcZcOw5PjKRoLhZ+1FD8rfHRCk2J/ghKyzigmf3jfU4++vyvRGdS3snNkzIIhl6Ke+GseLUTvdNL43OamUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ks3xn8mh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ks3xn8mh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C44C4CEE4;
	Tue, 13 May 2025 09:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747129704;
	bh=VCClFDmWn98t6LGY59WiqwTKlWQSpuTu+3dions5oYk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ks3xn8mh1X7cSFC1KOwcVIF+OO+y6b0Ag8d68qQn04X5kW7CMKhoM4lWd0o4yG+kc
	 E2xeVPxbRc3SdnUPCky7X/XtlfEF/hLjGqWe7OL5VjKCtO7Qzd7IT0UuRNRQ7RmqeX
	 1Z2RVvP9KAMHJwTndwxWw4KFhhj/QpSDPB6zcG1FhBtl3A1m+sZxIkbpPqy8lgH/sG
	 JNsFw7sZo2CBD7k3Un3DH7UpQPVIwyLb6Mfos5Fh7PvJqOrPbrX0LCMPr0K/LERuF5
	 3SP9kCFoogsdCNSZgueWGFi1Y5fmKpEB9R9aqs7s50yewlWBh+2LFz123uqyh4ndmD
	 EzgWPsF1CgMSg==
Date: Tue, 13 May 2025 11:48:19 +0200
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.1 00/92] 6.1.139-rc1 review
Message-ID: <aCMVYwGTloaYW2u_@finisterre.sirena.org.uk>
References: <20250512172023.126467649@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="HvTXniaQ6ThjIWnf"
Content-Disposition: inline
In-Reply-To: <20250512172023.126467649@linuxfoundation.org>
X-Cookie: Well begun is half done.


--HvTXniaQ6ThjIWnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 12, 2025 at 07:44:35PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.139 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--HvTXniaQ6ThjIWnf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmgjFWIACgkQJNaLcl1U
h9BCUwf5AcQUMQH/YoT7PfcB4JFLTtR79WhEs4DtSX8Tg6MHnFGqnSuIKAzM/ERp
Z9fz0awCn92QKzQTH8WLkZTBwMBVj1Qbg4KNBFJo5kLC3wsDHVsJGNVjHjiVOLkq
XGfAODKABAXVVXKrCW11kkUuWl9GR7B7XcLOM59CBZSKUB3xd9ULZ2yVMkjoKC41
A0Gygov8pWj30B+HpdB7YIx4ZehGruyBy/OP13qdW1n8OhcnvkbNV+HIGuVn/UeV
RJ/b9er2k+AQVth7ZHX3K3zDILi8/ztd0GqbT1c2XU6GauXcCwe63cR3g6+mSXJR
uwvU1ub5KkBwTOOEJRiLbHGh3yPgzQ==
=AhpQ
-----END PGP SIGNATURE-----

--HvTXniaQ6ThjIWnf--
