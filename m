Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7787DC8D9
	for <patches@lists.linux.dev>; Sun, 11 Oct 2026 00:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791679982; cv=none; b=EV//Pc1RfdWgeHUytsxVrYrXhIl611SCOAkKKK7Mmu+i0tiytKKL8dTEuqeErCx74KblpbTRqTD5JnpISUGoCPIYCEDwxWHIPWN26bAJLViAmv8O0YkQKLpCfi4jWvbJJyBGmIKqv3355HPie9SWfMpp47YPpAHwfkcF7GQJAjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791679982; c=relaxed/simple;
	bh=en91qOoAF7ONtSU28ECiiDCudFkkfPzlJRjMs78c22o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=urDezCvkOt7M4czo2+4o6L0E6G7YWb9/ZA5nGKJmAUW6QyYVT3edpVkF5TdL6JVKJJy3d+I1j3xmuEW/+Z8xHEgKqSJZ6XWJF/5yuSX29t4ZL7fouQZf0ueB0OxWotc9Bi57Sl0EVM9OcnesanJcLGLCkLJPl0K1qeIRJbW9zGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=JdGOB/GI; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=bb7ZDGFz; arc=none smtp.client-ip=103.168.172.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="JdGOB/GI";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="bb7ZDGFz"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id 9492FEC02A8
	for <patches@lists.linux.dev>; Sat, 10 Oct 2026 20:52:59 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-01.internal (MEProxy); Sat, 10 Oct 2026 20:52:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1791679979;
	 x=1791766379; bh=oPijvRpCMbjLE8AoRI1ASmTglYORZbm65aPnQy97GBU=; b=
	JdGOB/GIG727Lv/7NERg2OXSNGclAAyt0qAwmqqx7kzgwp4Ba2m5M4vVnh4+amkX
	acXCEacaJGch2CShZiWz48V4Vip7BP0+x8sD6jvryuvbEgaLK8NWOZKTFq1FHVXZ
	an8RJnnwW1Au2UXqclcS70mDju7I2D9u8iuPPyGYWj2w7of4HFpZTYuAnAHkRUP0
	qPcJEEp8chh65WRt1KjvDwROfcksBD48iJ//a7jZKxPqSAWM1HCsLIkGcfLOPUVd
	pN8JfU27/MB0mu7romA2sphxJl2ALBinaDuVF/StkUpO51wijxdNzNCbu/lsXXnj
	+XvHdNOfcEaKDheEQVUy+A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1791679979; x=
	1791766379; bh=oPijvRpCMbjLE8AoRI1ASmTglYORZbm65aPnQy97GBU=; b=b
	b7ZDGFzQjIeMaf+4FGlfwwpJXYf7iohkxxGhBzHNyZGzEcMy+fPXALsvKKD4kbQb
	hWy9gswm8ww94JlXmaIPMncpYcVlBSq6TE30zucV4hRzqGw1HRzpCFOr5MxNX7l6
	azMtxpJbydrNUCmA5ncdouy18ktezEFo4IugmxgWfjlUtsaGN0QJiekLbkDl+MQT
	n0aKwhZ1PpF1jXCIcCg7326j2UPQRyHmOK/UB+1ERJg6FdTuj9Q9q/myNUZwhtAI
	ZmtIR4SusrbSPRHlOzFBff1cPwpfRemizCkMNHkqksQU5EGjfPcPeLVHL4A43uWb
	IVVOP/Gz2Dr2ftt6xx9VQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=sign d=pobox.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1791679979; d=pobox.com;
	mf=PGJhcnJ5bkBwb2JveC5jb20+;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm1:rsa-sha256:eexsbp3E7gwepZP2W/OYi5bMCDtgchzRtciAT3nK3Xb7yTg
	Um1UjWutrDigkRE8sMWDJ5ANnjDcO5+E439IY0e+4u2uH/FTuLS+Z0susGPhvaqf
	XtH+HQrfX4OaDs3VDU2zHwqZAG7oFEFArlP35t62G9PlifOchEOZR++gtPcwANTD
	G1+04ofZUPGQn00e6CqxW9U1fZ8lbw6JbXz340L3Jq2T3VLbkBRboMSE5WriG6Pc
	D0Zpqou7bJIQ+RQcNOQnTxrB9uAB2adEvYi8PCG2943hvg6F7NZdxCkxGBe9IzcT
	qxO69JlGR8Z2agVEiHC80npnQyhMB4otsWeRLdg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:Fq/tcSeJ9/Z6xUS8S0Lc1/gJ/h1zWi4znxUePyw3do4=:en91qOoAF7ONtSU28ECiiDCudFkkfPzlJRjMs78c22o=;
X-ME-Sender: <xms:6t3Kakbipuqz5dh6PhqqNbH8eKgM7FkYi1fe32sNgvVraibxrK9BHA>
    <xme:6t3KarSK5ABnxPT9gmxL3xpYzHNFIa95PbPzV2GMV7CMZjsP7Xl7WB42UEctxMoen
    qR3KK3vfFZ0ZpwLf2b1jpt3jCFLFlx5AXc6-mp9127oB7kyl5uR7U-B>
X-ME-Received: <xmr:6t3Kaqet8LTHj90w7kSA3GybcmBEiy6_HCYArE4Zg0F2FhzGln6lOEAXZg4HHT4lrj75Vte5zqvMd_XCh2lgiACkEXheIxzV>
X-ME-Proxy-Cause: dmFkZTGBvTFpgk3RPwa8M1ObkKT87Ax1XfALtDqTPiSGuR97dAjNhoeH4z68g8/LiqCtT+
    p2TeM/uJmiPFUXvzYY2ZvawxCFMa7FtfjAPQpaHutQYlZ5GJefBmBfQ1Oecvx6ZA2YBRiV
    IHLmTuD1MQEWWIjctrPjMp0CgxUxjh/RzhVQJOjR4SyUUnilUASG3STR844CJ8MzHa/naV
    DMDntSBocL8XqyakdziJlAh1HPomc54RmHiVkvdcU0CP0esuDWUAqyeUvwXWfCv9tBnzux
    KifdQH/kPVLhwCacfCj/Tr5taAczzW7Dyoy0kDqgsokGwXaoJwG+2rfGl0HHy1GuXLyFZ+
    gN69n5A9pJTXOiC0wxc3paJmqgpTbZzqKEY1NNYtilJMFlIZJfpy+iW5NS564E20ZRu2dR
    moppAGzBxwfsQXq0HctWoranectvYaJNwKdMgMjKglZbMmeU+NHzJcCy6Vp16O1i5452lH
    +FEFgc+IYU3W7xCBPouvv5i9rG451Hd8wIrLRcPjH4EfzJ86a7AEnnOMNxvf3xq9dJ7q2X
    LHFTWV2H/hKb+4oxOj3cV9QZJ/AFfWrxEP5Yx1NJgrQdluyWIUmgq2o7fvPEOdrrsYmDgw
    Rd6mwU/bkczww/kh0NClXImQzPW2apsFSPhEGrj6cjWeep1sJQM6mlRfyktg
X-ME-Proxy: <xmx:6t3Kaink5IGlVdNnQ1Pnfu5w1U_OPvcgzfBKGEIm4N06veQbL1F5AA>
    <xmx:6t3Kani0qVLL48TiS4OlV8wCeHlNUj9q5k8mzIry9w4h94uyNOoPPg>
    <xmx:6t3KarE9YdnouZdjT6aF0Awc-PUK06HJcz_zkgu1Ge6ldQ1wlsyDoQ>
    <xmx:6t3KauxrylKEM4VoHpBtkHSyT9AVp4IpAgU4ij7hCKKt1K3AZ_jRkg>
    <xmx:693Kahva8dtDDDaRx25PbKwQdOvSxCWtMlf5KK4ZPaePtEsEoCuBEdpA>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 10 Oct 2026 20:52:56 -0400 (EDT)
Message-ID: <eb0843cb-f251-4afc-96fb-82eb34438592@pobox.com>
Date: Sat, 10 Oct 2026 17:52:54 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/403] 6.18.56-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261009140952.119038291@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/9/26 7:06 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.56 release.
> There are 403 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Oct 2026 14:08:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.56-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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
