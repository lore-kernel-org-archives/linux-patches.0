Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D69AA15624B;
	Fri, 18 Apr 2025 15:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744991763; cv=none; b=FbAokOQgqVxkQ+OPl0bmjI8ef49chdjFXX/O4vt7tiQGX+GX41mTT8Ho7H34mZXKDhhHEv2USekMXEi0Gj4NFFPMG2HfKWrABYuXsIKMwMH9rJv4FYNscWH6QFc2tBiedO97GKMcfLHVSb9NrSpztmYzr15oBK825nfa89zfHAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744991763; c=relaxed/simple;
	bh=Lcz6Vi38WInSCEbN55sKa5MN9XK1NMjZLwGK3L2ETks=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OwQqbdDYHvdHza4BC4M2IOotc5klsjqSwwCmzZs9XmTlxYWAqAUHuGrWP/5v+txkkLo8vcvwcUxRs4NMM4HnHHNelNzUa6K/j3wVqo4FB7drmbgnKRN9+Wt/0kwvTyRYMOCYV9KVQ/6Xq3pZ13i741lAOYZ7V6jxHxyYhEtIl9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mylidbcu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mylidbcu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82303C4CEE2;
	Fri, 18 Apr 2025 15:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744991762;
	bh=Lcz6Vi38WInSCEbN55sKa5MN9XK1NMjZLwGK3L2ETks=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mylidbcu6xSrLAoaqsPHW8pjYjCWx+CKifQcOaNiKqLp8sFNAq8D4zY+Rnvrz6GcI
	 h7oFZbFODf5zAOOqJMTdKv5EkuCu25DdrjqyFtSNURN/3IOtE8L2U6SiyTAi03NqK7
	 ElQO64WR7MVDWubpbzRlmou9tHcocgT/2FeRD/JNqOXmnup4Nc6C+2gy4TDQArES+s
	 8xkFEJIuLKdl1y913EJ5Ae22fEKSgEJZ6+eiN6JgBegwWNQUpqurGlGh1EeFFOle7Y
	 C0niNsbw4Ri+OQkgp7qkYnwJjP9cdaponec79gNiPIhZf1FDHfyRF7bz/7D4/SW2v3
	 xtpNwaEhZ+ShA==
Date: Fri, 18 Apr 2025 16:55:58 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.13 000/413] 6.13.12-rc2 review
Message-ID: <aAJ2DpBN10tq2dFG@finisterre.sirena.org.uk>
References: <20250418110411.049004302@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="HL3UoVhViSFsVcbA"
Content-Disposition: inline
In-Reply-To: <20250418110411.049004302@linuxfoundation.org>
X-Cookie: Well begun is half done.


--HL3UoVhViSFsVcbA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 18, 2025 at 01:05:17PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.12 release.
> There are 413 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--HL3UoVhViSFsVcbA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmgCdg4ACgkQJNaLcl1U
h9D7ewf/fVBUJor52ChtTThtcqqi4UycfrvVThIY3JSeZCE0QBpjv2wjGHZgy47g
IydLd1iSZKjVW2AuUBkTStuTqNpNEOp0NPkdhRmBrRqCe02u2wCVxaol7R5OotrK
Of6ASHp6iOV1UlYCf5cIS5IcqmJm1M3jNv6sZzXAY9ke8inqk4H3J0DjNavMGU3e
JDJpVmgnEYWpP1mEFMNrtTRMW8ZXEqUphZfdOAccmbfPb8rXiqcoDxYHk27xRGz0
EkxxonLZMbYG6wQD+apvd35GXVFYYKwuSQ+6PtVk+TTMQvCTrRO19Rj0gvxk8ZSO
hUoFETqKQn21H9ZwCe6BL+i2xXnWWQ==
=AJsB
-----END PGP SIGNATURE-----

--HL3UoVhViSFsVcbA--
