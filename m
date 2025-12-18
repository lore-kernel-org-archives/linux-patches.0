Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5760C2E173F;
	Thu, 18 Dec 2025 09:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766050537; cv=none; b=HPcuPYDjeVgkzWLOMpgMBwPI+AlK8ZLh3oibgKpp/zD+zzb4YU2X2mqCK6aE+LSpmxZEhhvkoT60KAn/7OcGHNZLeA7DVr0GvdTcWIS1KwxRMtXDcSp2DV9YyiiWJWhoh8Ote5fIj7Uwu2Bmukyjc3pcJf/bP8+KoWt5S8DkwiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766050537; c=relaxed/simple;
	bh=iBTrhCdrno6/DVtFcJDjlNsD9yihOYyFWqu48UTZ6Q4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mj1x56dUNgrvOAILV+Eu6dUhKq7BWVTjRKJTapo3AJODxN/gzWfUS33l78Di6EIg44TCmjtke0hM8Khr0Zkp8T/RR01RqDJvPzd7mHv3/IqdqqgDquMq2ZcMxztFEadHtKbUZ/wJjabb+hn71/aS2PLi3+62r439Fpl/XVeASlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T+zkHjBb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T+zkHjBb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67551C4CEFB;
	Thu, 18 Dec 2025 09:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766050536;
	bh=iBTrhCdrno6/DVtFcJDjlNsD9yihOYyFWqu48UTZ6Q4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T+zkHjBbKR1P+fsIVriOvBsO5dPn8/1xrP2NF7yEDkItB0drMNp/eaYZD1vyhzztO
	 6SuOMIN+DtZHbvqoP+rwJYYYZWZ7CPTOqIlk1zEHcJInax/0xlH4pVloz/NNp2B96M
	 hFDLtxbzVh7KpA2X+u/d70rlLbapsTW+n6UytB/PrQf4kZczcPj4Bj50kSh2V3Rugb
	 ljfTY2rPd4gmjDtkU7KCER6Igp/Ln45ding+rKz9vOmb7xsshijf44VKAbAOd4Sn0I
	 bnPk7kmKFM8/TwN59I4aXQeHh0KF8yF2i6YZlfakae6G4v2xkA1MAikoHloOF6H14h
	 aDPrlcHkY98Rw==
Date: Thu, 18 Dec 2025 09:35:30 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/614] 6.18.2-rc1 review
Message-ID: <a8a095fb-9222-47bd-a475-1a77a4b27e94@sirena.org.uk>
References: <20251216111401.280873349@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="CzzOrB0O5gPCkLE3"
Content-Disposition: inline
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
X-Cookie: Close cover before striking.


--CzzOrB0O5gPCkLE3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 16, 2025 at 12:06:07PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.2 release.
> There are 614 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--CzzOrB0O5gPCkLE3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmlDyuEACgkQJNaLcl1U
h9Cd3Af/UfP3upALCjxu20RmoJ4Cqc+uDjCoeo7L8/v6HJikf91p8cnH80Aqr2Xc
Q5fS2tJjVRpWTwcTqATrcb7i2nIGt9L5A1hFwrPkzmUkVDwBnmEmputl/8FuY6lZ
WgCRDQxgu3RVa7bbR1bOIrF3icc3DQvJT53dsMf3/wsy4TXXJCwPcSoZm2NwSJsj
7IVHQ+8GH4W8gnLPLI36pAduQXHMldVAFDBFEyDMIW4egS29bbZl7z27HA1yaqfS
NMv1Oa/RGbMvJ++CWE7LHnARwMOrBkHOJBXAbetboNOGbU+4EPr39X7eTPDkedkY
6u35h0IQIgGRGEpI/E0/kRJ36aarog==
=sXZ+
-----END PGP SIGNATURE-----

--CzzOrB0O5gPCkLE3--
