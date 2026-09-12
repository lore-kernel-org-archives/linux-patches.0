Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E143B442B
	for <patches@lists.linux.dev>; Sat, 12 Sep 2026 20:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243552; cv=none; b=cavhGjvusKeBDQsDRNuV3H0ydLkJWdJuSKpGduuXmWplwvrB1FzrCHHjxvaqByowyHb4Pl5S5uNJ9KpX2SLZoFfoD2vM6MOiDltzo96e46TWWTZsJKmSL9vOlDDV+0sMRI1oObR78hoyKifhPE3B7yt0K3SXnki/abAch8lAF2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243552; c=relaxed/simple;
	bh=sht7aACAeB1/uwiNlUaXhVeAhs+A57fOlpnAkg1c3Zc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Yv24KlR/zgHocYBbbO43iVDOkVPSNe2bKTSF3bVJoch1Q+7foJHeh6u4teYmMjY0EQUV5usHDBo/XnVTlyR+8KzPMID734e4N68MAtmUfQH2nW3pEsW4mlMr+4/xyqhw1vWPMmPkjDWoD6lz47OT6hWBjw7LX+xQd6mtmqT3p9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=XxYZOFB5; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Z59VWPwF; arc=none smtp.client-ip=202.12.124.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="XxYZOFB5";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Z59VWPwF"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 5918C7A006B;
	Sat, 12 Sep 2026 16:05:46 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-03.internal (MEProxy); Sat, 12 Sep 2026 16:05:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1789243546;
	 x=1789329946; bh=+yxnOYKvIj4tc99Oj0fh32sxDhnziGeI/6S0NJ5A/8U=; b=
	XxYZOFB529QL8KK5Knp5QdwTkm3Az5F9cIaIDCa7hq1b8mgrNT7G0iRzDKawLbU+
	mEJDFD6lrK0/uzG8AbR/WD4tBCE/rVHKqS0hVqsjMUgG3Yh+mbR0N4sEOw8cA+Cf
	LlIHu8xVVlKYDg1PEkCa/eluiV6K3A3pXObzp7WRmKbeh0Hg3Y3zsF84LSbgD044
	7JpxRa5mu2Ud1qFQZd7VKC5pNMrKTjTvIb6odTjqJRswyeaFjQf60yG8MXH453u0
	j1hZnfv2S/vAMrKrQBdeDxFnJBJ7xwW/fQT/bEDJU2CZYYBjALTzCvx+dlrRQf/G
	UjlM9m+W36re9W481FEqrg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1789243546; x=
	1789329946; bh=+yxnOYKvIj4tc99Oj0fh32sxDhnziGeI/6S0NJ5A/8U=; b=Z
	59VWPwFezmHC1bmX3BT7Dvhq+rtjvkv0AXU7FtxrhByVL3i4FuNzZdqSlQ/8yDad
	f6DEBcafySwa7pmI+e3IATS9lcAPNqV63n1fkOocloC5dyXzW24fDa0Mbk794b4h
	+JMu3jKPItEx60zt7E2GdZUJ2ttqzr7kAA9E0B3RR4qRbfiucpV+MNjUt6N+Z1qu
	qURl91HlU9dPGxBcXw+Epf620n0ul5USDeT+JFS8CACJdupIZygO2Lz1c5NW2KEP
	sAGNh3C/bpoRBFozK6mNjpqXwCOjlNnJTWWSTY2pQR3mBs1brWQ60YXRR/f4ElSz
	RD6V6zMbbM2VJtz6vJq1Q==
X-ME-Sender: <xms:mbClagJcoi_miAvHr_0x2ld1bYzWSV-3T-CL7q9vCd-Yw8mnt71pdA>
    <xme:mbClat3ftr1tsal6sPiYKIJE4WXYM4_635gucWisarIWB9E4PWg7beMv__184o1dN
    IrxwzZNN8vY9tiChByNWmuj9KshI09nZUEIEVPfUMD82McpNJAvfG8>
X-ME-Received: <xmr:mbClaifJLG0OKVvwfGUPK5M869XHUbWrWsfujji1omQyZeV2NdZG0AhZdbJlLABLWCtHLrQAhloH9G-ccXemK23np6fXMCku>
X-ME-Proxy-Cause: dmFkZTEEh5mFD4s0dbJCm8zTah2l9m1QWCIkPE2/gOdACLBprKQ8XpLiZ6hxkHWwHTZJAJ
    ZD9mVlqU6mc3K5shZtsyB1Xa1ZQvUOTz3Agt1iX8Tc9yFVe7tRzDWz3wzCLuMropbquksv
    H3kh0pQk/lDfx/U9d1IrDXa9ibRMcxAutAjlvEmY4+SZMQ1qZf4zDGL5HSIvNNKatvBlQD
    Z2Aau12hfXu2aSpSHPEoPXsTTOqek+9ljoFgdjBzKZmCewM8fxakGKm/w40FXDxxUgjBSN
    sLaeph48bD55pIT68SWsKr8Vt+9D7mAb+7wYCvIiUbkitPnKzYd8Ilx1SUH4/kIMnU7WaH
    9R5jz6S2to+AAgN51w+ePRUEfcW68R/5dio7Nac/cDfD5WYnwZxN+FCqTsc9RFeizEVONN
    UnkOR+5FRTeu/n5W/KdwXgkiITdVt6JAzdcdkd9Mw8cnTNotdLlVvpm2ePlM2ODbFe3JDG
    9jsK+WvZWWiZgYpqCP2R6nf5Ykc3nRoQzVU4bdQi+6iBH1iO4F6O9kLiY82MjP51udEYL+
    vpiwx3Wb1zeHNgRaxTrCu5Jzbpoq90ig+0ZmKY5MvucqIWQTW7CcawBwJ4Ai7sQ6U7eZ2c
    cKJw4HT6laT+jttfDiBAAiI47Ph5WnGSqoTCShiNT4KFj9nsEtg2f2rdPTZA
X-ME-Proxy: <xmx:mbClap5oKnYlhtjATPodxsMadIOFU72Z2lizhg_kF6TKigsUNdmEiw>
    <xmx:mbClat8VEKDDUZhBZ_jqOmqB7l6sA5B1xZ6z22lcvbCTw2DaWdg_Dg>
    <xmx:mbClaoLL3S-yogZFWv5frPouPtaTGFylQvfyE2KLaIz-F5EMTcoUOw>
    <xmx:mbClaogmLchs3i5l0VPNQL36mn478R2Tr_Xx7RsS4kVjPdY-qImXKA>
    <xmx:mrClanzsWDZw7r5acfCGZRn0kF7ZP48qc2vYoiIjMiYyBtYbztldaD9v>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 12 Sep 2026 16:05:43 -0400 (EDT)
Message-ID: <f4e2b1b8-d16c-4603-b510-90bf0c20807d@pobox.com>
Date: Sat, 12 Sep 2026 13:05:41 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 0000/1191] 6.1.188-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260912065548.086904252@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/11/26 11:45 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.188 release.
> There are 1191 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 14 Sep 2026 06:54:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.188-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on an amd64 laptop (Lenovo ThinkPad T14 Gen 1). Working well,
no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
