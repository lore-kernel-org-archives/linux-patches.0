Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DEE80624;
	Thu, 23 May 2024 18:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716488296; cv=none; b=rcD/hOo0UMGOHDF/hy+ZOeIn4IRl3f8VOF7SV0MM6CWVACD0Mw6R87j14xGsirjiSXfiDOMguJpaNXpe8UoDX7zk1AsJFnhHqPjweZZWLpoCNGYUg55b30jNndP8XcqoQwtcTtBXcCi3p9dumgKexhYMrwtHR2J0DDoHojtHp6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716488296; c=relaxed/simple;
	bh=3hgaT8w78kZbabZvkkL99Z7aNo9fxNK3vC+w7glVJg8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rwWflrm3EhBDR9sn+NaWSpftETCUJx/BGswN66sguiIhED7OJq6YlOWCPNcUfSu077LcJYh9OJV+FAtU57wSbZaYQCbLjunBTt5iTgG4CPo4a+nN6GSaFLu5AZFuPN8qQ6bdr0uJD33DLjLDT0WN+681zDKQixmNsIDGpsbo6Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FcThVIU+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FcThVIU+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C64C2BD10;
	Thu, 23 May 2024 18:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716488295;
	bh=3hgaT8w78kZbabZvkkL99Z7aNo9fxNK3vC+w7glVJg8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FcThVIU+C598QmiNseuOu+siYfHUC/FXLHI7ZmmTH59ahcHzhUSCg49cN7nhCsmtc
	 Bo3eAXD7eo2EwihQLlqAYtrSSvYvY0tgICqwUbls//APj7RD1DE7IlYPdFcVylj3Jv
	 efeGJKndaZ8K5grS9dGQXD5Bp8qDMHFrLfxX7DnyMfdz4Xp5MEGUAhwo6CXhQH216w
	 z8MuiTyk1wlrfGFD22IdY5eeTcxun6pGH+RUY7H3Z+rrdc8wqb2qiNZleIQAEhA6bX
	 GqIDNzLpZrYYAX1yp8B+S5V6+dnhD55TclMXwr2IpHN/kSBRyGmEBPyGCqG2tbZniG
	 Z1rYWsXerjAKg==
Date: Thu, 23 May 2024 19:18:08 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.8 00/23] 6.8.11-rc1 review
Message-ID: <248df9c2-c981-4941-b76d-7c2f54f24977@sirena.org.uk>
References: <20240523130329.745905823@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="w49vzORxSFr8toXp"
Content-Disposition: inline
In-Reply-To: <20240523130329.745905823@linuxfoundation.org>
X-Cookie: You auto buy now.


--w49vzORxSFr8toXp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 23, 2024 at 03:13:27PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.8.11 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--w49vzORxSFr8toXp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZPiF8ACgkQJNaLcl1U
h9DjjAf9FNhF1wqIw5GSygmbyypahKcjhKsVO1kqXfHA12QPEibsXe8+opidExbk
re0gja9TaSSJq2rD+0NU8sAWxllWzLAjvvgW/u5x1arPK0dMHBjGxRc33GfgHjPG
KboYIy/ffOUMalKsJWBGEq9XGnlGkJEtf/JTp8IvP5/StxJvZpILZt0lsaR0Hage
igpXJQhHWcBEDoY0oalBlU6WbwV/SCkrRMc0srbr4m9zu1Q1R+Klr9fPjDoeKsjZ
FEddwwV8/JZTd0THJ0EwMLDmvkFnNYoL2QzNqoFEcLGMCv9loZmuY5Px8XH0XgC8
CUxXK+Z5wbqv+VISm3kx/appkT9OgQ==
=l2zF
-----END PGP SIGNATURE-----

--w49vzORxSFr8toXp--
