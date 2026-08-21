Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B1040F74A
	for <patches@lists.linux.dev>; Fri, 21 Aug 2026 05:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787291606; cv=none; b=G0ariwqnvFXblCCpF0JoSPkpg82S4bQVN/JKolf7bVZ5ergPcJHUhg5sQ6DChEAGCbVCPRC4mVKVlL1N+Ytcyk4PxhOvmcJhfBblQPA8zfKlgY3Izh4jZ4DCcUCzS873TtGfgc1MNKcsI+1//GuT76r6bHVG0qwsJPpWWvgHhSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787291606; c=relaxed/simple;
	bh=QqumwZAJdrooyjSmYSUOC8S0ewwAdTrLXE4BPeIlF0Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=roZUvOvGoVhuDEklTxelSPowncaqjk1Hf/brT7+b7sF/YQldekLYe2FXiv5jjOmF67typSAtBd7yuj4j8g/sgIZgo/x+UvOt3EXvUs6Wb0t80dtfVecu2CQ9SytEMGvetX2MiOULcwFtqDuPGkKSLOJHwlG2EKTLuA+Hg+xYAWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=TMOFTLxh; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=f+vAt2WN; arc=none smtp.client-ip=103.168.172.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="TMOFTLxh";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="f+vAt2WN"
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfout.phl.internal (Postfix) with ESMTP id 9DA6AEC0229;
	Fri, 21 Aug 2026 01:53:22 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-11.internal (MEProxy); Fri, 21 Aug 2026 01:53:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1787291602;
	 x=1787378002; bh=KKK0f/eajc62CvVmRT3Zk2MKXPO+xjtACFQUyq1IDfE=; b=
	TMOFTLxh5zqspeAd7a05gV9lZgr4vhgaXeF+7nWGOFBoKtrnD94tLEMs52jOGOwE
	FouumOocu+JTkSRvFYuwYZ91mvnkZaRWj5Lvzd8UWh0zuiPu6nNnCOqzRuqV8LCf
	gr0kZ60cl+lISd2Hm7yycl6cWCWogpKM8EtPulPEk70W5qdigfbqObAIv6sdQRtt
	rAfBYHdoaRAwYzfz+MnM+YQWbgvJMkvjSVFzjcLeNwmF+smF5ygh4cpe5dNcVZ0T
	Uuu/3kTAJkpbFrO/Gh8ISspX2XcbQwMdNKiL8DcTGyh9ikAi5FBgIqbA5OystAuz
	2MTxqmLO2KGHnacD95Qe6Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1787291602; x=
	1787378002; bh=KKK0f/eajc62CvVmRT3Zk2MKXPO+xjtACFQUyq1IDfE=; b=f
	+vAt2WNsm4JiQwbQ+0F2Vdz6wlqzZNSUX4iU9d01AcbACLr5DE9JqZm4e2KjdNlP
	YgK0IlA9w6wS6CovYChDXZAAqw/qg/d7HPhiLxGpjOOXcMq9VAdptl/z7yFl7G8l
	10WgfA+Qt7Ve6WNpNaCv6fLgzvCPkfqIfkp+JBB7aduJv3KjL/p1S0NVriPr4mrT
	Jr7/778MDxaqEOQssuPMsuU/HW8tT7qFNogi+3XCfy/gdLE5I3ZBAuhQOx6W49jW
	6WE7SQ6PX8g0m3NW0w/7BPplfrB7w6OsG1lK/qPsED2HRVei4edSwlJhNagPuWvE
	FU3usmtNddQKn5tOGIwQA==
X-ME-Sender: <xms:0ueHagDEQ_4VYlDBmwi0pS-q0SvC2rEJeChcSO8_gUrZAv9XuLvzLg>
    <xme:0ueHaubC9bC-Et5zChwp26VR3ZfthmCqfK5O35YxAegW0hk6RoVMZlaHmiyroNSal
    vQXI06CfmKmNvoSIr0n-YeE2OrMe6NgBEFYtofd-pRlKk5bXBUUFLUQ>
X-ME-Received: <xmr:0ueHavGG2k4RAHk8QbVE_wfib90KNSe1a4PrXdrBfvJwxUgtbhCEzD8A1HPzyUR_exbRhiWq0DJd9zC09LQUqTwhbGYOo-wg>
X-ME-Proxy-Cause: dmFkZTEHS9bQ5EvDTfr4nvvYo+mDRwCceTwQCxn4t+BrO8sW5Tjtod1/+UgsuECY8kZFNn
    zreFp7IAHSP7YJfcUwzeQHdNjBoefb0qdPb+dQPACPGExGIVwA/P6KWkudRgIdsQbi4x7j
    Yv6HVxovaE7rXU1S8zQ06/vnb+HuE2MvRZ6cWOWZcz227n1BTZXq7WJz8BTce+TRIeO3Zi
    5A5iD4BLA/Aa1c1kECVf++AREhFgj7P1EYPxFwEK0Xxs6FBOHhfwboemsoqQNwg4WaM0DG
    5o5YAbsCLPy5CQSuuzcFUSgvCQ/Er3QjAuUkXpA9OIiChjw6Dq53nOJAa8WRs1pMT7NMl9
    67PonGXlp5h40V9D//55M6U6SvbKwVGSu3bnPjjDzvpsYoPRs7VlZW919xpDZhEek1irMj
    fL4yeGmWq9ws3drPVMg6rudZwu6NmfZP2/je9q2oXlyzvbW7oR88Rb5FvaquKxdlMCNjO1
    WSondLf47oIgqQLSqho3Smm69FVD4e1jLzD7p6rNXMDBAQXl7OIEqbNubutFxTxPZOnWp5
    sFL8TMb+gfprVo256a3Pv3dI/EC0AiBBkk5tehAe+DzcDJ9HpezFeXnbMm5UDJIVdFrWYm
    zUjpqcl+fiNrlq0wX3lzO/B2VThvvmRZ/CsE18q1PchoPOgx8Y/p/ldglSqA
X-ME-Proxy: <xmx:0ueHaqvk5p_QN72bURlwcjhu4c1_h2ZNkHdOt1JSky8AVg5pUQQs0w>
    <xmx:0ueHatK30BlWhLhgd1-ltwOKh0U8YxNZ_2i4Maag65UtoCOrhjbCvw>
    <xmx:0ueHagOH-NQRM5_qoYNZTaZfEXTAh2pNaBvm_7uJuqBzmGKBnLOKXA>
    <xmx:0ueHatZPrBGoKLGNbqwugO2wSJsZ1YhnZBYZ2Kpl_9SnX--VjfAnuw>
    <xmx:0ueHagJ10tXqp5PDAm8iefwjoIV6y0jnwqC7XzjwugG--3_EXGcs9TrT>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 21 Aug 2026 01:53:19 -0400 (EDT)
Message-ID: <6174efa8-a7ca-4716-8dde-2a9ea95ab870@pobox.com>
Date: Thu, 20 Aug 2026 22:53:19 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/272] 5.15.217-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260820145231.229664293@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/20/26 7:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.217 release.
> There are 272 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 Aug 2026 14:51:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.217-rc1.gz
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
