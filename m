Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D25821638D;
	Thu, 20 Mar 2025 11:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742470494; cv=none; b=NYzs3iMckamm4ImJE2I3Bp9W0MAfUJmYdLX7bDXaumdTinYnB+EcfVU+1CXobiUj+Lu377p3cIxSjhOlLXRg5vCf0TP+tpikLwLyHD6XzUCwC9PUmFqLfIvgWy1ncmvzbTJLJWm+CJklSnTyhNi2rn5on1xLfEG9a+ZolokQM+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742470494; c=relaxed/simple;
	bh=7F2XJffaHs6cQGIN1RV708lYRHOZdWAcpGmryuARyCE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jhqaTm/qxFZvkPbAXsXKXnmM6wAM0Z2t1+8Za6d7hI506S00xZ1B/6Uk3otRO6TTbQ0xrJc2TCdngOC7zh6aU4Kzz9zXmBDGA0cqyzd7Qm/pgmQYoEtpmWQ/JOQOvR0LpCq3YtqTEehCklNAXqhB6PSoLtLm09DIq/VtVYq942M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=he+8oOS+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="he+8oOS+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B3DBC4CEDD;
	Thu, 20 Mar 2025 11:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742470493;
	bh=7F2XJffaHs6cQGIN1RV708lYRHOZdWAcpGmryuARyCE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=he+8oOS+6p/pF1ptVs4TetYn2bwJBOCqVRK/7P6ZkELq+0iEEFaAbP1SUmSkq3NAe
	 gglMKc5zV2Rh2yyx2AveM35M0/dKrDaMr7XTCj2qPC1ZO13bz40ccI223bw1RLrifY
	 FuDy3uR4PPCJkc39YZkAMz99j9ZTpTA68fIkcPjubPr0riMoPF5afGvmFtYJr71h9V
	 kHEMUAX61ut3gECKjhj/yMGBBXP/F/9ORxcUZWiPaWigp+nwd2X+y12BnH9BBZsrgO
	 PesE2kPXl0x7amFKW8SujCcZJmayR2Lw0tmXsxgWZ1wxNPYo3G90FAjQewYm1pWoQa
	 I9ZlT7I5Vrb8Q==
Date: Thu, 20 Mar 2025 11:34:47 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.12 000/231] 6.12.20-rc1 review
Message-ID: <bdb35cff-4044-459d-bdb0-d5e5a894bb82@sirena.org.uk>
References: <20250319143026.865956961@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="jEBNBvNqBQwyutUF"
Content-Disposition: inline
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
X-Cookie: Do not fold, spindle or mutilate.


--jEBNBvNqBQwyutUF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 19, 2025 at 07:28:13AM -0700, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.20 release.
> There are 231 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--jEBNBvNqBQwyutUF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmfb/VcACgkQJNaLcl1U
h9AbqAf/YQxDBUOB+Mqekgt1KP6K2epXm7j7xLx+RELlqySh4zZWU1LHKJwP5x6a
NZ3Py3OlzJVLvSiO2osqz5qofNSFxWe0bfUTIYuShpbEqonSvVk1oEIdybnLLdZA
pvQuXpUXHNDAkGxLJfL9Veds/rLx+MVqsG+8+EHSqHdcBKir2yNibyOQY/QsKj46
BeNJmUc5OeDrfe+lhPTuwrKzbo02Wl1NHGEu7qnkZz6aeRYsqTkPFpvrGvDDU1xl
dI9YWrqkIR7vOh3J/EMQuugF4nYNgwSTWW6NVmeIDiO7eTYfejCivcmPW+ihCASq
A4q09T8f5eSXTzBg+yIzG/gT7JkBIg==
=Kmfk
-----END PGP SIGNATURE-----

--jEBNBvNqBQwyutUF--
