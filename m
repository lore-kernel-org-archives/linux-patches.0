Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72DA82857EE;
	Fri,  4 Jul 2025 12:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751631328; cv=none; b=eT8iCph9GO1reuW08ayhQt/0unDCTmGTu4qhQOJlrjMmDwVuA62jSnHS7efSREtOQOSj0ZTJBf9fbkzW5QXrp1PMLfwIwQJQ3/CyPpnP0sFz5Fuy0st7yE7EwTae8fPF7hOe7V/dTYLESgSW8VChoIrZz3YigAUwMwuQ134+d+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751631328; c=relaxed/simple;
	bh=uQ39KWmMNSgWe0AFSr/COBXYR+8KMfLXxHjF/pYzn7U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nfaKCmTqzblmj/zzHw+WCtfzcUdSn03WwbJQmkGiVyyMw3088RazfuKBqxfIJ9shrP8urIyAHIF98/8I20kGte07sItnJBOMwv8x9jr/f99EBTzcqyKwAjyYc2KNpM8crW5LyUBSc11q1chQGXdoaog0Who4fyVxygEkW70GVuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q8gr7tv9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q8gr7tv9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31905C4CEE3;
	Fri,  4 Jul 2025 12:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751631328;
	bh=uQ39KWmMNSgWe0AFSr/COBXYR+8KMfLXxHjF/pYzn7U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q8gr7tv9Hv+PSswH9FZQArd6QZjYc/MabvRl3fRga9oVgi7JatobLHyXzCHNcM9/T
	 k3iKwcYSjKcnT+GGTz2D3pJrosNdYMzEYRhfTsOpscKb/xl8upN2WmHuSTFNX8TFSP
	 PEOwbCEt05I/2nO2ZOr3vURocVxuHyPVd9WSHB4ik2acIed6eAqbYpCz116xdCTeJz
	 KokXovjwVUejuS0WjB1AtsHmG4sqgwb7TicJ/XoG9iyuFNivkACZaTtd1m1/Lb5Ak6
	 eEEgWc0pWFdk4Lz4mCchqG0RgM2GzdMip6E81BjyWfM7urxoCdeu7CweLzt4PcKhb6
	 7w8/Px5LeI0Sw==
Date: Fri, 4 Jul 2025 13:15:21 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.1 000/132] 6.1.143-rc1 review
Message-ID: <ca035b8b-92fb-4ac9-87a6-7687084dc86f@sirena.org.uk>
References: <20250703143939.370927276@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="5Nryp2I+j3L5TYOK"
Content-Disposition: inline
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
X-Cookie: VMS must die!


--5Nryp2I+j3L5TYOK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 03, 2025 at 04:41:29PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.143 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--5Nryp2I+j3L5TYOK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmhnxdgACgkQJNaLcl1U
h9AhJAf/Z8F3L6UFt+E4t4fKlGxpPz8fWfVAAaoHCJBVq1OiTwHRuVzZGGdNtOpn
q3Qo8PQ6LHZCzTQooLlvLQ+dr7pXjIFxgXaWMoGj8Qs21FGQWGWQ6R6USb/C50dO
vQeEEXrgi6zBQc9NtokCMh0n2Z6C2qBHzC7l67a4rR2so+sae+hJDJ7K4DfAYaYt
/PzJu3a4uOG5QZEmapEqPWJdstRoFivZPmHj8CHNqHNhhXBupjIoGMSftafZNjoV
iuktwAru5qPK718EEVIGpcOPijVbON+vskxsae9iajhZs/ALkjLZC669r8+JNnIE
EEHq6ZwQVSAavtu6So5QLDk/ovum7Q==
=c7/F
-----END PGP SIGNATURE-----

--5Nryp2I+j3L5TYOK--
