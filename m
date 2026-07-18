Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F9E36CDE3;
	Sat, 18 Jul 2026 12:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784377711; cv=none; b=NQSHFbVaVD22T/4vYKOmveh4KaKVNjrQa4mWUr3kmaw0LLnxfVxqgvsO7mTuNVukgnSd0xL5uILNROxE+If1NgzGnqiUW5Yi1Y+DfB9e2+wY5HJ9Vh9MImcFaSJ0vDYQ+F6/RHj1GMVWqcAD4DWkjh+7WOCS8ezt1qa11t4LtAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784377711; c=relaxed/simple;
	bh=HBBqp/UpK/saHbExuFiOgU7CK4MAMnKNPLN/+CYf2lU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PHuogxdJ25wG3+e5LuHJ5iGEN4XqhVMflZ9/LB1CHGa5Bc9O3je7Tfe0DGKR6ZfNtDne8vtHmlOQzXZWzt+Q2AQzVriF90G/7A3fmSetftuyzxcT1bzymbKJDzAlgLlcJI5E4ifw8TNc1+hkB4dMlsXCKrTbmQArvSZZaRoxClY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KRdSwNRZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KRdSwNRZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0CCF1F000E9;
	Sat, 18 Jul 2026 12:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784377710;
	bh=Uw5d5ebwVlzoiNKU5qSUHIUtMEJb/SrzPykd+PAuB2c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KRdSwNRZB8jSiaQWVZSI2Z1uNk0dMBPQV5staUWyN+MojZhUKWP16vpOZrtkGkNu5
	 wKQy1HvTz92KiknU5zoWIn0NTXPcnefV42B2RErboqqer/kOLvbRb8BGqm9F8BI6e+
	 BLWcE4t/I0HdC6IYW5f9PONezvJJ9AfqA+1RdFGX4pvRaRe5WsgVufJeYPihv8d0B+
	 MbQ7awq9TRM5D2f7Ln4x1/60uPJjCAvUh24CDsZNQXEy7matYmRV2m+uujHhwMrKd2
	 sX5y24HOYR92EWuqb9K4RBg/2ci1jUgUz9KpByEY1xYqriWH9IvPH+MZ2cdcQpXtg1
	 N98TS2rSU8xmw==
Date: Sat, 18 Jul 2026 13:28:24 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 7.1 000/533] 7.1.4-rc2 review
Message-ID: <0799f4ee-8b7d-49f4-80d9-e0290b99601a@sirena.org.uk>
References: <20260717101912.682013354@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="VZnJrQvrpCeMb2Z9"
Content-Disposition: inline
In-Reply-To: <20260717101912.682013354@linuxfoundation.org>
X-Cookie: Do not pick the flowers.


--VZnJrQvrpCeMb2Z9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 17, 2026 at 12:41:50PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.4 release.
> There are 533 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--VZnJrQvrpCeMb2Z9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmpbcWcACgkQJNaLcl1U
h9CasAf/cJcRdiNjHIhoEZg0xow8xCJ65a+wvM/fFnzp4/Opj1ulF1sitsCrMWTM
XWvi7R13bi8Z3PTpuZ66JcEmgdRJyfO2yeHp3A00HO5L7fgmsZ86WzPFJy+WxazU
7Dh5Fs2CbjPoZX9KwvHQEF0R21r/4egyw1nvwOBox81pqKE3x1dWTSIJMro+RxTu
lzPiqRoJ7lcb0jbAin/tkTmK9SWUnhnu9YX9dYoQd8GJkD1n+2MNfw/9+5TVBHoc
7zx2YZ5WX70mSqxXlysnhsLgvvnFnIMqKe8SeiEJNW6FSoyFOaJSTYdmcYb68/xt
2r84rUXD92qDK9RLv4nNXvAw5KFDSA==
=/NgC
-----END PGP SIGNATURE-----

--VZnJrQvrpCeMb2Z9--
