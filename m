Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9AD2BE630
	for <patches@lists.linux.dev>; Thu,  4 Sep 2025 08:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756973340; cv=none; b=ehK+0cohQvcRuosOJ86OcKKIul4EG9tRTxqj8LGhkbWQK2trMO2nBKR9kiLax7v5YMHoO+sXM/+Hq0ExJJSuyb8kMrH4qATwkWoAImgQa406uEZ30Tot4rORQ2Djn6XNvNosQXogshBvSBqJUKsW1XivV24vk+2Y+BtjMZD4QLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756973340; c=relaxed/simple;
	bh=sQRZUjw/NuitnjZWeXvE6DX3fE7M+HJx/GrD6grhYyE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mm6O+y3LKuaxlV1s7Q4CX+rCWyHjSPo6MS6gmDZa7wqORAu7/zav7MXqbPyMwfuukTGIWyIRH/mN+e06DYybwUrp+zWlAswJXbNQsFtQ9WHK1YkT8xu6/ahj/7NyAuF5iu9cK9PRljD3Ea197BQ0w9P7vRaozIPCZriqz/OT9mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=FrLPMhUV; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="FrLPMhUV"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 1014C1038C103;
	Thu,  4 Sep 2025 10:08:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1756973330; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=XxYVzgu681T/LCDB4jGVbJTLbaYqK3/BHA7KYwFFKUQ=;
	b=FrLPMhUV9tkmO2CwWeGevu8h9/1ZLpF9mQqUCbpNsRwGBcq5SUN5ArLZKfuTRp/8tKwdUN
	bCdHhPrRX7gHIwfj7Q+kxXkrgYZyn5KPAnm9cF3pE3jjLJDa03Xpr8jZaOEc1L3w9NXFXV
	LqdpFA5e6IOwmQj52AHHbsTOaKMnUspKYjW9Z3+vSioU3QyhUioMcYITRlKfqHeP5VyOSB
	S0Cul0CeEqgZPfnyzqoJjnrVZGoO5O1t9BZm6+x11whb37cv0LB6NMlM88BrRZwvx7yvSz
	DNUYYm2rsDrIfexgfXMnV5w0J2xoCJkm+LsAliNkh+/sf3iec53+2KuOKPlGDw==
Date: Thu, 4 Sep 2025 10:08:40 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, dlemoal@kernel.org,
	WeitaoWang-oc@zhaoxin.com
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org
Subject: Re: [PATCH 6.12 000/322] 6.12.44-rc1 review
Message-ID: <aLlJCKO5vIlZ6ZJp@duo.ucw.cz>
References: <20250826110915.169062587@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Wgc8ZY9FwFCe7DKA"
Content-Disposition: inline
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--Wgc8ZY9FwFCe7DKA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.12.44 release.
> There are 322 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

> Weitao Wang <WeitaoWang-oc@zhaoxin.com>
>     usb: xhci: Fix slot_id resource race conflict

This was merged for 6.12 and 5.10, but not 6.1. I believe that's an
mistake.

> Damien Le Moal <dlemoal@kernel.org>
>     ata: Fix SATA_MOBILE_LPM_POLICY description in Kconfig

Not sure this is suitable for stable, for example it removes warning
about possible data corruption:

-         Note "Minimum power" is known to cause issues, including disk
-         corruption, with some disks and should not be used.

Best regards,
								Pavel
--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--Wgc8ZY9FwFCe7DKA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaLlJCAAKCRAw5/Bqldv6
8k7LAKCXDsf9oFpGdmM77qKCKp0BJQqoMwCeKu4Gem3uw7stIQGSe3+ulvHUsmk=
=XHbR
-----END PGP SIGNATURE-----

--Wgc8ZY9FwFCe7DKA--
