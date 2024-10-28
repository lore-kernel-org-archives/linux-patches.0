Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6615618CC12
	for <patches@lists.linux.dev>; Mon, 28 Oct 2024 06:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730095904; cv=none; b=NSXOMDk0OJQLGe9sQoSuRe1IR5biH9dpkFqMsV4apAEf31IWbc3jz7uH7b9gSa8loQNqJn5uj+jXSr9aA9DAaEiAqhuBwoLmWvXdfLODrzaImY52uq4RqhZj/BIRYEdw6XASeE/mS4EHNpKHNdnRmggWMYQqbHEKOny1jCSV+PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730095904; c=relaxed/simple;
	bh=jbuTbPN2jVKzp69xgs5KjAtQm+Zh5HKjy+T4XhAJERw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A0qVuhKzyspT7U/j+USU/D+7PhGDacSpaqOS5tbThL3ASw3MCsdvSLx+3CNP6ZVFvLASlc9rGz3t8J9s5Q9o+LAKZSzrOuGfEh3fPY7v7z18yd36Jr/U+iDWkm/+K6hyAGWwOePAE4fTmK2q8xHE28hupGMH9/n7x4ZG3Pfhswg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J0WzYD2G; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J0WzYD2G"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2e59746062fso3099766a91.2
        for <patches@lists.linux.dev>; Sun, 27 Oct 2024 23:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730095902; x=1730700702; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jbuTbPN2jVKzp69xgs5KjAtQm+Zh5HKjy+T4XhAJERw=;
        b=J0WzYD2GjvlcGI0mPQyxOLx8Foo5Hy0AIw06d8DcVTRaOQ++3ANvTgoYY8Y5LKcfMU
         pwke63IDyCUNhqRjW2lvSEjp2nGv8r7gy9U6RxtCP7QUb2pjx3MlnaUKYA1eliPl2Hwl
         yQpm6GVEiS9isCoykw/pZfdGSe59REwXlSz3jn/HTWULkegVD2jlBdfGLJiIE9DgAx+B
         vS2qjF7Vxb6eG9CCRicjqwfmJ4HOmA/XvoUug1H/bnXyh8Z7T0VrtvhOZKrmgVOGbunO
         X8QrrbwXYE0OR9WaOSOJC2ryaHjXS5CZ3HL0h1T4T47P6wNZFXwsq1w02U9jlR3XLJ6T
         jJjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730095902; x=1730700702;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jbuTbPN2jVKzp69xgs5KjAtQm+Zh5HKjy+T4XhAJERw=;
        b=ONNXNqasdZFoAPNM7IJqFqIH1mpQrRgfD19UwhFKVpJq9PCvdFuIbrNr8U0c6LxT19
         JEUZDfZbkL+DCADyuvTNZXlnX2FT+B4u/TLqvLGea1hp8F7lOrr2dLK0IvtQaGn7k1+d
         hHtkcuBIvW2hh9DAY+jcvnvQmQHPBfuMMW+uy656z4RZKyBUHAM4O7CcrRqeSbUYRvFR
         2e3qfdDHZh0LZAO20DpCDloGlfpE0E5wuAyGZ8vLnK628x0EFBICYPV+OAdnr/QvT8mi
         5bZcZN0U+b/6y33m0hIsGsyuUETBO0blL8KX3Oaj+eC0cHYoJH4ovO8qlBWemv1N2NNa
         xzPg==
X-Gm-Message-State: AOJu0YyrDu5/71eN8ANQQ4+fI0zmDTmIg6OprQcCSna2/CUt/1BMauoY
	RZ6Mrc3Q28EkmXrZr5rWIeZI4mZbZUdYI7nGsTYHL75o13/uMjtBej1KmQ==
X-Google-Smtp-Source: AGHT+IG3UFg+q/e8fdl3GI/kVoudZOs1rz1KQ3OaB+SGwaxDn06pcGwHTnDQ0u21xR5lV5tr/XuCNw==
X-Received: by 2002:a17:90a:5601:b0:2e2:e743:7501 with SMTP id 98e67ed59e1d1-2e8f0f533e7mr8222044a91.8.1730095901680;
        Sun, 27 Oct 2024 23:11:41 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e77e5864e6sm8216108a91.47.2024.10.27.23.11.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Oct 2024 23:11:40 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id CE89E4229D6A; Mon, 28 Oct 2024 13:11:38 +0700 (WIB)
Date: Mon, 28 Oct 2024 13:11:38 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org
Cc: patches@lists.linux.dev, Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] Documentation: admin: reorganize kernel-parameters intro
Message-ID: <Zx8rGu6Pgy83RLz6@archie.me>
References: <20241028005356.214369-1-rdunlap@infradead.org>
 <Zx8ML4Q6GyGPw-sy@archie.me>
 <8b13719b-522d-48ec-92fe-6c98d651f947@infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="dHSCKawrK9nG6pkb"
Content-Disposition: inline
In-Reply-To: <8b13719b-522d-48ec-92fe-6c98d651f947@infradead.org>


--dHSCKawrK9nG6pkb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 27, 2024 at 09:27:50PM -0700, Randy Dunlap wrote:
>=20
>=20
> On 10/27/24 8:59 PM, Bagas Sanjaya wrote:
> > On Sun, Oct 27, 2024 at 05:53:56PM -0700, Randy Dunlap wrote:
> >> +This document may not be entirely up to date and comprehensive. The c=
ommand
> >> +"modinfo -p ${modulename}" shows a current list of all parameters of =
a loadable
> >> +module. Loadable modules, after being loaded into the running kernel,=
 also
> >> +reveal their parameters in /sys/module/${modulename}/parameters/. Som=
e of these
> >> +parameters may be changed at runtime by the command
> >> +``echo -n ${value} > /sys/module/${modulename}/parameters/${parm}``.
> >=20
> > How can users get support for parameters not documented here? Post to L=
KML
> > (and hoping that they also Cc: relevant maintainers and mailing list)?
>=20
> That's probably the best option currently.

OK.

>=20
> >> +KMG suffixes
> >> +~~~~~~~~~~~~
> >> +
> >> +The [KMG] suffix is commonly described after a number of kernel
> >> +parameter values. These 'K', 'M', and 'G' letters represent the _bina=
ry_
> >> +multipliers 'Kilo', 'Mega', and 'Giga', equaling 2^10, 2^20, and 2^30
> >> +bytes respectively. Such letter suffixes can also be entirely omitted.
> >> +
> >=20
> > Metric suffixes?
>=20
> Hm, it looks like memparse() supports all of these suffixes: K, M, G, T, =
P, E.
>=20
> So the heading could be Metric suffixes along with some changed text.
>=20

Agreed.

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--dHSCKawrK9nG6pkb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZx8rGgAKCRD2uYlJVVFO
oz2YAP98uCC3FPwW3EGkHnpcMof/YVq7xRBuMEbJyKq5avR0sAD/SLsSOVuoTORu
d1HBbAHZnW9Oguk+sac8nimHlSHGPQo=
=TZ/X
-----END PGP SIGNATURE-----

--dHSCKawrK9nG6pkb--
