Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6CC2274646
	for <patches@lists.linux.dev>; Wed, 28 May 2025 09:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.126.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748423217; cv=none; b=B8hf9YiHsUyBVasQy+dQ20MdACU3DR+5tw6q7VEPM26VCEDiCoHt9DX7PAXJU3TH/10AYFCOUTvK8JTfuFBXNIjjTvb0NbvYBtYUd2S/oe9pCYphtPWCcU6ltoBYqmgRaXI0miG5BBSCK8L8QharT3/scN/Z6m9QRttVJeOttu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748423217; c=relaxed/simple;
	bh=k/lWW+XJEE/jO3BFYNSnb6x47MyZmdSiljCfPatqm+M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pirfAu5FDM1UjcBPlQLukWnxP3+ns7YuLGppZIfvxp+vFzJreDbeJeyYkQ188hlpl2bfWjIOFQptzEkOKZCZTh7D8LUYJX+8t/8kPL+cI+iL8GEnGaoZ7ta3OIomMtpTtXVdgiQJwGPKPlt0kImWfX0Tg2MCuBP2Bf1E2uwngh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=IYUoUi6j; arc=none smtp.client-ip=212.227.126.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="IYUoUi6j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1748423168; x=1749027968; i=christian@heusel.eu;
	bh=/uji3PF8im9HzGIV2pshAadjNtC4PtjN0qjn4T/Dtek=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=IYUoUi6jExcrRbMw8OYCrINsdvMInvHrPz7HydawnDRKgbEdUAYLmAOuk/jxXVAt
	 XsuyNNciLnfq5bkeATh7oh4AMo8oCq87hkIl7pLKaQW7DslnOzk+G7lCYOtorL2uK
	 NBvJSgjLG915IDR/78jC7+eb9NuHSWR2wOR0Jkov4L5nfODATau7oo70TqiUKT3j8
	 ilhK3Heam0SL9jlJvvmWnGreMprfJdAMwMygLui/I7eIyg1l3l6EnhwnLs4E54Gpi
	 NpH9Qu2bKZ73DUn/RkpwLydWVunGCeS32ZrhkLWBlBOvJBfjLnpSJD2e8D9zXbtSv
	 bxhdNzl27eHBSD494Q==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([94.31.75.247]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MpUQm-1uhC8R3Mxo-00gTEb; Wed, 28 May 2025 11:06:07 +0200
Date: Wed, 28 May 2025 11:06:05 +0200
From: Christian Heusel <christian@heusel.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.14 000/783] 6.14.9-rc1 review
Message-ID: <28384a64-65e0-4284-9052-9ff49f673020@heusel.eu>
References: <20250527162513.035720581@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="dakoe2gwzt3ggdmk"
Content-Disposition: inline
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
X-Provags-ID: V03:K1:GQyY309Bmv+M0uYNfJlV5QP3YjtuAhSCLjJU/WCVqRv21ZqnOK7
 eVCS/Z1OJ0lwyZ25tdVUkalYrF+oGIf5teQGZnYbXF2DdodvVmzf44gc6Yty37+n+pfkgoO
 2aVRNAC8Cfw/oA0KlHjv/BQhT5UVm/bL3185vODu16No4u6GpnzEf0np+e2V98DFD/VQiXS
 EvDr482pMPuR4v2DBCx3A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:NXgLQEQgKRY=;JxFpqb0TTfpwAxGKTkFdqImVTZs
 BHgc485S9JpxLcyYD+j/X2KJ/O5/QhuqYHSh8AdwsEWwQPHjjdu3FPoRfJ4CKUKFMnkI/8/Ex
 jQKgjdamIaLL59hc22FvX9DtAdcy8BoCA+k5wghr4Aq0TyHteSyDGFd8Kl4r0XyTl2VGBUgMu
 8muH2mO0DRC58hBIrfGDSVIyKeV//bl+ndMwYJCBuQQhEZqJzOcxPxGhS4F5f8YLH0mIafn8V
 1AukqYi9LjwF0hTsPsD+yQv7uMn2+A+W4PE6XNLczjxcI1IvAEqUTBrKYwdGTdQb9XOsJLDbp
 +fmw1eunWGUhPMZEnZ6AY8wt9Cot0GyGCudDSfvj3Z2V0hv8NaYxU0Raa0Pgv5IgxgRarn6YL
 KfuGJdrByIIR/mDiFi2vVjdrU8sYGt2p2cgPgBHj9x3lTZMHAXO0/al3UuqkJ6KMJA8+nFecJ
 tylZgc1Y6OV7WMTxYin+o8ZiocgnTDb5IWwX05YfSw6ZdlaVu9cK+KAaNHSZ7aafZOzKh6qHJ
 Dp2MmfUMvB8Mxt7T81EejOlcRxzFiY3R5APvLE5ehHqW1dzcpiBckr+1+ElZ4hXO8rE3eRNGq
 8nzg5hPGIad3dC5BQI8Qtj9j1GRznBXpGwv86ZRCXc5ID6mX+DKL/4l4WtWI4p1gyz+4maf+G
 6LixuMkJsDF85H6jgGbDvok3dZ1N3hrNRRDKmHyDXXj4EaK5/rZlZAVFbLMRXeV4dCz+uMpMm
 A/vLsU79zzeQWV7hrjNhzGwYrDpUjhUjzkt9g3MASXyOohsyqfsPXfbmgY7jyi1kexZwNSxQ6
 mEx6EaRJT9Rur8Dh7TOWSn0YtYJ9WVBC/JnHEHe2RqYagd5AkLqk4osaG4iHsQ8mQDgCmgfje
 Uy6rDlppLShGTjx20vjEJT9lmY1ptAl6CaMOoHTPadWeMtRAFp6OjtRJ9nkgD3oHuWcgaP9d/
 OMmdR2t1hwO0ZmhDP4JKxLLmUdHU6+5h02rJyuj59C+vxYE7EToNxPLdsx11ZLqR9ljSVDZWV
 2u/AJRrcd7Kr6WktoJNDveiHnIO7ZU1FABdyjsH6A3N82HSGGxJi3ON3mRVghMWAwc2DH871i
 2M7BvmrsdnHZl1N/U71R34mUgoPRV4D+iLpm3zdKXwDkEXVN9varjpopLgsJELxWLlXc4S2RL
 P2ggftcHOdEuz4+Yc4IAtH7QLG9niiiNE+RKlqBT2C0s9GSIylgLvv+dv9YWxBnwp2CQ6Vcfx
 XOQOlojjnItHvHKZ08wXFtUxZmhO1JN1aBT5TCXWnQwD2/Xo/AT0F1Wc3fkSJ62WRYnJO58ir
 z3fkIAomqXR9eDfQAaNp2OaxxFOV08vOhTLwvTAJaw54CoChbA/MP3NgoC3jxAr5lNgH/LZJ5
 tGm4L21obaY0F4MFvzreg7SsdhyU0BCOb+hZFfhiP2DTj9wMxQdEnWUd5LnMg7BrEQY+EJlq7
 Vk87XdVSePB1QwmOLDOx+2yYSU3s=


--dakoe2gwzt3ggdmk
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 6.14 000/783] 6.14.9-rc1 review
MIME-Version: 1.0

On 25/05/27 06:16PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.9 release.
> There are 783 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Thu, 29 May 2025 16:22:51 +0000.
> Anything received after that time might be too late.
>=20

Tested-by: Christian Heusel <christian@heusel.eu>

Tested on a ThinkPad E14 Gen 3 with a AMD Ryzen 5 5500U CPU and on the
Steam Deck (LCD variant) aswell as a Framework Desktop.=20

--dakoe2gwzt3ggdmk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmg20f0ACgkQwEfU8yi1
JYXQaRAA2ynCtTKO6jxFUHncW496AAGx51nXBx1suUYUAL5+rIa0L0TnqZevkh1+
uxXqiIfF+houSMgtQcnCudy0MuQ64WQ9MdQPcuywYZyfs2Un89eAnsRiDcRNOy6o
1rIvq0TtRyCyFiwRSKvZoxGh32/mPbD4KDHTGx+UClxEpyXDfHv8q8RaVdgc0T2C
XOBOIaZAVIH4tln6TzSxKqPMHx6zb8Y4YmOEGCzDks9FKameLvk7GbNhIL99b3xf
0YODRY5d0Se7jGNXlvST6dzj0IuZuQlmE7vs2ThNa1orLcR3Qi7qpDXugKjlo/Xp
dvdljtx66urL0mQNABMcdePZYEeyqA1KCx8Fbc9Vjd560/u3cO7Ag4QcwM924QLN
H+ifA+l7Ey3IbE1qjUQ++JRV2kW0qylA/5dS1Wd+6A8t7KGsg8moZPIgb8Ifc4eL
LZBXfyoelMVCeH1f6oPz7raCU5pEyQo1w8wncoOa1hi24ZE+n2QKjPfRZT3WEk4z
77P1Tx6Lqf+BV7XUhsqPiSi5uuU95LKuEX8g7EBfQrNhCAHPT7Pdxr50iokVr/UD
CVN/lcX1xVguW0lpa/EFrRUAczxUFO3YceO2cYRWQOSG/4nET9VsvHxOSZipR/wY
iSogXIgVAN46R2wlV1btv2FH1r68XYTMh05K0oYHTygwWkiRdUA=
=2OuG
-----END PGP SIGNATURE-----

--dakoe2gwzt3ggdmk--
