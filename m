Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DACC33D47C8;
	Wed, 17 Jun 2026 13:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781704572; cv=none; b=hqBoo5wOx72CUHfInlqjbFvZSkZTU6YSPlQrjsTPS02cDJUzDiINVsI/SUn+TBlr/++KLA+6Msz/g0isdwWUo0X4eO9PMSWODP3/PvfZNsl77Dsw72KrrAIkQUo4XVdqaqDoAwVa/sz5blPPy35d7/JHvgWJb4o7Mnje5fvifIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781704572; c=relaxed/simple;
	bh=iTWAV0/QgymAYUWHubOAceNomkZl8fow7VtraiMCF4o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Izk5RYE2znt9moFN09ZUcRzdyaV/uWeZhp2N3A8SYAf17ZHP1tHljngiAfukwYTHhzbWORVR6kOXhl4rR5x3a7W57Fbyat4s0MKSpTYLIwGSwFvOYClggoGfJPM6H9LcQL73dRPUVMXvnKDYOsXNu7lRA7oJmWqIfCQRn+FgxZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O2YaVGMm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O2YaVGMm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FFA41F00A3A;
	Wed, 17 Jun 2026 13:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781704571;
	bh=isTw6+xeh+YNLcUcSWnoDeZkl7QnUKdUlNZcFZT2vyE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=O2YaVGMmWO4BRsJjJ1+a+8HE57q014tmzLDkgIg88+VOFq4uzFFvqqo4OfokiVJmL
	 P4EIitbYEYpamLOJswS+TmDy9R/BFjrlk8n3O/wWwZ1nS8r31MznipNyHBa0NXoVS5
	 J5PMV+ZvhTgScNMp1HiBZdMlF5Tn0EGT9odcVXYDmQA6Py793VG5gUqfjFHUBpahNw
	 b/VJy37nJInETw6oRabVf0FEEzgB+8devT+aIHK+sobw8kGejlC17FPBypNyDR2RQf
	 cp/oHxK5lxlvJGh8n/1PULwZH15iWO76kaU+Wq9UGiIukvXKjVv7NvAyAENaEtoDWj
	 qa2gc3yX4iE6w==
Date: Wed, 17 Jun 2026 14:56:05 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 7.0 000/378] 7.0.13-rc1 review
Message-ID: <689e1202-45d5-48b9-96e7-a64d30a6bf61@sirena.org.uk>
References: <20260616145109.744539446@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="LZftC+37NQqhM9/u"
Content-Disposition: inline
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
X-Cookie: Absence makes the heart go wander.


--LZftC+37NQqhM9/u
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 16, 2026 at 08:23:51PM +0530, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.13 release.
> There are 378 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <brooonie@kernel.org>

--LZftC+37NQqhM9/u
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoyp3QACgkQJNaLcl1U
h9Doewf/Xi7VqpZ4OzBYEjIlVN30SrbVCDtl06uKMILlnXIfCKAUqha75u1vx8KD
sOdV7nBPD4zvoNAA7sB5+SixMEgkU1ZUXzUQjpfQtuiMIH9oWfWSh9gLOz1XjHDo
oH6H0qiYvf348+Oc6P4IqMcqKX+pQ45igmahY/HJur0Vj+63p90P7sbwGfmX28Rx
XBEPh3R7i7lTiCrIVZNrH/yZdPkp7jmuqLHN/ATbcDaR0luL7ASxbHcpZzS487mz
Y/x3849EGWSVoDLvV3SXoxiFTDH6jK9Y8wRCKHV/KxSmu1nyKry72Y7rdSgs1FwA
RJ0Cz+71MOmzWrBjmAzFxU9gomYwEg==
=KDdJ
-----END PGP SIGNATURE-----

--LZftC+37NQqhM9/u--
