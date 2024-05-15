Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E33CBA5E;
	Wed, 15 May 2024 16:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715791731; cv=none; b=ti0zsQxKj/Y1/eMB5FpmXhlReY7liHxBDQxsNSHhNRyqblsuZ7OA4A771vTZ0GLjZqOcQ8UU89TXGkA/7L4SDNyTwkn2EBXLYSmB2limbjQirvnmuha71lucdqB7tgzDDDlfuZenbfmqLZX5mewsP59dzugbPo+BOeY1wrctuLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715791731; c=relaxed/simple;
	bh=GASwVqfKmyz9znSf1RGvi7DPMdb+4NtsQZqrCPEwkxk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y3oDivKY+OumCJfFqBvCp7kvBxG5AFbCFOtLijcP3MGtlGPO6x5iV+/woXVLSzAj74GjuenjGsMrA58jcLGvPA3PlT5N/pplDCVjV6Oy8zlEAt6+trDJ/81LBYL1u22TepdQ14uIvtmi9U2OQsAqvmHiO5fin0TfXdx7zzk2blQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y6FrxJ+f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y6FrxJ+f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA8FEC2BD11;
	Wed, 15 May 2024 16:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715791731;
	bh=GASwVqfKmyz9znSf1RGvi7DPMdb+4NtsQZqrCPEwkxk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y6FrxJ+fxF6IW3rhZAsmVwXVwpnjqzYL4B9HRW9sFfotJhkc6Dqehiap8z9OApAaM
	 i7WzbRjaPTvsHZvTfDcIfT9598wiKukVKAhTnuK7L2oaK1mCTEruR/Rq+DUW8+1S60
	 4F4vxHm23pzHBUvkimxz6WMU6Tfk0KcNHoWgeNSxM4/WULStvGTMQi7/KMEKbK8LpO
	 bdJZOzCVMkf1++HAf3AKDbJE6vNlZ9wRhwfwJ4qo7xgvKQlP66P45q+dP2cTxWAIRI
	 Ip/Kx3Kb0vWWEhHW5y7BzmhU5xO4EMqIWdCPQWRzDCQuPVkEasCJeTkltGLSh+6l7x
	 VQ48f0MmAeC9Q==
Date: Wed, 15 May 2024 17:48:44 +0100
From: Conor Dooley <conor@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/243] 6.1.91-rc2 review
Message-ID: <20240515-feline-confiding-7086ef3811b5@spud>
References: <20240515082456.986812732@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="hka0nQkqB2X+jW7l"
Content-Disposition: inline
In-Reply-To: <20240515082456.986812732@linuxfoundation.org>


--hka0nQkqB2X+jW7l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 15, 2024 at 10:27:34AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.91 release.
> There are 243 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Cheers,
Conor.

--hka0nQkqB2X+jW7l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZkTnbAAKCRB4tDGHoIJi
0hRvAQCsZ9sb54lisd4sfnQxdpPgBj5vKh77rX2oLDkLwa7RhgD/fEVEEhZ8cMhA
rWceF7xlRhePuU0c1S3cC7IUsfZWqgU=
=3K3x
-----END PGP SIGNATURE-----

--hka0nQkqB2X+jW7l--
