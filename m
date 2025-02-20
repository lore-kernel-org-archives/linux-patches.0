Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6638735942;
	Thu, 20 Feb 2025 13:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740059514; cv=none; b=B8CKoccYHq1L2rpofmSTxeR0FHZLt9d+7x9qiJDPRFXDX44jyb6TRPOljRaV9LVyqDHe5ySgvhXNfFCVQq/MzJjX+bGLSGltxmywHjrOvH3KialCYtKCSyqru3L7FWwB3XgntpV+mc826CXNLQVQPhRmqL5TW0z8Ay2rYRFFIYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740059514; c=relaxed/simple;
	bh=rDJUlX+QEJ9KJ+mWc8LtQbvy7UqqnfUgehzBbPykXl4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EXM0lxGeyFtsRfEMZm5jqo84R0AvU9q4sMswwPwkQ+ExDuqsIlhRnovTrP+huOtBC1D9Y0vYD6e6BrcTBo0amgwZ7P9PohY5+CJ0aFuIjSddw+qzZmVbm/olV56/SVU1D1DQTwSGnWiBG97dRUinAbOXBvODSkSAVHc8iqHYRzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OUBuTOq0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OUBuTOq0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A1A1C4CED1;
	Thu, 20 Feb 2025 13:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740059513;
	bh=rDJUlX+QEJ9KJ+mWc8LtQbvy7UqqnfUgehzBbPykXl4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OUBuTOq0xq22GqFdC1+jb5s32tEM90DnQkFAft/tbn9WfPrZESqQTUwWrbKDQY9ap
	 uJ+yiQadhtwZasH/E7RsMd6RqEe92mW/WeFhvsGCR1L2wMPs6qshRKzrcKafavcS+E
	 6Hg7VDwjWQ8gtHU1Np33c6pKwTy5Kuyi+9Q3ApkQJVzMrqdfNSQTmLIfha912gct2S
	 Egr2AA3r/Xm4clZbodlQMAlngzAM02csDhOe04volXO+Zxy+s9gdyD5QKAcRfgO6Cb
	 pIt7Ez5NcwS074INK2hB7ttOiTNJ6BTJ0hqPsAgfOPBK98FgfCuuk1aBgCipqz/vfl
	 QZ/kaBK7DBITw==
Date: Thu, 20 Feb 2025 13:51:50 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.1 000/569] 6.1.129-rc2 review
Message-ID: <Z7czduDc47ywPzXm@finisterre.sirena.org.uk>
References: <20250220104545.805660879@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="1bdC0VFFraiDunUr"
Content-Disposition: inline
In-Reply-To: <20250220104545.805660879@linuxfoundation.org>
X-Cookie: Editing is a rewording activity.


--1bdC0VFFraiDunUr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 20, 2025 at 11:57:56AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.129 release.
> There are 569 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--1bdC0VFFraiDunUr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAme3M3UACgkQJNaLcl1U
h9CKswf+NeZN+z+sFi2xjxLXJXHOS3wkBO+IzTdmz1Bmr2XtC7pBXaXrvWhPu3vT
KmoZST4M6XdmsNCfvbTzQWPwe0dVJ9DJPgA47mn/POKM4Gv8zzO3YA84CtS/JVe8
PkcNb4GjGdaNY1Npk4ARpkMRQRGRFl2ucIn30NA5kjshUs/6+zsZIf7lla3SXcJ5
DQSaPSM5ohf52Fl9jN/aGIWPzAmMwsFYhLQLcaYPO6bb43/G36JDxFu5KleaYNoR
Yzx0lCMiHikJ1EZ0ryeToLM51no69Z3wvP+MYUXJzkcLgYjyYh5yuURMFFltam4O
ck1Jh4v/sFneZG8I+54lF4VEgkUvLQ==
=+3WX
-----END PGP SIGNATURE-----

--1bdC0VFFraiDunUr--
