Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7103D547
	for <patches@lists.linux.dev>; Tue,  2 Apr 2024 08:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712045820; cv=none; b=m6WAnR9l9bwSicOw2JZw6AN+6EktGbuMND/C+l96+CWpvTODDC7leTAHaUOkMyguiNP9tRQM8FJw62GYpdmlFcmQGzBZ/5wckKLBMsO3mcbR75ZYSCI+/cXF5FAInqpcpWOt/nUsEkvFY45V83ArDCysDu9vpBFvYGWXCbN/52k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712045820; c=relaxed/simple;
	bh=fHfWBt+5+tlmiFF5W8s3mbBkeuPcLWeMDiItbwj7Tt8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A+2q4UmNaX8J3ciSCJjPHJ7ypVs6SQPlFYcbE1oYDzbkGGHGINuWXgUHtesruqlVqH+qiP6jJ6AJSHtBOpi6o+A0j8AxB+B3StScGmAwSRlDN2id1WwViMcw88ONSzlw7y8R1WpXPlpBZZiyz87lWgVG1QDvTEoD7twG4oQ6EMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IfX0L3TG; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IfX0L3TG"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1e27f800ad0so809675ad.1
        for <patches@lists.linux.dev>; Tue, 02 Apr 2024 01:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712045818; x=1712650618; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XkNvR4qIQ0Db8em+0g0qh+1j9L+Q3Yqd9OtOLhE4ahQ=;
        b=IfX0L3TGsAmlGce3GQdlnttjBoyvpewD933zxmWBxO3SJLOVLSbvlCY6h0PLcWz4xj
         XBItnKJIiqQ0AY7sjUmk7+9PghPfAo+8N9CR2qoghYj2/nNFf+Z09jJcX4CpELchtIFr
         sqXrCrE8T3oEGKz82p34zHlGKUbczcJP+mJbP6+5OZXXPokHcQQoFp9OD9EKBVIOzeQS
         DpaafbIubbF1bFVLgZu/Q9Y/MX+F2REASopnmYwK9eL2Sqk46DXqBZroBxGBvdLbIBZ2
         Efpq3JjS58KFyzcWSS6kZR5259MbnCV+2r0qas99BrdsqAmSbMJqsd8FGiCjJvNmYA1A
         sjaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712045818; x=1712650618;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XkNvR4qIQ0Db8em+0g0qh+1j9L+Q3Yqd9OtOLhE4ahQ=;
        b=MZQVI9NMSWkYvWDiZ1ir634asBxUw6PDezuVhgHfwjDyzofdgYX+0SVfyXv5srWqu9
         G0HNhloiPvUytlRy6qysZG2wYCKMsL3+zPbLF5ufOfUn8aJJrabH/+b0FhV6qIIVpbcV
         aFlMwyj57/9yho/ETcus6pDSrN5XA09RcoeifqgsUZYq/BvRnid3Q70OzmmU07e/C46I
         jr7DbYFpwpnjYS8KJjLxcnKIoylpGqpla+QmVVh8vfIuTeJ3fLU32nITzgzKZ58aTML1
         bGzV4pDHgSTQr6tvZCb/ab1edqDuC/Typ9EzlXAlDCgisgnAF7S40TcYS6PwpAKA9Waf
         XASA==
X-Gm-Message-State: AOJu0Yyt9dZULGmG1j13d5D1QXEs/myib8q+ImoQgrOj8qEYe0KtXHCv
	M2adBPObMF0CD46DT18u0la8AZP0ca1ijvVB3d6dYi6vd51P9NFR
X-Google-Smtp-Source: AGHT+IFxd0fZOmFNHBnb+TBQTxGABlte5U58aCoKtKjlAKnzhZGF2G6G4Wy/MVJQ/Sdd/ZuNPOMopA==
X-Received: by 2002:a17:902:ce8e:b0:1e0:b0d:5b7d with SMTP id f14-20020a170902ce8e00b001e00b0d5b7dmr11626393plg.36.1712045818498;
        Tue, 02 Apr 2024 01:16:58 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id p16-20020a1709027ed000b001e249843f3csm5680349plb.223.2024.04.02.01.16.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Apr 2024 01:16:58 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id D40B21847976E; Tue,  2 Apr 2024 15:16:54 +0700 (WIB)
Date: Tue, 2 Apr 2024 15:16:54 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.8 000/399] 6.8.3-rc1 review
Message-ID: <Zgu-9mXbrP7KnKLT@archie.me>
References: <20240401152549.131030308@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="2pA8USOwcFlMD1qA"
Content-Disposition: inline
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>


--2pA8USOwcFlMD1qA
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 01, 2024 at 05:39:26PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.8.3 release.
> There are 399 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed the kernel on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--2pA8USOwcFlMD1qA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZgu+8gAKCRD2uYlJVVFO
ozkaAP9vI+2/N+R4TCcyvBBlUBallO1Fb8t4vDeTkR3TW7qTxQEAnVLG01UHNXKC
kkWlz1NayRaFHHVptcG2FT95HtwmqA8=
=g7sZ
-----END PGP SIGNATURE-----

--2pA8USOwcFlMD1qA--
