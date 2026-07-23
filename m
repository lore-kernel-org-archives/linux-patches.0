Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07AB337F312;
	Thu, 23 Jul 2026 15:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784822231; cv=none; b=pTvAL0seZuYmX92f0f2LEHzn3Z3bWaF9hG4hZD9w2Tpe/3AHkm/pcFEeWffiSNizH9dfeqMyDMxCoUceWj77ejC3bQePjjAm7xdQMS/24HXgwibszGBuYCBo0RK/Y6C8DHP98MAC73KeUyG1WXRTaIYPhQjxlaAahgqxbu5B9Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784822231; c=relaxed/simple;
	bh=er4vKP3QkiN1KwXETf+jBliHTm0dc+FhSX6zmHm5qpg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CcXNqfoAQwbHlz4aHVwX/pJDJLppd90FC5VT2CI3wp7CuKnuf3ir5y2j7gJLdKrP8785IxU2dDbAPECknbSP7j40E9ciPM7V0pHxQIjDizO6ionAQ6DcvPPRTKsBZKHWitLBzSErggXZEt+G6XhpXnzd2I5oEoJiALLaQiv+INA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kN/z+bso; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kN/z+bso"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ABAE1F000E9;
	Thu, 23 Jul 2026 15:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784822229;
	bh=lFGiaDWAlL3ACzz2oTL2Fn8GC+ZUhW0ViX4n4LCIlBQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kN/z+bsocu/jxiNnNdAQjJ2EyReildK/tiO5aMFBYey2/2uu1VPL47fR+rSJxZVPy
	 fuw8W//u/+N2pUZviOf/4mXbRzMAWvhUdixC/CqPRhhIMRNz8xoquvaac/D0eF5RuP
	 8Iqoevbheu2J8IsnRpwBQwzfDe9XWrUpFcVbQ6OVbTbfjr5/312z0LVlWhUsd/G4Ua
	 Mx9+KfMZ57MHShanIZ3t128Jc2VIDRBuo4pY12KKvRkgmuqtFskguFtMesErX4IMbp
	 5RZF+V0jfFvIgzHstPDF8Zdovanh28RLQW2RCz8YSiN2OmWT/1LJmj65MpukBW/BWv
	 yJL3B/PHlu0sA==
Date: Thu, 23 Jul 2026 16:57:03 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.1 0000/1029] 6.1.178-rc2 review
Message-ID: <2e96896b-92a7-4acb-a256-75fa99d02412@sirena.org.uk>
References: <20260722143218.909123637@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="quwIsLqtF9LuTHw8"
Content-Disposition: inline
In-Reply-To: <20260722143218.909123637@linuxfoundation.org>
X-Cookie: (null cookie


--quwIsLqtF9LuTHw8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 22, 2026 at 04:32:58PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.178 release.
> There are 1029 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--quwIsLqtF9LuTHw8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmpiOc4ACgkQJNaLcl1U
h9Du3wf/WaT4EQBkMiRMLKqNmt/seWCCjNq7HwkCYB3K6OO/x0wyIRunirO0YK2W
ilgE+3QyeORbEcvChl9RcSpNMdsezFkQnVbNiMmWu9Wu+PrsdJDa4sXjdSVY+7De
/pGrGpnioJ7Lct53vNgP+p+jHIsvvrBgsIQxhA3tnB5nTV+otRvk9dvCrxuLeHo3
OUpbWwB8iK6s/oed4NEok/TVafyieOi9Bp6jWrdO5zchbLPU6GrBELmpFNLmgot4
eHC7ivrrPfifx01JuiorH3qmxTZPKjgz3GQBttk1u/IuJOjRjQH/02gBLk1nHEuP
/fr8UorPi6BeV2HDvOGYsmGo79shRw==
=aPJU
-----END PGP SIGNATURE-----

--quwIsLqtF9LuTHw8--
