Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B03225771;
	Sat, 22 Aug 2026 12:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787401170; cv=none; b=jXClOUThKlMv5knvgkuPq/7HOjF8Uk6xkwJ50kYFUI///Mwy+wNM1filXeLN7omCulM4Ba1rFJQEY1byDB0EP6O88+cZ88knXlcHKLN2OeN7Dl65Yet5XFNka6yKGPAeCUX29ytb2LB6X3nEub0qxkiyWN1a0kXeH+rV0Z9ihLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787401170; c=relaxed/simple;
	bh=F9zkF8wSwZMAEQ7b9QTG77WB1yPw/4/z9ZDj1nvI+wg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V3qzMcPY08wbpB90ApMYxczlRVq7q+bNugRo1H8S470rnbr35vT6py+sLiwTehXUqc3yWOsQFFXyKTs5gRELC/l57n26nq38fHjpsujE+mLdyGZmmgKLvkxVCh74MN2EdqfeIq5akYI2zTTUEs5kh257Fsef9oaLJMsSBNmhL8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B/I+Up/r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B/I+Up/r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 898A71F000E9;
	Sat, 22 Aug 2026 12:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787401168;
	bh=gU3TkMh1Q91RxwK9XVxnEROCL4g2AmZsG1bES6GBA1g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=B/I+Up/rHswWoQ1IG8fCntZjLyi5QEL0U5OYB94bPexy1QruYdwilm/SClZXQIx0G
	 V6N83SshwzgQ56ryQsh2TvoKOod6WzEGZTw/Wn21VdVQViMjXYHw/6EdDX+zMDV+N+
	 410gWURZ13d/7yUOIn8pNq/it21ieoj6FXJSgRKWU6kzwT2s/VnLu9icfIPrIB9xrJ
	 VI+2zsZqBg09zatkja752QO8g0JbkvcVigxZOhKAz2dlsdO9wWKpVioEACRjjIb4QP
	 e1+6fhwgg139oD5tqRFjEKz49JsIhrq6gRK/bR/txUGK3TutklAZ0tEDIT1M+wkAlv
	 blh0jj6X5TM4A==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id ED7041AC527F; Sat, 22 Aug 2026 13:19:22 +0100 (BST)
Date: Sat, 22 Aug 2026 13:19:22 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 7.1 000/228] 7.1.10-rc1 review
Message-ID: <aomTyq3mas2YEfSi@sirena.co.uk>
References: <20260820145244.450574346@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ETSQ6AqnLMli55xE"
Content-Disposition: inline
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
X-Cookie: My vaseline is RUNNING...


--ETSQ6AqnLMli55xE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 20, 2026 at 04:52:22PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.10 release.
> There are 228 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--ETSQ6AqnLMli55xE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqJk8oACgkQJNaLcl1U
h9AmVgf/eHg0OeN4EBGO0/BnGLQQaJNlSDxA7ewWpVJOplW7ljFMtAkWVdqq8IEh
GfV7l0yV38mKfsMJ8jzONh8mbeM4D/MKtkHMWz0FkLqe3S5PieCZxFMOuSC+CHBs
m0UvZJ/HeGHanmB0llrPEpiOc1KOr5g5hkrPwDI0rllfgZWmO0WhoD+BjSFCArUz
V7l0SiE6UL7C8uH6FMq1muWpUaD+pUF8JG37z92u3wG3bqkMSIA4V7WsAAgycKb/
jTNyKBqm20/7W6P3qZfLnPWGqbTvP7nGfRYaILB/PW+5HEK9MxjWEX1zVSe4G3x3
WzhHURDziKHzAsyBvFl7R2EJkH62KQ==
=QdL7
-----END PGP SIGNATURE-----

--ETSQ6AqnLMli55xE--
