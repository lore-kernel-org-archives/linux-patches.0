Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F4792595;
	Wed, 24 Jul 2024 11:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721819455; cv=none; b=PORc6Ox4TOYPBmx8i+rpmkkc/5ay64YjmojH4z5ZvBFW0xlBGie/4Lyn2veqT+qEomuW+AouylAvFUj3J8lETW1C4JFw+zX/2257pefo6TDV5lqK9nMVRFobrClxcaUKwmawQckjx9biT0HJt35hA/s2CWiiKWP/BHmYfW6K+C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721819455; c=relaxed/simple;
	bh=u3922YjUI3U+8yFgd6dbNIPlYgOaLgmd2jSn7pIR0Hw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ISO3faqy0o7TTXEcWCDf+nNTZDgcMPKkHv+cI/qlyuBSMvDfNG3v9fBBJoCNsvBejGyN4ZWbWNCpIl3Dx6LFR1HqCRy+fR3HR1pczbr8b64U9YTAF3aIknrHwHaUqZAXtQCNlPX52l5CEnxfAQOzaRQIqs1d9OI442zybBE/uSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kgcLtUbf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kgcLtUbf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF8AC32782;
	Wed, 24 Jul 2024 11:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721819454;
	bh=u3922YjUI3U+8yFgd6dbNIPlYgOaLgmd2jSn7pIR0Hw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kgcLtUbf6aABxmiwBrcQ6N2i4/sRSZjAKjj8qbo8lk3eipyPrlTJGhGBUQqRb6NZR
	 d12cu1IEwpCVM4T2nGlic5hRtzTuW4UrxNMGaoFWDRFH1J9nRjSVNfWBPaSpi2GS/l
	 TmrTqlzwTzwogO0oeV3malAst+Bx30ROJRps2UL1r618h2ULvDc6vIYCS3sCHpvWH8
	 eGC9ir0zh9oNAeUKOQrvGfJdgoCR5bgx9MEC7lOaoD5XTHbl50J4viP+H0QRAbe5AT
	 DW92jFL0Upykj27ShjIUUfF5VPiZiRo+PNcNPNNBHzGEGu3iNV/apkE6UWtSDoj9vW
	 DRtJUiwCV9HuQ==
Date: Wed, 24 Jul 2024 12:10:49 +0100
From: Conor Dooley <conor@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/105] 6.1.101-rc1 review
Message-ID: <20240724-laurel-abiding-6ea761df152f@spud>
References: <20240723180402.490567226@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="zs/BmGvHid2XD7Vc"
Content-Disposition: inline
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>


--zs/BmGvHid2XD7Vc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 23, 2024 at 08:22:37PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.101 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

--zs/BmGvHid2XD7Vc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZqDhOQAKCRB4tDGHoIJi
0q5kAP9m9/UZCIPhcn/lehZq365M/SlOCcgc886Sg0TvPV4SgwD+PI/MeQ/phfqp
5fJgHok1E10eLFuMZ+PMfXaatc/lEAc=
=HllT
-----END PGP SIGNATURE-----

--zs/BmGvHid2XD7Vc--
