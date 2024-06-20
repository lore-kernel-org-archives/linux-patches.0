Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695911AAE12;
	Thu, 20 Jun 2024 11:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718883726; cv=none; b=MO/P38Wjn/MdUi0b68uYazETu4puKmC+qOhJGsYNMvmpmZCFz5pnGVL0IE1KXmTgjz/HaAzeBpsWbphTYrrIAP2VN7PnfkEMCzOrxB/9IAqGkb21W/2dzaYPsKZ+zHwplIWPXVheqoZSw1KbNhCDS3Yyk96hC+HZAz1Zch8HoAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718883726; c=relaxed/simple;
	bh=Fl/meoJ9hW24/lUGw0b0OdTMIjc0zn4uaifHlua49hI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l3xlH5k5t2xXYOUlM8RDX2xDQ5a6WGDzXZwR1At5J7Nk5scaFb+XXrZKx1S5aRYSVY86irt2VBdw0ZgXuxnYpS/EZ8QK9cwU4FfIjt9YVJes0BrD4RdjzTZnZYqoVCLNVnrQpGek910krwLGK2S0YbT98Xrj2SEx1spvDqadGpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oydk22UJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oydk22UJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 946F6C2BD10;
	Thu, 20 Jun 2024 11:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718883726;
	bh=Fl/meoJ9hW24/lUGw0b0OdTMIjc0zn4uaifHlua49hI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oydk22UJfdc3kWGqOeAIhU49QYcl4Lc6HnbUo72+VutuFphIPPPXsjhZJE89qikBs
	 dx8LV5lhbeb24YNDV5WZGSSNKgI0+WXbuDA+lzLsWt5KoJIo1TyS2gndsUzs6leA+q
	 S52HBtapaL91C+f7aSDNYQZFBVWvNH8c2To6pCzcCJvKuZXNr1+Yu+qBmyzBb97ogp
	 YR7p9ji2ObXex/g/yqPf68I3WKdKgIINEjv+r/4eC69L2XaiAy3PNTGBQ/PBZyC/Q9
	 cXtNm+obnpLkTcYiPYmSb2gIIgQ0dj2mrBjasaWetsOE8OsNwVsuSJ3Gh5KlwPEaGr
	 Ih8dg2QpPGc+g==
Date: Thu, 20 Jun 2024 12:41:58 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.1 000/217] 6.1.95-rc1 review
Message-ID: <7ee343a4-f42a-42b3-84cf-2617b0131197@sirena.org.uk>
References: <20240619125556.491243678@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="r/iM7pK6grmTiquK"
Content-Disposition: inline
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
X-Cookie: You're already carrying the sphere!


--r/iM7pK6grmTiquK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 19, 2024 at 02:54:03PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.95 release.
> There are 217 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--r/iM7pK6grmTiquK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZ0FYYACgkQJNaLcl1U
h9CB2gf+L1/PKInBdGKJiUkjMlfN3sZOyot/+neHLRc/tax1VkZXOoUzpuU7aP0K
pIfgUk4eXItwYqNsXYbDxKwCme1/v30Rjb3TBeEUr4VVALHnCe74OffYPaRih+gm
JbscxCqTxPdewm767XCjggZkKlIkNMCV1B57anHEejVh/3h18wtymjW8VnoYWat4
PM4ntRWKZSFYpFfkmRLBNJfTxNCxkV1FNHo/wEXCrH0NbtgjewtKQhpY2wjEJgE2
LD6aiRrhw5yTz4MME+S27Gndqn6GpXAEtmgx181ft5vAXp7JbLaHwFlSMMrTXd4K
Y/+Yw2hT9gZLy5wZUryJBBdzb2MuKA==
=AKAY
-----END PGP SIGNATURE-----

--r/iM7pK6grmTiquK--
