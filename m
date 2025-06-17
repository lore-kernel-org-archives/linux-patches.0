Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA82423314B
	for <patches@lists.linux.dev>; Tue, 17 Jun 2025 19:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750190231; cv=none; b=XFhyQg7v+ddYv0bXoc9/hxQi32fRIYPmUFNwPiZlbl1nGEq5vy8X+P/Ee+ihBkOvTh/oo+9R5Yc0oBDXesaXUpeoQCGma7Olj2M9DDxhKh3dyKAmj3xly92sS1niK/yZ8J7FULZjINCvtZL5SHIiQHafvZhk2sGm8dpn7xGM7WA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750190231; c=relaxed/simple;
	bh=laByplv7B4Tr6BtcUrmYsW4xqoY1p+hJTT8masB+1eo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=isoVKtEPWd9JImMTQZGj54xgKolFDrD/15ZmmNHQVwNuLgvQgwtOI93m6RBwz6sCvp1UtCv7PztgBg4/65zuWIqXK7NfSJI6VueeeyIy3Ehl8/j1qE0/kvdZnqShzzaXz1QL+Hyog9bFN31p2zv+vTnXKI7nUMWnLpgfn8VH/Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=eX2WmeYl; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="eX2WmeYl"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 0CF56103972B9;
	Tue, 17 Jun 2025 21:56:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1750190225; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=W1m6FIv1wviKqfFcxApYoIQ1e/q7lkScOPJLhsCl7Zc=;
	b=eX2WmeYloaSsryC7ex47jjLMnmZQqwrFvv/FZXnZNJy6mi7u1Rwtq2o7wJkSWhtvWQtLcY
	ndrUrwFsjrThFJrt5e1kEAio+aOKFtfIqp4mONcpO8QJ4nmoxWkI/0fddYh6OsvLtj096X
	27BRJLpWYLxCpTcsdMQwY/pvW+ihubDeTz65XzPj9PHArSpmdRNnB48E9Jlfp3ZUgc8LbY
	ZYKa3ml8Xq4nQqIPIlvyOoR/97rDBw6sq7U8jCVNxluwyzQhVbpcSJjm5/rOxePFi0Y8eT
	YKj/YYbXccEGkTW9ZJfqpqd1PzxLXFlc0ljgt38OpxXn5J8SurgF2NWv6SJ+uA==
Date: Tue, 17 Jun 2025 21:56:57 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.12 000/512] 6.12.34-rc1 review
Message-ID: <aFHIie+MMif0HUKq@duo.ucw.cz>
References: <20250617152419.512865572@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3Grz4Hy2jcOM29P+"
Content-Disposition: inline
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--3Grz4Hy2jcOM29P+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.12.34 release.
> There are 512 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
6.12.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--3Grz4Hy2jcOM29P+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaFHIiQAKCRAw5/Bqldv6
8pj6AJ9at5kpk8O/vg4SWobDlrl+0benSACfb0g9IQKGtVF1VMvpjYJuKXSCArg=
=SVS8
-----END PGP SIGNATURE-----

--3Grz4Hy2jcOM29P+--
