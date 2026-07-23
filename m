Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECBA779CD
	for <patches@lists.linux.dev>; Thu, 23 Jul 2026 00:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784765224; cv=none; b=XdnWe2oueyKfrF1MyviQ1EfX2jtJ2w7kjjnHBD5wTS0TxVWLhyEiIzyXMuqlScHTqYmi5t+NaCd9HdScmfr7SOrpE9sX2AvNbApAjLNVonvJ+2gikbkQVKBn/mSM42//ZP/GjY9afh8LJIqdcZryT7R9WRX5fSUCJOlxUoGCOEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784765224; c=relaxed/simple;
	bh=SMXq/c3sQoXOSucyruMi8aULrWNRt3oaGo/8EkRRYk0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jHmEMKXwOQ1chsb8HDHS+VLOfsGLEJWEUuZB1X/+GUecx7uOPHiBBU+UcLdVXKWlhUmnX1eE9ih7xtxyA3Rf/imJ6Wrud51NkSvdhN3ohK/KqfII9oSCnY7tbHraX6t97KdgD400AXi90zdnLI6B/DoHsaT/a/tPXcphcCAxrTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=Xhie8Ndt; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=BTZmy+6C; arc=none smtp.client-ip=202.12.124.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="Xhie8Ndt";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="BTZmy+6C"
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfout.stl.internal (Postfix) with ESMTP id 920001D000B2;
	Wed, 22 Jul 2026 20:07:01 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-10.internal (MEProxy); Wed, 22 Jul 2026 20:07:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1784765221;
	 x=1784851621; bh=1qNI4f/jFL34X3GOabncYuW//3eyuIlRvWzHyhmEuF0=; b=
	Xhie8NdtnAFFecpGARFdmWjj2Djaf1pDsHH0FvkH/W7mXix/N8gq1wivvhvMjZN8
	jeImHTTYKVpMIQ5MjesNnXe87WknDLgZciBAIfe7sdmngldnoHDhVLC5t63ygHMO
	SJGatbvzrkbDb0tOWxzpRuDA4NQyn8RlOCgwdrTq1UOK2CZHO53erLu+7t3CxBfb
	9GOKQS/ceTSjYwapRyjVJFn77TtsFoYtnwjmhIGCV/HVKuk8pVCBH9excetrMU41
	RT2GA4fT6SsWC2IOQzDJ8q1F76AobzOiR9r2fF9YQ60lX5JtZAneojMjsDrq/Nfp
	wJRPP5b4eKCs0/WpH4Tw7Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1784765221; x=
	1784851621; bh=1qNI4f/jFL34X3GOabncYuW//3eyuIlRvWzHyhmEuF0=; b=B
	TZmy+6C8pkB5oraMz1r8RmLjbRGxoXW1fgYSkxJnWp0kAAYk+glcXSXMdJ8+n2GX
	G6h3OOXGNsbz/NsK7pXRxsFOFpBDRKvPvvnnlAz+nYEwuMmURy3gsnfbG+yWYtiq
	DnGO+hq69y4UM2k0PWEKsKcg/W66yZ5leFQhapX5lE+wvZv55OU5aarkN0BDN5w2
	zT0KCNGuCno+gZkU9aEOORBc/4h0cIUpWW6rNEzMY/t899LYQOLkWdZ/MpniT2dj
	fKjJM08nUNguLCCNJLEFSQ3bOgLPuZaZJkOGf+jLOBeZgxs2hV3yjiKzg4RE0BDa
	PIEQ9rLHaTYZYdnfgbiUg==
X-ME-Sender: <xms:JFthaqGMmRhptOB5ebXJbFkP4kkx0BwzOmz4VRy6dgb1ZdH4wfmTsw>
    <xme:JFthanPVKIxC7-k8zaBDCEeHtg6NfqFH3ZOLjKAroTUhHSjctCieWl_BrLMm1g3sj
    MxgfV36vyCUSuJjAhDLffSVcCXDygnEreAL9zc2PNbHkou5z5mI2ySX>
X-ME-Received: <xmr:JFthavoaQOa0U1WYvDY5BStsY9CjPcDQRMpJ_4eNOfJvdODd8GJNzV5huONT71UQNzzjiWNJbeTAnYv1bDXQ18RlQz8WdRSl>
X-ME-Proxy-Cause: dmFkZTERyxiSf1xaEmvv5dv9cQXowi5avp5nSBFII9DX9Zc/i1l8pw1afva9MDSwYutlo6
    zNade6Mx4+aMHfm7W8n8uln+S7eDebDED5igY1J4spGVAOgOKLfsZJwxML6Kyo4KoqPVvy
    YFdDHtC8pTyqxbk98Gc/CmWqsnZPxnRXkDGekgwSNcPQw9sxkO5JkFCF9AQyTBMataEKno
    jVTDpk0SbldFy68Gj8Wz7uX5U3wd1X3ZYvfm/f0KnMzmBR+fmWpzNaGDR+Swq5AeT08Z3G
    drOWcsc0MxI388+atGwTqt/KMIsGzgA0FDi2+dMrx27sr8Ys/YyFfU03zpT1Qkm0pPTIFL
    a8E7jmUEXp1qI7EsjxObCbwW8eoOCtesG1htCdsNuLhqub+1ewOXTAigHZLQKK67KlUoLx
    /Zd4t9Qqr+L94xf+oSQZNdSWmIBQJUbWhcMflK8JzCD3prbOuoYT1U9Mpzb3TPnXVeXVpS
    tyzxIGZwrzThzwtFIB1Rr5kjDYJV/e0iRpuCVblhP4KAxMqbok1TS/Q9uVuD0QeG6NInGZ
    N/Cu8fNGisCtf3MW4GARtHiy2TuTg7zkRS1ZUUTbfdOJE97vQKDN7X+6MvLX/Bjt4hliEO
    o2ziWgm+5KWVohVSJ7DAmBe5Tagb4T47grEwSlD33t+XQQv43gaCO7nla79Q
X-ME-Proxy: <xmx:JFthaoACc5-PBPOFRDfjewYhZiy31xg_Q0go9gdfsz2ivTVy2mdN_g>
    <xmx:JFthaoPJogFI2HayVnUiIV4-xh_3lkLdT-Xf5V73vHYb1n5FE0YpsQ>
    <xmx:JFthamAVexLTbOSNQ2k9MZfbgaSSJnfbX75BKa_lD990no-skJv8kw>
    <xmx:JFtham975nH7rO8wAGBmTl5iu01IRnAc7aVspwbzxulmvK4PGN6exQ>
    <xmx:JVthaqZZFRJOo6mRiwJOJz4pbztB_E22FqBrP_waP7KBTGX-Aj_-7pJ4>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 22 Jul 2026 20:06:58 -0400 (EDT)
Message-ID: <81158dae-937d-45a8-b149-40814cc966ae@pobox.com>
Date: Wed, 22 Jul 2026 17:06:56 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 0000/2079] 7.1.5-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260722142947.085426486@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260722142947.085426486@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/22/26 7:32 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.5 release.
> There are 2079 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 24 Jul 2026 14:26:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.5-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on 3 amd64 systems and an arm64 virtual machine. Working well,
no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
