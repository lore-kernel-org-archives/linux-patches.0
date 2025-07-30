Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2042D86338
	for <patches@lists.linux.dev>; Wed, 30 Jul 2025 13:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753880997; cv=none; b=qFm85Aq9E/nXMKe6tYOHqvkOEokDYgSzVwc1b42SQ4wmo7l3VaYknCw0XAnumoyZ4otlRvGSr2ZLpJoE0E2oNHvN2XvXdJEBy9FgIlpwzu9VPevAQ1qrlVBKYIKTakj7mXh+pqzr/em8NMc2/C94WGch4rkxaG67PPK9dwkYhAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753880997; c=relaxed/simple;
	bh=lCuqhOrWg0T3ijnvoon7IE1CXll6OeKPOnk5bcyzb00=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EIC0JhzO0rpkA9+TJz34vfZ7GSukXxBw8gasH1hvJT/iktpooNsyo0FxNQoUysvepPjBUD2+dCUKREgQNQht9DzmOcCImHU4QYPYuCtMap7s8FDsKrKobUVSpzlka+sqfljr6YDbosBixm0xUIk0FT7IzFJbp/0g5cDfr0XFO00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=E1AglkOt; arc=none smtp.client-ip=217.72.192.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="E1AglkOt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1753880953; x=1754485753; i=christian@heusel.eu;
	bh=F+f+ZzjCVEINsWps0V76Rygvtyr7S2FjfQcZbbWPwss=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=E1AglkOtAonIbDWuAetbUoJWBZp6CY+WraoCBm48ZXv5z50OQXSpxEj8N4Xr1Tn+
	 fnmqEib7UzoBR3A+CFEAkKx+v6Df1Ic4nI6uXO1r/o3i8MGMAq28kMYqXHJZpA2GB
	 K4uFAt6i+fgbG7BtBu7yjVH/2mF7k6HUm03pt/F0/2/3mZ/VdgoPr6YI62sSXAx5o
	 1VltPo0EqQgy2HqS3x7oh8EzyKr6+/NJdjXbFOgOVkTSjllKI18CyvtOZTq2B4u4O
	 8KiBhncXPGqbDx08QJqWR0TEaf+9pQk9LidFeDPq1ESqos1EXhV5rc/Uqa9xW7yx3
	 5z+DV1tKcNvC8Lcbww==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([94.31.75.247]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1M597q-1uiD1A48nc-009CYn; Wed, 30 Jul 2025 15:09:13 +0200
Date: Wed, 30 Jul 2025 15:09:10 +0200
From: Christian Heusel <christian@heusel.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.15 00/92] 6.15.9-rc1 review
Message-ID: <a200f754-82df-4a66-bd85-b0ba0c9ac345@heusel.eu>
References: <20250730093230.629234025@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="qw7jpb2xcpdsmjqy"
Content-Disposition: inline
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
X-Provags-ID: V03:K1:kuMtRY/zmeaeg3zNX+ncSB8G5XJd6JH3T0cqn6L3CfLcP3mwDy4
 zhUCWrH2MkBzGDLyFIgTMVjv8nez+CxvBvWTle7O6MAKnhMO74K1lel6NR4GrbgHYWtllao
 NGvkdRZFgCrqX8uUHTZJ1DTEUrlJ98IkqVveFa8LH8eifVAlVJhB8aRgRrpqUC55iQi6H1m
 hI1i1ioHhG/xq6TRQvo4Q==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:rbg0A307XiQ=;lxmp2doXNQZ4iBD6BQyGZXPvRtr
 7VKxH/uF7ZeLr9ioyxq+ko5MctAjyNwWMa4AZscGs6nYfwMNkm7Wl59kh80m9mT8yGPjtC+k6
 YNNnbdugHGXwkhfFvOvQrE5FdN910lQbuNhv522ECsZOzdnLIPXBYfCw1R0wbvQOkvmwhErw6
 t0QOLGlRsEKk5WCEXwOMF3Gjz7i3TiZCqRML5oA8GqRyQ6NpozfEICy4+sYkN9UjpTevBs4pE
 iFhnpNvYi6/xHRAsfuZ1HjTLWDOL4Z2gZ7/fndIuxrOl2kBQCxbeyuOvWvWUBFtcFsBU6sEOR
 dMBSrvIs8bF/Esuuo1nf8IC3/zvBw8YY4z4cpJUg5oq/EbIC7LXoI08NcPT+KBZ67u3N+oOiE
 jimoo8Mj8Op5NwdkfN7aBbZMqHtRaIUYpk3aK8hGAskKo6hQLGykf/3f5FV3wk0kZP3Y2MumN
 0cp7Dv0V2xmf8/MT8Et2WXe1euk81ohNxOTxKvnWuetyjK4TOk0+a27zWGyROOg7vPwskJ0yd
 hWp+QjroEpxLnz3feEmRZQrcHWeYIZj0MwYpsa+fxvvJixulfPrXqZOzNrfV1vaSuOeO+1KYM
 B3zqSCA11eSbjOk1VaZnAOHezMVNmDV4P+ocBz5sa7Z9dUx+ervX/uLrsBJcGuyKQL9p2AoEE
 erB9suoYd2tg9rsuo+uSP+2n3U6ef0hKNjXSNy9aOT9yxCEAAMfh2nSW0LkZBKKdMpnoPQdTl
 UFNP6HnfIjGvKurhaoCi/OwVUSQc+claKRQSjCJlgpOQIkjUZiC1Zl9SVxa+/dJeeA6kBV7UX
 lH26lWPcjSSXHpZcbn0qWgCQe40niOVIU10hzwjKko6QUMrHb/L43rrQbIYxWEMzbgQGA6NiL
 zkltN9YKxGGVgRicdggwRhmGP/iMQrsYB13dR/IHPB4gOIZNaXa0PGBLQgXX3j4MkDqBR9GUi
 WW8nPKjKoX7gqlQeTha4tjaWtJ+iSBXV4QwgY5v7JFN7qPA1P58sAJCv/a9RU3tq/qXMtYfMB
 WfWRSmfWGmb2kDQBGGvyPpHRpFCaw+Hl9RBVgdptbR+KCGRzaP5SYqzIXLQLHEB6AD6TofRPT
 1geqr4GMuxakgQpuhiduFmD3e1ftSZuf7abL3sK19IeYlLaZJh4WIXQB9Z4JbZjE0k7n+t2nr
 G9MfkfJF8WrOUQBo9/uY1czgctPgQ+dofhPzgQmt6Lnrjo72Ik7LluZ85YHLvnZBCXyoMn0ff
 zdah3UTAkaORm5JTxFW0DwWolYpAh57sOtY6N0FCnUHy2ZUQF/vXnnKTlqrCX8Xagwm47ehk9
 q+JquNdxkaDy/bCjEktD1koNq+k1pFTfAJkx6ghO/l1fLh0MHPHe1nmGuLb/c/JzqPcO7ODqk
 uSXU1i8qh3h8M5rAsxajOlX2P8h5+rTHpx3GtpDh7UqN+Wr6eMP9SVZ/7IOl9Tm0aHDWscZdQ
 bdja5GDjNOXSUcPwvYOfH9ll2V4+PgVTLDDaL059Lhf7mIsbBQIjqFKKuKarpG6dckDfQTOw8
 /4e0FyC8FamdTR0Bim/9zkCRw0gN6pRUBeJi/8EIvvXYCXGGCAcNziCXX8wWYa1sRZn62Eb1J
 uw3jDF12tZjSvxWQQ7vKtSGKXSD4dJr


--qw7jpb2xcpdsmjqy
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 6.15 00/92] 6.15.9-rc1 review
MIME-Version: 1.0

On 25/07/30 11:35AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.9 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Fri, 01 Aug 2025 09:32:07 +0000.
> Anything received after that time might be too late.

Tested-by: Christian Heusel <christian@heusel.eu>

Tested on the following hardware:

* a ThinkPad E14 Gen 3 with a AMD Ryzen 5 5500U CPU
* a Framework Laptop with a Ryzen AI 5 340=20
* a Framework Desktop
* a Steam Deck LCD Edition

--qw7jpb2xcpdsmjqy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmiKGXYACgkQwEfU8yi1
JYXu/g/+NxM7Lexz5g8+vNOzP2RphQ7ymAD0vecStCKuZl/BdhkPtYzQc+OIQH0m
JcrrUPZwHE12R5XuV9JDHwed41Le9yorD8A/llddnyTBDxYjQB82KKZD5+XvoLnU
wj7JiIP+TQzYE4ZiGHB5t29Z0/wqraoBGT5UgaJrxsOS2aEncqOnOyVGCFjqwpmW
wFux2qHuaJaqXT7pArg3qdwMYdqBfNi4/EwOJfZit8rCpJY57Ln68bi5Qle3h1rU
A0heuo42giNQZDizjGo1Yh/RZ2xJLwxD875Y65B+pZJbLEdABYa3LsYXz1b+KN25
3fGjc/E0zWKG11hyrmHrMl/Km53KjkcNKokXof0Qtr5br65yg2pyD8vazLiUJCaW
tEghoKViV3vmKV1vxKu2D8t1r2eUQcI/XagD0mh7CBo6dB0Vq/3tDR7usspCzCyN
RFQBec7xBOAFMdCOPFFWFdcY+XQFRKfYDjOS681Mwu5h23qCjSeaAn57ElQjJCoM
Xa7wq3oWo0iSAE8uiZHRp4TxdkJSmmycZLxiSGPy3WXyzWEtP0S8a7NeK7joJ2JU
cue0sArzEA16aiYLqpIX2fXCHVeYLr4gVdJBqBraD3eCXzAgt2I/qKkiJKd/e4k8
te2Letxo9H/EgwbkV8tWDJW375GHXv5PqkOX5g40LbddkU1DIbk=
=Q1Ru
-----END PGP SIGNATURE-----

--qw7jpb2xcpdsmjqy--
