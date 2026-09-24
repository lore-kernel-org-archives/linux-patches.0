Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7B6311946
	for <patches@lists.linux.dev>; Thu, 24 Sep 2026 11:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790249269; cv=none; b=stmlrkeIyzs6vFdzzugPLlZY2LrFnwHCrvjpmgKERB3xVAmHJSGRYOpRrnZsUAqsekM1v63IW0TVtjN2dDjO8c6jtbWaoOxxmFi+G8Nlg+EL+2BNVMF5p5tCHTn8ILf+G79Xht/mc+J+t5gqMgKdAc9XKwMRb0Nqpnl+n9QtXlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790249269; c=relaxed/simple;
	bh=Ng7XHk3vpmGWxyiouXoCljFHBI00MSlQhcephg9jKS4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gH0rl38tAT8WwWZzINZb5oMGssfpTMh8mAlhIQJeC5yOFYxrV8qJmDB17eNA08TJyLGLMBQ+3rYr0/w49nigAaNpqY2v3dVD5tWzyBEYZ/MCGkGJDAyS4ND4ppIjd2T6/eE2iqbzJuNpHL0uS/vQOci/BWNLIi0dIgtx/MAT/lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=h2t7rfHD; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="h2t7rfHD"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 7DD4F1049F9;
	Thu, 24 Sep 2026 13:27:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1790249262;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=A/bkNYgnP1tyQMZCXVadG8RKvR7fukhaEYBVhethcP0=;
	b=h2t7rfHDzZe3/1vbR4n6MtreDsBbtBTo6FV57F6VTZTmhZOUU+e+g/4ber7/xLWfcCdZpd
	MsAvn84twcvMH+B6huqPt09LIh7b4m7z7KBQn93Xndpkaa7nbnG2bdGvu3A49OiHNID3hx
	hiSXTAoOurxm6aVabDbtLXaakJbBZIKRfnYERmenEKBEEvY7iyBud3Na9d75sCFjQAa/WH
	5tdS2/n5Gu2G9FloOwCHMDPAzxM2JG6QPPJ7SSd+gI0FDvTa50pXBlvpyGJO+qQhs4VUTu
	QfemVdMM7Nv6X5egdSYcf04hXsgIWN0a2oZ4JIY2KJAWzZEQSuJYSJ99VgyeUg==
Date: Thu, 24 Sep 2026 13:27:40 +0200
From: Pavel Machek <pavel@nabladev.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/398] 6.18.54-rc1 review
Message-ID: <arUJLMtVma4wwXt0@duo.ucw.cz>
References: <20260923140643.441954610@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Tf7bFjsRjOWnN9fS"
Content-Disposition: inline
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--Tf7bFjsRjOWnN9fS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.18.54 release.
> There are 398 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.18.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--Tf7bFjsRjOWnN9fS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCarUJLAAKCRAw5/Bqldv6
8la5AJ97GSO3ZP/hNOZWdJV1pAEOq+VRaQCgtQ60idRgWmYTmprHUudBYAhPRug=
=FooU
-----END PGP SIGNATURE-----

--Tf7bFjsRjOWnN9fS--
