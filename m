Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22975242D97
	for <patches@lists.linux.dev>; Tue, 14 Oct 2025 01:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760404447; cv=none; b=quwY8XnnksIAu3WQuLpnRPI7eYrfBN7emGgBLr7pZw55YZnSieOB+3ME1/60HamnBMlC3vIU95uWXbx1qbooe969GZhtqictL57wggi70/j0XcueZAARqogHPqSD6V4cZXPN8wQPOq/1Z4hyJQvgCZSdd8qZ2SufmtMuW1UWZlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760404447; c=relaxed/simple;
	bh=VLDmeT4V4bMf/s8VcnNmz25fy91luPLGLGwIAeMLYJ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ISzgM3pDV2Vv+RLPoiCLeWFymjnbUXxeMGwRO+Jp99CSAYl56daNWadcebzGz2Zo8ehHgiwJk37YMXA4WrWHrac7NUHi9i8bTiZJY6XVih6fzmpnMz+3T5QlLaf8Ha0O5bQhkZYaruEAqH/Czo5JM/qd398QVhYcVZqAkoUh2AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=N3Su/bqi; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="N3Su/bqi"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-46e61ebddd6so51020385e9.0
        for <patches@lists.linux.dev>; Mon, 13 Oct 2025 18:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1760404443; x=1761009243; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BotW9r6xL/UMcoaCPy9Ldu6h3UcOKuy5CPivX5Mz6y0=;
        b=N3Su/bqiVRZiOqcUcKdrlXmkehiMTdTFDPJgK2KmRxGabOl0B6ZlR0PnO+goRfpV/S
         29IH1iW5KerpWBRzXrYQZve+7x9XFSSMwkvDXM2+t59xvtBnSZaSogyj4m2GWidyrHs/
         15DXn/PgjN2+t7FPM0YYlK7VHFJE4t+81E+BhR4lecKHa655eKBHqSafWtCxDSLP2ZBR
         694aivOZUJeerak7U7ZKn1joGrlX8/JuhjF/4dP7ORV84XFglNdrzkXLoJZ+nSKOQfzB
         rRXikFfgF7kmONY4q38sw2l5AWiSL++qUxoTpWfk5Y+vmbKwHeLD5T77jWSSmC1j7GSV
         DGAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760404443; x=1761009243;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BotW9r6xL/UMcoaCPy9Ldu6h3UcOKuy5CPivX5Mz6y0=;
        b=Q1tyiGCbnOHWIVaT3RyrvJ3P/+Sw8nQoLM05xrIdoFD1i3keaRk0RPJIBTXckYLJRj
         bwhm1pnyuQP8Qm2tD5rxk/OO3bgYgvUz2DNCEVc2Z5TyQNLWRo8fkSrg3FRbfxiA8HNU
         adaKb311TH/+WTpFUHkmGG/jDBg1Zl8svH1ewyyyP69/kBtaU8sVm33kp0daUdhawqLu
         vgKHPJylAjfgSs1q6gR1INZftzIE/GG3PkowKsTHBWVwhNLK1fG7ZJfsY2pOYP1HKFsV
         VxQdaZD7Dgwf6A/O+3YE5czE1FidG2VKIDWZjVCn0LluDQEM/1dByNyDkXHRPGuqmbt5
         MKVg==
X-Gm-Message-State: AOJu0YwsLc1z4p2LHSNX3jxYdCbff1G9/s3CpFUI9BdWfy9Yy4yc3PGS
	bKmqmwqzx7eD6C+adkqm0VLLGxUSSNI4yfR14yuF9/USZy8voCRcPbI=
X-Gm-Gg: ASbGncu+AWjK/Loq4rzJ1nj7b9eGnhs9CVr5/MkoUNXi1DuXXOwMlPoVMXhibw9QODp
	DY5x4mWPQWqfR2tf5XK9SEKTTr9nG1MajiU9hNnLoF2t+GZ4JL6GAzfQZYsHQPcIM5cDxYS84kI
	n2yjhIoa85PUU6k1r4BUb+3uydxqMEyOjwL78pDI7H8yBTVPn3j4M+5Z/bc1pIFOGpyYZXSJBRz
	z6klP4/chMyRWbwCU7uvF+K6DBadyUqxU1De8qBoCjf6Q4fukQzW1nOkIw4WarnT8Z/Ve2SpM1C
	P699s6na8WsnNdiPj9HqBKJ8fNKtCRykcGZF+ryUizNBArBTXGticBqkDR+U7KCeRoEJWKNLN8a
	5yoXa6NLgoc/jRu4bPpTdO7WtB89/KZGZfXUgjRy3SABHAAQNGT4SDr01FeLmlfR+6ZJHEN8xst
	9bheaAyYCJLk1LxqDtkWI=
X-Google-Smtp-Source: AGHT+IEn0zN7JJO7ozOpfwGf2FFNELh91wduawTwnU1AdEj1SfIBN2yVJEWWjvkaEB0nGVf1WaDqGQ==
X-Received: by 2002:a05:600c:4688:b0:45c:b540:763d with SMTP id 5b1f17b1804b1-46fa9b18258mr170118175e9.33.1760404443223;
        Mon, 13 Oct 2025 18:14:03 -0700 (PDT)
Received: from [192.168.1.3] (p5b2aca8d.dip0.t-ipconnect.de. [91.42.202.141])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb482ba41sm212307565e9.4.2025.10.13.18.14.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 18:14:02 -0700 (PDT)
Message-ID: <121e043b-f873-46cc-ab7a-22100c936dea@googlemail.com>
Date: Tue, 14 Oct 2025 03:14:02 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/262] 6.12.53-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251013144326.116493600@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 13.10.2025 um 16:42 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.53 release.
> There are 262 patches in this series, all will be posted as a response
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
