Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689522F0C7E
	for <patches@lists.linux.dev>; Thu, 20 Aug 2026 18:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787250643; cv=none; b=RzGKfJHxl0JzwmDyHnZ0vzBgkumixPkQmOjpx4evLJJmM1wyIhbdi/MCMUZhUEU91MxfrMpo7dzyMFDuD+S76qLI8aVjXLkmFx0KhAHxr3IqX7pOmokJ8bBVrTjXrFeGHe//wtiNyYplUxCr2ysAt2pzYj4okd8FzbZNz/02BVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787250643; c=relaxed/simple;
	bh=7sL6C3xJN/u+rqrbOFGDKnXU94vzMiYY4or1tUPFHg8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SBq+grKewOYFFLkZO351vKQkoV0o8dN9GtiQyviVi3IiCzDIrKc4Wi2deX4fKXCSFV5kbstNSMkg82DwtqeQAOVOulFYyWPGMHudFo4ihPOQ6AUwjnoYYPaXzMgARkz2hOnvY0fk/+ws9+2YkPkCu6xEtXIx1X9sxMaRU+3PUas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=aldBq1PV; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="aldBq1PV"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id C086D11C5EB;
	Thu, 20 Aug 2026 20:30:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1787250636;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=Rh5MeZByNIrjFeLWGJ3XI5+2H4upIKqUhHPVHuDsR+U=;
	b=aldBq1PVp99+gj1OMr66K5WFZ0YBfwIbalhjzWgWmJ7XLgEJ0mDf9FiqRafOLpiXNPvam8
	8yzkIVNet0XfEIryA56EdKumFYmbvxPEOwQ4h1sCqghBj3ahAaUoug73HiiR1wwS+A+GsQ
	+GvKHrwdnHgOUZ62haCmgTlwr9IPevBXz71nImXgbQrwXyWMY/98o5mCbZOeQglecS19y5
	/24MdlQT/X3LjxzEv3+j0nfEIIdKx9hXEOXIfblPcWMSp2JM/ce08HPLBVDKqlBFGXgUgn
	QSOpcaGTFQgqKRjuS+GdWllFyc2PjfLd5corQ6iJyhXN0q1GmGif2QggIV8CXA==
Date: Thu, 20 Aug 2026 20:30:33 +0200
From: Pavel Machek <pavel@nabladev.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.6 000/166] 6.6.153-rc1 review
Message-ID: <aodHyZFV-AzZTbnF@duo.ucw.cz>
References: <20260820145211.194104353@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mQD/3OC19p/I9hid"
Content-Disposition: inline
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--mQD/3OC19p/I9hid
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.6.153 release.
> There are 166 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/2776656726

I assume this is same problem as 5.15.

Best regards,
								Pavel

--mQD/3OC19p/I9hid
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaodHyQAKCRAw5/Bqldv6
8qyQAKCNLK0RDfZ/+gSXHF3ts1ZlZ6OBfwCfbGPhNrSG/2mz6p6yB6fokFkKK7o=
=2zo5
-----END PGP SIGNATURE-----

--mQD/3OC19p/I9hid--
