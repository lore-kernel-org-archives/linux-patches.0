Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6813523776;
	Wed, 15 May 2024 16:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715791758; cv=none; b=XTcmQ6lF5Kb9Ji3naZEtmcZ2Q7RCAh8meyQ4B8DI+Ftu9qUn+g11l1txnGzErd27wRStz55b/0nshfUlvYS+k8B3n0Ob0LqRq4O7cQI8qbwPfXpktaS5+p4ZtIRTG68XoLihw666rl/pTz639Rcn1Ee33lJslIMxCTgsQVkVxmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715791758; c=relaxed/simple;
	bh=YaqzzlFHvtVJ2dLzlrDhS48H9vFnQgSPCNrgRjps4yo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lS49Ws2b60Ki807zv6NUwIM64Z2UFqpSKCw9A+VQxL0cc26I+x7dBqD1LBNNJqeDae1H7veHcn34Ri78rRS57Q6+c5G2Q7WYSyTpkuf8q6dK2dDZDj0StmlTTqcdbPx38FqhhW5KnaqK63yDmEDvMQWyUkfSj0EEuTS3vbUNies=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HU9+DZ7p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HU9+DZ7p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91638C116B1;
	Wed, 15 May 2024 16:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715791758;
	bh=YaqzzlFHvtVJ2dLzlrDhS48H9vFnQgSPCNrgRjps4yo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HU9+DZ7pSAMucN0xyyzXKUuQnghRpvDA/IolEKDx1vEw5VvjXsKCBhg0VuwKMkIXA
	 4OG5g2ZLoS1lo/GVM0d73j+gecYf6Y4y+9fiKXFoMAnbCDbtlVjDl22OgYFjqNAUNZ
	 rQYi1euYDJFRlxLywe1yU6PERl7czAaonqzENjnKW/UHsqYWG9nRGPA+w2IEY/jrmv
	 kvQPJu0ZZZzpew0dpLJiKDXIBO2oUWjbmljPEcKUXLMK0TRMH0Wj+aEX88q72Wzbcf
	 3cnp69R3KEnje6q0Lhi+TFcewaVSva8Npi5QyItrgJEPLd0gOlOc06+JYmK8V/DhwH
	 CPzXD76ybxMgA==
Date: Wed, 15 May 2024 17:49:12 +0100
From: Conor Dooley <conor@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.6 000/301] 6.6.31-rc1 review
Message-ID: <20240515-cavalier-sacrament-2ce748e91aca@spud>
References: <20240514101032.219857983@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="xwlpbGy3+MeTczgx"
Content-Disposition: inline
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>


--xwlpbGy3+MeTczgx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 14, 2024 at 12:14:31PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.31 release.
> There are 301 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Cheers,
Conor.

--xwlpbGy3+MeTczgx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZkTniAAKCRB4tDGHoIJi
0mXyAP9wVUkSPmzjUCPEJ+9OYbVs8OQ+ly/HjXwob6fZ8d4R3AD/WrW3O2krPerE
UpItS12rTbP95oSWR+OJ6IqJP3m0dgc=
=GQRl
-----END PGP SIGNATURE-----

--xwlpbGy3+MeTczgx--
