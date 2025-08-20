Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF894353371;
	Wed, 20 Aug 2025 11:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755688812; cv=none; b=AshgSiMsQgu4QOPM9hFUHI8GBST4pYe3MR5fzqMMguPxDVBK99rTpDKVqYDHMuM+toxnYzcdm9aKcf8Zh42e9PbLK1oZKidh0Y2baozCEfy/HvhD57NUBNswaYLpnpa8Ds05m+Mh8sJGr8bhWKsxR/DV4WetuM4nkOR0VOFNDig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755688812; c=relaxed/simple;
	bh=8ZBJ2mvFvj6oDS6avl3k5cuPpoE8VG//1VWl+suJbE4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nL4mkISThCmcXsw7nD6KO5eHQ+/JLezNM7n5oDuWKGVnKc2LhhRm0Y9ZwncnIF0aP84KZszuYEXIvIp0kicPvVogZemet6WJlTiIow/W50A/6HWbpO1PQATZqgma3yDwbP+CntDJz9jgoXeiAnrPCndHRWTwhbRDwSM9J9YwjBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f2TgokLm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f2TgokLm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C9FC4CEEB;
	Wed, 20 Aug 2025 11:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755688809;
	bh=8ZBJ2mvFvj6oDS6avl3k5cuPpoE8VG//1VWl+suJbE4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f2TgokLmw2S9fnzr6GffIZPPVJb+DfdKodQW5V7okyvjYn2AGwIuTN1+7ieNSWD4S
	 UGAaKWAl5BykxXWV+d//cwc/MI61c4Vw3XdJByKrsC9in3YHpEyFKPNAHfngxKJLsj
	 Ng9oTOUbq3AdLDYABwI+SWhHJLlUzCX/hfGMt1w7lKVOxUZBT9jteXj0+7OtWXktrd
	 I0y3ssQSDPfq0M6/zb4CxSUE0agdame8urDJd//sItVWDmzMmLP/Oga9fuCyVyDT2/
	 CEYhzVSdHH4u78XCcx+bdHxNEm/WbruMH+VlCEMM08JIwJ5tqJxge6S1bfeJz5fL6a
	 sMTmYR/5QP4BA==
Date: Wed, 20 Aug 2025 12:20:03 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, achill@achill.org
Subject: Re: [PATCH 6.16 000/564] 6.16.2-rc2 review
Message-ID: <1c3f1b19-c078-486b-82b5-d3da866fae83@sirena.org.uk>
References: <20250819122844.483737955@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="sWN2PMYHzLLtvYUd"
Content-Disposition: inline
In-Reply-To: <20250819122844.483737955@linuxfoundation.org>
X-Cookie: Semper Fi, dude.


--sWN2PMYHzLLtvYUd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 19, 2025 at 02:31:49PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.2 release.
> There are 564 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--sWN2PMYHzLLtvYUd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmilr2IACgkQJNaLcl1U
h9DnjAf/ThFPztD9JOArMJPGoP8ThGkqOrLZRAZ5CtuN0izUmO3GHmHH7C/VybB1
CTXx1D60QZTj2mGuswtT7nplnBj/L15N5KC2YMudQ1h8su70OKzDh3zFgVmIwNGr
Pvcg7Rhdaf3V4xmSm11Tm33p+gmM1q9ht7zNsfO5rOAI+6bLoe4RRMyqCvfDVPzz
sdE07E0dIjPL/08PkzuOMWqowuow8aTs1u9HnFaMNiN6j9J87UkpPPkcLblnH5vS
raDdff0hDdA8LK2+TLf1LVBYVgZIk9vRjggm59U7u5wxj5WFlmVBoW3NgNXjNMft
mPcKotYgQGGtpNcEoYhIwz9BDLql5w==
=4oA9
-----END PGP SIGNATURE-----

--sWN2PMYHzLLtvYUd--
