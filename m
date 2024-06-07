Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E2DB64E
	for <patches@lists.linux.dev>; Fri,  7 Jun 2024 02:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717726137; cv=none; b=dO9L2baFXBDYxGoAnWOcpOD6prasaPDGE8vMIghnQcrIpvIohjkfZWCCYCDQcV0reFOl13oyd+bHEfiToD5nR5inYH11XRSvzz9XV9N4p9P6cwTS5CiHMkcm0q+jruf0dhvXDQ/f3PsZiYX4b3zuG8LmrDUzkTPcMbK/jmzJfbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717726137; c=relaxed/simple;
	bh=Zgs6EUaw+fgETHFqLyu+EyBx0t4ITnZTlUfvdp01WrQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LjLlUnq4cJn1Bnh0K4AvVM+8e6zNvRqRHAkM5IhnTh6Uqr2/JWLLOI/DWj2GM1DiMbAfbUP0ihm5PaGU6Xp8q9xIZlTyZEfY7BDurBg01BkwKSE/EbtDTwOOG08QkQcRJuBvWgGalZSRN7x9dLsXke3LFBzhI5ptSgp4HumNYos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P7KHhM3e; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P7KHhM3e"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-702508bf0a9so1346503b3a.0
        for <patches@lists.linux.dev>; Thu, 06 Jun 2024 19:08:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717726136; x=1718330936; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2YbNkfBTg7QNL7W0fk9O5zt5ZxmyJT5/V6X8thSn3Xs=;
        b=P7KHhM3eVjgVWE21uPyQBQxC//jDws3pxxEfYP1RWx7lnRepLfO0Y1FBDkrm2ozy/9
         PdpIWTFT9zWovQAN1YBJvbPnUwQG50WBENVQ0kbkgwrbFzZx3jtZfXN4wxYkjnBMpfJm
         1BlRK6onIC7d9/DksycecuAWYMToxKlBeDkx32wcLzRNV3uTrCwbfzS1Aw1B6Wqrkmoa
         CEx+Vfrm7SzmTLzyxd7teOO8vMovWIRDs2se/pJT/ADqXXnV7b1sCk7Y4Cc+nnI/bJSg
         OsxrbPxlYhJfxgbUV8BnJNtjW49hbLHRqF2myNEIlOgK24VdSJbpKDDalHEwd0BaUA/h
         6fWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717726136; x=1718330936;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2YbNkfBTg7QNL7W0fk9O5zt5ZxmyJT5/V6X8thSn3Xs=;
        b=Sp8XkHU8p4+lHs+gx4NOXkjfFf77D6SjfC620QCu880Dxu+P2AWC6Eb2brNBIauRS9
         3YoWmDVw9Toc1c8sfZ/1Ny3ayip4799AtEW0ySTSwbl+0UYfTmNevVV2X4OnCu82kudH
         9BJxVwuq++dI4qKFkf8+TtqAG2JWH2SH9v5YeymQ/mkvKCGRYEHXn1ROAX+dqajplQ2A
         OUjYVTVn2iu5pTgMqY6iFwcgvdzxVvvLGxjmenzMV/83HCxvwja+K7lLh0awksqiEM3Q
         s5NA/s2YhqamzuJ1h7nki1ChTP1MRoRFuptX01JcbhPq98G2xUzw38ZyrIwe6BcV5uvl
         t8gw==
X-Gm-Message-State: AOJu0YyR/a66Lpsv+MwaP+rrMT/VIjmAGUQ65kdjqSrI+P5FDNGJ5co1
	Hk5XvqooZMACNprHF5ZfJlB/ueGkBF+JH47fIii6P4r/V4rB624R
X-Google-Smtp-Source: AGHT+IGMw2tKALOAt5+mXjWbsar+Mn1+2+TehGkELpiwdXYkZoU9WWSW+/rp2sKMuUd8tEkbZiJgug==
X-Received: by 2002:a05:6a00:2387:b0:6ec:db05:36c3 with SMTP id d2e1a72fcca58-7040c615964mr1144379b3a.4.1717726135546;
        Thu, 06 Jun 2024 19:08:55 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-703fd498a8fsm1687742b3a.109.2024.06.06.19.08.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jun 2024 19:08:54 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id F110618463038; Fri, 07 Jun 2024 09:08:51 +0700 (WIB)
Date: Fri, 7 Jun 2024 09:08:51 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.9 000/374] 6.9.4-rc1 review
Message-ID: <ZmJrs2ntqb77ebCn@archie.me>
References: <20240606131651.683718371@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="3AxIghRg5g1ofXuB"
Content-Disposition: inline
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>


--3AxIghRg5g1ofXuB
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 06, 2024 at 03:59:39PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.4 release.
> There are 374 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed the kernel on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--3AxIghRg5g1ofXuB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZmJrrgAKCRD2uYlJVVFO
o00uAQCB/IULpEyo/wECqAHRYZiQNScetvGwBHIp1X3fIjCUrwEAwRAk2sft3lXh
QNyLORJJ7s94M/OI8Gn+/TuL2Ahv1wQ=
=POE3
-----END PGP SIGNATURE-----

--3AxIghRg5g1ofXuB--
