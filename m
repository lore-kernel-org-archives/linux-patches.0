Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD25205AA4
	for <patches@lists.linux.dev>; Thu,  3 Apr 2025 20:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743713548; cv=none; b=FEt5d1AWBBWAc1hpuUXr5orGYiuX0vygOL0/sOMxMiySNJXz/5q/gCuqczkZgwpwNEKZuYeJIlRs0JEreXqlx/YRo9Oyi1pPKZz14CvyS5sg7dONcG62aC4en89Ve+0Adc9ld7uHNd3dapXlhE0nc220P6Ihz6GzxXzTA86TA/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743713548; c=relaxed/simple;
	bh=wzaX8x8CN4VuzMeZu7Ro/jNwfZNPTLEs3cKtF1c9NmQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KsLRKYJLOubPS4p14jggGylLNzxqMxYojhE97FO4j9JM0UFC2X1HfknCa69eGw/nEC6M9eLWBVb691vn/VNSmz/LkFQ4gHgMJcP7+2GXbo4dVZklXawp6zw+CYFYIzHVAvyI8lt5wlmrTfm0oJdCtaI8dvuH4kruLEne9QcWOpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=bCpPkgCu; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="bCpPkgCu"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-43690d4605dso9531515e9.0
        for <patches@lists.linux.dev>; Thu, 03 Apr 2025 13:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1743713544; x=1744318344; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Dh1lmyVMoTxI6QhxvGlPI3b4b7IHb16ssKSrLJcEUZk=;
        b=bCpPkgCuXjsptlrt/lDElgWVj+xYS9B13E7GGMIL4tbHpQVH1Nr6hYjYDMLSsiAdbA
         UYCSNhHXXiaB8dZ9jedeJNGBs16j970HHyla/3Gcpjy98FCBZolZXsJEMEozx4JyU3XD
         V8Xe0y1T8yMm69RUr9OtwguYz4JkbFgT5KFPhlKmpX513dNPX//6tFjGc59yLNOkkpbs
         Zfgddf5zMm5NBqd2kPd+2xatVCVr+dRTme34C49pGCrE3OH2TbRudtWVRk169bCTxHcs
         plGNcE1bSbJ9bRcutBr4T9GJVK9Rz+aBXANwWNz++np4pEbpcEg3ZfrpsJWOzWiln2PZ
         2NwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743713544; x=1744318344;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Dh1lmyVMoTxI6QhxvGlPI3b4b7IHb16ssKSrLJcEUZk=;
        b=D8X84a5Omb/jVfm3FoezYrac88/1w44wVY1EcRbTEDGRk3ffyAsHwSAi1GJqoccHjr
         DH0Sapivc0jEgMy7VGpzj8q1JmZgNLZrVz5UnEe5XQsoTsh90u/zs6fBthqgxBNU2aXd
         tsrvTl9LmvvoOUeamfF1OXulUOctNjuTRQjRbDR0rsrvfeB0qqf6Ubc1Fvl8K1cOX8pu
         zhx03m1ci6hspHcXguVT3ZYsyAm8hLtV6kmeQH47K1bZSTzidbafBMfSBcRUvwwMTrcQ
         cSBR3ISd3tiI2K7k95T/0hRsxrVo3ITPnUzWJUpbujU4Rb+6yiMcsxX17UUS9j/ZBags
         jsog==
X-Gm-Message-State: AOJu0YwcwGTeoHL0nA+RdvLpmKnwwuTRYO/CvvhQ/PriXoOiClRfEljy
	ERvQ4b78mkWzLa+3XgLuetkXLDmfUvk5Rx/MIlGVDObtU3/iSLQ=
X-Gm-Gg: ASbGncsVcPZJ7HxYHJ48+q2uK4SLjmvKmFeFlZnc0wko1D6rz2O0OSH95CvQjo9g5jY
	Plepzd9X2vno2EYkzyWNZx9o+Ge5dV00QVNSXVUkS2XZnhJCVk5H9pUbTpqIG4IuFJcRCfQ0NnW
	IrgyLnNgLUvdL5OyyBAv40SLfx/MntCOWsxDuurIXcCHzxAz67mTKwAJRFcO5vBzPNgyQWIhVQv
	rlm4mLwp4hOAwx17kJVbu3Nx2143jgdHRyhopNzDfcqUohBxUBn1g1IasMpsTDSfKgYZLqB5x8W
	rbjIMTnjUtK8l8pgRbNIrnPqvCOI5svhY0+mou/dpo/E1f2f/psYp6oOWHyCGwIaPrbKXwzHeD0
	vlql0hXwQRbTxwr7MerbrQ/g=
X-Google-Smtp-Source: AGHT+IFKoqfuumt404ay/WdLI8M3vO1YnKQYh/NFzH+vQ/dp43SsSpIIC6flE8Gw/mHBQqDnya+SQg==
X-Received: by 2002:a05:600c:510d:b0:43d:2230:303b with SMTP id 5b1f17b1804b1-43ecf9c3e5emr3445025e9.20.1743713544422;
        Thu, 03 Apr 2025 13:52:24 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac393.dip0.t-ipconnect.de. [91.42.195.147])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c30226acfsm2618227f8f.88.2025.04.03.13.52.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Apr 2025 13:52:23 -0700 (PDT)
Message-ID: <0d22ae96-d1ba-4925-88fc-3a225743e468@googlemail.com>
Date: Thu, 3 Apr 2025 22:52:22 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.13 00/23] 6.13.10-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250403151622.273788569@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250403151622.273788569@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 03.04.2025 um 17:20 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.13.10 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

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
