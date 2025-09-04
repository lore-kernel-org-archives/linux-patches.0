Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9562D0C9A
	for <patches@lists.linux.dev>; Thu,  4 Sep 2025 12:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=140.211.166.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756987975; cv=none; b=hA/Jr4FEmhVeJAF+QweZ1s7awms1S16yvTUTb/6+R5IGUapUj7SzinLGmLXhWGBF2Q8vr8Io7kiV1qQnhu9yJgxPUx9AyEH+EgVN+Cr5Kg1+kE/LOHbG4irBRbDZ5cq2vve1n3EBUn7L48L4186C53mcJFCxc2GIN16BxN0MzmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756987975; c=relaxed/simple;
	bh=VGVuTDGKL0dvjAjtHdO+lcItteusAJJoQivC8xJu/8c=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=p9x0nUH+0bgbGvpaPqcYgbu4t36KdnxIxYz8rmUXu/fpYAXEnnf9y7KbKjzTYXNF3CGAHu0+YY/xj0tUDuJsHJjGipYtaM2QlXXjKdPn97NA/mP56sUtBWDdOA8ZFd3/NTAY10ILjLQxJSLIBVKrBlv4arwwUi6NEL0LxCoF/As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org; spf=pass smtp.mailfrom=gentoo.org; arc=none smtp.client-ip=140.211.166.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentoo.org
Received: from [192.168.0.1] (c144-154.icpnet.pl [85.221.144.154])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange secp256r1 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: mgorny)
	by smtp.gentoo.org (Postfix) with ESMTPSA id AE94D340D2E;
	Thu, 04 Sep 2025 12:12:51 +0000 (UTC)
Message-ID: <0d4ea5d5ca21fb3627db21ef5cfc9a0100b1e52b.camel@gentoo.org>
Subject: Re: [PATCH 5.10 33/34] ASoC: Intel: sof_da7219_mx98360a: fail to
 initialize soundcard
From: =?UTF-8?Q?Micha=C5=82_G=C3=B3rny?= <mgorny@gentoo.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, Brent Lu
 <brent.lu@intel.com>,  Pierre-Louis Bossart
 <pierre-louis.bossart@linux.intel.com>, Mark Brown <broonie@kernel.org>
Date: Thu, 04 Sep 2025 14:12:48 +0200
In-Reply-To: <2025090457-unkind-caviar-4e53@gregkh>
References: <20250902131926.607219059@linuxfoundation.org>
	 <20250902131927.927344847@linuxfoundation.org>
	 <97d648ff7cea3aecd6c2606ea60edf928e1cf1aa.camel@gentoo.org>
	 <2025090457-unkind-caviar-4e53@gregkh>
Organization: Gentoo
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Z6mkbOqoX9WlR+K6Lby1"
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0


--=-Z6mkbOqoX9WlR+K6Lby1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2025-09-04 at 14:05 +0200, Greg Kroah-Hartman wrote:
> On Tue, Sep 02, 2025 at 03:52:55PM +0200, Micha=C5=82 G=C3=B3rny wrote:
> > On Tue, 2025-09-02 at 15:21 +0200, Greg Kroah-Hartman wrote:
> > > 5.10-stable review patch.  If anyone has any objections, please let m=
e know.
> > >=20
> >=20
> > I think the prerequisite patch is missing (4/5 in my set):
> >=20
> > https://lore.kernel.org/stable/20250901141117.96236-4-mgorny@gentoo.org=
/T/#u
>=20
> Ugh, I missed that somehow, thanks!  now queued up.
>=20

Thanks!

--=20
Best regards,
Micha=C5=82 G=C3=B3rny

--=-Z6mkbOqoX9WlR+K6Lby1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQFGBAABCgAwFiEEx2qEUJQJjSjMiybFY5ra4jKeJA4FAmi5gkASHG1nb3JueUBn
ZW50b28ub3JnAAoJEGOa2uIyniQOF6UH/ilf6sj6WRuDnqqZCAkFX3nmBWWJl9Yc
WLW+h2eBU4zloeQBB+gFtqQix74JAVp9FdRB15L7CaDTZVNZ8q1SZ6Blu58yiNyo
0/vr8SzMiXS+4ag3mg7iToHj4Zz3qLFrqTXuPTmm4KIBA+49NLhO3X967Kdy3JJM
drtm+ixv8SLaAIevVb/u0hy4emSwb+9DHfliitBDoYoq7M9ZQPk2LvFwYL4fKXDE
9OTDSd+7stNWzFEIR0PvElOrc4jkXliODdohpm8wqG1XxSApzkdMo8IijfF+iF2l
h7yh8e/UXptkcpE4UZYxBM5GPhJ5ktpULXVCYRoSD4JjtdtLKez6zVM=
=RYKi
-----END PGP SIGNATURE-----

--=-Z6mkbOqoX9WlR+K6Lby1--
