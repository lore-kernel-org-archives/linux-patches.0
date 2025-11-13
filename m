Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB2E29E101
	for <patches@lists.linux.dev>; Thu, 13 Nov 2025 09:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763025581; cv=none; b=ENIbh0Dhwkk00iUV0aeXVn7m3ZnQI55zRb8124s7I0qk6SAK8fsM7eoABTCK6C2vzGuzQ0ffyTZslWuqQsic2syVWKJChh+oYgBFxWSs+pawt3j1911f3WFGEf1CWiEBvMd/dtmGNZuwGh3R+7gHWrx+cqrtRYZKiY1M/2x+taY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763025581; c=relaxed/simple;
	bh=nMaG1pEyRvF9EIMCWuHxosrBKtOHZxRthUpKE3t5hfE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MJ5RP8IsbvptmgTlVvzdykf8ls7pGTY554TTF1I/jiizSY7ZHnm2YKzhMkpB0AKPcz50FR5R2wVbVF4qpMEh80zDEEUMdbTFr0GGW5leKHtCOuSh/GmqYyqpjq3jl6Pqevk3IgIiAqXStRbx2QPwjp75NSe7RFNJKSaKDprxpaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=dbkGPI0T; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="dbkGPI0T"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 153EF103D144D;
	Thu, 13 Nov 2025 10:19:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1763025576; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=kDRnlDeaQdySH+77s07SAO6Z4Qy3pdNCscizCosQTBo=;
	b=dbkGPI0TX75vKhb9HjQqScKFrz7zBZXkC2hAs1ij+RVd93lZB6cAyu6eYS6RhvDqzpxrfP
	sOYrtomNWH6T6enVwZTHDPlws6eqXAB+qGTTGwQ7t/n9XYzngjyj9RwJKR57SmYtjj17uV
	tnO4g/kirQAT44D+AH3cUqAHMRb8Ls1LhIIp5voDNd2JuGEOF2ga6U9hjesTvy+HRs1Hjb
	axwC/oVorJTvKpzkWVxs3kUnPZXxMjvuiyKgkjgVmn7Fnco9WFhq0Upf8KyWqD7Gb5FKg1
	QVntmbgPp24WMaERRPCq3P3ejdskLDqvn92V5WxNyNOWz7uIUjpA/SlEXOQHHA==
Date: Thu, 13 Nov 2025 10:19:31 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	austinchang@synology.com, fdmanana@suse.com, dsterba@suse.com
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: [btrfs] Re: [PATCH 6.12 000/562] 6.12.58-rc2 review
Message-ID: <aRWio5wmbVX21IFu@duo.ucw.cz>
References: <20251111012348.571643096@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="50rAiEiqMSwfQg9E"
Content-Disposition: inline
In-Reply-To: <20251111012348.571643096@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--50rAiEiqMSwfQg9E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.12.58 release.
> There are 562 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

> austinchang <austinchang@synology.com>
>     btrfs: mark dirty extent range for out of bound prealloc extents

And someone should check this one too. It references these commits:

    This is reproducible since commit 41a2ee75aab0 ("btrfs: introduce
    per-inode file extent tree"), then became hidden since commit 3d7db6e8b=
d22
    ("btrfs: don't allocate file extent tree for non regular files") and th=
en
    visible again after commit 8679d2687c35 ("btrfs: initialize
    inode::file_extent_tree after i_mode has been set"), which fixes the
    previous commit.

But only first two are in 6.12.x, afaict.

Best regards,
									Pavel
--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--50rAiEiqMSwfQg9E
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaRWiowAKCRAw5/Bqldv6
8lviAJ9qMXnnO6vCa0fg9H8+e0kbWuEQwwCfbmOEW2UgK3Yzle9BFubXV57qwh4=
=WxIs
-----END PGP SIGNATURE-----

--50rAiEiqMSwfQg9E--
