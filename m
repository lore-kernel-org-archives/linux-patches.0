Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E5672610;
	Wed, 27 Aug 2025 11:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756293233; cv=none; b=sLxg6ehC3fA6wi/DPgu88ONXSGedBrTotA6+AqS0sxX2RPGPbMjZm6bYHM59nt1HcFYOo1QMp30J7EF0mC8739oKrca7tDzQcvktZHsMvyDU8E4iW7HWe9pItcIDJZeS87vZSG96en0cPP2ENefFNabA21xKeQPB1NE0iWiXA80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756293233; c=relaxed/simple;
	bh=+EFunwi1pkJP2H18I61OzrQHFnlmC5R3Abg+XE0LAtg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dEgkuNxD2+CPX6Wn4eBiFizABPlQnpEQXMW5p9nj/rDLjGFYIvDJt/l/AGs2fC50nmuglyV+yFD1IsP9um5WPTZsHQ5mb9RzvCt32uHcOTY407vKLXNfph8xrZMHsdDm6tw4yOUbFcDNCpOB9fVLie6I/7v4WkayYMOPjZpn7Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=svVrkZTe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="svVrkZTe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24154C4CEEB;
	Wed, 27 Aug 2025 11:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756293231;
	bh=+EFunwi1pkJP2H18I61OzrQHFnlmC5R3Abg+XE0LAtg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=svVrkZTezGvrm0Mt6aMtRHx744VUyZDAvYsqHpNDq2g7bzNke3o9POifqXV2Kb+/F
	 nKp4Ko0bOI+ujsQiY1lWwRGGckVpsAg7OSBVEcAPr9Xc0ri3xuoPVlryyRLJy4XMgF
	 S8CVdovSALLuXTcwL65WdNdKB5ha6OY83n9xYgYEsT6KB2p5g3kHfdC3aJqgEPlj5A
	 V43FkapOv5vWESR7LGsmmxeocz+TJXqUNoGmCq+VyWadx7AG8ERRuEmoPZS6cWDeUi
	 ZY3Cxc2+7J1ZcELM+tCdoCzvUT0Z3SRZL3VMJ4GGe2b8piUTq8ar6m+xBHmjhJtWfo
	 WsyYl24glhvMw==
Date: Wed, 27 Aug 2025 12:13:45 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, achill@achill.org
Subject: Re: [PATCH 6.12 000/322] 6.12.44-rc1 review
Message-ID: <c3304d11-154c-4523-b1ea-b0052b406035@sirena.org.uk>
References: <20250826110915.169062587@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="L4j0PrOP1RX4Sy0w"
Content-Disposition: inline
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
X-Cookie: Most people prefer certainty to truth.


--L4j0PrOP1RX4Sy0w
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 26, 2025 at 01:06:55PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.44 release.
> There are 322 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--L4j0PrOP1RX4Sy0w
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmiu6GgACgkQJNaLcl1U
h9CDXwf/ZJp4P6IjLVFktwv16AvmHcYcwbnvZZ3qCrsX5M7ndWOJFxWcAys4kuiS
NHqy94lyYH2IYOuyzdRcfMb4bZ4HBm4AcEYal2vDzAV6ShXRvXesyC5GZUPLU+J6
IOx742odIZHvHTz9otudpeyO1AfqFhLeAEq94/ak5DnZ87iL2oI8On0VZocx8taR
zP8KFeUche0mRW3832svpMBCS7Yo1NtyjoXfkGk5yMRyrI8I5qKXNrja1K6gDYku
NORlsZ5bJ1EHilvC9DePKuITqnuoaBlSIUygltgpSrIHZ7zNaIoR18wQIhIOEV/A
AGFeoAVKMCYrU/7oECC2nyixpFL2ZQ==
=xFv1
-----END PGP SIGNATURE-----

--L4j0PrOP1RX4Sy0w--
