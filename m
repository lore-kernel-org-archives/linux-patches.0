Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.156
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795073305;
	b=3ipuYmTzfnsE96YIQfK493/6S4OzsBclCO32UreHBhXtVsyikYkCv428bai000L93z+f
	 nXCaXZoejE37+fYGDeYmvJbFA/AVZx4JIZErHve+yUF/mIP91TKzy0/sMeRn95d8Kp2fZ
	 x0eIBmF/9Q2NFUFGPk364lDCOwPUts9trHr+8dxGefWl1zmoC84ZQL4fXKRBmE0NinXlO
	 FRaHDFfU5T3lf0QfwszKxt1oBg3Hb7V/OHyBtUHv4C0mIcZRGTevlK5efV9J2zNRNH5cx
	 GYfnXMLo/HUY9eERRM7FXhBb68Mi6qtD0zLd3dq1DSLHb0V9cVi2y+m0yD6v9F1N2FQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795073305;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=c9zRiv2p75VzVxjkTYBGQibVdofBxse2+qP1LwW4kTE=;
	b=hMPfQZaKRdQ+lxm4u4I7VHNAXbaa49Fhyef74RvvED7oiYn6WD/y84sF3Wqh9VrbIdOh
	 Z87z0Xo5GbiG9iV7GjSHuTbsfr4Na97g5sOVL9WMt9EXACm9/u4ud3nluANCyoRFBYIt2
	 KHXfKdl8+dZrMZPmjwN4+2mbodbUBPUfnlDatfm9XV5WoyB2n176ksBROIsrsAeMPCoug
	 ucy1zO7do7ko2PhZKwKi8obRXQT3nSFsjE/qqeZ4LYvrq8XcbDYxNS8uEEWPHEIzEosxx
	 Glb9N/vDeP+8EUq15BylYIaQ0ZPlJWwsY3OtmGv8d6v+D6p5PB+BVTK7MNTkXA8Iv1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pobox.com;
	spf=pass smtp.mailfrom=pobox.com;
	dkim=pass header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm2 header.b=TNut+HtW;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=BZ474M7U;
	arc=none smtp.remote-ip=202.12.124.156
Received: from fhigh-b5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3056606A333
	for <patches@lists.linux.dev>; Thu, 19 Nov 2026 07:28:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C3056606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm2 header.b=TNut+HtW;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=BZ474M7U
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 292807A02F6
	for <patches@lists.linux.dev>; Thu, 19 Nov 2026 02:28:24 -0500 (EST)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-06.internal (MEProxy); Thu, 19 Nov 2026 02:28:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1795073303;
	 x=1795159703; bh=c9zRiv2p75VzVxjkTYBGQibVdofBxse2+qP1LwW4kTE=; b=
	TNut+HtW58sxhFK2xbTfhUDg3d5dnIBJIvSuoWpKI2KuqIoY/IBb4dUufUUuTdCp
	PWfOeiqVz7YKkEWnGBULdiYnZiaszoXEAZ/Mu6yWoA7NmxcUJDQ617KaOYmVtSRB
	JDxM8lj9zwDbuvPbe9WuEuPlruGC/NKPDy8+2z5uf5CiL6GZN7bHGSsRtCeCe+sw
	jvRXlPu/ePlGeUSa703C/T0I/Wmq9zZ1MlXPYbapeTbU0h86gS9x6N5rDqf3poP+
	AOczUus+3s5KAylPJ3wr1il2kZXxwV5o5ebGKMGRelbj6rHC1U1z99eSlkGdEfTr
	4F9bh81wD+fuyhN6WHIBAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1795073303; x=
	1795159703; bh=c9zRiv2p75VzVxjkTYBGQibVdofBxse2+qP1LwW4kTE=; b=B
	Z474M7UusJ/MFXfgf0xMayQnDBsjRdFA78krWR71+E0h8Z5kswbDf69YiOOTORcG
	BOpnf5MlnlsClfhFSRt7L/85jSCDDZiQ9NUIUj32BiKxRmAGklqzNiIkyz6TRcyc
	SZ4Fly7lxypkOujWxFs+3hrC/6wyWi7fTkQVBl0TtgcA8WDBxeZUZULw68JZoGJr
	cNocMiFKY0Obk/haAkXNYVFSqv+dmZLmJ3Q4pY7MktczlUGruhwBMGB4eaHkzJGP
	LOLRldjjfrEhNzRtbWo9XwtoIWpAg2RuwE0CZmm8vRz4S8rxJCw2JnXgiXJhHT8u
	Rg60LcOzkw5K9MyTTEZUQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=pobox.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795073303; d=pobox.com;
	mf=PGJhcnJ5bkBwb2JveC5jb20+;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm2:rsa-sha256:Cf2qt0NmNiRuJlK6mUNl3tIviC67amt+TA0Bj8n1kATydTz
	QPCSR5pcjWR0LHOSOW8xAWbto1Z1lGg5UFbnmuoEJehljon3kOPwi4fOAjcYGJhT
	Ts63eru8dCjX8AFcQIJv+loZ5MoAGI9UHRD3DqojfiknrB0rIsacKRFvYBa2dAxw
	QtnIq82KAT6nyVIf+eNVcoZMifMuyHdUTfl3g5cDZRrq3i8i4hwjPJ9fJU7cMkFA
	WohNVeLUH/CglWKAT+WjitH6tXAP4xgUYtj48yw4M2F1DnsRXoA1ln+F2J+vOUGN
	mgH0Y74Jd+aZLELmiD35/At8x7ZgPwpElDBjG7Q==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:ISW2ubdVqkkdpLKk8nqDlmkIdg925T4kBxLI6BVeHK4=:y88EZY6qnHr8z0InMOaQ6wVzjxMYn/zx3/6WH6ZCsKw=;
X-ME-Sender: <xms:FqX-asyWFpfJjTXr5Lhpwq1WZLyzpTSvoOFL5mOY9cVkgCxaf6xPUQ>
    <xme:FqX-at9jPZU5ABu_TIQ_JfmRV6pJ5xiqM5frG7FQDtjwNzJiFT4n_JP0Bz9rbC6fJ
    7ARN9w2wgLjLkRRfQTm98ZKzIo23xZqv1AuqxrjfcMQpxiSSFzAWG6M>
X-ME-Received: <xmr:FqX-agHK5HnqFmm4k6oumKy3Z-hfcmaQZak63hP4NdWj5e6GDXToXVi_i8TI9ElAwuVYIU0pf4X2vft4Rt89BTm7L2RuaHdM>
X-ME-Proxy-Cause: dmFkZTEgLF9mwwuUZk67tn0MEUFj3LlqJiCxSXoyyhz5+21MIqCXCVwJCrX+0HpMOjc1xn
    F9H1fQX5ZnNvLTxy6/o6FPVY9Whm73s6adVmyne+UI0oGxlIhIduW7JZfj14siz89e0ana
    aIARLUpglK4xj9sLr9cwbOcLy/GwL+LY9dkMVIKvH5pyxtnWTCL0kOLgSamWmJiH1gtgqf
    rAPg6yH6JXRqvBCRSnJJSy3VWFWRpCLHNpBT+XjA8uLdPZbZlnwaPSq9L4fg2oDxZVDYQ+
    a62wgFclwGo2RpxGbJICtn8gzJJKHIOQy8yHE0zl4l+VM6hVN+8gR6UHa09bZk1Yt513T/
    wcHt62uQxC3yDf4QeqxnObJ9dxWLzHuZicEMhRWbiFlUKB+JGNP28qLACKcl6wNyoC+pdl
    Ua9B5OSNjPga8Ub2wVkvyTaFELxyNCFzIS7FCWQACLL220CCHvPh+X18GvExXjMJuhxv+F
    9tLm5ENFM04ASwkRSO3Iyp51qBVUBKG/w3yo3/EsuU0EX7gR58+hQGbcnURb3fC5vM8zd+
    usWhWpaYud3Ot3tCEDteyE2RJuQmepY7hlrM/z3+6IgJsx27t7vHX2SKpGotOeRCtprdv4
    kIMETzfYKxvhk56May1pJe0/e0UZqZocBs4RVNIZ2ypOGVwP8DX64BtIh6GA
X-ME-Proxy: <xmx:FqX-anChPgYW0jVA4I9kWxglj0Qgr0p0U6a8Pv_WBduwg8Zn-yT59Q>
    <xmx:FqX-aknzUKFgIUKoI5CG2ruqmvIJXtr7AT01ixogVCbD9uf_rgDYeg>
    <xmx:FqX-aqRNIQlaxiV4eEY9IT6q6QcZ9X_a98DboLGR6U1WycrenUiMFA>
    <xmx:FqX-agIbLmRX4vv6LZV6XNvf5sofPHOqE3RR66P4A9HzDLplCwDYYQ>
    <xmx:F6X-ap79vjw0oq_cuu4UFpjRV52eDTNxdDrq7qAiMo0GJkio1fEEZm54>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 19 Nov 2026 02:28:20 -0500 (EST)
Message-ID: <0d7a6ede-b837-4182-974b-47587248605c@pobox.com>
Date: Wed, 18 Nov 2026 23:28:19 -0800
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 0000/2857] 6.1.193-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261118150201.293410965@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/18/26 6:17 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.193 release.
> There are 2857 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 20 Nov 2026 14:55:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.193-rc1.gz
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
