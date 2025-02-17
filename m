Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80CA2C9D;
	Mon, 17 Feb 2025 00:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739750487; cv=none; b=UCnjLEbIR8QnNZmvaNvGM5NrY1ln9kN1e5kiaIT3keSaHMUWygL3yOTshRLOa69ql2YqKJL0EBHty6FP6dEvsqwj7W3/emBQAancfPFw83Mkp9IQ7VUbmJ1xql+bPiX67r2kWnP3/riPPqOpxxEglriDUAgAFSi8Zo5sLpsj/lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739750487; c=relaxed/simple;
	bh=rM5Eg4SppaODtxVUfGrqMkASGH+JxSroSn4yEaBQ4uk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TVSPG5d+UtrdIweioR6c1K8rTHs9B/W5S53ptKY0Q7uFs4/7GNGi48E1Wx651ge7CxpHaspyRtv2HvHREHHhaldGhKTl57V36AoW/exHH+Zmx25d9pubESPNFQXcVfBHTmzaQkz8GjyyidWLdrCRI2w2wdTo8ZNPZJhIYm4jxBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SxMBvSxv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SxMBvSxv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A79BC4CEDD;
	Mon, 17 Feb 2025 00:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739750487;
	bh=rM5Eg4SppaODtxVUfGrqMkASGH+JxSroSn4yEaBQ4uk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SxMBvSxvJbX70duXxH7qL6U8SRCQ4nnkAh6Flab2bM1+L/pVlNkXj9QKEIAaGYKEg
	 +XAyw8NHQh8K48PL3Z/55bz0r6IKYHgFcMDWN92XArBKQA8iWGcjUsGRUjOSihJGfy
	 mbX811GRZ6jDf2c8fLfvpbrFOfEVGDIsm4Tz1kXhZmU/1a2xCQ5okPa4hcvcbXJoUX
	 z+GoloYGtGgU0mqZ962umIGOGcUb+VwH4j/2ue1/9SnkRnjRLIb2lyfxkGjLtxHjCz
	 XItNSdudsYs70AAG6nEN3HbER7dQti2Qh9BoJXI3irNlC5vvQRokXJ38SScKHE8YIh
	 TMcbLwGsd4Veg==
Date: Mon, 17 Feb 2025 00:01:20 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.12 000/418] 6.12.14-rc3 review
Message-ID: <6a6cafcf-bc5f-40d7-81c4-fb266ce719db@sirena.org.uk>
References: <20250215075701.840225877@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="8IRrno+RfDNBR76a"
Content-Disposition: inline
In-Reply-To: <20250215075701.840225877@linuxfoundation.org>
X-Cookie: This is a good time to punt work.


--8IRrno+RfDNBR76a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Feb 15, 2025 at 08:58:57AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.14 release.
> There are 418 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: MArk Brown <broonie@kernel.org>

--8IRrno+RfDNBR76a
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmeyfE8ACgkQJNaLcl1U
h9C22Qf/XMqxsq8xI6d1VA3RZhLueWO4hwczELNCAlzkkrWeYYK84Fs1u5Kl/C90
2nnBlwYgHgATcsQ6mwJe6VwhaYFIQVFUmsskZm6+OkwdMBT38Mn2YuxvwRAx5hji
YL+M5bjpswPkkTOjF0RPvWxV0nL7q/sC7Emlr7H2t5YsyEyyeqJVG6x60fIoGK7+
orG5A1sg9hAivlUxmml7jJgyQUasDKO7OehpzXTP2jv5bryq8P7KQLtnUgVXXeOB
yApG2gV4f/7Be+pM0kMwMgx8nhwmtoAGsaouHs2AHDtiooh11eZzyl9SMWwygkt8
Q9fmG9YTc+BTyg2/9L4FYSzFO77/MA==
=CLhX
-----END PGP SIGNATURE-----

--8IRrno+RfDNBR76a--
