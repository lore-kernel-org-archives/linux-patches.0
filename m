Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D802E7F05
	for <patches@lists.linux.dev>; Tue, 11 Nov 2025 08:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762850821; cv=none; b=FosCe/wvZ1DRXwx7g9oo1gf4NTCOT1DoF7Zu1n39rJzl4a23OW9Kv+qlJaOju78v74SRZCCXKgXHV0BUIrdQVhED/8sOZwOGC7S7g4EWWSMmInZ8i6C16w9kpArXZxE/XCY9mRpI625bnLIyfey0z+hfpgTAOjuzO35WjJjaOnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762850821; c=relaxed/simple;
	bh=Gz5X3fmHdQqpzyFV0Aln3wmgksKN8e/3I+kRRkYmfiA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hR+o62mc2FcVjV9pwFs7OMIr99mbCwXlIt86oi190jxm1KnJI3mpmfefckjG3HsDjitdLsva6W8KBgfnQh1MIw2Mcj+ILXTKWwMRB8AL78m/y6C1o2qgDcQKEwtjPovRnh0BxuWUU7M+YP0vnvfeCLJH4FMvzFPGH8dDvNZDm1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=YD7qWuJS; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="YD7qWuJS"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 440B710036B4D;
	Tue, 11 Nov 2025 09:46:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1762850816; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=1JgHppPRtM6VJD9PYop9Dotc/XyI1oRdh8DQTwAwgus=;
	b=YD7qWuJSlDCmBGdov9uxJAyZVF9DkEEs+oRJiZsC0uN80fHCJiFgG7O4g2NuBQau7vnQxe
	DAlPrazewFqZ2iGMZbg6CpXTy4qv7FAnU71Y5AH7a8L+YgRW68Vq/A/YT65fIsVlDXZUrQ
	AB3W7gUnB0yoT2/1Uh8QfeYMB77EBJbr/XLWtfMCmhYJUI7xmZQSthZPBiGyP89zlyCprk
	FEcLDA0Ec6cUyUuPGq4VyI+F+f9gF64ua5fJG4Tb6GAforl/moNy/t+6vod9abdpkvUZni
	nl3iuwRYIP890OLHAuUakZMDgTP01tOW1uDV10QTQ68UfAic5HzbCVVePJfrtQ==
Date: Tue, 11 Nov 2025 09:46:50 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/562] 6.12.58-rc2 review
Message-ID: <aRL3+o1W09KxbCwP@duo.ucw.cz>
References: <20251111012348.571643096@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="buRHmNsBF7vAjqWu"
Content-Disposition: inline
In-Reply-To: <20251111012348.571643096@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--buRHmNsBF7vAjqWu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.12.58 release.
> There are 562 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.12.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
In cooperation with DENX Software Engineering GmbH, HRB 165235 Munich,
Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--buRHmNsBF7vAjqWu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iFwEABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaRL3+gAKCRAw5/Bqldv6
8rOtAKCPmCtCiWgpjTwSUv4jwNI11yImkgCVH0pnqlayRzRQTMltTyKhWG2v0w==
=fm9i
-----END PGP SIGNATURE-----

--buRHmNsBF7vAjqWu--
