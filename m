Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722B2135A7D
	for <patches@lists.linux.dev>; Thu, 13 Jun 2024 20:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718309707; cv=none; b=tZvBbPKBWH+4ZbCWaIEKID55mAJj5Kh7O7PA1Akf3yGizSmMxWCyQY/yziNvkDeeaXZYaBCdad82ffWYLM+zHCR3Hle3Hjryl+emDX53/eEisifnxp6QIaaGBeKwYqr9RaD98Cv5aYpA1an0ZV0FIQkR+PCacFpEBINK6MO8dis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718309707; c=relaxed/simple;
	bh=dlGLscArDzy44oP2aurmhtbN5pHQToD2F91xsEh7q5I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=idWY5epWEwXNZgUiHRcnRfpUk2hlLRXRCpwBzEPQvb0kEb/12hTUPVkaQNt7UFAr+b7JfhozmOQHBWX9SQHcxTAgB9zvQg2Hw2tnBRfCwi3LzVUinJvhf06STauA4GI1rdBb0uw1rNM0bhYaibKrMkiGaTFYOJ4mYHJc+SQT178=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=w8CUrlk1; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="w8CUrlk1"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-57c83100bd6so1746100a12.3
        for <patches@lists.linux.dev>; Thu, 13 Jun 2024 13:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1718309703; x=1718914503; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hDhVeCL8wLH4kUjFDvyKZ8mFuEbjs6JnITirIhpJobs=;
        b=w8CUrlk1FtVdh7mZg+qxZEj7sYqvCLYjPXSCFKaiSbnj43XddljRUDQgsLkytlXmPP
         YRZBjGzmAxJ4/T57uhmeJs5sGRtGUYeVm6e0RZFq0JnP0jVx+CPy/e/FeoSJxlvQIzsD
         8Vj343VKnY0MHV4pRo92CDC8vsM7WtpuZd6qQagD/JERAATl2zQXqLFV2ZEn/Zfqs1PR
         JH0rrdLc8L0DqaGMUWhAjgMXxm00IKRBzk/xm6MbxSWHm9g/gx/g5O0MxWH/CVEDPRKm
         bJ5oO+u5AEjosg4pQpVFvTM0rqVy3vhC5PCn1jcgVmaBqP2qkRoPgC1ijIrKdOHJ0YZ3
         Y6fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718309703; x=1718914503;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hDhVeCL8wLH4kUjFDvyKZ8mFuEbjs6JnITirIhpJobs=;
        b=rGO9CLC/cpA/wUaxJTnZIFx88G6rWDFXuM1GkpMS9+npxi5Re5o0FdrHSBa6z4cP8Q
         RpL8U3jDifQgFcjefY2G/xwOM1TkmPNiv6BkI8jOKtdqwZwcB+UY1GVZMiTB1/+UmXls
         XFQVQWCAK3ETIhKhftByAIQ0w9dpxzBv1QqLX6AXmZMV1MbMqivykTRWHWCEtyE+1T7y
         K0R8QO7qAxYReDhnO5Oc9uf6psb35ADBY3ods+mcWVaPMkkbxGAah5VGtsXJropwz8FT
         c7yCF+vEBDgFaUhvJm6vbMlMbKoL+5jU6aYqa/j9E7qLulLHoqLkgN4rKQ5lpB5d9KUK
         SSLQ==
X-Forwarded-Encrypted: i=1; AJvYcCU0SfNuuqyqL2+o/5HLMF8ZW3bB6QDPYD6ganF0lQBGbNXqemjxXFq3XvG9Fkfc+Wdbeite3Guc8q9SsvqP2aQZhFB0HbAPFA==
X-Gm-Message-State: AOJu0YyggTUpAPqF0hM42DjGc3k4DqIGDVYVrJTYLgQkRbbZx8cePm8A
	JXKN0nEREiaHuprRlJrkn3wtykXE36U6UsFqjKfVfTLpKH+8VjLB1ZpYKdimkgY=
X-Google-Smtp-Source: AGHT+IE+Ca5W8n6Y3E0EYOqcEFRbIILXOlXEMM91s0YkQkAIFAu+a2XFGplvac6dVETmyv+Gd43IIg==
X-Received: by 2002:a17:907:7f26:b0:a6f:49f0:437a with SMTP id a640c23a62f3a-a6f60cef2b5mr74557166b.5.1718309702650;
        Thu, 13 Jun 2024 13:15:02 -0700 (PDT)
Received: from localhost ([2a02:8071:b783:6940:78cd:4cb6:e3af:4473])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f56f427b0sm105375566b.156.2024.06.13.13.15.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jun 2024 13:15:02 -0700 (PDT)
Date: Thu, 13 Jun 2024 22:14:59 +0200
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Sebastian Reichel <sebastian.reichel@collabora.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 026/213] HSI: omap_ssi_core: Convert to platform
 remove callback returning void
Message-ID: <4yzk2jhrqq2ga5pirjlip56ezhnrdfyn6tpq2i3lhvlp3lahi7@zk4ohcap2lg6>
References: <20240613113227.969123070@linuxfoundation.org>
 <20240613113229.004890558@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="5xdyfwqwofn5vjbg"
Content-Disposition: inline
In-Reply-To: <20240613113229.004890558@linuxfoundation.org>


--5xdyfwqwofn5vjbg
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 13, 2024 at 01:31:14PM +0200, Greg Kroah-Hartman wrote:
> 4.19-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
>=20
> [ Upstream commit 94eabddc24b3ec2d9e0ff77e17722a2afb092155 ]
>=20
> The .remove() callback for a platform driver returns an int which makes
> many driver authors wrongly assume it's possible to do error handling by
> returning an error code. However the value returned is ignored (apart
> from emitting a warning) and this typically results in resource leaks.
>=20
> To improve here there is a quest to make the remove callback return
> void. In the first step of this quest all drivers are converted to
> .remove_new(), which already returns void. Eventually after all drivers
> are converted, .remove_new() will be renamed to .remove().
>=20
> Trivially convert this driver from always returning zero in the remove
> callback to the void returning variant.
>=20
> Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
> Link: https://lore.kernel.org/r/bc6b1caafa977346b33c1040d0f8e616bc0457bf.=
1712756364.git.u.kleine-koenig@pengutronix.de
> Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

It's unclear to me why this patch is included. It doesn't seem to be a
dependency for a later patch?! Also .remove_new() only exists since v6.3-rc=
1~106^2~108
and I'm not aware this was backported, too. So this probably results in
a build failure. Ditto for patch 27.

Best regards
Uwe

--5xdyfwqwofn5vjbg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmZrUz8ACgkQj4D7WH0S
/k7ZPwgAjF9cgU8o0hT3ffzbMTjoCvTN+OIoZEoGY0QCxScExt+4p9gOPpre0Z1/
MBWnVH5OSoxeQigG7OwrbGYzc0oz9I8WYvBV09ePrmfUwgdCl8z8yjAzKFaIwmqL
twAfAfqgORk068mMJw051CgrL4oUpPu/1aqET+WCItZGvlWu8orA4diASgavHBGU
ngDcZ6xTf2xvUN+19z3Joalw6X20POD5MM+M5YqtroHRIDOQ6fhO4XH2Jv4jcxL8
rgm8S/wfTIdpFpjqLbH0Q2fWeFbtD4J8qO9TMjv7QmAoSNIV8OJ9lT3A3MQFmlJj
Lcls3CjizmV8ztgMSzsCFT9xM896kw==
=fIDv
-----END PGP SIGNATURE-----

--5xdyfwqwofn5vjbg--
