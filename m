Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 161171990C8;
	Wed, 18 Dec 2024 12:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734525513; cv=none; b=oUUymcj0eKp/jZDUBwXjDPivn0JVO1w/DuJ9LQL+CPUL98sRj6O9C7GUDZw9Q3Ot3uXZqHy8ObulX5evP2M5bzn1cbfRXgxW80QIsqIyjsopqBE0wr+1zUh4C794JI+KqXJuwKCdxkrGSYf5fmhKGPVjrca8+pRRn5cwzL90mk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734525513; c=relaxed/simple;
	bh=VFpMKjVtbpb1UFqp1r2HFZ9XyP8rje0Zwg6umeC0e1U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gVdsnQcE0kL8uAI/tfvcdB+xC6V7DM9HQ9ccVO2iyXct88sykoUTMjUfWgZWuS++qAUQWIn8RRN/McKJ16Y9a8T/4AhQP2Z4Q3E2hkjtM6vbCnY31FIirShdCOD960KtJpNYyruunG/UGvK8YwKqzlbCBkTprcE0CNQywiTAB+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ejmEaPAW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ejmEaPAW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E458BC4CECE;
	Wed, 18 Dec 2024 12:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734525512;
	bh=VFpMKjVtbpb1UFqp1r2HFZ9XyP8rje0Zwg6umeC0e1U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ejmEaPAWr7SoEBdYSnCgUMPyPBTlDGDcdsYLL1+l+rX9KcRu7rsDSQCPDrRilAizb
	 bsKy31trp1RuudFw/EN2RxWgZDS/vTeCvIumDxva0FyJBZT3vBCuBkNg/VOxz9kV2R
	 qqCjGG71qiVh/elZDKuREvgW/1c6kKDfI3nau22RD40EkVFP2n7MN6WLUB0WMOUDY/
	 BwyGTWiEzaol6JpZnQrUYnXr9KH6nyLDSZQKH9xr898z0r83b6Jl1hilL4BA1Noo9I
	 N6FS68bcsnlNFnRdglCxY55JVZHg9oETtzvu03iLVdfkju4Og1Tq6I3a66pHzPQ7el
	 HTBkbbpAwwCAA==
Date: Wed, 18 Dec 2024 12:38:26 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 5.10 00/43] 5.10.232-rc1 review
Message-ID: <7d8f0a1a-a984-4b5e-8691-1c3f7165e27b@sirena.org.uk>
References: <20241217170520.459491270@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="TLj0GEbNT8et1pEr"
Content-Disposition: inline
In-Reply-To: <20241217170520.459491270@linuxfoundation.org>
X-Cookie: The heart is wiser than the intellect.


--TLj0GEbNT8et1pEr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 17, 2024 at 06:06:51PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.232 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--TLj0GEbNT8et1pEr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmdiwkEACgkQJNaLcl1U
h9CMoAf/Q2vKkSTdXiSAHfXiuzsiPbXhFs12hSqXMd12buXCOQZZ41mScn0pWB0Z
7Zb1lGjvIhsPHUHxNPKMrX8gyM/rSPA+wjKDco7BtRxgxQ1NnyTQJFcaQ6QS1cpf
4dvYeb82FzfhlpwnUnM9+W2VCRmTrir383QXQOAv0tO5DincRFxScVlIbqYvcBag
FUj8Y51sFnI6TCBNSMENwc2101E7wY7P9+1dmm/cN1ts5D0pE0w+euUlaoOnrUgK
TWp6QszKm4VXpnwo35KhEPIU17zV62e+6xTw8SasXRIXAZyvPf+BMAcB3jR7pu7j
SPDsLuPseJ6yZziWU0VwKiGKe+cLRg==
=S7Dr
-----END PGP SIGNATURE-----

--TLj0GEbNT8et1pEr--
