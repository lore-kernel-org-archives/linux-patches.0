Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4D92BE03C
	for <patches@lists.linux.dev>; Wed,  4 Feb 2026 20:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770235293; cv=none; b=K2MTW2/7xmVcJ4iE39r2bIg1W/i/KF93bqnvqAWnnywx/vfvW82tv9hm13jttfcIi5v7S314qDU4sGY5vSgDKRmInr0fBqj9bXEUuupyKH9RfWicYNA25iqKXdtFSbWk9VMXi7faJcWmDRiFJEOq1E6/h1zraB3deN42uIm4DCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770235293; c=relaxed/simple;
	bh=gHe7WGg7jP1evuumvxETi4DkTpbAy5LF4tiX52x+tm4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GdyiK14XhNemVwIY/zdKbnP22uFILoUM5IipJSJCR5rrK4BwiwXX03qk6fWvNhaNa9/xLZGhrkWqWgT0POO/ITg/dOC6Vg9CD11MQYG04v5knoVJuuMLPMtPNPnbrdq1p6CnSELEuCIcXpAkDl7SgQFDzD9mXZBxRPm8Y7vPNqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OhPUjkmR; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OhPUjkmR"
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-45f171cb842so169429b6e.1
        for <patches@lists.linux.dev>; Wed, 04 Feb 2026 12:01:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770235292; x=1770840092; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ShjD+EC9WPxL6ZuNnhCoKEA5OMjpVlimPEf4qFabAiY=;
        b=OhPUjkmRYYpXj8tAhf34qTLIHKUqUOm5+G1XaxNOZTZTr9zPX7fHaksPQjFjSadkZi
         NaWYOL0O8dVTexuPr0uF8Iz9zyjRS152jWC6MnZE+a/Qa48OdQfAhS2+SnLzyN0wALYm
         TBWrnBsuQBcrk1NEsaqUCD19a/XedgqRwQxuvo6n7wbhPS1XrKCTzOmC7BxuQ8oQ4Xkx
         1yoi1bYrinbYyiSvDTC1Sa2j3goOnTEFElO0lRZM5rThkTpuQdpyR++ZVM/K2Wcy0LKT
         31ZK9jp3obfF+iId2PBy+nklKj3sZfU6IqD3X9Ev93oZ5hUE9oW0HtQvDXHSCJw2GuEk
         sDwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770235292; x=1770840092;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ShjD+EC9WPxL6ZuNnhCoKEA5OMjpVlimPEf4qFabAiY=;
        b=R4ITvPZp1xfEIksh6fXo9j245ZQMHIXsHP0T47yW1MqQcrMS/NgSKY9i1y51ltEbJ0
         Xpcc6rcEmR0Jetl4y3vGSyBU9tt+sYXfJK2Bz6Q7E9lzVoydn12fBX5Y/i+InDi1jShx
         5OsuUGaodLwXcpjyyUnfgG7BDL6iBabGuSXvJobIwcM1dKYbZeH/w6nO3Xb1+TCk8sbK
         9M9s1curYt2L/ygkcCIkfjrH8qSZYuQjx9pENXnZCqG9ctVNUNgKiVcPc/RLXR4+waLL
         f+3MDA1ro4XgcA3J5E/jptBz7aKLOihamxBr27B5ud5piJp5PnN7vGcr5U0mQmzh10IK
         azow==
X-Gm-Message-State: AOJu0YxA6HAWP/GeDzlY3pM1H2pSK2Tdm3JjJPoEpqBl4uSLtpsL9XRf
	aspJmk3iNm+knU4xMgofft5g/xLRPP/E/ufEoQ8qlsdndkPDrt2z0Nyp
X-Gm-Gg: AZuq6aLqbEfRN3OkirYjG4j5DCzAVi44u2zg9zWbRxbpA8GYAYvrI392zi39jLsDy0t
	tmvYJuzPH7lq/qEkhVwLWCXW5eAeiGoC4D88G9TLZQYWrKHu2h3LeZEDETcSSlKlxNN8UmZpW/j
	gHa3g5tRO4MXf6fmadv7VbgAO7kfZlc70DlpffaCd8JCwLQb+UyRFR0cHRj8awQKnxDV/uV0zwE
	nn+Yw526msh699g0oEju9l2pfxqwu5JWqpa70lh1jyH9Mb2UofpeuJfEIKKthR7h1mLtfsQi0Ek
	tTIUfeZW4C3rvp7y/aV41YYmsyHMv2+Gvi/Q3m1b+eoAwsoQZ1sgzYmgcD3cdi0OE9RZaV6MKgm
	kV2+QC82h3PD3knmXAhRVyEQ1CA7Ln6aii67vlo5lFalHOuxfQuEF5h1rSUS1ePiyUFrjjzgj0U
	Ca03w0Ol3XOI4c7X+0EMhMUn7lM+NmRnrkj8PHbQ==
X-Received: by 2002:a05:6808:c0dc:20b0:45f:7ac:12d9 with SMTP id 5614622812f47-462e9ee7eb0mr254456b6e.6.1770235292480;
        Wed, 04 Feb 2026 12:01:32 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-462d677772csm1900394b6e.14.2026.02.04.12.01.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Feb 2026 12:01:31 -0800 (PST)
Message-ID: <a56c47da-d40f-4aea-a7c8-deb2813ca3b8@gmail.com>
Date: Wed, 4 Feb 2026 12:01:29 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/72] 6.6.123-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260204143845.603454952@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260204143845.603454952@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/4/26 06:40, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.123 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Feb 2026 14:38:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.123-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
