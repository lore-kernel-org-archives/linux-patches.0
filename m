Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2808B361647
	for <patches@lists.linux.dev>; Wed, 22 Apr 2026 07:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776841392; cv=none; b=dKL+LAEIqEPI+TbulfU7RRpNEjsDRsRRy6SWDTOcrr5tf5d6zB/gvi1JCPaCoZFdxK/9XBcKNQAnH99DlBvOmcdUrCJ3y6VXh1min+LAxvwvBbbK0MUMvFj1sYLgRmAiQ7PdzDhEN627GDrjlIG57u/gWdbVFYI8JZt/2eM7qbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776841392; c=relaxed/simple;
	bh=WkhNZCJwNgHd0N5khdpRXMOOJ8X7K9P2eioLiC0zyQs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CBPqnz6YiYadaE+0DAkGdCEzVxKX88SB8a0C3y5qj6V8JAaWyJPUm/YP1fJ3amEkNIXsC/9KCENYRTOzv4aMtsZ3/26nt9yxx9QjJLCKTNLt3NtmDbn0x9R+ACnV5co5QFPUkS0RCYKWVrRslE/UgwfT9OlpA2JI1Azwt5vFgJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=yct43tcI; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=iqHJOMTO; arc=none smtp.client-ip=103.168.172.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="yct43tcI";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="iqHJOMTO"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 7B1841400105;
	Wed, 22 Apr 2026 03:03:10 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-04.internal (MEProxy); Wed, 22 Apr 2026 03:03:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1776841390;
	 x=1776927790; bh=gYmL0iGFIRmXH+uTkCEjHW4J+LglNX8qo6vj+5zaX9M=; b=
	yct43tcI3ovdK3QZEps95srUoEV1L0M7w9KMWTLOZSkXHuddtRqHw0xn+vjtMN98
	xylLbVM/usFcUYPDrO8yr57d0U9TE7n3p7FtJoQr6PkeEB+9Zx7uYUetvM9P3bOk
	7njevt6TULWuYavTFcbLqCYyf4/ORZngMX14QI0BQeoAv2ms57zPPH42q6lMxnFa
	Fao+3t+EBABrL1XM3cPAGBxHcHX+paairdS9XnuU8e7DEOKByQX55yYPOlgaKc0j
	6g4/oqQQJ4k8DJ+YBfHUdBj5SSMtM9NLovRJn0hZtUvriQNJvKaKiqur3CGCYJnn
	dM2XYEwsQycqHFifB5HfAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1776841390; x=
	1776927790; bh=gYmL0iGFIRmXH+uTkCEjHW4J+LglNX8qo6vj+5zaX9M=; b=i
	qHJOMTOHX58eJOAo0DA0eQZYJoEtmOX0EnYTZUslptDQfvshGOqj4da7UzkkhIUd
	uAS4nqkdNLingBw0kYoU6TNgrECfgVGPgkoFPeZHpFmri/XRJ1ul2zni+Ra5s5yN
	FE22t7gTOKKI0ij3Bx64l9sKViPG6jCABESXuAWN+owFxWnHDFv5+Vg5LhZ//eF2
	MT1AczCSQc4LXKIiXycAFn6iIRHGFc4rtPVCFsM4edji5XkhsGnwWgqq/dabsusQ
	dowksY62RqSkAC2oxGLUc3EE1jsuxG2+YQ22GYkHQMsexfrfP3JgDm/RPHaQljhI
	44vcvTzTL9CN4yy6ICNyQ==
X-ME-Sender: <xms:rXLoacdBwNfW_YxR2KH2OfxksFh6uSDmCcsKeLSNo2Md53AVBIot5A>
    <xme:rXLoaaEabKlwPKu9fv8k3ClqeErcoQCCJ5XB9FSIYw0fsr6BwAWDvWPfsPROV4VM2
    vBsR0hfxncic6W5LsniIva2ms7QWPbUahxF86vu2KIk4IHz5KrevJxn>
X-ME-Received: <xmr:rXLoaZDjc3Zd6d-CP_sVAqIvmhsFoh6PG8DOCuLVdTlgFyF0b9XRERobmThtEWUinLwR6ggwcD3KmuXqfpAyPGXmJG6S4C6O>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdeifeeivdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefkffggfgfuvfevfhfhjggtgfesthejredttddvjeenucfhrhhomhepfdeurghrrhih
    ucfmrdcupfgrthhhrghnfdcuoegsrghrrhihnhesphhosghogidrtghomheqnecuggftrf
    grthhtvghrnhepfeelheekheelkeejlefffefhvdeljeetheeltdeiudffveetffelteeg
    gfefhfejnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsrghrrhihnhesphhosghogidrtgho
    mhdpnhgspghrtghpthhtohepvddtpdhmohguvgepshhmthhpohhuthdprhgtphhtthhope
    hgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehs
    thgrsghlvgesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehprghttghhvg
    hssehlihhsthhsrdhlihhnuhigrdguvghvpdhrtghpthhtoheplhhinhhugidqkhgvrhhn
    vghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepthhorhhvrghlughsse
    hlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopegrkhhpmheslhhi
    nhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoheplhhinhhugiesrhhovg
    gtkhdquhhsrdhnvghtpdhrtghpthhtohepshhhuhgrhheskhgvrhhnvghlrdhorhhgpdhr
    tghpthhtohepphgrthgthhgvsheskhgvrhhnvghltghirdhorhhg
X-ME-Proxy: <xmx:rXLoaV4u_okd9Bici2qq6jQLuVPWSQtHpn_o0qQ7FTqqrOR8DL1_xw>
    <xmx:rXLoaQnr9dy62XxT9y-J16FDuFBJgGe8fJBTlkRwM48CD-P0Bdyipg>
    <xmx:rXLoaW6_hkAx5dCWsg11zikwTlHRrdJ-n-hCwMw4pfp8Iu4A566zjQ>
    <xmx:rXLoaWV3jnCmNHByKtWw1vUdTjf9zt1EjSqVQBfXEylaj1woTFLWng>
    <xmx:rnLoaSyYDLUg8_XHPJDiTfXx2mCnc50AYFgH_qn1JSrA_XmiT36ebuwT>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 22 Apr 2026 03:03:07 -0400 (EDT)
Message-ID: <3ebcde26-a996-4379-bdf1-1b44ff24e875@pobox.com>
Date: Wed, 22 Apr 2026 00:03:06 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/198] 6.18.24-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260420153935.605963767@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/20/26 08:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.24 release.
> There are 198 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Apr 2026 15:38:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.24-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

I tested 6.18.24-rc1 with srcu-use-irq_work-to-start-gp-in-tiny-srcu.patch
and clockevents-prevent-timer-interrupt-starvation.patch reverted (since
these two patches were reverted in the 6.18.y stable-queue) on an arm64
virtual machine. Working well, no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
