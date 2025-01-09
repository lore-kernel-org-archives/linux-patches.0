Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31CCC218ADA;
	Thu,  9 Jan 2025 14:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736432054; cv=none; b=kH3iEeGRjqvQzh/2g9UjuTRPXGdAhpIPHbTbLVEfdFOUD2QtHAJaOB+np791m94iWsknlr/u413k+bpOEBgfNLK0HS5n5g55eFG/jDKz3CS3nqM42brRDtJXOYYkYL3FhcckQZlnryAgiDD8Zc0vmY2TmE3rYXjcA00ucu07xs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736432054; c=relaxed/simple;
	bh=A2q005KHmpvWE5N/r7r5s/F7M2MgBoF5xbVtoT+kesI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l32Svk68ZRwPrnIsEnEj0BDhEEXQC+RqSHn2StdYpgSJINxOZN9xHH7x0jwaE4OwQ7fPFsbM/zwzpeFXuBrUG+DKNXTSdTBXNuGq+1dfFoYovPAgA/NMpLdUyOu4iFGXV+9VdZv4RP/HwcVF2D3yTeW4DIuzPB7ihvJJqOGosLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RiYJ9PO6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RiYJ9PO6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04836C4CED2;
	Thu,  9 Jan 2025 14:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736432053;
	bh=A2q005KHmpvWE5N/r7r5s/F7M2MgBoF5xbVtoT+kesI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RiYJ9PO6yG7KBUTJs3GkRtx291/fGbF76PeNgC0CRWh0DbL1ILrywaywHGAOAc9Hv
	 T2hRMEp8474Z6ZewWibkCQi3tA1sB51PKz/c2PYPoy5ridZfcsjLvvMCRC6uQ77zUc
	 SC5eKqXEpfeFqtAhjyMUjtRu3i/j4xvHIqXke0dPJ8GE8Fo0qINvkztM5v0DcgtbVg
	 NPbsyK9SU1H1ALvmebkc9mnI/9yAfCMEaVJjMK3+7bzLrbGLb0cwvJnOGYlWtue4KO
	 BXJvUVDYc4oZ0BCgLlug2GanNSNyFEXtg9NHafdSaX+fAvEW2jr0DM7HttKJJ/vbQM
	 HuVCgcpVT5MOg==
Date: Thu, 9 Jan 2025 14:14:07 +0000
From: Mark Brown <broonie@kernel.org>
To: Muhammad Usama Anjum <Usama.Anjum@collabora.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com
Subject: Re: [PATCH 5.4 00/93] 5.4.289-rc1 review
Message-ID: <800dd2e8-8d19-4f14-8cb4-ba0dcc7603b6@sirena.org.uk>
References: <20250106151128.686130933@linuxfoundation.org>
 <9382652c-939d-4368-a4b2-93798ba0da19@collabora.com>
 <2025010900-camping-giggle-fbe2@gregkh>
 <d42e3022-d0a7-4e69-afdd-cf6911f82943@collabora.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="jgrIvMJnDaRg2GEC"
Content-Disposition: inline
In-Reply-To: <d42e3022-d0a7-4e69-afdd-cf6911f82943@collabora.com>
X-Cookie: I'll be Grateful when they're Dead.


--jgrIvMJnDaRg2GEC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 09, 2025 at 07:10:00PM +0500, Muhammad Usama Anjum wrote:
> On 1/9/25 3:12 PM, Greg Kroah-Hartman wrote:

> >    Failures
> >      -arm64 (defconfig)
> >      Build detail: https://kcidb.kernelci.org/d/build/build?orgId=3D1&v=
ar-id=3Dbroonie:0578e8d64d90f030b54a4ced241ec0b7f53a7c57-arm64-defconfig
> >      CI system: broonie
> Let's ignore this as logs aren't present.=20

That's the assembler error I've previously reported:

   https://builds.sirena.org.uk/0578e8d64d90f030b54a4ced241ec0b7f53a7c57/ar=
m64/defconfig/build.log

--jgrIvMJnDaRg2GEC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmd/2a4ACgkQJNaLcl1U
h9A8Xgf9Ews0Vq4QOsXU6wlCeYsNa9kYGZe8523tIL63uYuigHIB/WskGPxm61kf
0d6uLS3HchsmFag4+EzFed8Ssdred8ITPXdkyK3caVV01oyy/QUeiGzeh76A1crt
Htb2sghGNyyj+OK0ZsqfUr5j1stNoVh7n85ZwvfsP519Y8Msv7BGwhYfvqNYt0hK
YCTNYqO3Xst6USOR0JsfTAfOxUL4gJrtn5D7y1kZ94hgvtAVDf4fla8qgg4uIqec
IFniACMmFMzKpAMjJ+e+SuSueea3RD/fen4HXP18Pve6CbmxQVHcHZGm0sUn2Q7g
js04ZjzbMDjYFo001V6wHG6CbfgDWQ==
=Nbla
-----END PGP SIGNATURE-----

--jgrIvMJnDaRg2GEC--
