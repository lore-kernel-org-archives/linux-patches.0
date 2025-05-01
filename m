Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12FEC6FB9;
	Thu,  1 May 2025 20:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746131192; cv=none; b=QabccFmBdj1rPirPuEOrRoM9Kwz5jsGoNhbDmJ9sXJorEKfqDGqETVeXyPcTD2B0zlmtPCbXyXIyCbowZuONXVUaIrEVkud2FAseH53MH3U/YDQt3BLI7W/QTCQvq2mlrhqisFJCezAQUxd2le4jo3L8f8emG8aeo3Zp7Tmxu9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746131192; c=relaxed/simple;
	bh=IxLWoBm+FK1NxQ4bJYIXoE8mUtPdRKTP/24EcnCLkss=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UGWehX/J7KHRMtGaUTWR5cM5raxTpJMxTMewjgY0vDalCmeHK3Cl5pjEABnH//C7qGvrq6eflYWZo6OVdCqGqIiUy3YXhnT8OG5FxQUuSlbg8bx0b9V8GchlsPrHzO11XgzEvBW2jU1lW7LRPgghWJ/6C90oQzZw1f4jqRnAWyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pm23fLy2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pm23fLy2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C1CFC4CEE3;
	Thu,  1 May 2025 20:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746131191;
	bh=IxLWoBm+FK1NxQ4bJYIXoE8mUtPdRKTP/24EcnCLkss=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pm23fLy25rAexTSPTHx3uZdDUHt8y1RsmPYsbzrOoQxLnS5/+AttFIIePlpwraE2L
	 WjsP0oUEXfyFhqv2uzwOapdAIEafTa8zLLKiYc8spqnH61kZv4AWeKXSAUdX3srYgY
	 YS9L22X1ILS+9FTPTEOfhsSGK/TRnsdVkrELHJAwsmab6kQSWsRgCxw0gUGKZtE5Lp
	 zkjiqQt7cm1/7/EleCLQfBKR7QJsls7xJy4WebAZlxHlB9hKSIJRhv72dwCryC36e8
	 tMXShYZ8eigpDJ//2+CuSr/xKFDwcDyUvlMva6u8/bVbrNansycL+IYokAsrEzHazN
	 gBPy2PG2dJE1w==
Date: Fri, 2 May 2025 05:26:28 +0900
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.6 000/196] 6.6.89-rc2 review
Message-ID: <aBPY9H0BY4_Z16JP@finisterre.sirena.org.uk>
References: <20250501081437.703410892@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="r7ALQ56oqFOqDOuc"
Content-Disposition: inline
In-Reply-To: <20250501081437.703410892@linuxfoundation.org>
X-Cookie: Well begun is half done.


--r7ALQ56oqFOqDOuc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 01, 2025 at 10:18:13AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.89 release.
> There are 196 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--r7ALQ56oqFOqDOuc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmgT2PEACgkQJNaLcl1U
h9AEDQf/b8J+ItIivN+uVJFvrJW9P0pQSwGXx2ykFx19oa5oVV7qtvXsQdEN1HMG
dIUHMbQABD06GN4ugY8AOeomOByPANmqe3GtcLVO3s+K+md3tt0hdoni3d6dnhur
O3j5+iBwv3j8y5RiONd97qcSigjWVydTzTbxlcS3etBVBfKkpO8dnujPdVlloglW
9YhKu0mmz+qQwbENQzBMhH+uqbhDAJDYp7qyOzMVlK0XoW9QZvlq6MZ9B7j/CSRH
G1Qfu4ZTqwwOTBm7D2YsYgBAnv8vBTmW3qTEN9Xb2bpz8uDUhfKsqQGdiaFUcxXF
0TRMO8l0Gzfz9ZYSzIeHzDbEtzrwqA==
=CoJt
-----END PGP SIGNATURE-----

--r7ALQ56oqFOqDOuc--
