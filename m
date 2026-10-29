Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.149
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793289336;
	b=kGlYa0Cm9ndzlalDp1+9Kj0klIHmktBprVfkkEL1R9+o1MoPFUFi7amahO/+1mzdCFvi
	 dT8pQiSkmuMDaXqpg36RzHB6u4vMxmpyuldKK18ypZknhJfTmSCP5ZD+4KwyX4ivuyupD
	 oL2UTxnCuHwhb8IyDiTBNU/4uH2fdY0fHlRo9avpcR2tAauotpQNbGXWP1jRnzqZ3y4i7
	 uMz7qiZMwyYqfZ8G3PRmeNpgL/QOFULAfo7pZLgjXyoId/YMPoziuzwqlSku+B6k1Cmhx
	 F7hF7h4jCj+g46yaB8rtQR+R/Y5VW3JmoklF7jkUjxp1ljCOAE0LI6Z7I5QLXhiITEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793289336;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=zt+aUhUvOjfq4X1+/oBruwbdm7YiJj7HVs1sGEknazU=;
	b=ldJabi75YYo1xTzGvsutceLLRVmhbk0w0FJZXi531chJobVXzfK8us1psBCsWL+S6o7U
	 BxK552BUaj40vypT5/KdRRqQJVvYpNnQafyatlz/2kqL7bvQWbKRhTpJifpzfzPnINMtK
	 2mzBcZ8tK/3LzH+7w8cD+QD4bl4oHpMYRmaNKMwn9g+pWEFH+6GRDCpZ7Mh3jmms2hXne
	 42T3rQ6B01Kksldpfp3dnrIkAglq34kqMkNsSTYPEbAI4e6stpQvvktqyPTiO3/2oFnmY
	 np8R0xvchpBWrjBPUvA5Mk4/MsB2hsEIK6/yLNq5vubREP8+gNFev9KdB8S+5fjQffg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pobox.com;
	spf=pass smtp.mailfrom=pobox.com;
	dkim=pass header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm1 header.b=nOc5j0RK;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b="tdbRjvZ/";
	arc=none smtp.remote-ip=202.12.124.149
Received: from fout-b6-smtp.messagingengine.com (fout-b6-smtp.messagingengine.com [202.12.124.149])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F00606A31D
	for <patches@lists.linux.dev>; Thu, 29 Oct 2026 15:55:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 04F00606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm1 header.b=nOc5j0RK;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=tdbRjvZ/
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.stl.internal (Postfix) with ESMTP id 793361D000F7
	for <patches@lists.linux.dev>; Thu, 29 Oct 2026 11:55:34 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-06.internal (MEProxy); Thu, 29 Oct 2026 11:55:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1793289334;
	 x=1793375734; bh=zt+aUhUvOjfq4X1+/oBruwbdm7YiJj7HVs1sGEknazU=; b=
	nOc5j0RKfkX9jzVg18ZU9+VMaBu9atnyk6m/YEivet9r4LCHT2jC4gz/WuemXY0j
	lO9vF8J24NrF+St15VA1Ss7ht2Xov9DQFNQKlqnVlpxXiT3ctL2YpgAzceY5qv/F
	AIX3ocNz5DzgwLJ46YRlV0E1MZfeKxklfaRXsTaovgysZTzQEXJj8jDvAOpSxJ/d
	kUtFPk0+sdoMlebsKEVdYvOep8nLM6Gx/7iUvRdFklkPm/3L1ybRjGvTOdesVod+
	Qu/kvJkClZVnN0zR8bPeR0gXkIDD51EhyiStKZmRLSEBykhSW4JM5Gv4jLHO/ISW
	n4frT9tDuWUBltAB/MNddw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1793289334; x=
	1793375734; bh=zt+aUhUvOjfq4X1+/oBruwbdm7YiJj7HVs1sGEknazU=; b=t
	dbRjvZ/e/4/d31v+GnwqBfjjAxpTH4AjuQbfPG3u33QUwwYZXkVVVqBSlo9Pjdvn
	vf9/5KSsCZd7qkiwGh/1A5rGRlHx6gi7q3CU8FZX/adwLOPIqs2rxOsec4VJUFHQ
	dkA47D7WxCODeyGnRFE7cs7pQTamQNQee35u8ogkZJIev5uOcicNiUYMVEamyxN8
	jBYnIPzJtqGTv0xUR/teZe0LyVtwOOlrRrR+diSBOp4j7419Qx+jxBgEI8ExQIeP
	LPKrnD+P94V2w6yp2NZcNgXZJvk+u3bMs8gHlwZWMFtI4bDuHVMnPSTy5uyz2TtW
	AuGUcl1fF99kTvl6V4gzQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=pobox.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793289334; d=pobox.com;
	mf=PGJhcnJ5bkBwb2JveC5jb20+;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm1:rsa-sha256:DDIC1zlhrdba/2jHfM5c5E2PuM5hiesXN0J4VcRgBZecaNC
	2og1RwS+w31hotH3eDDCLBHA2fr2XPawtsF3IvPIcwxbu+xgt9rS4NDX8zDpunai
	QrZQvezinl81cTmpaLaCrxMz9cfVyKzvPMVXKm/yxtBocBRVQff1YkOnXYaE9+YS
	1oBMMxd2ILQgCqAwWWUkMiytVlqHDLF00/QFhfhCpCwf6EMAUmL9sNg+ALQwk5Mw
	wu3XSK9PcX+nrTutthOX8aWvZ653a79LfQVicupmfP+FMM7It1klmaIpehqysLye
	iDdW/yt8ha0Q8/FRKhkIPQoUz7Qk9QUH0o1TQiQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:cm0uNMTmIBCbSVknYg5JcuWOTwMjG6Dq9oOYqXtN5uU=:QEdpOXLtQgwyhlABkNyFgeLwl1X79p47zFwoWwqMogI=;
X-ME-Sender: <xms:dWzjahdRjpkb2tmJCr1jSSpxH_7svkMczOTBMlc4YdqL-8khrZx_ig>
    <xme:dWzjarF_qs2sJS9Mgn02SBXfHQ0mJF47QzQtqk1qlFmPkWPXLaGPQPZWcIdVjBjyW
    zkJmg4NlcPum2IXvgzkGQZw6_j_HHGi867cCoqNSKCkqVPsqpIIFta3>
X-ME-Received: <xmr:dWzjamBLkf6RxVg9vtXr0IhEOSJM6e3yaa5u8YI-soTXbM3AlJUg1tvAzeEzqBfJyDq16-sDPul8iHSjr4dtVOUlotgdAE7U>
X-ME-Proxy-Cause: dmFkZTFyi+2BXmgCre10T8IqYNpRmOPTBMZFggV21Mp8I45O0utNIcqj4G8U0QngIABQA1
    06QKSvlDo1XIu7S3avbFB8+h7iId8MOWhyEpY5yfUHRWS7wUy8RbvEtCJuUsewMcrqT0Vd
    +Y14UbKzLYao27r3p0ci58AJGqujG1ecv5G+5f0gpCiGw7wJ9G3+osXWrN+xzetOtslkGH
    HqJNK6abeaCylYjvS51S4mrugEZR4wvR8o+hlmNQ21zam8BKulMMPj3mWI8gHFWfvCOt0g
    zO7ZYbOJk1p9sOuICobrOVanGykmbpoMmkrIBNupvCyzKxVWcutcw25LQvvRFvFzvN+/Di
    dmyJBa0GI+xqUxC6S6o9lws0vIvmNCaUEA0wD4h9enB2lPubpG6/+PN6GaMtveAW08jWkK
    Y00qbgn1dwQJA8RbKqn1dfWoAuuH4PVHPkyA2bBfTEDqPp1eosR6Drk1R0G+j7ZYTERA9d
    8GcmfCatzQoC+Ji4PbIXLnfsSz1oKThNwA5wccww/8ktBwGmjKDx8ZNJpNrb9JnvfKCd79
    JwOCLUCPmmLwOi6iFntksv+5tu3k+f6xWadk2ISfRxawGCaCE7BxZuWaC6XQzZpSdyfjgJ
    sFN/FyKM5tUKxfNE92eG+eCL4FNmcENk8/NT5J8SK/UJKkV23HIw6uThZLeA
X-ME-Proxy: <xmx:dWzjau5BiP3vf3D3djm1zhHQx6_UUOJtpXjCWaVugVaYRtocl4_U6Q>
    <xmx:dWzjalmfEwU5ld9EC04fY9QxS5seKag3nqolwGfyc5Ac9cv2Bg2ZQA>
    <xmx:dWzjan5l7J76WjLrmrwvQEroB_XSbct_JVHiYD1MHg1hzANHjI8wQg>
    <xmx:dWzjajWMyOuNTCzBhwOJRTjxgHxTAhDwIb_zRN-QwV11e6s1Jmfe8A>
    <xmx:dmzjarjxrpZ_uTm_DS0Hn412JGCrVivwWppiZJBAYuY6ym97EWqxzVEj>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 29 Oct 2026 11:55:30 -0400 (EDT)
Message-ID: <b6682f1e-4961-4ec3-97ab-936b26c248bf@pobox.com>
Date: Thu, 29 Oct 2026 08:55:29 -0700
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
Subject: Re: [PATCH 5.10 000/516] 5.10.273-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261028170003.522232767@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/28/26 9:52 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.273 release.
> There are 516 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Oct 2026 16:59:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.273-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
