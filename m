Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1363D351C3B;
	Tue,  3 Mar 2026 18:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772562459; cv=none; b=QplJWqrWTOHZvcvV6iBlhfoX6m5jGFPaoGAELkwtp/+Nfvqk09oz+8vP+pSbiTZKWY9JPcTQBajWRT94OB0viEpna0dO8nI+ku5qiWft4X2dQrim9lKz56Iw64ALMMVgYIWYKme4/bRUAgbW2JLO7vAiuwgUbW8F9Mt9gVwE1hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772562459; c=relaxed/simple;
	bh=4iSWk3ur+aX//gqOLGl5Y3tmGyL655IxdiODq7UpVf0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LNFkrPxu15670bOWJRVcbLNS3WNyZ9/iVFSTy/PEvWu9n1QfgFQbzaLf/5NmvkWuLqhqF8bFInqWz4E9soRpUfEQWkn/qf77O9WTNt0zvjHVRdwzzrxtIMC8oipPtcfwdSbk6uF6cxhDTjqGFimiAQJQB6nKSzx/kusXroRC+Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gHXaHVjD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gHXaHVjD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E459AC116C6;
	Tue,  3 Mar 2026 18:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772562458;
	bh=4iSWk3ur+aX//gqOLGl5Y3tmGyL655IxdiODq7UpVf0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gHXaHVjDEu2Im6ddH4h1bh4wAQZ96uBmYuDtNkBTM3TG/XtfPgRR41yj3DBP5OLld
	 Ed2AwqyAHoEUJZVT+OtHjQ/9FAn4akvzhqYSguAXz3P28cCBwHJxyFzIszUICvTfb/
	 dmPz5q5/oxQMRHPFCrVAB62rpeI9XzT+TidzLDpmjulUBRfQOfwYtoVVLu9p3wl4++
	 4b2gDU0IePvRr6YdR1avHG5Piiai+LdCqrjWo5/qvu2jLy2/JzwKlhZBjrLrfeo6td
	 HrbbesMcUoy82l9re1z8+5TeGY06c72Y+l2QPfVLjjNMiLkuCMIReZKQVwUcqkz3aP
	 BP7CPDsgl3bzg==
Date: Tue, 3 Mar 2026 18:27:32 +0000
From: Mark Brown <broonie@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	gregkh@linuxfoundation.org, patches@lists.linux.dev,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/757] 6.18.16-rc2 review
Message-ID: <ab3b8f38-863f-47ab-9d44-a1cf1824a8db@sirena.org.uk>
References: <20260302160853.2519610-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="bs8TmucooCNH4dT4"
Content-Disposition: inline
In-Reply-To: <20260302160853.2519610-1-sashal@kernel.org>
X-Cookie: Use the Force, Luke.


--bs8TmucooCNH4dT4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 02, 2026 at 11:08:53AM -0500, Sasha Levin wrote:

> This is the start of the stable review cycle for the 6.18.16 release.
> There are 757 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--bs8TmucooCNH4dT4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmmnKBMACgkQJNaLcl1U
h9B2nwf9HUzxBOKtL/Q5Xg8IfkLeTRZ5n+SyTX6qAv/oq5lP4q0WrLNajhTdQa9v
L0RZQXDqvrak1JNUZ3a5CQZjW7wMhJ5AD/xdbB8VRU78866rLHIS4MsoKQu3uCYo
5ZGV6hsyHEE23fd0seh45d+xV68X8S8qP/1Q1WaKnAuFDg/AsRKRIhZfGeys/CQY
kiklzzxfxSimiw69IyOunav5FEdeFMw5J/GKdJr15PmQmb6uOhrDo5MjejyvUu0X
YLagJcanyXxLYkDpF9m47g7/DBWvG1xUuc7wJd1YmssqJMl+mFPionymY080bLKy
mQihT0kU938YDEqGW00N0OHC3pr8JQ==
=YUMy
-----END PGP SIGNATURE-----

--bs8TmucooCNH4dT4--
