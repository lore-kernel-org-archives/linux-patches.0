Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467D733B6D4;
	Fri, 16 Jan 2026 16:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768580606; cv=none; b=eitMLgf6PBypooVOkUeHg8DN2lHSgpi8Ddpb1BRizHEPcsMj4dFZX61gr/4McPyQJ7TOHmvNAdOwN3aAI7roxvQz6ql945oxAiiZCyX+otGChvLqgmBQ5n4/7YAZAZLj4CjkUzVUQjDcW49nwTwnd8ho5DVqpLsdHQPCX1AtMbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768580606; c=relaxed/simple;
	bh=z4ZuFuWTzthe7n3AbSxycIDk8nstnDtf2sDSu6BSGRw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=agkcBAZ6yKm2Y4yhmvvp8ZQeYfpTSqmSAyO5AZVtNGjna5bfcTVW53Zxl07u2Eu8wvvgJurDoWX7CQzPsNK8t9prRZAvBo7Gcuytsi9Tix+mNf3uBAFdDKTvFiuy6RPpHruG4+Uo+M0qMYRQvLH6SDDm+2pgbt+xyJB+HsvjJr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PWTx2TlQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PWTx2TlQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A42FC116C6;
	Fri, 16 Jan 2026 16:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768580605;
	bh=z4ZuFuWTzthe7n3AbSxycIDk8nstnDtf2sDSu6BSGRw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PWTx2TlQj0SpssUW1NdgH07qdf1lbR8ZYShDMbKSQQrWZiujTA8f0+A45yTlYEt2P
	 MvM7nCZpLdJ2eJxkHzQTYcUksAS7lUHmlBzzBDU/ipwOFbBTK/mDaLzTb9BUN2dXqZ
	 K5E5M3ZRphGM7LK0Jl2O9tZcK7/EvMLls+OViKI+ocBnvJ4bkRaWaxb487siD42flO
	 6qlldD+Y7m+1oTDA1sT+S/6W0/Hiiyv9DobtF9rTpfMjpe6YBddkm/itNeSAKg2ox4
	 cIeZE2IbhF5i9MU2nqxndP0SEIloxYXeiJ/HdzyKeQqwmeAZnEP/hlZDOxgCziIHZK
	 KRAXXIRWCmrsA==
Date: Fri, 16 Jan 2026 16:23:19 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/181] 6.18.6-rc1 review
Message-ID: <a902e6e0-20a0-41bb-aa76-9cb2f99f22dc@sirena.org.uk>
References: <20260115164202.305475649@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="scYBtMyrBuHiE6yR"
Content-Disposition: inline
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
X-Cookie: I've only got 12 cards.


--scYBtMyrBuHiE6yR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 15, 2026 at 05:45:37PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.6 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--scYBtMyrBuHiE6yR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmlqZfYACgkQJNaLcl1U
h9CMRgf9ERzKExGkHW4qPs0V9lErB/7jHpxeh4DEIWp9/nOCter3cvJRcJBB9k8I
rXnYZf8kC9c9xbO8UGdN9HXGeSf8tfThnHMH9ZJes62czwW5ZVnRnd4b7IsCng6y
OPq4IJX3BamWhZoR/ww22dmgzOeyHWp2At2FlF1MCyaDzCP43ysc7c2ciuvdgrxO
rDy0zC7OG7I8d4nKLQztQxABUJFyaEchaPNudKHFUz8uAVAGdo2+gs2y6Pvl7wyy
ZecSn00Vs0d4jrNsf4OAxQD5QsEMd4ny38go1gCZsGES89Aakj56F55gPL5wfbwU
grGabmffvvpTH8ypY8PjewLcaaDSyQ==
=dM8H
-----END PGP SIGNATURE-----

--scYBtMyrBuHiE6yR--
