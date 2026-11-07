Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.152
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794095346;
	b=IMpPHYFJz+OGcXb96JpSpOv3AGRR5CebYx0WbJ2fiFAghoMAO3SsMTWmhv06ozM3l0om
	 RRYJK5GyPvPfbEpNPXGXaODsPszSB/3ZWyKdxPQtsRMDJ8qTR4yOJvvEbjlX64TCNok43
	 33nI0R8LDmY2ioGUf6+8EA7G8Mjnxj+MjY9zeTRiIYJBOau8u5SXSOlpp6bmvf6BTR2OW
	 hKqKmXIIiuw5c4JPykj7sGA+Q2zskpW0eGi69posMyqSKKCCWpn9veWSEGdSPp36DuSXN
	 YdylL/TSSqhlBabd91VJ/ZSUr66VerEkZM4+Ufr1oZ2Fh80qJlh/cirmYXgbP7xnKyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794095346;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=gD8g1X301eqPT17aTVPdKs9fubIZ73BJDrt9THYOiPo=;
	b=zNw+0NEGPAI1QHeGEoEy9S+IjABM23HounVsnC9R0BmWDdj/HloTwE/7t7wVDzpN0/sc
	 m+9/TqbTbqIy9ojKXjTL/vJ7nC7tQt07YC5/bnNOJ9oUhkTAJN75lPyRHjzWJ9bkw7DzA
	 iwKYsLUwV45X2lU5uqh9wW4hVGSvoopeptmbxSLAXYMhrsevSsoclJPxgv06ZqD3zfAy4
	 di90fSN089P1P1S/fjbBb2LBivteCTA0pHZhsp3WlDXhmWffqUDltI7IbRAkTwqljc2zF
	 +T71y4R9Z+uN9Lj5TZN4AP1QzSsOMUeYuphnEXCV9aiyVIKtLtNhF14V0WWHGt1cJPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pobox.com;
	spf=pass smtp.mailfrom=pobox.com;
	dkim=pass header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm2 header.b=ApCQw8e3;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b="bD/9E/0q";
	arc=none smtp.remote-ip=202.12.124.152
Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D696606A32E
	for <patches@lists.linux.dev>; Sat,  7 Nov 2026 23:49:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7D696606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm2 header.b=ApCQw8e3;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=bD/9E/0q
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id DDB027A0162
	for <patches@lists.linux.dev>; Sat,  7 Nov 2026 18:49:04 -0500 (EST)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-06.internal (MEProxy); Sat, 07 Nov 2026 18:49:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1794095344;
	 x=1794181744; bh=gD8g1X301eqPT17aTVPdKs9fubIZ73BJDrt9THYOiPo=; b=
	ApCQw8e3ecT+wWdTsZtaeV4hhoOzn0CQ7i/x2mMEm6s43lEMHOBX/OfuMEr+toV9
	tPa5XmTtMDecyOkxbgYXLcXpLxUXVmNFyT6DbpRihCaNV9SAbJy2jYEE9LN52emz
	Ha+QPwLsnSPrImwJz3gMGaNVS9jtSCzuiHVxZvhElyzzX/yNkUbwz/KBx1YofLjK
	132+fw85ruhhxs+xu5kokll6cKJ0YR0UHre9B2bl6LlA1aJpsNszq/vCU4vLu6Ay
	EPHpc9H4GzgtDvY85znsyGuOSEBhU9jUA2pc8YBK3teUj1bhrfSCAMRKu+KEdvbs
	ZHwmw6OBS32IPqSFNJCVsA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1794095344; x=
	1794181744; bh=gD8g1X301eqPT17aTVPdKs9fubIZ73BJDrt9THYOiPo=; b=b
	D/9E/0q4yncFEnY6C4wAq3FarAyN/rWuOs78DD/AhaxRRJ2t9/fH0USOFR6GZSia
	+3DXXuxq5D9U0sIs24lH8APL4rBFu2oRtCb/MKtqdntuP8BYvZznPmamDZvODC2s
	DcWxZA2w+iO3/Rb4Z7XmDN2fkeirjoS0QfQwGMojuPLEpF/O9ZO+ezao6yCxlLpP
	SsPvBMxAvWpEV/UTvgUQvsOJn68auHKZ97l5wFv8HzhHVNd4CqvNlN3s5PChZaY3
	/vBhAkLVFh+3QjaVbhubPrPVnA2xzJdcr0XsxhNY0LMC09RpnzCoesv5A9RZQ16+
	Ez66znG3miZDv4l9TRfIQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=pobox.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794095344; d=pobox.com;
	mf=PGJhcnJ5bkBwb2JveC5jb20+;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm2:rsa-sha256:T1h604RHmB/WXW7GyMtVLW70QK+a+uj90IgMQ0oJyWwyjaK
	ERiZZvsBl85MdPmOFIUxbH231j3J7X879lcPf2N6Ziid9s3VAt4h7sn1lBKPkYrC
	caRD03XdvCO0u3Jwrxm9bQdLJ1X5Z6zO96fLxCsNPjnCZw8hb8Nwomv2EvS3HS4S
	HaRzQDNahQ0wIncOYB8QbrwGiPmA69XQM7z49B9hwNk7zjvBmsxcjtp24ECVLLGd
	xqlodTccSo8qYSz6cTPIa2/Ywougz/khP6d3zG++5jFnohD0XJYn9+M9JOLbvQBN
	6J1SeRWJcFXOQWy8AQVS6hyQzJbR23p4jVoYYig==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:G1yivMZvsHaxIqxODo01QQV+NG1kXiYZ7/u+/h209x0=:EjN7Ysv9OPVIViPHOBJ0E4kLDesx+RpDcKED22Oc6z4=;
X-ME-Sender: <xms:77jvapAMKZmxiAvLdvwTJtIIUqwb94Nlay1DB3ybF1NIq25jqGZO_A>
    <xme:77jvalOgl5WNln9A8Z7Ekw__ak5eg1pveJz8Gmv8DR9iSmV2DTirWQN5H4DDCTLJp
    -1q87oQEhVRArsaRgV8xYjSt9zch8JUC3-FAI_aAhsD_3uJ49cWtS_4>
X-ME-Received: <xmr:77jvamW_kAUpxpB5Nz42LiWabjIYZs2mwQxMXh3_qXWke-kDxATcD1c95WG_e3qrnX7IBnU7ddCQc938TqAUgxepF3_JyAyC>
X-ME-Proxy-Cause: dmFkZTGAB57/5P6KpLAWm7SdidvsjVYV1Nxgl3C+gZxBhFh5Q6vQTD22Axpa+2VmMWLl5R
    thH9jfluodRwgs8DtezeugdHSI/WmUcj5akH8puA/kHeTnowufz9W94QAuPM1HAxXF+NgX
    Mo6/NqH+7H2LBJRX2U7VWP5cuFNGaKR9IHwIJK8UjfIUAjcd5iDpF4WV+9lLMpJ1+CaY0D
    8eEj3ZAztSaCTovFSxYIq9v+AYyTpr4LMRXTHPOuqyl3rKDc1LzZ+DmxWK1uztyMsCovk3
    TWNKAPvncJFk3c3TNKWng85pEGHdAcKRiFeEP6LemsR0cPxBOYa323gxE2eV+5mI/w16mF
    Xc8bk6QjlkrKwoOhhZ9ywQbdXZnx5ENplH6papQcs7BO9Av/tnLp1HpY5Hwn7u604Go7vb
    xG4cHde/O+h3vpEPBV6Xjf4inwlQLtoiMMu3b1UpcsaWcnoTQSoun3SBndJe0NwRaRb1v/
    Glv6BV1+ZWLptS2vHOG+OdIM6OK0zNyTBZYDmITK84vqFf/NRQ1sQv+WSJD5mGV3km7S9b
    ++7WmY2mlpb16PDujREJyf38m+zuOOKpsNVR4y0m+Vr8sNJ8Tc5qPiVqZHGxW5N51MenmI
    RrFHrN+Ie+6Ot9TznaTiZDHI6kded3C0XBLc9AT5rlOo5TGVSU4nuG3ewqKg
X-ME-Proxy: <xmx:77jvagT1He2K9HS7jYpzWi6oZvVdX9I3_YbrlY9BPVyaA1iaBeeIgQ>
    <xmx:77jvak2B7vc26cKq0WSnD7ZUfRKelvwawQVnqrR9xpLHZ5vHap2EqA>
    <xmx:77jvalhdfttxUWHyBXzZI5XRnjpyyvcodj__TbUh-EJs8_UDxjvftQ>
    <xmx:77jvaqaC2SML6z3N4cKT5vvZGaCiMci-Sbrxo17NRqtDI6qrJyBtZQ>
    <xmx:8LjvalJzZpiueJt7Bl6l5ekBpZ6jlrcjx-wIxDcsxjmm09W3G9uvBb3G>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 7 Nov 2026 18:49:01 -0500 (EST)
Message-ID: <f65916c7-470b-4f64-84d1-da8cf4c8e7e8@pobox.com>
Date: Sat, 7 Nov 2026 15:49:00 -0800
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
Subject: Re: [PATCH 7.3 0000/1257] 7.3.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261107134939.434104957@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/7/26 5:38 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.3.4 release.
> There are 1257 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 09 Nov 2026 13:46:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.3.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.3.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

7.3.4-rc1, 6.18.63-rc1, and 6.12.117-rc1 are all giving me the same build
error with clang that I previously had with 7.3.2-rc1 and 6.18.61-rc1,
due to the same xfs patch as before ("xfs: cross-reference the primary
superblock"):

fs/xfs/scrub/agheader.c:123:6: error: variable 'error' is used uninitialized
       whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
   123 |         if (agno == 0)
       |             ^~~~~~~~~
fs/xfs/scrub/agheader.c:435:9: note: uninitialized use occurs here
   435 |         return error;
       |                ^~~~~
fs/xfs/scrub/agheader.c:123:2: note: remove the 'if' if its condition is always
       false
   123 |         if (agno == 0)
       |         ^~~~~~~~~~~~~~
   124 |                 goto out_xref;
       |                 ~~~~~~~~~~~~~
fs/xfs/scrub/agheader.c:111:13: note: initialize the variable 'error' to silence
       this warning
   111 |         int                     error;
       |                                      ^
       |                                       = 0
1 error generated.
make[4]: *** [scripts/Makefile.build:287: fs/xfs/scrub/agheader.o] Error 1

I sent an email about this earlier today, before the -rc was sent out:
https://lore.kernel.org/stable/7840e515-e7d5-4ef9-8c1d-6390374a5b33@pobox.com/

Reverting this patch fixes the build, or the minimal fix I proposed in
that email also fixes the build:

--- a/fs/xfs/scrub/agheader.c	2026-11-06 22:42:57.147299404 -0800
+++ b/fs/xfs/scrub/agheader.c	2026-11-06 22:45:59.898908897 -0800
@@ -108,7 +108,7 @@ xchk_superblock(
  	xfs_agnumber_t		agno = sc->sm->sm_agno;
  	uint32_t		v2_ok;
  	__be32			features_mask;
-	int			error;
+	int			error = 0;
  	__be16			vernum_mask;
  
  	/*

So far I've only tried building a minimal test config. Later today or
tomorrow I'll do testing with my normal configs, but (to make a long
story short) I will probably experience temporary health problems
for the next few days, so that will probably slow down my testing.
-- 
-Barry K. Nathan  <barryn@pobox.com>
