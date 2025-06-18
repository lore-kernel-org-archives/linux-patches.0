Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20AD527FD58;
	Wed, 18 Jun 2025 12:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750248138; cv=none; b=OFViq4oCRMn4p72A+FBHVQrjFYs787T7SU0XJPkbUckduGkaAW0WpdghatntsjzbN91HpAuP/+Hm/Q/4Z8uQ7hUVy63mZ352yCn/LJsMheexOQcgWxw0/4IxhdZI/8N1QTQnBillfq7esXzuSSsVJQfLH1Blr3uJst4XuY91zzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750248138; c=relaxed/simple;
	bh=E2oopE+AJdJ2PktRR3Hrrs/UQJrt5Fpy8sjt0APaBYE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GzcMCBUJSiBtHeC6NQ+QPuXTAuy/K8xoQlceFV7izAI5IT3b49y+bql5Jwe1hbHVYR3RMIZiGzyU9Ed+IAepJ604rIf6Sw7ydxtpA19aY443eIHKvOCL9hqNT2WSkZPxATQJWoE9d51QsEVTn7uztFAJqshW4b1RzuI+iBIttrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iTBkGRPr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iTBkGRPr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47CFBC4CEE7;
	Wed, 18 Jun 2025 12:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750248137;
	bh=E2oopE+AJdJ2PktRR3Hrrs/UQJrt5Fpy8sjt0APaBYE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iTBkGRPr/+vQYaVwlSPjwEhSdW4E7d9HSf0oQHW+1WrOfr1erNaBhxGY9yT0xiaXQ
	 DGD6LTkETCUbn3nd/XqofkFVxhRJQBTkewb0fJStgqoN9ybeNhjtSScGXQWiem3Ry8
	 xFjdRHKBMiQ8mBfbI38W0lwhfTiFH5gm18T3OKumSJPJuFN7cEgUGQIDmGxcK7k6lU
	 gV+m49VlWZU4FGB0aHENDVS0GEyIpvmSBldZLAoEYTdGwHhvbOhENGYi+ZwziDuAQH
	 j5S3NIopecagV2FJi6N3cZurlf0aF47qjJx8PLnEka5h1c+/WTo5d6JzpKgV3lE+/y
	 gWL/lupTAeydw==
Date: Wed, 18 Jun 2025 13:02:11 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.6 000/356] 6.6.94-rc1 review
Message-ID: <4cda41b6-bc4b-4680-8800-89ee9caa193f@sirena.org.uk>
References: <20250617152338.212798615@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="1omOcL+gB6VXDFQU"
Content-Disposition: inline
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
X-Cookie: This bag is recyclable.


--1omOcL+gB6VXDFQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 17, 2025 at 05:21:55PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.94 release.
> There are 356 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--1omOcL+gB6VXDFQU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmhSqsIACgkQJNaLcl1U
h9DgfAf9Fe6MS5Wg43nkB18ob9SsZY6MCHNMKRUiJz64X85W0QAN7xqSVVMSDbx7
+ySJ4Q0JMiel72jSqt0EiMAn2mZPIw9xoBlbCM9IYCcu36J+Lt0mOUugBaMAiAxZ
2mSdu9+sEA/dvEZoXRBoDUll/fx+N7RnDhhLnPbAoUc/M+x9PFTzh+C1FGexSd7w
UHtXCwfD4JUDEe//wG4YHdg35Fay2mRgatAmcPQ1Kt8dkqDXb3nlIfR9oRrxdDvE
BLQ9BX6SlM+meVR5v6Bu89oi4027/xyAjzENyivkXyNs5zN/6OBmOvEBW+auQxvl
s9HUvkWO3G9MPP/F1ssUvNIgvivo5w==
=lIfu
-----END PGP SIGNATURE-----

--1omOcL+gB6VXDFQU--
