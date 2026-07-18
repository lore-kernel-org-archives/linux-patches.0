Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7FA1A6815
	for <patches@lists.linux.dev>; Sat, 18 Jul 2026 01:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784338979; cv=none; b=CS2GCa286WdVRTQgfwrgLbrFk6NqOSfinC7P3wC3nEbEXUymnVOPAZMUg9IvzDMBGsrPz5m6f3H32OF4heMF0Wkq5H9nOfqgIGh74j1vBj4fiKQE6bYC2Sa1HS7c1jAUIEkiP5kMalB0+wKGfJfLSbdddcymCAxe5BDoFtLhrTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784338979; c=relaxed/simple;
	bh=tzpV5Q+kEKWdMfYHZm/eH1lwHftKZQj4hFItFUavIzk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n11V0wta3s2/K6H9TI110Ir/u3UxGtFx7FLSLfGvCy7yHVKDJHPZrpy++4LfwMl7YAgOVD+yWTZ/cLunIWrEQ1jDBd56CaLw7k6nZIIEChQX6sAiC6jWdoNKyHRZiheQIQXF0MfW7YjKtPWgBXcHliW6dMe1FMEu0pKyzBKv3YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=cRmm76NT; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="cRmm76NT"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4953e04ef16so27272415e9.2
        for <patches@lists.linux.dev>; Fri, 17 Jul 2026 18:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1784338976; x=1784943776; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O3clgJcwSjud4cWyU1JLhAejxLBMQ4geUn3FcNJdjRU=;
        b=cRmm76NT4Hy29I7t9/JIAVQTKMYAjitglC/vqcgEKopPx0aOjjcs5fpbanBWeGDhLG
         UsGs6BiWlC7AboRdVf2zrMCnsFqwM47pCCJfdeI7mlecKIlN8+5o/58SaqJzfgMNN2tI
         EHWgQgBxN1CBNlnuIbqrVMZq+GZu/5XM+bpCUBM0YsGgMa0bUh5gxV4eznJQa8mGStPg
         Vqze3NXLKcQ+gSOXTBGCfnyQfUoMcDOV2zTGL3RR0ibFpJP2DnPGDLEQsQ8cok2lCsjh
         2Ws1L8gy5cNi+BrUeKU2vUvRH8H7lf9TXwqkXwWFVJ7bBiPXvYSDKTbAXeFnO+LIrktm
         iPvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784338976; x=1784943776;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=O3clgJcwSjud4cWyU1JLhAejxLBMQ4geUn3FcNJdjRU=;
        b=Pflw3IwQAZahsVHjAnI/MPBL2CI6itz6pSUR0Movq16YTN0P3GZ406TVIIclUv3Nsb
         Ts6lvVVGQoD2TCR1bzkAOsXTIPbuMqfafYrJOIAi/fhu9QdXhnzojv5lv8tGeYC6flHY
         +u1uJfXYQVq2jCmiKaGR8iGtlPWBrWrOlFwbqqOa7tnZd7ZjkPVpE6YwmOXmHqROO8+d
         FJibthNu/Y4Kvm/6fXRutKgskM+XrfpCjcHDWv4EeX4d9v+JORjnmUg0oMQ5bvUwnQoA
         n9u+6cEJ617HIOvwKTuuaENX6DM5Mazi0maIPolRrTPPoMUFtiL90xJkN1D80qguW/PF
         FEMA==
X-Gm-Message-State: AOJu0YwFY5XtS/5a9PtRDb2S8r1C6Cj4KpC2ouoUhjrmazwUJiZB2exj
	/7iQ0+V3RwymhatuOOzpBkor2kh5GVgGAPbV+eLLs0fqBS1L58psxx4=
X-Gm-Gg: AfdE7ckgYw3LRQojXCQX4KTEfy7NT4ESHNHDSdD+X4VmTx6dNsmMuZNi0gxl1nSirOm
	4NfuR30N0a+posU5/9z/YDhq3UVyA6nk9ccjpQnDW9lwZIDbzLtHEu/Dni+sNfh0msaF6tg3AHn
	r8HfmeCFidc4YTGGCcbyHEut6wZgP5ux16E+ZkQxUsZa7+uOp4wZZV+PaX9zj0dV/Catd3jL0VP
	g1nQQ/cYn8ml6hWA3gdtwgeIJ1BeK4/WOdK7D3ahfnZhcmmJa6GI8UguPUKTe0JA2zTmSfE1TTt
	NQ41cjKI3mlhrGPrFBdM5gAQLueQZ/9zwzOu/tkBAoiO1aKl045AXS0afvqkfEtEbExiH6nU1s3
	qBke5G5MJvDI5aH4L6iXqmMz2rddACDPIr/WbZGnTyba5YxyMRx41PXx4S22X9T+HslLlxujWJO
	F4bNVLs3Iqq93A92dbRQfz0WYxDd+HSA2sDeA0nMlT1Zofybj285gvbnE=
X-Received: by 2002:a05:600c:4685:b0:495:4a77:1327 with SMTP id 5b1f17b1804b1-4954a771521mr56511635e9.33.1784338976025;
        Fri, 17 Jul 2026 18:42:56 -0700 (PDT)
Received: from [192.168.1.3] (p5b2acbcc.dip0.t-ipconnect.de. [91.42.203.204])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49548e0fcdbsm90874815e9.2.2026.07.17.18.42.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jul 2026 18:42:55 -0700 (PDT)
Message-ID: <7bce7e41-3419-44f7-b184-666c016c755c@googlemail.com>
Date: Sat, 18 Jul 2026 03:42:54 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/357] 6.12.96-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260717101823.379399592@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260717101823.379399592@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 17.07.2026 um 12:41 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.96 release.
> There are 357 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Just like rc1, rc2 builds, boots and works fine on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or 
regressions found.

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
