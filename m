Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B7A26BDBC;
	Thu,  6 Mar 2025 18:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741284497; cv=none; b=pUG2h/m8kn0eQAxIo+3VUf0p7rJBW7+cl3Qvuf+IApeKq2VyLnWmj9n28X6nX+ED5V31j0yT3+noTq2+YnfwRcx+vTcrLdRwkeLql89RwE2gRg/lXsImee4sohbKFkrVvChpi0KRsk1yjLlB6eBD6dlrxwqdinMqTNXZ7T190fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741284497; c=relaxed/simple;
	bh=vnQaN/qxxPA2ii1NVe2wlYHRUmqVqeNn54F4JWGaStc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gSc+LwZGsoZF5RgVTUx/9erW4qNquFBvI7SpxZcgyyuDuPGeO1AzQKD04uzUek3cybEKkwv1YWXYcOjBya5LD9UGWPNXDAmmlnPHUVHC7OlhE6gh5PYWym0MPp4Odttz7Zjc+Flbbn6sG7zFr0u1ZhA+LiHPyuHuUlzX+RLLRbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nvwl4xwS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nvwl4xwS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506AFC4CEE0;
	Thu,  6 Mar 2025 18:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741284495;
	bh=vnQaN/qxxPA2ii1NVe2wlYHRUmqVqeNn54F4JWGaStc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Nvwl4xwSvjkljsRP3f3kBgF5hHuWZ0as8X+2wuue/0mNzPTN5U/EzoA2nja4d9OVX
	 OulwOipU4pmhRw3uwQ2QgvUweaQ81woD8KXAr8J/2sHnb+AJk7vLcpiQIoUxFs83iW
	 Ao6CPSJGPM9q5XfrJjS9TR/8HFWP2uynX4IqHOEWoIpbckjbRK7/0r3AcoUlWSaGwm
	 WIvrj0ynA+eEw5No/E/iPK2+jLKNc3RTNXTeMv90YGQ6tOmUetOMwQyJ5mohOR/1VC
	 uDDx3yzIuVHwwPmrdz7b7av5YqqpsL9hT1KaEAlYzC3lryYIP60HxM0hkCWnQJXpPF
	 FMtYetaOo8wqQ==
Date: Thu, 6 Mar 2025 18:08:09 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.13 000/154] 6.13.6-rc2 review
Message-ID: <ac2f6563-6cf5-495b-b7e9-f65d5f501255@sirena.org.uk>
References: <20250306151416.469067667@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="QGqYIfYqC+HtPrX0"
Content-Disposition: inline
In-Reply-To: <20250306151416.469067667@linuxfoundation.org>
X-Cookie: What!?  Me worry?


--QGqYIfYqC+HtPrX0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 06, 2025 at 04:21:02PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.6 release.
> There are 154 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--QGqYIfYqC+HtPrX0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmfJ5IgACgkQJNaLcl1U
h9AgEAf7BLGDQ8x/fTtEGi0htpXNap8PeuaFNhyX+Ax/1WdX++Yyk2MOrvHnAK2X
VHdqm7Q+glIBrBx7ijLrFLhg+PDBV5Vi/onSJfJISRfw/Dv9ou/HPYgKjucz4TPU
CaCQc4RCPU59wQT1wIb2KDYwB0WvLOW9HWqgxIxe7VWQM98vsGmRT/b5M+U3ClBn
A/JrYyxkyKzgl3YU/Vyt/l2qYiLcf6Ez3W0BsM9fWH5jNgzw8oMgMKWxgOfk059q
5/qrHkxWpZzfc2diQAWEYXCDYmvRYs0vrE2LIXAz5LECbGiKQuhpCNUc2rLdzx1a
/NrRM8p5TW4WpKJ1CLfau5F3+Ezk2g==
=xcXi
-----END PGP SIGNATURE-----

--QGqYIfYqC+HtPrX0--
