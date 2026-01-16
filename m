Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8CAE339871;
	Fri, 16 Jan 2026 15:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768578280; cv=none; b=ipSR9XCe6rkL8hJNxvj4vxHe3d+6j4QQsqz6ENHIsJBqkNDlPs1wQ9Nvz9HDLCBlPi+GOwvG7WccDSEyM8EWCgIVc2IIaiT7wEZi2omCQISmi6SHhIvlvn2k9BEHR1vu02fQ11QioLTLBeM3jjNs4zNWPz9+fa9Oig6EZYj7BvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768578280; c=relaxed/simple;
	bh=hKCrJPYadKh7DbdP5O9+TzwO0EFbHZi1BeZ4zrB0Aok=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wqm1HW7GfdRJI9jSD6hrHytXz1FvvPTel6ouRxZ8JR96q92JCuMJC24FXkwZCne5Nk+NxDtVpQCiGoSsyQPlO99P1LlhTcB0hErbCBBjUxx8rfp+l5qe9+/4uay1li3pXXO3C6ot7YefLxWb8HBkzbpuWK4IzjypajhCKjuYmCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fN1JSAzZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fN1JSAzZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB79C19421;
	Fri, 16 Jan 2026 15:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768578280;
	bh=hKCrJPYadKh7DbdP5O9+TzwO0EFbHZi1BeZ4zrB0Aok=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fN1JSAzZ8pOQPC6K1DwR4B6F6uNyKDYw3I4wwFTh1rq1XWyqXDTGR/8gu3jTu4+ex
	 HEFqQRcyE9Q/PckM5TN7UFmEepKSTzUy9FDuiXCNjqhRzcheMOr9kglJseEm7qGFua
	 p9eX+KsGjNhE0rSTkTuKMwt/nPYyAcBevkT+4ClWmzGpXvD5Aklv5sq3tqKDqpFM9o
	 olPRsSrBhVfR1VYgUZJotVypI3D+SpMTcPig6/TkSJlGnTbuFtEnxQBpY8TnHZ0gsx
	 kjktDztZcQ8mxhUtqc92oP027T79u6sJ2cv1HprPpQEkFvyMhp1IqEwVnInrLBlG+2
	 mT5HncYndTJLw==
Date: Fri, 16 Jan 2026 15:44:34 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.6 00/88] 6.6.121-rc1 review
Message-ID: <fdc5fea9-39ae-4b27-ba23-40ebc25b332b@sirena.org.uk>
References: <20260115164146.312481509@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="B8/3P3xIOhxdB+Ld"
Content-Disposition: inline
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
X-Cookie: I've only got 12 cards.


--B8/3P3xIOhxdB+Ld
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 15, 2026 at 05:47:43PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.121 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--B8/3P3xIOhxdB+Ld
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmlqXOEACgkQJNaLcl1U
h9D0vAf/UGVrLA5x+MtDsInZhh9n6qUBAPAz3txStb2zeSsACcRjJxANj4fZ5s/Y
MR0nYsV4GHFSnnukjipvIkS3SSJNLjSv6ICm/7IV4zQT+1l5PbLv3R4c63eCPFIP
ZTp7ry1nEr9lmwt+0e25pDf5cEihsTb8mT+ZOv1YOlEcYgkXI/u6PdoAwo4NMPz/
afPN4QJs82GDt6DDAHBHuAq+YUBwOhH87pEO7hYjlMxEqJIf907O5g6PHkyqFdpi
pmlUv0oQE2csjE5eHjWQ/FfUhKKsariYYH39o/K5XE7LP4mv0dZ+QzUAVvEm4bns
/5DKc1n8ezna6w8KnqQqVHUVmrdhOg==
=uP9a
-----END PGP SIGNATURE-----

--B8/3P3xIOhxdB+Ld--
