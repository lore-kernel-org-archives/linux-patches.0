Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D878E221F38;
	Wed, 16 Jul 2025 10:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752662651; cv=none; b=Q52zXFi0SOLrEuXSdBQkg7eMaxDzAFkmePLiprHTCtzhHdg4fy3WP68ERTsb+cSXOPdEU4AaPEk0mMpF6b1Zqn6nHFMPaZZQ/S8xAFXSyYNhoT2Tv5Hn3+Osi3MJoicIORSUZ1wkK4Rn/gqYefJY+Nv7W3kZLeXey86rWplZit4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752662651; c=relaxed/simple;
	bh=woM15sNPZtZvC6iqxrA2B1KLtGhggiyRU4bj1TsJjEQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZVxOKP9fuZEJ6uee6/ghjpwp3jKdu1yH1qJhA2oRD1jZdhJSTxrtyALuovxLVsuaiVY/eJlcshzENJ01EEjix5g9GzWHRp6ZPtwOR+hrCsIPm60D2DzjDlR9Kel5RFjoj99WYqKhOzZgLeLDjdNZBNZ1zGKLSM9EUINzuUo311k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tMuaB3pS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tMuaB3pS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B2AC4CEF0;
	Wed, 16 Jul 2025 10:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752662651;
	bh=woM15sNPZtZvC6iqxrA2B1KLtGhggiyRU4bj1TsJjEQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tMuaB3pSVWkysNUNRAhB8Ef5OQZlhpF3C3L154ACmz5r7+2xxNSARkILzvPVs+9GV
	 Dv2qfihT8fe8fL0wyeLrXPHjLStzDEPesMbkmXQ74A/qF2sYYK3yZBo9NaJPK+C2UK
	 LuFO+FlBTtveQA4lJwgGJF4VLyC1oDUgaKtJG8WyKhpzOJcxUWHmBmOHcYnqsiNjfz
	 kGvVOwBe9uuKwhwlIZJ1rMNsWiXQbO3CgEwMWZzT3ctXOB3fbUASyLvZrEdwz4C0Al
	 cSrSVYi3F3mmBVANb5a4y1O6k1r4tKh0rvhkvglJCn2LnM7FlzDLk8CtQVTxrrdVyv
	 3qub8nTezZUjQ==
Date: Wed, 16 Jul 2025 11:44:05 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 5.15 00/78] 5.15.189-rc2 review
Message-ID: <a7142b3a-df38-47d2-bc1f-cf52ff230aa8@sirena.org.uk>
References: <20250715163547.992191430@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="hYeWHj1K8HaGqOKV"
Content-Disposition: inline
In-Reply-To: <20250715163547.992191430@linuxfoundation.org>
X-Cookie: osteopornosis:


--hYeWHj1K8HaGqOKV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 15, 2025 at 06:36:53PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.189 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--hYeWHj1K8HaGqOKV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmh3gnQACgkQJNaLcl1U
h9BloQf/V8jdkxsQ8/6NR/ViBdQpAJHI6xKDdB+w+6WUW+CbmxKhlCy1HxHJ7J9I
skod0r9UmaE0XWrwwhjQNvsdVtmYK0SNlUfkykNF6mRkFGjEPD0eO/cK9c7YJzNC
BQFgXn010fW7fPdZjzTApcUiyvDVQybINl2/lQc4ZFj/cfbb24YlYJxgMcSP/Ycl
/fecZqNHodNwACU+Q3bPC8JZc1r7r2hRMh+JKhonIrVf6R6m0FKzlhzcGJ+HxxTr
b7siqnQmcLtt211vmh53DTRWxQ8O/wTpeN3Ot2AwSe/1CgmZfKkffX2afH3WI8Gz
4wCTPSKh4ldk0NixBZJC2WRZmmC0Pg==
=ALS8
-----END PGP SIGNATURE-----

--hYeWHj1K8HaGqOKV--
