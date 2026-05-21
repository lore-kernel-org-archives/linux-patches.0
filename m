Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48BA237F73B
	for <patches@lists.linux.dev>; Thu, 21 May 2026 09:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779357297; cv=none; b=T2zEymx86x2LJpKNZhyrZgL2h3mstkFTjJbfy3s4QHVfjX51DZLBl4TgIYvz4RPmUfmpdHKXD64qw0NIE3mkuV4XN+qjeZrKLwc5eoR4iq2krJsIZpnawMa0PexLRaywVs+ST2PUlkTl4tGeR+tv6eU46s1meEoErqS7TPxcp/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779357297; c=relaxed/simple;
	bh=l7vg7eXVvo5CF0JKVThjB0mYv+mjgrg0dQggAWeHBK0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g+9Y0XWaKvO8nEKyvS23hEhs/araGR8xa80Jo2QYELVO5i6DQ3K3fl2TmpoMyVggUUj6vA+bpJCW+ebpqB5cdrYgIkVIjq7VyDkG1zubM+FiAOzpzVF+nOyk8tqmnUjogfxklwOc6xSDUeolTGR78SnZ9cb+jcQcBafzRI/lJRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=IgQ0CaG+; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="IgQ0CaG+"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 4F618106308;
	Thu, 21 May 2026 11:54:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1779357293;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=B+jvR8eAuAcXKGwTDo1snDvVAhHRBFEwaPSo3mc3g0Q=;
	b=IgQ0CaG+5bspyCoYo1aCR+ta1vNafhM2QuHpO3k6jK6byQD42VIeaE9v/wo2XHXRiAngh+
	xxfA+yKUF8PWiiT6OXGraQoOFMZI+mWe29g/+iA7DKGPT4bFXW8/4ApA24Zsh5KUlO2KAL
	JjDsOWZ+4zSbC6rbDFtIDiwbhUogTdvukEi8302pSB9WPaiWQSKIGsK8eifxhnv+TDTqHd
	AMSzr8TrA+mOkke8/RCnFR1GmivTAAnQOtAmBKG+Uht56zHP4ESg7rmlBBKjm6jfF6DNTZ
	PQW4txkImHxTQ078IXx24RsEEtwlbSDut94SjbDapQVEzUo0FMsbxZWv1MBxlA==
Date: Thu, 21 May 2026 11:54:49 +0200
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
Subject: Re: [PATCH 6.6 000/508] 6.6.141-rc1 review
Message-ID: <ag7WaeE0bn8-cfGA@duo.ucw.cz>
References: <20260520162058.573354582@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vegUkJZ83LiakJ3b"
Content-Disposition: inline
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--vegUkJZ83LiakJ3b
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.6.141 release.
> There are 508 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.6.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--vegUkJZ83LiakJ3b
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCag7WaQAKCRAw5/Bqldv6
8u/AAJwNrpfTaDb8RSbA1z8RWHbypG9/tQCfbkOXgCuBAGdm1kRM9SO4l5lv470=
=a6LS
-----END PGP SIGNATURE-----

--vegUkJZ83LiakJ3b--
