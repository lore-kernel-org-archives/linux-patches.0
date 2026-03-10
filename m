Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71D1276058
	for <patches@lists.linux.dev>; Tue, 10 Mar 2026 14:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773152177; cv=none; b=PRnP8/XdHOQi1G1UDjnlwZXkKu3x5ehaQnOUT+mp7efEdNeD9/hTUc2eY25ShbirXnOxN1tHhTDue5JOqUzPS2nfm1Q0HoHX0gdDc17nbJ1O3TbO4FMxmytN5/SmhJGtEzjeUXqsA/1y5LwimbqBKqmobfm2DoDaf8II1J7Gpgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773152177; c=relaxed/simple;
	bh=1R+q0brxT5FCSRMOO/LqKS2K1GLvRDjYnI692aiflvw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pawUaHExuSgIzN2+WhITNKs60Fj/pMHadkOyMc3QTWTpUuGuURfguZMcQ+B9RWpyl4YT2bV+sBwc6ir148d/6m5ePJEKnZzX2xRgNg2utQXbU2z/tGAczhtg3x+hwPVrUQQmMgX+6/KkY6t8u4qCY5vChaaNlbP2N/2QuzOeP/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=fvxiiBrn; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="fvxiiBrn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1773152158; x=1773756958; i=rwarsow@gmx.de;
	bh=1R+q0brxT5FCSRMOO/LqKS2K1GLvRDjYnI692aiflvw=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=fvxiiBrnyQWB46t+U9Cv5u0i2poE4HMG0ZFJ/NgUwhM8CNCcznORz7Gu9sht7WCN
	 cjvfZTsG5mHdRPmAsIgH17PNs+8BMBEZVfLQGAiLp6KMhJjI1BAzwvcNEgDMx4/2r
	 b6p7Q0dzCc7qs/BD1DcmjmVNKZyrSYqGN1R7IQS2gVHhFQo5qRfM08W3EUkPEKl6U
	 ZPMLX/Eo2OiW+v4hJVvW+Ntk+zq56ijIN5E/W3pW2DZDUY6hl+chYMuWeMYjbN20L
	 K7SLxbGh79SzfxF3pbgsUkctmjj3aDt2BoCSM9KJKS8GbyWbvDvlYxq/sUy6rXGJj
	 j2jt3/EPwiL8RmVLgg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MJmKX-1wK7Bn0m2D-00IiBq; Tue, 10
 Mar 2026 15:15:58 +0100
Message-ID: <1fb2fb7a-e223-45ce-89e7-6f36839a0c79@gmx.de>
Date: Tue, 10 Mar 2026 15:15:56 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 000/311] 6.19.7-rc1 review
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <cover.1773140654.git.sashal@kernel.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:DLgGP1zTQ+fy6M65WQn8rBL1FUkh8DG0+K/txVgWXM9ryB0awoy
 SKBQkWHdWgmAoj+8DVJkf1XDFq1uGi8eZ/3r5h+jWHxGSuLwvcA1/a4vNvU6n5ahx2ygwLR
 +h0Wpf/sl+yjsylCfTnyzLItegi1GZR1dpAWo1Ff0Dpig3hu3KK/t4qRhM9QUKTfPDavXVJ
 VGd4F+5KQsh0D7K4/sOPw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:OfJzgxGlXig=;e4cTz1HBhUiCaevIsx5wehrHrMJ
 ho3HRsr/9CnT0fwKv1DrZJieIdZIC9YOGoKbyA8h968ulTw06KWyaLnaL1PL0ClFnm8rS5jCz
 dpidVfHOpS5ia9AVWAR668qnEcFkvDKRI3aBNpd5EeGxknfl+2wBmMffPjbw3ZlS8jelkrbua
 x8rHsKVMLUSxVW9t4DBdi/r24jdg1OuzyAAu9ttp5sExj9HaTk8AUOVI4lKLecirH6VeHIfsl
 kPr6r1K/l0qyc5m3E3pef/hJwJX/BTEqIwgqsyP4IU81AUSpTwFrlLM8iEKZBbumHUFRGUFLi
 /LHtX7aEvYoD7hIKPVoq7tMD5sklhDj9KK/H1NvEWBiFMxBhT6R+cLyQm9xmmj+1GLaY62YGZ
 iiGUaVXrYaqehK5oQXhIfyIZHc+94qipvnXQZzW/3jSrdpH5Bm92TbJaE6ExtQMrkZXVaRtR0
 5+EzMnBa4vWNyZbTpG26KmiAVQ8qEIpMhl1YTKyYkVIg9HU1o5OG04SFTCir980LEkqMihfW6
 4otBQrRVF84GQwh3SLXbA95xHSeWbhUa6g26sPuZ98UyiuwP6t4XwxzjoqRgrEgh9Eg978iu8
 CTKXyg6tDQxi6A7MJiMWTE+OFMZXVF7ZyyoVQQUs1y1EEXHlWnViPzHv6YULnaupQtg7pp50U
 8q6YsZF/3S0WcP6bdCNfE5+rRBBVTZpanXgAa32in5FBo8B+niL+KbMqfzdbFGPOWrkELgAy6
 Zhe9Xi+7GRp59wm6OGFONglnigS3CjHTfXKXvlfuO4ysoX34a/QBrc5IOkpWphUanlwmUmq8R
 zNlN1MVTztkR2XOENnakIllAMdgqzNfitzVD/TAIx1/zm+lKq18qpyxbbUWmMo7bonBrbUz30
 QdhgiXozzBYGtMmg0TZ9IJK3OFT+SqH6WemFxfbyuvBoNWcRTnHvC02H37TtH7oseqzEf7S0i
 nStys2YWSF+V2P6hlXScrVan5g8vwn3NKeTIzEA8Anl9MHv1YKwi2Geqsl5KY/fsicanUUz0+
 22zM6ruAQcTOPKsIN3ywYE9DPmK96lJlpMVjbqWN/99MWPdWNtaGEyKlCvy+ubL8nao6atl3I
 Y5oq879hBqVV2SVDWDZf57IiEzWSa1GxnaSlA3AJd7P15by8VDrMVDDnYNsTOhc5zs28/Czqp
 kPHWlW0ZVkx3Nw8VtYVpsS4h/ldBLUcGu3Kn8X44mfa3CRYp7pM9mM02p2jSC0Iakk3Sz5ohh
 LvA4pl4vsAI3/1rZHYC9l0ukikUvwkzFR2IBDB4OIUh//4YnpiKg61L3oUg2D3Ag+mU5pivem
 glCbN3kJXy0OTGRg2qfHRV6JgS9N2EqPOMx31anxn1v+W6KGBiw21Znk4AxAXcVCeq8NOtYkh
 7qqLEoCVyRbmsxOX6HQ/04nohNHU8hTcBx4MVNn8/wH9dbyyAruZ/n1Nkpon8lqpQjS/qfaDI
 UY8uG5TraFjExTpAoeIc2yw1i9ONR7yp6mR3GFq+TYcuSPpHq70J1pj8VagcIyBYBIkij/7T/
 uod7hzvdE4UnHPgkeYQADP+ypoRygNvhx1ONh3oTybLZEcECFEbHEb6h4CiFCRDyPkrxJ5dbP
 Ry+pYlki/Cs1wXYEE7jRSvGobWMk98hmuwID8U75a/9DXimZAeowVyaJCjggHBmdSXZZM07nx
 8Ph+6eeUzB4R+jkBY/lXeOEJxJmX/ePna8Zz51BxXjgXRjJO387nUPHW7gNCbutTYWrGzQtRa
 c7+WSJfEOKdaNZYQJvNzBv74qHWG+xuAcaRGF4F/NVoCNP3N45boPn+agYRzsK7XJqIucjo7P
 qoPQjstjkqu8iXopHxdb1sT6Tqz2cKfNaFxHgeIlr0FTUc4MvPSwyaACVrZjolyOKFtZjVib4
 hkKZNsCGJBiNpA+yIAGL/jOszXa+ZNnTGcdrzc1wFW1kaeI0TX9yXU1OMjN6UnWNDq/qUNBUM
 6bHaC9rUx3DcfNWMeaJqT72hS7hEJK2hYmR0kdTtAytXOBbBxJ8M/qtuYgEVMA+JjuqUscPmu
 KqdlTz+oNdaCP8toHfK6b9hCW2yoe84CX/zGSfdEABgkLubdf/OW4eCxJK2nBVtK66yltoAZq
 swrX2P/EEuxjDn2Ch303kFAez8M5saPwWoffbiuMMnihIb5JpswJMnzg9wHbGQ0yBzRvNVMGS
 DHsFuJVCiulUIL3N8UZclkXdW4OX22iI7QsqYO9gCEedGRt7+0KJZCowEXpPcE0cf4u3AWoM7
 GWljDueAIAn7sLleNFKydPDbqFS1Zj7/x/bOtqgJwVN/oBNh9bJPvuGfDeGtsh4JZdk0id0V0
 pf91L5uCrT2DlhCvRxq+7aYc9ZJMC0CCHdUckK9ssXciY48fIxfQdtbNhAE1HFKbpg5i5h7Wc
 6g+3dMUtyw8IhtCTINUaLBGtzX9JW27XGx4bjK2vpgVAEXU1u+mBqcpG+wDuTYoeQOtI4qKiA
 A4HPdy8733yqzzMbePVZz16K1XAON5UcmfbM6rtDTwCuttbJhKiOgyy1Bz7wWHfmdjc9OEabK
 BvzifIsyU1sxVrZfMxAfC8XJOJmgFPDWQOE+aLyQJCFoIq6HysHp+7UNNOQn6/C6YjvYuOBA2
 4MGQwHh2eUm2rejrUzFRl4sS4WxHdFt0gyyOCbLfZT8eqrQvUv0e27AKaa27b7UNgf43gIzD5
 UpneLwXBwttJ6O1NY6kS0vDp5B2o24H8JbrANp3BbUCtebBiXpAf4j8eY/B6IIulT4QwaPdhe
 RvAnohFzDgxh8zEwMco2hPm1jUeoWRfIfu8zdqdO9dbZrfC5SMOiOc96DpO1tF4ef/wV8kWo2
 URDhSJzzBclVL4D0lvY9UXKOeNA1wLS9FGH+F3L7FpqV7pJGRLPrFCdOi5liSN4paoTt0L6eL
 1I4mwiZS5M4BYsZeBp6MpE4wL7tAJtazSaPgyWYo84Vfss/v5Y8xEyEy7nX8izX+pXv+htFCc
 tnx5AJmcB73adygfSxIizU7AbYScde45vCNUjwwJqJ2ZfiDKxQC+3ZNjbKjWi0h1xEiMtS8g5
 22ngxzLKXtqNH978n3zIwqA0NyNyf+uKmddvUPpCOwJFRAwmYIyT0ldhDYA+fw/YC+1FwRWi2
 yTqCvNgfcypuTqim7g2ye9D3WDC2MA/Uo3WdxZ+un9qhcbOR2wcTqWHLT4lr7x+6GF/g9sgu1
 wJ2CNUGCy7bFznxM4fwAIh/Te25m1j1wpRGs8wwmTm93m+LP9TRfXz0MkFEscuuIHXCiPihC8
 0f35TGignY/3W9c6jpmftDPrP7VouTIv0lGzfcleVoLM7WbKqHhLhICP78nkh6lBsKdqLyTvi
 Zje4AhA6RmcRFbl2uynPNWljf1QsHGRz7vGP4ypc4eK1JANoBjMbkuOcaWb9SjF3kFbf5gyc2
 jA6SdsJaYqRxqThtMqLPkV80epvLJPkd9bMfkc+F/wdhqYXSTfEmkcIvDliET3GLgSQ5bjezJ
 5g8/2d+ZtH007G9RbO3nOAvj1QG2n4kdAnZc8dgpsh6dKZbUZvgie29TZR5Qkm+dnDasEh6xA
 fzSgq5rU4KOdm6egRnjlb/KlznhHym3mFfHs9F+1JiYdydznQW+gWRPGGC1WqpTGV2E1y0ZI/
 5Llh9wKHrvUrmyJNQY3wJtnGYk5UKT/6wa6h56nwHY+Gx2khJwBefsizQSl2KPHz+qLcM9dlP
 xOoSe4BriaJGnu+DMHm2T+7L+gw3SGyDIny0jxuXBC7fZZyN8p+pzsRHyFLutNvan+Du/fbHA
 CzyY5wz+Vv6d156SIIAWyJr5s/J/x2s6suKHkruUO14FnEwTGbBxMKZl5Q7FIxiRFGpSzjBMt
 vFnrI+0+pc/QqZ2jpqKGU1aCQ4EuN0QuTeNv8fPIoCz5NV/TvX92SnzRjSXXSx5wO69FV2H10
 rOE3UzTzs+s/8OVL890y94Rvx7hBuLoEC3CpxyJnburgkYHwL3b3BegcQu7d3Erk+8Ya7cXVa
 9v/eelVZj2clni2SZR6cs8X/nF97TYwRC+WaxSHRxdmeVr+3Fhc2t5qQwzqUVe2UVGHxpxeKP
 Fv1vqhQN6nWirI1+RfGK4kp0Op2hFE4CmJCZOh7hjJYrSJi/dGvD+WQT4teomiNJTIYdtlAwd
 OKkJv2VAfpliO1t3AOzwfAz5ckEVWQ5ccB5yH4EB2zaNe9wtl4nOFf4YnKVDYU7TKvbd0g7Pp
 9kZJNxJXyqGyYFAFqu4i5ghF1/x+B3uMDDY1CVxRYFsZ1XvlE8UxJVrq280AC4A6efv8B6GKV
 lyGmiEwJ/5FdEODnaGrwwv+XFucREXwFdY4cXuzeAfbL+6+fCvWLsqhCRWkdZRzVO2yE0iOk7
 +UuQFM2XqtmwvOADle0ECqlpaXE6HZE1lEIAXQVC7T2w4ZWLQilGnK2YBBNrI+8s6IRzRcf0D
 GBKfHuBuHwjU+tyPnQnpd4c+zPWnW3TbySSBTIBuCb/TUTiEwP8b+2gZptx/xzumup67yG0w2
 7ot9ZHuSS0cGWfIsbLdpF6S2mzKnTSDBHD4dPBNWYE4RWchxmq4u5qo0RiSFNZYQ5XMrLoint
 NOM8BGZjqQC+NGitCZxplnj8WBAV5Dp006Qx3PUrDZa7lVeRUjGI4rjiwX5kUFCt+Fxs9rbk9
 uxzPcdtjcTcQHLCTZsK2lqA5AAAH1GKhbC6ewjEvzQ7WYWzc46Sm3ViKXrsVPFk3skjnqsP3q
 nEdBg1oq+QlyN19qIvv5P8E5ym28uVfd8uIoALZzvhZxiL/B/1sFk7t0vPUqBTos5/LFCM3Fo
 H936s+0OFlMBTLiHCFg7i3clVRfeBGE6ofYeX4ygS5rDoCmbiVViVg/CLZYMOiUXmV9XiI4Nc
 5vJl9A4+fQ4mC6HBO0qpsj0hxzNGGnQo/nW5qna+SW/fw69S0TkG0V69p2WaeHoFffxB4axV3
 zwD4M9bWoEAbmnsw+XBvYqrcpSKZZzlsclfhVL7ek+hWehZA+XrNyOHc8XCNUY3gHLI8hlYG0
 Ke3wR5D7qbwMoMVOsF85tSLeWOiYk654fNDOv/H8CtQOEbhaRcu9krNXnpuu0nxAGZGOgebNe
 wDox8zok6j6PGt769Dg3iATZiqCcEgTWrAkjf+k8N4Bj/6NQYZsGy9MTeHzUn8uBfOPyw==

Hi

no regressions here on x86_64 (Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
