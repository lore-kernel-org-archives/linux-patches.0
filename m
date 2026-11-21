Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.145
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795233858;
	b=kSGucyqZZxblR2UW55tvaM/1Mr6Us0h1npgE3Tki1/QDzTqvrNYq8FRM0iuIBE1FXx4D
	 f2nbECsqYleIUTo5lazB3hUEmyZzvB/3dRzMFWIyG2OgKk+zC+LB/9muoQHR0+badNdvz
	 fCylaa+3RnuIWtH1fR6tVmzsAMFznFVxdckrcGeIXa+/WkCSCw9R62cHToNsfHxKp5PYP
	 I4bh/HcZCILl3yRwQgpLS55jDqEBJYxjWc9EgHOsrq/ONHm9sMxZkbfk7hyD/ZuC2KoIh
	 Mko4x4gK8KZNkV1ftTf0tDTw3ry0gfkde6WDf2dKnRcsHU9RAOz+gAsCILvxWNfYkUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795233858;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=4NWubegdDtXkANy9fHp8pgRcnLPGL9pTvrg4SvHxqnw=;
	b=rE3sYvUwpHcFJ/kkYPlL1/xLfju1swQRcZMX3FThAcATwhsOI6Ib8eeTBigQTfwfTM8y
	 lZD2cUHGN+yGUV6zlzTxBNpd9sWmfNh5di8XARYXv+g6j9m07zpv8SAk6A5f0p1GvmMM1
	 bxSm/kVH2z1CA1JxjSgvQqK7qYa6qghY1aMWElDH8vpYRXY/fTV/JUzd0/ac3ZrBbMMSP
	 8EKFz2DhdTi16YdmYOESnT9HyHk4/us5ktgP1TVNElibICCmTS3jXqLFO0GRt0RnUPbf1
	 vpxG+BzhqRF+8mPXRGobR6c2zP6+otc3+tq5n4GuQsXXc2JKhlNFHb02j2VLHJsu+gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pobox.com;
	spf=pass smtp.mailfrom=pobox.com;
	dkim=pass header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm2 header.b=c6Ua18WF;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=mP0GHkyU;
	arc=none smtp.remote-ip=202.12.124.145
Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E05606A6A3
	for <patches@lists.linux.dev>; Sat, 21 Nov 2026 04:04:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46E05606A6A3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm2 header.b=c6Ua18WF;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=mP0GHkyU
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.stl.internal (Postfix) with ESMTP id A279F1D002B6
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 23:04:16 -0500 (EST)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-06.internal (MEProxy); Fri, 20 Nov 2026 23:04:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1795233856;
	 x=1795320256; bh=4NWubegdDtXkANy9fHp8pgRcnLPGL9pTvrg4SvHxqnw=; b=
	c6Ua18WF9CyHY6iBfUYzMDUEtUpZa979Ise+47sJnK1Zu4USqoXGTuVVOakSvpzq
	wGEz/jAzkRN/8bUW8pcKPjlujKXUXuW5+Rs/aovg5ETymPqVIoD7rsIm9WNx+5Ru
	NgrgQdpFSyZNW5V6G/C2P1Ca5nHlyv7JnB8eDz8fPdOYa4RLZLpWTk8eKB416bE9
	/0KioQqXoBPU6Rlyi0wKJeF4tGl2lXe4TEk0mESOZ6WPGivalZMEDxX7T6h1RHnW
	b+goQG1ylbo5UEZrThtxggAnvSPEJSWOc3Te/UN1FiNjcRJvgk1V5pb6DqOUY72C
	tcQYMELumvF/vg9Qk6XW8A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1795233856; x=
	1795320256; bh=4NWubegdDtXkANy9fHp8pgRcnLPGL9pTvrg4SvHxqnw=; b=m
	P0GHkyU/54qyL6Py0HotK++1IygGG72dHHHIm1z2+J/IEHIGU1cmRKWHzsSYy2WZ
	fyUoypRmZTe+i77nQvj4YdaizAoltqztqa9nMekYsmx1meIVsXe2D2JuSRue4W4f
	MTNi4iGAOT6B5X8x0WQVItl/0gJ+PcJCvKZ49v761Avt4K8F/zVVtpUxDfTKcHo+
	iZ5R1AdgL6aYH6EFCiCuyMsn/vRKHPZlteA2xMMIQrvC4b2uxJSP0D8ZUlItZp8R
	R4WG9s2cxeGT9oJGCKHv6khI50NgR3IYifZMzlCwfoU6vgWtzFHzmgDka7g3dr72
	AxL5/qFdy3lYmPTmqo3rg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=pobox.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795233856; d=pobox.com;
	mf=PGJhcnJ5bkBwb2JveC5jb20+;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm2:rsa-sha256:C3TOYWvpjpECB39wZlTpwuoSx2g3DxW0cHA5fisIpf1jXlJ
	cfAnTpN9jYz1zHTHRQl6DEXqqem3UE9nAqGqeykROtrXwT6f7lUl4m5Rlq/qxS5l
	BVylimbFa4Qqu8G+JZdkB1I8QMkBlYOWfWMZ4urfPuHZ9j0e/OdZFpTMQbg9iAF4
	tgMSA7RGXK0LbD4VztpvNRQwhIi3VMSNNXnriKNmakAm4opeOheB4f3c3rMAJgrd
	N7ESyHGvApRamTEVTD7Mv2wK7NrowVqygfDJ1naqDdfmBM3Ca99o7Eaakd1Zf/Iq
	/XjwUrJlJWrlL4B8nuHiLGshFvwA7et6SRvQBBw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:jcj2mBAUfhc/XA24AF8aFtLHZAWxctlPNg+y8pqLy8M=:mIGCjm7rePHhbj/pjwBkD2qnT6zOJXuui8Q5sX7LCGU=;
X-ME-Sender: <xms:PxgBa-Hs00f-dfUVLH7yiienuYEeGYQee0FCGluUjVtR70Rdv8FBMg>
    <xme:PxgBa7NQfVVmv317ApEXDMQ2pTpd7kGjYQOBkzaXhKy4oK_yWlMWjkSCA9ydPRffU
    bP6qAstU_XeYSt9lNSKVgwYi8js0dY4-WzAxpYs1RN5ZYdcHyD1MxKH>
X-ME-Received: <xmr:PxgBazoV9KReQxrBINy958OJBT1jzzwlXEjLIF9wUY4AuYnU3wk8uL-TsmYKTyRqAjvRWMEzd8h4wjz6citfmZk4xj84bFQf>
X-ME-Proxy-Cause: dmFkZTF6NBVmKj6DCTfeBiPFSfoeJSj1Gc2ZNhP9ATKgKnfmN3VihBiU/WUerafd89GyfV
    8xG0XB6F/ErqDOnC4T8rNnT4dlIg7dCZyA++468w28YflOE491Wo0HgTFErmZyV3KroQ4R
    HV3PtWE2gQYeKxarUcsOT+w+/D/HYQhSNucQdQzNRWI8Svirv5P/YrOIKcYY0a2baeu2J6
    WJTTPeGwMHqQyW8Wp5bcbWk7gmQPKD0ZiiRUq+eaqUI0c8tS8BK27Wgx4sZ9odM787xwQE
    FCJWyIc1BkVSUmBZoPBEhNeeZ4gbB5Ln8Yri1tT0ZeowDNLDjnrmFAIGGWPlNw9XLVZOau
    rFv8aBLXar/Tn7Q9H3lPkeco2ahP6sR0ROGfWGaElPTQEqhT3IifzSFQWICRaA+ZAqnutC
    3trTHJ247jBwWgpUw1Oh/qEcXdlDHyjL84sqE9Fb5COopbJB0qAY1KU/cEaa99CNPy8xaz
    SVEWEv+4+hmN6+y01+Ru+4JZuLeChI2Ql7spbDzOL/JkzCZS2xoiTDgtmy84arROfVsiXc
    a237OgStf2Ws6lAbJQbsITv/i8OyUPYF7cdb6EtGuST+35IhSDszC2FFaIPk6Qmp1k2tSd
    lJgPsgZLlGC7JqmEi+XU5Qn8sv2uqA0cOmnPoX5qWDhUZV+wanqzptJFTXiw
X-ME-Proxy: <xmx:PxgBa8AP6rdcqmopl_TnkV1ajYAz2qz8UTVkd6Ey-fOZklto5QQt4g>
    <xmx:PxgBa8PtOhm_JDQ5woQW-OCmmnR1x2-FuJuz7IVCOciHA6GYj_Srhw>
    <xmx:PxgBa6AE1LkWVDdCPBhOFfabvXn1nbh1dmI_DzwDFDcXD4cQqKcWkQ>
    <xmx:PxgBa6_Zt6hSiuKyAsLyPvcGq3a4SsDOeSt3Z1_r1QSQpEgDRa1bZw>
    <xmx:QBgBa-ZdDyCxiXFOHkAGXji4RIYxkYRh2045Pw2KLQt06FK04xA58C36>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 20 Nov 2026 23:04:13 -0500 (EST)
Message-ID: <85d8296c-998d-4440-b7db-343d2130e19a@pobox.com>
Date: Fri, 20 Nov 2026 20:04:12 -0800
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
Subject: Re: [PATCH 6.18 0000/2144] 6.18.65-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261120055114.182757740@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20261120055114.182757740@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/19/26 9:58 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.65 release.
> There are 2144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 22 Nov 2026 05:44:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.65-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

I took 6.18.64 and applied the current stable-queue (commit
3dd4b2d3c1f7915277082781d6dfbe71d7d41800). So this includes
the changes that were made after 6.18.65-rc2.

Tested on an amd64 laptop (Lenovo ThinkPad T14 Gen 1). Working
well, no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
