Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.147
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794709423;
	b=unmBbv0gDx+yVbyxFeQcwFWWTz9D77QcGVyRLnvYc+mvQQ6kVsdr7NM/GY9O3t/NDYG7
	 h/bplCncWII+v7dvewPnGUZmeM5AeKRq0tgEtDpG9ZX5d4sTtxmSgqFBamGIIcBldme6j
	 xSljFmEGzbf66EBmz1hjPgeSi03nI6b2nA+XUXNGQdj0xu8o968FQUxfvZCXOc4bg84ap
	 tF0mPxxk8YsoJcu8zCdyYqEIOUxdCkaEUrzLdhR8txof8AzQGuGOJwl2paEmbovhWk2J9
	 FHkwkF9vbuyZmnToiDANUJZdNiwJ9pC8zdEwDv/J94LTFR9uksTYsAUc6+IF6b58buA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794709423;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=pyJEuL9qie4Q5tdeck4L8shD9qsGn8RQvwkmrVaX+94=;
	b=0SMHv5VgXoSjxp9c1R1Tlt5L4146dQ2lkwVX+vOUpd20OPI7wh9VfF/vHOXjs9muqCWM
	 MTqPvLNHise2h3MUBLEukmJk/UfsBmoi/6V+IPtQBdAVFHVeCCiw4K3CgpSTs28VpuDKc
	 ehYiEMO/WaK0KLLYlVXnUEJWek5ah48MAvX6sAGY6L3cNRhVtso4J7zNgvZnyMX/Qy8oZ
	 ooIvsCGr5Bb5lEJodWEfERfUv8maF7PDfhfvQnHGVy1Ky0dULNIykdonKBojJ8HsjRq2r
	 Qq+a7/JNvqGO0vYxuhiNTUPLUpCCc93a79ElLgKhcwAcNee0d4RPqZ0bkDoOIxAz8uA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=seanlyon.dev;
	spf=pass smtp.mailfrom=seanlyon.dev;
	dkim=pass header.d=seanlyon.dev header.i=@seanlyon.dev header.a=rsa-sha256 header.s=fm1 header.b=Snaabcmi;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=VvgkzkDz;
	arc=none smtp.remote-ip=202.12.124.147
Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46CE9606A323
	for <patches@lists.linux.dev>; Sun, 15 Nov 2026 02:23:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46CE9606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=seanlyon.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seanlyon.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=seanlyon.dev header.i=@seanlyon.dev header.a=rsa-sha256 header.s=fm1 header.b=Snaabcmi;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=VvgkzkDz
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfout.stl.internal (Postfix) with ESMTP id C35AE1D000C9
	for <patches@lists.linux.dev>; Sat, 14 Nov 2026 21:23:42 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-07.internal (MEProxy); Sat, 14 Nov 2026 21:23:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seanlyon.dev; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1794709422; x=1794795822; bh=pyJEuL9qie
	4Q5tdeck4L8shD9qsGn8RQvwkmrVaX+94=; b=SnaabcmieKA0HBR+6ETwRvUOJ0
	DcIeTTfEC/ehin+epd2xDJMaZ/Z1BzOS1K+MhlXfOE7X9/1siRqowj/RLTZML3Ye
	PTVBzMEmNKxB5jZIvuucVONuVLSVbUxkH63s9JXjEDc0cV3FFQxa1Squi2Kceeca
	i6aW7AdKxd3nzLSyVTCFJkbRSOfc2A66gGoj9O8X/s2UDEKglw1X1tPEEoDttJKE
	TgKi2UZFt6yE7DZ+Akj7b3XHmBm4i5HlFebidgitpGyILX7M7Gp5JsfKwzx4R8d9
	uBofVlKDvR9MPMyxOcCLQm3iZkHQ4tcBS/GyIWg5Vu23PJe+i53gKqcPejzg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1794709422; x=1794795822; bh=pyJEuL9qie4Q5tdeck4L8shD9qsGn8RQvwk
	mrVaX+94=; b=VvgkzkDz7kWeVJUCIcV0FvjVrOp4a3GEQ110MuT+pLRhPThK+9w
	jfwqb2hu6qhhLVC0EeMUXs/CQJTNAwNTU1Zq+L75TIYeANNlGC044hucg95mwPsI
	bO3RWSZFUMSM+TQnhfXu+rob7gj4PikTOyFyOyduKQor46k4ZcC7z4uK2aZRWQ8q
	XRd8GPA+XzRwQiclNvysQCXYbifBwQvV3lUSo6Ukd07BVRpzExgmJcYvEULNXloZ
	mMdIoux1Uq4YYpNigL9gCRCyQrZ1q8F15yKDFEZSSJssmZf0P+WIeZiXWJ6unFLp
	jagStuU2shlLhrL3lPNHx7O3WW7tIIwiWCQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=seanlyon.dev a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794709422; d=seanlyon.dev;
	mf=PHNlYW5Ac2Vhbmx5b24uZGV2Pg==;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm1:rsa-sha256:Uj0yFE6nxExoBcw8IkFWSgLejV0QFNKbpbKXNsikRvAZKdU
	4MVpcaRw/Z/Cx9t7KgZTcpT3tiTEPHJhHvEniNB7MhK+fKW+SUSXpFQlTjpmZfvU
	VgklY/hOHe5px4Nk57dpmPYNz/KEkU0Fw5ImgbNByjuMUTQ3nzKCwfpBeJzQeOda
	26IdbKWyx6EmeP4lUNFE7zWBs6aGvZqOSrAYSrXmSg+iR1KU1MMExUZ29OFJ5Mq9
	pSMjaUncjpOSCNA6Z/lDolRCcto8RE8U9sWRVT8/dUxU5IeG1Hx2i+B6fGeXZWxU
	6PIBZ4bir7DaFBa15mfHHasty2KvdHu7ttyg+nA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:mMsIwSRy4Fo0fenOyS5an8wFuhyEnAJCw2MD5Xu1iI0=:UCYJ4TatcK52EVb5/wCjCGvBMqkoHuWp7r1J7OEchiI=;
X-ME-Sender: <xms:rRf5alau5CLrwvW9PNl6YR05OsrqeHs6mnu1VlHpRSBUxOp5Wun8DA>
    <xme:rRf5aoTNSnf5mw-lEps60mCiIdm0CbHOH8Y4yMVoh-9gIipqrtEmTiJXbaJH-5tV4
    ZLtUOjT4-mu1PQedSqRNNESvOseWefLTeTPq_-PSvd2F17YHR6djQY>
X-ME-Received: <xmr:rRf5ajcAQvbvVibJiy6Vc47gi3BmhKOJAOZykBV_9oGcpeJofHpDCZ5TEzrraa6301YCB3KACnLGOfyTSLU9rzAk_Fk>
X-ME-Proxy-Cause: dmFkZTFZjYd7mGpZLTuxKaaFHRoYdX4i2NEzO9HuaJQJQXexzsQxFWJpruajcEOtNfm125
    IN8fVsjuYx++xYPC9l2GGtQqH5GoAtFP8SpUPBA3WT/KVbvUGNozjI1opdcjs62uqwRl8V
    hCNLu2O9B+yCI5nm0ys6Yewfc+IH3pkdkGdlcHTMhxk+0WQcD1N9INX1NenQvaQo5ZL0Je
    oE85VCJTP6I6oPToVijoI4I0XvOLZyGHAGMTrsGjuTZC4kSHrz5HPAk7m7yCxVDnYepdyW
    H4MOhW6eCoeuSmkxNXVx9BRgf/XRgwk9G6iNN6eEPvd0pDjYhPcfvdcuyctibHTm1x42m3
    cKIzen5Y1FTerOEoYo/a+IL5BIBSBH/juCipeqC4D0W9Hc9XvZgW5Pn8UJLHmDoeVV0U5W
    3ZGUN8zj1kM50S+ImqhD2LPvI1PAXa80t7hV90/AP9odxmWlilj+Zhs1QOFn78O1tIE3ad
    YquPeeYTfaxhIECBu/DBmlOpKGbC7EpZrGlBd0SWO6Ory2dLvktphYshLqWtcw4vaMM3YH
    gIenoDKBP4CTkXF94X0jfelctjuQaF65XaGYz36kBFa0x2nElWssj/pCi4QG145Ib6fz1C
    94hglDq84v/eMHi4KEGHgVmOPmiOvbh0SZiIH9Xmv9Ga1f8QmXR/GPVdVqJA
X-ME-Proxy: <xmx:rRf5anlrcl5Ke9HijzRZ0pkqqToytRdPRbDhV9UH4bdyiZwvEQujgw>
    <xmx:rRf5aogxPoCWiHSf4mxWKlwwnr3FDAyawbj_fMsLhEDtLK8hMPkFIw>
    <xmx:rRf5aoHdttR1jYTZW5dB44I0W73ALcFezsb3k1laOB5ezeVeOhSj7A>
    <xmx:rRf5anxXlPePEFikKqZkUL2_ucOqTb0vBu1KuVrHykImvnMSzFOiOw>
    <xmx:rhf5ajvYu_yPqVZ3d6P8eiKHXHw1is8GJX_qtiy9HUtks-PL2IleVCU2>
Feedback-ID: i07c64b5b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 14 Nov 2026 21:23:41 -0500 (EST)
Date: Sat, 14 Nov 2026 21:23:40 -0500
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
Subject: Re: [PATCH 6.18 000/686] 6.18.64-rc1 review
Message-ID: <avkXrIG1xqzHWMcv@ncase>
References: <20261113153820.902362109@linuxfoundation.org>
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
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>

On Fri, Nov 13, 2026 at 10:42:13AM -0500, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.64 release.
> There are 686 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Built, booted, and tested on hardware for x86_64:

- AMD Ryzen 9 5900X, Nvidia RTX 3080 (nouveau)
- Intel N100

No regressions found.

Tested-by: Sean Lyon <sean@seanlyon.dev>

Thanks!
Sean
