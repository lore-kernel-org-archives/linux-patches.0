Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7138B17B402
	for <patches@lists.linux.dev>; Mon, 13 Jan 2025 11:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736766034; cv=none; b=N3nZWFs9uFsTWOKONtRqOnMXEBjrqUW4h8sLsb5DlKjNrmuWkw7NBoqIxeauUnqF2sbnckytEKZzcV3QS1DK9Knc0Z7Lq3NnHPeBdCbpFJn5AhLWcnzABGabbVWap2wohUbr8B9lYNYmVWAJg+lwowFaRQQyLSXQqNjJRfnq6cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736766034; c=relaxed/simple;
	bh=lDpTSjEKHOr2t8pQTUXemjjpjHl+ygLfVO112iM/d94=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UG+xR+DAGAfPEy350AAJKel4vtF2ldT4IHCkqPp86tLjuSJULFuEzS3odrn+Etwz3a+B63uZMumh4ggrSPfPsjWL0eCEq1cmbNm00Osv1FdLWLNKSzKEOurctt/vHDyM7dPbI8VnTXFZOQavlaL4GSRlXmN4qfs6k59WNrEtDGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=dU7vXKsE; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="dU7vXKsE"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 9EA1F10408F8C;
	Mon, 13 Jan 2025 12:00:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1736766029;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M5zP9xgydjYxTQItQWutguQvuyNIJDGqZwq4Hw/MCIc=;
	b=dU7vXKsEw42ZnWlm+nyE4MVUnfw9cjRnPGwN4l8JIk8vVYz2NjyJBd4KQstfVbaMUTGbMm
	QipEprnJjXvJihHjf+Kzjkp4zgTAp7D5vrzxPARokF2sA6b6ZACzQ5uhPqf3rRrITseGq3
	l6a4HhnBP4zFXEVmh61jA5R9yUvYYU1q98iHRbkiIRJ62QQaPYwIft5WIz3RR3AMh7fWPw
	3HeK7Nz82sZxaOw3U3mZScryF2vZz6tHg1lE5CPEftslCBN+TWTQvDbuc1VTB4VbB4M6l3
	eQ7/qidDJWvRuUX4PSscrhycP7EsmmPR1k/T/h5dUXdDF/V8Bb35xZDQ76JtIA==
Date: Mon, 13 Jan 2025 12:00:22 +0100
From: Pavel Machek <pavel@denx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Guenter Roeck <linux@roeck-us.net>, Jiri Slaby <jirislaby@kernel.org>,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org,
	Juergen Gross <jgross@suse.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [PATCH 6.12 000/172] 6.12.6-rc1 review
Message-ID: <Z4TyRusmhjbBwJe8@duo.ucw.cz>
References: <20241217170546.209657098@linuxfoundation.org>
 <CA+G9fYu0_o6PXGo6ROFmGC1L=sAH9R+_ofw0Hhg8fZxrPRBKLg@mail.gmail.com>
 <746e105c-c6b2-48c7-ae89-4deeb97e1866@kernel.org>
 <869c01f2-e069-440b-a81b-fe71e969b72e@roeck-us.net>
 <20241218165444.GL2354@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="47lo57E2zMuzH9j1"
Content-Disposition: inline
In-Reply-To: <20241218165444.GL2354@noisy.programming.kicks-ass.net>
X-Last-TLS-Session-Version: TLSv1.3


--47lo57E2zMuzH9j1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2024-12-18 17:54:44, Peter Zijlstra wrote:
> On Wed, Dec 18, 2024 at 08:53:39AM -0800, Guenter Roeck wrote:
>=20
> > The fix is not yet in mainline, meaning the offending patch now results
> > in the same build failure there.
>=20
> It's a test, to see if anybody except the build robots actually gives a
> damn about i386 :-)

You should run, hide, and not come back. Breaking i386 is not okay.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--47lo57E2zMuzH9j1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ4TyRgAKCRAw5/Bqldv6
8qOqAKCoDVAbRgAonDgtEa/N4QdRdFhumACfbdwzspvfer/jVbh7/+7gBRV1az8=
=HuQA
-----END PGP SIGNATURE-----

--47lo57E2zMuzH9j1--
