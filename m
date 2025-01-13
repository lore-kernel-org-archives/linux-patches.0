Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9516222CF1F;
	Mon, 13 Jan 2025 13:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736775425; cv=none; b=M3zLWUjBEwWh/KgYaiHoeY/gysrnYNHc4hYdhQ22tDtKWtdgGGNCvA3STFBTEPo1YHFlWxI3tpUgzvsgDuA2q7gsbZQqtBAcuNWoysc3wnTxfDHqvIH0az1BAXWTMj/hhZeziKc3QukVLphjNYsxt5Va7ibqMGepqaFRT/8RtjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736775425; c=relaxed/simple;
	bh=bUBozldLrA+tN5+cri5z0CuwhtvWendkH1kzInKSEq4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b4zDw5TR/eWCwG7CwIQsBm8G1jJ5WwYb/NUfqRihXvi1as6RIRRcpnQtiDyH76lSKOZJHPO7CRsmX/cyypKWYZHqtqKWHX7NeBniNAXEDwMArXTfLnl+EAFz4/Xi/n9+S2warrqiCQWA0mCCU65uFH+2Ao+xdCJfKX0wrgD9tqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k+UE78Dr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k+UE78Dr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E53C4CED6;
	Mon, 13 Jan 2025 13:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736775425;
	bh=bUBozldLrA+tN5+cri5z0CuwhtvWendkH1kzInKSEq4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k+UE78DrNjpBo9PvgdtwxUuPgmwqmI1oaJLBQMQeyWgcEa9VnVIzvVJ4qAJpwMZe3
	 tP8LBb+/nFr9AJ2tw7Z99e3AHPi3kZr9fI5ipMuTo7+uqKJOmcJ6HE4eOgczoM1asd
	 uLEzBNAjYPiEPManL1Y8G/fix+LYheEH4B39haADD0QWC3kKycFG99wy4kL0Z3emEB
	 jgvbHuWtDtQjnneI9H4iv+8/v6HWLpalmhAFPJi7AaaTl6A2JhNWutDGGW2YNSN5mt
	 toKzPRghb6esG/tFWusU89RMFxes86NRN16E7NbHMh2uipmCJ0qwI+WD6/P9A9yxEu
	 +m8DlXlAyKi8Q==
Date: Mon, 13 Jan 2025 13:36:59 +0000
From: Mark Brown <broonie@kernel.org>
To: Neal Gompa <neal@gompa.dev>
Cc: Miguel Ojeda <ojeda@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	workflows@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	Sami Tolvanen <samitolvanen@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	tech-board@groups.linuxfoundation.org,
	Steven Rostedt <rostedt@goodmis.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH 3/3] docs: submitting-patches: clarify that signers may
 use their discretion on tags
Message-ID: <523e2f74-ff67-42b1-8cc6-2956c856c833@sirena.org.uk>
References: <20250112152946.761150-1-ojeda@kernel.org>
 <20250112152946.761150-4-ojeda@kernel.org>
 <CAEg-Je-Knta8BtYSbZgX8cZ9Gd-2cpDAUE83dCJZbTbqmSfcKA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="OJsS87fX618Yyo0C"
Content-Disposition: inline
In-Reply-To: <CAEg-Je-Knta8BtYSbZgX8cZ9Gd-2cpDAUE83dCJZbTbqmSfcKA@mail.gmail.com>
X-Cookie: You will outgrow your usefulness.


--OJsS87fX618Yyo0C
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 12, 2025 at 10:47:02AM -0500, Neal Gompa wrote:
> On Sun, Jan 12, 2025 at 10:30=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> =
wrote:

> > +Finally, while providing tags is welcome and typically very appreciate=
d, please
> > +note that signers (i.e. submitters and maintainers) may use their disc=
retion in
> > +applying offered tags.
> > +

> A tag must not be dropped without the tag submitter's authorization.
> Otherwise it doesn't matter what you write here, the submitter *will*
> feel unwelcome.

> It is rude and discouraging to do so without their acceptance of doing so.

As well as the issues that Miguel and Greg mentioned there's cases where
we specifically want to drop tags, the most obvious one being that if a
patch or possibly even it's context changes substantially between
versions that will invalidate the testing or review that was done on
prior versions.  Perhaps we might want something like "please note that
while the default is to apply tags signers..." but I don't think we'd
want anything stronger.

--OJsS87fX618Yyo0C
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmeFFvoACgkQJNaLcl1U
h9AMawf/RDVc9QITXwisNyheXl8wCZ+1FAqXf0USgJDR7Ptsogz9dHSl2M+2AOLe
yJVnHXWVirQfunQ/ipUFyqZbzEH1f5HEv1e+r+1k7MQkbGcK1UTFKvLWGLySiHrk
DVUDPRUejJnTn62xGuKB2QYbY4M34CyIsi3qR/dDM8XVc7J6aGlsUabbLdyYRiM2
D/HPQc8k2kvW/QITElrHR6CLyE1ujKmpEbWfCmyhVj42UCN8GyQv3mv21SToo3qH
sz5/Gz2MjnA/+SwSXZvjLIvHI699/TEsgntSHrH2Mc1ZyTCyNxuODNDZ9b7pS4ys
b2GRgd5YQ0jSaj8TsHX2NUzTQc01QA==
=nNXE
-----END PGP SIGNATURE-----

--OJsS87fX618Yyo0C--
