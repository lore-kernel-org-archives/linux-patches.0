Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B0F10A19
	for <patches@lists.linux.dev>; Wed,  1 May 2024 02:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714529566; cv=none; b=ir2cWQ/3pCExwcB1kByCB3g3GcsQDwsrhvKJ2UNL/dhITvKJI5KmGSKTD7JaHrv6wYVBQ0mSQJah0lEsLKXrRNljBrSom3Ki3myZBMWx7RzqB03130BTOwsz5z2uhd9VBR2VZGRZpLlFeekCFQ3KRhRo6va3Hrd1gF8EHHqFbCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714529566; c=relaxed/simple;
	bh=3BgS9/AJBLqIe6NZ23UzhVBM7IJQLJanQj1HJ7kcSj4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BPW1f05ieu4XGSYiqHl5eLd9KDPuuXEbcnnChferuoxzFLD8EflSS29ANSLy3vLrHqaX21oy4UxaHmEEv+X3I4fFM+x2TB4Z9Pt/RCLqT7p25x2tvCvOnz+hFob0sJtpGXWy5GGlXwE48gYCxH5eqMFAsgcearcx5HaQBGwTpfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AlAlwWdw; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AlAlwWdw"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1ec69e3dbe5so8861555ad.0
        for <patches@lists.linux.dev>; Tue, 30 Apr 2024 19:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714529565; x=1715134365; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RLvimjdrO9Jqv7W4cDqyYmgShWy3d76V8PjiL+KAV50=;
        b=AlAlwWdwBPZUGDjmT3zRT4lJWc40xJtRfwXit4gfFMjQEkd11209D1NZwjIIr6ebHv
         0PLJtH0U50Ww7mvS0WCL3COznL5eXaVZltTmaMsb6nT+jvqPV+0y55iN4O/wijm/YYv/
         HnA1VNiohrZKv+e05AQzL/ZmFNROLQuGVqJm+biW1WDp1PSDhDLtiLFuPo7UexPlO0zb
         Cysq0MjsYoiQfoXm5iO70F48ZXBOY9O7vLuizJzgsdee1BSXGDQ2eFHODAz2P30uaUQp
         ezPX5dedvSesoR9NTryZYlGqSQODu78ohTlqyEBlvaYcEVzfMn+ySbAUrciYiRvbbVzy
         2qvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714529565; x=1715134365;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RLvimjdrO9Jqv7W4cDqyYmgShWy3d76V8PjiL+KAV50=;
        b=W+O+mYYMjLY6L18X+oQcZMSSZlyYN4PXExRH6roeW8gkv6r7Jx52VI/DwX/dxMRTyg
         cQ55IFuVLZRkl26gNbI2eOf89EqF/vH72/yhY06MG28bDkWLFJwJM4R/UuU/trkcnkP5
         z5YhzQvc41jcdZsU7McO+sEv/DGdJEEU9Y46vJoSL34Sy2jr3nBHJB+XJnRcYqOGcTeF
         WHTej4VBFbSx3nIrWv/IeSvDBc/H/XM5ABOhSJ9mbLfzp87bhpLWiY4zdtfB9T8+6BVY
         +nqelzS8gJRfqF8LWNwNmfyXTVc0NrRGAzDniBjsAuTBx7lMFNL7xr+A/BRi66HXxKZr
         x6rA==
X-Gm-Message-State: AOJu0Yyw5lH/rZY8pI2aYPzHxhvLVziO82aYk9XttA8hZOP9//WpgidI
	N2A4JD/UUD3QlgThQP6aPxcb7AltoL0l4OGoriyYCdAuAE7xD9AgEcffhg==
X-Google-Smtp-Source: AGHT+IFU1CNEHqsVmvSlgmR45wcV27Yx06nSSBXJ6JaF28LU8QLf+Y0xNiTeih6ek4z7354TpTJIMg==
X-Received: by 2002:a17:902:ec85:b0:1ea:b125:befa with SMTP id x5-20020a170902ec8500b001eab125befamr1316439plg.55.1714529564636;
        Tue, 30 Apr 2024 19:12:44 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id bi2-20020a170902bf0200b001e27ad5199csm23050397plb.281.2024.04.30.19.12.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Apr 2024 19:12:44 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 08E3518462BD2; Wed, 01 May 2024 09:12:41 +0700 (WIB)
Date: Wed, 1 May 2024 09:12:41 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.8 000/228] 6.8.9-rc1 review
Message-ID: <ZjGlGbF325nZTjIe@archie.me>
References: <20240430103103.806426847@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="D4r5PoDmW8atS8hS"
Content-Disposition: inline
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>


--D4r5PoDmW8atS8hS
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 30, 2024 at 12:36:18PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.8.9 release.
> There are 228 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed the kernel on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--D4r5PoDmW8atS8hS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZjGlFQAKCRD2uYlJVVFO
o5FqAPoD1n/DIgEveWXfDbsxiyA5LKJGy4n7/x5mvX1m30jTDgEAnWfO5SuWF0cM
qpKAoRkPth+GeeT+JNDRdwJhaXEjHAk=
=F/Lb
-----END PGP SIGNATURE-----

--D4r5PoDmW8atS8hS--
