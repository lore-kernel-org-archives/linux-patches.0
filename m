Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A11930F52D;
	Wed, 18 Feb 2026 11:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771415834; cv=none; b=HRCEVVufz7AnCaoK29Y8pGXTcytlAeGlridY1YnRzUYzt9hykl50Dad8gQuNS2+0P5ovSnt26ZGJXLW948QCwnMD1DGdVuYXTvnhkFiaRQ0deVL/CzxLGFWGgHb3Jp8MxwefDALzAxDJ0I0zrsRzcWYBWwr0VCvxMsKgqEMQXNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771415834; c=relaxed/simple;
	bh=To9+3wToIJ/dVVBoGIl9t0tfODL2F/1jDWPdFXSs0mg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p1x0I/PlURBW8cHMdQ0H3b9jBeE671q6ILq6W1s1VjCLEbv0Nt6M4m3ZSm2MkfpHqW4OaIvjzhhItvLjeedJ100H4I64MkQVHhe7zaSbqTGMzGoMqJsAMLhQuS3dFpvTFLY7nmnFfr9LxC1JnynYMzPcjyfNeTOb29kRNg41Wi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ds5xTEk3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ds5xTEk3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 919DFC19421;
	Wed, 18 Feb 2026 11:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771415834;
	bh=To9+3wToIJ/dVVBoGIl9t0tfODL2F/1jDWPdFXSs0mg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ds5xTEk3OEGlv3OL2u1KTLhgPAzZnZAlUjA62rRBS0IWo0O7IjrMqRN4Lp5xAOkAe
	 VfLpXVBdAo3uw/Q0a6Aji/wk9Xr7REN/LuLLSgVJKKIfRnuwwe4zhuWoOX12GxMjGe
	 tkNYJRLmOCO4cameVwo++Ncvx4LYuoPrp/83cw2mrWunRzIB9b0+UF6EnO9RuvHmsb
	 gttepBwhZuPXn/rukAamva5zVq212w0+MiFDp51/HQJ/zvTnwPTjN8LMp8XungTHMl
	 0Q16Ea+NGKQ82VcOjbCUay+vwDwHe1Mo+EChsL2EI3RVy0mlogahkqHqMsgadfXs0L
	 SjMsc/8E6EBdA==
Date: Wed, 18 Feb 2026 11:57:07 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.6 00/39] 6.6.127-rc1 review
Message-ID: <103c1411-a70b-4469-a5ee-1822c7356bb0@sirena.org.uk>
References: <20260217200004.221651386@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="9kB0vO/1IVdMOqaI"
Content-Disposition: inline
In-Reply-To: <20260217200004.221651386@linuxfoundation.org>
X-Cookie: They just buzzed and buzzed...buzzed.


--9kB0vO/1IVdMOqaI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 17, 2026 at 09:30:22PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.127 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--9kB0vO/1IVdMOqaI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmmVqRMACgkQJNaLcl1U
h9A3MAgAgwZq8JTfKKQN6fnbqXqiOYtT7TkgtyoCASBbVrjsbgacQELSCBmA9aDI
Je+HDwyefklwlGGr4G7Y9Q2RPs1ApDTt0/wKwl9SEUqv5G/izNqHIP5kJcNW6USy
qaQ2Agicxcjiyav6iHOovmroTg5jgx0qGJyqMi+T4l36pIOdezwwgab2V1QDrgg8
D+KAeRqP40RmgU9ONOZyZFzjGbFUJhRqhH/7Aj3VHYm4m/NXQsSPMSsjaI+1Ri1z
HxiVo4ZPEG3jMuQ7rFUXSkOorI+sKKdhgAPmW9dQC4+qwKb7JNSg+J4Umbmdkdo5
zm1i4lLMdZgU+nokVVoYPbVAJAZb5g==
=361a
-----END PGP SIGNATURE-----

--9kB0vO/1IVdMOqaI--
