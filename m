Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A08025D53F;
	Thu,  6 Mar 2025 18:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741284599; cv=none; b=tF+MdhjkCl0RO5ITmwQmPn+rFn3hCEePI6l3gVMrnuyFcYi2z3KaFv2biV2cv+YF4LOlPEhoojyBRdSUzT7Repx2qn/4/KmZ8RRmfuT7d7pXWXWsHk7kGu1p6XVhNQEEbyZhf9Z/w41Y1UOoDyfodVZZN9aPiDA+azMlwKp6i0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741284599; c=relaxed/simple;
	bh=QOSEGaAwFLFei5yxSURj/6BEsJnTPaXm1zXQdUsF5Mo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iOiQ1ZhWuizsAiLFvA5FgNN3E1NR5C1CQzjB1EbDMeM8YTMcgT1vVGJtbqEWEN6IhSQldIoCHDxmUnQ/fM0GM3NAN9jtM3gM6HDIpotk3S9ptnuSJCTZYg0I56fJLiS4OLAq1YtJCN/2obHRhw3yK2v5tqYkgHKUHw+fD2TgVoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f2PEKevE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f2PEKevE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4F82C4CEE0;
	Thu,  6 Mar 2025 18:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741284599;
	bh=QOSEGaAwFLFei5yxSURj/6BEsJnTPaXm1zXQdUsF5Mo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f2PEKevEayOuNl+Y0bjOl+btHHuufaRpjzzfXRB6cz8CXiwaAleRNbkWY9g9WdCNt
	 lzm4gMhjYvnaD9nUY7hu7nwEHRWyN2p8i5ax+D7tvyfwLpNQgDHLDadG/UA0vPr4Lp
	 MKHHAImnMMrp8n656JyDiHwEJ9Csgr2ZpN+fZC+y4EyvEdHG8huZEz6U3dKnr8mBS0
	 59eyQAlV0HieOxlWL36hE/l909CxOauE9ww66zyi3wdBslMKPl2Q5QJphQVMDEsTbX
	 04bSoeRs5l2Y0EaCHNjvmsfRxsH4Rbsoni6qzHl79Di0OEyx761xah8xZNnY869stc
	 u9Kk8GrKmbN2A==
Date: Thu, 6 Mar 2025 18:09:53 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.1 000/161] 6.1.130-rc2 review
Message-ID: <0f16f3b5-e672-4f1b-ae99-95997c4844c1@sirena.org.uk>
References: <20250306151414.484343862@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="YY2SpEpQc2sb/o2R"
Content-Disposition: inline
In-Reply-To: <20250306151414.484343862@linuxfoundation.org>
X-Cookie: What!?  Me worry?


--YY2SpEpQc2sb/o2R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 06, 2025 at 04:20:35PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.130 release.
> There are 161 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--YY2SpEpQc2sb/o2R
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmfJ5PAACgkQJNaLcl1U
h9A7Hgf+NpJiHfk/IUl3wG0blz96UFXARMmB8exsQp/c0QHcHiHRkEtGTf2xxSUT
wdaYD7zE3OHnzSPUTvx1+CeDs0Z9LKhBM7wrutXA2zwuf63sPPWitQyUAw7XecfG
72/VYIAwKbC8ONYGk7AQUmyTOFJ4RMsdcPbZdphxdTZtpD+W5G5h1+ckr50NGwrq
cHdzzqaaAo0q4NBe4dRJO+AAMY9oVVBs1mnryYMSfgMQ/peOUySSzDSrqUbK4/bz
9Rk+IHWN/IKrlKxbMRbNdl5ZHyE2HKbi6Xg5a84JRTMjN4yFYbw5mlrxScFlQTzX
AIfGs/54ccxY2z9qWcFZ5Tp8KyGPHQ==
=WVmr
-----END PGP SIGNATURE-----

--YY2SpEpQc2sb/o2R--
