Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7C215ECD7
	for <patches@lists.linux.dev>; Sat, 18 Oct 2025 03:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760758005; cv=none; b=NvPciqbyK3uyqZjmR5GyMwV+9SKZ1Gt+LmfF7M2K5kZZ97XfWu9HgIjt4JtfM0aYiZp77LNiFArtHID8t26yYi5ocsPG3+DI+uicdX1xV/NPFX04q5Mf5ar9cZDmyOBamt7gC8SLxggajySK1WtmwU92PPS+xnExv5TjnQLNZeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760758005; c=relaxed/simple;
	bh=9Vz6go/WSSET7hZHq91e2bf2IiJVDYooRd3SM+ixwzs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mYouln6OPEWAto0WD+0L3OYdsx6C8on6urLIoKm6dag1MUakdlvDMUbH5qH1qmnbjRgdYy3fb7tMF1Aj3B9t1YiRpZM440ADrxn56yqvDY6LLBrqqaXfxzcWEwOfURLxtgdyU6pFkNnFse1rEbYu3IVfCKVv0A86x6NraoM/bLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=XV+U7PhA; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="XV+U7PhA"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-46b303f7469so19088715e9.1
        for <patches@lists.linux.dev>; Fri, 17 Oct 2025 20:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1760758002; x=1761362802; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V7UD66nWwcPiFcs3XPMrdOoCuNNabzs8Aqa0dczoYOI=;
        b=XV+U7PhA45KhW13cBTlSa+54FfwhLB+9ZO8CbBNFG+SVkNwL6WyKEOFgNilku9pUQZ
         jTuzsWwM8lO9xPyqMk8BuLRve6Uz0YfppB3jeq//WRPVqsKdNLhzc1E+eKFDTJ7KOVWD
         TLA3ZwyEMo2i9aI4aOF/StR+auVyQZMiaCaa98LcPcniY8vfyn7nGaGsEdDMHxIlA/bp
         3mLezTTorypUIdjm70RiVbAj+H51xHlms01Geh4bBSOcV2Qn2/0b2IjGZYlSs6GSloMb
         zWOZ9hFERbCJSZLj8Y6eXve32aF2MuDjwPXWjgOBv9pHry/j4Ty9qkybEh2Iz4w/S8eh
         ns/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760758002; x=1761362802;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V7UD66nWwcPiFcs3XPMrdOoCuNNabzs8Aqa0dczoYOI=;
        b=i8SHm7o5KWMKNEIYb5/M2+DjbbcOqATYzFygG5IKQJDM4dEO6WJJrePrsWh9FMScsK
         jgJHozDureIlmuX5W1mBkx1Ng+hGFdhkG7Qo5Nb0JLOn+aioDVQFpTPum1MId5ScWotv
         5gB/0ES5ZO1PZ0QL2R65ic2hAVJWGw3VJblHWGreBreHNVZXb4KHTeCbaK07oVcWM+v4
         ILoYo5uGyxnzsB9F6E67xWd5ijuG0dmb4IQyaI+D5y/ck5tQEKuWVeI/K3nHA6hyUF+J
         rQv6DekeG6/sdtfSnKFCBLiF3MunVA3mq3eUn7t82V8MaCoK1mhcoLLtaOkBWZ3Gsk7q
         T/Ug==
X-Gm-Message-State: AOJu0YwsqRBrR40w/CAwojEisUvAjU4zFWX3/e+y0xgQuT/HHL8hNVYv
	/RS9u6mjC3fe3ajeYUdPH5F5Z02N7qeYlf/Gz1FRZK2On84WKtzhnR4=
X-Gm-Gg: ASbGncvWpSOOIEFe6rxpj6L0SWT0YAIqd0y8RSPoizPucXqqiVZoXx94xoA78X7/QBI
	IVkWiwvJkHyrQ32Yt4zc9JFaiBw5XyeHvB551p3qGOwkJyhRL2VS8ZLXOwRS8bqwfAC6ELIG2Gu
	eP6f4n2R9EA70jhf72qONaarbvY/z/r35pKhdY2sV+F7Wy8QiRF7pBFO3mqh9278uLBgf9tnfj7
	uxvIi6QUeW3sOxMsf93oqvJePijSV8+kjRyAaFlWUvFZs1/dOymeo6VAqH8kcRFAKRUCbPsNQVw
	uLKL5qLkGm+TtyLozY+wuI3yBdK4XonXVWGEABnhBDa/LfkUbUTwz+ETo74LPKg0wsIUNegAt1N
	bhM3BilHpUZFDq4vSupc6SXhZp6yztwUTNxALlGUtMhXj2YytDbwIR5ir+GC8/rR6owcIwZW/cB
	X0BDlX6aiC7NzDoW25bpFmplzEaobikQbu4lopS/pl4xMrZHPP8y8T
X-Google-Smtp-Source: AGHT+IG0WT8qGhi7qbukasMowA0m3pGEljJVHr4MRqavxDx0uIQv4Oco55RPQjnCpJK+yEKzAlJVDA==
X-Received: by 2002:a05:600c:674a:b0:46f:b327:31c5 with SMTP id 5b1f17b1804b1-471177ba398mr43631455e9.0.1760758002040;
        Fri, 17 Oct 2025 20:26:42 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b488a.dip0.t-ipconnect.de. [91.43.72.138])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-471144c831asm108137345e9.13.2025.10.17.20.26.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Oct 2025 20:26:41 -0700 (PDT)
Message-ID: <0bccfb0a-dbcc-4103-8453-adcade20a0c7@googlemail.com>
Date: Sat, 18 Oct 2025 05:26:41 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/277] 6.12.54-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251017145147.138822285@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 17.10.2025 um 16:50 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.54 release.
> There are 277 patches in this series, all will be posted as a response
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
