Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900C72EA16A
	for <patches@lists.linux.dev>; Fri, 31 Oct 2025 15:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761926245; cv=none; b=hYBk58jjbRX6ga40TzIDQ9voTx13RlWoWSEGR++7RwGiOMtImQob+aetDUN/vr0COGJZMujBy1/bT5WvduLv7mRzn2hjYtSFoRc2nY9s/dfqU72UdY85Lf7YqkICfqjJ69aOF++2aEFugUpv+WNo6jtNA+RSp9A8v+C2gV9YHE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761926245; c=relaxed/simple;
	bh=yjHBWC05s3h3HRSExiyGSQQjmN1twKVXh2uNlBYdM2c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iLxgJiyJrgPDcBEJTU6ohdGDIYcehuIWJVCVTVDgEk9pdYM9dymiioB5G6GH0XhW0OICL4DFsnGoXEpABabM5l69ekgh3r5oK4pmh9GEExawv8zMzp415f7o31kmx9oTnpTL1wjNAAZ4SnqA74kFrvSiZ4HSiZUp/dhtXfw3tCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=UObT9TNU; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="UObT9TNU"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b6d53684cfdso518922866b.0
        for <patches@lists.linux.dev>; Fri, 31 Oct 2025 08:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1761926242; x=1762531042; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nI+jUGUgrFwdA9J/BWhhFb2SDMktkHvnyj/zPRmzijE=;
        b=UObT9TNUqCuixXLxUnoLBOU0GuukSDe5U8Gev0NPhOHgUU2lMvXIKbNQYAl7Hyz6xf
         YbyGEhokf9vWj6RT8dNbpn+b23VKyo8jgxDQYxhUA3606yncu+GKNf3jwcsBPTZAioyS
         ZCBxqeVRxnEFKSupZezdxoIkUOjjYCDCAtxXXzmf4NudFYVvZ7fGDMklwQ02iypORFg+
         AwbdcWfMEOX2A+MqMQqOVFiuig8k6JU1jrWPfXxBAgBukHmnqGpVNdcpqbxf/YVnSbIv
         j4ifa9aD1GOPvQXlAnhMPZ1yFcgH79sBL/p1rnjCFt3ViJkP/OpxMUJJrXfqg5Qft5+K
         CJQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761926242; x=1762531042;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nI+jUGUgrFwdA9J/BWhhFb2SDMktkHvnyj/zPRmzijE=;
        b=uyM5TVW4y84qSMh/L3Shju0ggY+24CV2FKxj+X5H54TTJwkWoeJA5xReN7gSVHUGyJ
         kFpTIsddyWWacJPJk0NO2A0WRkRLwj53pdiTc39iCxhHK538wd7j57U6EDrc5kmebdn7
         JCbkWyOAZO/kcch8Av5cs2HiKl7npR1T3tL857GrF4FRE5VxnjP6UFQqc4zBc977+OWo
         4ngr3dPbRidQGCcg4PLhsyrRFrLPBO1JgLO681nCqFUbB/0i/wi1NgWmUKfII+b89NOM
         5ThdCRYHu2nWNOsM4HJyiJfUxJ1gUjaCMF6P7QMU0pm31DAa+sfcLEHYLHn0zyzoNPb/
         FC4Q==
X-Gm-Message-State: AOJu0YwGjfYSLAwzWwxRgghxfUu5csx8+ms4BtHQ3i3m1TpBF+49efYB
	QxIbkZHKwkov8S6L2uFZXvLTzDp6eX+ejaQfPHsiBlhRWWsJjuKv2EM=
X-Gm-Gg: ASbGncsuo0zOSD4c4ZChqiDsu6ilegOTHdN16A6Z9eqRZc/8tbqLZTqKGptOglgKrqp
	KI0hYu+kjrYrs3NUW7qxrpZc3thVa0O3lApQZZaZsa7YjyE5H5NwoPVj6Do/3r9/iF9fmTojjoi
	qkFKZDBF7l8EMy4z5hpShoD5p/cMpKKa7gtK7Lb8nGkpYt0bu6VHj1RgyhhAae+0/q9e/vC48Sm
	joxyrTI9eINmwPD/E0w+WTDeL/HQ/9CseBmRMA5DiY6srADX+vtYjCgSsY5pW7ACc+RZ8vx7tCw
	Ag+hNPXQxn1Cmoqs+fBZ9Ary5YoTtLuqxBeoh3t457lMntvkjR4NvHyyrUDmX81SwovY0jVJCVV
	8t0Tmn7fzaGFKuyxVu/QKHq+s9y3j0stuhOQyDOnm6B7QzQ/2pRK70KHtsfmNbNlfIB3s/2H7e3
	XJv4SyuQiipXDyAn2XYysYALoxMMsGX30ki+92TiIYJ6AJtw/K0SLZLw==
X-Google-Smtp-Source: AGHT+IHdC5nEkh3EIsfe801CuOexng04liN2h1LnrXQkauZMgdGcyum5TaU1FRbxBKL0FAJSkSNDMg==
X-Received: by 2002:a17:906:478b:b0:b6d:603b:490f with SMTP id a640c23a62f3a-b70704c40b5mr378182466b.35.1761926241353;
        Fri, 31 Oct 2025 08:57:21 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac3bb.dip0.t-ipconnect.de. [91.42.195.187])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7077d065fesm206856066b.72.2025.10.31.08.57.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Oct 2025 08:57:20 -0700 (PDT)
Message-ID: <19689e2c-5dd1-4c3f-a243-84b69a552f91@googlemail.com>
Date: Fri, 31 Oct 2025 16:57:20 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 00/40] 6.12.57-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20251031140043.939381518@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20251031140043.939381518@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 31.10.2025 um 15:00 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.57 release.
> There are 40 patches in this series, all will be posted as a response
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
