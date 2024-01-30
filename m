Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074DC38DEF
	for <patches@lists.linux.dev>; Tue, 30 Jan 2024 06:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706597131; cv=none; b=QyhjHfzExsfWKeE+fQDIJ/ESaHSK+oGYfaIt/F820Raml+AyqzURKe3pDWj5La2LTbRqQW9ON59aCqRiXe2ns2cuH3n7lah8sVUH7Gu/rug/WZ2b0iOQsDp/kCnYlYaBuOnPjHxqKJUPYRAPr49dPDLqejbUAfvJnOcD0LJdCd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706597131; c=relaxed/simple;
	bh=RUVhUB6vWpn6J7iBH9wHMArisF6jGJ3ANfbKe/M0vAg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FUJ/LKrfuz0t6klAlpqRJUTosfCa2Sxzz0OHKZlZ1dX4BJ7DgYCFbgVTTTmgFVlVO/VPioWtYtsD48pCklyOTX9q3M8+zTMlcp5Eur0MeSgnCRS4Mu2D2VjMCF+mCXNN4WTYtzbqn1q1VpSqooTfNPo1vd88CeaqPxH8ASpNxAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KaN6QwH8; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KaN6QwH8"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-6da202aa138so2196287b3a.2
        for <patches@lists.linux.dev>; Mon, 29 Jan 2024 22:45:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706597129; x=1707201929; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jG8Pdn1FHmkpqrT0d8YZDwmhNF09U0vd9Cbri7aDn5U=;
        b=KaN6QwH8UcTX05w6RCLJ9r2KGjeFBFDvsiotAX/2DZ9abLNLOCr7/CS9We+TCVznNk
         ucerFh+IkB7cBzrDzLy2gKwIVRxvGaGBVfZg3tCyvjpcKcXBYUtBFJaPCFhgRENd2gVm
         hmRyNxGX1GRPVSsnGZE6F2P/VT+Xx23HOiRXSWOjSwMixE4j7Inm1A8el1rFxfu+cCsh
         nihQNTK20yeeUDgeBrkjLXcpXnec+WoVbeka75JytsbxzcCiVNM1F/MYnOeVjysLrfB+
         sWrQ5E09cBODSalY9TiQ8uOYFhtaU7kBN4Lw+Ig2xo9XX+GokGRblpR4EwBbJLO9i8fH
         33Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706597129; x=1707201929;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jG8Pdn1FHmkpqrT0d8YZDwmhNF09U0vd9Cbri7aDn5U=;
        b=E7zyqPr1z028e1H7/hJ0pWYmJvFI+moANkTHGK7ASBGjWbQr1Ec84q9T6vsk4fcDCf
         q+pgzDuzOg0it0VCIO+rcICzE1CExc88NdkPDEbc0AMjDO3IWGggK9Ax/7CPZJAJp4co
         52GjL7FogVl0vbrdGvsHmhSSwA/Fm9GeVX0ITnp/OyY4IrTgwyIv3lCKa+tniYTzAQYD
         oj7KXwVQQSkhRtqbQoq6M7qy7q61S/U80q3/7OSRGI6lgh0hJe/mChoUkKWtPz7RXrv5
         BqAOZ97q3eRc/1XPA6nzTFUZ73pnRK0qYMj66ql1TPGzS2bohv0lVbtP093/JYxHroLq
         FRqw==
X-Gm-Message-State: AOJu0YzklMw6oW7M0nSPDMI6MFKDPK2La3ThRMTonJXfJYrR50jx7OQr
	wcgLzHnaRJOuYe5o0y1FArNZwCGbVggjA+UPdqCU4vsFEx0z2wTa
X-Google-Smtp-Source: AGHT+IGeGDTHLEO2DU2kIR7EfvF+upqRHyio1QTFSmhRLPbcZWOZy4I2mjf+4B18iDRCqehDZrGWPg==
X-Received: by 2002:a05:6a00:230b:b0:6db:bd8f:bf90 with SMTP id h11-20020a056a00230b00b006dbbd8fbf90mr7517980pfh.13.1706597129226;
        Mon, 29 Jan 2024 22:45:29 -0800 (PST)
Received: from archie.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id fm27-20020a056a002f9b00b006dd8a07696csm6867260pfb.106.2024.01.29.22.45.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jan 2024 22:45:28 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 9E22B1862FCDF; Tue, 30 Jan 2024 13:45:25 +0700 (WIB)
Date: Tue, 30 Jan 2024 13:45:25 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 6.7 000/346] 6.7.3-rc1 review
Message-ID: <ZbibBb92RFcvw7l0@archie.me>
References: <20240129170016.356158639@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ev9pclu/mPcHacYi"
Content-Disposition: inline
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>


--ev9pclu/mPcHacYi
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 29, 2024 at 09:00:31AM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.7.3 release.
> There are 346 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed the kernel on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--ev9pclu/mPcHacYi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZbibAAAKCRD2uYlJVVFO
o04ZAP4ncDeyZeMnHwu8TYV0W9sRtIkOTwea48RNMsB9VpTf3AEAxIQOgeKk3gzB
8P4A88jtE/dkF2yFG9kDniuea2bNbQ4=
=pKG+
-----END PGP SIGNATURE-----

--ev9pclu/mPcHacYi--
