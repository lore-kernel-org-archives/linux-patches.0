Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51C328F3
	for <patches@lists.linux.dev>; Thu,  1 May 2025 00:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746059261; cv=none; b=nZm2lq0Qk1M85fErnZdYPWYw4v2HwJdB07kivH6ny2GX82iKsJQ2Dx9HQO1QZfSFeUE+6hh8GEv4L50CBCA3epLAh0yZiVkHw+2ym49ycEg0uPfqWJMyF3Bq+VbeEf/dFvtBGMiY3Xpp6xMCJ2FnHl9M7TAAkdAJb4e1UHqOKhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746059261; c=relaxed/simple;
	bh=3qCoJ178Z7gk/rbv63q/1lEWRjc1f6t1/wwee5fYFCo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dapVS6J8VTTUf+RgIg9Gl4sQQh7BlV2HMkCboK46MdboQOMj9pyltA65b94/CmIIUqOQsVjxJiIPrgGMj+Xqh6zO0Y/BfZKUtpLIzDSoFNdIxvxTeG60PsXJ/sRLAth3HarPie9XGNW5zye3uMj97RZZIlqarnAhHLHPy6m+B0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=m4kBEpvj; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="m4kBEpvj"
Received: from eig-obgw-5010a.ext.cloudfilter.net ([10.0.29.199])
	by cmsmtp with ESMTPS
	id AFy7uHgyUVkcRAHm6uxZVm; Thu, 01 May 2025 00:27:38 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id AHm5u3nAXp1aBAHm6uUAtR; Thu, 01 May 2025 00:27:38 +0000
X-Authority-Analysis: v=2.4 cv=Y7T+sAeN c=1 sm=1 tr=0 ts=6812bffa
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=ag1SF4gXAAAA:8 a=KKAkSRfTAAAA:8 a=li4jrcibAAyYMYvLDh0A:9 a=QEXdDO2ut3YA:10
 a=Yupwre4RP9_Eg_Bd0iYG:22 a=cvBusfyB2V15izCimMoJ:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=LyCE1iqQqEWnubMvC1RAKL8kOYVncbxcyXyBW0mRCXU=; b=m4kBEpvjhqmQrWKdN5rcmXkHFN
	W55vB8A4E2Dyiv0Kdt5qHRKEqy7u0K/tnF6T7xlRQhVKrHzouviw/rCqR6pIYv7Re8kRfeXGS5Dgs
	HZa5IqGIwwvXCCqgFuYB7qQCxVfu3AfAMq0i/bA/KpCxfAkhDPRjHbpRibdd4c4cPhZJvMmB/3Wk6
	EylOuLUYZZm1jWg7EIwNr3Pl43cUuH5sBVbLg49r4HZpv+eO2yThK/Xew9QTaDGTaYAg316UXV+CG
	2ZgP2cHloPa/u52PcojDyyTvRdiZnxz3TxuvrsAWeg7Yr4LPMH1KcnwU7DfLAp5WEgayVVpsrgP2w
	26R/uFbw==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:59318 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1uAHm3-00000001t8j-1jM0;
	Wed, 30 Apr 2025 18:27:35 -0600
Message-ID: <44f876a3-7229-4320-8715-e49a122aa2ea@w6rz.net>
Date: Wed, 30 Apr 2025 17:27:31 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/204] 6.6.89-rc1 review
To: Naresh Kamboju <naresh.kamboju@linaro.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org
References: <20250429161059.396852607@linuxfoundation.org>
 <CA+G9fYs2AK7jGyJ-kR884-CJA3RRLLWD8r1L5fKLYn68TSQ1ow@mail.gmail.com>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <CA+G9fYs2AK7jGyJ-kR884-CJA3RRLLWD8r1L5fKLYn68TSQ1ow@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.223.253.157
X-Source-L: No
X-Exim-ID: 1uAHm3-00000001t8j-1jM0
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:59318
X-Source-Auth: re@w6rz.net
X-Email-Count: 17
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfDm5ezfunICT6M9YXDxhe+kvVy2yiKz5Wwh42E+EeevwYVlmcz8z0AU5Rtb+/zl7lNcAsnBDpSWxHe9f/oypLq1osaeJa0TOpG4F8Z4OGuEsiVUFYF7z
 yu+eXD3id+TJOxkTm4AJ4JB1mPEfalcubVyjW10A4GeSC6cITa7yI5fEFxcTQR+MjmiRUTg9Qgrncw==

On 4/30/25 10:59, Naresh Kamboju wrote:
> On Tue, 29 Apr 2025 at 23:41, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>> This is the start of the stable review cycle for the 6.6.89 release.
>> There are 204 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu, 01 May 2025 16:10:15 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>          https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.89-rc1.gz
>> or in the git tree and branch at:
>>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
>
> Following two build regressions found one on riscv and s390.
>
> 1)
> Regressions on riscv build with allyesconfig and allmodconfig with toolchains
> gcc-13 and clang-20 failed on stable-rc 6.6.89-rc1.
>
> * riscv, build
>    - clang-20-allmodconfig
>    - gcc-13-allmodconfig
>    - gcc-13-allyesconfig
>
> Regression Analysis:
>   - New regression? Yes
>   - Reproducibility? Yes
>
> Build regression: riscv uprobes.c error unused variable 'start'
>
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> ## Build error riscv
> arch/riscv/kernel/probes/uprobes.c: In function 'arch_uprobe_copy_ixol':
> arch/riscv/kernel/probes/uprobes.c:170:23: error: unused variable
> 'start' [-Werror=unused-variable]
>    170 |         unsigned long start = (unsigned long)dst;
>        |                       ^~~~~
> cc1: all warnings being treated as errors

This warning is caused by not having the fixup patch "riscv: Replace 
function-like macro by static inline function" upstream commit 
121f34341d396b666d8a90b24768b40e08ca0d61 in 6.6.89-rc1, 6.1.136-rc1 and 
5.15.181-rc1. Looks like it didn't apply cleanly to those versions.

The fixup patch was included in 6.14.5-rc1 and 6.12.26-rc1.

