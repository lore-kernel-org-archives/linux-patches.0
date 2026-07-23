Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEBAC2BF3D7
	for <patches@lists.linux.dev>; Thu, 23 Jul 2026 02:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784772268; cv=none; b=Bx4WhUSh5EYU+cs9NjTv/Sa/bQu+vS4Jfi8IpSUQNdYqvcLN1oqZB+1hG5M6/H3aunWz+W2X2aSMMAMfoqLLcIL9XFbjjo88UrvmolgzYOC36QvzxV8ozPzMNwQe1N3CCqK6qNpa03YNIWEjKEPIf4Omr/8M1orZK2LGCVbdooA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784772268; c=relaxed/simple;
	bh=lm7pqDpzvFfyg1s7YLBbVdnbQsuoo47AEMv/t04zjFE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p39ZCXzTrxheowdFMWJS2ppBWLY3YYQN839RHhoZ0JJkzpICs+pcQqXxAYF7IzQ2i+jLFOvvck3UKogulHhEIc30ga13H+vRN6bIP27mx9+kj6a1NvO+6MoefhcePppO9EA4Ua/kLXPoFURMKOTqImm33DOCD8J7MoX5EHDHeIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=VrBudizQ; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=JsnAHB1K; arc=none smtp.client-ip=202.12.124.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="VrBudizQ";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="JsnAHB1K"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id CE4437A0090;
	Wed, 22 Jul 2026 22:04:24 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-01.internal (MEProxy); Wed, 22 Jul 2026 22:04:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1784772264;
	 x=1784858664; bh=KUsfHdOnHHU+g7Qcb8Daqto0SnCgo0E1b9OWMr2dmlc=; b=
	VrBudizQzVdPvaJQYCYq5w03XFBYUz7uyYUanAzC5yT0XFh2QKtM9Rcd/C3ON3m9
	g77ed1H1rapRle+VEXnfc65S1bko9DkDRIdU9R+bCVCbp9t92GekPQV5BIipUIxu
	3TLlTskqT9IJwXPtjwNUGO1lYCyiJTt0rzjipkB5SCfrCv3XiJQ/wqiBq0dA11gg
	5KEXEJTnbYoP80L+uGJ0i2HJ8JHYgCBlwIOPsiZWLLnGtFfCc5gMCxH53JH3j+DC
	zkpc5zD5J2tUxns/EZRJaJi4WA8BT6UkEkBmRndTs/wbgeXQx6BI0bSb6ICTB8ja
	iEtgnBt5tHa2OVGQpo+fHg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1784772264; x=
	1784858664; bh=KUsfHdOnHHU+g7Qcb8Daqto0SnCgo0E1b9OWMr2dmlc=; b=J
	snAHB1Khm2yuLB8yWQoIK4zefMgoxAl9XQvF9qY3arypAYOw5Ga9rdilrbNAsNxj
	5wAZepbmZ4G226u0XzDhqK6e8NFoXbi7/e3mjsqC4x0IizSjZWMx7uw39Pv9Pa9T
	c9GWNPbeDfSkEdJq3FMoclZQ2Z6FBkCz2QFOOxY0Nohub5TnAI+3Veeq2tbBipbm
	d7xIXADZOhB+qCb0S/RxeCMCoLEU35e9g36ihVoT6EIJ5FA0x3xfUC2gl7BdYlZ8
	bwvCVR4lJLmQREBYfCLaiAk/xQOG5iPLEe1UQChzZRVm/bh1IQQsdUhzZytkOg5n
	RtUExesKbmu02W6BlWgaA==
X-ME-Sender: <xms:p3ZhaoBA8ov05KkJlE3fcuICbVc1cPCy388ipm3QMFazVUn_u9wurw>
    <xme:p3ZhambFG44YxmJkAN9MkUK5A5qwVfNtAtQLr77Y7uPFzeMkWo5z50y1pRvNFmJuR
    cUGx6Li5gjXrHnfBaEV2P8oiJLflTr6iLzNuyooxfwTzt6AyZn-1vA>
X-ME-Received: <xmr:p3ZhanGXSOz_tjh0cA9nZ--rK-k1-qiqzw-Zsi03_qs9PWmHIFgYCCb45E-blQRztzUXIUtex5oGG8w0A5K4tr1OkvoN-4rx>
X-ME-Proxy-Cause: dmFkZTFNYo0cc0wbd60k3E0GhGdpjEoEBkThJ+GzyaI+89TdiLMWUaHrBaVvXdvl2CYAmb
    g4vJ2gCtvGfygUW1zrIDTz9oA7MBjhUPYEVq1S8FA5uzFFX8jAiVHSumDeG0KLOZgERwOw
    NpturrlWdTIjA3gPCVLLbOpslZt50jrMhXCnqmXU1wT6MbPCnAciWfbvB5r+LzgMLDimsT
    Wtb8VdiJBQ2aaX+mhN+N7Iy2Vq+PpVZB7xZete5xmdd1PtJihDrTrkoGrNf0HCFkajuevK
    P1bsPr5wZ8tAwMJgIH46UbZHdY90aUmb3XX/oUwALl5XaQZxHLFySMXCMS7BTo6b+fxgJu
    HqOqj9NvYcA4edn4XfIe5xBFtgt5dW6Awe2Cyiisbc8G0P1r5RMyAvMaholLGmIF3x5V/n
    hg31MQQ5ehUHWK9OTRJOuh4zUR49QZSiJcUiJrTeXCO4MmyQyrm7xkN1h3h07VmnsA4CUa
    7z6FMjdnnYQuTigzB1RCjLXVvaHRJ4lGLhvd1qzrNxMWX3WWutbWy8Xx0atuY4Bl0jZoY8
    7AsLcV1HfhWFCqHAfdmxChpVkfRZEdM327C9eD/PmIcBHaVt6YRZxamyHM1wjBfBKJKz5v
    AoejQIVe8HdFppnsLrL+5jN1DFT90JBNfT/jzU1xcW88ICfLNRs0xdb1MQyA
X-ME-Proxy: <xmx:p3ZhaivrlsDwB42qJo3nkQfkho1j8s-qZ5yoAQnyN-aahzDH08bGTg>
    <xmx:p3ZhalJ8mijk4m1d-0FGmWhc1sRQxGxmcBB4eN8RRfDfFT6rklNZqw>
    <xmx:p3ZhaoMxbI185JZBhUTA-vi32U9SdUE_OaZSkvWRFFtpnG1wTLKmhQ>
    <xmx:p3ZhalboGrQoN9gtBJc2vDWyU5QHhVQnx2elovUaQ0JxylzdjZDy5g>
    <xmx:qHZhaj3LsGFDwx7G3lRPIYRpzRoKVRoIxfjCP-faZipXRqrWqlo21ekt>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 22 Jul 2026 22:04:21 -0400 (EDT)
Message-ID: <9a9c873f-a4d0-4ed5-894f-296de134e9ad@pobox.com>
Date: Wed, 22 Jul 2026 19:04:19 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/812] 5.15.212-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260722142759.100285390@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260722142759.100285390@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/22/26 7:30 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.212 release.
> There are 812 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 24 Jul 2026 14:26:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.212-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on 2 amd64 laptops, an Apple MacBook Air 13" 2017 and a Lenovo
ThinkPad T14 Gen 1. Working well, no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
