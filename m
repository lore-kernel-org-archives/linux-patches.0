Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91FC334750C
	for <patches@lists.linux.dev>; Tue,  3 Mar 2026 19:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772566010; cv=none; b=r0YjOmXwfxSA7aiPcfn8LUkjaF5gdygKLx9L2R8E4ukMBNfA1Owl+X41vPKU3Dr5jcTa7jGMytyaGJVvvKUETEhpEkjvtLByn2III/NhN7BxSbgFnCiK2OFUrB+hyzShxhLWyr/viZTnfzUMnAfoWsnIQaAFQyKbqtYnw4ZEw1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772566010; c=relaxed/simple;
	bh=rIPO1Kqv6O4QEa2oBwkvHIqVo4fKVDHYOJoqlRTAqi0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZvU9jpf4IP6DJ5TjaLd413cOWDIEu3N/fCxiHsDv5FVxQhMhizbhseL5VYr5dyFyx0UycKgt+BSdbpC2gmZUFmJbRjDzLHRUoxQRe8dulee1JIgt3RFz5QtMPW16iZiBzgToRbU1/77nxSpiRelUV2Ek9Z1+TUBqSGqKeZU3MK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bpSCzOVK; arc=none smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bpSCzOVK"
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-40f1a1f77a6so795975fac.2
        for <patches@lists.linux.dev>; Tue, 03 Mar 2026 11:26:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1772566005; x=1773170805; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R28fSbZ/y9OH3agGYv0rHtrb5fNITiawjIip5HJdbIU=;
        b=bpSCzOVK1TupK4wVL2ugcG6r+u1EBlEZDWZR1p99nzAxSivlyCMM9ktB+CeYmOpY7Z
         hWg0rDerHUKh+XOR0cHI5j5oqsDB27M8x8tvIMnCLp4NXChnVa1EmNHD9Xnf49GXfPQt
         93N1X3krGkBB9k8qSo6ZAeNM89A0HwlPNbAnA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772566005; x=1773170805;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R28fSbZ/y9OH3agGYv0rHtrb5fNITiawjIip5HJdbIU=;
        b=owIvFvj19muWE8tvVI0esBnn/RaIl8kRQD0u8NHgvAQbugOfCptS2Yc7ZseLKP4Dau
         CHshc69y5IwyCEKIl1upDs9bQPYkuTi8txHEzW5QLxX6ZGxZ4b0IAqUmDZWPb1p/F4oo
         4p03M6UCQOnRFnbQUvM6RcHIAlE6gPVTyVoasy2TLavluh0T8rop6/ZbeYIS2NuGqHox
         U2BkfaSTUU76ZxncZOwTLt0SgoylgHRkhREz7RwDWzqhAQGBD3gI52tI4s2fB504DSqV
         NwhjpWthhQ2mswvLYWf5oaUbWjrgP7QNZWzw4YMFF64pyyAUuAM3j2LgQT1mHvGagJgV
         1EyA==
X-Forwarded-Encrypted: i=1; AJvYcCVl5TrWwvNSqQWRXeWxnwrk/aTVw5JtvCpF9z+iAETh8Mo1t9YpR5iPyPIub5hyqpEhTYjSgu3U@lists.linux.dev
X-Gm-Message-State: AOJu0YwDE0xM9+8dH0yFlmwXQk7GZryz0hbhbMBHwfUEwGkmdWELDDK3
	luA7NUTXJ6pKMxpqKj3QYN/lBTzfCTFz1lwZFw9isms5ewNEzOcYN/B5OVvIU3EFZ4o=
X-Gm-Gg: ATEYQzxLtMilbnGJHZ3Z+TS8qQEU0MRxpaz7nhVIClQhhuTM0FtaASm8EjwKMP59lj4
	333ijZal5nd1+DPwbkhsyr+htEP4EFUkemkT0ruoV1kcRqCw4qvMfH2GMUCaeEFHt9acV4jpmz1
	xO8SljgzjJESYNlIK0WIbHHA+HCTkxW47NkCGuMoGFbKkICnA8Iin37JwadtU4MIjqbVEpWvxV4
	NyTWKfgT3QxRIjuZ2BwSnci2ZPjLE7OpGa/VIQ4UDuZNZZyODTHKX1d2cHfn47cFLN55U2CMKxA
	+DP5vG4oe8Nb+uMTiJWmIYBghI7X8ky5Yc/6JggvYX1LQWtnzIRAG4m7f8RNPRGVUtmH1aP7ZAc
	z9KfzmMi9PmiWk9Q2CVzS9AG79bv3oe9bv1iQqkRgKFcgp0f2tgrehR8PL8xjKSJ6cWUGyGt9IR
	DmJ8f8nkimwilbHFeu8e6CJ+++fuIYkj6eRZE=
X-Received: by 2002:a05:6870:c26d:b0:40e:95b9:40e6 with SMTP id 586e51a60fabf-416270fec36mr11373030fac.40.1772566005464;
        Tue, 03 Mar 2026 11:26:45 -0800 (PST)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4160d20ec7fsm15796275fac.11.2026.03.03.11.26.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2026 11:26:44 -0800 (PST)
Message-ID: <83675329-87ed-43c9-aefd-7ffc0436da1f@linuxfoundation.org>
Date: Tue, 3 Mar 2026 12:26:43 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/956] 6.12.75-rc2 review
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260302160918.2520730-1-sashal@kernel.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260302160918.2520730-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/2/26 09:09, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 6.12.75 release.
> There are 956 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed Mar  4 04:09:04 PM UTC 2026.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-6.12.y&id2=v6.12.74
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
