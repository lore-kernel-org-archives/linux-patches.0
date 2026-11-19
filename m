Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795086499;
	b=YSfy0NSW3jV+v70/7uiZIgj/zeP+a3HxIEmMroXXq9TQ59y4eh/fWX39wTKDBdT5tF0u
	 q4QrRQ3gPDnCeP3agh7Xz6h7m0c5akYKHkGC3S5/I94Simq2Smup1w2iSO6SydDSlygsc
	 7HtWJY3doAZ+nzd01NRF3uSDVvHFx0a41kKudheNUBcdfvRSv8fXtP1bYvBOZeYTzY5m8
	 B6toZfXJ+F5G2uFG2WYhTrDpUgas3TbaUUqzV65IP8ooRTdqAgzEkevTTckSzRLwyOaiF
	 7mZ8bnKAfovIEugN376AwXL+5R6QXdsTg01sdWMgPyVt58vIpd93dyR/rv4JzTH2ZMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795086499;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=1gFFQM2dmDCAWo152jTDOkXj2oU6JPJwu8xp6zLm5EU=;
	b=Rgz11/1FwNB5kqHsunZDJ2UdOtpPLbalhd9hrICdgQuZZuj/OLlZb5S1OUGfN6A5THU8
	 Zk4hlLl6N5R8SczXQ+oF+BmFjZzaKc5v7u6Nv0CYP0KVxTqI+25LvZDgty9TGcyRWZwtl
	 QSumPysepB9Xq94dtYxZvT1J1rCU16LtcPb1bPe5lO7Rm6P3Bkm/KZ1r5FhWSCDeWhV9y
	 JFbslJ2HpuFu+MIHtrWv8NH8HZ/sS1pCPlc0wsLrlThsMg3aqeJ+F+82eFAD5BZ4ZQHzv
	 jNhzkE906lzQXy/jnjQ3V3uE7dDyp8DLLeC4mK1VCJmljKq37/VvjWjqpjATP0YQKtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kprc097L;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48E2606A324
	for <patches@lists.linux.dev>; Thu, 19 Nov 2026 11:08:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C48E2606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kprc097L
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4bb6886d30aso18856115e9.3
        for <patches@lists.linux.dev>; Thu, 19 Nov 2026 03:08:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795086497; x=1795691297; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1gFFQM2dmDCAWo152jTDOkXj2oU6JPJwu8xp6zLm5EU=;
        b=kprc097LsRkvN8Nqz4/OwORTKGoYJIxr2nxlEG1EGqCEBZG6QQz4wdQEs98JiSFmQs
         IaHKV2z2WgUF7AdpvpRBDGKs0L2zYjTsvPOL7VghcGnfbLNvY2g1hx6bteIcWOywhaXK
         1uDfN6E/j4OVSVTDjfy6bmWMV19+4pmCu1FhuM8YnRgFrzMnFL9V6cXMni+pGxr6OlC5
         atdlREE/GjJsD7SP9JlqMqWJNPqqSwob83MlJqHD91PAX+im2bpGGadN0w5LDb1SrbF/
         +YUptdDhvGY4BD2wJ+Gfdll7o8eQI8o6OY1UhZX3BctjqvHMsisVE6LEsT8DFWPlKDx2
         nbKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795086497; x=1795691297;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1gFFQM2dmDCAWo152jTDOkXj2oU6JPJwu8xp6zLm5EU=;
        b=Bn4KUirhada0ELs0mvX+xHmFRTAt+wTuLPvko4tYDBclUIz1VO7gAIh7+Zs+7shXVC
         GU5YVPBZfcv/3EMmPzc/wymclZPDx1oDaDpplbuRmo1hhWLjkGlxrqNpznqFtZAeRUDy
         qVBTDIDXIY//CZ7/HBT9jMLxZLl8Pc/vLqgSknlO/ec5JpCxFdJiGK6+VLed3iQd0evD
         pI32cYaLsewnXE44s6GccUa0iD2cfFX/hppl3uB20ykM6vznQTqDKxF60tTOm+v7dbdN
         wT3L2nhfbuMK4IUGB6p5VG//eFTjwSOky0lCmaEwBZ6tgOEVW1wFQw9qCAM52HQ+nsw+
         rdpw==
X-Forwarded-Encrypted: i=1; AL+hErHh/6QsPSPvrwnA2kiee6Nj65WbBLvF8f+O1BKc5k+jRNukGM+VQAKmJcPFcFu6/zE0L7qGca9D@lists.linux.dev
X-Gm-Message-State: APuU4Z/iBnbHsq4bs8v9QmKOmcW9wVDZU+eom+bH3aw4Tj3jXRS8tHZv
	xYJXjp1VGlhmwaSUhBCunUEkB5rXHjHExIItprT+wa6yOdUo2Yg8gW1e
X-Gm-Gg: AYBFou0MmShs9jApvAYf+wzcnBbVkKoVRgiNTuSlDqlR4spKK8tJ8h9QdY/zAJA/EJv
	TlunjjUpLSHTmz1RwBxYpr79CUwk62vpNktCBvIBfmbG0s0daJiBVgmPF+2IgH2gQlpvLcybWj1
	9bb8YVkqAK0sPfxx8l8zZv/iYXScidmcF9VUifJhETUl2tZs1MnS1fzoyrExZf72Uyd5qyqiS9H
	YuCfmSJkn4j1Hr5GT65FbuY4tOnBZ7bAHsdWm32B09ZO0yXQg6wxHG9iIhqcUvdZZJIUeLAvC7Z
	huiU3A3ucKiKkKNLsUUsjx1xTp69yj7QYADOAs0d5Qt1LApxqjZF98cfLMRs9nCqX96gVM5hVKO
	a4QZ3t9Gj/nnqIngf648+zdT0HdjZvrigjGtUWUEVk1G32PWUDKZRG228hvsy/MTGoEG6pmcoiW
	WewWU9vJdXGT4ec5aU+TBcIyHSYxNhSp44JCFncqftgiU5FlEEQ/Jihjd1+4nalV9OnDwWTQjyC
	7X5uuVoZC4Q8zB4VXxgT1BvW72h2qukxhUjkBrV1UjOz3l3x1ViX5JqePL3h9TiDfG9N5DDWHZe
	3rgzcsGDDcbmn56Ax9Z35HVRo6wSnpDMR4HpOTIA//3azDcjjkexOOd29rE9P22I8jBMMyIYDc0
	JqH0C8LQ3X1J33WV8IVVnjrCvg2y5a69rMU6/fSCzThnRVVQ+veClsEulErWxX9Axe9BrftUOcG
	31D85rTn5PR3oSBJiuLMERoJLMgw==
X-Received: by 2002:a05:600c:4e50:b0:4bb:6a5a:7834 with SMTP id 5b1f17b1804b1-4bb7da1edf4mr105406365e9.20.1795086496881;
        Thu, 19 Nov 2026 03:08:16 -0800 (PST)
Received: from eagle.home.marco.cx ([2a02:908:176:3bde:c85e:e9f9:a271:af77])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb853b216esm29479975e9.12.2026.11.19.03.08.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 03:08:16 -0800 (PST)
Date: Thu, 19 Nov 2026 12:08:14 +0100
From: Marco Schirrmeister <mschirrmeister@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 0000/2151] 6.18.65-rc1 review
Message-ID: <av7WKeKW4NdFzDk2@eagle.home.marco.cx>
References: <20261118150121.603863898@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>

On Wed, Nov 18, 2026 at 03:28:55PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.65 release.
> There are 2151 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Native arm64 build on Arch Linux ARM with 7.3 uapi headers and
CONFIG_DEBUG_INFO_BTF=y works fine, without my local __u128
patch.

Booted on an Odroid HC4 (Amlogic S905X3). No regressions noticed.

Tested-by: Marco Schirrmeister <mschirrmeister@gmail.com>

Thanks,
Marco

