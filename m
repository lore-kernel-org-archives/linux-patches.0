Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B78F21421C
	for <patches@lists.linux.dev>; Wed, 14 May 2025 07:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747209038; cv=none; b=LOCXxcbmq/24/9VYpFdDq+ePH8cE/cjVGlp8iMyRkbbWmVdo7ROZ9o9eIPGzE1o/c1FhoNMXL6Uy6Xew71Hp7RdFPivSuwpBPx8yaHefPr5U0yUrzbpEXJYQl8VewFn3FSt7AAhrpunl80BrMUacONFudkghVoAUrB7WIccENYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747209038; c=relaxed/simple;
	bh=D8OQaUiF9ozJCoauKAS5nZUGADoLflOKv0y58rOk+NY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gYVpBNb6oX3mb3vgE0Ed7NrZ1EBfRf6lpc1zoPuVNE90xfnsKYl8tGak67o1OlIuf7ousXXp7aQZVAhUgUOVB6FgO26cmOr0naqwa8Y0vhDpwgudE6gRismecbzgaXgXoffr9pSipGS7VEDiOr1g/GBBrSgr4YD4zX3c9IfkrRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=ES4XO9O4; arc=none smtp.client-ip=217.72.192.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="ES4XO9O4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1747209016; x=1747813816; i=christian@heusel.eu;
	bh=haYVFLZs9fBtTp6OIgr3UBDWUsGQCSa/8Q+bRYFMm/A=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=ES4XO9O4NbUwCqbEofLNFzM+I7E9yCLwfbaknkvOm1LMTPmzhCOGpRHiATcC2doq
	 FqxEZ6yiAz/lUhOtrIJZ15L7iIvvSueL0Ba0oRYCuxtltWk23M0V7a3hCZ4LxU8Xx
	 xcFYSZrgjN3WrS7PWjH1bFPyU14awuvp3BG8P2lNA/EP35cbYGplR9GBIoWtRZ+R1
	 j46t64YJ3BBFe4bPjU9qGSge9RHofvdlXlgCdmCWvPpoOUZ3CZfHg7kiodEUTOcgC
	 4QlpS7w/kS5zJ99m69J9EHL0tspEC2mvaqr1J0Rz+xLZBjbDXkU0l6Ko51SSdNv1i
	 Dt5hhrLnpnD+RHZa1Q==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([129.206.223.183]) by mrelayeu.kundenserver.de
 (mreue106 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1Mduym-1untjN3pBe-00iwMd; Wed, 14 May 2025 09:50:16 +0200
Date: Wed, 14 May 2025 09:50:11 +0200
From: Christian Heusel <christian@heusel.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.14 000/197] 6.14.7-rc1 review
Message-ID: <e15c1189-ca41-4fff-a5e2-1faf3f5cd737@heusel.eu>
References: <20250512172044.326436266@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="eoa2746jorp77t5c"
Content-Disposition: inline
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
X-Provags-ID: V03:K1:gbXT6haEMcQAe/Lfo1+KLm1ogB12H+n9UXmN+ULdOH/2kRFYhW5
 n1oBn7xZxRSTxpmQzmCBX9hFEcs/945/RmYsNUyCsDh+rRJoM3cgkX/dJT3+4xYgCA5WJEN
 WFOYEInNLHXWAJmsIckqaPzDwVn0bjHQPISCrii92+mUrh7cm7ENRqeKjnRMX0eVBU61gEe
 ARyvDf3+cG1Y65Ux1Uj9Q==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:DOrWcrNkDl0=;Ln8XZW0oDRfulTcIpLKc/STfUFD
 T3TlIzil0aYTrtDzkWVZTK9Q0dVfSn0o3lI2es4MxDADmwnoYWoI8yF8tUN/x6tTV9k8Z+wIr
 qOVk7gOLoWOevoNk1I9VKBoIsaqRiH0SWH2TaXdp5XM2jXNd6RcoUaw0R+VDONijK83FowYqI
 kAVack4epL06Q1GyanNRc3JL4GCFLcgpnlRMtkblb9bAQYAa7YzmlJck94n5o3mZCha8XXB+s
 d7ZtTISl66jebtuU1wEW7qmCdQSSqR3gEaLTlI9oulvx9WLcSejSFedLz4UixP4enq55qGmtE
 5Qk/pK6sIYA5P0T6Lrn9yF7lmz6Bz2IEMWxHPIPHDooaN3K76XmHjNFw90tq8WfKrshZ2ZL3B
 nXGkQSWZtBxlnExjsQw7EmFq32DL/DiR7SxbnZlBpuH31hNCv6dYc1L1P6XxhDQjbo3OigIlG
 x9e7YGK2BesTom0FQs41QWWFYWIv3GikoJ3rS1E31vfpaUXh2XeipO+M5icSjRDLCppWJlimC
 HRc6ZCHHkpvhfmXec3uUUlnyz/ruU5Tf7/tVNbtOs3Yy8OX7Z1M5iGEwAqJc0jkcTP03gQI5h
 6ROTewcH4agQIg1EIpCnFi9MTD3d1dpM/qemNFHCksDCDJjWu390kyLPeuRYeJGF+7AxatgMI
 ZseVKb2QjrOfYwD+BbOtLhK1IwSEueoACFOqQQF5sK5PAvA1HYZrTUgIgXbt78eocMBtgvhzF
 TtF8M11BLVhbWvfVpT9BDRkrr+Fm0w+dHZgXWNeBVXU6OYZ95K9viMr1/wG0NQQO7JDJW3+XW
 7gvy7qztDYsAlMsVtTq4HkS+6bHt+cIvrJeLHG3Tb7w0vXvgegy+V898gr7H9SUh5VdlbJTy8
 xnu1S9cXQrnD7N7gCflUR7sp28EUE8VmkJj/HfNheuD8H7ID4XB6ijKYApi0XGGOvcuj7+Prk
 5xfcGFUIcJPrGCanIBMGOhioxEwTwFFo76N2iMoJYYJSwTotES9WLTzq+CeUda4rMzU5uQnPL
 t7+wvA+z7D7P04VczPcD8dN2pa1/KDs/128GZacfKjeDAk5aUN2tMQYd4tMvbs6rC1ss36Ekj
 65FMdIOkiPPnlIANlE1RcCpydNKKae3sHZSwH7gHuYykOV1mm6cL1Ot/Lq7RJRmit5RKXYIHx
 Wtt0d4lg83GuMk/UrdLInYk0i5B6u4h8Rje3twZ8RWuzVqjbxqhvrtzDmK+XjiPhcwzB/p0Vi
 z27d27mf9UGGMSax9NPoxSjYTqfearBThruuxOzT73WsC6pJ87Y5rzBt4DaEKV4U4DBhGrTUr
 2VL1NJx0K1WLz8MTWetfYd1zaIJWj988Sl5Mcq3FA2EUbwSLkZOf1J8IInBGyM8u6Vpdg2evE
 AwC+xws1W3voZ8pW03u4Iv7lWfV95qSwI9FcC+FfB1cJCszJBfXcuI2jvDiWi8kIQtfwFvgHk
 AtyKJ5Q==


--eoa2746jorp77t5c
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 6.14 000/197] 6.14.7-rc1 review
MIME-Version: 1.0

On 25/05/12 07:37PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.7 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 14 May 2025 17:19:58 +0000.
> Anything received after that time might be too late.

As it turns out my [previous concern][0] was just about a bit too noisy
logging facility you can add my

Tested-by: Christian Heusel <christian@heusel.eu>

Tested on a ThinkPad E14 Gen 3 with a AMD Ryzen 5 5500U CPU and on the
Steam Deck (LCD variant) aswell as a Framework Desktop.

[0]: https://lore.kernel.org/all/32c592ea-0afd-4753-a81d-73021b8e193c@heuse=
l.eu

--eoa2746jorp77t5c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmgkSzMACgkQwEfU8yi1
JYUNOg//WRqjquS5bV7IYbM6vdnKVi7bESIe2ce4jguJp17CZQ3+FxOvQW0jYsi3
cgMojZOmhWh8xby1gm4tEondsgw3SNdRY1fE8ciGUIKrJVfh3PCdRzxJFSLiXky8
E/5gP4cNFasaa4gHrc46Z3/4VwcMfnCzCvPrS4O+tS78ubpV9GrY3znM+nsKNGPP
qOeTv91Jgo6akiS8m6PbdwvfJkBvAOOm2fzC4mLuqe1QJPuEoF5UHP207H+2hQa5
bpVvc3Jelxrwfc/D55dd8PGoPua26IdeF46l7GHB9CBWTYjz7IdI25xnfLYo1ZC/
W9T9G1IXj51KP0iv67J8tdmopy8Kc/5UzggQi+4np3nEBXjotO1gyzJqLck/QbY9
fBuagLNdrBxtgK7vPAXCrJ+HsV/Cb2hP9bUKlZa2Ft6bArIfiewCH8quNIKOlIAk
frLpfB9nAm1U3YaKXCgCV8ZpUiZnTr+mzsZUePc7qoaIaPbXb6IvMzjmsWOGfFud
ksoGdlkmYVlYCj5G/uHYEq5K52mgNDSu9SMiG4ltpGpFy2meDWkqRpu9U/5fasJr
LCmCRPgIzy29vL7Ap+Ey9io/wY6st+im8XngqWAn2x5EMBXsgA9RAtrDHtdh2Qre
0q4G6An0AeqhMfp0jOxlj6BPiOiS8RfYsZzpznk35TMe+Qo7tRU=
=kIOH
-----END PGP SIGNATURE-----

--eoa2746jorp77t5c--
