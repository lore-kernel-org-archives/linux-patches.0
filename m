Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405251946DC;
	Fri,  7 Jun 2024 15:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717773868; cv=none; b=ZsVQ/FJv6bFFGtWQbssam/H0WVZAgbjDwvgSPm8lj/02TIQ+lzSrFlwlZ08lZKFojrea2neeGaXlotQxAAotNXSP3S1agU1GHdKPd1gfylazt4N4WjaPEMzo4wRBPbn0WZyqPdMFGixZ2M8iOV8ITux1/zdxA5M012BgIDajagg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717773868; c=relaxed/simple;
	bh=57dYR5TZgUNrI5TNLEoD2CXhS+QGxIVXJGvh1bGBdls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uxjsqM7365PDSrSF6MjzgmCNUtgqW+KKSpoOvxC63IS84sUX5wvN40vcln7X29gMwqHOX+P9zkYAm1BRDLv891+r5NzB3sywvlZXMJvsOjZthLcnhwrtxphg6IeNE0J+9JYfCmUKTobdKD57HsE/Tndf61ot31g3kedDjYk2qAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fx/QTdlt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fx/QTdlt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63A7DC2BBFC;
	Fri,  7 Jun 2024 15:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717773867;
	bh=57dYR5TZgUNrI5TNLEoD2CXhS+QGxIVXJGvh1bGBdls=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fx/QTdlt90yRCODWup09DDBCHC0+vodWMW/PMvRPu9kuzlNzUiXOdR+AM0jxNID1T
	 CecMnC1ihHmbTEXk5awSPNX4L0UdKabDqhWJIrBzkaR9WJLXjJxWqINRT0o48w4PqH
	 2FfP5ZVVLmAeQLmJGhVX4wRo6xBSsbu6/6hJiTh6hvYg49gG+CeBoJSFaciATjcj6k
	 8F1dT2eebAsFXNeWvjdd0ibzMj8Nq8yNxskIL08Ikj7zsjubupoKfr3YY60zOKtRVb
	 TJBgSfqKZaI6GxM/dulbe506VFJA8WotibkLBmsoWoe8kdmM8QJiTQ4wYVqjWPTG3k
	 8OHzvsMWSP4gQ==
Date: Fri, 7 Jun 2024 16:24:23 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/744] 6.6.33-rc1 review
Message-ID: <ZmMmJ6Xo1pPfpfTC@finisterre.sirena.org.uk>
References: <20240606131732.440653204@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="9bB0EXNkU8Qqxa19"
Content-Disposition: inline
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
X-Cookie: Your love life will be... interesting.


--9bB0EXNkU8Qqxa19
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 06, 2024 at 03:54:32PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.33 release.
> There are 744 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--9bB0EXNkU8Qqxa19
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZjJicACgkQJNaLcl1U
h9AQ0Af/Xb2ADtYN5wij4P7BHOkHw4+EJozELpuHNtXWMebKnmsNmAPlys8ygem5
jdl+KOGWgIf7gryafwoJayDxy4MVwYfePYRcXAv41VLFCYfXBHdQA5H2ev84lBr1
NaFO+OcBdY7CNjBLnrQMW/t3bf2LlqBe7iGcGS31xNSlDiFI+GmSvjZPWHnfSPaN
Awq/Wk/lAo5po/VC9Xq7gGFMvNxG3OHGFP+twr723i7mQkIZrfzatgOkdLFxK2pv
DDYvTbl1YwIfXSRVAcKwQwQO1+8F6OOnBHBPCi10QUFQDVc9duV+2InovxVbEohO
wzGIg52jBuTRZDT+foxyohScYuB1jw==
=lNjm
-----END PGP SIGNATURE-----

--9bB0EXNkU8Qqxa19--
