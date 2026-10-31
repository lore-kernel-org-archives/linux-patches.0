Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.151
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793434649;
	b=aoGOtGGPfclx9O1Mv33gwsFeLDdkz9Jz7XAXYnF2CA5SEN6RcgnM0E2j7WZ5/+bUYSZn
	 gp3Z/LOrZHIqFOp6kIL0tFKi5APN7peSH+GXF/e3HDnPbviyVub5Zy6YSQ2HDFG95L8PJ
	 1lR8l+uWgE7K8RP8ySxMNQ42Zl9dk9XobXy9x98GIPf+W8YE8gN9hthjuBPJucuT0vcvt
	 Z3ebkxJ8nftE6l6sR6K6xRDiqlmprhIqILQ04zPt/kYTrEjNNw1y6lHBtu4CNt0QobDll
	 OCpCyCmuNFeCBpj0an6LWSONcNCDdS46D2TVutyWgbv24aEpLLzWsSZI1/h1jhfbJHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793434649;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=rnfQUx+LEPhCPsSJ4IAiIVaSnN3kADpQoNyJc7Gibio=;
	b=Y/bf1y39XdwCNCZBz7pDWZgr2MilSBc5e5MoxUzfqN7v9mEmSZClqcnjiIKbBPxDceiM
	 IrIUCAL11IerllyhV00/FVf7lrEgKqbYW/uMTOjhoTyJJ7F8K9XxhgWg6KlBihv2HDC6U
	 Hy7JoQTKopOK7T5TuubRU/uydynFrxi5eRNUec//+4d7T35jDqQFgSp/tYbRZlmyi70GQ
	 eo1eBZY2dUxmXWN/7PezUUWd5IXZQYqhpglmoZr/5bi1nOpZus+lVn6SFQ23326ndZOnh
	 xVMaR4uV+A4QNIg0fph5UfLcixZK+AAOhSPfB2Uypky+CyyWp5HjD6qI7UEOgqKDKjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pobox.com;
	spf=pass smtp.mailfrom=pobox.com;
	dkim=pass header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm1 header.b=fC1Xdnrm;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=AUtpj+K3;
	arc=none smtp.remote-ip=103.168.172.151
Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0836606A31F
	for <patches@lists.linux.dev>; Sat, 31 Oct 2026 08:17:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A0836606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm1 header.b=fC1Xdnrm;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=AUtpj+K3
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id E2A9DEC01FD
	for <patches@lists.linux.dev>; Sat, 31 Oct 2026 04:17:27 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-04.internal (MEProxy); Sat, 31 Oct 2026 04:17:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1793434647;
	 x=1793521047; bh=rnfQUx+LEPhCPsSJ4IAiIVaSnN3kADpQoNyJc7Gibio=; b=
	fC1XdnrmdpGbz5gPs6TMNyPflsV1D6yfF/blWE2t4DONYl2dqg31kR8VaX+Y/8ur
	9z4U6l4/CeSBx7ybEjXxnv99dlqkoQEuP9FiG1ghzJekW3V6C8sh8yBfezngJUt5
	MRPxJTjI+z56m2IwAABBjIhe4EMTSXhktjN5lbo1Q9u0E0ysfgzeePmNU3gctBpz
	R9V6Wodgkh32LtiB3Gee9+PuPnFqht0ZmhilqlQa40BYd4ZFUWDLddcLUCd/lYnn
	68ayN+P7nvZTSkmPr5OtINiKcavaqCMygevmQDsK9V73my+WLWPNDu6LmjPfP0Pm
	0Lhq1NcnwBfejkNRJWSmGw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1793434647; x=
	1793521047; bh=rnfQUx+LEPhCPsSJ4IAiIVaSnN3kADpQoNyJc7Gibio=; b=A
	Utpj+K3ODS+KpSYo+MzzYuHHnDYqwQFO6zHnQ5dL5/cUDS6CO0sr2+DCp3Bzfnd9
	mp4nSnaYxDPY8osSeWEz+7VvFn/wM3HQbw4adWrY8WWWfLRtsUkJw89Xel1r9eYT
	A56mrZOQCeOOCxyxtjhhX4CMeQmNipPhkYWkwMswtTbJAcxr3hRmhp1faVpJdX8Z
	9AbPvuBXVz9m6yhEyZI2ilWdOAjXPPcwnRqzuR9JFVXOUxkuMHIsgS5O4YMuSLFC
	JgCFeCQqfWjK547fP09bMdNCAp0p2g1ofHdsIzCQIZoXSXAQEbGF6lkoM7NOAs8T
	Nug68R8Ebx0H8sDrB6F1A==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=pobox.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793434647; d=pobox.com;
	mf=PGJhcnJ5bkBwb2JveC5jb20+;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm1:rsa-sha256:TNG6jcNFaTO5AyBfXIkmpGgDg1ryBh8BlcrMFdTbRy6X4Oh
	MdfGqEas93uhU56RmJNGxaqiQCyYtmEDd2vzLY/L0AkUgrExlZqoInkK8mN8IH7Q
	BYZRKkt+wZwr1HalPq7nAzJMCIDcsQo90anmRhOPH8aQj5oxqrBg3ut/xG87Vtpf
	ORB15bfO2UIIlcs61Iqh3OW+0Nz7uZ+NM3GOySxbybo1cINjlMsCu9Zbp35dB4Sp
	2akumgSwPDoaiYx8KDWAwCHPHwItrHEyTw1Qkvccdxzo7ZJ/4+VaOwjwRJ7WImgy
	Ur+yMacdgXVqAeEEABXt6CCKjkBGII98OAWGRhA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:NgRDu01O8AU+upvey9fhsFMNhDK+YFrnyvatWUp2FAI=:qA0pD7FKCwuP3nSZJSt+RalrmtELdTli0/GLgZVMqbw=;
X-ME-Sender: <xms:FqTlarTAXyfJzZTvnKYHsJKhw4oexrrK06Wr0ifXUPQt_vqMY61Feg>
    <xme:FqTlaooT2mSozW3vIUcf1LDMhpPRydB9_L7UW9STan3911-gBf2dxIhTRddDce12_
    BTDNnOXvqpKlje0cQl60pGiuuRhhbZnysSP8rlw1jRmBeJs3IAOdDvC>
X-ME-Received: <xmr:FqTlasU0tJbTmw-Cvuy73cUnd91nAkifnl9SBF13IRmLn-j7ft-cf7q8pSxPZKlyNXIdrlnJmNwaMYftXr95eU5p1Xd7SYsm>
X-ME-Proxy-Cause: dmFkZTEEH/UJEPA9dFtELWv8H2w/4/6VOoy/nZUvDdlDrm2SZTJQktOY1SfcSO38GcYdzt
    ZyJVUA5jlXpSokW5ISylG5172c+vkMtf+nEAi2KlNubVue14ToIMna38mONKrORJ27Vg9I
    BI3IwgY62OaXndpah7x8z2qzlc92s3hte7KYWks3NHycZjregzSbmtLQOHfBMtZx2jAAVb
    wY7phBpo2F/JQGqm8uYR8xdbDxlwSpWhP76vOVOV96948hLFqJUdp9A+iBx8bW6l8gTKFG
    KRF6bZtVBh7ld597JyyaBVFIk/2CN7vFz9Eg0SijT3GQmN8xnULwnANcI9hVPWhSkj9hN+
    lPsclQjJFqARg/Ov28Pzl2nx1n0C/yA2lBJ7aOtcdbntM2jtvDbBlvJcsU6d+U72myzbuG
    Gh9HP0Cu6be2E0BYezSwd4Xl4lr6DDWfL/PYMVx5whrUnmy9NBfYOxpHi+2pelvBSuN/JQ
    EelLtSVqEqQPYW/I8wzClQck5y9PbxYWD1wtuMfkaUXPlKL/od2IOLyVrd9gTJAWI+Nzpi
    X/rvZ+DFB2I/KKwCiopzMA9w8+w9ZiXWx6FCMsukWh8G29ldYYurCRrVuZPbI/7NHWCUmF
    WHsrKDqXD5O7upJAtoSKC3EYjyLHXYeQFzN5IOrwXtOuiwEeX3G1lJBaYQCw
X-ME-Proxy: <xmx:FqTlau9fMuF0uW5x39SC0caJCwpoeI7cR_y4ewSjI7zwS49vcd66Lw>
    <xmx:FqTlasZLY1J3INq9MDp9pbgW6ZATK42k8gjhX8cl3wl9hZWQ3YlDnw>
    <xmx:FqTlaue9PpkdGY8eaLeuSxmSfugrVT0RFibeKA47RdFg2ADFNBMT7g>
    <xmx:FqTlauqGEgsJr55ngQlBn5PPGgip4ZD0QbMFP1gPm9iSv15LDR2e4g>
    <xmx:F6TlamkqZ53OFkNEMU9Yu5eLZQh_vUIeL9E8O5J4cm6wSUwkLct6LR4Y>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 31 Oct 2026 04:17:24 -0400 (EDT)
Message-ID: <922c7eca-79d5-497f-8739-91973702b969@pobox.com>
Date: Sat, 31 Oct 2026 01:17:23 -0700
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
Subject: Re: [PATCH 7.2 00/10] 7.2.15-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261030121255.257615100@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20261030121255.257615100@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/30/26 5:15 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.15 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 01 Nov 2026 12:12:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.15-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on 3 amd64 systems and an arm64 virtual machine. Working well,
no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
