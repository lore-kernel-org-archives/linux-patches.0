Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430451B86D4;
	Tue,  9 Jul 2024 21:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561052; cv=none; b=UQUqY1CxmSo1F807c3WNdgVY44QlAJ6nfreyPUbUj5d4BAdMOR4XJUalm2UHl8L2Yuaofn9YKyp7oPTKHnxiyWQW5qsGEteJG1jhU9qRKp0d4eCkSt8n0whxxOv8IRpp+jPFSZD/h62D+lXZZpURw4UOfI9lS5o2kTERAAfHWgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561052; c=relaxed/simple;
	bh=FgxdchY4m5GxoPZo2z12O7HVwH39v4uE1S00qYLB2/o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lzo6i/UOZEmz+I3FqNT69E5YgwYiovFlgAyF0HoKP9ffIbcslzfTV8ElXt9hSswE0sIZQpagpAReH1Op6qUVvQq/LSZs5EkKTIiQZ6w2UL6L6ZOCwnKA0K0kvMbI5KNMXqpGljigk5r1ANZWgiD22AAnoyAKxUfVqJcwSdyf8Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J0CJ8rny; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J0CJ8rny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46449C3277B;
	Tue,  9 Jul 2024 21:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720561051;
	bh=FgxdchY4m5GxoPZo2z12O7HVwH39v4uE1S00qYLB2/o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J0CJ8rny6/BoA4dx25NZ8VSy/bxI6Opw9b0kclcBf6xOVh8jEvxHwaRH9n1H9znch
	 eF6FKfWi1+N1epJ0JeVxk6cvNt8SRp1hrpc3eqfE9q27ttLlWHcSZRUFO8ZiH/KV4q
	 eZZdYLdVWromW7Pg6N6Mcsg8D/Z7o1zC9vc+pDpQ8YBzeOx1XTANiA7VnSb7vbiuBK
	 K9lWQHel2wiZOaHeSaaJ8lhIDAsItkAdOX3k01jk29GuXh7nEwWF7bgu+g+fk8xreL
	 iptfq/9sXgKLAZmWlUgJsrwJiQUFWf7Nqyb0G6I82QpETODSOYFl5ETm3cC56W9RQt
	 SFbk1pMI8EiKg==
Date: Tue, 9 Jul 2024 22:37:25 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.1 000/102] 6.1.98-rc1 review
Message-ID: <4176d17b-df9a-4b39-bdcd-55c08ab5d07a@sirena.org.uk>
References: <20240709110651.353707001@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="koXrYQYHfLZ5E0MA"
Content-Disposition: inline
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
X-Cookie: Most of your faults are not your fault.


--koXrYQYHfLZ5E0MA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 09, 2024 at 01:09:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.98 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--koXrYQYHfLZ5E0MA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmaNrZQACgkQJNaLcl1U
h9CJiwf/U4mgCz4SSlmzRT12cZwvD5+i3gv7rh3rT0I3yL5xibmcmPnwbxmrh1rq
eO9H2paOqrbjND4VFWtJaFB/YxqYxTWNZQ02H59nL9unvfirmA6PJXZNnkMLdIA2
m9BpFp7kyh3jhnDaFGct3A2P46BNfVhTqLbhMIPERgtL0fUmJ0h6dNfEAjiWwp1J
QVMwtTG/GLlLtBFqOKKLc8PAlmFetH7vSUjYUmsKKWUKTigKjsrlh45zsGxqUWvV
q2kg+taH8bFvzp3ytALjMDWLE7/+IJGMLX/Tvk3mmqZpOTxBO5yoYD3DNrXXyRU6
YglnpX/5hy5UvjBNPZVFPSNj2cQnSQ==
=pdCW
-----END PGP SIGNATURE-----

--koXrYQYHfLZ5E0MA--
