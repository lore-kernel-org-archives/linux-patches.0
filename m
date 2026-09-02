Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41CD34CFAB
	for <patches@lists.linux.dev>; Wed,  2 Sep 2026 07:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788335645; cv=none; b=MogA/5/uqTdG6Ra3rA6jKk2T567lnXfrp+AAEX+JnQojISSZcqH658b1KNGHO4AciIY/LtnQDgrWcKAn+bWUGkgU9L/UPWlNF/YtPXUfXT400fZX58z92Fm/x3NIjcFXpZ3W4f5/e2VwsAYJ6kkel86AKLFKrlHVFvBzvVfR++Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788335645; c=relaxed/simple;
	bh=h0ZFDLNyQKmMqCI24MP+vrayXKLwsUZ3jLZ7DSrj6w4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nILmPAQbvzenC0XwhakAdO15FSJUuc3RMoF4AYvSnhm1y4ZSGdYeswpOFfPQFud+djz59JA2JhBHR8BhJV3+4lIpyhrxl2htZqeB9APYKUU6sYh9lThHfhX6dWVF4kzyx3PCsB9eO6Ji1r0cWocAbeCZw4cVYI+2+R2QdD8v6E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=HcYMt0/D; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=PiBt0dZu; arc=none smtp.client-ip=103.168.172.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="HcYMt0/D";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="PiBt0dZu"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id 2F9FFEC0074;
	Wed,  2 Sep 2026 03:54:03 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-06.internal (MEProxy); Wed, 02 Sep 2026 03:54:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1788335643;
	 x=1788422043; bh=eu4wew0RHn2kFkFjJ7vxD+kWTFHmY+H0jX6dOS1OFlk=; b=
	HcYMt0/Dv5u/WfkGHM8x3pD9YWVbAF14v36LC6gJeNQSCfbzxM5IQSqgsUlpXh/z
	AjKtIQ+MM2h3GrlX26fmZtzkHltTKCGP36MrxiW7tS9jfxAWNXWx6oolBlZqO7A0
	6hnew0EBqSmN6xwBsIJ3R7jNcazIKFYxYMdm38QgM23WEfVFuTKi+c7gKdberF8e
	CfOJMYjISUbcwlafJqjU9+SGyPthZNIZjxyQgxk1MdJasdCb5IXih5Y0DgyaVwCa
	rY1cHDKj+2Osi3YJDCk7S4nvwZwLO7wCx6M/tUMqUQzfXbET/NGt5D/cqqacJ0Ed
	3vlNloIL863TCjZ4iRopkg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1788335643; x=
	1788422043; bh=eu4wew0RHn2kFkFjJ7vxD+kWTFHmY+H0jX6dOS1OFlk=; b=P
	iBt0dZu/aNOrFvyxtVSqmvHTvwqKom6+wrKi6tZAQJygaiVGk+E3Ev5KIKThVPSw
	+worGUgqhHwb47bDZ+t3DICXaHm1f++JjG66G3u2BgElQQQQF6Dl7MysDmsTA9gp
	nne1DH8VjDr4wG2f1vqYhchC6fXvH8vYH69EJN0y5ZXP+xgQ3CmOcmAQhCPD6qXv
	VKZpBG/vfYLuI+NHMQQrnWRpl2HGlIgqaMgv2+dV/h3DjB/+h9g+Tf+wL1ga0Oda
	FoRScAiQDhWpwQtmVjoinHDwjxZKOCumaXNnxO36SJU1PLO0rs7vA9dqnmy1km4D
	2q6dkQh7iwmUi7Vz1DHFg==
X-ME-Sender: <xms:GtaXah4zjntaUYbQJKT8kHzQ37kVnROfGxQ1xdW7u8SjbhtUIWlceQ>
    <xme:GtaXaqwGJF2a8Loovf_tsKk91RTvVMLRXTfgbj3Y0FJQeZ7OcU5vrO3eQRkRVMg6E
    P1q4zuK-0eEHKojM2lTcoijsD2uYz78qW-0_t9ga28TiDkc_RdimM1K>
X-ME-Received: <xmr:GtaXaj9G-V2EWkAj8tPrjkBnLtFHyWpcP6xWY5oUHk2qYqKPB0pR6Xye585WxRBgosMRA0z3NUZExwwsPxQWwc-T89ks7qu8>
X-ME-Proxy-Cause: dmFkZTFt64D2s3ZYUHlOw6VXBIqy+HoU8imDm2gWVxcVAGyAyIxblZ9Bqnw3y+88b62TBY
    PzaQEexsIcVDJRSHrT4DXTV/xSCWMEz+8nbgCkqy5tIlEQoJM/T9YZPmm2lBi6gAMo1JdL
    qFZkPDwGuJ82ipNgDyOz3F7PzESlLHzIew84UW3oEv8zBXoLxlKgDid35YyJXeHQJ5ZsX8
    zUL+yHdD5u5HHqvt+AgHwFEPNq9UZnnJTB2lZlOWi49AgVjAM19gEVX9/M4hbguseWYIAj
    +MLXYOJHrYFd78m6NxqR0ZH/Eq6xlmUeeYB2y9A0YH482PlRowHdBYl4uI+r9Vs/B0UiH6
    tczqDqFOhlNo6jIow6ZPVs3ake1+DD+G06ORo5byngtKl76gGvsTfD8PL+7ms8gzuh94h8
    xWpJmxqWquICha3Du/DybyLQby5n0SLgksU+X9mWS38D5ttMTQIpRjNL0dklJw0meosJ/W
    642OZ1q1QUzqWHK+m2wca3vvxTCMsyALGYvw+L8oNbESajoL1cd/AMOksGtYiCDIvadSuc
    jfifWBXQGApQbbMCzMPEmhxxELLtYAbwvCiPZwdl0L0wJRhDFTNy3kWljgR6HK5KwyTfrf
    n2w/HQxrECC2orE4MYAYR3zA9LKvHAgjTWaqd6e/d/RZtddhjy2bQzSsV22A
X-ME-Proxy: <xmx:GtaXauFsxq_SQAE8RKswaT9yvMxahvlQ7f6wXggm07cZ3dGlwnR8Bw>
    <xmx:GtaXatA6JhYqJ8rZezFyxJmWYfi2atgnqgQb2-Fnyu04vJH7had2xg>
    <xmx:GtaXaimBOR9SahpsSdmkBlIcgvvRA1Y7PqXLtfNCcFKojljjXDEE0A>
    <xmx:GtaXagT2HJ-m-TPcuYTNotHpuwoe_hcYX8swJwOt6FGs4SyAl1ZwXQ>
    <xmx:G9aXaqvNCfoRJS0b3LwPXfPk1BbURDKopZaLQBweytDvCkpZYBQPrAPs>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 2 Sep 2026 03:54:00 -0400 (EDT)
Message-ID: <c868e28b-42b5-4b6d-ad6b-1af65848c4eb@pobox.com>
Date: Wed, 2 Sep 2026 00:53:58 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 00/71] 7.2.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260831133359.055927882@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260831133359.055927882@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/31/26 6:33 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.3 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Sep 2026 13:32:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on 3 amd64 systems (my DIY home NAS, my Lenovo ThinkPad T14 Gen
1, and an Apple MacBook Air 13" 2017). Working well, no regressions
observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
