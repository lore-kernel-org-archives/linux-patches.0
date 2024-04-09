Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAFA93A1BE
	for <patches@lists.linux.dev>; Tue,  9 Apr 2024 01:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712626200; cv=none; b=kIaNyrUBkNb/RDQV7Ie2PU/FvCR+Uzkxifd5xhNP/PPjCFtlkfTCLPGZryL2WvIWcJQUDkmr59DS2WdUQPE/Lv5TMxfKKLpMXgNFVIksFOTLMOD3Kb3eIS1wUahGlM32V04orW6OVPsQFeLTKwv5YUq+ZqKALKFzWDi95jPsTdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712626200; c=relaxed/simple;
	bh=1z6d1tDDSFA4H/I8bjImtg61JQJRyJ40xuTg84O98aw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OV0BzmeZEe73a3qo06ONXAQUuXJFiEvdq1RGWGhOJvJ3kj7+bbTF/Fg8xDdXrQ+MVF1Tl5sSxalrPH0SGbd55z6Gb57qFVUSimzMLvKGgvhSA3auPEwXhSh7GhAemakBZK8cqWWhR7wLDezdmvxvVJcvm5vLscg2pSgwxlUUOxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O11rf+6k; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O11rf+6k"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2a2da57ab3aso2916185a91.3
        for <patches@lists.linux.dev>; Mon, 08 Apr 2024 18:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712626198; x=1713230998; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xcH7mjUSf37c2TRYjSnNBiA7jaHiSTYFNcmHQ9LeGEc=;
        b=O11rf+6keLRuv8kXZNRxQaPNroAwTNEvDq8AEXC3xrcYE7mur5hE9O8R+mItMg+xeQ
         UpmGQiLIm0fdhvTSM2z+zyoGxFbJL3nH8dQkuOXFITNeTyZLk0qP318Q5FFJJiX8+oUT
         SaFspStBwDZ+NRso9NjduiZecXrfIPHXFmb/XbFtzLNySkB8mzYJsyS3zx1QqM+ICDI8
         yU+I7ezDhGWQsB1YllR8kT5YphgBaMhUpOIj8Ro781AlxbIax+Lgv4i6npe4/36CPgUK
         IysaQvZ0Oz8QfS4V6Js/cysukOB+jn8Ok9xTCBht8PJATgyUVIMyaQF1lh+UTyB/i9BT
         bixA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712626198; x=1713230998;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xcH7mjUSf37c2TRYjSnNBiA7jaHiSTYFNcmHQ9LeGEc=;
        b=gvLrJbmVimS3Y6HQ3lhfTO1zf3VsksnTZAdxSBxkqJCmEq1qJ7pxQKijad7qEVpxip
         HkzYlz87yuLliGnvX3NhSaBVpj1G/9ZB6yb6Jl4ddJMQEV70uKIrl1Z9x6Md6niosKcP
         p7p7mR8bBgiYyOO1YsVjKOGzcycRu6aXQeN2lq0upnuifnPsKEkm5wAsf60+j1Tboy3T
         a++AGVERZAQihJC6VHav6z5mbLXFfsGRAugy724Sf/SRmfSbOwCG/pfknL8Uzadk/Knl
         xuvNGKDUedPvUEja8fZBV/fv5sfGiRhh920hBE91L6RW2TBQN8xjfaWHL+LRrymiJLqO
         kwvA==
X-Gm-Message-State: AOJu0Yz3Scky58DRWwpIiRBrtalnK7ZDPY0iOEndUXsp2lOXS9u2cmTn
	sw1Vx92ZCrgcYrYLm45/sfNZtneLi49B+NxBkn+8rrOwfZZMPj0p
X-Google-Smtp-Source: AGHT+IGZnwgUOz1BqN1c5yLkdQwmmVssLMzs57TdHPJEJD5dpvuXwzoiIyQ9tZ5nOTVfg6tfbJ6www==
X-Received: by 2002:a17:90b:805:b0:2a4:7133:7e02 with SMTP id bk5-20020a17090b080500b002a471337e02mr8521041pjb.35.1712626198010;
        Mon, 08 Apr 2024 18:29:58 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id on15-20020a17090b1d0f00b0029ffcf1df72sm8844622pjb.38.2024.04.08.18.29.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Apr 2024 18:29:57 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id D49FF18470A1E; Tue, 09 Apr 2024 08:29:53 +0700 (WIB)
Date: Tue, 9 Apr 2024 08:29:53 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.8 000/273] 6.8.5-rc1 review
Message-ID: <ZhSaEVEEh78RY8fz@archie.me>
References: <20240408125309.280181634@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="a7kZAJtOWI2jj9SG"
Content-Disposition: inline
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>


--a7kZAJtOWI2jj9SG
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 08, 2024 at 02:54:35PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.8.5 release.
> There are 273 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed the kernel on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--a7kZAJtOWI2jj9SG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZhSaDQAKCRD2uYlJVVFO
o+2aAP9y814LJL5WCPu+pvg6Hy2dWEwsu28eEHvnd3UhmENragEA9wg9CmasZ13B
RCiyK5QJI8v0LCa3Jb/97eksR6Z2AQM=
=gjIS
-----END PGP SIGNATURE-----

--a7kZAJtOWI2jj9SG--
