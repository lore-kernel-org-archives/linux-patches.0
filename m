Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3305618EAB
	for <patches@lists.linux.dev>; Tue, 13 May 2025 06:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747118748; cv=none; b=NEuqIgypMBVe/Jqd50FFoUpcOP0feWXfVT2V/NK8ELUuTOrfl5o47TH7hss6jZtZgraNg/6Y9KgdBBuVjZWWNupvi/0lE7EeZLHdyeLGMbBh5Q3MMd6NtQcoBvBgyYNv5SiezAi8/8e6JH9Oce5jEvwQfCy/OXSLFT15EYh2nf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747118748; c=relaxed/simple;
	bh=fj2ri2Wp/bpF018s3Z5QWNmJKfl+cJBrIQMhNjHTIxE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I/ygP4YHL+alwYmicgnSkPs4ED/EIZO5+KkFIXbUbfdsRZ6oO8o5KJFTecFRNdT88H5jsEVCzp7GUG9Qx/OfGooaXOvCcVEip7mm+rshi0GnSI5X7dJ+SFD4o35M19vsrghDEvAZ5+HHF+TTeQqjOvD3zP69x3o0J7f9Xlv+eh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=E0KHtZbV; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="E0KHtZbV"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 9794A101F54F9;
	Tue, 13 May 2025 08:45:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1747118743; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=Qn06Auz3g3uXaj4CpFAyQVtsbCU17ojJiIvRQnIdr2E=;
	b=E0KHtZbVqjvstXfX48X+jmcyH/BFx/UtsRsUVlYmqfx2VZ5MOWI2qjXET2vFV9a8L/EmC8
	USh4JJx/Ik+qXY6xcsB3W2IFzo2KXKS7EDHFQu4yR7YG0SI3yvCB0ZmmTbVWlruXs+CXcl
	/FP8Pc1TwvZJa+fEQiGojMoiDH2Kef2JIPqAQiaR3/8KbeuAXPZ19P6Z3qICQHMLLR9jtX
	JRMRksIooA1nFH2PaiarFa1jVH76EeQFfUG2OlNzf1RZgKUz0cfioHzKpehcEcy3GZW8Vh
	4hotqsD8V9JwcToSaUn3cSnLR/9j+HSTQYflvG79iFkzvtjg1w7ZFFtEaoH0Vg==
Date: Tue, 13 May 2025 08:45:35 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 00/92] 6.1.139-rc1 review
Message-ID: <aCLqj2SHnne6U1sG@duo.ucw.cz>
References: <20250512172023.126467649@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m4fjbYD3mk7Y4lHf"
Content-Disposition: inline
In-Reply-To: <20250512172023.126467649@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--m4fjbYD3mk7Y4lHf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.139 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

We see same failure as the other kernels here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/1=
813565657
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/100111=
61709

arch/x86/kernel/alternative.c: In function 'its_fini_mod':
1163
arch/x86/kernel/alternative.c:447:32: error: invalid use of undefined type =
'struct module'
1164
  447 |         for (int i =3D 0; i < mod->its_num_pages; i++) {
1165
      |                                ^~
1166
arch/x86/kernel/alternative.c:448:33: error: invalid use of undefined type =
'struct module'
1167
  448 |                 void *page =3D mod->its_page_array[i];
1168
      |                                 ^~
1169
arch/x86/kernel/alternative.c: In function 'its_free_mod':
1170
arch/x86/kernel/alternative.c:459:32: error: invalid use of undefined type =
'struct module'
1171
  459 |         for (int i =3D 0; i < mod->its_num_pages; i++) {
1172
      |                                ^~
1173

Reported-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--m4fjbYD3mk7Y4lHf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaCLqjwAKCRAw5/Bqldv6
8lWlAJ9ZtbtZM+Yg+1e2lZxFQ566hyU5WQCghwSwtJj9siRvUnrYIhhLZXr+3ZE=
=kBwF
-----END PGP SIGNATURE-----

--m4fjbYD3mk7Y4lHf--
