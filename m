Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA3042A83;
	Fri,  4 Jul 2025 14:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751639951; cv=none; b=sSJCiSg/HZVYYh15PmT/ckUo7yygqoF7W+CWvKNONW0BSbIfql3m/l9/UgFUmC3VmrHIgzlalK0boii1x2PLn/j7MrCT57FcVCpnQ/Vr2TS4TTydMMpntUZXX1/1PYjmeE65j9s2iz68bpMzM8dDFKjv1c9t30R+89xLIEc441U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751639951; c=relaxed/simple;
	bh=jyGnVhz5PkW5gjPGGKxNOeXelSHn3eaIgdXLKjLbjZ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nh0BytJIx+njZhcVVbvutHxZCc4eTCbu7u/5hFD+t4Fg8fjB1Qttc6mLCnA0CXMGaQo1ut5YtemZUvWXrEt2vQhovBS5ZcbEzVxJni5gyp7/Sx2QnDglCRB3qiwC5HNYLQ6t5vl6cckW/IW7H34u8Cv+PtOIftPEtdHVFt3IvMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lne7XnwF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lne7XnwF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2739CC4CEE3;
	Fri,  4 Jul 2025 14:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751639951;
	bh=jyGnVhz5PkW5gjPGGKxNOeXelSHn3eaIgdXLKjLbjZ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Lne7XnwFh3WlxB0PXXAP5uKJShfEZm8yPFejI10RqlK8slP2OS2o9hPyLJLYkICZV
	 9VY2CHfgi0RlYssM6u8YygP5KiSgvmZcO4qdLXexeZuK8cTsZWXy8xiYycTObTjmAS
	 RyC9soMnYXU3ZThlW2lkOa19a5I5VdbxFmHxiUcZIKgMAuvA4Q6AFVaz4IaGBJhls9
	 mff6YriNJKBXPuJSg/Hjox9mkLIXwIzedb+7ZvsH8P2fUsx2T/NipGocijWE2MFEJ6
	 VGMKaezStCae0R6Msuxs0kwDI3Iq/hiJZmsiSy+Ccv38r1aGzfu97WeB05PfEtCOIA
	 o4AgkJHbK/BlQ==
Date: Fri, 4 Jul 2025 15:39:05 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Pratyush Yadav <pratyush@kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 212/218] spi: spi-mem: Extend spi-mem operations
 with a per-operation maximum frequency
Message-ID: <0e8c4016-3584-4db6-badb-0d6d0dc66dbe@sirena.org.uk>
References: <20250703143955.956569535@linuxfoundation.org>
 <20250703144004.692234510@linuxfoundation.org>
 <mafs04ivs186o.fsf@kernel.org>
 <2025070449-scruffy-difficult-5852@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="7rG++0dv66/nZI2d"
Content-Disposition: inline
In-Reply-To: <2025070449-scruffy-difficult-5852@gregkh>
X-Cookie: VMS must die!


--7rG++0dv66/nZI2d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 04, 2025 at 02:17:18PM +0200, Greg Kroah-Hartman wrote:
> On Fri, Jul 04, 2025 at 01:55:59PM +0200, Pratyush Yadav wrote:
> > On Thu, Jul 03 2025, Greg Kroah-Hartman wrote:

> > > 6.12-stable review patch.  If anyone has any objections, please let me know.

> > This and patches 213, 214, and 215 seem to be new features. So why are
> > they being added to a stable release?

> It was to get commit 40369bfe717e ("spi: fsl-qspi: use devm function
> instead of driver remove") to apply cleanly.  I'll try removing these to
> see if that commit can still apply somehow...

It feels like if this is important for stable it's much safer to do a
specific backport rather than pull in new feature enablement?

--7rG++0dv66/nZI2d
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmhn54kACgkQJNaLcl1U
h9AKUwf/bzBESTlUxhGWnoWqWERaLQB+Sik9MJMxKayeO+RtMS2NE18ConVN3/HF
RMtA+2zxRBbqWS3sKbDthfCZd0PbgK9+muCzL6f2BYqPhTpNex4vJJQpN1xf5ZbJ
xoR+SY3D3LO1DPe5/92RbEyRkh2FAt6n32TvaPAWS7QYY2E6aH/8wI9Ke5D6lWxO
PDulxN7OlNG2UJ2VcjFaKRz1ibR5TLUAGvQ+GNxFiR/pSf8s28RaFc1K4vWeETsH
5fINr+b+QomXoZVEIkE7eAOP9Db4hyzIGuaLrkGl7Bhx6qSCcj/fIYDb3dc/qPmU
uQY6OHuf/wPFEs6rTeOdDxqSv60Arw==
=5ZTh
-----END PGP SIGNATURE-----

--7rG++0dv66/nZI2d--
