Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BD5226520;
	Tue,  8 Apr 2025 15:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744124868; cv=none; b=nEH+Ul6xkDlV/55kKK2WjVzrplEy/9EmjEkZV8QYixFW6YheKHE76qhqzvoRMFjKm25AgFbmMntd4gdZM+qRzUP5D/OHG8U5gSdMlQTE5I1yQYW/vEPa27yGQSnHu6z54fgjSChIYL1Jwur4WcUm73n8L5I+tgZDDTLAw2SjkWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744124868; c=relaxed/simple;
	bh=g//YqZbYnCgzqQlrcfZDtmZtXvFE9W0xNASxWfyoETU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=naiSFncUcB7r5iXHjawtyGyYO9JIrAFt7Ksa7+iLXFeXW1/Zq0xyLqZ4SRZ7mbcyUEmf2eptoda5654Evdoy7XNKRkWocUfN7ZiUwgEyjWeZRbNYqYoXwGNXpzwBPkpcReyTQEMPEvkwdPaZoBOnYfRtr+5I6Uuqpj/GzTMLAWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IbVMb7AF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IbVMb7AF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E919FC4CEEA;
	Tue,  8 Apr 2025 15:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744124868;
	bh=g//YqZbYnCgzqQlrcfZDtmZtXvFE9W0xNASxWfyoETU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IbVMb7AFmGJAYkPnCxwA4vipMYR2YmkWD6fAD9cjgW224aE/8B/b0imNqENFhHVqW
	 /FvuEiP/X4fbu4dquOq7I9TXKl3UyZni3FT/ifYtgnqYaKPvh6/8kD4H1G13/SZt8X
	 CO/uW7tCXDnjXhA7nND/ad/FXNY4QqzrMl9opoSAgP3PtpeXGKCmG3kHYopCaei9pt
	 YIZpe9K6xSZ9YI+JSt0lgl403F9ZzHgi5YVplRkEBMKQzlTRJUPcinHF4LLrMsri0o
	 cZehT5RCQqxfLRcka30b3oJLpWC+UnGNsHECh12aeaWOlP7Re3qUJtu1jFW2W7c8PZ
	 6FFXpzl4Oj4Ng==
Date: Tue, 8 Apr 2025 16:07:42 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.1 000/204] 6.1.134-rc1 review
Message-ID: <370ac960-a843-4511-9c15-a8a584ddb08d@sirena.org.uk>
References: <20250408104820.266892317@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="tkPt/6AyH9xfzHxB"
Content-Disposition: inline
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
X-Cookie: Meester, do you vant to buy a duck?


--tkPt/6AyH9xfzHxB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 08, 2025 at 12:48:50PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.134 release.
> There are 204 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--tkPt/6AyH9xfzHxB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmf1O70ACgkQJNaLcl1U
h9CnYwf+LxAoX8Jp6byNvI3mCG8yz9vQpIVxzYo558OK7RdsjAiJHcAW32sBwFnI
GTBTX5nYChf4PWt7jxCWZBUbSHJj1mfF0fec1xQuP012m4fPBTF0C20p1lmaMt9G
QI0nv+3ihgbAFdXJGmoaO03ZoiUz2lSjjt0bdg8KXOn3E9r00LEm2+QtCUxE+L/9
Re0m0NWymoJCVkDpPSovDw0hNdG5OGLKhiCqd2tl8ve18AF1qpDRhn9ZNm0awQWr
rR05dol4dA9jStELW/4HKMZDr4zsQtQFkDx8mRjMY81p0xfWqVebfqSdl28NkAnl
ehvrpPQbxOfSY/xRDMs/z7ExqYg4vw==
=imSG
-----END PGP SIGNATURE-----

--tkPt/6AyH9xfzHxB--
