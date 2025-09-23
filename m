Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEED4262FFC
	for <patches@lists.linux.dev>; Tue, 23 Sep 2025 10:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758622580; cv=none; b=EYEktyIuv21Xcf4uASAXFLZSmq2/qmfKPb8jKDHDrYsPggcNiL6c1PdKPqIJc2fINsSON+e9nCZ5AjBhbW4TWiMe8pJWSWMVAFw1y+dPxJAxeEmiJj//Fbhx9CXfj+eEL2GCPRkmOMHIijy5wlNAS6oP3g1upp41t031mXj0zF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758622580; c=relaxed/simple;
	bh=RYzPGdtC8EGMXt14i4heCA6P0dBRkz9jYtGI/l4OWoE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q31aybk5D5neNcnOTGZPD8KEWTj1BZRhMDVqUgsbvmxLC7XCSL12L40lMZUI41wY8LRPXsA/D8VZ28uzxlVcSkzH7796aIYgnzi23yIFoblKFfHeLv5Btwdo1dU/p4yd/NHmMHpiK3gFj+O2R4zhnVC4u08NdEQ8ISxlrxPU/Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=bGJmjxox; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="bGJmjxox"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-45ed646b656so47087225e9.3
        for <patches@lists.linux.dev>; Tue, 23 Sep 2025 03:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1758622577; x=1759227377; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z+sf++HoPCnwTrMW6zlIxHwkbmsZIiPjDZjaq8+brNA=;
        b=bGJmjxoxQgDV39N6FDQfTRY7MJCb3YhJGTDb7sVVF5+XRLBcOOjNWVdXS8hu+6Scbk
         icl4hPxw8R2NbOf8wi3+5fWTeb7SodjwvMqxTok3V6tc2kM9SNxy/Zvoz0Hx+ngm/eat
         gyb5tjr97p7vN5VcBJCANb9J97qYEZCFuoDpfSzkP06fEm2gCPGTVJE6p9yxYYvrm4zi
         JUpp6eUn8MOnLRMx8L8+uIUwGMi2MCXmzoZNrDdhdFXg8nsFtibcTsJKF8p4jkq6REG0
         AC0R4G9F5HZoN70i5I5BLFtkFCHfGnW1R0vmvU7KJeGXdXCjQCPLAf0+sTjsymJfLF3y
         x5qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758622577; x=1759227377;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z+sf++HoPCnwTrMW6zlIxHwkbmsZIiPjDZjaq8+brNA=;
        b=kk1+kwF71UQV8M+lwW5Z2j7hSbXkUFb43mxQageWRvxNhVJM5VyujPwyaRkNifoZ6m
         6nK/kRQcRe3eklDJNs2jzyWkbf+RaRmsvd3UWSIEjbxhCFSqV+SzLoLnca/cTV6XnMzU
         4GjGw8nmOHkbG6YRXXQ4UzDBnQAits+ECGJY2ptjDhokh8tZai/uity5ioJsV5nSzN24
         UMHKDjv/rDt5TAvKcq+mZJ7G8xoE5OlDVTC2lKUfZW6umyt+WmL21/r4wvdXQn+RuTXC
         QFje9c3gfvGjY81AB3cfWIrKLcUnYI8vQyTcZogcAXxEaqfFs/o4WWTa/jSng98EIgTX
         zNEw==
X-Gm-Message-State: AOJu0Yw1Te9ZvdYMS/tiU7vyugDk4POdLqw76LsEf/QA0N8YTz2mvcCr
	kvV6YlH1WP7p/NA98pZqeaxy6B3GFGnmSaYA5zLs9AkEX4tZcI1TaqU=
X-Gm-Gg: ASbGncv4/aVyE5TPaznB1BxOdMiIGPfM6JV0hN8vuAKkZN7Jkd07Ha95Ze6sGIqPDrh
	j/9VrMv8+tYJkEAABLgXtKO5nTpc/BlZOrSvYtmavrpcMYuosc6+IlFAnayuYSSCess+rGSTE/c
	7NuFNTcbOlV0C+AFQxTqH6o91oR2Bek45WN5TApdju2iQDO+A6sd3BDkHwJwGUZBae1zkwAik4S
	AAK3EIdGAYb2IXTCjePbfo6dkxlaKAFoXWAUBn9Aq3lMrLNIgKR3yL7Yw6JJzOs5DPt5+iF0aEH
	tyTIq7Xznh4Mz+B5bcDsgIoXTF5OM+Ws2NRJnAOXZdLIZCfkRKMMtlxh4iA4jZVY2QHVNhP9MGA
	+pPM7Pq1dYSQc355wtaIMliaCW4tfRxogM+9gCk2pbt2crXV3dKNWgl+IahHP9+Z2SMF+iNMcEb
	h7
X-Google-Smtp-Source: AGHT+IFVoBHgZs4WjGNNOI/TU/wazag77uFfteBay5mPYzOkv/vWLLx6YVSIzFhKxrqMSBUuEzeiOg==
X-Received: by 2002:a05:600c:154b:b0:459:d3ce:2cbd with SMTP id 5b1f17b1804b1-46e1d98a525mr20043875e9.13.1758622576895;
        Tue, 23 Sep 2025 03:16:16 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac1a7.dip0.t-ipconnect.de. [91.42.193.167])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46d51e5d863sm75027915e9.24.2025.09.23.03.16.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Sep 2025 03:16:16 -0700 (PDT)
Message-ID: <f89a5541-9f06-4696-8d05-961e4fd9a4ce@googlemail.com>
Date: Tue, 23 Sep 2025 12:16:15 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 00/70] 6.6.108-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20250922192404.455120315@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 22.09.2025 um 21:29 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.108 release.
> There are 70 patches in this series, all will be posted as a response
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
