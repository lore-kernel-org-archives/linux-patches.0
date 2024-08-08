Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F00189F27;
	Thu,  8 Aug 2024 09:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723111063; cv=none; b=XwhgZLzqadRnOcTdl+1nlaweS4IsUhhhuTtmHb7KkLxvmvvS2/bwQb6m8x1u3SXCunsCeOsjjjRmaMRIrcu48dUdlUT2ogOOEV763Jv8Q9zibjh3ZmKvRGOOqCnnq36/ApWi0HFFuyjshvXBaUDtwCef7BL4QbBeLv62aJwVfd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723111063; c=relaxed/simple;
	bh=PJnCvnMxQWr1Hholvoj+/7PmhJRxQiWO0mmMLKpl7YA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LWluDR/YT14jj7LUlEnaENt1bbNR/C0Y7PoxLDQgw5SC/A8yxnNIUY+GctusgCeFVXiE+I/EU9nxj1PuHmflhUlR79Ciwpg2JJxsNJAhTo5GGLGxrYBvV9HooNDxjmfJZzC8RhF+Gf5BFos5Ll31JlnJl7/s3VlzEPuYXmzRCXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=hzMS0+Po; arc=none smtp.client-ip=212.227.17.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="hzMS0+Po"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1723111012; x=1723715812; i=christian@heusel.eu;
	bh=jnbqVylQD3ln/GE4BVfRbY3YErNp/kxmg38Tn4SB50A=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=hzMS0+PoPgiMFWeOSmoJcJCqlD5fWjFeRx8tnyrHEC4s2jPb0onBUXKUw1vxOrtL
	 yG3nblAonhIzzhUmxOOy9oFMY2nkroymPk6NKfZUpTkvdacTKBjt43Xi8Z0pipu4p
	 qnQ2PyNCWwImHC4LEpT78lTKyZL4JXZgHOajqaDf0tJZvZ6KgZiWw0cAL72+bH0sv
	 HzmlQKbcUYQKRCf6pmlZS+zKatDNnoZHUP8gHhISmIYaiMmNgdqfqCtpYZpIZuujD
	 /V1rlMBChku/soTKcBjIybgF3gWxbDipGKlFcE3mEok/72kY94GGvLH/I2FBcIM89
	 4G3dElOO6Py02aJI/g==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([78.42.228.106]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MdeKd-1s2wFh2tub-00dguW; Thu, 08 Aug 2024 11:56:52 +0200
Date: Thu, 8 Aug 2024 11:56:50 +0200
From: Christian Heusel <christian@heusel.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.10 000/123] 6.10.4-rc1 review
Message-ID: <e97286fd-ffd3-4715-bb89-ae3448fc7f53@heusel.eu>
References: <20240807150020.790615758@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="vjtvkwhvjtmvcprn"
Content-Disposition: inline
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
X-Provags-ID: V03:K1:9RN1xbysnH6iNbaWOagph8BkOrdboQM2j+/jLZ9S1rozElCozV/
 TKOJVMvVuCezEJSwSwdh+9X4qbYpkmN7ywjaWyEApnBr5IY+De8zNAPsxM5n80BwgVjV9YO
 n/2bxAUUTIs8yJ+uTgkFUov5GX1wbcrpCpFCVX9/Ez7+FTBqAZR7pQ9nV4u20m4Dk7YEQ1n
 SK4LNsLBb1vDgX3gAFjmw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:G9jXmkjSmQI=;iR5g4wMyi5O+zOS3dS0yum30eMi
 P8fnnlYBRI3Xv24DxuNd6yvwGsnnfUTJD6wOf+VOKh99ys0ocJekBOmdd6nHdk1SXa2OjVqWM
 SmoT3RdQAXtZNm97CCb/fB7XaYHOyHB9L6EYDfkWVlF9EkqbFMWl0eSkCFO5ss2s1UTyZ2uXQ
 JOuvJf41B3uILmfKi2//IAh9MX5AAHEAnh7GmSF0RI6C98l0y7NVZsxRneRo1ofzUvLRIb/PV
 8E+QBDPvP+FqOSkLYQaOHRAqQkRsSJVjOw+oSqxtGQHaVuFnsAjQ8Q/NGwa9L26nv82i4xGrF
 QlTdsF3LfXvVbkY10oHeDaqZ31hW05S4edY3gmRqzFrPjiM1V1Ln27bwB2KPE0RLjGdpEvuMc
 wBrJXFDzcpt/ZPltCgpApR0uaEXXjWeaou/n3mM2R0HWuqW2UvJAecUJiIgRUa3LG45h8UI/O
 XTTbyGe9SQ46YYg5cZ3YtT8GrQaG78BmoXUn/w7/YNYcLxUxrRdw0oLlDYiOwZ7V+cplAa28w
 ypAvp0WVvBKdcFxcT2DqYu1a+dmi5j8ruGSRQrRZULrGv6A24aa5bDvv0idNpoysjB3ZvDWd/
 mddLUMZ7uGzn1/M01r0pC7WLzZ918C1fMaLDsMDPeFzigPmBSFUflTP1taOcJvvIzAV1QrUZy
 XwYCFGOTZe9BRnkOwPrYPfN/dZtDjGs5bvWFfAN8qRu5NgpnRY6z2GD4uH+eFHSibLgf5+I20
 Rg0JJSQQoZmxnoH6bazpCcwjDhfzornRg==


--vjtvkwhvjtmvcprn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 24/08/07 04:58PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.4 release.
> There are 123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 09 Aug 2024 14:59:54 +0000.
> Anything received after that time might be too late.
>

Tested-by: Christian Heusel <christian@heusel.eu>

Tested on a ThinkPad E14 Gen 3 with a AMD Ryzen 5 5500U CPU

--vjtvkwhvjtmvcprn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAma0lmIACgkQwEfU8yi1
JYWJ6hAAxfGFlDZL4TFI84Kdr9w7+5jE7GbaMqVCnJf5Arvi+OW8whYQvhG878Xq
9CBY7NcI2yzHt++wHzGE3ZjUiTTHnuLBncsNy5w7Q6JJYCwSCfmmhEIhFa7UsPHa
tt6jyb+y1IF40KUrJycGp4yXXjDEH+HEr599WpT/KwTOVapDe7BVEil3r7o+2f7A
WpkQn8kLFTbD8CqMcmQ5SKV5BmR3iOt6jtYpY9g0SrzgKXavS7dMdlWEFFBf+CLb
u6wLRtIuMbIC7SDFvhC2YW3xELxvawpJzka6jI2w5j88KVNpDqkf8VIiIcMnQ/UV
2I9z53zd8awQMRdFyOfAgNlW1qRhJ/5ursJBg2m1CHFhkFDT74fVGhVYcs27ROze
Gc3zTT6evpcUWsUW8Ee4AvmYVhz3QglN6i8dk4UI25dTDxNTyFxplz2yoA0H3XkH
1hzJTjTEclBnaXwhPPNJKecCz+ECGIQp3NUILRO8LMFTdbkjolYaTvLkxaSi/tBv
x4RfLnq3QORu/dbBIqCW+wzhrRsSRzwbeGdxo4Nc1upgQ521bHCMN9sOWlCS0wl3
j5fCTHy3Ka/+0twzZ3hIRI0K83ZpboPnwsH6TT8buSHXOeeWZ12cv2gpP3Qkck41
brkJii1D4oZ5mxz7jdo/tbvRQJFDfjcLjWc6gq5lO/p0AjdY9LY=
=lufV
-----END PGP SIGNATURE-----

--vjtvkwhvjtmvcprn--
