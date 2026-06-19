Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3A83B38B4
	for <patches@lists.linux.dev>; Fri, 19 Jun 2026 16:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781886246; cv=none; b=fMQ2Rvi+EyvlX9I9rlXOHYUqhuT5sgxnxdDnqWPSTjHtbFHV1dJ16EGaA9+pzjovZiWhjdx0cAAppzb48OxLDV+hqRD3JXoyXV1p2ZWaNyOgBghdB5xZcBj/qr5bgLjkh1tbb8hhmwMySP7CitvxdFTy6Tl2vp9FCB72nOUoO3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781886246; c=relaxed/simple;
	bh=dLseSs2Wm9SPVKWJJ3iGGuTBRDibOYCNjz4WJ+yAxjk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vGCIpSLrQh5+1cWLL6a3hEOqfOyZJfc38fJYna91yZKw3SaST6uzuEDxuJi1n5wB2ORtfXrLdVshUfIQiFFBdwEih1jpRmuWWD4dn6nrmyCpCMQIjHXCsoG8xAJRLNBwuz5Gvst+/mfRzhYqnz7xTHBr0Bb7bU9LKf4ldyyDgKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h/eSf/Ch; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YnF+vQSl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h/eSf/Ch";
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YnF+vQSl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D2D1F000E9
	for <patches@lists.linux.dev>; Fri, 19 Jun 2026 16:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781886245;
	bh=dLseSs2Wm9SPVKWJJ3iGGuTBRDibOYCNjz4WJ+yAxjk=;
	h=Resent-From:Resent-Date:Resent-To:Date:From:To:Cc:Subject:
	 References:In-Reply-To;
	b=h/eSf/Ch2S+tpmXIhWwu2nPyonxP2NtL6z3bbyCEvJnEaCqofWkJm4Z/UMZ4egkqw
	 BsBvohBxZcVZ08/jqOiUmaHwp+o7dLjYHs0gsXoYLdmla5qat9peyIr7fl7Qf8H1RE
	 f+73Mgb+Z+gVJYkSlyL90es1SYjkAYhz6X519OGGT9bhNXN+WFDb+wNsEEFDTrKtLI
	 3R4azuo5nt3nIBNbVeCVwUVKj6FDDYGhLHMgfKbfvllfx4Yia3ZgMiIUADwt29oA66
	 vy3uCMKAIMKh4GHuSHfgGNix7j4sslXZc8ckovR9CHPqzF67zUGWTzX2TNFXs1rzZd
	 gfP/V+PQTgn/w==
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Fri, 19 Jun 2026 17:24:02 +0100
Resent-Message-ID: <ajVtImNvO1OBydN2@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by 172-238-120-221.ip.linodeusercontent.com (Postfix) with ESMTPS id 780B02051A
	for <broonie@sirena.co.uk>; Fri, 19 Jun 2026 15:00:42 +0000 (UTC)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7250C601E2
	for <broonie@sirena.co.uk>; Fri, 19 Jun 2026 15:00:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 3D2CB1F00A3A; Fri, 19 Jun 2026 15:00:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B5A1F000E9;
	Fri, 19 Jun 2026 15:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781881241;
	bh=dLseSs2Wm9SPVKWJJ3iGGuTBRDibOYCNjz4WJ+yAxjk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YnF+vQSl8PpRFYny8vN1Sk/FNkz2tx1qvgKApCej7HKSecwB05eI7ScM+iZzPaX7x
	 oy5Bt8XyqRjmS134KhORjcg31hJZCRs9lqtc/S7zZznO7m5GPVlqp/r8laVSoGfli+
	 G5ELsUWdk0dLL7mFOvRHapMZ6W4WXC0GVF+G50kjNmpM6dmu8f5bsbdZxXLQOV97r2
	 B3WJFT3/I6ZnN9/rB/vlfS2F/WpeV0AIDf8RZPZ8H3iqcmXe59tRcn6fPLGB9T8i4Z
	 grW3LsLwrX8NEK3wSDMhuAg6rPaDSbLTgK2LZm9+zQc9oqIQMTNODwcJs6XemmuXXx
	 LLXhADs44gQ2Q==
Date: Fri, 19 Jun 2026 16:00:37 +0100
From: Conor Dooley <conor@kernel.org>
To: Changhuang Liang <changhuang.liang@starfivetech.com>
Cc: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, Mark Brown <broonie@kernel.org>,
	linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org
Subject: Re: [PATCH v2 1/2] spi: dt-bindings: snps,dw-apb-ssi: Add
 starfive,jhb100-spi
Message-ID: <20260619-monkhood-imbecile-7e56b57158a6@spud>
References: <20260619143443.22267-1-changhuang.liang@starfivetech.com>
 <20260619143443.22267-2-changhuang.liang@starfivetech.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ng5/tWqnwV/9AP26"
Content-Disposition: inline
In-Reply-To: <20260619143443.22267-2-changhuang.liang@starfivetech.com>


--ng5/tWqnwV/9AP26
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Acked-by: Conor Dooley <conor.dooley@microchip.com>
pw-bot: not-applicable

--ng5/tWqnwV/9AP26
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCajVZlQAKCRB4tDGHoIJi
0uscAPsHhWou5nHvVuNchzj8wGZLoj6oDK5OnUyFTYCM1qvReAEAvIjgVwaqSCOi
CX2nNeYwL9+VpsNjreBAJIbt8U9WogM=
=4OYZ
-----END PGP SIGNATURE-----

--ng5/tWqnwV/9AP26--
