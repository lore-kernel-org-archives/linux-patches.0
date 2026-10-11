Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A28F1346777
	for <patches@lists.linux.dev>; Sun, 11 Oct 2026 08:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791707137; cv=none; b=MfL6JJ+eE8m1d0OYMTQ97Ljl0CXGLdaJ3vC0cJRg6THZFI8b/8ng6i2du4DlvCSH3qgtP4cSuTBHWVdRTchdBJCf3U+MN6TSl3xCx7PUwYcZbH13EKKHRM+T/OcUhGYtusLfYBdvT+bP4Zp4pTYz6GnNM2oP2dvXeN/3obRmgiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791707137; c=relaxed/simple;
	bh=kScpCZUfbiwUBCfY1/4QhXc1j3HkTC2SpEXoET/sHcw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TFoeCFoW6tNTU5uwcEVAFbdcQwIYnhETndEf4baD4EE5Zh4VLixYzN7mOw7vmFfkDBOVXelhGF6ntlKaKD1jC1/kVnCacieyDZtNBUSkhVAXgVgaqxxhvwNmCmExtocZKPZ+fMPDq6WLh4B3WPDUSw9s6m6/G59c6H0DDMmSvnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=m9GvCQes; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=WvdmI4V4; arc=none smtp.client-ip=103.168.172.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="m9GvCQes";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="WvdmI4V4"
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfout.phl.internal (Postfix) with ESMTP id CD3E4EC0A8A
	for <patches@lists.linux.dev>; Sun, 11 Oct 2026 04:25:34 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-09.internal (MEProxy); Sun, 11 Oct 2026 04:25:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1791707134;
	 x=1791793534; bh=LLtGKMrhKvPJ9XjJTi6BFyiUya1GkfxLEGv2nPtdLf0=; b=
	m9GvCQes0K3+D2VAJrOiLgljwFAXLN7y77l8iINntKZhojIXRRYCzW/5CuaMufMy
	7oSdK97cYwuWD7XSj+R3WQCUjFH0+EEYrITzFfzCHiWTsMNHFrT7Dcohn/ubs1qX
	b9gWKY9gCauGeExMM41NiqLkeAyNYHU9YBR3EZBrSQPfwdXReweMFdzEpV8cKBFV
	tbdq/lRw8aQrCrdaSTR+Xb30yCkUr8Q8EPPPXBOWpkyvpz4DYNG+D4GT2ePnrj7w
	Y0lLNT/MYvvrE30NrDR8Ummv0Ry64Ufpl07U7yNGYL7I04FWjHAmPaDzhzJSH+8v
	uAulQp3Z18ZS0EvA9dKPpg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1791707134; x=
	1791793534; bh=LLtGKMrhKvPJ9XjJTi6BFyiUya1GkfxLEGv2nPtdLf0=; b=W
	vdmI4V4MOawQQ5mtLM/t4Dib4j6C76B0jVPYr4P46sVJ88ryDi7c8cCJAAg3fBBi
	7BZ+DDGT6Lirz2Q1I88eLHLqz2Mgd8vD2n9ShyEQqVoImn6ECYLI6lPtr9VAZl+o
	jCbNrLBM5t1gD54S+Hzk4AmaSmhvX0v0ronri/AB118tsfgCaRNOtgmOgi/s8wni
	9SKFoAk3vRfUij2mVPwA7LyLDW4Q8m+R+gIHVJr4ZTEP2vfH97nGVlCTNSm7zW/e
	2U6YkjfV4MAIT+DZoi/2Lir09IWDHwfYNLfYcp+nozHTj1fXQHs2SaAXkd6rlc3k
	mnKVQJjQSngxzcxwfbPMA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=sign d=pobox.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1791707134; d=pobox.com;
	mf=PGJhcnJ5bkBwb2JveC5jb20+;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm1:rsa-sha256:EZ9UOE67YSB1d59OFUlbAh0AlA5vCWPhoXaiLM/bvjRcl1k
	S6d5oulR/mWOCxIZHTGte2bAjMeqP8WjiTXimemYaM5/Qdw51AuKM32qcsl1xhH1
	iY/PRoi2TmqLvocZ+p/mtuqkyLjtilfWs75M3Nh+FakGL13NT2ecTXA29y+AxHpR
	FB/pYDw8dFCyR60ZrvHCKxQAe+MqXveayKmTd88A7e3IowZR8ogYxm0kwl2npJTp
	+xo85PEV38tyuBmNdo0/OHIbKg7xeT48dB7S9TaRZW8fsm9Wa0ifvgKb+MBEXTBM
	EBrHaZAjQolbdnA/1xvzdiWv5brGeD1vYsviv6g==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:UJXWda4JDQgsQCsKK+DUYbwUhN5jrbonyH/hgjgH89E=:kScpCZUfbiwUBCfY1/4QhXc1j3HkTC2SpEXoET/sHcw=;
X-ME-Sender: <xms:_UfLaiTFc1WVMa6T8l7WaOOzSp0r25cxCmH7FEDhrmDRbGNYcIp1UA>
    <xme:_UfLajqXnDYjMUX6wV_gvPO4EPB-64dL8waiK2YsE-TTL9yr5SKZCg4RiDGH5uaum
    WA6bOwLfegvGUK8QnJH6shhrv_6AwKwivV9jchaF52US8hS-wsdVv1qwA>
X-ME-Received: <xmr:_UfLarVmFq-6UoA3PNTTL-gsMEFqNYTCf1MoMFj-C9yhpamz_nc5BsoU_U15OWiHtYLKFf_2m7jdGu7c1aOygUrXl-vNXURa>
X-ME-Proxy-Cause: dmFkZTGIpgsSKCJlcXUNrfhQ+rOxRjqphKb+CKmUmfpqVrmmf+En8wMSywkaPXMTn8INhK
    kU6j9n8EsW9STbEz2liYD2xeGXc4HNf+WhiUxXoa2GtAE/efkNC8+D4x3DRFafeR7i+YzE
    XpSTO+f5oiMpHg9xAWurhjt9ycNlApP7pnwuEIcK/ZpYgdlagip/pXrar1axYNJ8DXXqOZ
    0vSOVzY4gJtpoDC3fhRvQH78AcbISUWzKarDj0DTnGFnwAT9j3ywp34O14MQ0wSyxmPKxj
    yCtxxzus65xp0grVOrsazpc7kBidm2+pTlSliBgCSCBZOfFbo8pQD9bK+qjH8O0srD0bkR
    WifMS4NVEnAz/RmbE//7jjCl7ZkBE9Zml0FKj4stCVPr3xbw+xA6fpnQsDeROc2E10ZnyH
    w7tJFqlIKBfdDFvF4mFy526q06qhDTG/piibSbakG1SDdzEJy1CZv4OjeHXmIt8oU1iPKv
    5t6b8uvHqX9o304cZU96cr2hNesO5uF+1TyDon4WAbHOvVrHLFAlDN9kHIiVH4GlUAZr1/
    QfGur6C5ePZtPc78HMPi+Q1ery6ZgmHPWGv7Vitt8LYTaBqFwBwRBqOJwNwdbNpa/Zpsll
    12gU0o8u0UZP4xwvngiyn+NSka4xuG2cy1yqVvwLWlcG/9I3dNxJdkaJAmtw
X-ME-Proxy: <xmx:_UfLah9DH6X6RIzaJ69BFSmivrBxezBgX4RXB0hLya8km3K5cnvBPA>
    <xmx:_kfLajYnnaL4hX50Q3ZEniiCccUg2lNDzZhetAsb5Sbl9GiitkrzBw>
    <xmx:_kfLapfMRyherokzlQFoOp2FxGhceiM_l_OfhuXtnz5y5QY1ap83ig>
    <xmx:_kfLatrnXz8zlJbuq1HJSRBv1d5I3l3rZgAQQzPAQU-0slcSYyRQ5w>
    <xmx:_kfLalEcTzPsHI1HfCK6k_hUK8WCak6PSSoS_M83ynhQmUWaJMuIWQ-8>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Oct 2026 04:25:31 -0400 (EDT)
Message-ID: <47315427-d8c8-4f60-a0ed-c607ed1d10ea@pobox.com>
Date: Sun, 11 Oct 2026 01:25:30 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 000/428] 7.2.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261009140946.008206689@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/9/26 7:05 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.10 release.
> There are 428 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Oct 2026 14:08:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on 2 amd64 systems and an arm64 virtual machine. Working well,
no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
