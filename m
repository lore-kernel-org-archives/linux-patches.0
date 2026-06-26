Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891B03DBD55
	for <patches@lists.linux.dev>; Fri, 26 Jun 2026 11:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782474206; cv=none; b=TNXNRLdYcr0ir4CU24CbBqw2etPb6o3+GnzzsRx71WaOtWxdoouSdT8IK7osSvo8qtqHkHmQRDHCVC8Ps0b1ArYQxui8uNgxE2vMLmhGOC/swB6eQ4VQeAFNop+wuc8K8DAsx2EcAwsfkUCONSPIRdNm2KD+2lKVMOI401V311s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782474206; c=relaxed/simple;
	bh=P5LOVI6HB/RZ8gCz4+aEk1/QWycuoI952xLS5tAGnVw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oD3XCDxJnCRLaj3VUUJQ88bnGCAjAwj+ZBplldmllllxkT0KeoYBGPcM7jZjXWh+MXgcpM2SIeLts24NXHM9rfJ6ktCGqSHi6kpl5V13HZ0VxUueg83YquTJawedg5wSlq92UMCZO5LWQbgSdrioZFVgT/yEVinzxbkhB+cO80A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=YAeA0nUP; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="YAeA0nUP"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 5D09F1180A6;
	Fri, 26 Jun 2026 13:43:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1782474201;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=Rr1cEDzLbCZUXK+ljn9CqBOaHcRPnnuRSii5bA4obvM=;
	b=YAeA0nUP92ZixdLW4++8WtJM16k/jEN9xFgkw1o+XxCrwk0qgmE65/PxPSblgsYmmWiECe
	ThV/mA2GRzJx8YnucuWFZshl16djHMoMA5d1qvuehXjR6fB7mulZ1HyKjWGZBRg2VFuAGj
	aCz9kDs+Fgc+XpbMU4Fkpf0M10alNBX7YK6cp+tLlHx/ADo/72NI0cpxfUmTUB1nRJjYhm
	/w5qaWSJ1MgHxthBSrtpj0obexp/dXsuSazeRz6nb1559gPZwMnJYTtfR8Ulsqk1Hg/sn4
	RgiKQBNFPzhlvNlkzPBkXz1WIUIvTHCBqU/W8b8JDudjRqpM32e+9yGUw/bXXQ==
Date: Fri, 26 Jun 2026 13:43:17 +0200
From: Pavel Machek <pavel@nabladev.com>
To: Pavel Machek <pavel@nabladev.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 7.1 00/21] 7.1.2-rc1 review
Message-ID: <aj5l1ZZeX7cj1J8v@duo.ucw.cz>
References: <20260625125613.243729608@linuxfoundation.org>
 <aj5hen7qThm9X7LU@duo.ucw.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eip3KXvmoWX0Gcjw"
Content-Disposition: inline
In-Reply-To: <aj5hen7qThm9X7LU@duo.ucw.cz>
X-Last-TLS-Session-Version: TLSv1.3


--eip3KXvmoWX0Gcjw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2026-06-26 13:24:42, Pavel Machek wrote:
> Hi!
>=20
> > This is the start of the stable review cycle for the 7.1.2 release.
> > There are 21 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
>=20
> CIP testing did not find any problems here:
>=20
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linu=
x-7.1.y

Aha, no, sorry, the test was running on wrong version. Disregard this.

Best regards,
										Pavel

--eip3KXvmoWX0Gcjw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaj5l1QAKCRAw5/Bqldv6
8lcrAKCEqvZ37UR5AoAcA9wLpykzpnJ56wCgnUDOtTPo10rQ0urXSCMRKchSVEY=
=dNUM
-----END PGP SIGNATURE-----

--eip3KXvmoWX0Gcjw--
