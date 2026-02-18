Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7001C861A;
	Wed, 18 Feb 2026 11:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771415980; cv=none; b=NJu0SGuHssjEukOfbr1uFDNzzgzaJthUbka4kdHx+AGlIFNTxTvRtcYW31+BBDYjhhLx3AyVoXf01EDCu9RdQt0HMNtv9qXvk1+qAWL34/Sq0CT+warQI4clKD278P5fbUcWm+qBZ90YwogQ1HOQT6SRESqL7zynhXgwV2ndFhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771415980; c=relaxed/simple;
	bh=n03qZT3m5Y4n7o0pgjPPIjrff64cnwK/vFPHNdq+I6c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c4asANL0B24ZiXF/Dv2tFnty8oMd9/SoLkRVOaYf0FM3fpKKNKsgihSyPKDIP6F6BSEoQ1qp22MDicF6SqXYDT2kju/oNK53wq/aDW+Nag8V6k8TRCAxhNQM2ST0s0PffUjp8a97mmiLFPk6mNuSuntI2+GCmTYoefegCz+DZpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=arZtFPHV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="arZtFPHV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71662C19421;
	Wed, 18 Feb 2026 11:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771415980;
	bh=n03qZT3m5Y4n7o0pgjPPIjrff64cnwK/vFPHNdq+I6c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=arZtFPHV5mBR1QrUeRCq+4/tWaGMCDQwqTTfXhvKRi2gQXgZc4KKI8Z0khgRhDLqy
	 eGBaoNzD8UiRZVFe6s4oQVoZ4J1tb932lbNEmaJAcP31NneK+s/Hf1awvqV2Ib9eOE
	 XTiZ0uG+EwAplF2MGhqfBasEfwRtNANJCJrYnQS8dJKd5zjM4pXFt2GDv1VFCFmeC7
	 Np3jUCDPopnjKFsHT5M0sW4PhO7KvnZn+9Rr+CgeFdscPh41NYtzaNtUPIm4C2fVxi
	 HVFil8eR9FN2IvgRiYirPGHAvox2OwtMUxFDlAwOSsmqQs2nKhwbF9z6JsGM+ANtpm
	 LK9DKAtaKuAPA==
Date: Wed, 18 Feb 2026 11:59:33 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 5.15 00/39] 5.15.201-rc1 review
Message-ID: <19783e65-c0e8-449d-ac54-5f30b22f0f58@sirena.org.uk>
References: <20260217200002.929083107@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="eMf3cfOT8XPNaiGf"
Content-Disposition: inline
In-Reply-To: <20260217200002.929083107@linuxfoundation.org>
X-Cookie: They just buzzed and buzzed...buzzed.


--eMf3cfOT8XPNaiGf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 17, 2026 at 09:31:09PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.201 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--eMf3cfOT8XPNaiGf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmmVqaUACgkQJNaLcl1U
h9CiRQf/XmKdqYnzr5U2hvx8H3wfylKRzZMpFjcP3bWTvsmnXB1/JDe6D9rMQi6Q
wVVGPRo0EzBTaF3eU0XP+unI6CLzf7RcbLvQoqlEPSgBi4hwrK9J5Rg2T0EFImoL
+o8FUtNk1GRFRbLNqxjiFBCye1o/od5NKP4/y2xnH3Jz4jSMr8OI4J5ptYp2GMLz
ImircJzH5XXs17+93GMr1BEpwEStiObdF5TG5iarmkMURE5Jjo2GFuMVcGWWAiH0
DX0+755RTuDt9Rx2qeMTojh63xhLZEpaCIhjbx22ZxAJgNeyXGwJ4NxVi+vUM/H2
CWKnLB68pUM2u9H23wETe5J3H6BeCg==
=1r5z
-----END PGP SIGNATURE-----

--eMf3cfOT8XPNaiGf--
