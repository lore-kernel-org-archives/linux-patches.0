Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E55378F59
	for <patches@lists.linux.dev>; Fri, 30 May 2025 09:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748598665; cv=none; b=YAsgdEvy3qDGGpgzLk8caq0uMzzzfANGm8aCSLHGgXNWvvZT9+56z3NLM6mSiQD7nJkHxnYw+qosV9K2KvrmJCmO3LSKIMpd2nwiFC/5qxv37r1sVHL5Im3MqstbQWfV8S6gNn9LI6bGvxS1NNrgrLc8Y7v9+ErYG4Y6hT4HQzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748598665; c=relaxed/simple;
	bh=QLLLHyqn6U/qyTDqBjR2GCngGFqyMLTqcSufRha3EPk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hCCfcNn9ZOwtPyaoKPZ5UAh+cDVCQFRx78z3i5h76ZYfOqjb8qetb4NqNX6ZuairO57HM3YrrPSqKn86JMeSUFYVO+Y7mDDEu4wKXn6785jR/uojQ07LRuJDiV4vQtxF3VoVcFpGR18+rExSbC0O8oAJ8zpXPp3Uyhk6e/RAzEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=LLHrOEf/; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="LLHrOEf/"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 783DC1039728C;
	Fri, 30 May 2025 11:51:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1748598661; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=clkWbce/E0EYUI7VGheKKj5ojgFptAsBLdnzwKPRw5w=;
	b=LLHrOEf/CV/iqdIUubFcMiR0kw6w1hJtiAPYKlMEk8fDsxb785iLRgu8GZFJNjagVRNhnQ
	Ci/zJwnIPlXwLUeMGWzEtjOsCQrH3dsPkUzkH499dAaeckobLduTinxe8sRdLxu08V8AHl
	Ci3TkkiPOR93vZxSGmHoOEKk6NAQ9FuBckJuYgGoreDia9h46y0QFzae8UxV2naL0Cb2o1
	GNWPfuDd6x0QkC59NgFl39O4T7QMUkGFe7wrgctBX5LqGo7qtz+oEUTfeMmFER4c2pPpLX
	PCzjF618mPETCSP0Zg4sPTDVX8yB3KRAYTcVIkIbmzGUoH67u5N0wSstsCRe0g==
Date: Fri, 30 May 2025 11:50:57 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@kernkonzept.com>,
	Andi Shyti <andi.shyti@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 112/626] i2c: qup: Vote for interconnect bandwidth
 to DRAM
Message-ID: <aDl/gSSUIA3ugyDH@duo.ucw.cz>
References: <20250527162445.028718347@linuxfoundation.org>
 <20250527162449.586493039@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YLjmnzVcK2IW24PE"
Content-Disposition: inline
In-Reply-To: <20250527162449.586493039@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--YLjmnzVcK2IW24PE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> 6.12-stable review patch.  If anyone has any objections, please let me kn=
ow.

This si wrong.

> +++ b/drivers/i2c/busses/i2c-qup.c
> @@ -1743,6 +1773,11 @@ static int qup_i2c_probe(struct platform_device *p=
dev)
>  			goto fail_dma;
>  		}
>  		qup->is_dma =3D true;
> +
> +		qup->icc_path =3D devm_of_icc_get(&pdev->dev, NULL);
> +		if (IS_ERR(qup->icc_path))
> +			return dev_err_probe(&pdev->dev, PTR_ERR(qup->icc_path),
> +					     "failed to get interconnect path\n");
>  	}
> =20
>  nodma:

See the goto above? AFAICT this needs same goto to free resources.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--YLjmnzVcK2IW24PE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaDl/gQAKCRAw5/Bqldv6
8qZnAJ98WFM4M2CNPH3QyXs93WeR0yXSAQCgmiR3ryz98tbjXmZnZsEfHoeGLbg=
=0I+n
-----END PGP SIGNATURE-----

--YLjmnzVcK2IW24PE--
