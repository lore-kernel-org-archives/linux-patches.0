Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B1379CC
	for <patches@lists.linux.dev>; Sun,  4 Feb 2024 07:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707030527; cv=none; b=h5ykWyy0rU1oRgfweZSpJwq7yJZDVx90PcdYtHjdkX661pxREVt4qQTRZC5tO90N4+Y+9npGXq7xSyN6TfUv6KDSHHuHliMf6tWWd4nD3YMHRWV/3ZwX2D3yWWqxGynuWkYCChBQ4pmebMa6FdX0tA2cnvm4+Chct0TSIYiLZVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707030527; c=relaxed/simple;
	bh=wnPn5IFg9U8NeVsjj8NdA2AxDIAY5IVMf3k6An83i7c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EiSgYPY7c8I3HdWK2z4CekUlcSymCOygvje8yL/Alckvi86rR6iufMOZ4Gq2yai6prYgT0PfXwOEj012Yf4Evp0AtRTDwgcAKuOoozcaRWPpAFUzx4/adSaBiUNKaMe8pRLZLWk6ZAaOgPop6xfulX4ngveipFU1Q+jHynA1CPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XFDtrqN4; arc=none smtp.client-ip=209.85.160.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XFDtrqN4"
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-204f50f305cso2289260fac.3
        for <patches@lists.linux.dev>; Sat, 03 Feb 2024 23:08:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707030524; x=1707635324; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uvew8PMPYA9Q3wdj7yebEAHOaHLru0TRVp231IrBd0E=;
        b=XFDtrqN4HHRMFbYVt5tMj/QjW4WflsXeVkCnTzxW47Iy8mhUrFJAORfhivbe+kBku8
         gYFORNMkdgcDdNC+yHPe1iyg4h18copDUxQiAKba4ptVR85Osg1jtCYCihZIll/4D+6+
         T4ulg+8E5DSK8o4SeyZ15gm1p62pVHqUEWo6ingKdjdpRVq+SxZLgCxMl65AJqmT6lyo
         8RKD0gpHJSKrflgYxEm/JYhf1SK3SmCacDkWHQcNKApUmemp4OvM1th2Dan9VF1sdZTI
         WikplJmP+taQWO4X2Yx8f8hzDE59RTwtbX5U9BziBH+fxMcchRHBFTfmFRyNbfixOyW4
         mhBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707030524; x=1707635324;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uvew8PMPYA9Q3wdj7yebEAHOaHLru0TRVp231IrBd0E=;
        b=Thdi7abf2yzSmR3DW6Jc/eQyeLoZf/3mvdioVlJF/RULwkKPCXyrhq6hjn1KWyK3El
         2+xgY6iXvxjZXVoFAvFrTpQKEQMJIzBhYH6yTs73LaQKQ0Da9YjxXIbl3VGhIMEDuqct
         q8o2/nLO93v+o96hWRWDuEonWFvq0iw7HIO8d6CUxwi0tN0Go3KvZ+vq7lHpxuxN07lU
         7M7vdgb2yYk9WyO6H/NRVlvQA22QTWMR4YY7PzJ63gO1gJ2/TOCaf5g2igG6FlWO7DCI
         l4fUbkxMVBa1Alj8bQI5hdT4EAvgUufqx63H8hEgLXcGtXxfq1K6Xi2ojeIa5spCU0gt
         Mf0A==
X-Gm-Message-State: AOJu0YxI1oXZaLfIgJgeGuxYI5wjcB4Zw+hyapVtE61C3VB1xCF+IrvW
	sT9C3AvWtJ2xEaltgUPlpllbVxmQUyuQ7I6hUIo/TEnNQLYF8bOL
X-Google-Smtp-Source: AGHT+IGDwtCcLC+/4nlT6FTgbTeUCOWgrdhp59ZhU5Axv+Ge9mCLnMx+NTQMxftIWZdccw0t339f8w==
X-Received: by 2002:a05:6871:29d:b0:219:6da5:1a0d with SMTP id i29-20020a056871029d00b002196da51a0dmr1429906oae.17.1707030524553;
        Sat, 03 Feb 2024 23:08:44 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCVjfASpty6QrXbYS1PLpsLg8IcanID2ZNkktfgpY7VaDWiFZR3YQZ8Cl2wRUB5Sz7uyIBk7Ucohg/1djOMOmKosi2SWRIurECgfCSQVOsQuvb1a904AXcX9tIIE5tteUBWBC+mGbFE4s177MuOhTQX7Nrm3uRk+famVKrtadVBczOnx0beb9Q9KkAAcal8c/GXEOUL/ZlDJD2l37id3T1Nu/3V5ZazpEmLtCa02FpgZTwUJT0KCld96Su2W67sy1Ug84KAqrtHF0x052TJzrwIOi47MoQlXensCmC4yCiIeRggJmOb06tbfAsE4ymlbZOI9oFzMxFM+qgbtG4M4FQ3CcisP4yT/pcQDtlCfxUdjQOtSvkTP9zBldgWPPBASzOLqLW81CfbWccIBagPBwfPkKBbnlWkfrs+AumL4pf0VAKEq/q6XondUEchu02trferV3gWvmLjCo5UUXbpVsnbdClYC7fH8JUyJYgRMPy9e7bmiWxdG0XLRkBP8bNMywRYPLYKdzk2QdTa1n/4zwEtsA/SqpWbVzixK5/pd9Q==
Received: from archie.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id c20-20020a63d514000000b005c621e0de25sm4721706pgg.71.2024.02.03.23.08.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Feb 2024 23:08:44 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id B5F791846855A; Sun,  4 Feb 2024 14:08:40 +0700 (WIB)
Date: Sun, 4 Feb 2024 14:08:40 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 6.7 000/355] 6.7.4-rc2 review
Message-ID: <Zb83-N9mWfLoJw9R@archie.me>
References: <20240203174813.681845076@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="NIBRUINgcsPF0enG"
Content-Disposition: inline
In-Reply-To: <20240203174813.681845076@linuxfoundation.org>


--NIBRUINgcsPF0enG
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 03, 2024 at 09:53:10AM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.7.4 release.
> There are 355 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed the kernel on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--NIBRUINgcsPF0enG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZb839AAKCRD2uYlJVVFO
ozLDAP4prnytQeD6WZCB5SrSf6etlyHTRTuDct+B9tTjt7jxoAEA0P8xLxbiliSh
1Kvwrt9CkqbteTq5QSaezFJi1je1eQo=
=qs7v
-----END PGP SIGNATURE-----

--NIBRUINgcsPF0enG--
