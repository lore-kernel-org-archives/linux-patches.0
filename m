Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F761DFDB8;
	Thu,  7 Nov 2024 14:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730991319; cv=none; b=ZMRnql0ifdCHCObUXbOqJ2rhFVoDE7x4WNcHoLEOge/PeLdJ6AVRpviDB6XqxjVBGn6CGAgedkzVPn0zWhOA9eXzab7iVFGH7oULR3AiV5h5k/XlKpu1BxDiy/jnxKxiKo3iNuj6guZNc306YHXH1IQQ9NLJX7XGyErv0479c8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730991319; c=relaxed/simple;
	bh=K5+gjFHFUygX0x3HkOo96uYxYFByfgO4woehcB3CLcE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LToLFlk6+AC+nJxjKXOVCaCmoDlSm86MBlEPtmX6/eRGRkt7Qscipq6sr/jogMmWdFPABqEmNtvAJ2D5ZeF9HA336hLw1yNkwCVwPgduszwKXay+SvaiyhG1EPe3dsZ+unLsTvIBP4Ls+/xyywvjm339M7w1pXaFK/RXhfZv5JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gwabX0Bt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gwabX0Bt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DFD0C4CECC;
	Thu,  7 Nov 2024 14:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730991318;
	bh=K5+gjFHFUygX0x3HkOo96uYxYFByfgO4woehcB3CLcE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gwabX0Bt3r9b/wEYR2LijvJ9TbY6clKCOV+tUc8Uz7aIdmmksaSERHaKFMq0DnKS8
	 ZDKuHgspcp1t3w6V5jVEKCyes+oN7Xr4KX9HosFYNuU6QNFlEV8Rdbz/k1TRnlncsQ
	 Z/rg2AK3hT03kdyageX10zr3112y+mvFur5OJs+ZtmSKIjB2N82SZr6Vt87phG+uRz
	 oxBKWy/qgv2WJYnmKuA8oSkN2LGHHB0QHih9Y6hH8UHdU6VZPdxTis2MUTmf1kBGP1
	 JhgOMgxnvZV18xlI47L4zP8dEdNpPvdbyBmWNr/piOiX+pMGdmBiaPMHsQEiJ+AHQx
	 n6TFcgbCt/4aA==
Date: Thu, 7 Nov 2024 14:55:12 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hagar@microsoft.com
Subject: Re: [PATCH 6.11 000/249] 6.11.7-rc2 review
Message-ID: <df4c9a3b-7fb2-42fd-ab10-94cfa7e70979@sirena.org.uk>
References: <20241107064547.006019150@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="IUTVW+fggAyrcTk5"
Content-Disposition: inline
In-Reply-To: <20241107064547.006019150@linuxfoundation.org>
X-Cookie: Professional driver on closed track.


--IUTVW+fggAyrcTk5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 07, 2024 at 07:47:28AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.11.7 release.
> There are 249 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--IUTVW+fggAyrcTk5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmcs1M8ACgkQJNaLcl1U
h9Ct0Qf/WZL5vpyyXrZS9JZqKeUYwjJtFkwo1GFXPKOSBifK9MG8hmHHQVLbLmj6
VUuutYsYJgry35r4NPCw3mGTqg+P3zyY3MIDPZYhXlv7figi9a0NabbHe4QEC/Ti
0ExFu5oIuJq2XfWyzG+1WCpURuPNVh6+wuv+POg6ufnN37ODQu7NjMOyYDqc/F0H
E71YdviNzQ+ljILNxZeV0GstCmjQ8ak4L8vuJoC1kBN8SkQqvdR3QEz0DLy/hBxz
WrBhu5Uk3jIZsycj0NkSHHt59HmY9v8TLXh/MOcF3w+JTjQUgrPXxIQGtNvHukvJ
MjCqfOVk6PZ8pggPFl3u0O6OAWoR3A==
=PX4Z
-----END PGP SIGNATURE-----

--IUTVW+fggAyrcTk5--
