Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386F0D2FF
	for <patches@lists.linux.dev>; Wed, 14 Feb 2024 05:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707890057; cv=none; b=jiBZBPenT0tC+qGI2N+xGe5BxsCu49fkV9rH2mVB2DBWE5Xam4jJehfbKNSA1RyiJm2gihTa4U0aaFicbrUIPKFm6Ik480FZFozDQHBIQby/l+sf/SVxiJeO2j1lTgWKp0pdsF4Q2pa2oCxBFKAW4t3wA7Yiyz8jX9aHhwb8jRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707890057; c=relaxed/simple;
	bh=25ckc3KM/P31T2MmlHew23WCxv8QHqJXI2iLVgv6gnY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eFy02akfRXxx7llJXOIO+RK65SczGHeIzq1Kl6ed4oZ9HACmTPQ4X5ceJNu7zoJ8KzzNUv+9HD7WoR+rN1o6hwKQMXHzl12IJHnoTNOAL8Axuava2Smi8S9PT2DZG0GdXaWJyLx1gTe5jce/M5gRYJnoEEploKCs5rUVrIVjExY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ORl6+Ftd; arc=none smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ORl6+Ftd"
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-3c02b993a5aso3010005b6e.1
        for <patches@lists.linux.dev>; Tue, 13 Feb 2024 21:54:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707890055; x=1708494855; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ghC12rpvGm7hIVfOQHZin5gwiwfogaH9K8RQZ1Sn/iQ=;
        b=ORl6+FtdSHOeVAXtqGE5BZueWgmla3jVHODuK9lu1SOXJGzdgT0OWMa8N3sKuBlXqn
         YiJJ/9itjsOOLKEFWDfQObzHQ+KzFRVgx2qrhf3QxMACKVFv2toX6H81ntyJQKQN2nhj
         YfEendr7E8BhD7OcjAC7sL8b6qshYbBDm90e1iDjVgpbElEhEEqaTeoSPf6AmvXVWNI5
         qF1U/qX3DTvUNVrVyAAJVwy0Nh4vndu5mV39gAo7PwHPkp9dwROuCbVtsHqr5y6L4jtr
         oUcpiN5hZhmMGGnMzuQbas4QDVoenaosMrLvDjCkrLvM4bN3SKj20eN1vkEGv1A7288J
         8nOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707890055; x=1708494855;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ghC12rpvGm7hIVfOQHZin5gwiwfogaH9K8RQZ1Sn/iQ=;
        b=hZDB7A3eUnwIP3PZUTV+nTqJtboPAOwiU3INtRNHMfrqKEGcsOcE1gURZP6BieF/1l
         mkdeghj2PBgNHBrgeqD+np3sP78h6XjYu3Wg/b0pNkwI8QuuRze3oyfyOAXXCNWRZ0gc
         wJ1dcmwd3CcvMccigQuAHC+4Mw8erDQ8GuEB4X1xmw/jEBkos4jS+fgLMt9YECCiyOru
         2bEfDvKdBTrynfp6zHGTnQUbU45WhPI2QHhtZ5EfLkhfTt3zg8LR0CgdKongMJwwSDHF
         sPN+AWpRDjIP1lvCOiXIr7Rpt6CLGGMTp2faVz3dQM+XdKT5onJZZTPWag0SnLz8hjGZ
         pf0Q==
X-Gm-Message-State: AOJu0YyMII8qdjhrWiCN4T5s+Sulvm7w37JhUT2UBbV/KsfqwZaShqrN
	lpRzbyoue0QORyk+VsN4B1CBUjR61jnZEEg6UrmgnzK935kSghn7
X-Google-Smtp-Source: AGHT+IEXpLPaMTyAVhb4VHkjhzRgcyaB2xH3mfWfn94BF+1TLb9Cj8iZhNm+mNqolmDyKmzfO+X1cQ==
X-Received: by 2002:a05:6808:14cc:b0:3c0:3d8d:7f6e with SMTP id f12-20020a05680814cc00b003c03d8d7f6emr2121825oiw.5.1707890054945;
        Tue, 13 Feb 2024 21:54:14 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUXCJgN2Hv+RvIZ8J9zjiv1ouPV57Mq/XEHjqEtPRtzonHUmNWPnLswOIY5Yby9VMgdh5zkANwP1nTjKBFLXSHvnJdd/+sDKfKDMil9l+LJMH4JN+ZrkgAuGh41J8+O5A4uT5Y1ALEHKpaVDMAC60GQJ9SxaMV9hwTGQFHDlUkOQDL4luB/8ZPUVdanLt6Qam97PDPGx+aJHtC32oDLDgyWZ7iM0etjbHfgo9xFUxg/WV17aOVW3HiihJFrnBHaBG03ISAskXyi6FPOog3ACzVrVXAGnlgfG/2cmyOpnR9R23AM5DLpoWIu5bJVqVhJjDkIxl318GQ45h+qDF03P6Qv8PT/YNqTviWygE5YXr4AFKbbLf+D+TGXG+7IdsTMN8pXX3NIMKVIBr31oBQ+XrmmHdEhM2Tc4RwS0V4qrSBZeqJYMpvmC7VG1kmOfw3U3c0aClyi6kktwS/aHuh2JDMIG9qKa8IsGLluynFuRCoSTBKGlHnRuaiwtbarixra6GkQGRnjLwTFsO1zdDqIgQfMeYqc0lP51PYeWaTDhg==
Received: from archie.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id fa12-20020a056a002d0c00b006e0f6e6c014sm2529593pfb.84.2024.02.13.21.54.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Feb 2024 21:54:14 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 31FD1184690A9; Wed, 14 Feb 2024 12:54:08 +0700 (WIB)
Date: Wed, 14 Feb 2024 12:54:07 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/121] 6.6.17-rc1 review
Message-ID: <ZcxVf2ysc1A0nRlu@archie.me>
References: <20240213171852.948844634@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="0gDu7LBv92JGmNAy"
Content-Disposition: inline
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>


--0gDu7LBv92JGmNAy
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 13, 2024 at 06:20:09PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.17 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed the kernel on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--0gDu7LBv92JGmNAy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZcxVewAKCRD2uYlJVVFO
o2ZuAQCcBrSXuoc6mNTOwuhFUBhCaiPzAKZLcjTU8b8yb3peRwEA9JZq/o05Fq9Q
xpdcN0T/vsW9YJaSMqVp4WXASgKawA8=
=vYtO
-----END PGP SIGNATURE-----

--0gDu7LBv92JGmNAy--
