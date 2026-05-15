Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C281730170F
	for <patches@lists.linux.dev>; Fri, 15 May 2026 22:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778884996; cv=none; b=HIO5bVqbvLKITqqyzKB8zu17JozW9Z1GUW72Jw/4SlUiB1Z+YOgoekypp0EzN/0WIWKPr5Q3SxW8biLknZVpvKPMSuRPN/IHw8y0JjDNcNFrysKx1DlhQA6jnysAGHp+/KZ6EVgDOQ4cG3jIvhcdNvhAot6bJ8lXyeEfgZbm56A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778884996; c=relaxed/simple;
	bh=P7yoart6L3Ptt0MALTqzUGKYcd9a9n370pSWilATlCw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Kj9zuMTWELUJS+sW4ONHnvaPr+8JoFBvkk+Yesdi94ieBWRWlLfkRI0fQpxcmTaisLN3rQiEDeuNefizDnN+wTiYxerH1Ml3DkdSyQ2J+Qarica1rCLIPnBnq2UfuRPAVz0r4SvIflzwcKfvwchTv8aPLoizGwpJoGQIQXXKt90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aiyASxDm; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aiyASxDm"
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-479d9b155deso133270b6e.3
        for <patches@lists.linux.dev>; Fri, 15 May 2026 15:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1778884994; x=1779489794; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c9OMOeDr8S/nLTCUWWSGldKz2xqUmkNeXT3iSS9CR2k=;
        b=aiyASxDmHG079iLJHrCbUzQK81OPgHHDw+Fiv9+ahGne2LXtT1s7p9O2R8DVAm4250
         1V6AIQ3HRH+wwkbTuko+A1+yU5GGC3YnSehnMjdpgusO3s0ce/qaESrbGVi0R35bBp3c
         6iigfSRKafX24CpVS5JqXKaXt+QAoE8F9RL84=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778884994; x=1779489794;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c9OMOeDr8S/nLTCUWWSGldKz2xqUmkNeXT3iSS9CR2k=;
        b=O8lglzxw0qUV4dI1PnonEqJX0hckzxrbOa/io+u65sx0WT8K/Mz8kngCgeOo94Hl92
         Q4NiYkpVQVp6tQDi4OWBSbt2oy/wCvuhDO8PMBoj/ACdmtCVCaXqJfk4NU1a4kgZFmVU
         p/d5k+qM4V6BbsKZxy6QaAOlwNfP0uf0UWlMXJkG1eFQ4Lo/gpCOCuRXJwVDVdhqLBEz
         06ejWkcZSl8df1IsnM1OkrGIVfA9D78VmRa983TVXO8KbQdOxVEqsuCxN76YwOqS6Tn7
         BzuQ7dG1582iPxq2nGgsx2ZIPCacef9WMlq5/G3Auh3CWD5bgyLEz4Set7hoGhqlXVPY
         MmCA==
X-Gm-Message-State: AOJu0YzhGYnN2rY1peXf6un+Q43AzziuLrN48i58OFFI+yCe80CcXmaK
	J8jbW6qTxyH7X2mt2PwIMz1dqqGafPTBc2xp9uq2Zt0/6/iy2q3D2fhBMsEf8+724mU=
X-Gm-Gg: Acq92OHONLCxAlxN1/I2e+YoqxAPcoXGdyc3pzO0CmFKqDUb6i3K1eCKDWMipbJdxAW
	Opa//DGGOgSpMgzP4e4s0nwJDLkclBtQl3WN2DCbUAj6IH9ry/8VxUx4cCb+RS9N6vSMK5CRnLL
	opk7oUh8XV1/++zh1cU2c/Y/8h2D+2Y+eF+yYeNVydaaQHGOdSGlxLqxDv2ZnUaKEURI+Vzb2tl
	xjIc1rT1xMUrCAMjhhKcUu922zYoEVxuiVrnVtoEUXsONEk+tEjmiUFTts4tM9HnG6D64MsCx/g
	tXwmcnZujUjNfWEHc+6cEhkr6LRBXdhzIEu3Ogk9+ZuxZYEb2tMehnM+I/34FY+di+EPuiNoEWc
	siBgPjfW2nuuqCTECwLpze1zQ4gNnsg2GFAC9G2emByUtfuVLy17sWWizaW7VfGgxCtjGtr+9+j
	jIpp0n/gewwnyXsZu4uMM79QA3CICXchc=
X-Received: by 2002:a05:6808:228a:b0:479:d16e:961d with SMTP id 5614622812f47-482e563231fmr4169565b6e.20.1778884993749;
        Fri, 15 May 2026 15:43:13 -0700 (PDT)
Received: from [192.168.1.14] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e55bc4983asm2254977a34.26.2026.05.15.15.43.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2026 15:43:12 -0700 (PDT)
Message-ID: <bd75c4a8-aaaf-4072-91bb-fa491a00ecd4@linuxfoundation.org>
Date: Fri, 15 May 2026 16:43:11 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.0 000/201] 7.0.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/15/26 09:46, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.9 release.
> There are 201 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 17 May 2026 15:46:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
