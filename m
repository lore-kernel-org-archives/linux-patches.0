Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5801C8C7;
	Wed, 31 Jul 2024 00:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722387268; cv=none; b=u+YvbtAOHL55cxuckopSTBD7vjZ1ke9pO7lWY7dqZFF+7MOnPn/XDUkOLNC1I8ssKKIo78dzhqExmXi4yewyZF4SDTRfdVCYuHewJZv24UXSrrE2RRDX+0yPlGQHIr5xyzMBAsMQOCNgMEGV6I3UyepGGUugFXj2tRnkAlr9tik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722387268; c=relaxed/simple;
	bh=sNK1q/hPPhJzRGBRVR4nFgGZxEucNYGuSj6F6L8vNOA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tio07r5CSxuTCEO84qXedNg4gEas+AZ9zvhA3QMdM3hPx3o6oIkPcKCzslxNXdRBDCxWj97HHGvD8tLYDECWXTCFHQYgZkv3Q1V1hBoflJHxUse3frkJhpWnpTV9hWMIuvXJBYfCE8BKPTnx/G7onQyZBICvs+rwaSzxcId3ucQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sjpx7Il8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sjpx7Il8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C601BC32782;
	Wed, 31 Jul 2024 00:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722387268;
	bh=sNK1q/hPPhJzRGBRVR4nFgGZxEucNYGuSj6F6L8vNOA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Sjpx7Il8Dp+naWxcnqGCe92P2EmvPrYn9JL14kcPew8GmBZ/L+HEtHtu2vEUrUwz3
	 wYYIxcMobTdXWMw+gLEnRTyTjrnDdn6Bv5OJJMicbWy+/H5vJUOIxnjR5sw3TCde8m
	 DU4TD74rI6YDyYXQIrnt9lKPgeLjFWRjmAjvBNeicKiv4ZSu7jpsNtyBOXq0xUA2Sk
	 lcYgtY1jjTwVM+IkXTWXwvmnEpDp+CDdK9rPeXFzxVJ3djz+6uDYGIygJs2S+ezX0g
	 LmbgnEjpE/y+sTFCHerOdubuHTfkU8Y4GnO2O/77her38grJKt1NJG30cXK7FyeTRm
	 YpPFVMpAQ1eOw==
Date: Wed, 31 Jul 2024 01:54:21 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.10 000/809] 6.10.3-rc1 review
Message-ID: <89551797-0561-42c3-af6f-7d4cfadb4452@sirena.org.uk>
References: <20240730151724.637682316@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="MGUMh83iBNVXp0ET"
Content-Disposition: inline
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
X-Cookie: Don't SANFORIZE me!!


--MGUMh83iBNVXp0ET
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 30, 2024 at 05:37:56PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.3 release.
> There are 809 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--MGUMh83iBNVXp0ET
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmapiz0ACgkQJNaLcl1U
h9C7Lgf/XwfpId07DqJjRuqY3NFHqFWdyKe12u+/QSz/ihr9VMOe/3UzBGEUFS8g
sOcOcVlavhdHx4f5GUTklKfdtYFXKuYk3vRsqqzyvSkZU3YkSm1EqG4CV7v63pMU
eVkJzQe4Lt6WEcWFRA8HcECYumDY9kcQyd+h+Y3clfYoFAMtg5+7M5kCeFXCNz7i
TANsCm5Rzo7PzZVaguMaciJi8mklIAoc9DR1UBxxARzXpTtddr2CT/cpo8VzaIbK
28ysHEVmRbTkVGKttWppmFJarO5J2JRDp1gel9PJcJty4kv64CTZ+L7KuwqX7r6D
udmYMfau8652vKcT23Odk7o2zBg62w==
=Ku6b
-----END PGP SIGNATURE-----

--MGUMh83iBNVXp0ET--
