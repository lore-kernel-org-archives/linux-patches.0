Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.146
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793951398;
	b=ZTbZHKvpnez3+FSb592klKH/z8JN5FIXImWoq9cSNlzoy418KaO49ltxQ+YLimpI3fAU
	 aA267GfThnh6FgOWSd9yI9ttCUB0tH2iq/sork28+Abt0Ufq5lAvR01I3wkvMa5rW/6ly
	 r5kUk4Vf0khdduc1JaSapsy9exZgnIiiOSz8kRszQ4mVHCKrVVwlXNFPUpCqZj5UaNsnK
	 tjejOdr6dTXgVOAL86fy1dTRrDDvW+HnqDChU+md9P1qU+dZ3T3r3oU38LnHG446qvKny
	 dZpMil+ob2vb8R3o3vXnl8Fgr1RdwwlQIVTF/LpaAL8FoVMoGCuCgJG4A55bMiPHA8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793951398;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=1AHI0cHVScIUZqupXxfL2S2LYfFvIDAWL/E9K98CHlg=;
	b=RkfaC6VKuFB7eusEzTWhJbczJaWFGZL0x8IomXVtH5UCx7VxVAYKECU6Le957xNwkeR4
	 6KPzl6wUK/5GlWW8XWJOY4Vfp6OyA85kSf2YzLgXLUMyoZsXRA/+mrdDrIAPiZ2V40fer
	 0rqz9cs9/KlPLsfhfXnwuUL6TKEGnNDIFlUmQ2yHeg5jS8FCix39jjjq0xJeaxjC304pq
	 XbAZux3dckUGPIP3x3ELBDZkXJf3JjpMAJ7PvY1uPl73hQcb7efPzyVqR60GxQwDNnphB
	 PTOw0ubCMDX6TJuOEuAG5mLrQkZhR+5+BmjwqOxtZcJ6y9EpuflQHAhS7Z3bE4jLukQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pobox.com;
	spf=pass smtp.mailfrom=pobox.com;
	dkim=pass header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm2 header.b=AhYgfsmG;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b="GMU+T/4y";
	arc=none smtp.remote-ip=103.168.172.146
Received: from fout-a3-smtp.messagingengine.com (fout-a3-smtp.messagingengine.com [103.168.172.146])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D05606A32C
	for <patches@lists.linux.dev>; Fri,  6 Nov 2026 07:49:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B1D05606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm2 header.b=AhYgfsmG;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=GMU+T/4y
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfout.phl.internal (Postfix) with ESMTP id EC4F0EC023C
	for <patches@lists.linux.dev>; Fri,  6 Nov 2026 02:49:56 -0500 (EST)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-10.internal (MEProxy); Fri, 06 Nov 2026 02:49:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1793951396;
	 x=1794037796; bh=1AHI0cHVScIUZqupXxfL2S2LYfFvIDAWL/E9K98CHlg=; b=
	AhYgfsmGeDZa4/y4l3w/90waPCwb35P8koRZwK1P67HFJrdLKmLlKD9Yr+jNClix
	thttOryLmGVvG93sREOKNtvjn4jrn9RdBeBEgGq3Yvijd99tGCFt2K4y4BVWnJRV
	OTn/NoiVdlBFJfWJDUjqleDVezpnzAsdPMfjcaq16atGeEeQfefUQUFJCeWV8Ogr
	2focazJ7DGMuDwSeu9UL3QMV11Y0Q/OstcA+90emcsjenb+RgfqzKi8drvS/u0PI
	XJ5nEvxadFT9iVcxQCeaF/L3d/609R4o3CrtpPK1mTvVcSqPtSncB/dAPLtFs050
	WCyO4b8EBqSYm/MoztQBPw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1793951396; x=
	1794037796; bh=1AHI0cHVScIUZqupXxfL2S2LYfFvIDAWL/E9K98CHlg=; b=G
	MU+T/4yC3xU7sJY4lwPdj3Jd+cy9+eLdZPQJA9OXCyaL+jGsPkpnzLnAoYPl50d5
	iicgCraTfSdKoluVdA5NIkyD9y5msb/kcl9WZ059rMglzbspFaJhKy39L39mKIBY
	ZXd6lRAqRKxEzB8nm3vgWmwbqRQKUKSi7x+uyQMXLtFyCA5yW+lHPtmQWCDy37BD
	0GocPCMLOFustRNxJ+Ei6xAaExiooHHlzkb3NMeiprGbGdR4cFc2OHA7BL8pS6s6
	MWsJfRENJbfa+crYg2SBTkxsygoFu+4FY+j86oMH+9ZbxMEipS74CRMNfepsHctI
	iuMSWIPJORf6oS07usewQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=pobox.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793951396; d=pobox.com;
	mf=PGJhcnJ5bkBwb2JveC5jb20+;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm2:rsa-sha256:n+obGlnnomr0zChgoWpRmTPYaLSuOsawR90Mu3su+rIi7ZG
	FhcVswME+UBUqMKAbviA/pHCxscfxhAnOwFUR4fQxlVUICq3kxe8FtCE5U+W3Yky
	s7CRqO3bsVNYXhBIzdIf5pdoFdARL33g64/LUizxZiSU3OAbw8EEXjR57ZotHZre
	3x2Pjw+sK8wxC9DxpequPlXr5jbINVIjUMGbNR4mGJ6WyWZfMZVkvppGhVS+P/Tw
	U8z4BP3yrMrSeK4mNzM8vKx1ncOXL3U4WACvW55Yi7jJDKYnbWhQVTW0+72z8x+n
	cRyvJEBnOEonmH/DyuZmUD2AWsJxUaPaSCkOeSw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:KIHw2e3xfPS+YXrajfvk65Yocyqa030eA4wRjeVGb4w=:ZvUPCHxS3O6LS4EixgV6YSZVVcpJv+np6nRlhY7v1+4=;
X-ME-Sender: <xms:pIbtakR_amYMBEUB6E-QWeefd2HVmu59l1dtAYPNgFs8oAmWihxKnQ>
    <xme:pIbtatqWYnCwAHmfcHQBLikYyEAJkJq-9iAEX31vyzkAJAfZ7vDV_PHQDdP04dIkO
    1TQ2Cq8sJDPOA1b4dTKxf9-rv-uEIjlQroMecnntAz3IFxt0rNUgF8>
X-ME-Received: <xmr:pIbtatX9jZNMWsaLnEmAuD4i-1UMXNGwA_i3ry8118mqmjk7F5G0Fr4oOs4whZnNzB2R4L3kIQ3uWvQlgOSRSWS3Ptn7of4Y>
X-ME-Proxy-Cause: dmFkZTEUI4H6PQciHH1C0CTjTEnjL/+AMWtSU2echlVeolgKazYD6YGf/jp1/AUiVQw0Vc
    b22NY8UD7W0YPFI0J2KMmNRLoechu8v/kX7oOmBz84ncHJvjlSUovwz4qgMh1SKRVBe8Z/
    5ZjCeXkmh3z8IuoYffyLxHtkGDLObwXWUm091vKQ3RUMT6pRfAog4p7mSkKalMV7vdAhuT
    uUnBL7oi36i7Zah1e4k9lvlFnJTDxj60I6igSytI/qIkf672YZkuIUbB7Zc6Isas9YspU+
    0mNlCtDXC1t6hCmqwQ5C/d85MR78RM/1srLqU5nc8fMEAsP8Iu+lM0E9MqRNR+Dz4XgSFy
    0YNg6jYE/w0MrFPCfZA2FrqN7hrziXa9c59+Woa7xZyvN+MYSAztTxA7gXfYcNz8qXUUpE
    tJQ946pwRgsNDOpNVBuT6dYeKWlT0Li1lbIDl/UrFvaEfZTUUDCVtIkde/+vZfYYvkxrIv
    +2XYWrZT3FgyIS1Y6zuArYz1IgVgPm4ompaRP99c2ILbnh0ldSFmhTgnSCOWfyZ0QwLTmr
    HuIV2udmQuoaGaQyzRUNY/39Pre8AFsNld87DnbcQC8S57tn9Cbu82Ir4OVNFUmAY8Bc4H
    OAsgSMINGnSjxGogNtoHGqz3YbCvhp/Wgo5LfctWDnMnemHPIONhloZLZ62g
X-ME-Proxy: <xmx:pIbtar9bUW_MOSTIJnBBYi7LyE7IbFRgPhPVkneRHn11isJhF-_Spg>
    <xmx:pIbtalZjkS-co1ma0Jj1-GcIMF1nvPbd2ui2hV1iWK9vSA4xCsavfQ>
    <xmx:pIbtajcmyse4no46AtwihIz3DohQdLOb7FNAHsDh6-ZSIuXb9_Quag>
    <xmx:pIbtavrQ5aXKANpBHROOLlv9A9MkapwBVvLVBYxS0ozFKbb80QFnWw>
    <xmx:pIbtavl57qGsT3499otKlSu6KzlMMghN7ADE7VbLpcCzQgXUTiVKlQpA>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 6 Nov 2026 02:49:54 -0500 (EST)
Message-ID: <49bb4977-b5f5-450e-b3ba-9d494fd5a7ad@pobox.com>
Date: Thu, 5 Nov 2026 23:49:53 -0800
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
Subject: Re: [PATCH 7.3 000/547] 7.3.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261104211038.406938024@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/26 1:03 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.3.2 release.
> There are 547 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Nov 2026 21:07:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.3.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.3.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

I tested 7.3.1 + stable-queue as of commit
aa65920a134b0366b65f438be80335f2060ed664 ("fuzz cleanup"). This is
after the broken xfs patch was reverted, but before the tun patch
was added to the queue.

Tested on 3 amd64 systems and an arm64 virtual machine. Working
well, no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
