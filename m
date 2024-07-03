Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE9B1C6A5
	for <patches@lists.linux.dev>; Wed,  3 Jul 2024 04:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719980761; cv=none; b=SusBB0nJW6wEUDCDnL2RToxaLpPKE1VeSu2EHggVmWtCpu7nsDx/SMfTxi/0UaicTe4PI6gbkVowBNR37pQD829VLdPSLmGs94h7C2zUpvsfic80MRAlD+PzWcBCQoQpJ3LKJmwvPAupaFgzLaG9xg7tRhNDpwUPddTB+NiPAOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719980761; c=relaxed/simple;
	bh=CTqwihBOux67otfyvZtz70kvvZA4Vo/MhZfFROMw1yw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=udfbtSnqYVxnu+2CBP53o2UAFi5TXTZWIvNrS0YSJ+KYUOSq0FWcz9YBBxFrFJJgLGSBTvJu9lMiGZFOaFyK4hpKnA5h8VcDj1Wb2vwp23vLOAhPpZXH0Gu6sGKxtNzSJRzezMWQIGSMgidaxZ/+OQtAb29Gxk/pG6sBQlym/5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AHKO6oRB; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AHKO6oRB"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1f65a3abd01so35772555ad.3
        for <patches@lists.linux.dev>; Tue, 02 Jul 2024 21:25:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719980759; x=1720585559; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cBnaqUZYK96vUrgWPYxgC+5OHY9C7ZJqIA02ClmSNCQ=;
        b=AHKO6oRBtnorlQ1MhDmqCwJcoaPfZUks0mY2T8VZ2/w2VahZ+9vpvAtQW4e0SFocS4
         uoJ+B1yUj3Oe7CQZxY4FprNUlfRnPVbNz4PYc4TZUxijHI0lq17Aoc/35IhKJRVaMX6Y
         EpT49ImsHkkQylxPpBR61U78yFDNFXtz2lSLmGO2pGNaXYS800sFaNMDGjRm3G+bJcdm
         bLo1OSJTBW3hfWkBOV5SxvajAzfxJviXNEEn8t/yBMIlPIGD1Y1CilKISr5BC9VwhXD1
         vDt80sV/OdwWKpMhAn8qxm4SBd19W3E7w6vlNPo2mH1DF5uBBV+1FF3PJ1v3zBnTmmjW
         J7rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719980759; x=1720585559;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cBnaqUZYK96vUrgWPYxgC+5OHY9C7ZJqIA02ClmSNCQ=;
        b=llW1QZ89gDgNdao6Gy3+qVfEdzP77Sd6aXLzpe/dXEVFAhZs0l70s9lnn0GlQGFXpQ
         /5q554r6e1GKI/b1MaOGDPVIOZGjPn6nMTHp0J9nYj6tHk5g6Ai/0QFTg4FLtJvGHQ8B
         iJ3WPxlLFf632hITLWOaRiQxXsGgMMHGhd9n5AkiRPYUq/D5BVR6tNVyg/WB7K3h9i1f
         x5AnRasziHSOh5RdDAZRxwev1qqiVg8Z86aqcbeKhpxQFzhRtjnAnCwbQLm7XJGPZfDx
         5Fks/7OHuZfxkoUInz7BmJMVtmTPp4cCtiP2s9CBIV4okc8u7Os4nAibq7eKSxsMaZ/W
         p3Eg==
X-Gm-Message-State: AOJu0YzrCho5A67jNkhq/lTWwP5p9zVHODifzVOgDzilswSjbB2lXKhF
	8GT5sio44DVsLBeeUsEAhNQ2s4rNXTfvadzxqrCEfjuDsnf6+wgn
X-Google-Smtp-Source: AGHT+IHUeV3QCOeOWx1/Vbhxgd3leWzYw8PWTNlqtzJ85bI+P6YvI5aKH2cmkg1+QJ/JlB4oC5AlvA==
X-Received: by 2002:a17:902:f611:b0:1f7:1a31:fae8 with SMTP id d9443c01a7336-1fadbc85fc7mr122403305ad.26.1719980759067;
        Tue, 02 Jul 2024 21:25:59 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fac10e2197sm92898705ad.63.2024.07.02.21.25.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jul 2024 21:25:58 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id A567A185B99C8; Wed, 03 Jul 2024 11:25:56 +0700 (WIB)
Date: Wed, 3 Jul 2024 11:25:56 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.9 000/222] 6.9.8-rc1 review
Message-ID: <ZoTS1NEjgv1FoVfC@archie.me>
References: <20240702170243.963426416@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="y20GA+L+N+D68gra"
Content-Disposition: inline
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>


--y20GA+L+N+D68gra
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 02, 2024 at 07:00:38PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.8 release.
> There are 222 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed the kernel on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--y20GA+L+N+D68gra
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZoTSzwAKCRD2uYlJVVFO
oyEHAQCNKXYyjiaXYt1QH1Hl7jD8dw00fbeEs3uPj+bf7HmoWQEA0jcs3111Kssk
96nRJRvfR2+2ZJa6T5eSZ4TMzMD7LAc=
=lKUP
-----END PGP SIGNATURE-----

--y20GA+L+N+D68gra--
