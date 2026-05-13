Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DEFE3D413C;
	Wed, 13 May 2026 15:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778684566; cv=none; b=DDMu7sLRR8AMhLpvuTNPh61I+FmsfJItTtyevqclhXpLocIltAaTjjM2dpCJufBa6mHSvpDs+/bTnFlQAFtWBJFsm5uSP1nkiBkRCMdOGC6GOS6Y03+UZ1C/hjF22BTpcBwlj19ixtR58NyE+8aLUjBAHuBsBySBaJSzgRb6q28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778684566; c=relaxed/simple;
	bh=/XSeiiJr5eoVT9AozxVDFtM36fxG0nrnTSRuUepTcS0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qfigz9UhCqdjLAl+6RRTgh9SE7A+GCYeF2JaKXd+V3vyKoQQwB9H4KbxaAkMHOu1h5+YIdaC/+f8ImekQ2AtWsQt8aLcuyvbf77YO2Il3mzWZAO7r2cw1opgYbZAd+g4z2S0+jmoTHjCLsQs2Wd64HnWTBxXmE+y7qS0akoTINQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ycxhpsog; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ycxhpsog"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0FFBC19425;
	Wed, 13 May 2026 15:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778684565;
	bh=/XSeiiJr5eoVT9AozxVDFtM36fxG0nrnTSRuUepTcS0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YcxhpsogAa8hcBo5awcsIsUPIg9jrWd7qlvN+7j/VusRi2x1dbSbxA+Nzxbe+yjaX
	 8MLigV3SM+f3ey5fP64+prui86Gk+Wr2Cl+gP0SKZ80oMAras5EM+RIManBhATm1GE
	 Nib+MVVEney0ayTDyChODXzApQCoxNSXmIrgovTJpfMieqk6VOx7ytBzJdM5C3ZV0h
	 1lLkVS1V7SJ+rNUbiutAL1oRCk6K999ARODxBklKQFN5DrWnz44wq5q9Eh9qkuBe+k
	 P9OWNeQAZnG4UnkBnebzedn5usRV9zbyZ+tIctjl/HP17ZcnpL38nIV9ITWNO5AsMJ
	 iQrfqVP6jyJJQ==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 910871AC58CB; Wed, 13 May 2026 16:02:43 +0100 (BST)
Date: Thu, 14 May 2026 00:02:43 +0900
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/270] 6.18.30-rc1 review
Message-ID: <agSSk1ciwekdqUiP@sirena.co.uk>
References: <20260512173938.452574370@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ot+dvuSws3bXQzNM"
Content-Disposition: inline
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
X-Cookie: Truckers welcome.


--ot+dvuSws3bXQzNM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 12, 2026 at 07:36:41PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.30 release.
> There are 270 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--ot+dvuSws3bXQzNM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoEkpIACgkQJNaLcl1U
h9D6FAf+IqOqP0wLjpQNp+PgjmtKISDfD2sPQctexazfYpTuhlkDOg7X2HkCUODe
7+P/8C8poEGnlNNkz5giIM1oXVcleK7AgFCLsSl3Fropm/Goryqq5nQx8co1QVe/
4+yYgvzoEbVrq81gPbVM7VL+KO0DeEwrwVSxhoH1UN6rO1XcHaJIkaWGYBk6S9gG
fbDQLGQFRzBhc4hc0+X9LjQAuTejm0PedYhQZlJTgfDP1rj/ibLHtawN0KnLY9iU
6o/g50tSyM8dBneOAwHycuLAiCtS91VzeY4mpQf78jQNSw0XtbirZY1IJ5Zt7D7N
T+mEEGuFiDJKdE7TJXoq2+AgzCwlNQ==
=ETgm
-----END PGP SIGNATURE-----

--ot+dvuSws3bXQzNM--
