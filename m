Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E542B9B7;
	Thu, 14 Aug 2025 11:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755172796; cv=none; b=QGSkupdHuVPo0l0VMRWIM++dyxiDFbXLgUo/EbMSK7dq4A8XnMqCOiWYG7mp0IcwC3ZYP7YwFE4u1C9XvEeiXHKW3pN2PSvCkdLdmsZWzJyIpiz35+mSGFuWtpFOwnsUcSLtrumwQATz52cNjZXngU9lXWC/oUPa2//uikHaXgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755172796; c=relaxed/simple;
	bh=r4iDt//s+QBSbwLuaWGxeAZrhZlpm2M61+oczK1Xlf4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NcHZD/990ey/MvskWNcbZ20og1ml2Gd6Ic8tP38RRhmNcxkNT9rHhgjvZLZuAb4E7c6K8yuTsF8UPEGqESmB/IpFFosZwHdUDxEifWhhCSBZDW2u0Q6u6oIe8KY3M9f3YuoP5KW+Vx5hc0rKgIib3wMfAC37WAdoV83ZejGiK+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FEk+0JJB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FEk+0JJB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F175C4CEED;
	Thu, 14 Aug 2025 11:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755172795;
	bh=r4iDt//s+QBSbwLuaWGxeAZrhZlpm2M61+oczK1Xlf4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FEk+0JJB7f0TfshASByUYjwXUthEJL4ZX+69x8uoPXg8hkPPiAVZgZcEhTvzgTc/O
	 naAmjf/ZWkJR/AAUEQalp/smsSgWpQTGAvhP81oFI0p9piRJU09IQC1MEG1N8qzx90
	 Z85aPWl2FHEePrL0Of78671z1cDZSKundm5f57CU4hVvnND4PAWcmFWxb4uPfVrpVp
	 7YauZVFXaLHI6m73zoAgyOeTo0SaCN25el+zur0ESrWQnj1250ldh0Max52Fsviptz
	 mT+XlX0yb4gfa3OiWilE1xLjhkntV+CE5v6+2JvinjmZnwSXNvK3v0cYEJaLveHxRu
	 3ZN2zDcZT2dKg==
Date: Thu, 14 Aug 2025 12:59:49 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, achill@achill.org
Subject: Re: [PATCH 6.6 000/262] 6.6.102-rc1 review
Message-ID: <9de6ded5-003f-41c3-b876-a7a24c8822ac@sirena.org.uk>
References: <20250812172952.959106058@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="26Ts1a7RHFR28Ciy"
Content-Disposition: inline
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
X-Cookie: This sentence no verb.


--26Ts1a7RHFR28Ciy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 12, 2025 at 07:26:28PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.102 release.
> There are 262 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--26Ts1a7RHFR28Ciy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmidz7QACgkQJNaLcl1U
h9APVQf/YnqKllwDRDiIIGWMVHtBkfho9cnPBwueuQ1V9ZFiNm7FEukey7RhCnZC
fTROTjTYkfdUi04Jn+aEKXRVlPQj2rJ7CEPSYChYcnSj41ryV5qbYnnVMwUIw2oq
BzHvbn9/Us4kdwkFJgnWJU7hrTz6dDwbskbxSzdK3UbIY1oHZcK5amfbcXWaUtsw
ROBg4iHi7GPujPWOcQZ3fqfu9XBZJnyud6lzQWbYbTYdO9RSdhwysOz52+pEokT/
hytAS5tIBoKa7fM4x4YRX9O8yAbe6FkaxpmxTEz+lM0Q1+dBr80WfFoAhTzUESrY
BiU9y2resJUA90FuCCnIXaeMpWozaw==
=uI9m
-----END PGP SIGNATURE-----

--26Ts1a7RHFR28Ciy--
