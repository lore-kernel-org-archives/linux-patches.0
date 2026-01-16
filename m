Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B331DB125
	for <patches@lists.linux.dev>; Fri, 16 Jan 2026 12:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768566542; cv=none; b=sDdEzgyPAbHSW39zOGCEW9ox3HJpSliLSrzBHksG6wKi1JrIreS2cMTitWJw79qi9x4xC3sVwrHlC4ZfGlfsCOIUgQDa/F0OThjT/a7HQ2Z4hhEIh3aFDWxSvmvNyBAIYHuDZwySA9r1JqY1SaLhuXbrNOvNRwjgPxvT15BEqRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768566542; c=relaxed/simple;
	bh=8lihPPXddl4nXmkS+7M3Ov5OGAJiiGJ4AEFErABQcsg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HM10/n6f72beMFPXOJGQmDONbHiLCrzYmSR3mW3Z8D1+v+BX9N/xWT/Fs4HKCKkUEAUZ6y5VnIdiY6NjYn+kdgGF6fFDy0oojSmUCEPInKO2I3PS9BSxQ9l87rqq0LcWXq2yMDL4WKQnBYHcaK63NaSWP4qvEO5bCOxssiYPE+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=hQ1QSpTS; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="hQ1QSpTS"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-430f5ecaa08so984714f8f.3
        for <patches@lists.linux.dev>; Fri, 16 Jan 2026 04:29:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1768566540; x=1769171340; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=v2vIcNHIpTLIvJVy+m8iWxg+GbYuo6KoiowqnHlQO3o=;
        b=hQ1QSpTSry4NIsE0fBjKkiaiTy4C1vIvcpHqb/A9ejl3zmmcoanRpOpkTSsTg+MUe2
         f9t8CDxHjh2REpCw5TXz/o4NmAjT9QFfKL3QJ/CgZviULO4MIL9aNpihRQLIL5itIRH4
         3q542/xbkhE8QWcX/cplc+vSbOsasQv7FKlVbG97UnsSQxmEW3GK8dPC4ovFu0yxwnQG
         DENocLk3AVjIf4kZ6wbVO6b2f18vrdpFo/WYg0+UyLj8yPgvY1QqD0inr8ygtpumxX7j
         ZtHsezirgE81GSq43u3N9+TCoWKU81S8YXE9PcnqOnRXvVr/muG41+CwrXU/rY5fQAWr
         F3tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768566540; x=1769171340;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v2vIcNHIpTLIvJVy+m8iWxg+GbYuo6KoiowqnHlQO3o=;
        b=KFhFH0VKKsup7rvkhV5BVhE8KqWmERwHY0SSMTlK/bpebvpsNyhxQ6mDPYfPxEwzKt
         GAuq+rmitUa067PFrhVJ0xOp4/1hqL3C5746lijzpEg9Ld4b4j4LjfAFbaTcnkI2s+c1
         9oPpqYleryfon88PtJ8PBPnndJ/2YbYe0tQqwv7+y7gX2sSAm8JoFJqvN+EyK6p5TbAa
         IN2KFw9/23LvQP5SbztNyPbP7ka77Ex1nujM1rBY4/ghtRh1WSLJDZu+KAGIwmEEHxnU
         18hGPS/ehTJtW5eGtErNntpDnFFX0qNVknVZWzEoGiytDhkJKezSqU8UlSM11pDeV6XJ
         jeyQ==
X-Gm-Message-State: AOJu0Yyr8LDbx5+/J5Cqwh8s3x9e06uZOKCg1KnF8y8xAvHwc2hzl9/J
	v9grodPTPezCWj9l+3u2slJbmfsENEeM1MASJlKBGKGdWrHQqF4miUk=
X-Gm-Gg: AY/fxX5mjMc9IJuwldzHSJus/6cgTMIj6ydgesX4mKxG4DvEWhQ+gyVE8+rcSarwbcF
	uUwQKcwqCopd/NaOy1T17+ERinGrL0/5eLPWEZP8zjGI8aOwtjJop3S7h646N3Zk8RLHDCMzjdF
	37R6/+rd5c2sD1BVzZPu7dfbXblhKYzaXOXkZZkAFrT1N22l1FW3Bp2S8E5ZAotzMd7rxfxwqRw
	oK+oEFHVBYhrxpzkYSsSzeJoJmDMJ2a1SYNIIrXIEqz977fOfpX1KwVNj4akTie8tx0cwFYO8lR
	bULcow8Gwb0UAZS/z22v3DsNNA66BCoX3EAxS+YHE+kLseskBrCP4ba13LdvqsTI0eLI656HuDi
	WMC/J+0MWjHIFI756aJ3hmf9d3kiUDwb4NV8s3UVnr3N1HTwq3Tiq9T8PS1+ox6GkJLzmdLcpdm
	Tyq5PhGtU44aoKLRzHdhobYaS+jOqfPbzsuz0W5hKpCGSFobclMCsjW6NgY/IZBqMn
X-Received: by 2002:a05:6000:220d:b0:431:67d:5390 with SMTP id ffacd0b85a97d-4356a05d93fmr3352032f8f.54.1768566539478;
        Fri, 16 Jan 2026 04:28:59 -0800 (PST)
Received: from [192.168.1.3] (p5b2ac8bd.dip0.t-ipconnect.de. [91.42.200.189])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43569921f6esm5091253f8f.4.2026.01.16.04.28.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jan 2026 04:28:59 -0800 (PST)
Message-ID: <1d9842ea-2705-4232-9082-244d4dc4e69e@googlemail.com>
Date: Fri, 16 Jan 2026 13:28:58 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 000/181] 6.18.6-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260115164202.305475649@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 15.01.2026 um 17:45 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.6 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
