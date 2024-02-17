Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675B87C0B0;
	Sat, 17 Feb 2024 15:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708184293; cv=none; b=L/qYWofahpNA9QXmHgV/7eWWC+9K3jJ0xms0jdpSwnmjw7P0X+qg1GW4ws4+cHGBkzlkAcJeuMwKJO9d2DwBFui4nPOcv1cQkfMD+4H/AGeJIrLt+zPAcuVmEBLL8L54ZTxPYY6Xwuu7/N+Qbe9wrMvH9c4J5uqQyyVjS5ylKYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708184293; c=relaxed/simple;
	bh=kjuTWgsUB+jDmBnO5TlgZsfyV7jcweZ7L3sfJJQE9LM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AEkztK2K6Yi3AzqifjwjcxHAx/xfvJVHPEj3PwF0YjkMh7V07LdkSy1BIdkf0rnj5IjAKKuE5RxcdTRM1obbekL3a5h+GJN+t4Z8IhTeQvgjoncfjJ4WRpUEnxKi6A2/tDtZTYUtDIFPeMXVZ2bMSQ782mylrCvNLxpOE+7veRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gm/mp4pO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gm/mp4pO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79B68C433F1;
	Sat, 17 Feb 2024 15:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708184292;
	bh=kjuTWgsUB+jDmBnO5TlgZsfyV7jcweZ7L3sfJJQE9LM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gm/mp4pOcXR5OizoA29lalqSU0Eg4EA5ys92ezPqT9Gb6tSRRO0KpaZej0V6I5Z0r
	 O5E1kuMAWnmo5l7axO0N7Xg2uLB0zYMDlRz46UEgK23v7YIu5r9GRyc4tsmwJI6fcY
	 XYyuj0ABdGhjhpxAjpued3XdK/5oqCjs6yjWgd7KHEzAlHro/1BA7aZCWaacm+xEf0
	 mGuVSlTjlTQ0MkoB0Ku/7nF8W01eTmNGgxdkMbWR88Pl1sfZQEIaRF2rzyR3yHdGiz
	 fX65nH0aM8EkxZ8i/Qk89JW7UgbGBD46HhN0Jz735UPMzzycqzSBtuoeBPXBeOOgc4
	 6P3LCbqvWm25Q==
Date: Sat, 17 Feb 2024 15:38:09 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>, stable@vger.kernel.org,
	patches@lists.linux.dev, Frank Wang <frank.wang@rock-chips.com>,
	Badhri Jagan Sridharan <badhri@google.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 6.7 093/124] Revert "usb: typec: tcpm: fix cc role at
 port reset"
Message-ID: <ZdDS4drripFkFqJp@finisterre.sirena.org.uk>
References: <20240213171853.722912593@linuxfoundation.org>
 <20240213171856.446249309@linuxfoundation.org>
 <571afc70-dd77-4678-bdd0-673e15cdd5ad@leemhuis.info>
 <2024021630-unfold-landmine-5999@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="bMoKNK6S/Hd/5cfl"
Content-Disposition: inline
In-Reply-To: <2024021630-unfold-landmine-5999@gregkh>
X-Cookie: You might have mail.


--bMoKNK6S/Hd/5cfl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 16, 2024 at 07:46:13PM +0100, Greg Kroah-Hartman wrote:
> On Fri, Feb 16, 2024 at 07:54:42AM +0100, Thorsten Leemhuis wrote:

> > TWIMC, that patch (which is also queued for the next 6.6.y-rc) afaics is
> > causing boot issues on rk3399-roc-pc for Mark [now CCed] with mainline.
> > For details see:

> > https://lore.kernel.org/lkml/ZcVPHtPt2Dppe_9q@finisterre.sirena.org.uk/https://lore.kernel.org/all/20240212-usb-fix-renegade-v1-1-22c43c88d635@kernel.org/

> Yeah, this is tough, this is a revert to fix a previous regression, so I
> think we need to stay here, at the "we fixed a regression, but the
> original problem is back" stage until people can figure it out and
> provide a working change for everyone.

Given that nobody from the USB side seems to have shown much interest in
fixing this since I reported the regression should we not just be
reverting whatever it was that triggered the need for the original
revert (it's really not clear from the changelog...)?  I got no response
other than an "I said that would happen" to my initial report, then the
revert triggered a half done patch which I can't really judge given my
lack of familiarity with the code here but that's not been submitted as
an actual patch.

The board has been working for years (at least three prior to the
initial revert of "usb: typec: tcpm: fix cc role at port reset" which
was only applied last June), presumably whatever the original revert was
intended to fix has been there for a while?

This getting backported to older stables is breaking at least this board
in those stables, and I would tend to rate a "remove all power from the
system" bug at the very high end of the severity scale while the
reverted patch was there for six months and several kernel releases.

--bMoKNK6S/Hd/5cfl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmXQ0uAACgkQJNaLcl1U
h9AHQQf+JNK7CNRe2r4vzoKpsDxOwXAm4mYEqhxn7/SeTopx2o+ZSskNu+3TgUXQ
EyvvZhtxZuL2NzaLgW/GsEv/7jtm0n5JPztqCQg2IZuN4OYp5HXRiT9rMC97tJ/N
/BmWc8zOpOTvh+MzC2FEQdrR8YLTgEA8z/7tFBpMrr69VmCnASfVH9lLsBJKDh2+
CENLlU8DZ1ShKoj5eXadcY6lxJCJGs/6e9G0/BEtl6DxVp9QJwLXmInkwRvoppAw
+CZWek1fi+dyXomPEoBnpMU27aQ4yM7tmqIesgPbAhy2GSFgR4u2i1dHy18CQ7fK
Cqjq1ttEh+FiyYgcmhZrRGTcZ42GBw==
=fTqS
-----END PGP SIGNATURE-----

--bMoKNK6S/Hd/5cfl--
