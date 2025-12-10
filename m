Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201D62FABEE
	for <patches@lists.linux.dev>; Wed, 10 Dec 2025 19:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765395736; cv=none; b=mogxGEZSXEliVT8tlKSeWLNHYh8HzlSrY1rYO5fPFccVl1d7UlAyscSIDQb5y2qkK2vyqQ1kjrGNTVgHKiP8nBCJa4wno/URMydyRvlJNDuP7uTZOY9SYRG3sTzRRihQK2USlAq+fLBtdNZFnnGIAenll6WQpAUhF7tdFUUsnZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765395736; c=relaxed/simple;
	bh=Bjoh0cs9hp+8i2oA+nrPBeqcL2Xj0JTkD+Sc2wWIqE0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NzvvGpG6daK+qH7rpBwyqbYa9oo/on1GDOUJVhIJsViufosAjiBoSlZonyQgnu0ZeOtb29LAcQLKE9uVlAUD0OApdxRfZIcGSd6ksnlh7pKoTYypZYymg3ZFiqDXc/CPEXjUU4hiWzlS9gPV9Gh1AwYm601bksMz0Bnm+3f8kac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J7SY/kHJ; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J7SY/kHJ"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-299d40b0845so3315455ad.3
        for <patches@lists.linux.dev>; Wed, 10 Dec 2025 11:42:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765395733; x=1766000533; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rTXG3UAeZ+4nWsAK7nRjvI8ENM1F6qzEUo7eddhOpFs=;
        b=J7SY/kHJoM6/I3lmQuDejkMt7R6Y3t/lzrEozKSaIesD5vVzgi4DyWxtwhD9oFS3WR
         o17NUBKHuWwtBSAQDmI3te8Yc+FiwmQIg7Y89D74F0D6e1MzRjO9QSr8kY/C/cHzNYLi
         o2AMUHszuf+Nmadh5/6breK3ZGCqJXPPjIyI6hf4ZfrhBFR3AgUMBgC6b0bbVwwxo4YW
         oufPFmDom7jKH3ppXZKTJ47jgGWIj67LXUC4hiifEiBMXZfYzgzDS+5I+BzuWpgq+l3O
         XflL/vN7wBcXDAv27mgVhkNvVTbRmvSwq7SL33CRZGwvfzNz3yhkMR+Z557wuqPWScua
         YMTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765395733; x=1766000533;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rTXG3UAeZ+4nWsAK7nRjvI8ENM1F6qzEUo7eddhOpFs=;
        b=h98NlV8LDcf50lLinpSXH4DDp+lo7y1vs16R1IjdiJTq1Ut6fcmu+BGqNxV+wN+JNx
         pMu7tTf4ddm+VI/eQGxNsCtDHLHbTu+u1VRMx0xTAdNwgaWiiyijZNj/2rCWjAIr45IH
         OpYbq0G74f1ozB/tShSMkJDIHekqRZkhyJxo9muEYS6mgIkcpKdWsEaJQM4b+BssM4FX
         YD9UhypUpUZpctr0h7+Fs3+54ZaYTcg25jG15y157NB2N79hIKjUY+B1kxKtzKl6qvLM
         owEjzf3DB49UNbS8yp8zEzefH9GECsPeze5fk66YBdWWobdrt1tDekuD+K4qGsfvUQeP
         3gQA==
X-Gm-Message-State: AOJu0YyqZHIcDfEhqXTNdNU/NiXUQCyotCP3oxuEGKxhBS3aZMUo1pXy
	gt4hAtbLuZ9rmub+ifO3YIeivyICKCyDxBBvgJR5XzTHETF2F1vbS//r
X-Gm-Gg: AY/fxX5SnAp6TFteGObYuOP/C3NG+nlaWL0sYtZuTZ/F8Qe9Prt2wG9KqDOMsBuOwf4
	0C78GJXambaAo2MfQ3ayvjt/O00tN7VdAyFsORB6zraEg915+q2GAE1xxL0B+b5lyVKVSI1+j7O
	G88EmJO1iOFyNVOh0fkkoRulj9+JhTxvCn43HnefyV4FQgYIDsZcsyHlbmxkiW0xAeJxSTK5Gjb
	ivdmsCpJKpzY/EMQnaf+Quv8DgdndXOkEos314RIdWLdzOhfJFnf0s+LeYKsTzHtN6zSrFa29vg
	cdsY+AuCXoTRkFouUUpWdEkO4/9i9lGCpwRwnbzxdvgH1ORmuUnPTBMXCA4hFyIUXPDGnhuHKgA
	gC4tdqVE5ayJ39ZzPVdBJulguxN2fRXatqibVGFosR/xlJEhFSc69ZrN3sWTLTz0/KYBkbmIF+2
	oH5RHXAAbtZvZgPCtiy/j7e7ZtBlxYl/sY9/lJ9g==
X-Google-Smtp-Source: AGHT+IG8hL7rlUSmacHXNh1bW7WDqPze385dRlSXQp83wkIks0EMXedpKzK0WJcW3BsUifno/jpftA==
X-Received: by 2002:a17:902:dac2:b0:26d:d860:3dae with SMTP id d9443c01a7336-29ec22e3df4mr36371385ad.3.1765395733348;
        Wed, 10 Dec 2025 11:42:13 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29eea01723bsm1436855ad.62.2025.12.10.11.42.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Dec 2025 11:42:10 -0800 (PST)
Message-ID: <4b1a256f-5d1d-489a-9c87-c38b4465a6bc@gmail.com>
Date: Wed, 10 Dec 2025 11:42:08 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 00/29] 6.18.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20251210072944.363788552@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20251210072944.363788552@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/9/25 23:30, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.1 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Dec 2025 07:29:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian
