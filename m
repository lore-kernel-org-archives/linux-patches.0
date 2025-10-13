Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E3425D546
	for <patches@lists.linux.dev>; Mon, 13 Oct 2025 16:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760371787; cv=none; b=CMUTnjJs//iUZaTP6yqIBgQ9zQYtP09yc0XWx4z3Dt3noc4+QmYNb6Tto7cOdKiJFcGzbcGmBbFfyy6BtkQMsFCfdoGWhNp3axFaHyrFgrqW05sU43/IBkuITDAIlj4ikweMp7f4SsgdG8jmzGklV6FbH/XEu6TokJSY3/LtGxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760371787; c=relaxed/simple;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lVrMgVswnq8fMNUEP15j22GekR2Gm2rFEc216ELioHopBn/Q+XfI5es7v5tmkICMvMaYE/HgWZMuQpODdXHeQL3swKAm5g4BBhqF8KtG0ORpAPCoots3INpIENvXIVm7eji7CzGChVIyn0oA572f61RCnkQbJhfD70jaZBMsHC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=SzVKjuz+; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="SzVKjuz+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1760371766; x=1760976566; i=rwarsow@gmx.de;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=SzVKjuz+2Kg4GPJi5pa+ef3jKYTQj6YdULJvplIjvy0bNaFr8C2WF9x2WE9+WOl8
	 A6nA+g7CL65LUDwKbXl3At6yrwA0IlOtsHOuPsfGzGPT6Do9EndbDJB5Dx6wXq3Te
	 LltK/SMVDuOV7D/mHbj6t2aV9uGTXFaS5KDCXw+OGlmL/diYLxeQnqgFMHnaaPz1U
	 XOVF3rrJ1daPJlkbaOpNeX6tq7lwHczsXCkYR2iiEyS1HWpzgiyN52b6ACOrTe535
	 28Y/kooUpNay6IgHMpFbYaA9Ke0lBaaq21g9k4HiselV3e1iwqbhGyFgvc/90aMEc
	 cF456N5lPwsLemQQQQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.32.251]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1N95iH-1uCVU132nf-010jFf; Mon, 13
 Oct 2025 18:09:26 +0200
Message-ID: <52680ea8-4a3f-4e8f-800e-ce308fc23e14@gmx.de>
Date: Mon, 13 Oct 2025 18:09:24 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 000/563] 6.17.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251013144411.274874080@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:iIVicWcyJUsXE8joN7F1hufTLdbyO5eX5BQA7+XGeWbin9l9CUZ
 nnIQAwEoZcw5GSiJNUdJ1Dcbm2u8ikgI6TdKR0lJ7hWuRfEl8MDqPeW8vCJ7szOQ7IMkxsR
 /7+M3abt6et6R8SyA/i48BCw5U7YbouBzbTWyIUTxaH0E6Rx9eXue0pFmxkw66kEu6ZBgNO
 uj9DH79NZQ8XdJA60NYHQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:ZwcvJDA71tU=;ewJxswaqCCUtCPPTODkR7gPiYR0
 VD7r/GIRCej6qt1Q7slmBsmiZ6q9gYLuze3/RLCf8pQ2W9KfJ+g0+f8yVIyhCHKg0clovmoXM
 Uiyvw33EPpRwEPzC8o3KgL/vemjHT8oLlV9MlFlAadLLfurIENJ6RlAIbabGROPIt4fTiCWmW
 2v9hFn9OQDTyQZVaLBQm54vhRyy+8qijqLD1k3X9eAI0Xqfe0VFQS9Dc1OUWZ7xpY72kZg3GT
 2yebmfk9IboiAJZpdb+dmdew1QJ7IHkfRGWNSbdQGF7z/56Zk5FvH30xIWM4OBhrBBm1grdpN
 RgYzusBliZKrMfiURnwFWlJo2ZqBpu5xARQoTf3JtcdvKMKCJam8Dw6oF+7MEXdEusWVOaxMB
 5uArnYfJQPD4a9zVGUn36espIt9HrgxBFq0U+AKHui/115yhA/TflgrccPwMDAUsZ1zBxfZye
 t9YHhqsDnM0LjZyqbq9FoeM3zGFSC6Jz5oMkKeK/9TptSZs/WO1SzdcmawtfVn9pDvM3oH3qx
 E/f5TsoB7vXJC3KlaVTYrqm7uzmtlKtVFpJQAX7eyxF3MGrQkYRRpa18vW2zvLq6qxgHMZa3c
 M0bUv13Aybxsmk0dLBrN6IKOvKpJY394VquAYb81pXFosJdAZ9abVP14mEabZ3YjJagRzA8op
 G7PoOUYmN5pQgq/2P1E9FHrxMApAwn7IPaHIicCxbCfGEJpuDjX6nkWgNIdK7rwXur+5GMh8/
 ko5XsYzdcLJMuUdUKcRLicRqndnjBzkOI/Y5DsAaEsOwGndJ3tX/Ma129nA2e7bZhrShOwi9Y
 VGPwEVswOhrijUlBR6hJhj9hQqof4yifoCzn7VyP9e+HD4AmqFCk+QEylpHG22PimUF9dJxI/
 oMm4bfVjQNZTlD7LEA70Z13xo7MCmcRZD7WZCQGR+Z2/pu/6qNM4JB7tOV7qPa3wCoAIQ7Acy
 6o0e5eAnnAGKx2BOBKIOiBAREHlLzfqD1II/qdLN4sT2uXA1saGVJMPYGPk03oQaFDbYDz4HD
 iyqoEc5Egp87ButXdlnPAH3Em6wsa6mFFFeMT3bZhxOoFU+eocECKhsZCcCSFzzOxVMTgKBVW
 fQENc4dXOq+NxLpaq2SU9WkIl1y4FLqmEvNui3zLgNvQJWrS7lAi2PH7FnRpkEs5BgPinspCW
 Lmiuwf/Dfmkq9GTEXV9bP4qUbzd/TtKosvGsoRGkA2pp0kZk+kwVpCbM2reOKQGNx0hiNl5k2
 1b7BNBdu/0oNlL8vDK+Hzy6qn5AYppGlxspxHU7waKBXC2iKoRxLoprUrVkj34w9KPME+7+YI
 fjulCfB7UrL4qTFNrBMyHQPx9Cg9tt+oM8lfITMLP2yzgihSSWIT0BGL5K3YnvL2bjZuL7TXt
 S8KMJN9yEHwwOoIB+ETghnSZRCBjF7wiU8fpc6H1336aPtzwTaFoWzpv/Zatkp9vsS2l/lCyx
 xI6VtuKFVTlvIavAlLNW4TylmvvqCXVkH+Zyl3UTcjfCyRMhnVnLEGUfY83kcNXlsU+rh7FBd
 q5D3cMOjzwCvlSbZ3rbYt51dFee4A+Wrx4jjzrqWdz8iC55O26MkKMKy+6hiH2Sr5DfHws9lE
 N2LMOu1xc118LbXSvu1e8tGqQlz2viVc1XRCxqc/0cOKWZjP0IT0zy/P5pcsT9oVyebJiLM2N
 BQE10MLh5J9xae7NCKED874ACx+S9hXdWayyTeBimuZMbfvbDiWiRSp2PgeNelrvQybHnH8LR
 gz581xvW9ss4zOcoBDvBo8JeKQqcqoQd5S5KUe3kW1GNdSJuWl7A8/WrI38CnppDXRHPjqS4X
 EN0gdK8tXpYu8l0uS3NxJAPyao4gRfFMIclb2UEiuP2vcAT8ntAgqXOPYoe8RMG6n4i8RNUPu
 u6SxVnFUD9jiS88fOJP+4obfhUhJ3cDetAi5iGF3MyxsQKBSD5qDHPRZM1Sy7LtvyyssxZzvj
 prxZMPT5BvP9XCCVCS6PdApx8uBkcr38ESlsUKSpoOf9uQoToq68ZA2LRNP5Gv6Ne5b/gtlSz
 HSQTxpEeyMn8ojBFhK2vnwdkDuc3cBVYWzev04mb84DtAx5bvG8PWzs63/dCGGMqfWNf2p2ZQ
 9JbqgJAPFfSk7c4nUJkIBx1FFW2QJrAtEcAVIfZa95d9Qn03BDuj/zpKBJqaqf5Fje3bBpcpZ
 JDtHWv3TT0lpmoGgfEecBHnGjCaaIBYbpab38yP5c/0XKMBACqJHoq1TrAJlKcYInOfjojOLM
 jRSxfVwcFuWH/97sl+aam4PvAwJbaK4lcSKB3sSnePISw37hXbYA/qBwZLcn/dZ1GTtxoE6Qg
 VTHnbJdqZljrlXA9TYLc+aN6rTaBbft2lRw/7/fQDEuVvg0+pInzgcXjsOCUNDOYoGjrhAlC8
 46mABxeZTgmXETNep/ZDuJHvimFyg/gnP18O46mweLyeLGdDn8qavUgb2Ehwh/PCFqe1cWJ9Y
 B78sj1vf+EieK8yB4YPqqUEQny9SSpyLN3HXKMdBhNKFH698RPfbxTj9aJru5WjloPptGGWYI
 YQYaMGZRXDyowoexyfQCqt56LXTHgCHAkDzV4kQzCaf8IFdr47itWh5AqiebnXV/xp78TvYIc
 qnVlcM4oKB6MVIKXz5P51fgQjUMY8f3WL0M1iTvUHVlcnDzV7vljyxRjBB42ihuCDtd00hTPt
 xk8jlVeW8rXo2WHc6KyRMOTsZ6SPJP+8qQF4hLeFRoaYpsc5c6oVpy3Es2y4wUrsiisSB6SlB
 o+ihOTolrZNlx8B3WAdJUwa0m38IkbWVFiSSCHtJfmECLMEl1SzFW0JWoIRKzIw/uhFKW30LV
 k5bti1RMZHhQe2nG+tz/qNvzMEt8IYVzHS/8kDuhoMmCOlBd+62YLOZjOtBUXgQJq4zq62t1v
 hpzu3UPeGFSP4e8Yo7ALCsLDaIaCiY7ZRAm8ku/YcXYT6TPluADCbKsAqQ54u8gSgGyhvWGLn
 RGZTuFF+xKkyHnMYjvc/mC1fsA+AS0De+vDFnR03DAfeB6WAk9fAkW/LScaPvzN4/fllgY8+F
 R55U+VOraZObngxBgVLfgfNfFaPHdge0qj/lNYuHAHfBX2YEGZdwXEFsvpYlMOr4GFZeE+VOf
 GccMrBotlS4xWrpmbxUvFCLPgU7Qlt8d5A3xw3nlqhx63JtZ0kzM5rcX4w59L2tUt9W60pSQH
 +n4A4xkppYoRFfgtxhoNNddrsEvFXcDLSdSoAftqJ+6fEvoHrnpS6A/MmL+I2qQvU8ERxvYaX
 VXStO75IBlNDpkSqIl67NZYe0JBZ/M4ayeGheRfIxiV053Y0HeX/MrlrFsgeuKmMoVUypCKjg
 0Y3xdvPk54baCMxgvMjfjCBBiVtUy/SIhD0oLbJd/Cr/p664YoT0NpFzSrJVqrwend9a0nHM/
 6vu0rnUKR0HjsB+EkOGbLMH2doAyE5q7xXF8YJed6dYF8gyNXgS1cWrogWXjhTjUde0RZsQXk
 SkeTPAK7gxKZcVdPzuybLi8YfAIiHl2Yr+PRw3z88oybxHMtsVoNlLlxfzyxbz74Y2Ci84bEg
 FYg7ajRnOBqIqjuh5occkW677/JjSySyQyMeBfx4tTiDsW9O+bdAjB/hEqagAl5GnFgKUXHUO
 Vm3BPDMQmkIMH8cP5k1vhuTY1O3C9uYx4M8dd8xrw6FypahYy0fs35/BwBLF65vbElB9sTYxf
 4MojMRGyEYAS0ncmoNVdMw56/RHxpHjtSBc0diGVIjKEfCKkOHtUVFde9RkUYa48a+WxvvlAv
 BJ/RC6zj0l6Md9Fx+UXnw3NuWKm00J/VbYsHvqGexXw2rsDfQShfVMxXFCHJgh1/tppXwdxeb
 Z+3KBVoD/TPHkff81INTi7kVZ/Rok+i9DKnkePr4f00Ex5qvCaTDErBV4A+7erjeOrwYO8y2k
 qo92JCnC+9NXVeUZMwT00A652Wq71CtIXy1wt6nW9shd2sMjhiK6KeVs8ZwWz1Rq2XaJypc/n
 udSy1enIRbL/TDE8FNh9+yBTtjbXWftE358D4l6dkaBfas3NCqiW/xOzPXoPBXMOX2PG32g3f
 sO7AVaf24dfwKN8GiEbf5CMwk+gPHfWitrlt0bXWcTj3NVgf2+JWevIXyIC6cHYJWWh1FE5qb
 HbJVYrsk4nImGHLO+rE2B2rav6Qz8OoHiyYNeaIQOTWarVOx4RnN185UoDhgDyGYsWlyWmsE6
 OhX0ldxw9L/w3Mq9FwUWhTqmNmRWGEdiWyFk+roR7gvdeqN9AWZOggQ2pOyMQ8dmSLRYU/Hnh
 Kxz8T6zO/3WsrKL7HDH3n8INROw4yuTzriMtN4QTKkvZOZ1Yp9yJSzXYLI/cjMV9k5GClnxyu
 NNM5g+ilva9upY6VVOKSIM4BnXvjjgH64d/wxavFWISR5z5aEZa7BQHsHXgWvBczDz8ZlmP2i
 nC90hGRXt3J4s9wr/xtvxKOtcOdgxQmNmpsefuff2c3/xzDXR2ijKlXXIsSLU9tIdmrw1lLbB
 Sq2YbqkKTTqcRsdRzEP9WXUcjbervj2N9QNjNO/XMxZOl9z7yX+wWmbZI3LQOClBrorAMsJoF
 fpkc7US1zPEhtXDPLDcOOcZpFesi3vcJ+Ilc8nvcJMVAi9XXE97ppwvsefdGHvJFuiDPAraZo
 kfnpsaRbf6Jd+nk59RP+Ouq8eIlBE7f5nJ+0CDMdNjnJet3Vnpm86/8c9mux+t83Y9BdXHNN5
 lZgM7uIZkFiyjtxdyUC1LA/ffW923HX+zxLHGzAdTkRnhmLuNnMWjGNIUonoDPTBY13h2iMch
 6IWN7I+cOQIRUwgWRZBH5P31ORidDHobD6Ao1Gz9BKXlRt8pUCowzwUcRIqT93aek/E+2fMCQ
 5fDSwAwYbrCTJ7QZWrfQ5V5NAmu6w7sHV3IvLpONT09wwsN9TtKRzq6/RR2NFuJSkHOMqj68M
 MXJNV3CCVYRjlWTbeo+hg9D4/q5sCyE8h5z0IjR6l3wo=

Hi

no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

