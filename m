Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F3F4431
	for <patches@lists.linux.dev>; Fri, 12 Apr 2024 01:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712885561; cv=none; b=h/NtWMu0KW6acztbeUA006R8bAP7Pnq0aI9KAOmKZxzZG4lLznn+dfFUD0DQmS3p5iuuYneapYWGjbZSj5dO3ifyHaV0sQgH0xwfzplFIIfRAqOS/s3PnysjRp5MsXWA2FG+VUqnliWqJW9mN1ymhD2a3UxrpkX9BRtTdXdW46w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712885561; c=relaxed/simple;
	bh=PU27nh4ICcMKtfoWAY2oTKn4uNtsFsaFulZ55C62uGg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OsJWrLU4VtFf4Yd0z8LyQoqDVPWo+lUyaM+3aMM0kcaAIrE0Rh6H2x/QXq+Cb/Qzpq/KJsuwXPDmatSuQuY+l4BnB+U35S335BATvXAJpPNZnIdNQWGpOtygeGJW4fGMEoF20NJzvmox9k73TRq7PMH2juPzoWreUmrqwIkfh+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BUvr8Vwn; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BUvr8Vwn"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6e782e955adso466978b3a.3
        for <patches@lists.linux.dev>; Thu, 11 Apr 2024 18:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712885560; x=1713490360; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dU3sSS4eDu0gFlOQ+EtChbXI75mbMnya9v5nETYuAbM=;
        b=BUvr8VwnQgtRRywIxeUVKZU29MzRmALmf0g6eYu/BK2qDnuqPv5G4saJq0pvGFV7Rp
         BMM24BdSAaC8k8rPY46z+1iw9G+W8rT5FhxaChxcNgxcU4IHW4Rz1bLfZlUoOV6k7XBb
         ZxluOqBWLK18g+/5SHYqaarVp+4uCheyC5+aaTDlosBp+ZZcb5rRGgq1tQfTr4hfZqBw
         /QwDvp82zIh+Lo+Lmn2mEf+j/mC2cz256myGULFXuFeq2RAMOrxD8sAaxJebthCsMwKF
         0ULUIKLIWFTeedxM+SIoJFhEO8wNqEJBnLVkUAI9+UIYC8uzYi1yrnE1NWn4qwYA2G4J
         2gNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712885560; x=1713490360;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dU3sSS4eDu0gFlOQ+EtChbXI75mbMnya9v5nETYuAbM=;
        b=tntcmyOonQsUFG1q84pj01OmVEIrSqcitQjjXV9Hme8epJM9ChNDkKzS/qJIQKCnK3
         9J9eZr3NNj6tx8CqTbz81qHiF+JIPMiIfeXsZkwwND77fCNOtdN48YdKAd8B1U/7WuB4
         WFMhO+1z68uU9Nc/gzx62y4nswlSqWx1c+aos9z31H8JpXUYxG9sa9vF3gezen6x+bJp
         n1+7Ozsv1QeOI6qHCfTzdOp3d8THzUoZ+huP4YHyHvq8J3Gtl8Ci342kfymwAWfGEnoY
         zLUz7mPmjj/853+TasoX3vl/Jghbku6D8rG+Zy2T2fEMyw8CELLKCd7U2On2N/3aGzf8
         tecw==
X-Gm-Message-State: AOJu0YwwYJY+7aLh5zkY/DE4hhu5r+qYs3FquEjqNqLxqxh+yhlq19h5
	tqVh7kvpk90hWhMn73kuH2OO2T/X7z7Jefh5xkuMrJXOz/Y9LnHF
X-Google-Smtp-Source: AGHT+IEfQBpInoWg7ls3MpIafYuMBgkN2A6xBoM+hy3ZDJ1AN48nI79H4kzzTR2Jkb2hBKd8AtqDsA==
X-Received: by 2002:a05:6a20:9496:b0:1a3:bfce:ec9e with SMTP id hs22-20020a056a20949600b001a3bfceec9emr1557696pzb.18.1712885559704;
        Thu, 11 Apr 2024 18:32:39 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id i89-20020a17090a3de200b002a005778f51sm1920924pjc.50.2024.04.11.18.32.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Apr 2024 18:32:39 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 14281186BBCA4; Fri, 12 Apr 2024 08:32:35 +0700 (WIB)
Date: Fri, 12 Apr 2024 08:32:35 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.8 000/143] 6.8.6-rc1 review
Message-ID: <ZhiPMz1V4TwH_wKb@archie.me>
References: <20240411095420.903937140@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="KD2kvVoGn2JSdYIW"
Content-Disposition: inline
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>


--KD2kvVoGn2JSdYIW
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 11, 2024 at 11:54:28AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.8.6 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed the kernel on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--KD2kvVoGn2JSdYIW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZhiPLwAKCRD2uYlJVVFO
o+FUAQCBcW+tpaOSaAinvPSnFZyQ1A+fI7JgTPvpQRLT6x0bTwD/VBb1rpYSBLEK
0FgrnPcLWyxBzYmF/u+FgiSn5adh9wc=
=MQEi
-----END PGP SIGNATURE-----

--KD2kvVoGn2JSdYIW--
