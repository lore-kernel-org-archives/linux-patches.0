Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41BA92F3C1C;
	Wed, 16 Jul 2025 10:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752662472; cv=none; b=EdFXqciDX7X0n4aKYkUVFRSc0PnpVnZwxPdgxILCiYAtkKQViqRisDlpwzBu9Y2BzkZ5UWKvbXOwrp3UlwxfqboP7gUx7vCR9s28VymBirE+kSBartZpWqixdbUB0nbVlhg+3dQcWTg3FjEIZ6flkpf5scpaQ8ZkvNIWxoC585U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752662472; c=relaxed/simple;
	bh=WAuDPaySVV0HnQUZ5upm3Jxvcf5/doeQ9PZuT7/Zgvo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F0Eg0FVe/mR/YKCCdLxY+PsklP6jqiGqPUMprQLL4eW46xeZ2xje52e8VvcD/SkzCvZdZViu0r2gE7pGdyddXoxJQr0S1NOc5Os4hMFq9GKf+3wDQvV9OuuJzaZS7wyhtJr9dqb49MRz4glatMFQUI7DtY5w8yoa9N64aE7UhJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oiEr9LU/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oiEr9LU/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C53B2C4CEF1;
	Wed, 16 Jul 2025 10:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752662472;
	bh=WAuDPaySVV0HnQUZ5upm3Jxvcf5/doeQ9PZuT7/Zgvo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oiEr9LU/K8R3WKCtf5iMDc/qlaWAaakbjXR0l9uwB/GG3VS74I+VS/MwDVikhWCkJ
	 g1V79O9ZSDPpLVHIRfgOSuSQwtPl3CwKk3E8qpipu8RUGgA1pr2g+3UPyuENB/xv+S
	 E0BjWFKiLOM/2DENI7B8iFBLYqvfXKO2uAO7RwGyz4jARjpPjSAgB5bAdIRIUB+sIg
	 wJtSDGwJ4ywQwrEtZS4QrBErtiTTm+a8d1MK+BBfkpn5ZRn9uv7fTqZDwP9gCaNYdK
	 wyle7yDnIphth3LohIKmVtfxcIp4uAwR6Q7qg9kynVRi8ZSeZCRPCpzTbGzZ89msPf
	 Q+9T3U4Yd0U0w==
Date: Wed, 16 Jul 2025 11:41:06 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.1 00/89] 6.1.146-rc2 review
Message-ID: <20d0ef01-5cca-46eb-aa79-c177e109905e@sirena.org.uk>
References: <20250715163541.635746149@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="S5AC/qK23ALYIhd5"
Content-Disposition: inline
In-Reply-To: <20250715163541.635746149@linuxfoundation.org>
X-Cookie: osteopornosis:


--S5AC/qK23ALYIhd5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 15, 2025 at 06:37:01PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.146 release.
> There are 89 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--S5AC/qK23ALYIhd5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmh3gcEACgkQJNaLcl1U
h9CMPgf/YL+F68HD9kPgYB8OjJrWnulxocqERGdWa2pfq04dVMUB1vf756A9BPZ/
G/L008ZTdaLaURGSCZiQMBTJlRSJtZLLDszCrL4d9vZe6MqUtWbi31sJf+J1lt2n
f1ZjwOWWHrQHPL9aHmpi4vzbywOFsMamXHJZUOpfEfpKFWEzM05bKayhjY4mmQSO
TrrMDajXVoNP58jRD3wPNN5g4Xi0W0lL2H/iC520aZJAz5FFhwGMTAFJ80jJuWkS
m6YYEA2d+3UklaeHWH7++MzP9A/SxugZ0lCEhDrwX7KmGSKZ8lbc9Hra7ruBrKd9
fNnMfN1V+z2owp+N8Gh4TSwu/VV1Mg==
=c0AT
-----END PGP SIGNATURE-----

--S5AC/qK23ALYIhd5--
