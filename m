Received: from fout-b7-smtp.messagingengine.com (fout-b7-smtp.messagingengine.com [202.12.124.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F18B22083
	for <patches@lists.linux.dev>; Tue, 18 Aug 2026 09:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787043702; cv=none; b=pB41x5BM50Hfn1hX7WeeKN2K5/X/+/xKVmt4APpir+yzzLs0m4Hj8GqfaCXwEJgMCsjjAihwX6UfrPCQjDrxrA0zquYJIX+xliSnGOTdoHpfWxFa5MIDVjdYam81OFVnjRsDl9jBRWWmltDFOBrNvuqrsuhc56f3y3vLEcdpC0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787043702; c=relaxed/simple;
	bh=KZ1lRhjQVJnLQAKE/s/NhWe0Jkr1h+u5/aqS9pFSLek=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uGmbsB0xeXfyFeZSHLl8m/FF+POIC7f2qFMTMigscf1f701tHf1VqoOCY+3Df3mSw+9hBP2ERMCsaz1kkwr/iBQZlpXLCf4i4SQS4z9Q+g6IMB+pc6WvH7zxVc+tuO0l7+qdBw9HWPXJ5WO0DPkhb/mOJHlM2PH0WBYXN8eSv68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=bUcoCZub; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=TZkV4RzC; arc=none smtp.client-ip=202.12.124.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="bUcoCZub";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="TZkV4RzC"
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfout.stl.internal (Postfix) with ESMTP id 558B41D000FE;
	Tue, 18 Aug 2026 05:01:39 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-09.internal (MEProxy); Tue, 18 Aug 2026 05:01:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1787043699;
	 x=1787130099; bh=K+Yqw+zyVXrFf578OHuhJ9c2JQi4tDuG3ez72kc/vU4=; b=
	bUcoCZuboxIXoZlLwarS+ydRQhHdyqdoOSkQ52my7sxvTG/Oe+YLUCrm6J+fW8FY
	W/B92DU6vU7p/JAlMSIIS85wd3/u2pNetesbtQdQSASxcNIi7npNmNcHvBDHsVLg
	eWR7HQvw9Ge6epf7IvnEdA1+xs+K6zNsR5vcdC0QVHRqhMO8KtlnITxPsIurFiJ+
	lfD4Y5nCgq9inQ3BIUt1CtsEp6Jpno/aeJ8Y8qmk0LRNBNenGVfQsKWn5zf0SLZZ
	0MYkhAF7mM/25e9jlzNqE2XfdvaJ1uI3Mz5YDa//Vn67lCD9+oy/cABPqAsCCTuw
	4F9+F/h/uIPzAOyGUA3JKw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1787043699; x=
	1787130099; bh=K+Yqw+zyVXrFf578OHuhJ9c2JQi4tDuG3ez72kc/vU4=; b=T
	ZkV4RzCVXRsmcVKBiGshSlyw3I39Qh/h6T/J2aJZfeXOvJbJ2YPYNmXLY5vrye+P
	S5Q5rXAXqt8vg8ScoPvt2+TYoAGFzhqrYuiE2F7gsAvim2Q5FlB5IsIB+ijznapq
	DgV2N34nB9rEQCFbg2LuaN+UpsIuCkCw/7z7ACqnDT3gnTOe8aSyvlahNOnKIVyH
	7Xucrscx2rPewk23TvuIaowhxbTJraAI6/Es/AktQXbpDrHOrQhRH3vHNhmbI2nB
	xuHqsCpuTi76hRSTYZgzcgxChP+G8U/VgKWal0DbsYhcwQmtwdeppPF2WH052d4m
	EgJXDOuYQoirBi2hoRd5Q==
X-ME-Sender: <xms:ch-Eaq664qbCoUXL5F95z9dTe3jpUh01kG-VJD3CpZXvo4pyOLP1aA>
    <xme:ch-EavwerZoAr2v58NqxXHY40roPrw3hegCkbXBL_yEwPssYR8AmsZCNf4LaOcSnF
    fNPqqMwdFB6SKgHJHuTs9qfkfjmvVBekFIrg0Mjq_jbydSr6aXBnVjg>
X-ME-Received: <xmr:ch-Eak-A8IZoNHAQBdnfxwxSDaIK6mQlGQtFUFx5qe27zXlhwJtbL8oFQIMsmjL8hGljFyJaXS7BA_0y1gMt_4-jsUkd73kH>
X-ME-Proxy-Cause: dmFkZTFCWtQROyJjSwtAQQFBNxpATtoXT+rpQ6XmwQyQHGpvWvynlV54NA6Ix+LzVwzJe5
    Bo3cqabJEdPxk+n9SVNAVktTN3pz08HZXo8eCWvo2OQMppgjIF4HaQNuRXnvNVkgs4F+EC
    +wqwON7dgzWbbTx9MkWLDU0ntQ48/B9kkNfMfUX6Vivwd+sW/UhWLJxnW7A0U2hsOf9NLJ
    E74oiwtK58Pw7dzougxY4McWh9YFcmRpsL9LdeFzvvNsF3AWLVCT1FGt5sbT5E+kFPS5AY
    aNvkC6Ylu2omHM0Y4nwy1jfmPYK0tUlHP4Z6FPGMkcGsF0nK9v/jcSdMzS3k3g3yNzEWHB
    Gqw7nXw2sxmvADlaa7x+BrVMWaLKURDNqisjqvokEJ0DsGOC9ENFPsx5Zc6yBKuggX+lfT
    1YxUljnL9GUgPUUZ99mYZPVCkryGrBKq/A2+kNRnz8TDLVTQSzCd2Q8owoPXtRpy+gVgA8
    Zp/A9MFHGYpTDyvv9EBTFQM9HgatQ0GoKQMhi0MkE4tBZRC6jczwnigQoi1Gju2Wj3L3mq
    AcpCYhKcdS3i6xUKrZiuqmFeG4KJfHusaP6QrzPO//GGux4l2o4UcYfqVP/zlXutjoQTIM
    dQSbumjmzXGicS0nmiaMZ0ZcNUAjxsyXLGC+NmZzC5L2YTjMi9Ii5QrbOTOw
X-ME-Proxy: <xmx:ch-EarGF9KXCf6WeeUezCoctmYgoJV2ILLJqM2Ktraq2zuD5qACH8Q>
    <xmx:ch-EamCr0ZGWaTrii0ct78ZkEMhIHeer0hyIGhVOZ1JQb8dffbuB4Q>
    <xmx:ch-EannOGXP9wEfNaMoZAvNv_ruaMa1ro8Xlj3kRmFcsVLX__zAgDg>
    <xmx:ch-EahTB04BPeKTqPKtAfIXoX5BC8lu2Ij4ntkQddY84duuGEdaYzg>
    <xmx:cx-EarhzxMSHuP79BkCI0eKvRLw4j6jF-Oevo6IkJDQaG0qD-XGpkGNe>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 18 Aug 2026 05:01:36 -0400 (EDT)
Message-ID: <d8fc69b6-b5a4-47de-a564-c32a60397380@pobox.com>
Date: Tue, 18 Aug 2026 02:01:35 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/456] 5.15.216-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260817132539.792407575@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/17/26 6:26 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.216 release.
> There are 456 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 Aug 2026 13:23:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.216-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
