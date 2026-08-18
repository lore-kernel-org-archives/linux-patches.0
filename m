Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6043B6363
	for <patches@lists.linux.dev>; Tue, 18 Aug 2026 08:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787043474; cv=none; b=pAgfFKzm5dfpeyENNcFXNhwlVdQIyh0wuKm3/nBNnUb2Du0N1LSfiOyhOwdPo4CEtcuLDLidHaZ1eP78Uv/pY2HP61aGeQJ45FYf2EUqtYrN1dJvgCEA62h9s90O6Ya9vcIsf0F0nVn0BMnQB9XLZdVEKyKI28EIB2/Hd6atXBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787043474; c=relaxed/simple;
	bh=lRw4205O5yKga2Ckf1NTCrWvBAJvQz3hIGqoHYvDQaM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KBAQlo3bf8Gm0VHcCIB8K9lvFQU1aQ7Hr1SHMcUW1aq6woK5UD0GVcZ/xZjszNL1VxjWhiVlA+ohhR1/caEt13fRMLUsTgtx8t5PMf1/qAL6k0kyQFJAtLkDN99Ky3p/2IJxVzQX9ReWribRaCMyPI56SykB5HwORpTjvc+KoO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=tVQeS7ZS; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=DRf3K8Bf; arc=none smtp.client-ip=202.12.124.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="tVQeS7ZS";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="DRf3K8Bf"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id EFCC07A0136;
	Tue, 18 Aug 2026 04:57:50 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-04.internal (MEProxy); Tue, 18 Aug 2026 04:57:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1787043470;
	 x=1787129870; bh=4QHVPwSaP+BSKNOdCOXnFarCCuT3uPCQhK+hekZait4=; b=
	tVQeS7ZSzrdhmQQxh7/Xw91XO+PIzchja1tstjSzAZ+nTGr+2KDdBuH6cDsf7FC+
	o/BDYhgbyHqYhPgtT4HOh8qWKf9ku8oy/67cGRNu50dmxbGUC2fS2gHgn958bdU4
	dCleebPRP0xO6G/WNrZ1nZbOWMnSkTjxq69VrGmFYtFXVBAkw1vXjOKHxelXc86Z
	WRs8pN5ty3+NxwXJ2EiYOR8VqA6BUFl6pen6n2HMXV0tnzP7KSQ0ss3ib1vYU7fB
	N9vYYQY7Flmx/fuvQ2q5o0uhdPZZM1usYkV3iBzSox0Y8c059k1WnHt80SOfXiRI
	sc0H4jPqpqmdBXtcnFA4DQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1787043470; x=
	1787129870; bh=4QHVPwSaP+BSKNOdCOXnFarCCuT3uPCQhK+hekZait4=; b=D
	Rf3K8BfFyKZ9uq/Uu60OpIPYm5KpPgq7wrnxS4YB/Kc+LNBSkOnUt5yvGC6H/wYF
	gbN/Ui+RcXOfZpxQWT+bffIvvheUeMO802iogE/HkD7+MjdAhmv2Ky+kgLhzDIS+
	dtLFuBC84z3Wo2di4X0bQvR6UbySEkDPSB8vFGlGPtFKS0MUJSaOSp6KohshAe2a
	Qo6M2X8wb3p8OY4BkYd5c/RdLS8vP0nv1dqf4trB4U9W9JjGlYAjG9tfkUW46w1w
	C0KgaW12FOj5iUQCyI9CxooBBShWM6uS+Rj2eEUXbk3vS0IbXKh8NUDvPk3ZfrmZ
	EddhFTE3kj+CPoMi8sZFQ==
X-ME-Sender: <xms:jR6Eao4F2JzNTvvRSuM76FBWG4c7PT1SdU2v0WZTGSCXEEz8UIrMCg>
    <xme:jR6EalxA4_ux-1ncwFcNrw_nur-N8QbFxQbx1f35IkUcr_mygXFBxkYRowWB7Jj6R
    vGag7W2EG0Sur6C1mm1TXwLm9Gf_rxknTWaUhi6yncqHXBD1otNW6QK>
X-ME-Received: <xmr:jR6Eai_2eJESHwyS2QQ0zUisaF-2HTCp_Q8v6cva1EcTcnA5pX5TiKtT5knCKd-UulCH033WYtg5WljFy9hhOVkSvOK9Dw58>
X-ME-Proxy-Cause: dmFkZTFCWtQROyJjSwtAQQFBNxpATtoXT+rpQ6XmwQyQHGpvWvynlV54NA6Ix+LzVwzJe5
    Bo3cqabJEdPxk+n9SVNAVktTN3pz08HZXo8eCWvo2OQMppgjIF4HaQNuRXnvNVkgs4F+EC
    +wqwON7dgzWbbTx9MkWLDU0ntQ48/B9kkNfMfUX6Vivwd+sW/UhWLJxnW7A0U2hsOf9NLJ
    E74oiwtK58Pw7dzougxY4McWh9YFcmRpsL9LdeFzvvNsF3AWLVCT1FGt5sbT5E+kFPS5AY
    aNvkC6Ylu2omHM0Y4nwy1jfmPYK0tUlHP4Z6FPGMkcGsF0nK9v/jcSdMzS3k3g3yNzEWVI
    KLI4GmhbLxUNqx5Qam5KTYuHEfwpSuulvVorv6nRZ1qmKadad+1BIhlTqv212K5KPeRoTr
    H5ZUkajMxRl2eOl2yaiwpuE1qsxyAcw5zkGmxF+fxlXSjUazEaae1ZXGk9WThcaFMgVcsP
    2I6WnmiSD+eL8hIHa3ldupFXY1qwJ/rIWstSHvPEerj1SHeS2fBlwl38CpBTNM4JXZyz3B
    8IrQphlJf4cSoNvz3vc1AfwiK61fdmFbh6TCbQ/KAolOScwXQ8xvxqyL3aDwkEJJHc2HJh
    /tys4qg2pA4+MlJjvTQiZq8X6rOLGfcn+D1yIn2d25fSS7uFk1cBY046uJbA
X-ME-Proxy: <xmx:jR6EahH2dab_qc0qp9xox-F94-VJGGlamzJvn_-XPVEaWWK3NtI9jQ>
    <xmx:jR6EakDEZOyvEqbA6oy_gQz7QCm6KOogEcYoXT3-XE7n1hbqSRyD8A>
    <xmx:jR6EatmllFrQCx2N0BkADCChcjL2JHNQBTuTSZf29l9lQHLrDGOWvA>
    <xmx:jR6EavS0ITojQmZRKrbDNMFW-mGXd56Gt7YBc3Q1yNzqd1Bl-Yk5Jg>
    <xmx:jh6Eahi_3k0Oo_53yalkZpJ9SE6EutpivLSpW_b03qgko7HqRz9IVG9I>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 18 Aug 2026 04:57:47 -0400 (EDT)
Message-ID: <acaeda35-71d5-4815-a981-1e48f0007819@pobox.com>
Date: Tue, 18 Aug 2026 01:57:46 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 000/271] 7.1.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260817132536.752504388@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/17/26 6:28 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.9 release.
> There are 271 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 Aug 2026 13:23:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on my amd64 DIY home NAS. Working well, no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
