Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218F51AB50F;
	Tue, 10 Sep 2024 17:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725989404; cv=none; b=IxatNrVVERLGlePqCYpBDWqlA2JYOdKOnsqrel8Dgn0P0Eyq6qcNJCVT1B/TWgCLCwHIEO9t5g9QXhbkTJzsUOXJv8eng6wKI4jOMDNMEjoHtdxjNTbDRRsxlXCtQemxB9kPAaQvTapnLKEw/JoLOq5AbriJagA4xEW5X3dlBEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725989404; c=relaxed/simple;
	bh=AFTp6oWH/6TER58vFkwOBYEl4yXZO+TrYlqFRI8K9Cw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ipSOwM4+EwPDLgOq5DHWGMRDbWFKRx4Uje8Vfl0INB/9HX21N1QffsNUeYMRoPsiiKeKkZ5GLAtWNxY4fjmUbQ/X24qNKuCXXR6YHaBohWhmXcDiN6Z9370vLqq1qFt/+Wy2RPmTcbL8CvtFiC2iB/NOtgnlvfi9OPGKjAqbggY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wo5TOssI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wo5TOssI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2306BC4CEC3;
	Tue, 10 Sep 2024 17:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725989403;
	bh=AFTp6oWH/6TER58vFkwOBYEl4yXZO+TrYlqFRI8K9Cw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Wo5TOssIrSUUT5wiN5/kVlyOczl6Heh+8SxSu6YuAzOa8uRm8v3SBiRWATOuhpZMl
	 0QqCpjWj96d1SG5l7Oy7PcXSI1RCt4eKXrQeDJjHIBJcr6AH0wbMsqqDA6Xo9VWh2n
	 TKV9mWw3/pfcV6LHA80tblcjDjFwTAPSNA2/QDWe+q1UDXyp/N1WTjZD5JJOXk0onx
	 9auUSmqaw6vjJ1RJj1XHzAjz/WdBngBunxWYs8xg3UEf/6kcTx4fInmnhs6f9Kv6lb
	 VTxH49lN8qO3pV4JACCkc7zRiHRjHWpfCdn3dCM4qOaGcNH7J8/KHf6YgFiwSomIdB
	 yEaPgFOuweiuA==
Date: Tue, 10 Sep 2024 18:29:57 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 5.10 000/186] 5.10.226-rc1 review
Message-ID: <3ec53132-6323-45b3-8ae1-585563e16dab@sirena.org.uk>
References: <20240910092554.645718780@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="VxD9A0q1t9uWT7vU"
Content-Disposition: inline
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
X-Cookie: You're not Dave.  Who are you?


--VxD9A0q1t9uWT7vU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 10, 2024 at 11:31:35AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.226 release.
> There are 186 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--VxD9A0q1t9uWT7vU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmbgghQACgkQJNaLcl1U
h9A5dgf5AZVf/wH/ZvWqYGcz8X5cjDpFNZl12UnkKDwxqQNlKgRc+kFfVDUI9dJL
X8qZhGtk32Wfupj3UbqjhP0RsGSVIbHRRBPdjaG8UhFjrBuYFVUewiOterdRB6Hq
okV/TBZ1lkvBCEOITc3mV48dDXt8dfiwTLXpjpO+1HRQ1QuWeN+FZKMGG5Qz6ACg
02L0OVAOmSfXTQAGb+G+YjjSuvYvG5mtH8pkV4SCjnNhD4BZbdCNXeW3RUhAlzvQ
o19E9ePHqDI27lfHL8TSByFbffSnrqgGgNT79mK+QreA9DPlw4t76EbSMIE6Vzup
6WhAM53Oa89ytEJTid3qlH0N+tj7aA==
=J5/Z
-----END PGP SIGNATURE-----

--VxD9A0q1t9uWT7vU--
