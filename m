Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F381D7999
	for <patches@lists.linux.dev>; Mon,  8 Sep 2025 03:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757301875; cv=none; b=eTHz7SS+4N0wLyjxHV22gCiDO4DR3nqLpA2fmdcMnCC6gcqcuas9p+IjqEaqWrnEBWXisrY/sWi9NwdCFNLfJBmCasm75RhzXFzKRlpmrKMHfEDwPSo/Hi15jnVSAEeeS8djZ74Rwn0+6e5DATlbyJOCoxpA5QZkKdN/DAoOLNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757301875; c=relaxed/simple;
	bh=4KMKE3rf7nGiE4o9mzO76A86cw0C5sJX1SugltkYX9E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DgRvA3xNXCP8e5In+hiDmqtP9d/3s6iVVDe+WYjcefwnLmEN36OVyybg/r6e9qW0RYbUacSeZpN8WA0djaYugvXuIHld0cb9QIParYnhocqQxON+vFz1U/ypvHiZRNBvAXadBtF4GnPqS6KCwR34iiu8o9TEL9B/IJmQXye43g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y+X9sI09; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y+X9sI09"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-244580523a0so40014085ad.1
        for <patches@lists.linux.dev>; Sun, 07 Sep 2025 20:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757301874; x=1757906674; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1YdlViIZHKUzYpjlo2f7uFhrNB8IK0wvfe/kRf2ExMM=;
        b=Y+X9sI09ZXltKaZSszhwSgViBnifmdmv7odLa48E53Bv6GPUdFpROgLIY8+BemRPLN
         VsDtYA59RHKqKfXdDQ4v2auO0K83n0wEcWVCrqztvlePwkNT9RjNTrX0kiulRTg32tXB
         qq7E7orRgZiQ86lQ36tOwvP8449HpXy4oLa3ISKyGeEnMfg71sMJhH11WaCfNF5oQVdV
         /J7F7XqpJ6nOwx5y2+GqNzQeKZMb6wCQzIer5NAd3v3ULldeQM47AtznQPoPSP7fhc/U
         P8/ZqfBCzQNnJ+EO8HRC+LiP1vCDOwW1WnoeMd6xUCJjuAFngWos61oWlwXXzugUU0qn
         Xxpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757301874; x=1757906674;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1YdlViIZHKUzYpjlo2f7uFhrNB8IK0wvfe/kRf2ExMM=;
        b=cjc76bDcBDauqhJji5V4xDH6rtT0wrsRsV6PefL3dHvLqSHkQKtITzlz/6ENq9Hlse
         m1bQ5bGUmp8PJC3CM1YYfqHXCwSHW/JWCFt03YI4zvsy36y8Z2y7b7qj1qk4+UJ5r1nL
         uT7aCM/LLJ20eUhTg6Zzha1j15eX01TlgoK8o5AposVC1PguPKr9eN+VsJ6ipHs4/Fgf
         dzKy6BafbbmAuUVS+nGRynW1lB3bFoo9bceKMiwTN08xRdEcNkatMtUskhjrdcDHijRf
         b2CAGeZ0NbtDCGFn/O8RtgWFR9If2ew4S8khWV2Alc0HVyL4k81XBS4QRJfiMP8aWqxU
         uAJw==
X-Gm-Message-State: AOJu0YyNkvHOBjUxljdu6CRP0+Ggvb4hsuNTGapUfkmtlDVGqatWwuys
	CRDkgy3dgRxMqEf4El5NeibbY3F+WiU4YfWvPC3diJDXraQNw2ABIj8I
X-Gm-Gg: ASbGncu0udhH63Z4rmPvtRlNPwZp1csKD40M0ffj5upg+ajElqScTn3elC+sWpUqVY0
	x69jwUrj/MFNVI41mf/KRYUbmvkr99rBe7Jxb1v5g1UrdGhzKZSDG4QJKm/QW3HcYAxMUzYJeLo
	VDFaOc69vqXY0ZYHGPmsI6qw4gTJLSyzqGeoAFQP8usFSLOwCztYbBI6KNoCqNTQ6xWUQ/nrjar
	1PPXQrOIRvyAZCZS/RkvkhypCnkkQlO6RD2USsJn5R/SMAZhk7NqVS+V54AlTC0ewSOIV0y7Lxa
	TEorHwoYKwwDPyiapYkqJYSDXV4ppQIyM39lhq/sF8SmV9Ywp91gpDcpA75V6rWDDOVKUwWDRHN
	0kAX8xOV4+nnN2mM3aD/j6Nf/4QpyHBdNn3NTRTDqIyQurq7PZgsP9lPiE5AHK6OV
X-Google-Smtp-Source: AGHT+IH1B5ZE2vW99JA0qH8CCygG0lWswOWJA8nDyDWgxquAxw+pqFuu9wOxwpISgnD3lkc1Gw2lFQ==
X-Received: by 2002:a17:903:2b03:b0:24c:e3bf:b456 with SMTP id d9443c01a7336-2516da0618dmr95348025ad.15.1757301873762;
        Sun, 07 Sep 2025 20:24:33 -0700 (PDT)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-252a0e700a7sm42273775ad.15.2025.09.07.20.24.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Sep 2025 20:24:33 -0700 (PDT)
Message-ID: <ed431dd0-b044-4923-80a0-63abe0309f78@gmail.com>
Date: Sun, 7 Sep 2025 20:24:26 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/121] 6.6.105-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250907195609.817339617@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/7/2025 12:57 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.105 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.105-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Same perf build error for 6.6 as reported for 6.1:

util/bpf-utils.c: In function 'get_bpf_prog_info_linear':
util/bpf-utils.c:129:26: error: '__MAX_BPF_PROG_TYPE' undeclared (first 
use in this function); did you mean 'MAX_BPF_LINK_TYPE'?
   129 |         if (info.type >= __MAX_BPF_PROG_TYPE)
       |                          ^~~~~~~~~~~~~~~~~~~
       |                          MAX_BPF_LINK_TYPE


caused by ce6db078aeb919d5fff7846e18bda2307c8a6ba9 ("perf bpf-utils: 
Harden get_bpf_prog_info_linear")
-- 
Florian

