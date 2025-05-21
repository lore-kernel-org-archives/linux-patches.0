Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75DD19DF4C;
	Wed, 21 May 2025 18:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747851407; cv=none; b=H0H4m0eOAthroq0t1kTeyGpNRzfZKUKiJo0VQBJx2FolQRpZcB3CBhFKR4iORWJ23zFp9V4ldkuGeSXpop5CNryfxIgFNcogsfdEVuruy5wTe3zmi6yMt5kbP2Vh7GUSCsS1q+xNJCPQTWPn7h+9QZaJA1Q6fE1TTg3SkBNznjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747851407; c=relaxed/simple;
	bh=9tmrg5RQZaCazyfwqN15ZQHkA/yKEelqV06wye+ZD3k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JnM9LgRwJ1+5RxOcVKG50OS9+xmWv6Bh+bB8bawpMq57QyKPQZZdY1I5yogUZs9NDi85VoRMuM95rM1iCqMCR/PtvEDGCh0DUXwVyiUTkFY2//+7+bpNMPcdJTdpSdCwyk9ICWRCyiuILZORt3xldm54p28qenX+jCcVgMhpAF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gBsNmyDu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gBsNmyDu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D03BBC4CEE4;
	Wed, 21 May 2025 18:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747851405;
	bh=9tmrg5RQZaCazyfwqN15ZQHkA/yKEelqV06wye+ZD3k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gBsNmyDuiDSA/VGDCMr/u7TVrKFTqEYHP/LkDhx0Xpc/X7hp0qugI+gxC7z/99cJn
	 CMTytOBJnaiiKihV9OSDVkgmRDxzh4XMCpnfLWcEZPA1GivRwzqJ+ohLcaIWQtIBVP
	 dEAZWY8zc1jgDvIFE4mRLesdyLoehoXdLZdukeHoE0u9hyWUIxcsB/LyIC5m8zo5yD
	 EmfWNkGnjN3tjilXdJ4vX9L97L2HohDaYugiIe/gxCj2hpBxWgi6XO/pP4l91VgWoy
	 sezgVHied9Vl8+siDZeAGaTApvoT0tVJ6v9/bwEZEJKdUgLsNWdu3pc2K+TJHm+cJO
	 CEBPaavsAiM3w==
Date: Wed, 21 May 2025 19:16:39 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.14 000/145] 6.14.8-rc1 review
Message-ID: <8162ecef-8343-4b68-93b3-b949cf12fd16@sirena.org.uk>
References: <20250520125810.535475500@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="4jHBzb1L9C6kFbAC"
Content-Disposition: inline
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
X-Cookie: 42


--4jHBzb1L9C6kFbAC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 20, 2025 at 03:49:30PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.8 release.
> There are 145 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--4jHBzb1L9C6kFbAC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmguGIYACgkQJNaLcl1U
h9BGpgf/Zi1PFtP4xhcABmRWe3A0t5MDrGJENv818yyzWee9Me2AonoNnctW2tZ8
e3p3G96zdNSHodZhKA/Gk7n2CQ3yhqKzTla56Ec/xU6j6w7S5emhy9vlVcjKa+EO
aRQ7WcPxXpZLnNqlvTz8TyGW9EPjwhP+zU8qKzSDUTES77L3FjaYImcjsxMX0fjb
HVRLhXmeEvpTLrDDisFhtuFbzxqBDY5hOF6gE8S9Wkhou7jHa7/tm7MY/yhLhTP/
uqLrfvkd1Tnh6KJGpS5Zp6yZXoTfJS/QWxPNmf01w0JmvjHKQlZ4a9ztTLc9tcEm
B2ACiN2yxe2RJHgCjPBVCqkst5P8QA==
=0cuL
-----END PGP SIGNATURE-----

--4jHBzb1L9C6kFbAC--
