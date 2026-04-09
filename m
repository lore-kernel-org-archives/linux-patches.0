Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB7B2EC0A1;
	Thu,  9 Apr 2026 14:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775744208; cv=none; b=oipbB8iZwkcLu8/GbH/RaF4DaZfTUKgVwhT0ougm+6yPxnjEaT7A/t+bRUsqCOd1oiR9cPl9y1Mm1Zefz5yc0LE7+fjqe/PJT4tUss0aEzO/njIn98dPbBn9Ihw4k746DkHKaACBHDUAl0rrkWfhAPZ6TQTI/HiIsPDpElXrvm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775744208; c=relaxed/simple;
	bh=9GCDqvf3ouE1tZChLaCxCFk0pdlg3TigRyHsCi6kqYo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K/VtbZcTbrWFNIruaRXUCu+dq1/luDyyNAe3pCP84KUBaWL+0wni14DNReIO74e1Xq5tnnauvGnSEPpT5Vx7TEi+pbSaIPh3nPd4SMY5dmIsJ4mG4Z5N1gz6RLILH2kF0bIuK5LrquB69z8ZyMQ9003OSnhdWFLS41zg4ouaZ7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qmal5Jwt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qmal5Jwt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F58FC4CEF7;
	Thu,  9 Apr 2026 14:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775744208;
	bh=9GCDqvf3ouE1tZChLaCxCFk0pdlg3TigRyHsCi6kqYo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qmal5JwtT3w1nRruUKdqyYRHQyOnwPnxWpM0cQnZbAz/q/gostrAHu/ofb+lnoF4z
	 sidAJk/IL+ig6zEoh7lBb9TiKLfwXOpJtgXEj7FFaACtqkC3tDOOYSZV51KKw6dYEE
	 I1XE+ApGlXRSXFo3/qpemlcF44AgpoBdOeOvQ+WSVHueu8QTNNrRmPHrTkMcqWWNAB
	 oO0zpOwdyfrSNaR3WWRUEibKXATF6lERYe2Yo/8RBXwQzL3ZzrAsVfZEq6+I84byNf
	 5A7bUDLEb8AVOEw5/JmgsFAWUqoS4r5BnEn84+qx/YwAY4q9NkJ3OtvWefJM+PVEir
	 BFZJ2lEGSebHg==
Date: Thu, 9 Apr 2026 15:16:41 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.6 000/160] 6.6.134-rc1 review
Message-ID: <9716b9fa-132f-415a-8998-89d6d032dd73@sirena.org.uk>
References: <20260408175913.177092714@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="azmIMgNWjcBpCevv"
Content-Disposition: inline
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
X-Cookie: Hailing frequencies open, Captain.


--azmIMgNWjcBpCevv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 08, 2026 at 08:01:27PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.134 release.
> There are 160 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--azmIMgNWjcBpCevv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnXtMkACgkQJNaLcl1U
h9CJywf/UMKmsSEO9sIQtprejPg5ou7FJWY24miX8C4zlOJ0v5PvMS2vHBWqoYCV
krEr4UxHOmHJriess081e10duDg2cwj1rvMlC8zkB2eWBPtOfp9fp1SqtmH7Hlo4
q0qbhs3RfoHE3hRfRUmG/6Up3O5/VR7qCbB7xJLbohNsuPo5xPRv69RgDcrxI5AL
DlDB1aZix9MN2a3hlDkqn6qiXItowaV6IpQ91aA6wCF/JO6ZDg+i6njL1dDyl9Ev
MbFsB2mewdXIXrpaecQ7mXqV13YVCDBTtShsEUHd1SOOKweCAp833qbwVJx1XS2P
PikHm4YqjcO7xg+MpbL8C3RZFDCScQ==
=aPaK
-----END PGP SIGNATURE-----

--azmIMgNWjcBpCevv--
