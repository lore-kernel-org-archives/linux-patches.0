Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C4D12F5A5;
	Sun, 23 Nov 2025 13:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763905809; cv=none; b=QXaXL209CSVVDYYzkzo0LqLdKUl54Y2weg1RgRu1EknfkW0IqxC5GaSNf+HT1hFzAbQb9Ea6lAPsOUZA5l90yyBjg2G3ReKyKt5tHGJoDshLcSHEJkxJ355kEV29KncCmnVqbZ2rSU8eFq4YIj0L2EP14mAnL7UG6lavejUCB2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763905809; c=relaxed/simple;
	bh=ZL+RgcMLsSKNdLTtT60kCDHhXm7tIpVLS9UID5G6Js4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mkNOtVxZEIG5ie1Ut++HLVx2etN1EE7fjdS6J/nDmb2yLzveDiJPA5528TeKeSWQ2xBw0IQ/41YKPajhzSCaUBCzWI57fjNY9BP974oaq8RmR6UiVW5DoexuqXAok247febUTZqiU5SiuoXTF5MO7KF1qzKh2zncZ4/of29Fl3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LuTBiygi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LuTBiygi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BEC0C113D0;
	Sun, 23 Nov 2025 13:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763905805;
	bh=ZL+RgcMLsSKNdLTtT60kCDHhXm7tIpVLS9UID5G6Js4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LuTBiygieg4YuuDij7/ToJT3tAZHx7t8VaZ+opZd8Hi5L0CfxYY9xrvyVIbjU5CFb
	 lNdyxCEKYH5sbrfZnDKAJ0A3cnar0Vl1CYApH/bQ1PFEMPlTTby5n6YAQba2Otq7ll
	 D27IZGB+Y5xnlB7Nii+WtRWz0M8xtdU4kro9YeDQUHJ6beQEIZUda2XxO+hBD47Oye
	 XCIjbGh95ia7vuELborLRiW+SeXW4gSm21qsUqJYeztmBjU2oDGEsdh4IwW//GNgD/
	 1a2kNTquDGDW0DPqGvU/usHK0I4uTAQDwdxcJcnPhhxxV+B7Y/fw4QeCyxpfVGPfDU
	 yVAKE+yYEw3UQ==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 95E391ACCCAB; Sun, 23 Nov 2025 13:50:02 +0000 (GMT)
Date: Sun, 23 Nov 2025 13:50:02 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.17 000/244] 6.17.9-rc2 review
Message-ID: <aSMRCtECYoQL7ldv@sirena.co.uk>
References: <20251121160640.254872094@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="VR1+TAkp30PNznjK"
Content-Disposition: inline
In-Reply-To: <20251121160640.254872094@linuxfoundation.org>
X-Cookie: It's clever, but is it art?


--VR1+TAkp30PNznjK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 21, 2025 at 05:07:19PM +0100, Greg Kroah-Hartman wrote:

> This is the start of the stable review cycle for the 6.17.9 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

I'm also seeing the listmount04 thing Naresh reported here, otherwise
it looks good.  I didn't see a report for it upstream so I sent one, but
I'm not convinced it isn't just an overly sensitive test.

--VR1+TAkp30PNznjK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmkjEQkACgkQJNaLcl1U
h9BeaAf+LtzJq3nXHq2pbw4sJZ6CF7O0r54bFprX6GXaIm8sr5xq3GGKujh7wgCF
xQ8EkyvCPBjuIJeoXiC2cx5ATEF2HVVYrqWjwRXwVZLAkyp4g7adYhUokr2vmSci
bADLoc4tiWoCBzxIHGLkpgK9ioajl4Gn/t0J4CVur2utNsbugHNTsCXK3oLyipZL
f8WSaNsM7d0r/Id6QKmOSepD2/smbAWPPLHWHeW3947tO3pKOU8oGTJMy5jIjWT5
VPJ02tVpEcodojc0Jluy/lOyMT2ncGo1QOHiX/DfqGYYYj9KcN5XahGhUxzQry+q
vvGmHldmSwUWP03yNAgUi5ulpCBxtw==
=9bFx
-----END PGP SIGNATURE-----

--VR1+TAkp30PNznjK--
