Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B88B1CAB1;
	Wed, 17 Jul 2024 13:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721221243; cv=none; b=kVjKQq1loxCFZS857G5+gw+focz+KvqUdUvjaZ8t60yZipaLeVGK4DnowKI73gNuts5Ose8iq9ADRC1na1j1/1H5qqK+q8lnPuuGO/G8Z+6H55wvRjPP5H1DyAINLOq9KhyJBuAIb5uR5nA7kG7FfFjnPUAMNtl865J+r5JphS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721221243; c=relaxed/simple;
	bh=PWzdVeGOYDFDvAAXX/W3p5qGqEG3bjIvRVMTy/P1o1w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FAb6EsFr27bVWgSxx6rrBOdybQGoikW8K6xnxCLsAL4zTyakiY4x9GRy4j+HhDltZYdQUsy7kwYwbmfHPVgfzuFk4+aCeXswcvWxrxeOWNiS8LtHquLqcYG1gL4eiMsSsbjVbGt5tvE5ZlmxxUPBF0xmg40SSXq9pMi+WX9S3k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L61whck0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L61whck0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54F3EC32782;
	Wed, 17 Jul 2024 13:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721221242;
	bh=PWzdVeGOYDFDvAAXX/W3p5qGqEG3bjIvRVMTy/P1o1w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L61whck09pE3scA4NiGcX6fe3jlbHK5L16zTkRpIAXtyGrc72WEVgwRKMurgkzwoD
	 pASEsD0NPUsM5cdRcgjDug2xWAlqarla6xlxSfN+Z8Pzf+8nc/WK2/awqSGne5GA4I
	 sJ2i/dtU5M39cqeNo57oH81T4Nb4yxS/0J1rFhTbuxLnDnD0J/1J5C8rjQg8Ngfxkw
	 3XdzPjH+fXOczEe+aBd4IrNFJQI3R1vsKLAfK6SOhOEy4z6BbP8hKHUOtfkie3j3cP
	 2PKRPeWQ/rOuYI4orQpb7ebPy9eLdJQDlO2jNGK05pbK+rvGiQ3aYi9DcgjXY7seAj
	 s+XcAs+JTr9yw==
Date: Wed, 17 Jul 2024 14:00:36 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 5.15 000/145] 5.15.163-rc2 review
Message-ID: <8e698886-e458-4cf9-8067-1ccbbbf45ec7@sirena.org.uk>
References: <20240717063804.076815489@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="2QE0r/hzZyKXLh34"
Content-Disposition: inline
In-Reply-To: <20240717063804.076815489@linuxfoundation.org>
X-Cookie: You should go home.


--2QE0r/hzZyKXLh34
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 17, 2024 at 08:39:16AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.163 release.
> There are 145 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--2QE0r/hzZyKXLh34
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmaXwHMACgkQJNaLcl1U
h9CiOQf9GRESAqPV8kfku5NFbPntaUwpMW0ibiCJI0C5kJi+QitBM/xtQR/zziVH
eQXdV6VyQco4SIQU3agqYj7OmB7hz0V2TjJVVb6k3qxDFSt14QLkxroU57dYXyPz
83eQ8G/3+/ZL7YW6TWAlCyWyqR0pONX+eP9vwSrH16LkpHRJ2BZPMCXNBtROZvwe
ia73R/3uxz5hMI5onwH2l+TVVQ+bO9ywmhEGScGiuTWmO0IQ5CoED1DhNNzbrmhG
W2ZD2t7iIU5QqeYFV6vs/EiKnCxA9l/N2nlqMeul73cyiYX4AS4F2T3+CJAi+Jwv
nIeHtwJ8uslXX7QpIYQKihf6xstlPQ==
=YdtL
-----END PGP SIGNATURE-----

--2QE0r/hzZyKXLh34--
