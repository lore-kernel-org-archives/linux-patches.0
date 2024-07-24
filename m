Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6ED2595;
	Wed, 24 Jul 2024 11:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721819591; cv=none; b=n8u0WTZDlDg2FttA8ScNzfJr76m7/2ZdO5LEXA4APhDSMq80bahc1EltIJ0/kHZlBmX5rzRCQIjbF8jyO5opDaZ/gcK65MlOddjlYc9GcZR/ERZdo+3w9zzklzy7d0KFGde3kArdR7ujT5bvJH2QTn1MPpZLF3EW0Nt1rZrAPnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721819591; c=relaxed/simple;
	bh=zeX5yGFo8cAhS3fNPgzG07uAxgBK0HKLunn1WVKFB7s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bzSEp/SMIgQyzvyK3BPEeWHa9jgh1nbeCcuu8+FYL8hRFY7nc2u06MLdY7R0FIHSa+El/18NZYFrEeswm+dNxSYXGvNPsJ0p0CMHWM1tcUmFLKCIN6HrvB0R96QE09H7vbMMjJHFPN8TrRHb/FeliYJgMCinkW9M9dUES8pi4eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PmVxp9u8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PmVxp9u8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8418AC32782;
	Wed, 24 Jul 2024 11:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721819591;
	bh=zeX5yGFo8cAhS3fNPgzG07uAxgBK0HKLunn1WVKFB7s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PmVxp9u8TWwPZipzVAIqZ15rKWNLqvAPQdonNX7vA9FIMctOgKAQJW/ffEo0RYrcS
	 8PnLci1lV/1XPz5Wn+YEeH9PNKRcU2JQ81aqxM1qoQna9UdK7K5q/Cd14LehKmFz9+
	 ZWs3esMsUyAmzSu/1bs4yjl/YPVTsVQRLGrHK1wPkygUnZinoGnSWiNYsaKjEnFf/o
	 eyH72thOQyYnTQcuYpuZDsNMSSvFcb6xiG/9rjhVsu+YISTtzGtUd3Tvx1Yn/osqa4
	 CuwODhpgN629AwG6zzo/BsHrRETQWo4rqPLOewgoiJOg5UYAYTVinJbm6RJA60zGbJ
	 gLwsMuw6tQAdQ==
Date: Wed, 24 Jul 2024 12:13:04 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.9 000/163] 6.9.11-rc1 review
Message-ID: <cf5ae20c-c581-4b98-a24a-37d0b479120f@sirena.org.uk>
References: <20240723180143.461739294@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="DLb9R6akA0P/lm9n"
Content-Disposition: inline
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
X-Cookie: Editing is a rewording activity.


--DLb9R6akA0P/lm9n
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 23, 2024 at 08:22:09PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.11 release.
> There are 163 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--DLb9R6akA0P/lm9n
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmag4b8ACgkQJNaLcl1U
h9BQ+wf+O5Q49Cv0pfgfaweOdCK/AOXn0ausK4LqcZpROainENTNczuIZWmk79Hz
vd/WuX9xDTKc0tISVTfcovtdNKyKljkE7rlQJQnWjHNpGLkbdY6x/ZbEvgE3w+9B
b7k+x3KyLS2tbeCckRD+jwA20CA22L/sBUnRl7Psp8doUJIV4PaPUuyYJK03dYoR
1rOACYcLgRWiHqVS5a+Pob53yyp9pjRIbiKWIRYajmM1oJMVC5whLJo9SQZNjGF8
ZOeWw6o4r/8X7s3EmYiX0hdNwGbiNQPfeHRvyv5nGODBe8ByVq/XqkM1fkIjzgvG
4gZr1vQL31RAVrNiglugygTB8IsT2g==
=lFXY
-----END PGP SIGNATURE-----

--DLb9R6akA0P/lm9n--
