Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D462A3F44D5
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 20:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784751093; cv=none; b=st+j07hW6IeKszgBUa6gZ+UJUnRubXBf+neKKtjfSPhb3VxaKnWbAFrC2ALWqqe8TdU+fjjvSLUVmPXGc8rgg6CezhQ5ZF3YoXMFwOUnqY6/RRIbgvUfyVzpdW0P04y6eYXvXt22uw3CwyPPj7Dm0Ft7t1wKCn+pq7K9PeFKG5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784751093; c=relaxed/simple;
	bh=yo74KNEKdhVGElGDxjg4GySu46CVcEhNgpKopQ9XKFs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m2zyo1L5p2YN7r2EK5qiO1tMF5MVIumM8M56gyW1xk8ZUow7yb9mwZhfghjxHc3kDUj2ZFvDcVXg7CVIazvx7TKgS3d0N2tXqoyiDm9BK2njrbi3pnHph/6+odOcTPdNt7ceG/wN9+Qp1yOymydqXGS30zty7pEb0p2akgGckQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=D1F3YTKl; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="D1F3YTKl"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 02C9211AAC1;
	Wed, 22 Jul 2026 22:11:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1784751088;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=Yf1ePF873V7hLjVXDqPPC178FAwSIUesfMnfbJGgjT8=;
	b=D1F3YTKlTYaY0/ulyoGqfEd1Lh3/T0XybSdtTrC1dtA3dDwA0fFVJLY3HztNymLT5len6j
	cxUJi4Ege71dQHCRIvQ0qYcOpyWPNxovEoubs2YkIFrG/jt9lslPN0wCuh0cMxmzI3Nf5X
	iyBcK6tE7mauunEiqWpbAl2dQPeBmvlxR507f0H1JQagQEIlgwc8GANJm3y432ApBbRQhS
	5senop/VLXqJ+EzqrEpRtwX9ieVwjeKBEdfyu4kXcb0fFXOQC+4oT6KA3ZKdzauTjSOTbM
	swkAviyk1KJhtMqmxDFnqTFJJZ0A7ExKEZYUUuLwG4nX7R2uxwor1Q/NVWWlLQ==
Date: Wed, 22 Jul 2026 22:11:24 +0200
From: Pavel Machek <pavel@nabladev.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.6 0000/1226] 6.6.145-rc2 review
Message-ID: <amEj7PTgFWWOIFtK@duo.ucw.cz>
References: <20260722143258.264584003@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CoQ0KfiOvZqwVWlJ"
Content-Disposition: inline
In-Reply-To: <20260722143258.264584003@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--CoQ0KfiOvZqwVWlJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.6.145 release.
> There are 1226 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.6.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--CoQ0KfiOvZqwVWlJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCamEj7AAKCRAw5/Bqldv6
8isEAJ945RSLqolUlhsWXY6ShI9YrPABxQCeIvWPAyFb0NRBGLLO3YiYkq9idRk=
=Jz7X
-----END PGP SIGNATURE-----

--CoQ0KfiOvZqwVWlJ--
