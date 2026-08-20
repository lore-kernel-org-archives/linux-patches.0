Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7624925B090
	for <patches@lists.linux.dev>; Thu, 20 Aug 2026 18:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787250745; cv=none; b=QBsy95dWjEXTem5FNxQeua4y9EU6Ik1/z41qH7dhYPmCxzQ1ZSF1jSC4E4hEsmt/H+uq1E0XX1jbnlwN9XRRJruzOaS9RaAEzgqX0K8GYLNSp67EP5F+GC7Vc3dJhKGUt44wLNHuZVTytTffp8silLS8iLzfnLCFC+lEbu0n4og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787250745; c=relaxed/simple;
	bh=cQ8AMK01qU8Ch0RbmtWydafNi1GuQrcApydd5kqe0fQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HfdVOzpFIoCMnUKmy7fl8QEI+utQrD+yoVgV71XTChZFkcT25KYRWN8EXc5KOhK46K/TtnItcmKWbTAYuijtRbrJ0QYLgkkZsn6OHFsXis6OZGJpJ+GWzvuCq+M/GuO8ivEaKVmJVvI8JHwFRr3vCuirmZfCp/WY0bt+D1ydjuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=btQh8B5K; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="btQh8B5K"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id CA40D11C60D;
	Thu, 20 Aug 2026 20:32:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1787250738;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=2AJznJyfL904AQyvReT3YMb4zbIz8Tsej2fRKxDqYSM=;
	b=btQh8B5K/gfdquPooUwAnZ/Bq2IU/YMldZpnH0qY8FlkXKdI/Q4esvZX1Ou7iPrTW/JYwB
	p6lCX22UJUkPX+/8tTmbr7budCThzbH5G22rVDFBOqraQrBbFVRkU0NcJMDqG5dmRdYLet
	rnY4IdpRL5IYKLkrhofTZEL0z6P36A89v94Sb67HRXkBoAuDNP9o7vB3bXtJPFJZO2rEdN
	q94s8Q2x2LxtfSavd+C6ZQ7itu614+TRiBF7ruqF5CeKUTcFL8/uWa6VdVnwjakgUpMrx0
	fwMqWqJeXqy5/0ivNIWzhBWHnZ5zoz+MxPKD7gIl2OmFWwhhDGyJZV0i/UdpOQ==
Date: Thu, 20 Aug 2026 20:32:16 +0200
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
Subject: Re: [PATCH 6.18 000/217] 6.18.46-rc1 review
Message-ID: <aodIMD_hzc0ZcdjU@duo.ucw.cz>
References: <20260820145237.531699751@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bqpfV16JlweVUGUq"
Content-Disposition: inline
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--bqpfV16JlweVUGUq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 6.18.46 release.
> There are 217 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-6.18.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--bqpfV16JlweVUGUq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaodIMAAKCRAw5/Bqldv6
8siiAJ9feq5iIlZwMpKHo9t6bw5LI8m72QCfWhuHrWUba5po6s6LfbclC8OXGVI=
=9/63
-----END PGP SIGNATURE-----

--bqpfV16JlweVUGUq--
