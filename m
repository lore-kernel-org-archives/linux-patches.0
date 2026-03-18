Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9D023D2A3
	for <patches@lists.linux.dev>; Wed, 18 Mar 2026 19:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773861727; cv=none; b=QUPE38cIO/I8m0nq3wBA9rcmWc1+PtHNsOfLQNokwn1E12lZaJDmC2ARShhSAiS6UJmQ9/x6kYJPVa9pJSe5KkCMzayT8uVyIJcU359LGBp5/0yyNHd/4XWv48tAowW2h0QImQNb/8CPMSycRxc9FrK+0UPE0+h9KRpOs2tKOWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773861727; c=relaxed/simple;
	bh=w0L88E4JONxcknqxNeYj/mU96kVaZt44YfM3bCuyj1E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q/kJNWT3552vbXNzJVB8bsyAZPdam0nKcBlyjoaEOT7cc+CP0izSP6ko/AVr6LLZ9GRa4aoxgJJAIZ6iQiPrMBIm151qMRw+WA7yzdTMS2ZGhp9cgNmkIbNnUbqxp6tHX0bH0JwdK88YcsGMNKQs24C8PBgb+dvw3InnSt17FMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=O27UYy56; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="O27UYy56"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 9709610E8FA;
	Wed, 18 Mar 2026 20:21:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1773861715;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=Oy3QBhS4EWryri83ZPBqhGram0OqPJmtGvZJCIL6wVY=;
	b=O27UYy56BY+5Qv80IzGKlgoKNlCx8zj4Reh84DXxmEmO/fl54YBx9wrtQiOaj8naOc+dC6
	My8Jx1GDAljZ5utpIxKkkoyF5Nc4XAeAqpPd87GswU4vSXKANMk86iEjd4Hy3GQ9DegQ9t
	vtZ4K1WwIz9U6rFHLAbEYJTOuQbZNcDoqPZycYgoAD8j/52CkUhOkYaTG0TcUGS7V0CPil
	/q2h7xUJo5S7Bpcn4fyfmFZBlbI5Cwtrb16TwsB63JvazXI11LEq/75xvk0o0OtkWODEXz
	9AzNHlaDlCOdQFNwDL7TnQe6TWSrOiB4SNvcR1s/7GGwEwJ6GHqP0XrECxGkCA==
Date: Wed, 18 Mar 2026 20:21:51 +0100
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
Subject: Re: [PATCH 6.18 000/335] 6.18.19-rc2 review
Message-ID: <abr7T+v9PDUSo9WD@duo.ucw.cz>
References: <20260318122621.714862892@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1G/feHWU7Fzh5M8s"
Content-Disposition: inline
In-Reply-To: <20260318122621.714862892@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--1G/feHWU7Fzh5M8s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.18.19 release.
> There are 335 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.18.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--1G/feHWU7Fzh5M8s
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCabr7TwAKCRAw5/Bqldv6
8sq8AJ9hg+DKITs+FFN3HtcFDOLoJRhcIgCgvSeHmgWRp1i3Vtu4Jcr7A6Ax52I=
=8bj/
-----END PGP SIGNATURE-----

--1G/feHWU7Fzh5M8s--
