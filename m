Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B6433E342
	for <patches@lists.linux.dev>; Fri, 31 Oct 2025 11:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761908799; cv=none; b=gdeEkeRArQiUSegp7u9OK3gOm5j0HdDx0qrduCLzwoFGu6KAD6xpQeD/Wzx4D8Za/gBWFmmIvuGEHija02qZax5hRWQ/TL4ohI1iJsaZr9OuO+kFSyvKSSjNRB9IHU2z3BpE+IvMpgirZra+bMD0ltFvUxeVPCM7hWwfKUlx5lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761908799; c=relaxed/simple;
	bh=HTSI/dPQSKHzbxRngZhO4z+EGxJggMRfaxfudEJVGak=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ejOV7Y7KhagmdL5u687cCwd1za4tPd8ENpBiQcXcTf8Nc+869Fug1EKQ+Su0h4XFBgdxy6hKZ59230XXPoK0awVjIDoDH92oZZA4s9mWg8Gu0HQr5/y6e0wbfiowRskIbEgd/1RmO+HW1EgfWEKPmAVy1TEeh3Om/w8PgdhsbiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=CexFIWGB; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="CexFIWGB"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id D66CB101C5774;
	Fri, 31 Oct 2025 12:06:33 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1761908795; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=e1Meplh8hulJg7phg7wGQvk5FzIea8bBjXiGqMQiYDs=;
	b=CexFIWGBbQ5TGUYhp2nNwt5KSANC+mVbwMh+aVhVa38Prtgfmyf0CAphaPOQzNCVQ0Otx4
	2fes+PeEzasu7QDgOGrhGlSZJxz7xuANrH53VgKLlpjLVjUQvKjtYFMKdmNCp9N75QbHF9
	qU5KsB/aLGOgqXziV48yYRn6ulfei3TU+A6K7Mx8DOJPcJBwX9ETmV5uejNBT5XfvwOiET
	f0kxZslHlxHqUonHcqh/ofRaQdSXzmtS2I4VwCngmbMYd3uQl4nUoV2Bx70k0jhilmsOOX
	gReCSEq+fy376xe8hGVgxPpV2ui/9XCUOOpYAOWGf3BbwtYoIMveR5o2e5OPJg==
Date: Fri, 31 Oct 2025 12:06:32 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/117] 6.12.56-rc1 review
Message-ID: <aQSYOAQwNN/eo/TE@duo.ucw.cz>
References: <20251027183453.919157109@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VpDrFU+m0k1Aii7k"
Content-Disposition: inline
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--VpDrFU+m0k1Aii7k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.12.56 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.12.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel

--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--VpDrFU+m0k1Aii7k
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaQSYOAAKCRAw5/Bqldv6
8jCtAJ40b/+TG85WPrhtqf+fgKwoFBJt6ACgoSs4IlJNYJpbaNXcIovbCyArAnU=
=Z8Zh
-----END PGP SIGNATURE-----

--VpDrFU+m0k1Aii7k--
