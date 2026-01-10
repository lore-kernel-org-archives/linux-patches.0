Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F5718AE3;
	Sat, 10 Jan 2026 20:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768075683; cv=none; b=hioksmvKgsa/CDtJ78kHmXLt+kCzYFK1NvcKn+t23zABB7NmPWssdoG4yESVqOlJCZTa96qLOQDK7aSFxALPEf7bmIpzvSXoCpSGNGc4xGEjJG5XQN+ghs7xI3XuyGxFBv9jHXTrV5OVNzdfzGh7cIa0+gTLRqwFbebdh32xwvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768075683; c=relaxed/simple;
	bh=Umgxx41Bcigz1Jl/IOixNSyAqJKMBL+5/uZGoWkJdVI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=So+rCRcQkYeI3X7PpUgYtpFZ4iwKtD/JMtTW3Gtgu06FbaXCAZ8exo6ymcxLRCe9OgIpd/4NHs06jgWTjVaH8oadevAsYMu1oK+woaN5HdJNSB4PQVHpYd6GTB+FQ/taiJI9r3T00HmtOZbN/Q5iKvtjwGIqUHqonPRZZJ5Zs3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZfqwuXqu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZfqwuXqu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E85CFC4CEF1;
	Sat, 10 Jan 2026 20:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768075683;
	bh=Umgxx41Bcigz1Jl/IOixNSyAqJKMBL+5/uZGoWkJdVI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZfqwuXquxA7eV09G1+6Vg3Q7VIBmNK7TK/iZfmDzEcVScf764EelORyCQTuRuQSFe
	 n26yy6rp0l9v0jEystZl1CtPW3Tfo89nWudC7EJ73NTkvg+swVCBMFQI0GpVvwE1xj
	 8xsxe9AoqV9oZbuNB7QS8mDIv/zi3di1DzU+Yrn/KKvyKjHHeamkJOn0G0q6dc71IB
	 NidrB4VECsGyEJKgGF/i+dHOeUf5K0/3lHBEhCNog0GcoUJeDFpGu3iR8TW5KmszeH
	 ajGWMo1DRi9WvemHJBHgnHFL80o+CRs1fotcPLqKCgJXfLs2+ZT10xjj2EhxOWbKjl
	 E6x38tNSLg1uA==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 38A611AC5681; Sun, 11 Jan 2026 05:07:53 +0900 (JST)
Date: Sat, 10 Jan 2026 20:07:53 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.6 000/737] 6.6.120-rc1 review
Message-ID: <aWKxmZ0GjD07P4UF@sirena.co.uk>
References: <20260109112133.973195406@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="hujgU3CmPK/39lX1"
Content-Disposition: inline
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
X-Cookie: Think big.  Pollute the Mississippi.


--hujgU3CmPK/39lX1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 09, 2026 at 12:32:19PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.120 release.
> There are 737 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--hujgU3CmPK/39lX1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmlisZUACgkQJNaLcl1U
h9AtmQf9FFYquYx5i0qhSBtYd57Hdic0QSvnl1d/6flEg0Ss+Xv3JetCO+CAsGRR
kvnYnqQQqI+/aB4Z1+odOWpWNKMuNWkomrpx0NHER5+VgU6s4EbUotERaFZZfK26
Qtc7++nH6NLv4R2VuLOy3MXHUw8yz3FDRIlGqf/eboVPxJ5RQlW/rKCdLJKzoNnz
yjJZmp4HxmaNbwt0amncm3cnHYFswdLB3G1HHdkn+7tWdzp0NhKiN3kxgUaKfdmM
p+f78w2CAcU4d7fhtIi+WEwE7AvUI/IOAdHCAiPyzeL3VBUVs++7XHHgzjNp3KVO
hj3gZ0ZW5RIVMw+FByq/1FsCPcVSRQ==
=JgcI
-----END PGP SIGNATURE-----

--hujgU3CmPK/39lX1--
