Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135541DFD6;
	Thu, 16 May 2024 15:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715874387; cv=none; b=WO9QrHYbDqCPTQLWm5dGzbS2T8oRmrmh7SDIPmV8SFBFZXTJzoARFuOGkPBP9eHikTdGyCrDRCTwchpc3t3K+y6fYWWszXeTrgjYXy9ExJ3Q9k3+ddAvTSkfaGeD/P/RBHmJk2qwo5HPI6Z+9B8AXdjbBK5hMSBoUrxYvfjD6oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715874387; c=relaxed/simple;
	bh=jNeTYgB9JrRx41ZH5bCoz0zP6axFcSR8qxD5/yfBbmk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jt+1Gv9gVm9b2xA33qQuftCbbNzhD5znEj1BCzMzcqZRSlD1YTSKLREao0cegzUPO5ARlUQWbBzlB3ddTfhOMqkB3nHCvcsCQ7qcTaWTqCgzb9/fBqFRo8sArlzQqLZqecQQk8yucK1DWFhAyHfAawfkc4FhjzrgmhGmH+tjc38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ic+uftSO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ic+uftSO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA48FC113CC;
	Thu, 16 May 2024 15:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715874386;
	bh=jNeTYgB9JrRx41ZH5bCoz0zP6axFcSR8qxD5/yfBbmk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ic+uftSORrrlwHVGGjvLkuoljHBjd4KuI7bteturNO2ObUILYYkiNCae6zyMGVI+U
	 moSwzr2+1myH76tE91DdtTYXR0t1ee3G4TLc4xhNyDTrZG6mfH7dFT9cDWLDEo5UdZ
	 rijveDzsieiv56pSmMpGKWLPg/KGtp/P0O78LbeObJhWpYMgM/0Ub8rvl+evA1u/pI
	 ik5rwLXTXLnYA2/8h9pKsTIpmEUq25GgwZ/q1giaVo2T8c3nkOvTD9CzFfwtdJoHsG
	 x8tGiMDt2EK3V9m4GDnKayLheqPDmO3eofkQq1iYiW10wmHKyVMUl03J+EanYlkcjB
	 s3KWcoq/O++BA==
Date: Thu, 16 May 2024 16:46:20 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.8 000/339] 6.8.10-rc3 review
Message-ID: <ec7340d6-4bb8-4106-a7dc-2445e230620c@sirena.org.uk>
References: <20240516121349.430565475@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="an78PT4XpI8Yq0SY"
Content-Disposition: inline
In-Reply-To: <20240516121349.430565475@linuxfoundation.org>
X-Cookie: I'm having a MID-WEEK CRISIS!


--an78PT4XpI8Yq0SY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 16, 2024 at 02:14:57PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.8.10 release.
> There are 339 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--an78PT4XpI8Yq0SY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZGKksACgkQJNaLcl1U
h9AgZwf+J69pKb1lvGw0Bh9dos4agJzkecCiHvVOjv0Y9iJ0fgVijDOEgidxt0Bf
KzjIQXyEl5hrSoKLMIzxHZh2jZgdOgZM4qdg/YOMzDq570wh+SGWU6BmLAIWt3pa
nw3tQYdsBSuOegyL4Ia+BMcJ9lKlfWjpMGSeyBVAWPipUy0K8xVA2m3OPuvDj03S
qp4HHWxcTSDWn6ebMNkJ9Xlh6jeky47jxf8qcp7qyANc7NOgOpLxw0SMRt5AfLGk
FtUoAPY3JK2nVT+zLavLIWQHhA2d9Ya5bjIfOfFB/3N+k4I0J3EDzrReDoq3F/hC
M2FTAk+zuzq3TXHFLVTHOx//QxTrHg==
=SrXX
-----END PGP SIGNATURE-----

--an78PT4XpI8Yq0SY--
