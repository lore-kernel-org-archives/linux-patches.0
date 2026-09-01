Received: from fout-b7-smtp.messagingengine.com (fout-b7-smtp.messagingengine.com [202.12.124.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717B239B975
	for <patches@lists.linux.dev>; Tue,  1 Sep 2026 07:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788248696; cv=none; b=nDqgEX1zbKvvRSWSGVFeZcrYElwH0J1POyU1RR1FFGrUHfYssFaM9S5osFry2HQr3S61No99qL03fOa+mVmJEGfL3wI/Gx3KCQ7gnahE/9a0Ta9RLZ5Hh+YgZnQBvCPXRV/inoMp4qReC13BkQ6b8oy4Wv2uyQ4jIJm46KKab/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788248696; c=relaxed/simple;
	bh=yoMTvp4YiPcF7B1CdZBdXB9u2vytV5Ngn5aJ0MgQzww=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=obZF4aBP+zBZI75wMmP6MprcnzoATPxNCo6AHXlZbzN6qerTl92JsEYQy3MVXlTELKYwkEqFmqGpelMt7u8JF7yTP5Bet0JAolLRFEUpirFg08M3AxRw3af25ifOdTrWbArMmXRy9f0yiwxazd7iiOepY0ZiNx8ObhMmAInEg10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=GyU9v09j; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=RwjV8WCl; arc=none smtp.client-ip=202.12.124.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="GyU9v09j";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="RwjV8WCl"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.stl.internal (Postfix) with ESMTP id 35DAE1D000C6;
	Tue,  1 Sep 2026 03:44:53 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-01.internal (MEProxy); Tue, 01 Sep 2026 03:44:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1788248693;
	 x=1788335093; bh=vAHRdu25Gd4aL0UCJnMOYgyFCMzj8uwlZmxfVfrx82o=; b=
	GyU9v09jebZ9vm9YyuliYanip4wbKWhazOj2kLHzIvXnW8VH1J8h/LamrDmydqeP
	H7yQTd5VcRorkpDKQgZgFURSgNC2L72BN36sOmQMADCsTvTm+KNmdcOF7ad6Och/
	QQ6xOvPIZBpYkjRczgAXz9bwAYSenwjeaCxPd2U3LRB2i7DWYfsZh70498vhG8SE
	einRRPlW/VV0HClwMCNjL72Oz7incaYFNGZ1+xVUUDwJQ9isYM5r2u33o/6bccQ/
	nzXskrxRDcX36Xz/lxqCBbPut6du5azKVmpNhcaE19up4Eq/rHQKiKSjN2pgBqcF
	L+c0NKXC2vvfCeq0ecwd2w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1788248693; x=
	1788335093; bh=vAHRdu25Gd4aL0UCJnMOYgyFCMzj8uwlZmxfVfrx82o=; b=R
	wjV8WClSIy+JkzJTAmyrHU1dKAczuy1j/KcDmr/bJIYBW6Uo3VzBkfqW6QXbz4Hx
	1akYPtU5AGfRO6a7sSc1H9Jz6bl43vXzXEUveB4WoVGaYG9Zk4TM3OaglpdUPfyX
	GwxAWC1EyWKIQPYTOSwWphJbaTach5/IKDnPepSs3WTSpoxOtkUh1ApFWMdSQNF8
	zZUvlPdrSKRFRNsYyw1scUyeu1yol5jXVoAWatgKVIb1i5nkW3dF60jOTnrrVJNX
	YLsEb3C75M1ZhtyDdwGUQB875c2DRlMRD972v3zfYBG+aMPpkw2WIAQNJvryaZF+
	CoDhzcBW4p6PRMZJui1GQ==
X-ME-Sender: <xms:dIKWarAWlaYPWbX8PJZcSYPaLBftF6A7bdpWc_-DRXZDaC2TIJ3bjg>
    <xme:dIKWatYXIEYOxTsBu1Xi9PBVF3ELPbO9jTB2sTuizh7BBS5vFClU_9Tt1qTOUwmyU
    lC-8rxsX3sGISPGXLlswknpGn-AdBnZ8M1HSF98l7T95ZJ-jHmSSczL>
X-ME-Received: <xmr:dIKWaiFRcEeI6Ez36WL6WHtrBj2bI5kuidyGZxgnN0oSOStRzeAKFTPX1qcWwzyTlhyn9sRI5F-m9jNo8Kqkjw2ro_FgOB-P>
X-ME-Proxy-Cause: dmFkZTFjbx0J/iGofjF5oeSN/hGWMP2hYVoR0A7CGppWe8ytwELxlfhj94LCTLfefR5EFW
    Ca1160+d9JZ0igfSyzXa+LMFDI9u/T1g5MX/YJf0o7e/HuEeiut61eMa54GClb8GU0nhOb
    Z0bptqNf0jhIZanZHApWkU2mwfYpgTRnaLO9je0XFsQLBNdWzIHcSHXm6EbEPTT/gHHJ7j
    JI8TyHuA4TMXDsvKN9O3vjKrrU8vvOoJTUXqvRpYlHJ1PNiD3LtMO2nxD7ceVG3hHaaeET
    roXCiT5G1Mrz4mziEt+tYxaDLRl1UVc9YcKBUc+FIsWWSyFLXPwiGBKOeikqP9d4ihw2oj
    2jAe+pUQyhBfY99KY9avYO28fEVGk4Fu3k2WTmEumgwTWs9MrsNHnnhKKp5o3v6dvB6PR0
    Hq6tfh0IQVfLoFG+v0zW/7WEhhP/ZHdOA8hemZB6naGKPiUbZJH2Zg6/OBKdVTDhOIZ2BE
    nLQlfWDasBfnwZBbFaRITA0ehw1W8x6VCqX4O7DxTB2CjKFxYMu7yLeFn1kHxY8X76HTKe
    Khp9p+NF1kqNLdlFs9GncVPi2FKUtrfrlm8aeetRhyaydWj/g80BFyhoskDMUTSy8Zqytw
    qP7+vlOvs6m9/vyzscwpigwmC+cnpuWFzMCZZVzmFk2hpjjL4fDuFBvvj7sQ
X-ME-Proxy: <xmx:dIKWahsblQ9Bnjf50ZTu0c0Pte1-aw42n3C6sVOBpMLpxu0F9ril0g>
    <xmx:dIKWaoKFJns0Q8PeKy2yQ5BNgvjebvyWNL46VKsCaQmXSRlJ4c-dpQ>
    <xmx:dIKWavM6jZtpUiy_zVHC_xx1AZOo5W15PIuGVoCOv9AcDBpXu5Wo8w>
    <xmx:dIKWagaN5jliQn2kv3uaPGiSrA3d47J-9_rzCvpvfqt9Ka51Ko3xVQ>
    <xmx:dYKWavIaSBlQHCALCoKEtO4nQyJZ4PZOQ7I8p3a6lZR17CbQMUswqGrl>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 1 Sep 2026 03:44:49 -0400 (EDT)
Message-ID: <1442dad3-9791-40d8-a602-8f857bd6fd46@pobox.com>
Date: Tue, 1 Sep 2026 00:44:48 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 00/76] 7.1.13-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260831133359.185608553@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260831133359.185608553@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/31/26 6:33 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.13 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Sep 2026 13:32:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on two amd64 systems, my DIY home NAS and my Lenovo ThinkPad T14
Gen 1. Working well, no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
