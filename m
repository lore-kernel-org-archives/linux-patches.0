Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B42A43A7F3;
	Thu, 27 Aug 2026 12:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787833144; cv=none; b=PaXKST7P4IxMLoX19oJ1i5xLejkFAELSvmCGYqs6mwDpa7gh9gzo0AlDobK1s8ZrtP/NWpb1jZhHgs2H7/GfNqgpSpQs8L2pL3vapS/2QhQPjhAnhLwWghnG6VARhrQFEJoJOJbIamgmGghKP7TjeKDvWOLP8G2S2gIKd1i3Ibs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787833144; c=relaxed/simple;
	bh=ZlJcLdkdpL0Te8QZvFs4GA3wpwItrqQnrYnrwnSODro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qYj8GTXn8xRv7eo89TXZRHMhDVWPL4vILX3wcRE1AGeyFzO8wHz2sr3q/qcNuWRNDdAqRu9CC6rOsB6z4GIAuRNXKjXdaE/WEGPRzCQyLzf2dSEqgxp4smpgn7frltGXeVSD8qzZ6gyxgFOR+OV0kgaahnvAbM7bjr+sNhgAqPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hDCaVvES; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hDCaVvES"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D34901F000E9;
	Thu, 27 Aug 2026 12:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787833142;
	bh=4Qs29KcnwoyMzvas4pVDhwqppVcxQsyz3i5GRnW+BHc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hDCaVvESn4UCKrFBf+1sYOqotBicNf10vwuhmw8jIRr5tX5wW84gmzg1iud9AgsdR
	 Rnt1o66gSVs3a/Q+H82bRVGylUZvsJ7UUUp2dy1OMw+V24unErF6E6eIIKCw/s2+Jx
	 tYeKEawgNW29KHceUwMZCRLN6rW8HcfCnQFd1eisOiL02NGYp1JlRus0neRqJOdgkL
	 JR6xa/C5nQ5Fnr+B8J2iTptF1pvravU6OGBLDE0EsvYKa2NALgcMByRraGh8MyhdmI
	 dBuw+lkx/l2LfbHDTGDtQtS2HESY2Dk427RpLL70rJZcbL3YN3CyCQTQ665BxaFzvO
	 PoJ3y5ZuBAq8A==
Date: Thu, 27 Aug 2026 13:18:56 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 7.2 00/82] 7.2.1-rc1 review
Message-ID: <46163062-47f8-4028-9d11-29171f9b6dae@sirena.org.uk>
References: <20260825132541.560541185@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ifOI/kR6j7bCVOZY"
Content-Disposition: inline
In-Reply-To: <20260825132541.560541185@linuxfoundation.org>
X-Cookie: Alimony is the high cost of leaving.


--ifOI/kR6j7bCVOZY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 25, 2026 at 03:24:47PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.1 release.
> There are 82 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--ifOI/kR6j7bCVOZY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqQKy8ACgkQJNaLcl1U
h9DFTAf/URJjHRxYnJK15iZqT4rhflqlDUXv1eGp8gE43DrrO0C6REDak5Ydo4n6
T+bj77+hhmiSavzmPyrqb0rkLJV4ApAuaKmdrSa5K5no1QjcU8UsBsZ+SE3NY1KG
W1AYLXfMz3wshFNE68Dw672vV7FdfjnO0dosFcnhogk2sakIBKxYp002QGzKz61P
cCyuLppFHpKFmK8Ra/SCPoqTB9ChvTHejzINsZxZDJEkBJLSuAaXSH5csnRgcyRf
5NBBGXcrhhzJJiYhGcEDm6oBLuw4ebmEGWWQaOk2xIPLJ6Dut8rd008Ic7hQxoxt
fbmdsQjBQ5n+Dqw1NIXp4jHTWTE3yw==
=S695
-----END PGP SIGNATURE-----

--ifOI/kR6j7bCVOZY--
