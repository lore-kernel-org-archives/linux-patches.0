Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996BB1870
	for <patches@lists.linux.dev>; Fri, 19 Jan 2024 06:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705646318; cv=none; b=g+9CH2QDZmcAa2ey1GzgUGSUUPFJVkoSdj8anLbUmKhh2vj6E/hRN1N42gdzqvb2isOMfAE3pvnMRxzTvBAxBGZN7rqXJkcaB3I5NGG2JY8KBA2GVzA4e4A3jqTqr18RvkATmTrvvCdtZcWlN7eNWyJUMN9kQhM+j9auEIhn4eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705646318; c=relaxed/simple;
	bh=j7SHeHyxzRsXVPHN2nQxvOkMM30oEoiFZsERLqnzMC0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tGdfC6HFuYxUr0DCzd7hp5yvxYR6numw4gobKj/fqUJQI81hodD8/iyvpl2duUgIIA60sjwuI8Gfn8h6wLpigAiXtjWhIpWkcEsMCmKnu7Ie9ZfYl5xkKwGV3x7kZAzPGx/r4mCJ9ScVZUZk0sArmCB3W7TtpZFDODpWY09OQYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bN1gKza3; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bN1gKza3"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6d9cb95ddd1so356400b3a.1
        for <patches@lists.linux.dev>; Thu, 18 Jan 2024 22:38:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705646317; x=1706251117; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+Qe/k8+og9KBjj5t8Na1yVhACJJNYJYcaBiHf/D2Yf4=;
        b=bN1gKza30UDfu2Jj40M9EWgEK1DIoHeb1+Us3fiukoTH1IlyZWyJNW8u7yjz+vbFxJ
         EyDfdLdND7D3XDGHhPboyMJk/2UIYPveqgIdqshuNuhJfF58sKCxqrPjxnkAhIHfYGQf
         Vdcf+4dwOZLQnbnin5yDc4CmjS1uxHYiPssDLQVd3llGxpwC/IncLqQrqDNWRfZxx7G4
         54gZLiDa3eKUbSj5vYa/SppEmprloyWmXHuz1R1C77lsVea/hm39QobvC/GWTZzPtQe6
         h4T4gZu4NrG6odyD+fsZc8aWOt+RNYE2DQpTywc/fGmVADIvf28w13w96fJhERfsesRR
         tPnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705646317; x=1706251117;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+Qe/k8+og9KBjj5t8Na1yVhACJJNYJYcaBiHf/D2Yf4=;
        b=dSJj2rfaEDa9vwPihOjnNSW5VamMkV6taqIprvxoTrHNIbsHX0a5Z5jJr6LmgT/wVE
         g1PiWCC9x4j05GCJGHBtfPBsegLObID0NqXpOUMWisf9p91FXEQWA9k5WpfR9srxk66X
         KU9O2PrgxPpxRoBpf+mMumOzI1bj17AQn2BSOY87Z6hSLs5LUEHGrdoCTg14qwk0hqp+
         mYfmEYoQruY2cvY+eyVVmTqZuJijyZ977lF/AsT6oDREZ2I1hLnxRjNM+jOudgIf8gbh
         JeL0r4ppzzNnv2/c3gL+MSDIvtq4KjGlJG2jxkjNPwTw5br872+ATTtNGBsHKVsOScIq
         n6DQ==
X-Gm-Message-State: AOJu0YzMbrqKSopUDv43XIJ7DMQ0I7UmJ+vwhawVoK5XmeARzfQPRyAR
	Py8iu6ilEaK4txTg4AP29l9BoOMWod2IDvvYIe/dXFcq6IgtrunS
X-Google-Smtp-Source: AGHT+IH1qY4E7ovyO81RAOnSK2e21BwX85mzcpzM4d6G/8IA158nOsNAYBXc2TuDlCSM5zRU0T9Ltg==
X-Received: by 2002:aa7:9d05:0:b0:6da:3437:f70a with SMTP id k5-20020aa79d05000000b006da3437f70amr1950328pfp.25.1705646316882;
        Thu, 18 Jan 2024 22:38:36 -0800 (PST)
Received: from archie.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id c2-20020a62e802000000b006da24e7c16dsm4319294pfi.186.2024.01.18.22.38.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jan 2024 22:38:36 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 06F2E1854A1A0; Fri, 19 Jan 2024 13:38:31 +0700 (WIB)
Date: Fri, 19 Jan 2024 13:38:31 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/150] 6.6.13-rc1 review
Message-ID: <ZaoY50OP1WG3d1R_@archie.me>
References: <20240118104320.029537060@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="zrxoHMcrjZRlqHg7"
Content-Disposition: inline
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>


--zrxoHMcrjZRlqHg7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 18, 2024 at 11:47:02AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.13 release.
> There are 150 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed the kernel on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--zrxoHMcrjZRlqHg7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZaoY3wAKCRD2uYlJVVFO
ow4aAQCfiuuNbYW2Qcd5R55SfiZmkisibKOU2oQF7MNL2ha5KAD/Yc3tVRXu3yM/
xpv+7sFkIbAHmcVOljQRwS8Pss4MhgY=
=8hPW
-----END PGP SIGNATURE-----

--zrxoHMcrjZRlqHg7--
