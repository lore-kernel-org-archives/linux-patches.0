Received: from fout-b6-smtp.messagingengine.com (fout-b6-smtp.messagingengine.com [202.12.124.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA5430D403
	for <patches@lists.linux.dev>; Fri,  2 Oct 2026 01:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790905299; cv=none; b=pgMBDQQMQ6+e6XjF1e4EfvYke2mbQ/DiZmxWNvFI4aol6wmJIR9HtQyZQMOQAaedzFZ8bR/lHARPiIiV68WJ2SZQdfvWZhEv+wqUsSNQGfydqpA6fAMm0Ai0xX6YuV4duCvm0Uk68Sr9cv+djqMrnCjn/atKjQrUzuq+QNWtARo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790905299; c=relaxed/simple;
	bh=ZRzhF25nKLSbOwT3sLI81CeKd+a/Z38RuANs8dJHJmI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QsljPSftbpx+yzlpBFwybXy8HtzguNoYxfRePPwWoMvGiOGw0U4aA1AN5dt4mAippzNLdWhH7KPIs8x/1+rEp+54HMXuPq4nvBuffKm0wf2TWgxsnyfpBb1LbE9TgfmqMo6YmWbp4byg2v/Ui8QcN4YPFf4C/2gqv3tktJGnJOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=K/6Gt4Rb; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=mQmwOxNw; arc=none smtp.client-ip=202.12.124.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="K/6Gt4Rb";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="mQmwOxNw"
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfout.stl.internal (Postfix) with ESMTP id E6C8E1D000CA
	for <patches@lists.linux.dev>; Thu,  1 Oct 2026 21:41:37 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-11.internal (MEProxy); Thu, 01 Oct 2026 21:41:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1790905297;
	 x=1790991697; bh=ashCR8K0JXTuj/faeWQROt/MfohFJFs/K324b7Qx6Vo=; b=
	K/6Gt4RbvZQo3slSjDKBh1UvmRLzWs+wtTkQGL08IL5jz75u6iTXAjB963/SgEEv
	3NDT9qHjFd7BvRvuS7Y/wvnMrxV7K4MT34retdyVi9+7OKBrTLxYzrEj6J2NDPsr
	UGInHCEyje27MtNhPUQqlzVO5BvuAqU+ZkZN9mtkD77b73UX1ldRr1Vtr9duo4aH
	V3f1NyZWeLCX56xcob60qXmZ1qQt4n6qJDas0xce9ouenVqRHTDNUNSRq2+1zn80
	Y1gI1Z/0u4MUDW5/zn0tH5VNzoSOjUblOEFwd6Jh0Jj9Wne0ir6sDR0/nVb9gvRT
	tlEuOcF8/d5wOeYK0xSzvA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1790905297; x=
	1790991697; bh=ashCR8K0JXTuj/faeWQROt/MfohFJFs/K324b7Qx6Vo=; b=m
	QmwOxNwAOcqEoHXhCGo1TWudfQKL5+qh+aLStL3XZ3kodq1019Ime3m1vLVh/eET
	ad+UaZdh2ZAT3jpoQw0bVIgADmSDHMGgD5ARkLOMyapXD0Jas/lxnCerxPaaDxAU
	OvWC04KWCNW5WfB9M/dRUpWlQX878fEO11M1N0PyD34ojZVN2l81YIaHEetfFkfm
	cGjtiv/MpFngDiGucswvh+Ok8K6+UJiH6/x0iSKptmY53TANe7lcpoiNThLs65Ex
	M9WYhMzoGc7NzzNqnRru4F/xwWrY8zzvmTpDuHdggPwZ0oahB3+/wCa8uxvqYaCG
	eTTC6RliLFdauPtM+5T5w==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-09-30; sw=lmtpprox;
	action=sign d=pobox.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1790905297; d=pobox.com;
	mf=PGJhcnJ5bkBwb2JveC5jb20+;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm3:rsa-sha256:kICcnqovwUHcAe8q7/hvZyg5mnrGysM25+Vp965CRNyXX2j
	/h2tIThUmHbtx/Tsl0tuzFtg5+I8WsrnOlTm62GL0l4HXSeB7sG5aYPUSWDCzwwf
	TqUKGYqy3mdLj/ZY25c+CTZ2YfdvDvdyD01AMekdCnnSdL4LIjy66sHAh56IVPCr
	zo+tQZMq8fLbg9Lof3GFR4jYp1wukqfVMmX8Xxc+xxi8UShAQS8kV3DHhQC9eLgY
	6Jo0fes74pRUEFi/8c90PeMPyuwzzyRoNv2gE6d6xRcS+FMgiZu55ioFNK1g9+nJ
	z+vKGaOTnXTIX6ufIQNAmCAsJQ7zsDtQBdm6Htg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-09-30; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:yuMlTujvqfWFUu6LMMvqS+vgF8zzUbmFizA45jHeR3g=:ZRzhF25nKLSbOwT3sLI81CeKd+a/Z38RuANs8dJHJmI=;
X-ME-Sender: <xms:0Au_ak2HLF8ZXpalj2QQK5KjY7y2QfJmFUSanK4q1AuLcbSD-NHmXg>
    <xme:0Au_aq8YhOSGbOXCEB7N7cnzIevJjcgaOPmPkc0HSL0pLco3iufe5s6oK9_AUFdpr
    TIq_fchjf1bx4oagZJiOiDbUYCqov923i2NMPGvY7yRwjM5GW3NqES9>
X-ME-Received: <xmr:0Au_aoaj04ZrjfFEqXayeBmzOUfGCp7J2XlgyiBZ4HqbIH1z97WWTGJ7_z-HdkPCXoyYxdfU_LiHAT2f2mxsGvlfF_b273sc>
X-ME-Proxy-Cause: dmFkZTF4V0bz4r7E8XJUN+K/PO3behlfcfAC4qFQy749o/EwNIvur4sMR2gyQvMD7K5tqp
    MS2jKgCVOcZH1q/tiMiLvR0Y+XNuIaNBpRJHXFJD48lH4lFG1+K3hDAYNIdnd86vFzHJfq
    mdB3rBbx6hqPB3pzrfoJEtsOsubU2DxJNuKmGRaIZ9P1bexgJR6NRlaREAnyasjKpFChZF
    ZzpKkLtdXltCNqX3aZoB1XCk0ryz6B00PLEG9oEmnc8glm4kdSbjku96SRG7Z3i9f38taZ
    e/5BaqrFx5DXKVFyyp374D4a4WkSny6B5OSxXeNltwUEY4fhgK+8qBT/8lugxjH2tUmWpo
    ojqT/r1V7M0UaxtToaOaGfPUizqS37eH7qd0BN9k6kJwoUIQpczySO7sgRxKfkFACQruUj
    TSxCcYO1qU0T2ze6v3tf30GIwnf3y06dmi7f6FFXkKImekrxMPW+WfqfsjMYS2eFOURSdH
    MSBIQpxrT6U47tqYZtarMCOhVk+AsiM82CRxKkD+ksfHpnlvcndkxY9tECOQJbz2FHvQqz
    NL/BGuJVEaE9KKMI/4xqrJZquTLGW+8ZNF9TKIZ7SzYDfzPn02Z7wXRGJIjnpc3OEdYnb0
    /jkgKSoX0hUBevCxffAEm39E0G6gHEM5pRBHOaRen0kfCXCT3X7kNUkcmXPg
X-ME-Proxy: <xmx:0Au_ahzuAdQJmkdx8ESQqzfLw7EjIlltkAok_eyki5q-V__v93g63Q>
    <xmx:0Au_au9C-0UAAQGSboDONcWZvMcujoJwFlYVpkbXTRDnM-qu578akg>
    <xmx:0Au_alzQzUCOsiiqzouYk943UqDSe95vEQ4wwwz1wb6ug5Zx7VMrKg>
    <xmx:0Au_aruAbmciIp6HUYmyb6IfcTf-GD3eSRr3-ZmTiRP4lueybLlVPA>
    <xmx:0Qu_apZNhz30jZRmI1eZtKAH5LVnzbvMZPE_ahUI5pkibiL4L1Tdg4Z5>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 1 Oct 2026 21:41:34 -0400 (EDT)
Message-ID: <449cec94-5916-4fd9-9b3b-1af04efed83a@pobox.com>
Date: Thu, 1 Oct 2026 18:41:33 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/982] 6.1.189-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260930152416.775402466@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/30/26 8:12 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.189 release.
> There are 982 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 02 Oct 2026 15:23:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.189-rc1.gz
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
