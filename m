Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.135])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D1FC7E0E4
	for <patches@lists.linux.dev>; Fri, 31 Jan 2025 12:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.126.135
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738325923; cv=none; b=WwzCQ1e7QCy2H5yLE7/nZHqcfefhFFnT0gnCJ2EO57CdbPgfAJ1oJiuEmnScPq7mytXArGXIOvRTWrQV4dSIxQhl0QcXv3jg3ZO6qiB5xQe2agFPGwX/t039Xf6P51qVQaKYsFIWeUErRa1drrOwdxCKPccnWDfk7/TcpOYivBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738325923; c=relaxed/simple;
	bh=gIGzR8MwypIs43ehe0ZGBgsYNZYPnTzbEi5lyxcOLk0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dms4SMttPGN5pSkVRiuW+pGARyH/AP4K80tmf+KzL/jr3eYg1G4EUNC2SC973uUDfkf0S7x9Eq4uNwqyavkIsPgvNvlK4mPN0wpPyopHgzmUe4JLmodVBxh9GPWe3NJbACf1LvJk9MXRLZrtR49IXQap2mVz7d2BD10hrUcvgHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=YjftNYqe; arc=none smtp.client-ip=212.227.126.135
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="YjftNYqe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1738325875; x=1738930675; i=christian@heusel.eu;
	bh=H/WeaIDMM/Hlhi8zDV0LnE+8YereH3OqT7dcQ/IUAJs=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=YjftNYqeobwEGcpfizqLpjhGJsGv3Z+16c5sT960dEOEzvxE+MDpBYXyHThNPBmV
	 Bx8ELkifzMoL6pqdn6EqHxaf1nzrjuHzAwhflM1wnPJbHwYXA+A9aMdzFid6GZI6Z
	 aWYhP+36oCK4RXcRv/1ho/VNkzVEAMlWx9ZVniLFlP/ZG3SmiAnCNBPZEGuwFl1E3
	 WsUdORoRWByJdUrvc5GS8pW61x/eF9AcEbfpGq9nPjujTsyNol1kWxNU1e+LYep/v
	 yjn0NntzgUdNZExXZrkv6FUTkQ2usmPgyAVggJc+xROyu/EUdExxwbAPW4GRFrmVi
	 yiFBA+6q3uK4AoRorA==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([80.187.66.70]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MWAjC-1tyBxZ1yAc-00LcfS; Fri, 31 Jan 2025 13:17:55 +0100
Date: Fri, 31 Jan 2025 13:17:50 +0100
From: Christian Heusel <christian@heusel.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.13 00/25] 6.13.1-rc1 review
Message-ID: <380a5d29-13c9-4735-ba71-de2721b840c9@heusel.eu>
References: <20250130133456.914329400@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="5xvjg22pvmcceoyp"
Content-Disposition: inline
In-Reply-To: <20250130133456.914329400@linuxfoundation.org>
X-Provags-ID: V03:K1:wKHUbdppmSGgLyqdQZfXjjRn4wINOmsdTUXtUenkn/iK5cfEgB1
 RiO4Ohr43F4o+Vs/gc1bDpOAm1QBNE85b89iaBk4AGcrqYYDtpdZZx2CKVg8O9+kTWGghbS
 RaVTuq9FHQAjYev/GTlE8v52lc/HnvDwOMa6VZ4ltmlaFytPxcnomXrK7fPPUW2lpXdva7s
 z3wfmTtfbpdCsex/lVdJQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:hy8Vqgn1P1k=;zPR/A4pITDWQaBR8h98o1Hjszb6
 VRwAjA6LUmXCxmBeWwkjbgBfE9EDV7Kr3j4OMQCwJ3X8J+1Tg0HHnnaBozHlXgiLJsZoaq2+v
 4AtsfdSdv/GtHlXouYtzwCPJGmqiPYdriSWGMjUSReOTItCeaAAcbCVoi+B+D6ujAXK+GdFDm
 8/ST/DXDvTCwQqbC9J9QX9DrJ/YDSLfqEM29FaES35h505YQMtrKCy7oSbdiZCGjuV7tFatn1
 Lh0xOCRzQwaeW6JTReADJIC+1hIDLhd6vkKT5YA2tU+Cv+k9n1T2DE4HOECExDl7IcVg+Owgn
 PDaiMeJbroWje6dIgSlzrkbarvS9XZxYsz8J+WBbL70dLIdFW/BWzzyOBO9TeBYqkniG+bRsf
 uy5AS+aLFwIq1wq4jybZ6x2vcO4pwJCdJI5Bkxm5CUP3ywp/jzJjLacjpuouNeijQ4/8b94OO
 0gm5kb5Ycd8n/PFzrGfzx/G1RALDB5ui9/19NNf6GC6KV/qWXBjPY2KcefFK/favbhQA9iIAW
 Fsrk2REp0Qqcy6b8+SnnUXX34T7HmWS6Y1Nmr/CkWaCLampwlzNjTrCWhqK8suKZFwZGaAhZp
 szSUudL8rytmwc+a5RzRBQIKbLifV9IvUEiNfx84Ap2HDPkGNv8Vl5LyPHZlRhO3KXHunMFGk
 eZLFuUKE0htuu8fAXnAOHwSr3nzoWFi00aaRuoV1jTFnwyxHDt312uKqnpoO4HlvKHrEiIWht
 FjT4dIQyrjOlU3pmp9oL87qdIl6137TnoZ+Zs+eUsX5PK1Uw619CjXLs/T9Shts+0Kjlb8vaF
 I5nzul5agnF9Cif/WbsOz+anoLgw/dTcTiM4QRshKLk/cm9WbAovDQPFu2nPP6OxCwd+/Q70V
 j53O0ZvnPqBsnoVABUaC2BGuXhl9wtX8JEV3wefi91S6C6cK8ja+DAnyZ6zV0dQWZsJiv7Nzv
 ZePqrGo/DS+94ZOEvNhNYIsNGCxhz9O/b/IA6XsYiIq6sK3rNhEU3jT/9O0+OaJalrr0oqYUz
 zknSFsAFN8AyNnhPaJN84J/yZTI6k68CrtoyO/HQfUYMxMPVs4pKN8AJFTpeWIKiJhYQNv6k0
 +C+ZZsqrtt689H2HJSMpEiHXlW9wdxiMddSxwOhClc/SN2e9gvBaY3Lq1OdXmGdpg7IwnyBi8
 CQcNwPV+48Apv+YD/r4ABh4YFIB6MAgHRpBgEPrDtYrIn+8NnPGuxlYoRX2vrtmZzQVVvjk06
 mvWJEtVdlDk7qpe06pQAbLvBdm97duuNyzreO9t8LVAbgnjIgB+ECjc=


--5xvjg22pvmcceoyp
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Subject: Re: [PATCH 6.13 00/25] 6.13.1-rc1 review
MIME-Version: 1.0

On 25/01/30 02:58PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.1 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 01 Feb 2025 13:34:42 +0000.
> Anything received after that time might be too late.
>

Tested-by: Christian Heusel <christian@heusel.eu>

Tested on a ThinkPad E14 Gen 3 with a AMD Ryzen 5 5500U CPU and on the
Steam Deck (LCD variant)

--5xvjg22pvmcceoyp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmecv24ACgkQwEfU8yi1
JYWkYQ//dHVgJEr+U79JiNAyqQxTm5c+7Fu7K7A4XjP4q4NyO4gCvknr9W+05HHX
ZBF8qi1GEd3IY6s9a4ZRYfRww2K5C1ahHkXM1g2UFHB/hRM0AK1biZpx8oaxuI0w
mhjeyDgM86wCLzhVkCDMb6Pv2aDCl+fdZmv3lOhjcDcOR1J9bZPg2ocCcxo5uHVz
gCAWXgB6ETzpw6wWI5+Z4PY0WUi2t45K19qI+EW/6GuzSh9wrPRtf+gFk/pUrZP1
39AEua9wnW18KIWdaHVwuTM8WorkLG9NxfoHSyhg2lilsp5hVp8hDyUENQxaF1YS
yb2MitBmeCTEMzIMshcdSaNRgETwcinnOhYWQEoIokEThCGri9xNMKxp2jZ7sTPm
U5lF+G3m1aoVFkwPb09+AeV1JXiiF0oy0cXS5MmF7lH30UQKYg6pf2aJZcZTZMXd
o0CWRvXWPXWj+POT4H4TZgIf5nbzcp95zj4XLUR780gY4Xa633ep7uHKeaZ7csWu
p6oTyhq+U71j9LVzWa/RPWAYaEyx01BhpFoEGn53ZKYC/f1IapDw2cvKl0X/PMAS
4vdaVFqPXtMej24EtFkG6ZC49wle3l14ZhLQq/SzTyhuZ28uv8b+Dcwp/W2xpFIy
oLgQXglFAgmh1bLf7a4yY61tLL1vAf7XOgXBgleC8LChQuZYthc=
=p0Zx
-----END PGP SIGNATURE-----

--5xvjg22pvmcceoyp--
