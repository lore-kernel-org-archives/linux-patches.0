Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C9D7259486;
	Tue,  7 Jan 2025 12:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736253192; cv=none; b=LvgGaDy/UFzIoi8opfSMYWOJJE5GKbYYXvl9aAQ3W4DjbxEBsXm1JYBZUxP3Ml4sgG7vGtD+FqbajlP9XnibYDV3o7D3A6kjVnQeAXkpPST2ymzx6tQeO5yWgcO+9QizbnnY2JuyqfbuD+VlzMLnimQMMX+CX9iZm4PRB2OMgCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736253192; c=relaxed/simple;
	bh=6FO9kExDpBOYBEJaTJaUwPffIcyvBBNYYZzQ4BiJKDU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SZHY5gKU80IspCazWN1MvKQ/tXlifxvZ4qKES92IGaqUVam6lnnnS1+RHgCiKpvqWAnYok+i7jhYxaPD5kD/wWl/IyxCtWAd1ZV+z8Ilsfwbe+PE8puWd8MkwFbcRlRtoLz5ZJHyNSbtxX5z2/hbAwsmqfXOkHbzCi29jaHE4Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BOUDrmA3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BOUDrmA3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77AA8C4CED6;
	Tue,  7 Jan 2025 12:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736253191;
	bh=6FO9kExDpBOYBEJaTJaUwPffIcyvBBNYYZzQ4BiJKDU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BOUDrmA3/pNFbJrFcb3nWlU+jr5V0NnaXjpVACZzyk8OC1zAzedY92BKI9tsPO2Sn
	 r9/o4ceSBp3zp8P1dVdliXX0xKhokkSPMbaOkHECOCuU2l7YIhefvemWLzG778o4lG
	 XQyRr3HTHpcvAlN2vf/oMaklAOlr2dThMi53gbxkmysn/GQvu85isU1z37lnJ1Fgh/
	 01Y9yhtzxYxeV6Y7PKNDkyppwltEgA6w/ZiNitNJHeZYZI7YE+b9Z/qVrzkTPnrlYi
	 qzA/iBwSpseUrHswJmJOzF3JYKe4Jzf+1yKM/4QvfO1MJfoxV2A4iH9w5LCWQfGthU
	 cZD/NMitKRwxQ==
Date: Tue, 7 Jan 2025 12:33:04 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.6 000/222] 6.6.70-rc1 review
Message-ID: <f71dc7f7-e9bf-4925-9150-b1194a6d1e01@sirena.org.uk>
References: <20250106151150.585603565@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="poWt/wq+bsDp4krz"
Content-Disposition: inline
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
X-Cookie: PIZZA!!


--poWt/wq+bsDp4krz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 06, 2025 at 04:13:24PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.70 release.
> There are 222 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--poWt/wq+bsDp4krz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmd9Hv8ACgkQJNaLcl1U
h9Df/gf9Fe4s/kVlQ7L54bCYWM/nXuAJNjGDBDln1dQRMhujFfAFISAbZsoqxwXy
Iu648LNa9Jy4s5XOy0K7XobnEyP/m4K8Byf81sRYU6t5OTwpl29Ea0K/vEshEQ6a
wqW/CwjBPkYIEUfFWcwsUt91WW51dEvz83Fr+34gYSNEkhfk+ntQEiCnYcIMFKy7
VEwkVgcTQSkOSm29n3zq+j0DmJF7v8vd9xHrQgKljC6tN5nwonUWZe5QmO2T8/pH
ZSLEr3Xp9oHAfoNb/RbTA/aF3x8Uu0Qztxq2/Uy+5Oqu6EDn8w7KFZLRxPpq99TA
CQJ98EO05mOcE0HyHrq0obwKryP/wA==
=gJnE
-----END PGP SIGNATURE-----

--poWt/wq+bsDp4krz--
