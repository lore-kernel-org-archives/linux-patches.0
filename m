Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651D732F775;
	Wed,  3 Sep 2025 10:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756896429; cv=none; b=IzGDQJOaDyNYkLIYeAWRlWt2wgwAiRET7QxbimmxBcPTMHWdbl6a8LeB6r7LgJgRbeL1B9u3W8ewyJ4rgHZW4hFIcvm8DtGJDKMwxXKTNPigK4Vr/o+jI15u6oBN3L9uob88gPGVOqXT1ruFXzTffrqbtDaaxzax2tVnQFcae90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756896429; c=relaxed/simple;
	bh=fz5qmFrEHCXZUGWMGVIO3vtqxPDyiM48ah7GvAY13vk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tlagLiKBPfl9GC5MYz/xLdEwSPuzMEfPZ1muOzo+ZbCeFENq8JtADmJdI9Vv130Xtt631OGD1QOtXBXQuZ19kry7Sg5OitvNQBE+CoJuv9fSvuvaMTGnnBwqByybcumnxHTneHasKPwjvWhyyiz/dGmmEofRvEwX+5U+j5cvmmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DLiuXvco; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DLiuXvco"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46BA4C4CEF0;
	Wed,  3 Sep 2025 10:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756896428;
	bh=fz5qmFrEHCXZUGWMGVIO3vtqxPDyiM48ah7GvAY13vk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DLiuXvcoHuAIBpbv0ee5qIMH7HCHPPpMhiovtn8kXwCAXNY3PBePahseuun4mmUJX
	 gGY3HT+raXunXIYkIIZLke2+fOgGSzvF7gnMnsUZ/eBC+d9shNnRtJauTV+MpRUOHe
	 3QSpVyI/5SK0pb4lcuN+AmXb1rI8/ltFu0SNQqa+OCvIEx1EG/Vp9uWT0sGvvnAbvk
	 Dlbaa+nNWzjLjOWIRZEdS//BNvfdW8EWAHwcwffSPa2C3LHhY9RYNoYNAiP446B+Sw
	 ZfDgOIqpJmPXjJIZpKsRsG+PeTC8/5nmxIe0DDd9wJklTIp0SwysMA9i3SwGRHmh10
	 2nfrTJkoSPPFg==
Date: Wed, 3 Sep 2025 11:47:02 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, achill@achill.org
Subject: Re: [PATCH 6.12 00/95] 6.12.45-rc1 review
Message-ID: <c452b3fd-770b-4fb8-bed4-6e89ff7240df@sirena.org.uk>
References: <20250902131939.601201881@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="IlbTxWye2kNCvcVN"
Content-Disposition: inline
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
X-Cookie: Ma Bell is a mean mother!


--IlbTxWye2kNCvcVN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 02, 2025 at 03:19:36PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.45 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--IlbTxWye2kNCvcVN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmi4HKUACgkQJNaLcl1U
h9APoAf/XWN6qKPtAxH+YXrd6CBW7IEWpc92yghyvMnYVLt6+HmwzeS8J9hUmxrh
qe/sz2GARO8Uk1PIaaFdQI/80wo6x3HdM8x44mqLL7yFUZRYqgoOZbFmOdk7ZbiC
Z2QHTss2V620DVJhGFyIKNRKGkpzCClg/9c3RSTK0EjTPEiNh/XZNERAaqdjYzhS
kBFyislLE4vURtusNliBKaGtUJA5d8MT5erpis4Mv9i57vLT53tz/C5atDu4o8YR
g/sA3+18Cujs9vmvRCU3bWGyJKpELVAk7wMryg7rcvqj7ZmalXGkUgzwYP7pK7UM
9MQO16UukQszgJLuBsZF/+cjKAbuTQ==
=jQib
-----END PGP SIGNATURE-----

--IlbTxWye2kNCvcVN--
