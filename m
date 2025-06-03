Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9701926290
	for <patches@lists.linux.dev>; Tue,  3 Jun 2025 10:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748945500; cv=none; b=iPwMBacNsvVcGk+g1y7EYhQ6pSFoOrLyYKzK6o0Gm3102muCl8BNZdcu8UEayqb6Jhh48NY722znTeNOxaPTwq8hGc9ZlSeekakHv+fGWfBRjALx2ZK7IOuBtAH83hxg9Aksj1XyzCfAf6OOLV/HGZkVyc3skKEh4wblCnasHgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748945500; c=relaxed/simple;
	bh=2WTULSlq4y83DGKPC7AHKb6p28e6UuN8McyZnKYnsz4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kZrgJRXdvUXrdyRCidxaz4Wrs62LPvo0zmZ6Ye5sSm5ZyqYl1zs+0lxg5JjKYDogWB9l6FeKLRvXKtkf3tqbi2q3ryFqkmeNNYjthLDggS83w9OdI4zWVOQALAJZkhqd6eG+9vVfgP9YqFEZslG8Cf72wKqMA1xES6OLO+O2pn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=Jxv1Gdkk; arc=none smtp.client-ip=217.72.192.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="Jxv1Gdkk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1748945460; x=1749550260; i=christian@heusel.eu;
	bh=7DExoq4IcRMFVLKImoAzDlLPIEUfwpnpFpqkcpxpLOU=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=Jxv1GdkkC+k6sD/s4xVIV7RstkJ5qIYbKw8RCVAKl1Y9m27+xbGz6sP9b/n59ngs
	 0Hbu+10J2kQiyrW3HRdSclfwrRt0Vklkl/3Kpl2GcikS5sSf+TekckXIMv3XTM5Ty
	 al2+3kD3o0etkhuPB58rjoV9S2LHmca39CgM0Hm4cV652S69RLISuhyHw1+rEQKWj
	 arlZUOWTSfw7oYGut3PNDf30hsmS+kqa9xe5V2rcqvXuU5tHXXVPhQCXK5b+4Hinc
	 Q2uyaE2iUUD0JI8JXwCuZIQzLHfL1Kid0xWDBZTO//pguTGkpZWTrV85sfEYBEOfp
	 e/uVon52i9a+SIxurA==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([94.31.75.247]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MZl1l-1uPPHf1QGt-00RktS; Tue, 03 Jun 2025 12:11:00 +0200
Date: Tue, 3 Jun 2025 12:10:58 +0200
From: Christian Heusel <christian@heusel.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.15 00/49] 6.15.1-rc1 review
Message-ID: <c3c34e50-016e-47f3-b5fa-29ee8cb146cd@heusel.eu>
References: <20250602134237.940995114@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="aldxyrjtrikulwfd"
Content-Disposition: inline
In-Reply-To: <20250602134237.940995114@linuxfoundation.org>
X-Provags-ID: V03:K1:VfXiSb9Ab4pbnBqt2pfBFfKbt3nmXeMkpST9Tk2NkdfkOjMrcnD
 eIxKTfoa1DRqZzpqSZAQywhs9dHwi6zCVzQxci5+qjkk1IMvb4JmLHUJ8t6TrVbNeZnAOkj
 O1M/M057zzHVTB6yWNqTGkIjROVjsml9FH2omvqSF/Z4LAftZ3ejjWrMkmLZw3RsKqRmn2/
 jPBgd3E8BjpL2kBJSEMNQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:kfFnDREyfDA=;yY3jlHxZeSuHGKA60yI3IZm4+P9
 L6WUVpYxGlOKA/OMBROOJKjV2trt8HmfDtUJG2e/fB/hHu5MBTtHUonJNl53rsLD99xEGojdB
 E+KxwzCkfe0X4tPghlLSpayT02CAL1c5v8Ekp21H5j6CzKPgAUSYqks0byUCx1f9qv2Jwd9dZ
 k0osI6S+7NpzKmxBb3QnFIR1Bd+QAeeBwMY2Xi94DgiiXirDO4VVmysngjlIrCoH5PJ170RVk
 wlnX2f+YPb2CX0bLc2LGu9LzPn05xFGEsyBJQrPdN9luGfklv9uz8TG/LmlNMNd2+NtdVsNGD
 ZQ7qpmZ6NE36bb2XdLvBnazRcyIscTerRVBxcCvTrii/mtfHTGG6hC+dbIu/ipENaCgidvh/j
 RoHJ6uQvBhbnORl8ePim5+TegNcMjCINf/P/bBaguaKJ6yP2dI9zaZsBAiiaywEHU6aNNPTfz
 XEd0pOd1o49l662OJEUjKpirkCU/uDKutJDduSpDxGkbYydv2BV9icU+wPSujEeSex6hRK6N1
 F6PvX/7VIprVA/5k3le3mJ7ENR0fd/UwdF8Az3DRhEQy3MFDjMmKB8svQzIC6YD1BKudgZ/QD
 fAP4Cgwks576BbxKbwD17PztnhD/0obrl1pH8/Pkm+O0qM/qjRqRfHagdp65ksNdI/XshW4L9
 0uJw+uQdOCTUWDLJ8tPqNTadlrSUR74fjak2iplCztshPQaIrk681qqPOB6MV01oqfPN91Bnk
 mBkFF9HEtRdfFlKICWXEycf+dX/6Qsdey1VXnsJoGILLxUtV8JUPK9AnQf6QE9ql4++5ZlcNY
 5opJeLKgEoKM47ySnOHNEpDl8egvcJ8DA0mbG8TssNWoUke4FK/APLlKKKT56Gm4UX7Gcy/CF
 s0Kvntz+zwLcPGkqgkbDUXsLOuGMFVSxOLsCo0cr7vLFGKTA77sW1TTOH8RgiRna+7QZh+Nj8
 aqX3sBzsJ2/zVsg4BvwEWKxqlB/D6oIznZ0mBzM+fv4Y9LOXdiwA+p2GIWEei+z/2XWa8bVfq
 vr6huGVFKqJFAi/wG/ypYmIVAhmpVoI+hwGYTWWP7O9dNDrj35cNNA2/l4jyXnNWTWc8v7fcM
 xSCawd5NMv06/4r5q3p0B2lDht2skOzsQJK73uQvZPQjuK5WMvvXq3QDoKbKOd+s6cowM0+N5
 xwZqY3QIDHIf/eZxM73SfTF5qkq716BW0qpxonxb+Nzq33BTUj+0c57xOPSbvyQDxz32T9ACd
 6Vy5eDYxQk4UUoVswhl34/6SGEnHitiyNw6nQebo6wQwiSSQuLMeOMPETcDITYDrhq+8dOhmf
 QNV3jTK+Uf3C3pUw8dY8lz1Fs59yYuD+nSkT0NKb6OB0p5CCJR159msgwPK7GSPurAHHXzcLs
 17fuMJX99Wuh7P/YHdoESCEYFqLAocVEd7HKXXow9xaGsnYSFMsdHq3BLGcc+cF7cOFOgUgAz
 5PjpM2w==


--aldxyrjtrikulwfd
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 6.15 00/49] 6.15.1-rc1 review
MIME-Version: 1.0

On 25/06/02 03:46PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.1 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
> Anything received after that time might be too late.

Tested-by: Christian Heusel <christian@heusel.eu>

Tested on a ThinkPad E14 Gen 3 with a AMD Ryzen 5 5500U CPU and on the
Steam Deck (LCD variant) aswell as a Framework Desktop.

--aldxyrjtrikulwfd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmg+yjIACgkQwEfU8yi1
JYX7/w//TuYcN0nRos46KY4o1NWdqp2E3GfzTh4eMe0+4M6525aDb5rdmH9aSNjp
7gQJK4J/NIA+QTxJqfrGX4ObSSjUwoqyaJQdN5FrL+D+Xev3Am6j08Ts8c8EMt2x
jrUBFdzDyyTRyc9NS5ct1b6X0n017SHGng5KffmoRfAsk7lewAKdS5uIUbLTe6Du
viuJsZBMKrGwiTUIYh+AzGJVjyglIPI16wRmHktmTO+eRjAek5s6uSS3ZUwU+ajW
O2AFRT9kMQTUlwIxZGJGcIcJYY/AauYR8xD7jBY8hh/eUptY0Bpl+S+EV6GIC+5+
E+2GVyfDR0sH6aixeiwglA0LX7HiGrUkiGZmJw3kgp5ziXEeo96pp9dcO8VyZBXz
co2XY0KBvi/+wY+5FJQxVDuzPXasT5GKGAUFVGp5KHOxk+LIwpupJ9qNx3Bz+Dj1
/FB2vw7HirNbqrQ4E6Q9zyiJJVi4pY3GhbrZL2hrNEMKCmGvzjJ/diK6Lsbnrh25
ZQ6oNb8a2A/hz8stnknY+vpXPja4nnTzK4cJ+no515xbrzKIznTzSzs2Jqov03U8
1QQh0970vwS1cBcLFgVBzf7H2Jcm/qTnoGjj3E6He432Q1mUFZVSb0Y4UzhBoVGJ
sbEn6jm2BYN+gCs1JlfkGCd//nEckf6rmpBt+MV9+Nxr9iXt/wo=
=G92W
-----END PGP SIGNATURE-----

--aldxyrjtrikulwfd--
