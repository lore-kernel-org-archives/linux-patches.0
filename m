Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B2821507F;
	Wed, 22 Jan 2025 17:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737565691; cv=none; b=jX0Xo3AxDyZbBWb2zFQ4DCb0BsFIcTx1nTqBv7Gc5Jf8a/x6hrzdtMKy1VawMwPWftoq3wGEpq5drSNjOCp+1q64nwq/9TpAUyZ2yQzIJeeE73JiSwxSgmY2LcphzaSuZs1njt59SqfUxF/Mq/ZFizIOe3G9vMV2LfhJUre4Yg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737565691; c=relaxed/simple;
	bh=YrxsAG9OjBLAcl5IL7TrHiXUiNwyQTRsMuaFolwlMjw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dwijbzoFGvl8/GNtpHlVV0HVVq6MUPdanF9AxVjmV9JWhwgPTZ2MjtGqrBQg9wHL8GDwMDvSduPAcgZDL7z8mkZKhLoXA91Ia9IDRsxwQ1+50Ix8V/VJJCc+mptxXj7BVKwpkNCEdGFfQTQzr/ZOPR/2lmrVCbHduVDhlEqMSPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FQXm4SB1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FQXm4SB1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E94EAC4CED2;
	Wed, 22 Jan 2025 17:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737565691;
	bh=YrxsAG9OjBLAcl5IL7TrHiXUiNwyQTRsMuaFolwlMjw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FQXm4SB1iGFEJ50bOFMyPP5epGsIjAzvhaz2AKKqaGGyZgpXni4S3H/6BWJcKY2Fl
	 atROo/FbkcW7hihFZIbsleNULiDLc7R8iUOWak2Xkck5Kstb13D7LgvjGoVTTRiA7b
	 GNYronCv7GWCuVCH7P69VNlX0qxcwG91hZOqh+EeJajLeXmux7DtwPWHkH2mZz1NIB
	 Gg48CZudICmAD1ZV+MPyYhSjDgFWD/L5Wzy4lmpFOQOMnIYzwEivWrBZJ9YifPsnvF
	 U0witdLAGgMQKnx13x18bGveZJYAp/P0VAmIF72q8n0jq+hIkeEkrt9c9G4Wy7NrjL
	 mYk2+WcQbHYCA==
Date: Wed, 22 Jan 2025 17:08:05 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 5.15 000/127] 5.15.177-rc2 review
Message-ID: <48c7d53f-0ea5-4544-aef8-bbf1c8d0bbc5@sirena.org.uk>
References: <20250122073830.779239943@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="VKtG/M62qGTJnFoV"
Content-Disposition: inline
In-Reply-To: <20250122073830.779239943@linuxfoundation.org>
X-Cookie: Star Trek Lives!


--VKtG/M62qGTJnFoV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 22, 2025 at 09:03:53AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.177 release.
> There are 127 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--VKtG/M62qGTJnFoV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmeRJfQACgkQJNaLcl1U
h9CWAgf+JGvUbAJchf5nbeNe8rlWqmPHmsqlMwMvA2EUZKdNOC05KUsU0FxLqNS/
rm4DPI6uXzJyhmvELJs+Kvyhl7AxZIiuyN4ybqE+fxLkX687nO/Fq8CkJJrOh2Zi
fjP8K+7B49hr5Ai74z1SThLURyJ1JgWG0AdbzUA6O2//MJ+blkEJ4P88xgCc/gri
mvaEN60J3H0e8vCb8COrn8rqMzaiyTnbwmd1zAvtAYQyRLRoLgSpCka51NkMudEQ
jW2r//SxATqsuEdUumy1pV97mX0nrRIeKGwRn1mW2Tt8In1ea6bvPO5MEq0cUn0N
m41CWfXJVDjb7mFj0vQateDMYz62eA==
=hW1/
-----END PGP SIGNATURE-----

--VKtG/M62qGTJnFoV--
