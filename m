Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6495E1863
	for <patches@lists.linux.dev>; Thu,  5 Oct 2023 04:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZiWPrL43"
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-57b67c84999so334013eaf.3
        for <patches@lists.linux.dev>; Wed, 04 Oct 2023 21:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696478680; x=1697083480; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RMXyEVE2i3k4dLTGe3l+U9bUqIsZ76xJBWfzrLVaQIU=;
        b=ZiWPrL43tvqDE9VQcVR/WAf8CVaH6C14WSnZC4VT/HQiIybJscHbAt9g/zlQ67caP6
         JakpPLw9hUyRD9k9sXee4o9p8pniCBmUJS6OzRDjSEgDhp3u02n72vtfavqlm6AUyGk5
         m7qRgO5hf6wSzO1bIXxwiMUD2h3Ora9gB4XHzic18hTlx/FPPszcVmKMvwkU842JJ2sk
         MSPrKppJY/RofrFjFUj4c24tNapGlx50CbPhJgUlOKuFt7fLJp/J41s6X9AaK4j+vX7b
         N449u8XnD3haVfHvM7F5hcAKKyCJovVUtDNsR2GT2qcziyeiFc1HtYfQNNKaxcDc+fdY
         OUfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696478680; x=1697083480;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RMXyEVE2i3k4dLTGe3l+U9bUqIsZ76xJBWfzrLVaQIU=;
        b=wFWHFCbu+Fcx9w64r/uk3gN3KDq1yDQoxx1GuiJs/UYm/J5qcUlipGwmmIWy7zKeAH
         VEWkaHreZkzUYAbW+G1ecpFJKQGQf/4gmdLxW0odjAoqYl58wCShTC/oZ/1ZraFK5SYl
         us3QlUpC99TqeAnhcbTM4OnNs2INTJa4NkNfZH39CiCMIEH9Ww8wV45VW0/Fp0eGShZO
         2lwhDDMJSm8nRlkEPF5jefEnxhW9IXZWG0l60CZjlDNedHrS90Z8iEe2rSiMesF/x176
         k1hkkWtXsYJjClpx1pH/3qqLpPn9PL3FrSq9Wmks7TN41EGrRHsKHHYHkYuv1xoTHRxa
         sv/g==
X-Gm-Message-State: AOJu0YxsHRIBwDYHJVUR1u1ZeiECt1cOtHcBx9Am8zGeHaLO69/t5UfL
	oE6v1ap1bI6JcNiMYF8HnAY=
X-Google-Smtp-Source: AGHT+IGSkWOYk4DqwbRQRHzJ3jU+JRLaveKGsN/Rmc1OJnWzSjkTWWfAwyvTJOtRG6XzehfYWnpG7g==
X-Received: by 2002:a05:6358:988d:b0:143:723:8f89 with SMTP id q13-20020a056358988d00b0014307238f89mr4897551rwa.4.1696478680192;
        Wed, 04 Oct 2023 21:04:40 -0700 (PDT)
Received: from debian.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id x6-20020a17090a9dc600b0026b12768e46sm412448pjv.42.2023.10.04.21.04.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Oct 2023 21:04:38 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 0786484462F3; Thu,  5 Oct 2023 11:04:33 +0700 (WIB)
Date: Thu, 5 Oct 2023 11:04:33 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.5 000/321] 6.5.6-rc1 review
Message-ID: <ZR410XeUZfIVaflc@debian.me>
References: <20231004175229.211487444@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="UsH318AZCdPlllMP"
Content-Disposition: inline
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>


--UsH318AZCdPlllMP
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 04, 2023 at 07:52:25PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.6 release.
> There are 321 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--UsH318AZCdPlllMP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZR41yQAKCRD2uYlJVVFO
o2jLAQCcDpwnr/d3rHimS9StGzwJjBbtqH7B6sZCbbOZ+ywhIgD9FdAMSztvx21C
hdzoPWYfxAUqkWC9EpKQ1zrL2odaEww=
=lDbM
-----END PGP SIGNATURE-----

--UsH318AZCdPlllMP--
