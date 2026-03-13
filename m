Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75B61257828
	for <patches@lists.linux.dev>; Fri, 13 Mar 2026 04:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773374738; cv=none; b=j+FohYcO6LwHu2M39ax0UuNNnAaV8pEjjns5IQJoevHsmmbunvhyW+QMqrAnmGj3ChHbeDXUpa5v1pxRuKA11pmYMQsxUdIO2LtQYKo4Wzi1ylBK8Nq9QHgNmxexro73elfXrGnAPkoJDGO7c7E/ZfOWPfaNQqhP38ckcSBfZiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773374738; c=relaxed/simple;
	bh=1R+q0brxT5FCSRMOO/LqKS2K1GLvRDjYnI692aiflvw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lfFXH3f40eq+fFpmqF7GzNrw30J4fIA+XiWdv3K5wXmoc7butRu1tpWn5AbD063UfwPqSMTmjNdd82Ws33P2aqG0NpNXdTjCiuYrWV/S2L/7eUlAF5Bh/DjkDf6XnSo1fozb65sPLcPN6zfl7Ycha+dm4YRJ9CpsDtPWU56u5q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=L3SkIJ8H; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="L3SkIJ8H"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1773374697; x=1773979497; i=rwarsow@gmx.de;
	bh=1R+q0brxT5FCSRMOO/LqKS2K1GLvRDjYnI692aiflvw=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=L3SkIJ8HQ256r/ccaXOBY3pSdtr6nCCCEacjy98KmfTqRqx7be9yYhxdz6PvXFkL
	 78hO2Wga8EZvet0Qw9fZQ6TXuT7sBze6/MQPtzCCBPe4okaKa0t2AJCLNvKIiImFp
	 IER+DLtwBwcskgOyTJMB4e+4vH5ZguGubTQY+AbbCj0SOU26KK6ZIYHE3VsGxqiGm
	 F7ZLBzUw5WsNTRu1zjDVs61kbWxihWweBe19jYnQKcyvLiFBX4gE96eZB0RxOazau
	 dx0YVswA/81FDNnhiQAd/Rw1f8HNdoCVm2Oc1UARCrgxrBcRtvF7H3+tTSS1J2RZi
	 rxt2+y2Jyjx7HD9Yxg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MBUmD-1vubAM0d6V-00CCrt; Fri, 13
 Mar 2026 05:04:57 +0100
Message-ID: <44dd5e80-ae04-46a9-8913-255b888dbab6@gmx.de>
Date: Fri, 13 Mar 2026 05:04:55 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 00/13] 6.19.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260312200321.671986598@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20260312200321.671986598@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:MVkPFa+gI8+c1GZCmvX3uSEmyTGQVM2NYOHm07uRgUKXO9GIERO
 QReXk2CSX7a7hM2AUwsUdh72Lgv1iOR+YRBFDyFeV1GApvnEvop/Oi6XKXjrKPWgjIB6K5D
 a+nFLOeFiC06C9m1gjHuRSafOovsn+CE7IVJqv8PiGgjYZPxPSUxWgyrf3zWgkCro+iGGcE
 acIai+1roCkcadRpLbXAQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:ti0iUlzASqs=;I0v1l8pGCYSPPyR0D/3PQvyGkJJ
 oKCBtuptVIp8Dik7wApD1HCoH9ArDEN4ppavWiBTsJX1jgYR451e0UD0zmXUl1Gd3cDHIkZcn
 SGcyoFZA0uUhQH9wtG/jhoqV3GjnObkI4FGw9jVNRgSKFQ/34F3nwwJHBiA3bVKMpkZ0Ki+zN
 43dLOcdCdXnxq3pQcf2IaPH5/dN5lrgwE6o4lS1oHNGmC0dARfYW+k0t5yXmFdbF3Sa34mAS5
 iqS3rSRSxwQzdEdLV/bccQxr7a+4/iXfaqRZvukG1cCTMq/9+bljhR1nxEIrJcUN4wHwB4flU
 m2oyh/mcmCrAq5ayLodY6fuTrb29YIAyK7Qzt6Ma6Vw3I8s+rSUs5gReUoFkWh22TtzdFV4GD
 +43dFppVDRKfc/6mVEOChRB4V4DTiETt1nILRpYUNSIViX84ZvKpMkcmMEIFq6NvIW7shtrO7
 5hBSC/NIq4AMl7MCkx4qYGUKwrZnlwAyIm5OmTp8dFiszZehgI9TD+0GOJa5RXvD8qfg1tXsE
 ssTAKBg3KNdupBAj3XqbgRFb89GFBZ447PP4CarcwiIVaIVj+G9teYgyu6ESO6VrwSeY0/2K8
 +qFelNy5n27ObwWiaVoRqxljkftAOsqp9CBJu+eEFmIXYKL9YPEeXyD4E1uKiPiabx037vjyl
 QI8IuzcPLkTFFPpDuJqx3xfserBzjKbqMYphxGNnWpv7TJ8A71qJlcxiBFGFA6iNLm8rQEuNX
 pBpUbvZl4JeuRSci3mQVuWX66yRSLrxitDptzv4Lzfwa1empotc9MANrGXCUxqaJCCSwQVkeb
 uETigPeewUh8Oj/bHyH9ywvsRNC+1G27RnNLAi2KBnl3pyoMZhLyHipwJWj9D6kbYvXlZGuX3
 DDmSXO2W+4IlQe6+X6JYSbOMlPwzZNk8btT9rspUIPJcEKGdBT2M/atfpixpSAkISsziLs7Bp
 i/Rm0Jv/TTjsfj21z+Jf9VKtExuQxoP1Ks4Z7GVmikHA9JH0NmyPxiZZHgUucK+8kdZc1HRKd
 8PuKexQ2wrB1g0/wDdBPGPFTEm7obrQOUKVuwinYtotenkjh6vfH/OPA16blKkcw5VyHpQvlY
 2S50LbYOeL9d2w5BGwPo9SvcuCZ09eHcarzLmPee0J+gVT+HCwxvgz20YJrEIyYeZ+e1WP+wq
 XNB0qi0DRV3MpKib3Pt92WD/mEgnSBrt+vVSAieINcFZalx4SBg8OqoxlMYZlsopZkDQX0Qz1
 y171QS4G4L9eB1mhSRS+7wLziCRullbFoeRPtW1B9v++ldf2n5HyiO89//8ggG4CSB2Qj/iUp
 dDXp4ioB6frHk7ATiDsk3+QSmDp1U1KKac3q4kjfrAq9EENTWrFp8lnTLwkluS2Z8paCwttAe
 XMAhgcu/Xm0itGuMtJJdvo8fEfhss9OJ63yDt+vhtDkVJCl9X03wT4lpYdba8qeI9eNLNzU56
 yxKJE/F3rpFtn8LCZFCYBUqcFxcGo2calPgF/9xM1+aXkrPjmmDNU9EDRSoBxTmqLR31Wj8Mv
 wHsenttIkx+HNvzr+N/yi9vJH6nO2H8r6StBOrCONztPeMMe4D7djVWgBzxt9BuuIyIZf9Y7V
 Fk1BtzPxSBz2RnsL129cM0LZoZp7cskAUw4r5E5ijlaGYIgYU9S1YST2VROnqNaxGzmKVZ9nb
 Nwfdww5hz8ULavj1aefjpfj+5KCUJpbW+s3RwE/2KXMh4BmufRxbZ2Ie8lw32CGHjukRBC0td
 NKtbDBnHo0q7eM896hGuG4n914/MyDdO/DZXzL7WgUiC+KdoISQNdP696/j+aMvHcerPXk7Ub
 U6BwiUHEPk+j5q3HTs+yfZG3Py3Z10+PzZ0TYK5mNZi0EjTOlxrxNMlsZiTewqYguzg3ZrvUF
 jkKhckIgZXi5YK+75KjJYh4JlgnwNCSdLefBshtqUrJ5njMO6Wg0fTdY+7oHJOnfobIGRPGch
 Aud0W8AUUY+29DkuZodYtIsbFgMsEGIyRcIf9Gy8wHYmr6TBYUGgeJQFEm7KKVz2WW2YzaYNZ
 tGldrVwPTqpGh47mmtBGI3aP7nQrI1xMwFqRFMmZEEll1Q+ateJWNd9ay7xIiZNK2G29h4ibW
 qYLaCnA7IcxjY3whxsAP6F0hoBrXI2BK7C83CW10F+sBEyIyfOp2qdfF/RJbzBrw8U1CuAFm+
 NuaclEgnZscTh9KokuDlBF8UxWDXUl8FqhRIOZ1TWLmRoDKj73KV6G9VI0Sr9dxjphW5Bx/Og
 uZCz3TDHKKrsvQ6oqjxFgVMxCTlKemxfDQzWHlLbaeqlGhML9BnxG4tJ+F2z/uh1FmV8KkCHz
 mSUmD25NvLVzl/maIvQzgqUZuwD3M2TQ3yBcrrbArgAhZqaYgyzOLTTVUnpyXy4Aw9YxAKm2Y
 cHa6zX/19jpsN4Lullku2VnjrgAGtrAKhz7DLx1a04fvt0bQn8q0j2uKob98VD6z028qRy7NF
 b1WKG2aVAX8wpYWvqphLBsAZx5cDiqxMWSimI3RDGZadV6eYGYcZM+AmtiN84wIL4bitxi4jv
 nYBYBgO1nyqzyFf+Xb2UESG1WgwVdISVarEGxa//afmRx7zDyPyxVSNaP8zpJgh02Lzj5PfOC
 pdYpm3iqmF1GtCnISUCxgmjzBAn27wyIxPmd26+Np0/Tnbtz7dw3ij8I0JgGvXg5cFkvHP9gJ
 SFyNwCZ1TAW3Rq3qefi4jqvBXwpuTYr1y34O+J0SG6UQlKZ6o4C1PMNsvZ1pEeeoehup+3JxG
 v4tWK6+TZ4sy9HlLljh4NmE9+Btd6hcZhmr1HzseYp6Tzbh76TjXBUgkhs34EngCJkPcBNAgg
 BGbOPGHvRhS1m1qfciImJn5yq9bTe3+L6lp92iNbIwWgBjgTtVeK7Zn+bOstCjaeTDeuIPntY
 DHpg8/ZAg97kdPTsfcx87iAJbG2SnLpsMYbA6FPAaI9FbQVHbelkuxR9URck83rlQDGEJB/z/
 +K4mUgyF/0/SaoJvUO/W9x3rR970gOhjo4oqHTwKw4tDfPdQr0KC6wvsPTCgdPo0lxhNH/Zuz
 TWQJ2az7VqaQK0o4tVxdd22BH9jYPFxQFuxzglUDH+C426mt2NURDEwBF5ymVPtBDLhIvgyzu
 1G926eNAimM1rpZ5d0f/lbxLhXQvLdpNDE6rSJNN08TidFrkjKvMDdUE7PVpddB1RHHDYlfT3
 O6iRlQf1Eb0qd6wjSo+EVmJOA3aHkSRqGM/Pn9WYZFXABorn6jKxJwFEyOMFgqAzc01Id+Vnx
 tt3ssqKrinsISdjP4QT0crNGcszlSf0He+KzpMGwtCE9vipY8FLZ3JykyS7dEP3hh3pc284Rw
 ruSFtOe4GNIo7SdmsZJjZsR8qDrOEmaL378j709snZF2/TjQiCIpelhMp75KrTCflWBB317+p
 3aTvl0h4fX1Qm7NAytppurR1sMbcVJ34/ZhVWD9tI6NY4GLpGnRRbSHW1/LXGRTU5CqCxGNWA
 DEBxgjxbnbUm0iwwPuDNsa9Z/hbilIsj7oI5ZQoLMXm8C9uFHtNBQTNQnIffd7MmLH1XUp1co
 b9QmTQ7kHK8sVpX3KVhcuTpppp6Nxau6n4PZjZW730boCx2FmSsNlrQBZ0GGhXnL0ptdhV/AH
 erTax+urBmE4ZmsKa4sFrMVTo2HLQfrhA0EthJk35sBBEFX5X17QuGerJgjMZpWgRutHSR9KU
 Tr8cNd323phybevvMHzOngqOX6bbgZEqU9O/doGQSBXqppSgzG6p+aSLrEPPN8og+uyJvDJdG
 1pNaAWSKWeoyYIRXoyJRq19XG9NjGbrIC9zcFvDF9rnBhxg+VJUTYKE8D1NZtFxgf6hSrNuKx
 UZj2myHSFCCEjyVS5BYgAVENlQcsW+AEMQFMKMQVWetBNxZbACRB4+OndTCHqay7PA0mmi+5U
 Ful5LEn0TCiHOhWmebiwCOnwp6X26MPmhugC45IuxxzsnKmgKJEcb4iWXYUS9AmaPXYbXxIk+
 HvKHxyjRwqY1cuj1pRmuTPw/+7UHH5l/F9B2s3L7C7hZqcR/QnMyxYVNbYqSy2obijUjbYfSq
 DQLJu/ZQN3wVAJqzT0G+ypb0n0HYaJJnWPEzwN8pKpQdslTrHBK6TWx2NpOIdUxrvrXKyWlZe
 ygMvWRMXViZ9VURdVXgy6BaHN136EdtXgZ2ewjKFJYpkebwG8t6lA7v+Br+OE7FeEwqagldP/
 hCnciNUaYmbnrt+87/gmW3HJaQdJNFGprPEiheb2OSMUiG911Z+YCxzUvGkvpjOL8P0vzYESk
 ra2kEUAA2o6rZ+25Fqq20qeJeGCDFe8/RA4KCgx6FDPx0u/QpXsZqGlKVkXjpjJPIt6gPUObS
 v/1iLYygbrPf+vPKePhRuzyv97VsJVLFqMwuyw2c8JfE2azKx0oOj4Hs0hzddiKLoWTeTyFfJ
 A2N/FeqH8KGchU+KXbS4GHz+8ACt/dvSrXA1M2KqZs0uJKQveMjvVjxtmaRqY7HFQ+bB9Sar3
 2bwlzVrMnZu4rlxW+EdsO+5q3mDhAFfF+9QCz4UBKiz3cborxDvX1C5ZA+zY/Ojb5w7Wh0oJL
 HlBfh0Ov+DSANavSG0igZHdOj3vMR8Bag9nehR/HFDe18yzbozTeAlhtp1JqIlOC2Nx41vbMi
 Kf521sX6JYq4klWmA2fsQaJoPGfJGUmfIhStxnRcEgK/3bL1HPD7QoQfP5zO4b7XFCP1Q9XL9
 i2PmyThTcUY2hXJ/dq6DiKsr/wKTedQ+/ERxJVklN5zxeVLkyiS2y6bfvWcZ9lDijpw04LDEx
 1TYG3OGo3/ZTxu+aFaGaXfkVekWuRBOVd9N8BYX6WcQJO+AFiLe8SSFN8ZUnljAEnyWXJlaqt
 TQ4CYL4KtpSZ56x8GllueBRd1lyNh2AB20tYXqMXABTcvpGD+YLfxRkhnhAODJXAlbzUy9pcZ
 WKog3+rtOFgYHlEnkYGPYCA6gKJ/xKVNu7st1EB6Kphn1iSUZWZJzuOejwnrAKU/Kr+ZrM9jq
 Of1PBRO33Zu5SltWtXQ/iqOT4Ptet5t2BXf9Tyskmzma/KDpS3PP7n2bOWmGFgD3Yx6Q38oGQ
 yhq5gIPZvrFJyXiKBLXl3DN77dgNh6n5Blz/KihXXRQ61VlW93+vpgRrUV40bw1bJ1ee/ONZZ
 D0dg17o3bwcMcJMCFETOdXIJ67JgnacMtWgThP+AzKHXILsoR3FQSwcKHb23TWwJHz4w6/YCk
 dDmsOmEA=

Hi

no regressions here on x86_64 (Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
