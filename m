Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE22280035;
	Mon, 18 Aug 2025 12:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521934; cv=none; b=lbni45e7gWU2ubklB9jziMAjKJ9LRUqGkwfAMTsETwxK6b1KqcM6l0U/9pWA+7EY9ZN0dN1N/a+5+0WaAza+7O8+jHfCBsW+IEt/rcyxfSC93dckLIct3jOhSueO1/rRN58dmqjDYL7C78Uw/RK/kMs6RhwJjegoR/iu9k5+1YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521934; c=relaxed/simple;
	bh=E0iqUF8u0lKcklH2CyTuVcFN8oQAd4cS3SjszM+5ofI=;
	h=Content-Type:Date:Message-Id:Cc:From:To:Subject:References:
	 In-Reply-To; b=WIxaGhqq6BYExsrvGgyQIxOM96rawl+zIfkHkN2kT4IqeyA7CILR6ZJFSBlFrsxW/Ndp47rPDjGrH5XnYlNrZKEQHcAtl3EIhDneRU56RxrSjXlIfFvE6IrRz9xbYPXvw2Zg2HoqJF1EzGI7l9a8BnLCdDQoiqQed/IJIdVoOnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QwFrSI6K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QwFrSI6K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC269C4CEEB;
	Mon, 18 Aug 2025 12:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755521934;
	bh=E0iqUF8u0lKcklH2CyTuVcFN8oQAd4cS3SjszM+5ofI=;
	h=Date:Cc:From:To:Subject:References:In-Reply-To:From;
	b=QwFrSI6K8l7NqhI1Jk9IkkXUzy3kH1RbX98iApJ9/1ImqJRGBkvjqUMnWS8syar5j
	 vSc6dsYhvlmbGvpDoLLMs7rt5n+MsB3tTQHzDAXdn9O0qgP1Czs81d1AHIlXXi9Q+N
	 9nN3FMeeAwq2uSh927bUea77uOSxQSp7n4DFSsnqflGpaHHeIflbrZCQTxnZZsCt5x
	 1+Qw3C6CX6i4OYjbGUOZxMdm7X1zZRAdBAnBlx9QGmOQDchAKMF97iwCVfjBShn4cA
	 NFNkKGEGNV3nP1OpJAPkMZEZt25ySsVB04qn0gVcR0lPLgrehlqIprE80dvm/m3mhO
	 BH+PCP4g6mhyQ==
Content-Type: multipart/signed;
 boundary=2affea532ee4cac79085df4446c4f909e46e73883057bc53258e38ec6b37;
 micalg=pgp-sha384; protocol="application/pgp-signature"
Date: Mon, 18 Aug 2025 14:58:50 +0200
Message-Id: <DC5KL5AL6HQR.1UOVPHD9YNBSM@kernel.org>
Cc: <patches@lists.linux.dev>, "Lee Jones" <lee@kernel.org>, "Sasha Levin"
 <sashal@kernel.org>
From: "Michael Walle" <mwalle@kernel.org>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 <stable@vger.kernel.org>
Subject: Re: [PATCH 6.12 120/444] mfd: tps6594: Add TI TPS652G1 support
X-Mailer: aerc 0.16.0
References: <20250818124448.879659024@linuxfoundation.org>
 <20250818124453.420152236@linuxfoundation.org>
In-Reply-To: <20250818124453.420152236@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

--2affea532ee4cac79085df4446c4f909e46e73883057bc53258e38ec6b37
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Mon Aug 18, 2025 at 2:42 PM CEST, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me kn=
ow.

This patch on its own doesn't make much sense. Have a look at

https://lore.kernel.org/all/DC5CEJ4YYRRB.3VTJAONRBJPVB@kernel.org/

-michael

--2affea532ee4cac79085df4446c4f909e46e73883057bc53258e38ec6b37
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iKgEABMJADAWIQTIVZIcOo5wfU/AngkSJzzuPgIf+AUCaKMjihIcbXdhbGxlQGtl
cm5lbC5vcmcACgkQEic87j4CH/hOcwGAh1RdgC6bf91j86onq8Gl2lTLBN+0RnZs
18dTy9hJmdkQEWQfFrR3liiBGVHCAf7AAX4vW6Sc8aJc+XE3vVydRJ5KTAnrc/9G
UVFuQ42jtRuLRxx57f9Mr4QQ8FAxqH11h1E=
=bMbL
-----END PGP SIGNATURE-----

--2affea532ee4cac79085df4446c4f909e46e73883057bc53258e38ec6b37--
