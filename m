Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D02F2A1BB;
	Thu,  4 Dec 2025 11:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764848123; cv=none; b=SDX3K7l9Z5IewVPkswL///8ArNStYWawcvVI+TBE9kN+wH33ltYl5oFpRXmDmNUMf0rl10QM9JpjCI01e1W60tfBNGF5VJuK2uos/8ZWD/GEJoVJlQ0Wpvqj4byF9UadBrAtIAThhkzd1o80snFA6vCNzushLgtUvxtUPnv4swA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764848123; c=relaxed/simple;
	bh=nNbIQujrulFBZ89VDSc70KdDmQC8S73EdhgvsgLj1M4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EbKhyntaZ8z+QJcyQ225Jtstgq7kDmpASZFBzvR0D/0xNK8tfDcNT/se4lofyUQwqqkTzBIJb34G4WlLiVGgiZKjZmNOcBX+mubLC+On+ZLZh63lOSVu+x2WctxBl289WYdK9stu7D8MsP1P29L8t49HnmC4EiR2GEQD4OudvJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ISw47p0d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ISw47p0d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42E4EC4CEFB;
	Thu,  4 Dec 2025 11:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764848122;
	bh=nNbIQujrulFBZ89VDSc70KdDmQC8S73EdhgvsgLj1M4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ISw47p0dsiyWQKVlgCI3aKy7/qi8vh6NxIdJpFhUl7ZsbMR444Fd1MnXqa5ZngmU6
	 BG7EQ/wpG6BS1WqtQZuGbmVTkc7622nsaBGMZmEDEr2t8jeSpVqkdBx+7JNRm+/AJt
	 dZxU6gb1xyumChvTkiZEy3qP5o1idX7AiX9zfTNEVcfFVut61KZQ7c6p+luGIxNTDf
	 o+/2H4cSAl2liw/svAnzZerbXK0zoJBRwATYraGjwK/CnA4/NITUDRtWi3MhLazDCQ
	 p+56KuYpjDIlpT2oonq5W6bl9JcVqs57M+49XDdef+sKpDZ6lTuIxGhWcB+BN1SPtp
	 waZodZVGpMpIQ==
Date: Thu, 4 Dec 2025 11:35:16 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.6 00/93] 6.6.119-rc1 review
Message-ID: <3d542188-7822-4979-9490-c2e6a0c3b8b0@sirena.org.uk>
References: <20251203152336.494201426@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="UcndG8WcPIFAynKI"
Content-Disposition: inline
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
X-Cookie: volcano, n.:


--UcndG8WcPIFAynKI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 03, 2025 at 04:28:53PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.119 release.
> There are 93 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--UcndG8WcPIFAynKI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmkxcfMACgkQJNaLcl1U
h9AXZQf/SJOSx3SJH8hZmJIh3p4/0qAy7ios4cMdWm/9W44ERBLAkKTAQGcNPgQE
ZvZ2nRm+zTUOr50mU5nissc2SYutG27LtK5AG7oPNKBhF/Xicw121Q8ItkLMfeIo
FKWB6N+fb/d9IR5s7wgXQ0nzDVnmwkvyjNl4H3ajtdxdnnNKPtbxYvdBmP15d2ui
x5I34bNe/Mf8V8YZLPuoLbmPdtgmppYrj6kMDEQxCv1AQCe5RpojHHIajPPATBNF
KVOozN/Q+gyifdfIn5eLtmQoeVtZ6M1FEnN/h5PIMkEUFhz6Md2reC+DTgcUzkS5
1Do7fQSZrdN3xEyLOqjmJbrOCuirtw==
=O+A5
-----END PGP SIGNATURE-----

--UcndG8WcPIFAynKI--
