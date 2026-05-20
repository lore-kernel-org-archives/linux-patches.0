Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E4C35AC0C
	for <patches@lists.linux.dev>; Wed, 20 May 2026 20:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779309235; cv=none; b=tHVLhjC78EBsIZOgWs18/1ADCBhWarx18xhxciOnI6pUy6P1/H5AICBn6P0r2Uu1juwyhA0XsBfhmwt9f8CFDx4P6I/bBQ8pocSV911DFW8doX3DDyVB2cQ5cXSA1BRR/s7vI8FxouMDC+qQL4XhpD3BrA7ZjM5cJXr8l1YY4lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779309235; c=relaxed/simple;
	bh=2U2Lrnq6/mMF6JqqGqPi5ZlHPgVMQhiT+3IyPrsu+nU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ahryaoiO9+vjrtAvj95Ic74AzqefFkk8zSD0WJGAgxA/F4QdOTDnvRqu33bYQkv7Y6EtE2RUKmcEt2VwHI1IY69LUKKC9qByU4LFoha1PJHLPT8Bu2gxeZsD9TAaZ2yrBqAVQN/BgufYyqXh+EYQibKsM+cwBBaezi0Oh91oEW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AUfo003h; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AUfo003h"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-911449d9d03so633888585a.1
        for <patches@lists.linux.dev>; Wed, 20 May 2026 13:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779309233; x=1779914033; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=enS5KHjm0XRPYA+x0TyDaAoN6jo0NHsshdpL/D7e74k=;
        b=AUfo003hDEBk/HSTKzfVAx+FWYHTRMnvqerWkC92CjehJ2WDNFaqQmjRWe7xZdnt2y
         MuHk5Zvt0RlhStjo+XhMnWzo8z5XaN85RO2Aw05vUnaO+gXO6UqhLvrF4dmbq2f4jogn
         XzD+GaqKDeqlQWadl9yZh3LuFvs3BWbtM0tQ1Wxaz+CFs8TxGPqLOi7sNl/T3y8BquJR
         bpR4EpHFOwHI3DFPhyrikvB3a7zlJoHSxBRdk/wQxSCpRkrDDWvoFrSTP8pgg4nJ5CZl
         pjVSa2bADtT+G1x8gvIk6oulfvjrOiGFC0yTEWSPYMyi9C2INUttM1UDDeH/g0usqHGQ
         tOGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779309233; x=1779914033;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=enS5KHjm0XRPYA+x0TyDaAoN6jo0NHsshdpL/D7e74k=;
        b=VsBIjufdnzfKpKdBawKdqxU1W16yxPkRrWFho3pVUhsGHwHatUnOE8ya/VWOwrDam+
         Gxl5IDy/KSBbhQ4GAU6E1NZwCbwAahyOjR1oS4+li1P+8TTC4seoT8duKUOVORRSdxPB
         gl+1kGyQDu8ZpQlP94pFOyjkjm7ARG6ulVNzXKxlSmDEW8+zbDCM7N/qnwQBACDhfBIn
         /EuENhVCbqkwyo01gWQwfGNmMWH7Z5Y+EuuNTT+3ru2sgtWLjxJcGLjBpfe5ODjgkAKz
         /l8U75G1YIhNekJqt2/3Ku5SFkSfdvwpNGERXT/ANhp/iNiJkQgGyM85kkNTlpDTlk9+
         b4tA==
X-Gm-Message-State: AOJu0YwcTV4GsytQmxNGJLuugCWc8ETYLY4OGblc3p5IqVp+q/O2br0Y
	ximvnbxoGFL5BivdWvFvx9fHohJqmbsKR2xDmN9b84evF3/yR+ReAFOO
X-Gm-Gg: Acq92OFD4Zbg/1Txy/gHChxEpcmg/ptWNmbQlYKkxRR4ZrL5MTme8Y09zFr4frhanZq
	MXtImgGlyAPRJrv+fV3PIXhB4iBCesFH8E0PrgIe4xiwtGMRrxOqHCrcmbWKicvGhWquVBeWt23
	phywl19Fdc5wuUvFB69Pb+eak42Tj+l+L+azDu0RdCcRLECIOqkKzmEdXSznl163YE+UpoyyB8z
	I7lLZSh8Qy4ykybRxtJa2mG+ox0Q5GG0beCopuSqzb2eRv7dOaXc7U7ejB4sYhJ8oRhBMAAQNAZ
	bDM7m9Zm7yJGwySODK6yhi2POzZp+SIiFlUoBGOOIGTgChh5/V87WaaPZC2jRptoHcqGxe7uYIw
	EWhclxFuDwTTSh9iV9Uuy6RVPohWd9Fbj+FN27NhdupFAXRiJGeLdPTSmIKXwM96y8MMqUxAWBw
	nVKrSwihmi9BLg4DPIEqdcY8BlP9UQw4RuVnbhvqzMcr4ZjuM7pQ==
X-Received: by 2002:a05:620a:7102:b0:90d:c28d:9666 with SMTP id af79cd13be357-911cf9e0e16mr3452163685a.30.1779309232654;
        Wed, 20 May 2026 13:33:52 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910bae24879sm2382261785a.18.2026.05.20.13.33.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2026 13:33:51 -0700 (PDT)
Message-ID: <fbe52f15-5b34-4e03-88e0-005ae6200a60@gmail.com>
Date: Wed, 20 May 2026 13:33:49 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/508] 6.6.141-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260520162058.573354582@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/20/26 09:17, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.141 release.
> There are 508 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 22 May 2026 16:20:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.141-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

perf fails to build with:

util/symbol-elf.c: In function 'dso__process_kernel_symbol':
util/symbol-elf.c:1379:7: warning: implicit declaration of function 
'dso__rel'; did you mean 'dso__get'? [-Wimplicit-function-declaration]
    if (dso__rel(dso))
        ^~~~~~~~
        dso__get

this is coming from this commit:

commit 8b4beba45e858aa793dd5d4d2e86d60c8c1915e6
Author: Chuck Lever <chuck.lever@oracle.com>
Date:   Mon Mar 23 11:58:04 2026 -0400

     perf tools: Fix module symbol resolution for non-zero .text sh_addr

     [ Upstream commit 9a82bfde4775b7a87cd1a7e791f46f83ae442848 ]

-- 
Florian
