Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5960217C23B
	for <patches@lists.linux.dev>; Wed,  3 Jul 2024 15:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720019159; cv=none; b=D7g3nAHIDgi2IDxweIz23mbN7t4JWd/EcnXaHriady3nCsKeEHJSUDrDif+wbpV5OmSbkiwt7dz+p79bAY78vKOcJU6aothmmqMPE884cQB/El+5jmQE22fTErreki2X9gZLWZo5BglDUSmZkaYERDvWz3UOVI+Ou4bY80kcT3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720019159; c=relaxed/simple;
	bh=B6sujYJQENgveO7tnjCvpEBvHp1f2ksX/jbI4qsbw3k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B6jRZouobOQIUUJSJTtThwChCewRsvZIkEDNYxN8jgzsRGSM0736He8hGagU8hmXUV6TPWiS5X2XKnFTi8X7Czknil4UfR5Aod3q6Qbux2qb0OEY+MnSLe8soU4rtz1PLQzPIU9HdqjXnZuinneUZYMVkR01M9H6fdd6cgAqj8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=OJC3lw1x; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="OJC3lw1x"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-585e774fd3dso4007470a12.0
        for <patches@lists.linux.dev>; Wed, 03 Jul 2024 08:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1720019156; x=1720623956; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OUv04gNK+axs6Kwx3JUMSuV2/tPCNKiXFLMvPtB/z+s=;
        b=OJC3lw1xIiZPgMyipJLQuAyaSRg2W48EM3ZBsrKbST+W43QUD4U6dlS5iGO0lYrUNT
         T1pdt1KdYHHqztzqwg6pujKcL0mZQJCOYvGeFQzuYa9FTzsGAJJYnGA18HYzezCFDX3m
         5t7s9M+jFOiQsALyprf3XbrtCOVQfpXTfEP9PbggHmStxNGmv1zwIzokVOY1rVr3QVy4
         Sa+I/GC1HVIjBGot2ir85rY+emPZIWYKENCSjBIcap4PfD0/QHYn9Hvu63KgFKiRIMed
         J7EbuoA+/WpM05CzlY2eHtJ+OGUzIRVV7iO5ugdxCC6P/PCySbQZC7eZZpdvcA4KXMSc
         KZUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720019156; x=1720623956;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OUv04gNK+axs6Kwx3JUMSuV2/tPCNKiXFLMvPtB/z+s=;
        b=QNrKqblBxxp0z88caYjjIVHSHlaoAHvXlVDFBByoW2L7mUX5v5cdoaK4qmYq9X7Gh0
         HLTstiRdC5bsI91Lw1iA+sStTBmiUAeqOS6NERXSAWUXYFe/JMIwqM49w1ULT01f51Wk
         fTh9ZDbwC6XNOIgVUnOw0V1kK0Uqtanl6/s32HViCFJQQzoGW5JV7W55OhRCWnS94Ka/
         FqbFNa1SOzl9jomBrLwlbr/XUjBOV8EiA+cqfDkQoE6GWHI3HcdJmYZZM6zFfJZGrWSQ
         enzz+GcJBP/kOHHXubtkrnq0r4CDS3rD8pyjRTY+pj/nY5amDhJxnq/FQt1rM6tJ77Go
         EmaA==
X-Gm-Message-State: AOJu0YxAXHHYIugwFnSbHk8zH/78fc0pCJrKQYVTJKMkS54iWiaBwOLs
	GU9t5P3a/QZDPqNybJRpn+k9KIencImUazPgTd7h8BVa90D+aqs=
X-Google-Smtp-Source: AGHT+IHpMD6EDrrI/Wl0zM/QLJIENWXXXmfuMXLQ3fiJHPvoOk3BXQjywm+JvONRLzyxl9UjFiF7hQ==
X-Received: by 2002:a17:906:f88f:b0:a6f:e19:6fb2 with SMTP id a640c23a62f3a-a751443ba6fmr814949866b.29.1720019155086;
        Wed, 03 Jul 2024 08:05:55 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4597.dip0.t-ipconnect.de. [91.43.69.151])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a72aaf63dfbsm513147866b.84.2024.07.03.08.05.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jul 2024 08:05:54 -0700 (PDT)
Message-ID: <e6c07abb-d202-4851-9e33-265e3ab51dc6@googlemail.com>
Date: Wed, 3 Jul 2024 17:05:52 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/163] 6.6.37-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240702170233.048122282@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 02.07.2024 um 19:01 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.37 release.
> There are 163 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>

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
