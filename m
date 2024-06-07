Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C4D50282;
	Fri,  7 Jun 2024 15:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717773833; cv=none; b=taUSxpfXQJ+kr9sUPaFHncjgtjeee0TTLSDqDJZ33Ca/GQHqLngqjAzv6u2UYHMp4WQ3bFgOzYuN9kKXd/o3R53oEcvoQrqVomp589JZKANkZ0UneFGlER8oiwjPNGAGbcyrCtN9zBD0ULGk9UJyjcwRQ3DZic1aINnc9bYz/R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717773833; c=relaxed/simple;
	bh=V/3eoOFv5cme6xTNs/EJlbPazWiQMTzwkwpXP4COh8g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MbVXlU9LHLS43XaIjVxd/DOuHcU9eLxxOzY5wMpoNsnCXnDfR+Q2CbPyAJwxz9rNoVyY1gscqwCFexuA6ZkY6w0vf/zT83v8sQA8KYZ7LdoUEGBny1EvDjZIPCCl5ji1dfIvWqhxtpzM0rTTYbagEqvRl4n7aLFBfRJmX2rtNnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fhapf53L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fhapf53L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98442C3277B;
	Fri,  7 Jun 2024 15:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717773833;
	bh=V/3eoOFv5cme6xTNs/EJlbPazWiQMTzwkwpXP4COh8g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fhapf53LEr43mhfoueBInZBI1IDRF8vmBPIHhMEBS6QyCsmMmC2WURvra8UzB/rOL
	 AFT6EiZm0DAZaAwgbkKY5t3Pt+V5x6h9YI5t0FgkMU7zmxfiqUDc4n8QvVxBv8lRRk
	 0dWHbPO+2GVJdfp0hhIqgimL0Yyv8NvvhSYwLiPBc53i3tdWcOxSRIkqGmnsBR5XdS
	 kPCYBEPVFHAKAqu8UhqC1xFb9YNA8inOFyMusskV8SnFECcnmfiyIhHMQ2CC6cne+S
	 ZQhpLNE7skwpFmJVGsDye0flyn9wGQzhRUabogFtRSd3D8sOLA6dUHjJqSBbFZcHUX
	 856HzAmSqG4iA==
Date: Fri, 7 Jun 2024 16:23:47 +0100
From: Conor Dooley <conor@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.6 000/744] 6.6.33-rc1 review
Message-ID: <20240607-footnote-script-3a1537265b4a@spud>
References: <20240606131732.440653204@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="q1L0P4VLgXRK5f+f"
Content-Disposition: inline
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>


--q1L0P4VLgXRK5f+f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 06, 2024 at 03:54:32PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.33 release.
> There are 744 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

btw, I requested a backport of a riscv patch to fix some userspace
tools, but I didn't see it here.
https://lore.kernel.org/stable/20240530-disparity-deafening-dcbb9e2f1647@spud/
Were you just too busy travelling etc?

Thanks,
Conor.

--q1L0P4VLgXRK5f+f
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZmMmAwAKCRB4tDGHoIJi
0oNtAP9d6pTzkVK+AA2Ue5fxgK9G+fAhJOys372EwTArRLK/fwD/RW2M2KvjuUE0
jcXyt/cWjW4SeGbbnrhiEOSnrrUrpws=
=zmCU
-----END PGP SIGNATURE-----

--q1L0P4VLgXRK5f+f--
