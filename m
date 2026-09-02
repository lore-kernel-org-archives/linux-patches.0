Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D0635E94E
	for <patches@lists.linux.dev>; Wed,  2 Sep 2026 02:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788316106; cv=none; b=OhozAqzwbvM0TGBvc682uwYYAFaRZmHKKGI/hMGHBXfanYcqXgjtkzY2atUsTIyqRbEqTFH+01UTGG40IyBWZ9yba571xHJ0aVG8Dwc2ZxDhRbFcd4DRgDoD6aDbXoQsTeM9FTsuZbkukrbqkOikjQGGQUmP/JTvz9epudo2UZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788316106; c=relaxed/simple;
	bh=R+qiKdqRJ5cNFgVlSrg8alIQKP3U7exe90LEPSSzFzo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c51am1QGlLrfxJcYhlwysPlhOBbq6hLpoEOVHJ3RpEoiK4Qgv61JlaZ49T9pM38Az2MNvKrgUhXj/bkzH0dpae8HChB5Uaj3MFapHdQ2YcQWaVuBhU4WnAhh86dfNfLcoPAcjJTUbXrS1dJO75D0lWaJL8HTV60AHj9nc3CsuLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=WTXwYvPf; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=h5GQgMGa; arc=none smtp.client-ip=202.12.124.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="WTXwYvPf";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="h5GQgMGa"
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfout.stl.internal (Postfix) with ESMTP id DA9961D000E5;
	Tue,  1 Sep 2026 22:28:22 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-11.internal (MEProxy); Tue, 01 Sep 2026 22:28:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1788316102;
	 x=1788402502; bh=EI7ZcjlIisAiLrgFRMX5lSZYM59HzE1LJ1ifaxB1Pvw=; b=
	WTXwYvPfSbZttL3YpbRAcEst22UICkp5+tamoV7C65FgdP0xAHIeaXaMqrYoIcpq
	sjAIbU7Ek/DiLVPP4I29MU8BY0vOHK6N04FmD8mx+jnRN3NWn2da9uIZAQ4nRS+y
	GUaPrH3M+36pS8urYQgKTBvbi8Z8yTpcj6bKfEaD3Lm9TlNN18vZgPfWKsd7w1ry
	YHMCmUOnfhmbwKoiB5WhUJIw3jpgKnLwrR+tJtSVUzuQMHEq9VbHVswgpFqxAbTa
	OvcOUj5GnEMY8el/VlZOJbKHF6ctkAJaSIMMBkIMIzlh+2n0wW9SPVDFaqYeqRRo
	GiCInb91agOtW07u+wDflQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1788316102; x=
	1788402502; bh=EI7ZcjlIisAiLrgFRMX5lSZYM59HzE1LJ1ifaxB1Pvw=; b=h
	5GQgMGaCYtM78h4zoq1yIZqQkMG7r8uEjLnhh7e+4lvK8U6foyHyIrH/gMTEvP9D
	Q5Tp3rZFpOeZEc8pqchCMsqeWddyk7omw1oASlWUXbi6hr0q8zdGgfr+wBGnR0As
	rhRm2b/uo/n3hiyJxIjjRh7zJlC6HU3KsVCN9mrbgD7dYIcTpp7m2b6OQbXawUhe
	TvDskgHcjMp9e73aZvSn6vA9RbT7C8ixJzhmJkxR41raqW066yTJiYBfyUuc6iDa
	6J7dKrCWQ0rHfsIKQ6Zf2Dp58QD8kbBy0vyWL+MWnN+awqvKhqVzWjsFmOfeGvqb
	pyVF61AcrvODeuyTtL34Q==
X-ME-Sender: <xms:xomXalZu7kfGD0ZeyaE7-wpsqGQMYcgibxmNis7eWLzV_H3BZRSxjg>
    <xme:xomXaqElAizhp6MxlHLUiS_EPA-f1oo6pWOz542CRVF_Z5QFo5EBRSJN8JaQH_v2t
    IHgFSWI5LIB7z5OvqJSIC5Lu4w7PHFrXbbU6p9K4zfFTFhBf9CZT50T>
X-ME-Received: <xmr:xomXapuVl0xY5fO2Ugd_8KuBEZa0zQBr2eTHch9JUsVPCAlYoORhxVYNDK52uIwpDOyoC3wLOVo3VYBWF1C_oP9IjtRwCbac>
X-ME-Proxy-Cause: dmFkZTGZIqB7RdmiXnTnJhk1iAJ+kQyg0bM+2g5pmHyvo6+Z8YDZ4TR6To6F4BY5LTVYmt
    N+RcMrM2OnX1r43p+az7tgT+Xz7ZPEF/8I7Oh5TSjN3lOb+LV6x6RMf8sKoDT4DUvTLdCp
    Gu697CnpH7gRI6X5zwpUT7yyk4L8xchG3nXlrZjCLOPJTEYWOxISTLMdLpqUiJ44w87T/S
    f+TqQoZD372nDckAArA1FRM1iGMEW6sI7Ku7fqSIaZXF6ZJjO/sQ+xX7qUJXCElIvuwHM0
    HvQJ4G1xC11MfW3CsYqj22I7hic2xi7bg+lxuILhJy5AS+9wBDU43GURjhDdciB4aOAiaW
    CDKfERb+NRA7SGFx3+WVdh82PUMnh6kbdQJWbWfmLheXVvsqqIB4WaxOWnAKY2dohVHcOE
    RP8S1KHonSWvb3UB9Cqn0Tnuz4O9SAItpVbH4LN7IBowhMNHtUfjJTt4pU50bXJrhTvZxi
    6zNEh/rBtLJM1fw1FVJUjSxmdj51+ZrBfUr86sa1cfZop5ryYp1e0DZX4XguCqY169RrLO
    3In4kFpDHPNdsFXvAkf1H4c1VKQ6ICA2i074Y8jJk0CYcS3qucjp+yxJuTDffGCRo8+Eap
    etsHB8gs3e++nmmCqHhZdNn9wqlrQAkRnWO/j+BI5x8MA84kWNb3RMQxu/+Q
X-ME-Proxy: <xmx:xomXagKuQ535n4Pb0ecZa4yVLgVIh_kVioX-GGJEqhURHTvhA-XrSQ>
    <xmx:xomXanN5WqozJWnkJDNaomNdrxdne0AvpEKt36aPLeC_0g-bK2dPEQ>
    <xmx:xomXaoYpcYvU01z5upBpTE-ECMX96-Iy6rOJ-jCFAKqMOrNy_6u4Rg>
    <xmx:xomXajzGE1AKCI5A_psZmRJJt3kocyP-_iJgvYt8ALoJNmEiGhWq1Q>
    <xmx:xomXanIJAKlfmEf1zX08L4gL_3CrxajlPTYdTbwHmlfTvtiBnIAqo_0s>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 1 Sep 2026 22:28:19 -0400 (EDT)
Message-ID: <eab24620-7ad3-491f-a618-3dfc20f5a189@pobox.com>
Date: Tue, 1 Sep 2026 19:28:18 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/99] 6.12.108-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260831133359.740409777@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260831133359.740409777@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/31/26 6:33 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.108 release.
> There are 99 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Sep 2026 13:32:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.108-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
