Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.158
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047859;
	b=s59VwcNnMbN5MDlMcmoXniNgukQC++yZpvsEB6XL47+4CTvS+Rzu7X9oCKoOKqTUXRx4
	 VqXeadLeV9WN41t9F5HAlx1YlX6lQT/OR7xRzZg9arTAD6E9B4d0Q46dLG8D8smcEArUW
	 3V5tkehPwc1P3UDD+elmcQbkKpQA2HHJr8DrbnJTueEaNsLbjqsydLbFzAjTuDz86hHTl
	 dL6aOaEu/0YvVtn6QQegx+HXM4cW1ApC6MP94e/OwfuZ0vTdL3JogTJGT3z0JWwcSE9RD
	 ePlDZqBABjWudkLGJ4eEKBo+O2Zx/POVqQwU1FXhJDMA+6NBkNgFXDEFu1MqTlQYmww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047859;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=aXOqKt2NMYYEXvjoI7GZxfHPL6l9VgfPwE+uuPiqf0M=;
	b=GuXsssa9T5vNNNeq41Mfiwq+c+EZW4rztLroRwH6EDgKasFvVkrA62VP2B4IvY3V3dwI
	 lzIySum8JOE0lP/e7ZJjXqrfMUcTNdwAHbqh0+8OepuYluszsklD224VteWgDO5DIOSN0
	 w0SF9ilDQrUs6T7Bpk5sRBB7mFMngD9L6Tvm1Icrgf4CI5UUulEroGFXYKXnvnMuaHf3i
	 3B1YJG7VVb/Rwlhix0NYqY/nGKq+aLvvQAagZ+L54EBhbs98JhGEJKhld1avi9fdTdfNR
	 DxUedJHHBlGh5A/ZJZvaaw+onrpT1zm/JqsVxKPUf95Bg+g4g6DNcuFXUzYyPdTfaag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pobox.com;
	spf=pass smtp.mailfrom=pobox.com;
	dkim=pass header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm2 header.b=PbmRJzjy;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=Oa0bafj6;
	arc=none smtp.remote-ip=202.12.124.158
Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1047606A31C
	for <patches@lists.linux.dev>; Thu, 19 Nov 2026 00:24:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C1047606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm2 header.b=PbmRJzjy;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=Oa0bafj6
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 0F2737A02E9
	for <patches@lists.linux.dev>; Wed, 18 Nov 2026 19:24:18 -0500 (EST)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-09.internal (MEProxy); Wed, 18 Nov 2026 19:24:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1795047857;
	 x=1795134257; bh=aXOqKt2NMYYEXvjoI7GZxfHPL6l9VgfPwE+uuPiqf0M=; b=
	PbmRJzjy/QNeWh0lmE80OqRCzYn6R1vCFQYtr824dDCeuE9I9E2Dh2aSgbZx+vab
	bc3G6deBTBzdtTJ+7W3AnMLpbr/q2F1ysPmOnNHY1mIG0Ou4P8caOCDa78xFkK39
	XN5dljrbu4Ab62cRLTM12W85Saau0ebqNJOw5xnRUHu+gqYF0sgfrp0cOGjmFyif
	QMpiVtEqn7edJp5KqLRqZ2mnstEoFZNLYqEINsGfBZTrfHQa7G4mOdkodJeNLHgK
	RL3cHebJ+rd1hwlLhKEhfb/aiGsW++T3BLahgcdYjYHEBvqsg9QIwndJL5t4hK8+
	BMrRePU+JBCMMI+RkBQpYQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1795047857; x=
	1795134257; bh=aXOqKt2NMYYEXvjoI7GZxfHPL6l9VgfPwE+uuPiqf0M=; b=O
	a0bafj66XkWPM26CQYjEJG2jT9Vsf/BbwPTFUKmPlQdE6iAnP1v0t5rgBjth6TPp
	92o9am4QHp8cgEf/5th2RWcX78h+ZzZbR9z0TNHBeW2HFVDEe54tF0iGdujOnIvD
	vx+mbmjjJahiFQZBkZOLyY2RR0P+glSmUbUK8Vbge0b+MQRY2qruSnZvRB+9+hKd
	uZpeAeV8QYz/GJnS+gRdqZM+xIrfSxXboneu45SZNGQC9Y3GhUFgrUaFk5jSk+t2
	VhAM81QB9Lw0LstK7fYF9y32btA7WPGBSLdCzybxyMs1dVerA8p/yuKUiEgSr7yi
	MqgcrstWE1Nwaxy11O1Xg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=pobox.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795047857; d=pobox.com;
	mf=PGJhcnJ5bkBwb2JveC5jb20+;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm2:rsa-sha256:UNAJNU+3ZqG8IX4AzB9FNZVvtfAsiaFJtOurZN3RO3diU90
	xRbxgfTL5AmQPZ74GYsMABF/nLLEP6QmmG4chkFCBtX6nxWflRCxtTYzmB+pu1Lx
	r/GJp4bE45x6o1JJBZPA+X/q+lwH3OENt3Bk6Vc9zVh6wo5JRWZvEtJtK9wahJ+d
	1W9bItvhUs1dNqR5Xl2EaOnaX+zEOARM+ikJEfMVrSUPpeO5XCRQkeddeZFCHx3D
	qtItYey5RblzqA5zjcBKzsAeSlpBqz9ujAWdoUWQrJkRCAinG7kuvZ4hxd6sRpaD
	JXBM8XDNMTDbMWvIXpPmkNxH6n3BoA2H1JsxuFw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:Ta2Kt6YfwEM2fVBchHi5OzhsC0qMKaCSW10HEpJ34nU=:4ujMirIt1fvKIqFyNNS5n6CZS6ifKo9vSFtOqHX+BmA=;
X-ME-Sender: <xms:sEH-aiHHbSVW3nzJT9lgS_NCWOu0hssvJw4N35gsnIunyk670zaaiQ>
    <xme:sEH-ajsjIIthu7VsaXBZnfpHxKpOP-3Ebs90_tVYPcvEZsjWIpAB44XbICMy7cHfq
    0DnJBYh-WONj74HhVaK9Vz5kay9wQu59sNuSmnDjbibQzwYVJY586VL>
X-ME-Received: <xmr:sEH-atQPdD-PP_r-9gX55M6XUjG-wTgAe4gJ9BTXsBYWuvL8sP0QQzIs_qsdnFuQQ2nhjttaCMIQtZBm3YtT9qxO9rV-xSJe>
X-ME-Proxy-Cause: dmFkZTFziiajCBR4Sr75l9noV5zaF2WbXJaANF5ti6nw6uZ84o+FAiHFYbgyx9LMT6hjCU
    VazHKyRi+1qn/3tDO2qt45vt9O5EX3hK65tBmLIG0ZIt3D1298ZpIfDSdvKWcnwMbOkXE7
    LZOzXKT2F7k3d3Tkbn5q+XOTVDex6nXpC2/iE+WCXALaUmGrkvlnOFrxtZYoJ0sID4cu0t
    XYtBR1a6FlswIzH2ZmyCdPAMxVKos+tcH0k/RPZq+UaStyjBfRUXiMkNWGJCNpJO69e8TS
    Mv9J+CBFddxDyHAKLD5KWFipt2VtnnI5NkWrIgXtsWrMt0npGe+53HZ7rpqKa4THSQl5VM
    /tz6El+wpW8zH5BzcQ2hnjO6dTHgJYNjsFdXAjDkHk29Lol07/LxZ5rUooPkQupq1dM28Q
    ilh2aaL9xjYiDWtIN6xcyrxtGg94znNu4igv0wy02qwOX/Alaog5n08xQC2e0sJ7pYEjKs
    Yrt9Rw7NwtVZM8HajICL3L5YrnxyGHVwNOlB+zK9E4U1g1F1UBOC+HFo+f9gjieU09czFT
    yDAK+8Fw9/Ww1tac/ICCVG/1NSkQNuhaLgARt0xBcAlkcpXEMJqq49XuJryItXP+7Zoakd
    A127ybCxieSKmxGx0wY7c9BMj02/NOXFhI64sKPFqQBtW+eciP/3ySeZZd2Q
X-ME-Proxy: <xmx:sEH-aoHm5FcB8xywC3gvzPrUVmAULjoBkAhKU0lZuM9HJKdRL556Fg>
    <xmx:sEH-ancPqQvcw6dEqwGgwOUh7NHv1muxOok5jdfxfdYSaWblNl9FZw>
    <xmx:sEH-ansnUPluP79FYCe3vd3xj9KtVdDxLDvrDnErlC7Q-zZMsFVMeA>
    <xmx:sEH-atfuIoCPVEjO6AV6AzmRbcArOWOanTIcdlY3xiQ4BiLxmcsXuw>
    <xmx:sUH-apPisMEE8WZ7sGpk8s0zfIa1gqnmwH5J4OnoicNj2KOdeTHXPmpk>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 18 Nov 2026 19:24:14 -0500 (EST)
Message-ID: <4d8d08f5-d74e-4886-b9a5-8fc4dce72618@pobox.com>
Date: Wed, 18 Nov 2026 16:24:13 -0800
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 0000/2857] 6.1.193-rc1 review
To: Brett A C Sheffield <bacs@librecast.net>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261118150201.293410965@linuxfoundation.org>
 <av3WYtoFXmHPM8uk@karahi.librecast.net>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <av3WYtoFXmHPM8uk@karahi.librecast.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/18/26 8:46 AM, Brett A C Sheffield wrote:
> On 2026-11-18 15:17, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.1.193 release.
>> There are 2857 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Fri, 20 Nov 2026 14:55:40 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.193-rc1.gz
>> or in the git tree and branch at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
>> and the diffstat can be found below.
> 
> Same build failure on amd64 as reported for 5.{10,15}.y

For what it's worth, I'm only getting that build failure on 5.10.275-rc1,
not 5.15.226-rc1 or 6.1.193-rc1.
-- 
-Barry K. Nathan  <barryn@pobox.com>
