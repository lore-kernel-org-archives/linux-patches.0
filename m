Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.134])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDAA322B
	for <patches@lists.linux.dev>; Thu, 27 Feb 2025 00:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.126.134
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740616077; cv=none; b=VDavNumZ5pA+9mIsziscCcP5UpBD2e8O2YfqJZDD7t4PR82mCDKO7JYVPC7Lx82cPIfKPEQcGBdyqXBTmfY2r4uiHBusZVeZg8j82kpNwAfVAzAE/StL+kTF9tuMc5MJPZ4hngp3vIrxqafFCKC/06eNUFj+ukKZWBrJBTING/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740616077; c=relaxed/simple;
	bh=cEEaCdBgUBGmqjtauYKieFfGvHm6RRG2x3Fw1BDiHLk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WEswbCEoKqett/zjyDqiuzLhVp0Nnb9VlS+syxferJFzryqyJGWj4ee7TVIQ2SvNLV7Nc5T0V0EdcoeDXAcedENkdS300WugEI6h2A/Bch/XVuHDuibGTFUtrmnnjg89N5WRWSjZKEk/nIYGH7RBuBUqAjGaSsYKi4cYmqiXr5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=qQCbbAe0; arc=none smtp.client-ip=212.227.126.134
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="qQCbbAe0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1740616056; x=1741220856; i=christian@heusel.eu;
	bh=v9/RM7WxtXhrpa5s2wE6b9/tiJOcwX1NVtNIn3ShMvI=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=qQCbbAe0tUg0LX0wWB07nEapzHBKc9j0Phic08Jru5kO5h4AD4zwf8fsYOJ9w1JD
	 9ICYYrB8FJ2bNHhtyl9PdHIKl3Q9ot6spghtC9bZbakMrk6Elr3pysieidEKbrGaY
	 XYERSQMVxwvDDMSeJtQOiY00+AmcBygnPM/0edeqC8dfJM3nkXex/prHwtuitKBXI
	 dSMUlYQELHCJUVQfnRscgpJaGOzmNOPI38ma9NthNFCgWdYYNWKtWVAErXOxPl7zN
	 b1D7ao54pFL6r2nky7OibpB/r15RTWjg2S11Ugms9pL41HJl1IT0mVw7BW9Ou4XFc
	 +YMQmkfL9q/GiEa87g==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([141.70.80.5]) by mrelayeu.kundenserver.de (mreue011
 [212.227.15.167]) with ESMTPSA (Nemesis) id 1MIMOy-1tZ6GS24we-0080zT; Thu, 27
 Feb 2025 01:27:36 +0100
Date: Thu, 27 Feb 2025 01:27:34 +0100
From: Christian Heusel <christian@heusel.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.13 000/137] 6.13.5-rc2 review
Message-ID: <5bc40b9f-847d-4e88-892a-2e9dc530df76@heusel.eu>
References: <20250225064750.953124108@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="btjuhk7ko4i3pdhu"
Content-Disposition: inline
In-Reply-To: <20250225064750.953124108@linuxfoundation.org>
X-Provags-ID: V03:K1:QkW+7ndbyBUi7qhfVn6ne60ZsGGqiXLR0SWKiAV7tb840OZIypA
 2KM1omOFhkvIWjz/S5UKBAqMGpCw1aa3l3GW9whV99QbSxA9TV/lpKawodOh1Oh75l0NHgv
 EhD1ZD4now7GkXlU+GVlMyOhsvLz8fA7tV2DeXpHk6rU/o8ehCBymDL0o7NF3cC+fwgh/ge
 l0h+En4y5UzKZG2kwwf3g==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:1X11xTailZw=;/k1t7ikSkO7zR9qUVjYtZ0lqqtC
 ns6z7O12QOzTycIQYA2mJyTUg0X3BRbmyEHUCyOSQQ7n9aCGtuJl3EA95Ip7JoUr0eY13r2GF
 B1JVZFXiAz/GOSQ03g7Gl1+Nd6kokKkzr9hFa/kdgUgO6VGPbhFkSlEoaOYBMuA1og6WEGYoM
 HBbBBQajzFawSg70X4gu5iLSWpMkK1YON4/CVxl5LfOWnGyOtUn78H5XT0SvS9k1lXAbYm3/f
 DbOH4ktA07NcAGlWUk2nNTa5ufjNp4q5ubvM5No5JW1qitWJKW4W9S1XKof8sf69TnMUkt3TC
 7knJfyNi5Tk3RIqld/UIPD8AGP+9vMqdt5/wT4vDaAj/SCYADTBnuFZkySeeZwiXWFfd1Y66/
 qqcSOHBh0U8BUqxCDbX6FA3n1CLVkjZ5uTBwUCZdMbZMmEHUZ4WsW7wSlEqPfpiwgcsVAt9rR
 j1WHNQt/bDiPtvXVQ/sK1Bc8Dgz3AFZ6SqSs34qR5GVHPmjM/xTjvfebRnEtZcpE7bWBt0eZQ
 0O+QcxAxwn73N6vn7VctrS77Lh1yyk4e9xMbWTs1VQVmqCiV6VXZX+4BhmQE2b5i2qAFJFHHA
 JSM1lCik2c/tdvzVSsUexuKNtdytdesbmvd2oFlSqFzTnyRYBJsqTsp+xw0bHY2fCJig/6v8u
 JRefu0Il43E8apYct3HxEngNZHTaR8eyeNHD7xKdfis+Alhjx5K1g1Ae4JyxLuwh+eB30Ebht
 l6TxsAGFGldajeVLNdruWvKJXgfvdKRBEdYGLrKbC4UjXj7AvxeJo7u2O98b4AXIInBl4/cHa
 tnyaIL76E1VxiFNQXLSNhF9FbRKmF2nBogr+pZ177KNk/tmra1zpKMBSrrdz8lcx3wC5Xwsg4
 sbHcLCgZYo/0OI7K19Mpvb/p//6mnIZ04pgNPc0nrcVU8980+uTLG3RqLGhPPTB6Cl+/vQukU
 hdxSX4MJvsxjBMqGBmKGMYz9zwZ7NThFeMg/c4CjtpPEL3okpazhR5MMGIuMleYxNlLHBR672
 +P4Je6CYkZ/MLbMI0+p7kgwEMRWV8GJ7WCUedXtz+nY71AVv+gv/EEeLGb8158BTQE3fqdxQj
 0j1JtWu+w8dF1wYkIUIy4x/RXDqml9DApWtb6MU+2r+cPDxD5QAG6Mpmfm/WV5m9b1IDLVGsL
 jYEYyLZOd4ZFrHkOIQ9atmbrh8Gv4oks/XhUOGsqJALDntaSgzDJPA+rRdBxA5C8lSJ01Ku0C
 q0wfbMpqCRU/YpQn40TX1J+QoEe8RcoO84JbRUk1JqHAdHGuRyRGUTuuobYGLPtkCAPO8MTFn
 V7R4423Q3yeuE2aVWBjfmAcJSsrxYFoldpsYtx/TqCK/EbqEr0YNH0H9OXOGKqx95WR6y34cW
 ixr6CDYmkJtFw4hQ==


--btjuhk7ko4i3pdhu
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 6.13 000/137] 6.13.5-rc2 review
MIME-Version: 1.0

On 25/02/25 07:49AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.5 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Thu, 27 Feb 2025 06:47:33 +0000.
> Anything received after that time might be too late.
>=20

Tested on a ThinkPad E14 Gen 3 with a AMD Ryzen 5 5500U CPU and on the
Steam Deck (LCD variant)

--btjuhk7ko4i3pdhu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAme/sXYACgkQwEfU8yi1
JYVjhhAAuyxVEfOUbqPiHs4y7QAAN1o17DmuUcU9mCugogeB2WTof5h+Mx/n6y9U
yXEk7fJ8CJtKXSONA3o3d66iYgvnLFDGpIDTA+4M1jdLPKFhOovItlPdyeGJ9buS
+dGe9Vp4VnAE9gcP8fpslMuDO4GRnraLhhoyrilkQzGlIuSFyULy5/DLFPZTsafN
O3eug/Ku7pXdl4dt9smJvWrdRSoW14Cuupsra+hEVEM97wRKoIHV8Wh0zldOwiWA
eMaAYSnNoFbcBp89wFGYUudaa6+2sq9e6u/1mGKDb1jIcQfCafL39y5gE/KO5UGx
6ZWmUXmvB1CBgwVtSqSVkDOolbhKoQfsiQFGxhSxwjIx9mch5iZ69BjHqf0/NROI
ZGZKlFZg31X7cEj2mkjfwW7bS25XWRXDoIoQ9ApCM3ZgPTbQXf3ihFR3/sd+sY73
19dyEvquasAMrQAhPyH6vutLyPG2D5h2kt7bu/OhptppGX9YtUnOtmW9Po/I84nA
2YY/GSWfBhsRhle3OufyAqRBCub92TId/MnbotjRwfW/6kaXVaXoRjeFTHHGtzTN
cjaFsIsifJ2qGx4O3LkYvtC4k7nrRwwqOLeJq3uWkziR0NZ3P9B4PGpLHtgwD+I5
1CQr76GgW/gNwvQerIzZwB4Dj+QUilFRadSvpR/K8is8O+vveVE=
=tD2E
-----END PGP SIGNATURE-----

--btjuhk7ko4i3pdhu--
