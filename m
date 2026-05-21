Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51A13A1A55;
	Thu, 21 May 2026 10:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779359596; cv=none; b=ObNq6X3nJBrOOaMohwSTE+Y2cfJaHfuN+1MdeHejqklMtUELnMDmCUc2Ja+o0s+qiHA+RIxYa4XFxXxLG2/BB/WYj9EacVAzTs81x2CTYvJg/cZ7Az7ON/Rw/ImO7cnUhY2Xc+KmtLBGsNEG9x7WnAGSniDpIhQcFR4Woguagwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779359596; c=relaxed/simple;
	bh=dMJLNIj4iVzbepWy4Pdp1KI0RZzJIcBQR+AuoM+7nVY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LqiM0vfVRGI0uXoaZwQXnks6BBbKUVJYjfgmrpJNB/3xLZ0p4r7ciENz4pk2+eX21hIoeH/ZPoM7qBj3ZjEOZKWS69flYnKy6sWQs2mYLmMsAxX2PpOSGoi47W71xn69sLEYwnwTc/Cm00e2MefCH/EF7nTIEOJ0LyyySYz20I0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WgYCTMHf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WgYCTMHf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A762D1F000E9;
	Thu, 21 May 2026 10:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779359593;
	bh=A5OEYEYEb8FTTesHZfLdnIbvhyMGTWGCcnnrrpaVDgY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WgYCTMHfD3d89XzUe+M+3nwkRJypQWHi5lYnIYx5yJdM+/JpST+5nyVz8MCV3kS7e
	 +p4JAiVQTriwH5FAr3FA744zOeEK5zl/MUIHS4KEF1LPci7x426gkHpGfqwTxENGwN
	 zevfueZEdwHifeeCH5mrUupyTK6wc8YUlyDewztkzZkHlJUeW9L/60RG++uiYzEhzE
	 bH6+nMi+6uvVG1O0HDtrbBePU/KbYq5C0JjmiXjEUnepieDuWqRYy5kMFGr1xW/PIi
	 ysVCN+9wdtFQ97dxrWNwsmT1iGTeZr8yXhQ1qGcNtv5begGtG5jsIPqEmC1qh0fSSp
	 e3O52wZh07W8w==
Date: Thu, 21 May 2026 11:33:07 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/957] 6.18.32-rc1 review
Message-ID: <3133fcc7-bfb7-4d1b-8a08-ca426f3642e8@sirena.org.uk>
References: <20260520162134.554764788@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ATGUu+gcoZ9NvSsK"
Content-Disposition: inline
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
X-Cookie: No shirt, no shoes, no service.


--ATGUu+gcoZ9NvSsK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 20, 2026 at 06:08:03PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.32 release.
> There are 957 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--ATGUu+gcoZ9NvSsK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoO32IACgkQJNaLcl1U
h9CzNwf/ba8B6svGtUT7uTrcKKH/d7tCELm3Mi9yv0HG5Cmngu1T3cwg59akGNvV
F1Yb95cFw4sUvVnu0tXIO+ItZvLCZD6XZsVR1VARODWLzYEDtfyZ2pa6GGoGpKGL
Ku86tHY4ux5F5sSWqPiHghYGo3Wwe/xyn5hFeu7zkIX/ftMawZ2zENwxN/ur23hn
js35cQ4GuFbujW2SxWEJZzo4eREZ09v+AX0HpUjZ9IAwjFYzWxBuiWiski1YtR+D
t4l8a62uwVXXy79i6NsTOPzb964tPyl4N3A11LQQZk5OID+7lHnNAKTVMAif49y+
Bc9SAAOMcx/4xQR+tm/DcL2C19zm0A==
=QqWy
-----END PGP SIGNATURE-----

--ATGUu+gcoZ9NvSsK--
