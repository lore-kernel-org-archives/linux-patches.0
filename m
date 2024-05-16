Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F580146003;
	Thu, 16 May 2024 12:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715862169; cv=none; b=SQrCAU6gZwLv18xMHWeWJOi+yzoG1Xy8UM7CMi9hJwaPzra1QU+s2jnEaGJQZmI8caCRcuzENBAdcsrmlBLvlgCTui2Lq23xoIdss1ZbipMC4f3TK8gMJjHlTrS86pTyB/WcyL3NsUWL5ka+YFE9F2OwaqCZVRhIzgKAhlMZvw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715862169; c=relaxed/simple;
	bh=pbkgcyOMAvajczsNFMK5AKBGKVLG+pkcaFB75ObAP3g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DUvGilnlg0sTfwkYAkyBNwXL0yHB2Z6Xk0pFDuI1qOawDc15ROzZ4P0ZKLbVEjUJWV7D4W5NymjX1ALFjqbx7zI2EbsUNSX5fp21CPtSpDgTdU5ibdY+0ySCYs5uE139syK2l0e7vHPRaOnQcqP1l0vbuHNZxsRVxBcGCKCBkLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f91+QU/Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f91+QU/Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E5C4C2BD11;
	Thu, 16 May 2024 12:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715862168;
	bh=pbkgcyOMAvajczsNFMK5AKBGKVLG+pkcaFB75ObAP3g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f91+QU/QCdXhU0lQCGrbANudhZ9sklbIOkouSYyBkFpNwHCKQAjW/Tw/WovwPzeLE
	 a1udjPqkMFhARICQ5yf708SP/hPSpIRqnKpE0IJZ31OP3PJ+NGLltRQuXo9XohubU2
	 dgPDYC/i9OLTyHXdC3gYIEjelFXZ94gT9ZLcZ9noDbxOcIBykg1iqMaqMgDnvtz0P+
	 imdbK1c23hrJvO2fBfWRY85ksAHybnPXG6JBq/nOfS1fLls38VH0PcHrVBTfwe1539
	 L3D7CZmlE13zwFgdnlZfAehLxE+VErFlUHp+vDopzkQ52RyRr4jd6hVhvM73pxc9bX
	 KgCfmvLR2/RKw==
Date: Thu, 16 May 2024 13:22:42 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.1 000/244] 6.1.91-rc3 review
Message-ID: <8b92c738-6719-4f14-8f86-5964e03abfaf@sirena.org.uk>
References: <20240516091232.619851361@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="FIKgxqDy+M7OVyzr"
Content-Disposition: inline
In-Reply-To: <20240516091232.619851361@linuxfoundation.org>
X-Cookie: I'm having a MID-WEEK CRISIS!


--FIKgxqDy+M7OVyzr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 16, 2024 at 11:13:37AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.91 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--FIKgxqDy+M7OVyzr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZF+pEACgkQJNaLcl1U
h9C8VQf7B1XtqkicL7UqbMI4wb/ilLikxiDsEiXSoRaNeaVcahaPrzkYjTLKRE2E
2iUH5wEC5SMLwJp+cwA4iDjkewxJTmVvx+n7KcTKFrVxt7w6axt8otTdhJ8m4KKO
TpGngmYkNi8TFBath/2xeEX9JrD3DIMbjSoMd3TFxm7Mcy3CrS2fSf8xHdvIVXVL
0Dwubx7MJDAD3rrGO251N6eAHPgCpOYBwxKnk8tnhkK/Y9VuJ2ztQtFIXzP7X/A7
t0HskZ1fOhjpmTOah0ObZb27KjKsumqTqMQEDjNV8Pkl4E5OF2bAmQLfR5sALNy5
DCnJK7Ke7WZigRyoU+giVivjyyWDJg==
=CJ9E
-----END PGP SIGNATURE-----

--FIKgxqDy+M7OVyzr--
