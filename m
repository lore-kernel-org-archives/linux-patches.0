Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E6227AC57
	for <patches@lists.linux.dev>; Thu, 27 Aug 2026 02:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787798409; cv=none; b=IbH+s3gvRfkCuk+6U2juKbt5HVXhq9T2SBEk18RjxS9PdeYrL2/VJcKzxrNIUyr3nunFYr6qqQC6Pd4S/mLd4O8otzx+Ync84JQg7YEtHR9FYcJEalblZoWZWgK0IwvcpnvJiR+jatazJO5nRJSB2x9u7NITRlYYjqcHi//imlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787798409; c=relaxed/simple;
	bh=a6PJlX2eDjqG6eTem80WGbWpxw0WOCwQ48T60BYfyfY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UoVXr/wH2LSMdggb16h7+1EPPuuNuz/zQLXUJQ8oEaSfdd7GjQR4NtNNkQUxXqM8F/cOsEQXRlp6MNEkdUqYV5jIoTiBy1ZxC47ki96DC5cXj9+7FPtI2aYN8Yr7y0X4mFf1GJRYKNocIh1TjjpYC3lrebOXU833fNRQwHbKoUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=YRWCZdp0; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=SNRWVki5; arc=none smtp.client-ip=202.12.124.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="YRWCZdp0";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="SNRWVki5"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.stl.internal (Postfix) with ESMTP id 3B0921D000D0;
	Wed, 26 Aug 2026 22:40:06 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-03.internal (MEProxy); Wed, 26 Aug 2026 22:40:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1787798406;
	 x=1787884806; bh=hWMp3cXukM5aYcw/dN/YYGhsXf9+BYduq0DgOXDKtYU=; b=
	YRWCZdp0YJ4TxwI9X8YehchX3imdHe5sVY13fJLhGd6i3sCQPov9ZNY2FvvxqzB6
	euZkQ1DO0//LNRWQgartBjqXBmjktIj8ndCOF1BGQt9E6CEIp7a63NEEWDlL7A8i
	pwLNdZAHCUdYBNsYJ6CggOcMROfom08i948CyP0fKX/TUvfiRZCFGf8R/ZpezcQm
	NM9ZgfrAZFncByBUMkOBdM4HwEo8MrWQjxMSVo3BgQRD9nRpBTuj1Q4yozFgWTB/
	Ou/ji45wXnPfZBF+Mi+xU4ZL0Nr+k1Gej46LYhCJYJL3JMa71d3t6EOMYNTisOb8
	TgNWqxN+H9SRL1L7pFQ5JA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1787798406; x=
	1787884806; bh=hWMp3cXukM5aYcw/dN/YYGhsXf9+BYduq0DgOXDKtYU=; b=S
	NRWVki50UnPJ7mNgDQPxe/8km7Ahc3E/c6WlF5VoDYf/GuyNwdicJuIcz5Hk+cmK
	ysuHDtKbaSku7ass3LN9Mn+YggCyndVRuC/zaHHA2YwvEuBG/qIpphEyrtQPQbWh
	Kmg0XVcfKEbPquTqDK+3QxaILPyLTNokIK6mLtU5iKq0v4TA29Lc9UfSByM+zACJ
	gR4uVfm+6DGkVwYo6BkW//buAuIwNbnG+1IQznvH+YiPJ7W2bFKPgqbjbLgpUoKJ
	nogEjkNTEQqDhE6EiwnIymSQuGFVXWNrkH/ovq004ARaSna1zsQX1KLNkSsoGJx7
	W1QOWJ1ptbyqygWliLj6Q==
X-ME-Sender: <xms:haOPasgGxHjENguA8tgCogUhHBFEtwtyta2YiwFbrRMZJAzgthc_gw>
    <xme:haOPag7i8RWRGRtyASeoU5W3vrheF8bg7Sxtr05SZnXpaaC6walbXJTBboEf7IVqk
    GLsppMtiLfew-Z-BQzA26Urcyf1-ZXdPR7RTj654Q0PUGrlFMTm3zM>
X-ME-Received: <xmr:haOPavm6ETtfYUUTTsJShkuL757KoE7aNGeRwZ8zBeowth6xkMo14jgFS350cQqCHJzXeVALpZxqfDKa69iDRCnmzoWz46V->
X-ME-Proxy-Cause: dmFkZTFB/oj+N6i/pB1QH6sVmwIZNNP9xM3v2B0i8HNXDDWrLjkdHN/fNOcO9f13+P+buo
    y3lyLGvEjK+enk5yoB19S2msvURE7st1oi7p+nWxEA7T/whKEKnYo9bVjG2IFyiKwa53Xt
    gCuB8lu3otyFfudhiM9vztRPkVFkT6roqNZqkPdfCDG020fIUJ9K6QPn8vVrDKsiUqkYiM
    ie1VkYgF95DtlNfLjt7iSCkFGp4DQvbE6m406xdtFFtseYiTy1Acc7kA7/k3+wbnTt5D+s
    FUccso02ytCoE6v5jURM2JimKW0WOC++EPvSm6z8Co5I83VNjbqseCaO1l/k+Ppm2lBaO7
    +fnnubVB59ni+OpMtHf9IueQGMNLQiMPlBbn3i9hCjLJUaYWHk3zhiAINvGZy+sGrRo7Ry
    Oce9KbfhLrWSww1X7/tZQ1OCqKAuRM+ZPp/AfSJI3ILJheF70ogyNpzdkOj1+JGGBTobOY
    /aSbQv57ndLYdhPdfin6c/b6V6qWoJwZqyO4yvVu0IZiBYTTUre+FqwMUquYs+Y/wx4HhW
    wrGubNLorde/U1e7Hj8hZBYklxki70oWYuUooEUeyCzLIVgplQ5qbwpZCs56JxRH3Yjcec
    V3zIY3JfTzkOgUj97i1ahS1bD5fy0TOs753fnRNP22D1KEgZE9i4B1fB7BLA
X-ME-Proxy: <xmx:haOPahM8h7MJoT5VNpj40JqcHjKHb_9lABee0Vub8sgv1U_ICT6vUQ>
    <xmx:haOPahpffUeBYIDmGFsiJCHQ-WfX5QrPguCPpzh8LyaBnPeA2Ij5cA>
    <xmx:haOPaqtwJgx66IFQxbuqfchSDFbLhZgqK6XJQBs-1Ftk37P285q1IQ>
    <xmx:haOPal68Bec9ZFd4j4E2NzuLij3-pc_SveDwULhMcvcwb3knHWR2Pg>
    <xmx:hqOParWC3FxdOOUfDnDfplIX5IkuGt_IZdOkkqdlBFTQ_pVm1gbxxbP1>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 26 Aug 2026 22:40:03 -0400 (EDT)
Message-ID: <d478e59a-ddf1-40f3-8cbf-306a9fbad206@pobox.com>
Date: Wed, 26 Aug 2026 19:40:01 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/79] 6.1.185-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260825132541.677185791@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260825132541.677185791@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/25/26 6:25 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.185 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Aug 2026 13:25:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.185-rc1.gz
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
