Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0EE1171A
	for <patches@lists.linux.dev>; Fri, 17 May 2024 05:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715925412; cv=none; b=EioiR8osxO0gJzeJ2Cjkhwf1V6BMNAe87PLkT4DcPBPmEKM4Kea/envxKwOaJmU4rmbb4gBg39uCLhgnu0d88bhK5vor/CzrVJuW+Ypac8e35jzSc8IcfQO19C7WhzN1wsAF99FfLnzRJ2UycqJUbcMdaYUeDFLSRnCjENYUq1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715925412; c=relaxed/simple;
	bh=YmSGsQFqP2sM/tghthyHZt/WfhYPDSOmoFnURY8upkE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pOBb+LdY43jjRwZxq1eAy/NKOxvCSxkyliWB88FVHzo5ukgp/64i5TWl6Sou0UmUzwD3LWH34ploMntF6dVhccO3fBApRk1bgm2G1s2xCiAi1e/+zdPWrmrBNlIK32TsUEdzpVJStqR5CNzRcJY76ffrhlLWEbkOXp84inswDR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k5ne4hLe; arc=none smtp.client-ip=209.85.160.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k5ne4hLe"
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-23f9c2f1df6so948fac.2
        for <patches@lists.linux.dev>; Thu, 16 May 2024 22:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715925410; x=1716530210; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=esvpS+HJVmGYN9zlMcpOZlojnY2YKhtm2CtrJvMWw1A=;
        b=k5ne4hLewhtcqGTk/+pkaMaUFZZL9s7TLMv8Jz63URMpD3jf6eBPH1Z6VK3MQmsoAS
         +AGzGZB0f44Au65+4BQ9zLbh8pqqI822w5jFfTXfTRsa857AItsWIIjwwxN10fMxQXRo
         iRjIAVupMjz4wwDmflbuwZ+1r19LfyZLgIAEGnDU1emcz6l3txmq8p98iQ39ISzN3ZfN
         Oh7iSJNK7g9CGXcH9ZVTY8BD79mTUS3mZph/fj0skVffuG97jH572QsQN+T2bQcJu99S
         Xg5cVT+7o9UC7Rp7Tg92/XEXlTzWQjhITwMnneeLqXwMMzp7ZtPvfOm0mO/Gpyohw7bJ
         7eEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715925410; x=1716530210;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=esvpS+HJVmGYN9zlMcpOZlojnY2YKhtm2CtrJvMWw1A=;
        b=tEn3ZLDHpsr90ihbDpGgGWV4Wv6vZXY2i0rUb+zD+xwg/Wg2H/ZCZSSZKy6y2GVsZF
         g2tXoYzW5+xd0wJQc9StNu7zsJgjDPgRfK6bTies8IBpVB9nlbxZPlv30Ywvlu0paeRr
         5lJ7KOTVyQZ+Bfmrf4tPO1cz6mudZBzw3NjlOlOoU+rnsavP2WAfLH/LwPxV+c2RlfwT
         XSMRDyTSgmNBgHoGHRxXPJXgcSGd7ksoaAWbARzMmRlGAAJBuP7OTTfr9E2FplKtZxTG
         WXRqUoXaomhTxjDVLe1j19cIVZIlwktA3VW0oDn6+XOuLK35R5uS5r1TdvY5wk370PG/
         MYAQ==
X-Gm-Message-State: AOJu0YxEuyhr9U+w3tnjUwupfEJUTLyPMvYYsB8G9r9DPi1vfu2TYPqd
	tRiYnEY2MJAe4NJJ2vk0URT6iMgHSXww0cpsqTDYIFT1pZmQJKvW
X-Google-Smtp-Source: AGHT+IFlbXgIANme5udm932an91YyNDPFM783y6kvOlmYR2NH/ClaYk8g/x1Re/kZa/8KVe23/AyEA==
X-Received: by 2002:a05:6870:d69c:b0:23b:f2d0:7b9c with SMTP id 586e51a60fabf-24172bdf92fmr23759567fac.24.1715925409923;
        Thu, 16 May 2024 22:56:49 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f4d2a66428sm14021515b3a.27.2024.05.16.22.56.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 May 2024 22:56:49 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 40BED186F78EA; Fri, 17 May 2024 12:56:47 +0700 (WIB)
Date: Fri, 17 May 2024 12:56:47 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.8 000/339] 6.8.10-rc3 review
Message-ID: <ZkbxnwyfeIiIwLPc@archie.me>
References: <20240516121349.430565475@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="X7EahXYUI8wOp0ZB"
Content-Disposition: inline
In-Reply-To: <20240516121349.430565475@linuxfoundation.org>


--X7EahXYUI8wOp0ZB
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 16, 2024 at 02:14:57PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.8.10 release.
> There are 339 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed the kernel on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--X7EahXYUI8wOp0ZB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZkbxmgAKCRD2uYlJVVFO
o/VcAQDd3hve2Ri08VYkrZpn/ZcRSgAxL1uotH5DpftZbVurZAD/UB5eW+D/E9Dd
ouHI00/F+H+zVxE0pf2w6eyCg6SPzAw=
=9d5O
-----END PGP SIGNATURE-----

--X7EahXYUI8wOp0ZB--
