Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86EEC244660
	for <patches@lists.linux.dev>; Tue, 23 Sep 2025 14:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758638377; cv=none; b=mRJRSFDW9g7BSnaLFE30dHU3Zq4IjO7YeC/yzLeEp1bfcxuhcd16qt42Dv6hKJAOzipsqn06F2PRBN0+FXOBTazv6XiRdv/HF+lu5AUmvR4h2cOGOhp3emw8m1JJhchX+R5TJwfdZ0w0e1Q2oMtZ2bxRHJ4TccZdiP9wm+UrzZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758638377; c=relaxed/simple;
	bh=2W1p1PVxEkh/5Jzxzj8mbMEaZhGYn3Pso3aH49N+ygo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bL7qaC+QsqIb/GT+Fy0XqqAGjtOOrRU3GPtagjB/rz+aABwa3mbDL8EWTv0yUebEn6zvccFMP4hlM5PPSnZaWPR7iR71douEEAEoabyKQmDEt4T2SzBTwhjUZoPUKu6O6et9fmkIUrP/73fErUHRtvrAIimF/zGmLns+6IGNvNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=VtLhkWb4; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="VtLhkWb4"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-46e1cc6299cso9702715e9.1
        for <patches@lists.linux.dev>; Tue, 23 Sep 2025 07:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1758638374; x=1759243174; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G03TPrIwIbXqqIw62bjb6NY2zbYfnOY1m550GCrJAlU=;
        b=VtLhkWb4AS02YdlMzYT30nvCPNBPGvZSZJ/J7sQ2jzAir4vFYxvJ6T82CgjNpB+axw
         u44mOzggHpj/1WrT6i+/4LXMTm82xIB7YCiWhi09WqC0Nie3iTUiu3152OJKpeMlRbQx
         U1eaGs9tdadRHp5Lb09DSeoidLObairq+2FUsr51MUA/NORIb62jG3sxZvoJXRguFgBv
         25CnEXhEpcvURRuA+SOrRAksKFaOxOX1brO1JBW4P8id0TyN0WFWJtDPQdJyU1wyFZDR
         EFpWIZBtYYrEr0cuuip09wqHckfSoIA3yqL6WwskeGijbq662K9ZPZ7nhHW1x62faUcC
         xkJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758638374; x=1759243174;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G03TPrIwIbXqqIw62bjb6NY2zbYfnOY1m550GCrJAlU=;
        b=G9cMak9aNqn9zkMpXmzc9XCWtIUtXfvQLZAbDnjSbHZdyGlZgNLd3I3xvz9CFW7pzr
         wHHRN/bJfKxXNafksqQwZm3M6fJ6xr0dsn/nJXXeXwVPRm/EwB5lIZaiuGtd1Z3dEYxK
         b3oeuTofkuKShcrmbM2fVBZ9quFOHbw3S/9inHoqLXEpLs1VxKds4HaAiLiDo82lrqu5
         wMfe56XZ90nCE0WTmML6ri5ZfShX2sVeN+bbDiFu40hLNHJdyhLqjSpPU4cMNM66B0Dn
         BbkoKKrCyyM54RhwCKmQsuJZTJEffexm4zkco/66SCnr7Fhzrmbmbb3ikacHnWSREl3T
         ax1g==
X-Gm-Message-State: AOJu0YxaQdUDrg5aJG6dOXDC3ZwTN7GE1Tp8CHDhlDnGOIfGc2obbYdb
	pPSzIgKQ844W2KbNpz+XRTehXOwPrmZ7C7U+EHRymJ+6fKgcUXv8ZKA=
X-Gm-Gg: ASbGncscCuxbDnaOH9+TnwRJVEwes6aOMO2FZSfPZta9hBOudj34SExhATQGSPWvpSC
	vfFJuwT6zi0chjoK0KdhNG132ddT/qu7ClhRfKIVe+JDrYMCoIf0ElDE92/NofsSt+62ldA8A8j
	TGIArcn62yngfG9kLFmzLnBbACzLkTdkL33ebEATpXbnjdwKRmyn3awMsoIbstDgPcQ0LlSDLR5
	3V5Pt08Gb7TwnMTq3ZUsuVeQIFuFUb3WF8Q+NTgv8t5y8WG1t32vHqdgSKQPc0YoiLg67fDVSfD
	+tYwr+Z37RKhU3//A45OYFxTSvzWbSPVJIeEfZ3MOStEEMkm701rMjoqLjpZHswARSFaTEFJ4Rp
	MzEFWc17bacirC9I4EooeMIJMwBL2oTp31s16l5HpjlrABIwe+rPTfJB+7zwzP/sAVGlkaHBPSZ
	9u
X-Google-Smtp-Source: AGHT+IESPIKuTD5INgzVqUCgOWgsSMbYvBp254k7b3uOL7WxECIr1xPMPZTeONsx6mtFF/O0lx3uqA==
X-Received: by 2002:a05:6000:2287:b0:3e7:4265:66de with SMTP id ffacd0b85a97d-405c47b97ebmr2400311f8f.8.1758638373611;
        Tue, 23 Sep 2025 07:39:33 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac1a7.dip0.t-ipconnect.de. [91.42.193.167])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e1d98093dsm16253415e9.3.2025.09.23.07.39.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Sep 2025 07:39:32 -0700 (PDT)
Message-ID: <6bb6c4ea-3ece-4799-848d-a961b96bc8d6@googlemail.com>
Date: Tue, 23 Sep 2025 16:39:32 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.16 000/149] 6.16.9-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250922192412.885919229@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 22.09.2025 um 21:28 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.16.9 release.
> There are 149 patches in this series, all will be posted as a response
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
