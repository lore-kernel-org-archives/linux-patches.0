Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D6F14A8B
	for <patches@lists.linux.dev>; Wed,  4 Feb 2026 23:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770248378; cv=none; b=fzEQrIPOlH7j0Ah31QN+EhETYGrvaEW109fWaHbX5NT+L7DQ1ar9UATWhgv4fwrqZRi06aK8pctx0lDqBa1JyjN51qG61L0NreU6qQ4KmoUGZh1zYji+drxNezq2ZEcuqLfkZX28KHBgAcckXG9YZGJaC/1HGpiTKxY0CsXK7iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770248378; c=relaxed/simple;
	bh=8NwPCPG7I61+w0yefaU/qL3EzxyKUqb36ha1hjf1lMw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bpnCAKfx9hcpOJ/zA7qTKYZkBUNx2mQeHGXGjYnritQsO3oe47lvcKc3yS3JiBUjv0ugOlT+JEK0t9jxKs348KROJcFlOe1N8bwouvCH+y/GrEIdYRf1WptTJYpMkJKim7VJ2myvTaIoSrFtw7mOYj/2Me4Ti0zwDYK2GVPhrCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=hfEVfEdq; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="hfEVfEdq"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4806bf39419so8441125e9.1
        for <patches@lists.linux.dev>; Wed, 04 Feb 2026 15:39:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1770248376; x=1770853176; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ssmrgUH8rK8nzJBIo2+8RdqGcLD9sPXKrHtgFJOyxOw=;
        b=hfEVfEdqmjzLBTaVHRmd86Jlqpuo7kI6RYWJHj7M62uybBxilLJ8H0PuyS8IFaddCG
         P7tdQ2TZvKYA+t+pgCFVqMPpECxMNJhix4QSF/xOmgJXqgJo83rRfoWOSc3iz0tq7104
         rLohUIIetoEK4pK5Gsn+UgKtMtjMtGzLv4hEwNxmg/RKB+453mvzxfGeAsGK1CX8P3ok
         4E3+bLYQYCzV/INpAI8aGX81L4Qc+NoarL+Kxe3xwGgMqLKiesjZlajLf7JP7NN9LHnG
         uvfh5oTUVhbZxSBhmAUNjuTpAN1YCJ5Bo4ZXJJFhqCqpVo9j3zAX0QDQPXKuNQXAicJ3
         41MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770248376; x=1770853176;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ssmrgUH8rK8nzJBIo2+8RdqGcLD9sPXKrHtgFJOyxOw=;
        b=YA4w3ySgPM5lfn6COk0TnD5fTIyZnFYRD9iFRhsz7xjJEtwglEVJcYm2fxcdk61ALB
         RKb/Aa3iSaVqqP7PrhmKFsisPrQO6c3sqX3eUMSUYLMmVARzu3Gwg0oknRnUpgFI2KTq
         ziEl1Eo96cEKm43PG9vPyMuPMzylQMswOr+ZCDZQH5t5dNPC893VohkFIldA3HSY5c8k
         xPkho+Z2R92LMXx2Vc8IQ3olLAnaPqDJAozejmsPW1Oeg+EhL9TOYZCNSLJhcKdwm3JW
         ioJilgB5bc3YT1f0SdE/HrH+kZKTqDYcsHqXc4OTsWAa7bOef39w7eIKKo8Br1OM6bYx
         w/CA==
X-Gm-Message-State: AOJu0Yw175tpVEDXGD3JbYxtRWITm+mGEw+icwG4yCiNasDTriXF3sa9
	NRz+caFRbiviAiOZEKZS76eJv6LJonCOy5eJrYuDZQFFni8U5JQpxdo=
X-Gm-Gg: AZuq6aKZTA5k3CAN8/5ipst8znkD0M0fhlhJjj4LvPjQQUILzhbcXpqPKJp1VyZB0T6
	xPBDn2nvLu2/1SIH6bGTyBUk0K/+qtF5hlKF4MHq+8D1QpkdEFU8rw4FoK7wqfnCyXQQS5YyD2X
	kPaZcPuzjka1WcW0cCCSvyowPEp8Z3wiU6dU1R22RzVDbsMALT5ZPRNdh8Nv3pOpD03V66KedEk
	nF4gTteFOR2vqOSK03KjrRJCjmI1tFPyREXnoRqjyg2jdBKC5BwsDF3qQw4M9EQI6iNivaNU3e0
	NIDsl8kLGDF4DGm7iqWrTND5sLoIXsuh4KASglpGvYQEHZuL5iyKqtbY0gywI38MWmAh5xGXcGM
	5b4F8g2xKDW/WsZm6E6pHdo50HtQgTVvu8hrhyACWdVenKWUBVBUlgvjxq7eqPWm3yrmqXSBm6s
	fqF0jLrCjAA1ylIeQTnMS3XdLQt3m562zzSykYDSPK2QQdRRt6aQoAV31B6iKmWg==
X-Received: by 2002:a05:600c:2eca:b0:477:991c:a17c with SMTP id 5b1f17b1804b1-483178ebb2emr8492375e9.6.1770248376463;
        Wed, 04 Feb 2026 15:39:36 -0800 (PST)
Received: from [192.168.1.3] (p5b2b4d5e.dip0.t-ipconnect.de. [91.43.77.94])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48317d2c856sm18561895e9.4.2026.02.04.15.39.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Feb 2026 15:39:36 -0800 (PST)
Message-ID: <e360d5d0-5e48-4bf5-add9-d5f62d03cdcf@googlemail.com>
Date: Thu, 5 Feb 2026 00:39:35 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 00/87] 6.12.69-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260204143846.906385641@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 04.02.2026 um 15:39 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.69 release.
> There are 87 patches in this series, all will be posted as a response
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
