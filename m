Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.159
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795143102;
	b=AEAhQe1LhB88Q4DE5BrsF4Rjh1nbbqQWc5TmvEcdra0spvuah5r5CYzBJp7jMsJ6uuqC
	 cIXlwB+0xfHHkOQQDb9ItTaiUYqhbCAy/NiwWNzHvDl9mdPLEG7BfxDUGFZeBykYjYJzX
	 GjVgJ6Y52FobMFnZv3RUvREvHN/uYKDLhpcYskwFiMqHRIFVSd0ee8p+SDzMHosXA0hkf
	 mqjod93dRWADa51xVn9C1pbS3vxgGn2DdpQJiRsZe1uMsvsujREeVrxE+Wr5PDF3Rfozl
	 l7QX7krs0G2c+CHK+qcJ91epU37XVZUa1uatX69Y6g+rQlBa+fpmDs548vMmG4Cp0qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795143102;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=eGfAtI9kyl38J1trJHjzM3izwRkrfzjC6sxGZRhszQ8=;
	b=ZH5idkByFcf/76HF73P6V1BCPznTgxgf4kd8ge700sFiQn+rY160AUmgeNun7t75iAJm
	 DtPPUjASj8ihRmQRr+kNrv9g2TSgnrZhuQIh5RYQdx3Y55xiVREHBKfFX7VFwEWKTutd+
	 tg9NIu8l79CGpl5iW/KQHEa2cEx5zZAozH7KicyvJMB0wqjtSqG1mTBfzrq1GVAmyzUXN
	 2F6c2ttyHXK0sYwnOBlNXS+Yiu0N7qXEsShFbIZCOfC7kKpKtdJOmcnGRrIJSrMODOJbg
	 BPBKmInYIU6c7UZSQG9mD6myzo2edBXJAw14Wkk3oTcwXkJE/vuWuDJ5NH6jGC9qFTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=seanlyon.dev;
	spf=pass smtp.mailfrom=seanlyon.dev;
	dkim=pass header.d=seanlyon.dev header.i=@seanlyon.dev header.a=rsa-sha256 header.s=fm1 header.b=l7zTENoZ;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=YAenRQ9n;
	arc=none smtp.remote-ip=202.12.124.159
Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABDEE606A320
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 02:51:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ABDEE606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=seanlyon.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seanlyon.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=seanlyon.dev header.i=@seanlyon.dev header.a=rsa-sha256 header.s=fm1 header.b=l7zTENoZ;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=YAenRQ9n
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 3189B7A0203
	for <patches@lists.linux.dev>; Thu, 19 Nov 2026 21:51:41 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-12.internal (MEProxy); Thu, 19 Nov 2026 21:51:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seanlyon.dev; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1795143100; x=1795229500; bh=eGfAtI9kyl
	38J1trJHjzM3izwRkrfzjC6sxGZRhszQ8=; b=l7zTENoZN7JNl6iF4eu20r97po
	rzR1oyXoqmS8tgFzvlYk7JBjBgNUJ28xmltVoD3CaMCnfrolWtOlMvELos+u8eC7
	sw05110XxB8UPkmVttnp0ssElBrbPOStfXnQu4ikjwaJpfWyxbWiZvXeNLdxDqUZ
	DXouSiTRwuI8S6o/zleXdJLguqZZ0cldSgPqbdHSR35okRRefyjO1Whg6e3vOVWE
	8ia67CUK6wt+zvEh5+eSQ5ZFgWDPChhY8UJ0NrnB2KF8wzS6ZyVajVi00BGguXpV
	6koMer2heYmKd3wUd3N3HPNvgKsO0XfPefMMRT05t9MlFBxpE4A8yAQrkpMQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1795143100; x=1795229500; bh=eGfAtI9kyl38J1trJHjzM3izwRkrfzjC6sx
	GZRhszQ8=; b=YAenRQ9nTmFpi0n06vo8DwHbHTA9eMY/HFmvniNBPYfZx5CloaE
	fZIZjUUwpkkRwdEbA/R8Rpg0CbDctuHdvZcUP2Z7pXrXqkkMMblnDP5fnSNXc6JL
	TpD3LDVaewspfuo51Jhs+kEFEczU+KIwLEzD5uqLnEGwA4Yesfhovwn+Eoij5QmW
	D44dhsCp3ex6PvBtwsaQ0O5IBv0xUXedkA9sykEuWo/haSHWu+82rmtJ1DdoE/Jf
	UPLzYUj15PjrJUDwf7n88iyj/xWb8aRCFaQXpWFtLm4BKtjWVCctitXkg0r8rnks
	GJVwsoccB/UJDKU6xllms4Bx9Yjf6Gof/Sw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=seanlyon.dev a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795143100; d=seanlyon.dev;
	mf=PHNlYW5Ac2Vhbmx5b24uZGV2Pg==;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm1:rsa-sha256:BDuc0Tgiy83NXK9G3c9Ah625JvH333cywVS+xpVFbJLwd5t
	830I7MuqFjT2L5GKws3YuInYDi4GfmBKwayrdnRhRFBUakB2O+Kojf5wtu0UkxnR
	DL/4ThTMMETj9iJkDkTqklqS9+55VIj0+hkEzCfE6voTJ2XbKTGQyqzehKapwv73
	+xgUjn1lx/vejzVu8AZOTz/DxT9zFApW+WHQtcDech+Z4EQGUeBjV5/upQmZPbZW
	PQZ+XUDnCAACKv5oqt/Oo9w2z0JftcDCAg7aK9iBWSn6ft9IlkPN4v5bfm4Q48JG
	DtJ///cY3/UT4Bu/vPjdMzCrMU0jeEbFpEq9l8A==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:d4R6zsxUJ3nWZ33S2TESEzabliviX49L7PBOKLUxx1s=:UZf5nWPtx6oc53tNqsnCxw4a5bNtZ3wjBy68QPC81ro=;
X-ME-Sender: <xms:vLX_ar-WY6P-JzfK65w1YqeER1-x3LCxfS6Yx4QDwe4mwnxPoNw_5Q>
    <xme:vLX_ajkY7oAj22XuuJNb9FFfz9R2f6ReVGUhk_M9i6Q62demLyV34aj1mkV_CnfBQ
    danZ5WfXNdw4FXPSV4XPSI3NGsJOalbnmSy7tCq6TYKkAycuVdUTNQ>
X-ME-Received: <xmr:vLX_akhtw5oXqOkszvyB-Gc0uAI6pc1vDQb2w5F5mRGiSvC-FcZ7lcRgtJL-U12WLR0t78QODaNxnWelQatU5AvLQ-Q>
X-ME-Proxy-Cause: dmFkZTGLuheel4IkDeQJKZsYVqt+ZkTlooqvIH1sGgPCN74xucbqrfqeqIJnUZKGb5vpW7
    6wQ6kIGZUa68gW5mJIFbTwxXfxV9Ls9RXIit317iEAxTNnxAJ1hIgbMgrWx1PFmthxTtqp
    CYsTJsT/IIq8DJDxqjVOgWm34x7XnQLgbfiFJI1CFisdaYcypkaMMSPmSkVmKpcFfEHd2v
    CuEZpJLyKc+Uqooi/VYtHvPNApM2kUQL8aq7NWQ2KeRx3X0JG1a4uSPLPd7ys8japO24Rh
    qmHwA2o+EbAG5dJmGdp7pDSF//x+GlBcnzNVwyvtdAvYdjmuhwqZUjehm4dJpxl70/jIDI
    whhCk8D/MelM/IBi3B51U6F6jfmw/dvoXLNO7lafC6v+XQMibHAKGd7BgK9B64Ryz4BH0i
    0r39Jzf2eE4yO74bV9S1eLteA1TaE4aYEvwxaEiuTWm3XuhM8ZQm7h7YLjdRwrtORr0DCl
    imvGxeytgrXO+H9C7oH5pHipN0K0IQ7W+3w2lwYC0vcgdbDqhWHtXwgJJMxmisGRXclljx
    UyJjmI+dpGeiK0592Jy4Qm2Z6eOGfrPPBFrdEaf87RUo5YNMj40/au685r148mkC/wttBc
    Sg0UmpBCnqg6HtZLYalwZmR/X7UuttsgXe24PDHUYawi+rVK73puvZyZqqQA
X-ME-Proxy: <xmx:vLX_arYhN_toWF6-mcjOSLvjBIEP5sAINQWTvNbz7M6ZyUMh085Zfg>
    <xmx:vLX_aoGX9uFkm6sAvRFaZAOnsIx8K0b-iYt34PjGxM1C5PcDAtTS9g>
    <xmx:vLX_aob-YwuLta3zPyiuUeAUfmeimxnpEu3R7In5GoNdq6hqKr00xw>
    <xmx:vLX_ap3kkZHwp0rT-Ei6CTiviEXUPDvXbzx-GbjKA5RMDIgV5E4EQg>
    <xmx:vLX_asCGULIRp4g_r6Z6BKZMZWcvvBOWGcH0m4QTnlSQRLlb3tkiYp0S>
Feedback-ID: i07c64b5b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 19 Nov 2026 21:51:39 -0500 (EST)
Date: Thu, 19 Nov 2026 21:51:39 -0500
From: Sean Lyon <sean@seanlyon.dev>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 7.3 0000/2651] 7.3.6-rc1 review
Message-ID: <av-1u3vCWASDWVS0@ncase>
References: <20261118150247.972732815@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>

On Wed, Nov 18, 2026 at 03:20:40PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.3.6 release.
> There are 2651 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Built, booted, and tested on hardware for x86_64:

- AMD Ryzen 9 5900X, Nvidia RTX 3080 (nouveau)
- Intel N100

No regressions found.

Tested-by: Sean Lyon <sean@seanlyon.dev>

Thanks!
Sean
