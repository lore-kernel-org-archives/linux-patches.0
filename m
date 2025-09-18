Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D50134BA23;
	Thu, 18 Sep 2025 18:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758218539; cv=none; b=Na/qfPzHHXmSyzNUqttddXZu1Lkd/2GqNBO+/VO7M6RUg2vYvtG646NQ1A7CntUMicge/bF7LtCK6qCTDZ7tFpmt6n+hPeuQEtY3LlLQGGZ5ooFofZnrvKqK+UvE+hdAcPWEiDzviOReyI/pZDrha70UajA4RPAk8LZzVGt1zW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758218539; c=relaxed/simple;
	bh=GRv/qMuNXPqIL5V4j+9JPVh4VfWxg0qTxoHmq6Dish4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TV6rQjSUNk2YPdScqhg0qc0EpLl7KsxrxyZyf+pZR4UKBVddc37rMRAJR+ASJcz9o3bGlIz2PgNMq9Te2PFNAKlk0DoZBb1IS43ihfn/gRsq0bhwVKEQz5WDmtHTk/TqtelYv/jDMwwIfqL0j05tqU54YqyL4oJi8EL8ODC9O0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gnX59kfr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gnX59kfr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43264C4CEE7;
	Thu, 18 Sep 2025 18:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758218538;
	bh=GRv/qMuNXPqIL5V4j+9JPVh4VfWxg0qTxoHmq6Dish4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gnX59kfrBV3qX15yxpkjtNLgUuolYPHnnYmjtm5ROuNxU6FEyTDm+ZDvNFTnZnY2R
	 pMEB1Wy8Hs7mulNEgqdrT7l6V9LnlmYvAAYlyTrWUs+ZEPpa7EXqKctHgka4fsxYk5
	 7GlSwFJWMm8ZB/yT1gyWO5MwLFhDmJdWtajYITFaYBqaX7gZmrQxvN9cMPPR/u1ML7
	 We8+8gEg0hmBbk9FNfN67XPk3IGFqubrQP0wfceNH63M24dL+0I81saLFi84fvshgP
	 b8hC6w79R+kDd07vxqmb6prBIUJnR6H+3lpLpebzNk9Z4uWtqfVXeff5bgcOL9HbLt
	 n21Elubsy7WHw==
Date: Thu, 18 Sep 2025 19:02:12 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, achill@achill.org
Subject: Re: [PATCH 6.12 000/140] 6.12.48-rc1 review
Message-ID: <d07e74d0-01b5-4077-b290-bf98b32f9799@sirena.org.uk>
References: <20250917123344.315037637@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="BC75i/grGq58he4E"
Content-Disposition: inline
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
X-Cookie: Victory uber allies!


--BC75i/grGq58he4E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 17, 2025 at 02:32:52PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.48 release.
> There are 140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--BC75i/grGq58he4E
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmjMSSMACgkQJNaLcl1U
h9AoQQf/Z5Hk2vtEzFgRsyab8wFf509FJAlmwRDZrdFYNd2oooSnxGmzRAtNS60v
EdIKlsLihDBj2smlbH+rM+bZN9w/i6BzjRJv0lDY/I89yIs+v7xvtIBmpM+o1iac
1njAgSuI2L4Xkyhmirxbsdfwp3l6IhZaUh7KKisnTUbiZuyOK0hKO8YHOV1V3t8+
ItyXOwf2Ohrv8PvPew70grOCSmeQ5sNsv5Tv5R0Rc3g9axGGLY9KK2R1WUeRbCDv
TZasZPwQu01Dwbauogjejcr/NO0Qz7gcm64cTqCId5en/LzZFSIczVcARgbZUkuH
XbLId/4+34ELdurZeQjrXw91W2GVkQ==
=yRv4
-----END PGP SIGNATURE-----

--BC75i/grGq58he4E--
