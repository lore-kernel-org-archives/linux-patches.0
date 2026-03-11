Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108533E2743
	for <patches@lists.linux.dev>; Wed, 11 Mar 2026 16:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773247640; cv=none; b=HjOXAtTDuVJnD+A9drzT/hxv8fsF1ZvtvSdOaTVcs1GiDVJWgbgHhHPrn6F/pDHquIlWwO29srdsXnfYoD3U7M3SJBpFF1f3TSwe5zN0K1LnmFSn4GQKrHJRdwxl/EOi+DvxNcXjtpqj/JpmibMffe8+87gZuIQ++M7e2IZXHI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773247640; c=relaxed/simple;
	bh=07KoFmIiZuLE0r78+cnohMeu/H1TK9ZRpKNMrm4Ua8g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OIOKZtShOZwnINIln+QlFE4Y5A8jLp8kWbVA+22mqvbc3IQ1UXayURWSlK+LCHL1Y/fZRDJomqhdoW0+Mp+hM6Q4zZLPJ69Pac01BM62lB35wxJCVHslvxky1+gr8mI8Z8F3m2hlLWo7ysuPaph3HtJWz6sOi3PtDc1iFYEAzeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UTqJhyHm; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UTqJhyHm"
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-464bc03efd8so64968b6e.2
        for <patches@lists.linux.dev>; Wed, 11 Mar 2026 09:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773247638; x=1773852438; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yioi7HyRyHO1HEe3ML/SgM5AjwSP20V3T57RuvHWGvc=;
        b=UTqJhyHmBFS4r35lZo9nbHpZ+a6OoKia6ttv37cYeHl6TnezfsGeco+MdfUZUBJw7h
         2BznxQtjkglw+Hn9nY1G4kHbH6zrPLbdlphap/R48TQulWXQBFgr/3z2Bxk4fQkRkXme
         qPPg9Q8nTis5HcoBu1vxsooyzMB+9hFjGBvy8gM8M5N8SmRLcRQY7/O5uM51P1JwGWT2
         Ni1ad23I/8gHEYdaObS5UCVEZNA7+HhjyOd436NZhumuGZZpF/aoo6FIYgj/EnaHshiL
         +rhfH0/sCssDzsviPmIRhtnEVx23A5J5SBjZhoxLfXNkQ4dbrctrYI5tb86CUXLKra1y
         4NYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773247638; x=1773852438;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yioi7HyRyHO1HEe3ML/SgM5AjwSP20V3T57RuvHWGvc=;
        b=igvEVgXctD1jnfC0LJNGjLTNzeEn3NzpR/kXdkDMZAPfflIKk9HRWTVSczDRogLn/F
         p6cxeJBWKq9SbO2raZ6xrI5QpBXsGq/zMmcd103oybbXYf4pV8x8hE5FOWIq+m40MUY0
         onqRP8UBe3Ys9cQskT6pTfcx64lgpfiQz9M8lFJbSaIKrAUia4z5kdOVCAjXxqopVDbk
         tmLFyw9l8P8fzfjLZLzNDGvw5YRSPnIsj6nfv/4hDWMoh7gHtgecqFyvp3yl9PpmFwDT
         VijIlA7DuQHY9Yn79GRSch4HkiK9Lft8LcxrCWMEDglZ52C10m7eeG+h/L0c15RlHiMO
         cf3A==
X-Forwarded-Encrypted: i=1; AJvYcCU38AHdM5J/ASB4XyrMY1xXR8ujj7HtlJgSdq205mLjsk2RtD+p1wwnNHA61NK6SicX3euqmlrv@lists.linux.dev
X-Gm-Message-State: AOJu0YyJq7LgmgTzTeH+6vvTlWfzWUGOCyYb/ovtJ6Kd9mWAcNmBCtOH
	veXXiPKT3jPXTde5mXnEk9EhwHLhsrlv1Y7dzoqDyDiFklALW8I886nx
X-Gm-Gg: ATEYQzw3UjcIpgtT41zE5yyzyqKZw6en09AQDynTkC+tlVoF4y9hru7s9kdktUnM6tx
	7/ryYZftEnPl++Vumb4/eNiLD7Dmkas1Fc1ChEOldtQE+OkoC3GAn/K33lZOtezkXbmTf6cME2J
	9aePKlvFl2SUl1ev8KoPJnaF+wArrtE6VlJNbRpwJm3Fpy/czEVc7EKkTbsTOW+vUIITQXRKNlo
	fXfPf/ko6N4iuD5LPbjq/Zk3qTfRkF/kV2AGZ7llHnVXNEuAX5bdUYJZx7I8Ni83FB5QzZM4yjp
	STfrHOJFJQavCpDJENDhHBPJ8TzcdQn6mtIvEh5Rf44nG+rECXA8DNY0WFTVNk3BR06BjU1qfxm
	6M9AM9ViclgeEAZDmwj6Mvy0GbrtMOUUYC6G4c3/w/5mlnfdeBExeJZioMCGXY2n+8zRJBOZ1pz
	o/ZXwc46/J4EiDNtwTKuDtAV6ty78GB8OU6Xm5aA7BPzGNoOpCCtup7c5QcgNKoo6bG6Dkt79Pb
	Lj0sAb3O9JogcHL0AquTg==
X-Received: by 2002:a05:6808:d50:b0:450:89ee:922c with SMTP id 5614622812f47-4673349d5dfmr1873647b6e.27.1773247638017;
        Wed, 11 Mar 2026 09:47:18 -0700 (PDT)
Received: from [192.168.1.228] (76-214-69-104.lightspeed.irvnca.sbcglobal.net. [76.214.69.104])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-46734343f69sm1500624b6e.19.2026.03.11.09.47.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2026 09:47:17 -0700 (PDT)
Message-ID: <97a13d4f-e1ee-42f5-ab90-d6dc589ecefc@gmail.com>
Date: Wed, 11 Mar 2026 09:47:16 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 000/311] 6.19.7-rc1 review
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <cover.1773140654.git.sashal@kernel.org>
 <75302bf4-3f06-4e9a-8d05-1706d60f44c6@gmail.com> <abDACatouF12XBX5@laps>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <abDACatouF12XBX5@laps>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 3/10/2026 6:06 PM, Sasha Levin wrote:
> On Tue, Mar 10, 2026 at 12:09:32PM -0700, Florian Fainelli wrote:
>> On 3/10/26 04:05, Sasha Levin wrote:
>>>
>>> This is the start of the stable review cycle for the 6.19.7 release.
>>> There are 311 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Thu Mar 12 11:04:16 AM UTC 2026.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux- 
>>> stable-rc.git/rawdiff/?id=linux-6.19.y&id2=v6.19.6
>>> or in the git tree and branch at:
>>>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux- 
>>> stable-rc.git linux-6.19.y
>>> and the diffstat can be found below.
>>>
>>> Thanks,
>>> Sasha
>>>
>>> -------------
>> perf fails to build the pmu-events for all of the freescale SoCs, I am 
>> not sure yet whether this is a build environment issue or a genuine 
>> perf build system failure:
> 
> Could you try building with a revert of b56111d7a464 ("perf jevents: Handle
> deleted JSONS in out of source builds") please?
> 

Yes that does resolve it, thanks!
-- 
Florian

