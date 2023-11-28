Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3BB2748F
	for <patches@lists.linux.dev>; Tue, 28 Nov 2023 05:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lC3iuEnl"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-5aa7172bafdso3411173a12.1
        for <patches@lists.linux.dev>; Mon, 27 Nov 2023 21:03:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701147834; x=1701752634; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=W23J0BcgxSklclO8sluyghV5NSHeDrAZd0UrfhgnfVA=;
        b=lC3iuEnlhy6ivvh/I32k6E/Neiilr92DcncoDabYy1gBPwjdtSsd7wEo/TlLsNFWwD
         yt8oT/TqU91LaVVA4CAGOvWldtsjHTyTZSsrPbs+i8AenDW1y5/2ui35oz6AXYC+Ch6u
         sY4pGPtadcvgL4kwdXSkPzCvtSGPoSRv//MA++SvzMwwHxviQwSvkK3ZeNSNTVhBdt+S
         jqPrb4Q2vhEe2ghsVQnpk8xx0lyx08XY6SZSPwyKIEdIfmymj6sEveKAYGckIEPMxACt
         erXFX08zSN6xlbPLuBgetSaWdp86w71ZMH/ptiwfLuIZS+VoD+Yl5ltE0x+zt27GUk7y
         w6LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701147834; x=1701752634;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W23J0BcgxSklclO8sluyghV5NSHeDrAZd0UrfhgnfVA=;
        b=cy7glLzssBHxqzSrhX1rVmXGbtw8ZTtQVG+QJ9iSw8VPet5Fo/uKrxxMzpEdrnm+xj
         WiOkuKN38yQwOjnYxq8VG86RhMQBRO0gORFYBJN9j85nu5Rib641ilZcHQU3G8weuRCI
         46BL1ZJ+/6OjcrdQ9lFOxUfuYNoiQ1MsmCEUMrdSFSB33YZ7utKtitbphPbDuR7w7WHj
         0YXz+oAOP7drNmt8RIZUDH3ufnsEj4eHgK4RpJAUzXIs05xeNm/u1X8N+MpqYIXWjdfa
         CBjp9hWpoTjaXTESG6l3AMSqLR7Bl5ZjUrBhK4IBgpd9vd5z+Cs3GNP9GbRr6cJKF/DX
         2x3g==
X-Gm-Message-State: AOJu0Yyb/mck3jc4DGw0N+n2o83jKiMsjBDuCmyeTtPIFknYC620T6FG
	QiJSXAbJ5+L1QdXOVaarOMw=
X-Google-Smtp-Source: AGHT+IFuJn1MeVxt1Lb37TBLOtXkrbySVrPTWFS2/isDPs/CGbGxTtuD1nU4JDP4hz4LPEdarkbjSQ==
X-Received: by 2002:a05:6a20:9e4d:b0:187:9521:92b4 with SMTP id mt13-20020a056a209e4d00b00187952192b4mr15282620pzb.19.1701147833813;
        Mon, 27 Nov 2023 21:03:53 -0800 (PST)
Received: from archie.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id d10-20020a170903230a00b001cfc44aac0fsm3860940plh.111.2023.11.27.21.03.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Nov 2023 21:03:52 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id D5C34101D8AAE; Tue, 28 Nov 2023 12:03:50 +0700 (WIB)
Date: Tue, 28 Nov 2023 12:03:50 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/525] 6.6.3-rc4 review
Message-ID: <ZWV0tk_99WPgDgv1@archie.me>
References: <20231126154418.032283745@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="22dtCgJlc3FKpRYP"
Content-Disposition: inline
In-Reply-To: <20231126154418.032283745@linuxfoundation.org>


--22dtCgJlc3FKpRYP
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 26, 2023 at 03:46:18PM +0000, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.3 release.
> There are 525 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed the kernel on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--22dtCgJlc3FKpRYP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZWV0sgAKCRD2uYlJVVFO
o0ijAP0RDLvzKuwa7DyIA5i0DwkZMEZnmCpEUPiA/1G6gmMefQD/SIfbBmRymQCW
4SybJh+OqlDHhDkn4EmBcZCCrkLoXwg=
=k/b/
-----END PGP SIGNATURE-----

--22dtCgJlc3FKpRYP--
