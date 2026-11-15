Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.141
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794720343;
	b=BERGzxaGF1ua1Mtx5D7/JqBOyL5ovIy9RwkF6LWEwVaLWeNsrSQS3Otax9GMPM6dUu+A
	 k/pojREmuIrpB7ZGPMapobM7DP8BoERv9czq/76qFvd4han+Cv/vRGm4UWUijxLKa6qsF
	 UaLO9NdUOubmxTH/m27tuDhsH6oZi+6s0vUsRpruJULlb2lcZ/9eVGu30/xHsfRikGIHS
	 fJYznpBw/uHNh7rxJyziMh/3v/OHg6DCK3FEIj7dr33zUxndIDJDSmlD88rg48TOjsBd4
	 MV/3mnTT4WZ0yFCvDenKBbn201QNveX7x4act7vMhhf7b5izrVZq5JaHLvWCAQmopoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794720343;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=LkGrPCXP0JLPKLY8G6l+QM23WPnzVBFjGg4q6mnVAmY=;
	b=Wk7CkfOe7Ez8QsN3RUhsgDd4jScFXCWXplGlIHWqrBNLl+MOmjymKJNmOY2FKijHhnjQ
	 6sFOw9UUIHQgdRCMlz20saEFJaFrCz6lpqFs+25euEBsdJj8C6qnGyGdpMwkNiw1ihKTg
	 x+jj5p7wKsktx5sCm/pm8aWLOSXV7eABLZd31aj731QFGPIfoD6FTCINxD6PwDu0rSOQf
	 kLBxixekbRisU8xKlyTm4RtLKK99lFffilVY1xzkRtD3ad9FX8XBeJe6gtAfcTYsskPoL
	 99FKLJ7U8Ef2rQB6t5LvNMIoNwRKZpWXiTtKMufUsWrqS4RUzCENGagDNvzX8CtCL3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pobox.com;
	spf=pass smtp.mailfrom=pobox.com;
	dkim=pass header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm2 header.b=iN8B8XJc;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=UxHea5MZ;
	arc=none smtp.remote-ip=103.168.172.141
Received: from flow-a6-smtp.messagingengine.com (flow-a6-smtp.messagingengine.com [103.168.172.141])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0AB606A327
	for <patches@lists.linux.dev>; Sun, 15 Nov 2026 05:25:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0C0AB606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm2 header.b=iN8B8XJc;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=UxHea5MZ
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.phl.internal (Postfix) with ESMTP id 574891381BE4
	for <patches@lists.linux.dev>; Sun, 15 Nov 2026 00:25:41 -0500 (EST)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-05.internal (MEProxy); Sun, 15 Nov 2026 00:25:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1794720341;
	 x=1794727541; bh=LkGrPCXP0JLPKLY8G6l+QM23WPnzVBFjGg4q6mnVAmY=; b=
	iN8B8XJcdgKjryL4leqw1KQVAC7w9HuzWK/gMrGBpsUeYrjEEhgnjK8E9bcMHKbW
	T/Jdvhb2I3VxJ9n7lohsRdG0XTet4fnLiFJknRSIZFbNuhNgTuBraC7LBy4uzlyO
	63xERsd/h1wbXrpDa1806w8kfnYJPDWCHYmUaVUSZjaFcPN1Uci11PaWipy902lY
	vZZvYC85CMuqczLfKFksfvkSThmqn3HBgF5ngP0WLjr0rWTQsHP1ZtLicwY/dSAw
	X0aKUof9SqnyiuRBci/4orEiJUdP74PnbTEZ+h0ytDswy/HWqt20Ttj1sT+QNHSc
	Nh/2OJCCksHl1Bjg2Alk8Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1794720341; x=
	1794727541; bh=LkGrPCXP0JLPKLY8G6l+QM23WPnzVBFjGg4q6mnVAmY=; b=U
	xHea5MZUh2Ct1ptcmh96dt57YhrCj13A/j0EZpYB4NIaLOIHMXk4pCdoUjzF/77V
	hXXSpd2As3dUKEOI1NFZ8JepC4jXUR9i/2ND7zPfYTpRylhdQ7qnWUK2j6aQyEcj
	WO0jPOq4ktAIwnuw/9etqlfXTfVlEifiUemT9XGggU6oJvVUQHdwDb++rJYEsAOf
	IFzWJcuYBVYVMgBQRvyi/eku3f7sL4Xg/HYh4Ba3KlRVtEw/mHTNwMdd/RPPx6oj
	tiIK/g5hRdL0IBIDlc5MvINanxrN8pdto/GFG5LYlhPEN/jtmJ63mMErtwCvKu6W
	ao5LWT60dbZDM0d0guSvA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=pobox.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794720341; d=pobox.com;
	mf=PGJhcnJ5bkBwb2JveC5jb20+;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm2:rsa-sha256:Jt/VC4kt74DcbUWJPwFKuQytF+cPZ/cF5zzVCb0tczobUGi
	HsTMoi8W9JoIeoZ9OiInvJim5IrZGMRAPJgmGNdVrBBPUhyZHGzeNBjHYTERh+Je
	KMVpX4XeFCaO+gXowtNlqDVaRl77bNu1ZifAedWlREz5snHTW2VYBujC/NLiU+mD
	J/7wHIIVSFzrii9Cyiv2CXA57B3fBC9LB/hHx6p8C0If9lUA8GB328dV8pZgFAJM
	8wxuhA4/70a4jy5y2D+jmBkR5ZteyG4L/facLD+/2ygmK78ImgM4bZ95JuQoxCGk
	qz+3e5b2vbgdoOeq7pThEqubb2PrKmccBB0rBGg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:pgYaof8s69eQEzDiEx+YE1Lz7uCmSlLbL1lL19rLk5I=:lBBrFOAxXfUOM9RLrf+gvd0Ms7akLkU1PpLZKV9d5EI=;
X-ME-Sender: <xms:VEL5aloIu7QeyWBFSYRmVM6G_n2co2X58HG10ZAU7fVr0lEoEXauLg>
    <xme:VEL5aji5Hphrl6QEMv048c54itNH46NQCAkytAzPX_91XqDBz3E9hz7ToDCRHz3DF
    ejH5AEBWtoP_q_b-cw8CfGXNWWx0Hu4ddsv2iNDQZNY5ctcORU99zaB>
X-ME-Received: <xmr:VEL5atsTMbjN0BQs1bPoCgAWKT5RrMnkQlWWgduW24rqquMxszEu5psQVQb7VCjj_tOYB9fHPRq5nNK2sHGJ0ZuU5OGUnQcO>
X-ME-Proxy-Cause: dmFkZTGEh5LvreCZCnvcwwEWb9jr6mjfkx/QSxg6HA1Q53K88YCMfBJwvlcY5e5F3Ty0MX
    jKbz27N+bErKjiX7XukR5r1K4y6g4J8Ccld5lVZIHbuiJiB53M0AftEte3Mc0KkWJcw/cu
    VEiAkea/vK70hsvoH46Gn0KlJO1tXh06nvOO8ldmrAcZqb9jE+GPMwQ/oPrtO5GH5QtjGc
    W0vCQVvMQP7W2DcZFtPgA0GfDURzYHR4+GsvsjQFZpqttxm9akKGPhgpIbwPWDaLKOhYVj
    LWj9/ujW5OJIt77/ob2s0gomwGP/3h6jO0RYxsIeBKlk4hHSfW3Nc9REr4uav0Dco8xtMs
    dJKhs1IwncK7eJAJnwUlXW5lwGZkoqfmLUtcd3obzqi2MBko18koTtySG6XTzdM8AiTSlV
    fxmbcCgX9RJXpejJFglBIE/6BkpVIkLwF8u+A+lDLtmyr/VolFHrvxw+3O1yfL6c2G3dud
    C8oo1Si4dAcQDP0iGHVcdX025ZjdfyvfoqJhG9H7Bi18e6T5ucfXjOax7k1nOIyOPT6NfQ
    2PXvZnPN2urq4hgUREoi6sBaOyJXmTb6uQQ0Fm4NtXZv1annBMMAaCa+u3VaNoMGekuljg
    2vgXZ0wtCnV6G5WCL+30IODw5aBta+tHUkvc5t9eCR92ZDaHGpi6d9sa2uAA
X-ME-Proxy: <xmx:VEL5ak0gExD7RequbW5DWdJxTc-_vjMokZ09CiaSGsvd3vtSBKW2YA>
    <xmx:VEL5asynkQ__k1-J7WoR5VLMh3LjIKuewDSLZUBmWoF4AbAphHDWWw>
    <xmx:VEL5anVQMdb4xRbWCcnls8yzlcP94ZNJbiZwwiWcs_VaStclqtjXvw>
    <xmx:VEL5amCB7izlYBMl9NCqCqAaeiWUCnL8dbD8Y1Ev1KprW4fk85tkEg>
    <xmx:VUL5amEsXGoM7mtVBVvkYrjuo4ezOWGyIWuGZ7y1-yvQ_1qvVVma8wGj>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 15 Nov 2026 00:25:38 -0500 (EST)
Message-ID: <fbaf7f58-4c42-496d-8db0-6bd7ea3ab0b0@pobox.com>
Date: Sat, 14 Nov 2026 21:25:36 -0800
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
Subject: Re: [PATCH 7.3 000/507] 7.3.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261113153753.358973689@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/13/26 7:45 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.3.5 release.
> There are 507 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Nov 2026 15:36:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.3.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.3.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

I took 7.3.4 and applied the stable-queue as of commit
3b8ff7f280433e6fb085dbc4f44ac6a138f352a0 ("fixes for all trees").
So, equivalent to taking 7.3.5-rc1 and doing the two mm reverts.

Tested on 2 amd64 systems and an arm64 virtual machine. Working well,
no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
