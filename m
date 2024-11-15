Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE8718E351;
	Fri, 15 Nov 2024 21:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731706036; cv=none; b=eyb40BNuD0nISbs+SqBdSJDQZRA86ggMG5cfLPfSR4yPafUuocvHyGHTzhCLGWW83oFe2RST/sqt0o1uOqe+yy+zYYX002BR30d7/ahr2MOltAmoH0wAiwwk1lv1eGrgxKXLCBX5hx6U5I8kAnz/mXPhyqGccZx1DVmAWLaDlgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731706036; c=relaxed/simple;
	bh=2EpeJaT2SD/21d9GIoCwNxGnWz++hqfMy6JLHhq5j3Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W2cLbPLiblQ8n4jjKm4vHx+jgdIVAEkYWtapU8AbHzMpCSws8dFE9mhRG9Ls+iMdiAjrujfk/DaaDPqdVwZMwStGRlz0OtOOJ7ODhnuj03IADZHC0dBNIzfbBlHOAWKZT2vQQaTdGpqC+u9Ni0sEETIx6jWRR8FTg8dupkVoAkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pjVdTB+c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pjVdTB+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD53CC4CED5;
	Fri, 15 Nov 2024 21:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731706036;
	bh=2EpeJaT2SD/21d9GIoCwNxGnWz++hqfMy6JLHhq5j3Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pjVdTB+cYzRoRHueKKYOFaHctzsdr9xYU0kxoHVCbOniO9Z7P2HHfTlA8jhVKVhSv
	 NraegDHuc1nC/U28yda0j8hm5rJx34h5vP+qqja1EdrEf2kfoIPf2AnC5ZIPnTxZoR
	 hzPA1h5uMkXLf9yANqgtC03mhfN8I5nrFn7YrABxQS8R8fqyA6TXWIXA0vGTfdC60h
	 WRaxhs8N4CUcyOLVRJAGYl+dlveakMfiNcj2XdIItARnP68XV6hlNJU9S7KE/D9+vZ
	 VTT+oxuZV56Y3C24g4IJe8U3qCxM6A82cpoRa7bSFKqmhzLkhudliRqJncHWdkKY4W
	 c+CPswXOYdYMA==
Date: Fri, 15 Nov 2024 21:27:13 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 5.15 00/22] 5.15.173-rc1 review
Message-ID: <Zze8sS4HNpqDjH9E@finisterre.sirena.org.uk>
References: <20241115063721.172791419@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="AA4Ovhj/+54QA/Xm"
Content-Disposition: inline
In-Reply-To: <20241115063721.172791419@linuxfoundation.org>
X-Cookie: Editing is a rewording activity.


--AA4Ovhj/+54QA/Xm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 15, 2024 at 07:38:46AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.173 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--AA4Ovhj/+54QA/Xm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmc3vLAACgkQJNaLcl1U
h9BEoAf+I3+EAgqZyByLA0snJa6OJ+ZrBNl3uIqaQUYSLacxpjkiF4AuT7CQEBNb
UIftwUj3Zil7HHZ+C/TzSXlftVU9+4QgVhYmoTXP8Ss7aZJmz0RQSSdBBo1z1Q/r
gVrp9+I9XRodtQDJboOPY+s3YFDr8A8HybLqEqZDc6RSSQcGXC50flU3j5tU7At8
EswpBWZDFhekGI+6NE1ZgV7XTyOTwYUz5nfwsDE71E8Hf71J/1RI+vg4BwRuX3rs
MjJJpuGFps/EHbJGdLqEP36AZ1dSmMcFc1awF8yq5VTE8wL8yTQNkw8QNRBZKA8Q
T1rO72+OQ9LxfLEk0W7IRSkPntAQDA==
=lZ1X
-----END PGP SIGNATURE-----

--AA4Ovhj/+54QA/Xm--
