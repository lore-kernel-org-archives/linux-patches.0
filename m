Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.135])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA921B86FD;
	Thu, 18 Jul 2024 18:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.126.135
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721329078; cv=none; b=JxuT1JvPwXTVsouuvx/FHmO5AX+CJJEgRFvRq3z2/hHr5begpBLlplvCNJalDXz4SkWu7jRz1fWwiua0nRj8Q8sEKiX72cILCqCKExLd6tJUbt7JmYlkpIkRP4kE13IW7wXLwR/lpKuBarx0qUfbTsDqaS6lBblK2qQEoyBi9DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721329078; c=relaxed/simple;
	bh=jWIr2p9q+APTlA02P8awT/Hq1xwOmy8iyNMZDtQywyc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qH7/zya+JPHxwCWQI0v8/7hggXv+FFcbI3/KzTukAax/1cc9i3nR4ub0v8zmEXGQitDwa6Xclz8cXMWDo0+MLoH12kMKarVJx6UY0ImDkYcUxehRYCB9CAiM2bopPBs+CRCydqT7WHS9XE/8e81NZsEHU3orfCw2hdtQt0FSgSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=zIKoa500; arc=none smtp.client-ip=212.227.126.135
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="zIKoa500"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1721329028; x=1721933828; i=christian@heusel.eu;
	bh=pasceRveCFkn1+I2qnzr9ZEiAmtkorF811Ry/SVshWg=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=zIKoa500aTr9p0u74sywlwEhn+cUQHubQk0tZqFZmLV9dR4HaM7q4AbZkLAsQOrU
	 Uf8bq7wxipUnbDVkpuPGZLEcCg7lHIuPDwRaFL8sxt5ETrwTLU+EaDqTz1aPcZQto
	 SFNVIqwKYxhCL8V16zT5M1Rk8+8g7UsE4OKm5+64WiIb1RTi/k88UKg5C2rQkTiS2
	 MkKfckUpO7aIK1u8QYMiZdBE8xNBihChLS133dy5nevyz0gleWrpJcNBCOuoZKzip
	 u43te/iGVjuvbX2KiStWbNMAy2ZCcxR7nebMK1RlzrfDGrzB5eaTu0n0ST+FJtRbj
	 jC/mKqxHVFp2/bQOxA==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([147.142.158.42]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MZkxj-1srnyF091L-00J2Qy; Thu, 18 Jul 2024 20:57:08 +0200
Date: Thu, 18 Jul 2024 20:57:05 +0200
From: Christian Heusel <christian@heusel.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.9 000/142] 6.9.10-rc2 review
Message-ID: <90470268-4e53-4667-8102-38f1059d8e25@heusel.eu>
References: <20240717063806.741977243@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="vqaie2gfvhvbkzao"
Content-Disposition: inline
In-Reply-To: <20240717063806.741977243@linuxfoundation.org>
X-Provags-ID: V03:K1:dwWZqQh0pX0cFK40QZ2IgXmiV1UEQ26AvCed0edPxDRa3f2IwcR
 xlRD3lxXm9uKHdW5IDl+xSs15jUXlNhKtTBdK1nE4yNnXLMgg6NekVoSOx2zXLBpVhHeNg1
 pXXeSy/C4inXHfafDjh93Y1BGFmL536eH62dDS/RbjQ6ZIfSrArJSumZx0wzIWuqGSwkJM1
 AFyui8I6Pg1io0RJI7lKQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:LPailIGziT8=;DsTel/T6L9rSZYSat8vc4pz+Hfo
 wfbXeaiTqWoSr+hlf67IVLETYSKRWNft1UgJ9SigAnFPDzHH15xUfIkAe/XV/G+UOAgxySgOP
 6r58waa8HA+/MEgcMkLbC5etDX1sgvBA/L/w1jrz6CXvTmSuSykUiACJ4vAkQ8QUH86SBlOT2
 avPyy/i2Y522M4mqp9pb9bMoCF70McSVNJyPu2K8UR9uya5HuvmaaEFlC8QO0LvYabmAH6fr+
 3pRNf7+5pO1Ns+xnKMbhKPyQ7KMBOHG+lqW6Z80qnVxsp7+vY7+9gLgz6I5SWPBINS/JTum+N
 IBrPYErTxaa6P4MxE+/yaoTQvakLVccwGIT9oN2/8GESkCHJYiAL85HVdXi0zbDTgsb3b7Qp2
 7fGLS21pJilUqdJ5WUunY9h3oB/rgcPcsHU6gQ/hTzXjK5W79IcImwhJeHzmNlSReU0eh5esg
 yYOmY70GINdcXvSKaA3KJoTU5jh3Hzv6F4x3kGW1HXo2qlStbzxdnWVXChPpqtZ0H5QqnFjaR
 KDDq5doYDCaiZrxp5N13l9uVHrJQeEHGHapOBr0XlM4FfejWaXfszKFiFLQnZv4oWzf6snsXG
 VsSS/K8Xnh06oUXm76qxPG731LqDoMAy1MvncWqtsTcjAe/4NdBePJ6wy+gv9+VUAxPWj9tz1
 A6V7xb0I74k8/Ih5o7msoB6RMvcdKfQDiXXETMQpr1Oen9ms+tGuFUEUTBZAOVezOo6dpn/ta
 H2Q9tAnBD4L5LoY4pcOcNMbSTUPFoDORw==


--vqaie2gfvhvbkzao
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 24/07/17 08:40AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.10 release.
> There are 142 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Christian Heusel <christian@heusel.eu>

Tested on a ThinkPad E14 Gen 3 with a AMD Ryzen 5 5500U CPU

--vqaie2gfvhvbkzao
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmaZZYAACgkQwEfU8yi1
JYVBBBAA4Ek4o84UKsxwDAEL4G6nWV7sEPqbJ/BOCyZGkyPYlzADhkqnorNsTbSl
Sy7wyAfspvanYFcLFRGQK282YpobNA80zY9m/nPr4JdHVsBzaMq04w+79+0UezDN
l0IB4BAaY3DgvgNJZ9vY09eIY0sIUTPcuuw7d299FsHYeyRnCj+6Rw2PrgqvTr0L
pLXW42MiRaMBW2LcP7mOQIkQwR4/NJw8SoKjpnhkyjVyakZ74jT4//HPodvD58xV
8n2PqqNFMqNyVvhAGSXltTPksyJz9pA6kR6H2SOylU68LQWt65k2Q0iJsbceVYtB
eRzuiDJixFEty775J0J2abyPNNCwvWYiMYYlARUjy6Q+kfsGmCnVuCX8nQJqbO9i
jy5pE2A8b68EPL6SORLjC6o00wOEcvr2U1GFsiJ/Vg3M1gBkT/W6vgw6DVqCXatq
TqZ/SfsFIRpcHYhCzY+5HotbKAyMouNbihk7kf7c1e3NJpoyvxsEsAyQLQusup5o
91Je++yQWE0elpJpWDByRZkKIrtnAgumfX4MVUe68o6dhtvCD1CvH89q7obRmnJP
3qVBmuKKHHZqJ4HwMJhZh7Hl+uikfIfCGYGq1jMPFRQ6Bvqv5vQynFA9aqaJHoEg
dwQN2Ee/aOeIFrt5ltBF2C7XYIbX7sIHxCY0dR9zDJ+S6oenAK4=
=k7Hx
-----END PGP SIGNATURE-----

--vqaie2gfvhvbkzao--
