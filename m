Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B86701C10;
	Tue, 16 Apr 2024 00:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713226819; cv=none; b=qGtN2lTSPbrToEY2Ur2qBdxUPXsDJTLF1c6DInr4r0lIypLmGyHGdLQ3H3+Ot6hruftu7NFn/OK7CyexbveON9Y1oQjUZsKyjXbJemmUtOadA/BbJwbkt9eMeX5CnPqvwBOFj8vxQE+1q6XdOq548LtaNGP3jpR/xmlvSXNED2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713226819; c=relaxed/simple;
	bh=Ecffz34Ol5COoKwxnsLW3luLfpMXTn/v5iEXEMC+sBA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gv+RLaGTnQfz1oyH7HGnDYc6/Vc64/4XyUk2m94jh6rKh+yqjT9+YDR0ge43cVCdZ3KoC/hvJD8h6mfnAd5/u8egAKRFUeNXBWCHuEJVp+659+Q8V7Ev9up5fqTf3T6r8a6bGpmWREF2NJOuzOUXS566BzjCIKfYfBNIRKCxcJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ilMzKBIk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ilMzKBIk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF282C113CC;
	Tue, 16 Apr 2024 00:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713226819;
	bh=Ecffz34Ol5COoKwxnsLW3luLfpMXTn/v5iEXEMC+sBA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ilMzKBIk7xA9d9gtblWu1L9l4lNczqy/c2o+EGMEMqsDJwUFe9XG4S9+pE1RGngAj
	 MdB1zkwEMayY1oBRJV9eLffzPCs89yoIWPgQutkS2y0famwLtuiHHGokc96VWLviIX
	 BwW0So2M1/e3ZCV4Jnw1upLAq/wzIQibjxauJoJ18NunEVK+T8PlzzAfAxH8fX15dN
	 QE3r067A84ng14aPh/enQIj4J0D7fGrCFCb+4bZ1qKM+rd4RrI0DoPY6CxtwJoiwOf
	 l/DyW9Ism9puqgEReFIqcJg/O33trWBbUa4JUEWncewhu6vU9I3SYVxiOsZ+srE4Py
	 61MsjmRu+jdQg==
Date: Tue, 16 Apr 2024 09:20:16 +0900
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 5.15 00/45] 5.15.156-rc1 review
Message-ID: <Zh3EQMkYtM7SJCAi@finisterre.sirena.org.uk>
References: <20240415141942.235939111@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="8pElh3uKAXIyU+RG"
Content-Disposition: inline
In-Reply-To: <20240415141942.235939111@linuxfoundation.org>
X-Cookie: You might have mail.


--8pElh3uKAXIyU+RG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 15, 2024 at 04:21:07PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.156 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--8pElh3uKAXIyU+RG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmYdxD8ACgkQJNaLcl1U
h9CtqAf+MRpzycDIoC4rDclOMz2qdtmipot5sJPPzFr5cyJCAed7ADmBJM5Jr+06
/a5fwA6nhKnAwZkW2mAGwfYYfXoLbHTYrvIX16LiqnLNiGDDKuezFcInwihpWwLb
3n/sham15SwSsnMaZek5ZA2fJAbO1aonY9OLJKqJ8CPOu8ZQpMZVI+n3xmDuW6Ak
T2viatM1Ir+2EY5+MqNcfr4fc0SP9/YlFCnIK9kkUuvx1D5DHwaEXdy4ltf+HS1W
PNcPPeS0gAmz0fzjAuMcLIyQQv8CBr0OzVK37IGmwUxrqI81lzMOGJYUldgT6cDX
qxa7nWIgYG33NLP/+GSrgedtzEGJcg==
=dbep
-----END PGP SIGNATURE-----

--8pElh3uKAXIyU+RG--
