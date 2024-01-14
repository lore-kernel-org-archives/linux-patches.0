Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE8917E8
	for <patches@lists.linux.dev>; Sun, 14 Jan 2024 05:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="La7fv37E"
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-3bd6581bc62so1102749b6e.2
        for <patches@lists.linux.dev>; Sat, 13 Jan 2024 21:34:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705210489; x=1705815289; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6sE8GJgZQUurHRznhkMrLCR2jJi1Q8GCwy2Ue2LjotM=;
        b=La7fv37EjrS/Ri89l2Fd5a5fUuQU9dndTCcqwFlz1fuAK8eB+6aFttFNJg9XbzQbQR
         SUBxDC7hZJFo7mNIYqmu4Hnf1NdPAQPjBePA7w+25jgpf0ltDzrLlg9s8owmIFYJLHma
         txBHjcp7EHiU/rKcevxA3/Jnvsm+dr2o75C5qx1P1kOKe4M+ldVsKfAA35M1YUu9C2ix
         iAy4MT4iLRcPIDvW8Vg63+ufWjOW+yMugM3msXAllnkXdBLFGVx8PcR2hIN2NdKSgjBZ
         pzZs2BldyLxok9tB34GG+jtUhLqSMqETmZ6uqMyEXH26S4rHb7FOpFAkhbrzpT2vfKhl
         XMKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705210489; x=1705815289;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6sE8GJgZQUurHRznhkMrLCR2jJi1Q8GCwy2Ue2LjotM=;
        b=EyD3/Dt4P3ZafqSYyAawBKsvIyW9j04h9Ra8hSlhX9dXKhaj2c1CXbkOouWsjfgwpB
         GDIkUo38iXTRptBBQG0s/8sR4y7IxhxK65nJK66+5o2AqM0tBIDRyox2qK4q6NdFmQHy
         rG3zvs7sVfq1Lclj1ii1w3iefEOitT75V+DOrJZ4QvlqmHY7uS8fVdKCaUTal/Mlua7w
         nUiG2cZQ44ftmruGpMOUm5mkeGnwvLpI9pZ3SZGxSQ5azwCEs/WYkOnu1zepa3poaENe
         8Py/W42Q0V8JlZ09DoZgf+tJjb+mjwsf2j2LRSN+kFYqZke8xQQUhcypd/Mcih5D+fpT
         IzXQ==
X-Gm-Message-State: AOJu0Yx7vv9Y8b3gRA24DSeM1YBam61SCXDyw55hUgQtrsbnDXYF9Mbs
	6mSHtPCzs6HxIDcUsjT8FpQ=
X-Google-Smtp-Source: AGHT+IHTG+PgGBbFgr5D7soUP+YgGL2BeumCRe0trgMNggDvAmVDnKvr+0kfpm4+h7VZoM2z5cvURw==
X-Received: by 2002:a05:6808:f15:b0:3bd:578c:d866 with SMTP id m21-20020a0568080f1500b003bd578cd866mr4727902oiw.35.1705210489281;
        Sat, 13 Jan 2024 21:34:49 -0800 (PST)
Received: from archie.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id ke12-20020a170903340c00b001cfc3f73920sm5550792plb.227.2024.01.13.21.34.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jan 2024 21:34:48 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 06AF51846DA01; Sun, 14 Jan 2024 12:34:40 +0700 (WIB)
Date: Sun, 14 Jan 2024 12:34:40 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 0/1] 6.6.12-rc1 review
Message-ID: <ZaNycIqURYZLW1Yt@archie.me>
References: <20240113094204.275569789@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="JGCWdCXWhEvYzJz7"
Content-Disposition: inline
In-Reply-To: <20240113094204.275569789@linuxfoundation.org>


--JGCWdCXWhEvYzJz7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 13, 2024 at 10:50:58AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.12 release.
> There are 1 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed the kernel on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--JGCWdCXWhEvYzJz7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZaNyawAKCRD2uYlJVVFO
o2JaAQDxLRLceubxCaSwvgyu7sQ6J7gVQIjdjD8/1ifIc0aq5QEAsd4mDLOz50D/
KDvdhnKa4f3YVGQCKctZ+SuYBXsG7AE=
=xq/3
-----END PGP SIGNATURE-----

--JGCWdCXWhEvYzJz7--
