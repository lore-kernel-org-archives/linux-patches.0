Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC72B36B903
	for <patches@lists.linux.dev>; Wed, 26 Aug 2026 05:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787720643; cv=none; b=pfnRXMF6quhUtjzpVrzOrn54kdXhVnA3nCUrwFBzu6GDERJBFpGzdnf2Fvnq8OMeZP/2/AxH3zCH65os2G6f9ydvH3b2fSITWoyr14ZMioCPW4tTJVr2HVlDkYS3mRwKxoA1Vd/yzlmgEaRCu58RSnZ4wwGbKvxmH6Y/Gwrhhcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787720643; c=relaxed/simple;
	bh=lkonS1j8XZzCCBkt3/6hLqSjwdXUu7RGlnrr+qq4CyY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tPmMmsr80sJXfV3aioli3Kjrp9CCQkNtiamvD2UchGwlFtlMcTYDsirSfV0yjrtNZLSbfRcrwbtpdNCWP3YDJaGA6X3QRsUf6CWtiLhtZB8LEkk4xyy8CC6CpQAvliKFDday3DQAZ8wlY3yWefyaopkNU1QrEo8XPMTCxU7bH3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=wYzP50Iq; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=LCHmWFe6; arc=none smtp.client-ip=103.168.172.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="wYzP50Iq";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="LCHmWFe6"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id C9B7A140008D;
	Wed, 26 Aug 2026 01:03:59 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-02.internal (MEProxy); Wed, 26 Aug 2026 01:03:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1787720639;
	 x=1787807039; bh=Hmh2sQRFnZT4fsjBrs4McWOGbWemtA52vs9VOTGtjTQ=; b=
	wYzP50IqwkxaBsWEolMyHI8lC8Lkwg568AbSrjctUJZuLUuNt+WJ0n6X0EbgpdBh
	uajD6msPve2UBa9qrSNjytFG5gnKguNLmTQNXiumvnsGxebRvbFVX4ejDPKXanDD
	HI72jNjzf6vCgiPBHD/Z1kZWuJmWjg2Rhy7t1f5qdyvLd3grRWXxFnMgyaxB7AW3
	sui6ag7kcUZnFVPDfjZOGEM2pTgXO0WHJruoiGfrL3VuaVWX3tShRy5w+TIXL4xf
	HwwFf6gxzG2BXYW/44LOSx4FUQ44hM43PmKF8DjUp+LFQoiLcdbER+UqjL68soYl
	ygc35j6ntXQLicjfEdDEXg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1787720639; x=
	1787807039; bh=Hmh2sQRFnZT4fsjBrs4McWOGbWemtA52vs9VOTGtjTQ=; b=L
	CHmWFe6D+VjSwrpXkyWv6mPUaYmq/b8C/UCXkyocTaBy5aSX06t6hpiXKJPlE7s+
	69m8z2lUKghvq1gKD5C8bpXZODK7PYGXOXnGZXyL2w++mLDVmxcViKBV4W2cAyvu
	QMCtLvn7Mt4F+2W1b9FE5nsdXBSpvRUtXhr8zaebbF52k5gGHBcxmC41Buf4T6sT
	uZWQdBuoS8JAVpRiZc/sTtV2Uww/su7V8a9PRi0nyX2sskT/qp2wgANIg8WCOYzY
	cZzA7JKef0QCaXLZkd/3kssC/z1itcHNiwxIZDpJJn2njZ9SgeoXF4aaTZ8Uxm25
	/Otgx3P25792PWG+9EY2w==
X-ME-Sender: <xms:vnOOaiO6wwwwMvC77ujUtm05okbRmsXt8aYQAFpqpE0OB3OF7Vfslw>
    <xme:vnOOas0B2RbLoLL8YNlD6sTBlPKoeR0asmBqvw33XYFQQFyuzWXxcgsjajbnLfybp
    MKkMXODB6ybCxGCRnw10hOsv4_NVyymmzX-ket_w8-E0FBuTUqyQh0>
X-ME-Received: <xmr:vnOOakzZEyrPyp8JWWKRbDrKpJaci97A3-5ZgcojtPuI2xVQTDS8vl2lh5n83-FerzKVdUoqnLWjYGOhbyHyqhN-V3MrMrku>
X-ME-Proxy-Cause: dmFkZTEad7EeqEtnPQV944oIis2ZKhtdP3ahcWkQr5y2PpqhOmTlNDxTKpAuijSa4h1zTO
    tIBW1Ky95rch5CjMSBAdKaMhj+asQgk9fPvChFzfy1fGZ0Xr26qXBDry2nA+In/F4s9N8p
    WkDkb1rkGJNkKasMABYJU2vp65tHh1Fj3LIuWRYCMbVxTMf+9kNR8tv2SSUZ6TqVw3ecJo
    6ppkK9wjVej2+EW/di2tpIuSCkjPnmF0EeKaGG/71EO0V7tDT50/N21e5k5879Nu39ghUc
    jJPjcM/Ybg4rHuDPqVLVWaTRstfhYM1S1J+YuLvR8fVbasZ9QjN11Jx7xy87Q7x32o66fo
    CKVdS6fKVBs1iqxkPyswYOi+1okQZaje3NNTvzOCnTz3I0K1oH8UEj+5sZDdvreDx4JYox
    ozddzhbs9MJsdeGDVcAkYFhqv04AFG9zGjCpITWzuNWQ7i6yhppxTUyKoCtv2XYkT567Q/
    egCDECQKfPlDCyFTGlZkq8y11MmwwYtiix3GK1tWSOwB8rU+EVE/WSCP4FB54Dvj6m2pAb
    FVv78p9uhwsT58ZLazlVXcwo5+6010uCLSrtyhDPBhbj80OF7nB5QrLZr/JTlNAlsryuPF
    eksdStMtVsAnYXWhDgEqLfU9KATOAO7lpRZ3w4TO6nGOzPNwnlp6GaUBiJ7w
X-ME-Proxy: <xmx:vnOOamq3ME2AFSDHebZwXmDzJdvOS3ezS8fQyqgB-FtBkqi6CKyB_g>
    <xmx:vnOOaiUNqx9hWi1nebxNyiwK-SvvG0UaOKP4texT4NA7DZFEDtFD1A>
    <xmx:vnOOalptGx5ZSTAibUzwdPhaTxztOUrR_hi9ZMHy_SVTUi4UeaqqvQ>
    <xmx:vnOOauGMrlpU3teGhJLfe-9XfqbtRg3kuwcwYjWUQeZCzsULTN2LWA>
    <xmx:v3OOamAS-lUV2rYxv35wJP-HO-eTCdk58S0Ul2AKK-nh7xiVN3J4Wt2E>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 26 Aug 2026 01:03:56 -0400 (EDT)
Message-ID: <aad5aee7-d385-4978-ab22-fd30365e345a@pobox.com>
Date: Tue, 25 Aug 2026 22:03:54 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 00/57] 5.10.267-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260825132541.342390421@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260825132541.342390421@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/25/26 6:26 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.267 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Aug 2026 13:25:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.267-rc1.gz
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
