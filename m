Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9554718B477
	for <patches@lists.linux.dev>; Thu,  6 Feb 2025 12:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738843800; cv=none; b=FPb0himmU4jzWgdOxvepIgKbP/1K6oo/Oe1lV3UkWyJLrnuS59dKJMz5w6DkcDYWnIZEtTcj3oKZ56wWJ3xmwQw+hCNX3sNc/DnWUDYWRDsrm9qrZW344NFRmLcfcVY4/c7fPC+z7jsxA62ksvVD5JxJxPA4aj9Wwlsax1hrKCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738843800; c=relaxed/simple;
	bh=qkU7mN3WsjPDpBNtFt3YNB/Qn72CCJ1Masnk7K2NHIE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kaao7QmXnSD6GRs60E+xs3Sma6a+P0mxD7MGzFXU0P1/wGkXvsWi/cQxeI/LG8HWSKvlbYJrncHYx14VBcIfCVOniNkbP9uxjXAS6rYB6znOJyuLwpJzpccaImX+gY8ZMLHh/qwCCv7IYwqSiefkygikq4MZRLvQPB/mFVXZrus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=iQCxbAkV; arc=none smtp.client-ip=212.227.17.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="iQCxbAkV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1738843795; x=1739448595; i=christian@heusel.eu;
	bh=sKaacpelINh+QPZCj7WfmXqNHAh/vXPNTGfxtluWYqg=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=iQCxbAkVE4lDlc6tK3uyxUHeTM/Nw5lQjEqyGxlGSjPyrqS9nn8rl8UdzNSaqtJf
	 egy7zSXVu1yCq7Vcz1IGWHgGku87rHGz4YNYUK7cYiLQ287+WmZHqd4KD7yrCOnut
	 5ztFxXvt4YAN0I2coB+k84wZ2MDY+GPwynoYzlIjITo6VnOFajwpcNm5NNPWw7v76
	 XIZxXfBMCSKxXZeL87og8KfO61IBmj+eSB8hueVLe8wm51GR9pPCprdHbBp/PnEkV
	 oA5vKNFahd9kAVpGstcq1unyPaHBXtIhpKHXi/oPyxEvNTU42yLPKOaFHwX89Gjax
	 lW0ZftacN1zZI9gM/A==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([141.70.80.5]) by mrelayeu.kundenserver.de (mreue108
 [212.227.15.183]) with ESMTPSA (Nemesis) id 1MI5cP-1tbJq43KOl-00Fthz; Thu, 06
 Feb 2025 12:42:31 +0100
Date: Thu, 6 Feb 2025 12:42:29 +0100
From: Christian Heusel <christian@heusel.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.13 000/623] 6.13.2-rc1 review
Message-ID: <798f3ac3-ac78-4463-a2cb-68fec03f8136@heusel.eu>
References: <20250205134456.221272033@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ouvuviv5axtginyy"
Content-Disposition: inline
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
X-Provags-ID: V03:K1:h+PZD6BVMcDnThJ7eIWrKvUJMEFfpEYRpQWcYef5xzHcenUCVXp
 tD+FgW3ofNvGF+rw6WReYBNpmrfTOSefs0+hShoSuSPLksUcJ4V2S09WxT6CLTK2+pRsjb6
 9IGrd+77DRPrmngIoEmupmBd4IGR3FLmglbOSch+9zW2chT8cDbNJorBKr4B1jscF2QARrE
 Jnk1nHEeColYiTdXDD2Fw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:W8M2GPw4gcY=;70oLVkX3oCOf+SH1QiUmutR17Z7
 q5/B68wo7hHF4XyW1iEmtdHL65B2EiCPPvRSfMBo0ZzCNYlD2EUykUqSzVnhm5j0pwS1snBxz
 eRpHk9b8pMm47hAlELNtKaUvw1nMMtZGPUNVMGVit5Z7/o0GNL/060SsmmDdHoCwZEK0Ycouq
 G/OrvtDuZpjdi0I2CIBX2xR/WMLJfF71xkL+x0SCamvdBhl2bSoE+4gZq3XT0wru+qCv1wOrU
 ySifQ1CC06CLSwe9hDdTwIdT3B+Pkh+S7lVioX1YjvGNDVP4OFBFa5/BH2lAdK2/fQAXfyi/K
 LARuiBrfKwyzzAjXmlNDBtqA+cXEi6saLpfk7at0RDcw1iW+W1a5nIpdYrA4wDmHJxM0NeRj0
 6TlDLMypK/PnpVM/QITDHRLpmWhcNgDxr4VhuRWlMxzISwj4SkE7UqaV+z5cJIezjgVa1HBcg
 JI8qeeKpBqrTIz4AbKV8gv9sM1M1vWw2CsZ+Y4Z/wQTBnBgNQJE06LI44eWiiyEK640A6pivh
 Grz4yEcPKrqnq28Ypy3F37lT+7hYdX88/9lV4FHSMxb0fliGZaUOQlf2J5NdykNOnN0g6Z/un
 /VvnW8/6FQGOACrDbNEuXhtf/VB+NOEIEMUxPyjdRatF5L2c0hnGzextd2rmRiBTgPPqx/IOc
 JFUqXG1ZpwvEqRLO0PKva5jnsVVfN4kD+u8eJGJ3/EmG6azfi/B9ms0Ma/tzwtrvJ441OYJaJ
 uOFkrssZGl5qZZIG0o7cjnP+LJp6R0qN7TxnCwEUSYeplgPU3dcU98jRWuQMm//j0FeYRBcPj
 aXSf96WPfjlWn/fXOTVTLN7BHL/w7MQL5sFF7QHAaGO1lUcQMrMpSfUHZpo2mYQi/JGT+g0Eq
 zQ3+OR6/8yB8WuO17rEN8Q5zMzPDRP1kGkRhJJVsvqljLHhMDt2LlMcY/qLpitdJEOLeBtYHu
 1qlUz3AYVwFV/VpPFYOmPlGQBq9fcifgS5RPEWOiplMNjjY1Wk/fTedHJioxUEL2wMiU3DO/Q
 iFRlWp1nWlJ/SubshK9IBIJ5zrXArWkQ2U61wUdDL5BqnPveB8Yu6G3gkWQEU6OsrIdQKiyxJ
 hLMxN3meNy//rRbBxn+ZZ+2lmdsgLGX8q8Vo/QN+lB8pJnoX8d9b+PYryn783q+gTfz4Or3wD
 xoDL1mZz3AfbzeYFrdV5hWsMeEra8slKqNedKBs+IZklNh5Nhi6Qv1v0efrY1RJkg0yhUScwa
 Bcmz7Fo+vAroqcocfw4nNHb6MzmeIGKsDQ9nq4oIZJIeM9BXDfzzjvTm5+vWg/A2fBHCB8FV5
 5gxw2fMOu0TGFRcGtJpRaqQJYUOrBtdRH4dAeN/dXGNtW7Ot8pkniK08HY+KTqZxvfg85nUtw
 u9rYGcnxfni1z9OA==


--ouvuviv5axtginyy
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 6.13 000/623] 6.13.2-rc1 review
MIME-Version: 1.0

On 25/02/05 02:35PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.2 release.
> There are 623 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Fri, 07 Feb 2025 13:42:57 +0000.
> Anything received after that time might be too late.
>=20

Tested-by: Christian Heusel <christian@heusel.eu>

Tested on a ThinkPad E14 Gen 3 with a AMD Ryzen 5 5500U CPU and on the
Steam Deck (LCD variant)

--ouvuviv5axtginyy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmekoCUACgkQwEfU8yi1
JYUouRAAsm7lYVm2lu6MTYGEL+LLpdZ25cGOUjAGsZiWra/xJQqXZXVLEpcjOLL7
BSoliqflrtMVpy8xZe2/2Wwjhw8boYP2DVrm7sg5eH6tg12Z/rOV08tOvL/wIkxg
ewBTdlJ/niVGwmndRjJdGXcWEr5E0Ll/57mBfF6HCDP0opF0i3ijOxs/IRgHg3IO
eikRInbaUj2fAEbNSKEdxTMLSigATEQC4VUgANydBvqF0aS/zP81alyCjAI1n5Bv
GRXwfI0VhqB6nNNvaJvQJAFrXdaJVipNUst9eYVqsFo388Qkaz3r04TwdBCwKbMl
kBQOUjulv/fyAs0W+iIoVNt4fJcB585zCRC4P4Ql6ugwf+4dlTS8plQWoqZChFWc
9m9Qg0WSzr/+aYV2TlZzu9aTKSr4BNk8HyuKAujVbrVfE+smrSCu2q8vEVZQm9YK
I8tGXEmq+RNCBKP5BHJxe5AysDQLZbiWihikMfDj8prX4O9PkAx+U0GuCxsjTLoc
vmhpZ+0XTp1Wd1u+k+s/7tbPne9snozU7Im0cYz/2OjN+Jifje75WvS/KjamIfgn
BBf7N4FCVPGxG4hrKSL9YUH3fYAw5ZXvUGBTt1Mw9lJdlPlUCjNv1XfdBeDtjney
bvaBmqua0/7eRVl5F//pMDpdOq2HUFoWZDbZZ+4K7IGkTGnEBws=
=m6t/
-----END PGP SIGNATURE-----

--ouvuviv5axtginyy--
