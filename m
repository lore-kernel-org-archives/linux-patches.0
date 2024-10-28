Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83968A47
	for <patches@lists.linux.dev>; Mon, 28 Oct 2024 03:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730087989; cv=none; b=eWKgylhUkRt+GBHKXtGfkZa+3dk3Zy0W4tYHsRYmZhfgC2Eg6K3JV5SCbse/tqqzuAw+UDfdvPBfhj5CKvNhrXm19cqduzxtm0AsWkbtIBuJpBVSxavuIFqzYJ232h3/Zh8hUwPkiDjrscfSWvHj9Wr3Ok/Fp5cZEv509RlHdPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730087989; c=relaxed/simple;
	bh=xOIucUSOyVzn+tOFu1dRQsBV+Ijf9LMcPaW+mlRS1Ds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a+GGz2a3FhcG1/w4FpUe9NEEcxdnVELmfnuOZRwIxgYCtuFPRFUdDlP0bdwNTRLNztp+s1mkUONziZz7ydySVrYBHzQQzmG5irYfCLOnpa5cqNedZTzWzCxT6BVm6H/m0nLY8qhm1QKQqYDYyBNQsny0qvDByplYOJkbMjwQD0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gXS7ZVJ5; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gXS7ZVJ5"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-20e576dbc42so38194225ad.0
        for <patches@lists.linux.dev>; Sun, 27 Oct 2024 20:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730087987; x=1730692787; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xOIucUSOyVzn+tOFu1dRQsBV+Ijf9LMcPaW+mlRS1Ds=;
        b=gXS7ZVJ5mDomT8oppdQWHeFRMeFQElpQu6/N3jrf6v37gnPJp2aFcHjUdLPNnYM4lh
         g52wGln1MotJxq2wTnF6fXhUjHDQ+aQ+c4voeOj1R9XKJKDyH/Bhwt+5JFHE+YG3bP4L
         OZyK1wK17piwGFHoIMVNv5Ocy6hea3q+AWa2wUGAUpObkjHDMWWOvRNXdyrTNOZb8xiL
         Nop0pbs/ZysV4x+78q4XRWrhFWRvxsWRdT5k5Rs5/TMjdtVcvjRRNkNx/btiN77kk0Ga
         dOhZt5ILjzPZ9RU4/alrwD6rZ7NpzPRYQTg87qmKRUFq/dIu7xHB8RknTcpTlJhoJfuW
         r73g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730087987; x=1730692787;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xOIucUSOyVzn+tOFu1dRQsBV+Ijf9LMcPaW+mlRS1Ds=;
        b=VZDYUr8MWnSPitoKjdqAkqYsA+R+YLsDOQuknSc5/frzP/1gsa4j14NkYrTCa6Rq7b
         rjY/1vf/0XA83XWtVdhzltJJi9CXziPSo5XWDrelorbrECrt22tK3k86Y0X6ajsxcFjm
         JvQYDsxHSt9oxkw2jkF2IIzyIn2TG+neEzZVhTi0Yk30D8kAc9cYhx+vbuuLhn+UG02B
         eFnzrOJO1Q5K0jkCQXvarmPtny4mnhPYgm4vsG8XKN19Ng02hxXvTlICybSx2twO10Dc
         UdXrO0XIJesQw0psfWMkClePrNEadb39FDsTjGl1tYwK7paa73iJ/5PUxFFT4dHKIIdN
         FvAQ==
X-Gm-Message-State: AOJu0YxIEb4lcP7UKSTtg2JhCUtmOk8ae6Mfsoz1+6JrzlYNgMeFYgka
	xwOFqEtKvgViXXe3Xbod4WlQQ45kxYJ3jmrD5hVQg7iam9z4iFGRustXSA==
X-Google-Smtp-Source: AGHT+IFA5oS/XPDQvLN2aoJlwFpsbROVoWTN2+XagbztkKaII+Up9jqVlypAInw5cImbL4xe/nzH5Q==
X-Received: by 2002:a17:902:ecc7:b0:20c:5263:247a with SMTP id d9443c01a7336-210c6cd3749mr84465515ad.38.1730087986764;
        Sun, 27 Oct 2024 20:59:46 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-210bc044f00sm42155775ad.260.2024.10.27.20.59.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Oct 2024 20:59:45 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 945E349E58E2; Mon, 28 Oct 2024 10:59:43 +0700 (WIB)
Date: Mon, 28 Oct 2024 10:59:43 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org
Cc: patches@lists.linux.dev, Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] Documentation: admin: reorganize kernel-parameters intro
Message-ID: <Zx8ML4Q6GyGPw-sy@archie.me>
References: <20241028005356.214369-1-rdunlap@infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="9zN7ASNFAgZBmq41"
Content-Disposition: inline
In-Reply-To: <20241028005356.214369-1-rdunlap@infradead.org>


--9zN7ASNFAgZBmq41
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 27, 2024 at 05:53:56PM -0700, Randy Dunlap wrote:
> +This document may not be entirely up to date and comprehensive. The comm=
and
> +"modinfo -p ${modulename}" shows a current list of all parameters of a l=
oadable
> +module. Loadable modules, after being loaded into the running kernel, al=
so
> +reveal their parameters in /sys/module/${modulename}/parameters/. Some o=
f these
> +parameters may be changed at runtime by the command
> +``echo -n ${value} > /sys/module/${modulename}/parameters/${parm}``.

How can users get support for parameters not documented here? Post to LKML
(and hoping that they also Cc: relevant maintainers and mailing list)?

> +KMG suffixes
> +~~~~~~~~~~~~
> +
> +The [KMG] suffix is commonly described after a number of kernel
> +parameter values. These 'K', 'M', and 'G' letters represent the _binary_
> +multipliers 'Kilo', 'Mega', and 'Giga', equaling 2^10, 2^20, and 2^30
> +bytes respectively. Such letter suffixes can also be entirely omitted.
> +

Metric suffixes?

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--9zN7ASNFAgZBmq41
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZx8MLwAKCRD2uYlJVVFO
o4CDAP9ghJCv6bQp2yMD19pUKZ5GJG/K3oCf20GaeKfgNpyJaAD/T6GPwOMK9nBQ
3p3F6/ipCCWIJXBCrjMi/4hsU+7f9w0=
=i7Td
-----END PGP SIGNATURE-----

--9zN7ASNFAgZBmq41--
