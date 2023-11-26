Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6727FD
	for <patches@lists.linux.dev>; Sun, 26 Nov 2023 00:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FuF3iAq1"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1cf6af8588fso25535505ad.0
        for <patches@lists.linux.dev>; Sat, 25 Nov 2023 16:52:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700959958; x=1701564758; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KKbAS2Hz5r5UYPT9wOmOu1Kao71kWGzQNplLWwlmgQU=;
        b=FuF3iAq1iAud0Oc6MOmpzaGkgS3/KUig/U2lRmoOTJf7msu3u6mhWiL9a5Bj6SxH+x
         O+NCp8cdXBgICkAxqm/AmsyAUoNOS3IMCLTzu0gvgLw6f+YL8j44ohd+XpHjRdcz1HX+
         +vcCgGXI2XY7TRpgCwoaWWValMeRGFdXR+WLtSFjCDUoAw7Qqvc2Q+kFB6dmpKQ9nqXt
         dJTDodXQvTx3Cj0b65OQ8nc7WbA/srHGKHkoVhl/Tjf+dcXgUTmo92jBFk+YTWgQ9538
         q5djgR3Th0OU+D9I6otnfNSgs9jXShRV8X/d7qJ+4Qf1IbYbv7peNPz0LXryJgFln7xF
         gAkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700959958; x=1701564758;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KKbAS2Hz5r5UYPT9wOmOu1Kao71kWGzQNplLWwlmgQU=;
        b=EvflX6uk+OxyqysK8Oo3Eg3QTxKz1E0E8UApE53oGrxT4kQ77w5B5jr4fAau1mO1kQ
         LxYdAKBk/IGH9rH0U84+uIHi76QqDMiZCqqLwYMkkeZAWTY7jlped2DDF6DvY0sX+VJW
         XKxxQl2oNFSZomhoOroaIaDNq6ecRGMD1/O4B8aFiFKv+/pGnElDguwvho6Cv9siHYKB
         9V0DukqlnbMy7ju4gM7NYZFUMXRG4Y11LI1Gs0G/kwJn6o5O9Z5tz6p0WNp6nx25/Pgj
         z4Cg04tpQdfPgVIiyOHwH0uu8e4SzZqU4mylvSzAh6INMPU/vftNW8YJ9zOiz7hcW1JO
         lPFQ==
X-Gm-Message-State: AOJu0YyzGyDSt5dKHoEFSyud69DT1MIJAcuomgLz+8hsLT6sqq46S5bv
	uAZoDeHBNjUjEMlOYPoPjGs=
X-Google-Smtp-Source: AGHT+IH6FyNJyJqu6BLrI29L97TNTsQiQLKSRLQqESyUex6zppGa1K4ONTCLBwy7o/MD+4fL1ghkiA==
X-Received: by 2002:a17:902:d2cd:b0:1cc:4467:a563 with SMTP id n13-20020a170902d2cd00b001cc4467a563mr10099829plc.3.1700959957964;
        Sat, 25 Nov 2023 16:52:37 -0800 (PST)
Received: from archie.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id jc11-20020a17090325cb00b001ce664c05b0sm5509447plb.33.2023.11.25.16.52.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Nov 2023 16:52:37 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 56C7F10205C41; Sun, 26 Nov 2023 07:52:35 +0700 (WIB)
Date: Sun, 26 Nov 2023 07:52:34 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/527] 6.6.3-rc3 review
Message-ID: <ZWKW0rxstUR9Qnen@archie.me>
References: <20231125194417.090791215@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="YjTMKzLNLP7oLp3F"
Content-Disposition: inline
In-Reply-To: <20231125194417.090791215@linuxfoundation.org>


--YjTMKzLNLP7oLp3F
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 25, 2023 at 07:45:29PM +0000, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.3 release.
> There are 527 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--YjTMKzLNLP7oLp3F
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZWKWzwAKCRD2uYlJVVFO
o/F9AQDS2pa83YDWDhWxMzoiLWzfNPcGYt2GVvwS4pBVMs7wTAEAyYfn/Fvrxdj/
jEtZeTGhjlo+BcrcpQT+79IChb732Q4=
=zVdp
-----END PGP SIGNATURE-----

--YjTMKzLNLP7oLp3F--
