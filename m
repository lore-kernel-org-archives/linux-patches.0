Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4671991BE;
	Fri,  7 Jun 2024 15:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717773918; cv=none; b=GeZK+VKS+b/JOoLe41B8iOFlW4MIRPhN3yiwjCbiRxeE/9OMbu4GRkliZocRqQhgpQZx3e51PCeZ5GSNrSVuHzNnG4fk7FX8JZwuMK3hwGbkOVkvBK4zZL6fvzd5tdw9Ms6DKjgekgfwKhfaQf5Lmhlck4JeZNEwp9CIfHl0z+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717773918; c=relaxed/simple;
	bh=gUgOgT/LUDLvdZIKyGb+WnQAxfHfkfA+6gjyNtDmWnM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GLzyl936FCD3wkCEmJg/OEBsKrpqz9a26UKJcCHVHAWXlVmQz5g6oAyVkLPzsOlJCi2oTyGplSWDIdZitLU6zaZw327gJ3GAmb0z19fuVP64S4Co4MGxsAem71PG7DwRMH1PsNaHiUr1mCQE1SDpUNaExAsYxAGY7SUBsUgYYeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XTY72xSS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XTY72xSS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78DF9C2BBFC;
	Fri,  7 Jun 2024 15:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717773918;
	bh=gUgOgT/LUDLvdZIKyGb+WnQAxfHfkfA+6gjyNtDmWnM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XTY72xSSg/7E9m4HGOnITOMQoTZ/9UKGbwfwomGNYqCEJMloDcZiS4sN+QjRtq32L
	 2DOlHL4KZ5EmElMGUPUN947AfVMbynSSL/oW2cv9KWNgZkliiKjRS00FFjsvV4t1J4
	 OtcUwRivFr8rcihfMAqoFGkdtwk3JiSqdL7P63OdpPkqdLdAyw9jJ4fah4sZELa0tD
	 XaJWC5092mDOwRD0Gwf93HyhKf9dKmt0jqPdbvrEh5RIZ4bt2b2p4MYWGtmZ9047ZO
	 rfdH6yZGR95/V3LrGP2phYfc8e4WvaFX4NVILt5ndyFh+s+aI97g3kd9Hh3XBhKCki
	 /bO8kcNUJDZSw==
Date: Fri, 7 Jun 2024 16:25:14 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.9 000/374] 6.9.4-rc1 review
Message-ID: <ZmMmWkKDX2GMcsn6@finisterre.sirena.org.uk>
References: <20240606131651.683718371@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ybHuM4Y94k6Vjglx"
Content-Disposition: inline
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
X-Cookie: Your love life will be... interesting.


--ybHuM4Y94k6Vjglx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 06, 2024 at 03:59:39PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.4 release.
> There are 374 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--ybHuM4Y94k6Vjglx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZjJloACgkQJNaLcl1U
h9CsRwf/V0UwEUYV1B5Q9d1KfccCMIxz+Gz0bH5OHUj0rA0+sjwwqk9Fqyqit2Yk
GvdsslnacvqNrfRTQYZYzEmoS9ccTAPe9d5hWNgkQ29OHPDiNKG0FkhxObA5wKHZ
aIgd+Vp2yQdnHyWAUU7w3Re2Tz/WiDoNl4+tCKb/eMDc8OWvIxF50e1yTtz7p1w4
/RWRIBQOlmMfNSJ9hfrUYd76ecWqiwAbrVesTJ2FMcu8WJKn1o9IbmXMauanr3OQ
eJFDNOBgSWkWFrmNGV85W1lkOTBc/YVhtKxjCFD3OJSkKjioBt40/BwHaPeIPH8X
h6zz8GfQgS15rENTfokuY4s6vcsnVg==
=4VbB
-----END PGP SIGNATURE-----

--ybHuM4Y94k6Vjglx--
