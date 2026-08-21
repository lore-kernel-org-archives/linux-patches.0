Received: from fhigh-a8-smtp.messagingengine.com (fhigh-a8-smtp.messagingengine.com [103.168.172.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12083126B2
	for <patches@lists.linux.dev>; Fri, 21 Aug 2026 02:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787279311; cv=none; b=tmvQTBilwXZViMejGP092kMYHeoAUY0c9oP9DYal20fD+mMD++FcJuvKB/7wWDRaY5WDnPlaMVyOAQm4+J63xiyFTRqds/XGIKien+A/k8tsM2WQ1Y30oSlCCo/7lrZgGvVAGMO67kdE7joVnReLzgoLWDArsfkFfk9ZNBCvO1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787279311; c=relaxed/simple;
	bh=uVbTszhy/sicK/W0rN/nh1U0aZ2Y9QoDoUjpvmj0X1c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KC6C0YbEv9fGAaUaxZ47RiKH/sGz7FxlmPZw8Xs2tYHMEk5Ccgbj2wjWXeNyz0iEhe57fRG0U2/qAmJsNCDfqy9XD7xfeCwcyHg7VJ/iIE8PycdeihQkXZ4OEDxUKYotj0Qp8Q3qKRnPa1fcq+T4pATPsLyMAT6QoZr8SMw+sJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=B/cAuSvW; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=E2aypVeU; arc=none smtp.client-ip=103.168.172.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="B/cAuSvW";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="E2aypVeU"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.phl.internal (Postfix) with ESMTP id BEDAF14001BE;
	Thu, 20 Aug 2026 22:28:28 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-03.internal (MEProxy); Thu, 20 Aug 2026 22:28:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1787279308;
	 x=1787365708; bh=GYMlclfuemkvAEFbiHuln3ygQZ/s06pz/qvWBLeBhvM=; b=
	B/cAuSvW+lGzaIZRKg7Ra+Y7OmWEVHuB+hmNkCB09ZOmNmid811JMgkYoFkA5IUo
	dUvr/oDSXeY54+oG2I6zYGTqIlKiL5pk4tv5B5hecLRzZjhxrVVH033xmEI5YYy9
	VlqiGExsr3idcuvBn8SgooTCcnTfjfZfx01/zFWAaz0l7Axyshk7uGDFPyEiFw0O
	5eGgO3q0BwBVYvOHwNBg5TPk9hu/y/w3H4ki+AhL0l/Z/YWvXVk9NsIYt0dBU3Z+
	y09j+bScrPLArtYh1c6syigA7qEY9cuQkLEi72fC73AZI+n/5fCJi/DWaIEAv9+g
	7l5GXel5eo2RUqsOartGiQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1787279308; x=
	1787365708; bh=GYMlclfuemkvAEFbiHuln3ygQZ/s06pz/qvWBLeBhvM=; b=E
	2aypVeU8BsMceR8B62UEi84rfbbHBBKI67zF0SDXLWFjgYMQ36AsFzML5EBQju2q
	5JMQa4AfuHKbSs3wTIC3NzkUvYWH/DTLV8kmBvh+RGDEZxpC/5UMmeCfMLfSVNDk
	E6v3jvqfc10hD5LZjcsTxdME4mPXsrABiTQL4uIeHGdx2V1CtxZE5HlvrhKDMOyF
	KD3rgXsIRoWDIIqeSaKoOGotyav+8TSbn2QtWXiV51Fa3crrD639xIdo88ROaNgm
	+9I7+nlUYCGRCMK0axqdtVgMDUiiVaLwOYM+QPv9SX5ACmSTP/7l6X9gzJ6KXzZV
	PTQc9DI3G6UsoR4erKS/Q==
X-ME-Sender: <xms:zLeHalpPKo804Ln9unrACB_ywXj29IawWRfcLwC3d00c0cxa4EmcYQ>
    <xme:zLeHajj0SQfuVf-yiXIKeT4n9xwULxtnyQpJZZHtCSl6aB7QeibYHl4eUcNXaA75Q
    dgmmTIzKhizpkPycbzm8b0ZB9tL97XFdCI5XVLLHH1hAsL_9Ja8NGE>
X-ME-Received: <xmr:zLeHatsym0iNx9HRkDxF8tdrig1xAFtwhg4H4qyPtRwTsxQ22Ip3BsD2wAkcJ-kISqS7rCD9jUwPfP7sgDiSKzx15uzeUh89>
X-ME-Proxy-Cause: dmFkZTEcTfs7ETc3YcRCSWPc8bvUFI/O9x3PyeIqu1VN/NDnn2SuW6cSjLcvV5Xd/6f7V/
    x3t5GA+oe/cYmCwkNY6xwH9c9JWT6ULWnl8uL7Aq7JmLnAxTqY5W7Xhf8tzhLAO5iHK5De
    MT37T2P9s5KB20lEcYLsBJb+JlU9VPG2PwxhpKQYOadfgWzSxdfTBFZKKP8eXi1kPaplkA
    81iM99KQg4877ENqNNKvS+QbhNbM7FLKvUYaYDhhNhXykXLfTVJ9q7JQtQDu6cJwc2LZCS
    k/GjKzdc/VRVXxo7/sVa/lJmzNSwFcMHBrvjwtYWbhCg++N1w9ObgiPpVAsptIcOP9DIdy
    GWqaCEVH5ECTNrD/JCwPgVXbcFS10aOLiAq2h7mb4UqXeA2BD+OHmJWKpqCAOBEtxfRxfH
    at+gVWjWgCsOWYCM/YyiIYuP8QtnMh4g/lR8J8CR0xZpOt/0fsh7rdzX5o0uNmcZ9hjiUl
    GILjSv1FhqZ8b3JDBhbJJPGdM3AbsfsBI3opxQoSfAzrXi0lZ6vgezoHeO4aegDB+3e3VQ
    uMqGxfVimf/6kBYC39oLNWufHdVivmmI3zfWPdyJgwTFx7umLc1dzgV0V6ttsfBAa2vlG3
    2Cpz7G/4tS/sEORtV/UNgRBsBkWDilLNjCHx0ZY3kREt3JBLDuVSkQODthkg
X-ME-Proxy: <xmx:zLeHak1THHnuWzXS-5OcPeQN530uCH91Kb6E1CIJtIw5roeM2HY0LA>
    <xmx:zLeHasxeThBkeGFbAR61nG3gie1FkgboNePEL_x5wxvW3f7DEDE1lA>
    <xmx:zLeHanU79WbO3hg3GD9bNuJFAaCN5KIuccVseVxahWFA04XCOv9gKA>
    <xmx:zLeHamCQe3l1lGqNfb7x4ggnaNL8zPLlIJEuwhh2AuSNGN1LmSiNkg>
    <xmx:zLeHajQdUOn6OMSQXi4EYjVkSSxu6p903rEBzaBM2gNOlwyNAsATbp43>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 20 Aug 2026 22:28:25 -0400 (EDT)
Message-ID: <92488daa-2f80-4a35-ad86-3de4c2e06204@pobox.com>
Date: Thu, 20 Aug 2026 19:28:23 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/217] 6.18.46-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260820145237.531699751@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/20/26 7:52 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.46 release.
> There are 217 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 Aug 2026 14:51:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.46-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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
