Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96FA322C67;
	Sun,  1 Mar 2026 12:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772366779; cv=none; b=XXiuQ9YNA5nNUxCmr9hIQa5tWBfVuYhr/w3oioUOCY8NTIOjy6xsVvcUrIodQEij1HoepkxCkufYvLZqE3UkHseF0PurH9HWltwgZRdMKz417ivN14G00HDIk6OeZTrZBcTJeqTLctXYfUaZfh7OVet58f5d1NywBqfzD7P3+No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772366779; c=relaxed/simple;
	bh=QptG2kMMMXas62n0gwRdu16vLLCWQ3nvKn7hOKa+RDA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fh7L38kpetp1fb7Z4uoxdWzDLjMGvGi0CG8N4wWX7axq+7aG1tTdblROEWbe3IyA5X/GEf51cFQ6DhwfpzocwDY7Z6k3M93VWBkaQnBl5tlrVyXX/Ne2PETN/J7Qj+ac+Xpsof486PCacj7w7Lhdi4mMGdENRcpH0xMg9KkGNwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TNvjdnns; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TNvjdnns"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E124C116C6;
	Sun,  1 Mar 2026 12:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772366779;
	bh=QptG2kMMMXas62n0gwRdu16vLLCWQ3nvKn7hOKa+RDA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TNvjdnns0W5r40AxQVktbaTRPou6eWhuzHAa2RPAiH5OWNSi2FwOy8fMbAf8pt37n
	 1k27GZ/+ru6ufw/k9+/tExGg3jJYco96vU+7aoCsvGQwAlq6kQXjTFmv818P8ggXLG
	 shclVu2lDzVtFKPSpek8+TKbr/fd4A6d9J09qnUZCChJhMQYGEVwcaLH4DViYlKtzV
	 qIVjSNludWVfJajv2pXkCW9RSUX/UlA/HW+O0sFqjL4wjVn/CbcG9o7lXZBdwbBZPH
	 9LiGKn1CX5Ap/J0M/Rg3N3DFEaiy7MLNAO4lZXTtTu0p7PwX8/FLoOBfZTuIpyevyN
	 Jbbp+oxNZmaHw==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 8F0241AC58DB; Sun, 01 Mar 2026 12:06:15 +0000 (GMT)
Date: Sun, 1 Mar 2026 12:06:15 +0000
From: Mark Brown <broonie@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	gregkh@linuxfoundation.org, patches@lists.linux.dev,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/752] 6.18.16-rc1 review
Message-ID: <aaQrtxB5lZX7TMRm@sirena.co.uk>
References: <20260228174736.1542240-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="rIJferplav9b6cXo"
Content-Disposition: inline
In-Reply-To: <20260228174736.1542240-1-sashal@kernel.org>
X-Cookie: Think big.  Pollute the Mississippi.


--rIJferplav9b6cXo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Feb 28, 2026 at 12:47:35PM -0500, Sasha Levin wrote:

> This is the start of the stable review cycle for the 6.18.16 release.
> There are 752 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--rIJferplav9b6cXo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmmkK7YACgkQJNaLcl1U
h9BZAgf9Hg12J9P4WgQTd5QGL+Cdl3pKh/MCF4n1ogoZu2jqGtX5MqDk4g7fSkd/
5Itjy2PKDrboSSBrLpwTMPkbl3RcAibKDxsjGgC5eKguEKrrriWMWybvkBfk/sgx
ZBHYrNehW591xsvp6i8NfNKyhJnnnae3Rv7VZB7jj2sizZ9Ic8EJiR/G1DxieFKY
d3jJEgutB+zBYmME+Jxkf0fHVwrfysKHoks4F5eLlt3M8XijSJKYbw1i0h8WJ1JR
iyhxnqGolFAh7Vi/o16hS7NTjBEzqsxcanzP8evang5BvAj33n9zBbZAjYrBgshS
Viyn6G3m11d3KeoBzd38PWKxgliKBg==
=LQTj
-----END PGP SIGNATURE-----

--rIJferplav9b6cXo--
