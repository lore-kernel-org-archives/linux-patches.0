Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9665735CB8C;
	Tue, 18 Aug 2026 16:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787072006; cv=none; b=LwC/Q19M9stNMdDzs6/eMQ+0B90LC+2JRnhC+aDBfnCCOjTORshT5xejxdaOD/PDRv0ZvPOGrr0UA61mpsrFpEngVvbcpG6OV9SNMU+2Bi9+wXyzDjg9Twt6A/skpdBuPSrFFkSu43Ml7k1HzjM23Cfzuv40/9gtOcq+xHlwpIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787072006; c=relaxed/simple;
	bh=W1+V2QEXdt+q+D3ttwaCo0i6EWfIq0+Nxz0wigSxjW8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MtbYvTYP71qVVH8/mB1OJl3xbYG4/6WRhDQ7QDBAsna5pk8nE9QvWdbmoreIAfWbZP5Vnq10KkOcLs3SgEO0fGrMOjhmYLuRemAFYeQ5Ue+BSaMK88nXq1iy8Le/dLOSLMJMRVZzitpUkBWxYtiX8V8sKZG90HZv24nDLoA8KrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J4fiUtaD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J4fiUtaD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D55351F00A3A;
	Tue, 18 Aug 2026 16:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787072005;
	bh=Q+iwwTQocaJwzZytYWcYcqgWCK9+a6Iq1A0Vvf+WCXQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=J4fiUtaDKB9hQtUjUpqMRuKmvSQJOrR+HD1sOk8XUKw1Exw1DpCEQNwFlJ2JQ0Aso
	 y27SOnR4jCn3BYRW20afoVn5gkd1PdrklZiccleem5wyyrwmG4jjzdT2YJ+inIQXYq
	 GJNMwtXu6nq0E8c2/CmdLha95DxGoSnPbfjWkgbg4aBF3Y5gyh1Q9Op+9Bkgeshhi4
	 KreVvtsx79g0rT9vAp0ukTaJxnJXEMQTtINuQQKqJIqTw/P/7/EJ6SSMfKxW5CpSv2
	 fMIoORz6Qa6BD1c78R4PryGd1yM7O9VYWImR8NeB1uqrLFp4oqYw8XhdQKKxdRPYAW
	 YqHJitmSmgJlQ==
Date: Tue, 18 Aug 2026 17:53:19 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 5.15 000/456] 5.15.216-rc1 review
Message-ID: <b709c5a2-f570-4420-9ece-829fce3e159f@sirena.org.uk>
References: <20260817132539.792407575@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="7qmC+ie7cPqZbSUY"
Content-Disposition: inline
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
X-Cookie: Smile!  You're on Candid Camera.


--7qmC+ie7cPqZbSUY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 17, 2026 at 03:26:30PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.216 release.
> There are 456 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--7qmC+ie7cPqZbSUY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqEjf4ACgkQJNaLcl1U
h9CB6Qf/evxqBIHY95/6nKacyxMrkb2TDmaEfU+FQVgzuv+nSAjHxP8Mcp0JnLzL
LVI+DnimkF90AigLhsUNwPv1ag3KQjbfgQVuFdBcc745p1o1HFVm3bEx19RRhNfj
+gwU1R3KnQ4p49nQQBAxWHg9KpK4dhjaf2LWYnEa5bnO6zPo71/ntiEiIaccSmPi
X9abOc7k2bHqiFNEdV5EselMtyg6cjOJPZNYIGAPjg/cOqygxvPPWzVJOxSJkiwC
+UxQLBW4TfvFVuUdOtjArpZYt/8RyQoSD/mPB8IaaLQlipIj/vVF96q5UEuB3+p6
zfcKP6WPYfl8wX0oD9K1rf3gYKcOmQ==
=TRqS
-----END PGP SIGNATURE-----

--7qmC+ie7cPqZbSUY--
