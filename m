Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4609322DC2
	for <patches@lists.linux.dev>; Wed, 10 Dec 2025 13:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765371668; cv=none; b=IvoTvMVr1SnUaUuEUj7k7LZzdVMkSTxlyf22+NXWWv4/XO0EFhpv/SFWfAPk1pBK3ANwDpgcdb2BLnx2wikD3ew1nSAGYpCiQhGHxS9p0GKdZJFulygKVG+Uhmq3bt8bdsLAHie9XXPdRSE30PNna0o2g1DSDPnXowZeCeY9hlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765371668; c=relaxed/simple;
	bh=tM0crvOF6uQketKzGcUzJt/x2RnQeslVhRYwL8mMcbQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rbatzwIg4OMPcv3v+q8WsIOOz+Ngrh30bCgfF9r1Lf3x7qcQ5jmDieIzW8Da02iOa49K0yQEtU0R7plznvbCn+nq0iPjGGCTSZtlIispNH1Arg+r3G9ZwzSQvKnNJkEeYyXPH81PI1/Jc2JQJzixvatqvDuxwGPJeN/Bv1iyrdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=mZeKY3fz; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="mZeKY3fz"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-42e2cf93f7dso4836790f8f.1
        for <patches@lists.linux.dev>; Wed, 10 Dec 2025 05:01:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1765371662; x=1765976462; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TCS7GfOmrSOsGr4lczglaWgYwldA9XAo/9uCFN01sH0=;
        b=mZeKY3fzLGQHiT7nD8A/yc4hL6SuxtqQwPf3sdhyb8w4e0Gs0NqucJaEuYFzwVFnxj
         6PTW75VMtXCmfeiVcgFKNfbHNVy8yJssbrvXCaDmFHaJGf3ty0vE2CfrmV93KwIFr2MD
         R0Ps/HHP/hWvucz3Eglf3waHBxa/rnnB5hDBKyH0rW9x6/qgVV9fz7jSsTxHBtXhbf5d
         vSYslQ7xl8MOSwCkfxpZ5K8xXQlGFf+gOBLxfeETeRjJjTECtezjPoGC2zc4F5ei2Sxy
         IzmiCZJG/QQ4A/ywXoyJDMR0WuMttEwWGq1QNH3eBpdroxOHgQl7KvajQ426XcomhNJu
         DCig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765371662; x=1765976462;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TCS7GfOmrSOsGr4lczglaWgYwldA9XAo/9uCFN01sH0=;
        b=L1qaCdnkCNkNUpyDFBiBwg+mu7WLUyBDNibAlCZWvg8KDxZOFFLKrJovLbswIG/+ju
         rJOss8CFUx3kYr6n6BXc7UjcRgkRgBUwHSFDCnVeTJYmBHZ21NJTIjYE4SjQ8tC1ylPv
         Ukq92+hrEt4oOlLVmQDuKAy0zAx5PUIwu3sCCb8FHEGd6BDdFSO9lVd4tA9B6wZUSOQq
         FLO/as+JNJbW0XhRltEequ7g3OeBjqj1BXUwhatmZfduuIcXeQoIKudy/siOPWoJqA18
         TJ4Bggm0GhLdKDyzmrl1ZmbjGdeOT2AhLIAsXtm+DFhsUh72aIZmXOqCueccD4GeoIR3
         sKXQ==
X-Gm-Message-State: AOJu0YxkTq+SxVI+JnnNhXOsIVo06pobJJNMUiDH0vkwxGTHM1yc+onV
	0Pz6xL+pZkMzVbU8sPK/gamTfZ+yFdnhyIfIIHs+Z3Cy69J2Rk7UkV3QSZgv
X-Gm-Gg: AY/fxX4eFhzBhkk7tmTRa/C8S5a7lFmwsqv4izrnGKDrYrw2hDvwEGihF1qeWHLIOek
	CkLQAtPsH6Q9c9oV9hhBWd1xB2xHkeZ7oY/JHN8lFDjB3CiszqNmIvVh63KkaXc8iUr77I9SIj7
	P9lQkN7jGmaacSci0J6HrdjmC9O0u+V/lPwjxVbtKc/wWoSaz2+LB2xsPy/+Cydl7r7AFWofAOm
	VrMbM+lRg4Iw47N3NZUlIUh1hJmaANdLPdQG0pmCkvjhILE82s6xbsGPRvkatSTm3zxbMEWIx5F
	Whh5LgyO/0HpdU08wKCFHP8gMv38joTot/GK22V1jYMYiZmz9zvjgMc3F7Td8yGCDPzb33N3h1Q
	3La7qtVED0DFKZspk3eTT5jF0vo7t39183GISqY504zate8VdPuEpHRitGTI+6F/9Hofe354sfb
	a56g2aPVetuZcWe1OKl5Cl9YrLzrfnffoA6ZeOTMySsw3nF1FVXqKUP6scVQ2s6dKpmFdeY8U9
X-Google-Smtp-Source: AGHT+IFrrlOJCf/V+kYb4fnZRVhRfhFsQIZpmeJrt4yqinm/F5tOB/5end4jHdvM3o6gcosjwWJVcA==
X-Received: by 2002:a05:6000:1845:b0:427:454:43b4 with SMTP id ffacd0b85a97d-42fa3b0512bmr2424961f8f.48.1765371662193;
        Wed, 10 Dec 2025 05:01:02 -0800 (PST)
Received: from [192.168.1.3] (p5b2b444c.dip0.t-ipconnect.de. [91.43.68.76])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7cbe90fdsm36302032f8f.3.2025.12.10.05.00.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Dec 2025 05:01:00 -0800 (PST)
Message-ID: <0e096eed-ae29-462d-9bb2-60c14b7e40c2@googlemail.com>
Date: Wed, 10 Dec 2025 14:00:59 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.17 00/60] 6.17.12-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20251210072947.850479903@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20251210072947.850479903@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 10.12.2025 um 08:29 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.17.12 release.
> There are 60 patches in this series, all will be posted as a response
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
