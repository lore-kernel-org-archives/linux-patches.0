Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759E21ACEB4;
	Wed, 18 Dec 2024 12:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734525541; cv=none; b=j5/MMn+Yrqfpg9KlpN0azl1dERZy+0P9t1/jvvGhZ5hmRV/5ByErWGTf/Qv6EWEMsjO71Tek6/yHnU2pg1q6BXhlGI0mAHIxtoUvVR4Cyq2otrN1XGHwA4vMmDk9FkMN06+rEwa84ccoOE9LYSGA5s2pkm00x7G5yfWirx2/OXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734525541; c=relaxed/simple;
	bh=ukAcrbbsOVzg3qn7XB8hWH6AyBOk3Q1BABpxTtLk4yY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jZKtfnNG3wwmMq9BukbN+DBcvdRTWpxGRuxXZXAy1ikyy5lNQH/gMkjjahuLLPVqRn6brAN6xo0HeAGHAHILU63xIYy38bn8c8a2XqFqf4au0m7Kurn4PoksTXXgouHj/qanoNzzYIUPTUZ6luPBjDDITb0+S3ncaNEo/thewZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qtrcIthQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qtrcIthQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D8A0C4CECE;
	Wed, 18 Dec 2024 12:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734525541;
	bh=ukAcrbbsOVzg3qn7XB8hWH6AyBOk3Q1BABpxTtLk4yY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qtrcIthQSv2t94X0cqULdJm2+bQHG2niI5XIicsghyJh6EcnITCwKawRHPPfCQQ/f
	 w87p8YCTWn+45vlJmcQFjnwdETERFp2C6cEtPzljToxHyETR0DqLGxSgWV7itPIQIw
	 3luW95364ReDDDlZbiePhZ6+mN7IKny0xKPsg01dx/xHcVumXklrJLd/gXPMoe0p1N
	 LqslBoremMATKPPtVxoMixYPIU2/Wnl5OioJ5OrzpLHFvrXISqLEQ5JD5kvDOGSu/V
	 nmlxavSSNU+rPaUHOQCEUmphjQ8/PfWLcDKh3WBqH+XOHekrPzQGfoRtukwv+rpYxR
	 yCRiz6wTnsESw==
Date: Wed, 18 Dec 2024 12:38:54 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 5.15 00/51] 5.15.175-rc1 review
Message-ID: <4ab2049b-2742-4a30-b23e-54eed5b85639@sirena.org.uk>
References: <20241217170520.301972474@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="bq+3g3zUstMw1Ck7"
Content-Disposition: inline
In-Reply-To: <20241217170520.301972474@linuxfoundation.org>
X-Cookie: The heart is wiser than the intellect.


--bq+3g3zUstMw1Ck7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 17, 2024 at 06:06:53PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.175 release.
> There are 51 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--bq+3g3zUstMw1Ck7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmdiwl0ACgkQJNaLcl1U
h9Cw1wf/coitio16DUruCK7vscpvPXHZ5BMhhURcqDhGlZqkS18yUY5ZAnjcnVj7
XWUU562Pm4XUPI9TH/BforuYLPsG3mqS+mck3a99XJYlyj3oNNy/NY6VdJDukQxL
GEP4JL90DeOQqtEvwxG/wd3AXBJdT4E/ueUK5NaY5Qb3KYTvwoMxOFuna3mBIPfz
O1uSju4tij+w/Z49OdRNWCtzKyWNhaXbh9SbUVyk14LCXptp6LyElEd4Tsg12T3D
i1MfDBPcj2TTENo7UayiH0OY3ifYpQGsQ1PDmQAvi2rPnDYqu7M4SZJZS4ncYUVq
OUI3f2AapxYxbVDT6WgqF6MoF1M0CQ==
=ZEIf
-----END PGP SIGNATURE-----

--bq+3g3zUstMw1Ck7--
