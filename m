Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D61A1C173C
	for <patches@lists.linux.dev>; Fri, 27 Sep 2024 16:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727454899; cv=none; b=LXh23QVM9otA7kVaviBJP9p6187ZsH/6s7UDstu04nscLEYNSVqaaHnKzrYi9iw4ZSzo8gGACjDLr0/m7KwvABIqJRgzAL9gYZ1groikag1H16lozXV/U7N7tcBjd1v8gbPf/tRhUzZU6Kw3auYLytUeFkxke+VcV4JQXZOyGxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727454899; c=relaxed/simple;
	bh=LQoHedUqZJIVDPEPLGQOFF7BgCHqs2L4dazdLhVW6wE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YuEu6/yTvPllCZ0aydOlbexID1wHJJAnuj/N7nk7//wB9sNIJbZHFlCCblVjGFlkzIeKUa65zIhElBxi2/KrJVrAFkNvASpMdcjVh+e/EsbmlfPsDLZP73PA9pgo4BhuEJ8GqKgORJkDF4tCvTFi5oqBt871BTR7f1bJBDod6jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=eWJitSOY; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="eWJitSOY"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-42cb1e623d1so21846865e9.0
        for <patches@lists.linux.dev>; Fri, 27 Sep 2024 09:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1727454896; x=1728059696; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fjW0SfXJHHMpF74jkLxhZJc4kDdjeQmRn27IgEhzY20=;
        b=eWJitSOY4E8J6jmPOUPnqUmG3xyZgWV3lIroZp7O8/cynVjfvk5/lafnSp2YhdPM1y
         TyhKw7f+oBEyG6s4fOUOZS74FAtVUwX6sbaRnTPFY6/kKKaljnbnWXASmMOnWBjP9X7/
         Chufujcb1XNCsEFL//g8XtNDrZeFqWrPYSNppv6k5/YOVZFk2Cv8krKMEvXP0x4Vd/DE
         O+mhTwUypRqflAxqWSEtjc8PRheYrqDIoLu3dHCKZXP/1io867vjVMkTCjqxSHr6JXE3
         fbzSWiiKhZV0AjM86IHflJdPDmLu8jqgj71E4a7MuIWoiqCFoeiFfQOKRnaJWDPK/pDb
         fwZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727454896; x=1728059696;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fjW0SfXJHHMpF74jkLxhZJc4kDdjeQmRn27IgEhzY20=;
        b=ILn13UtpDfKNYKstR4aTUHBUAFvRS85vNFNH/u/nAon9JadMlmj/gZEYYWSXpWjSmA
         vsiarh3gxULPpUeSO/4l3lhnFM5Df5XvGMhXJIh6ARxZR9le3FNyxA1Dt2Z8DiXPaY4K
         G/D5j4WEKpyD4bwkkodeSSQGkv4T7UbQSqLWk5znvl+d29r53wwhO9dpsZ+5WypkUuWq
         DlSPSwufWoKjPTAy0Hv1naeu6oz6vtx3BRlUqTUNa04/RwMV/wRkgYRxwk9uLe8m4gC8
         E2bStzu56mfw6MvbpuLcGAZzyb5eVvW978hK5KKQ2dTxqEfG+1PraN6L/ff2uDcYjYoM
         fEww==
X-Gm-Message-State: AOJu0YyrkUgSlKIH0wRdgI0HPrW6f03XrCTH77z0PofFiSh3J/ndiawe
	HjyO3fZvkZ6acKySOU5ttxT2AnLsph18rYnXcgkZ90G5YxDV2pw=
X-Google-Smtp-Source: AGHT+IFUSNu6KjgVPgBU386pEbCm/OnFQdf54/K7kJsZSt/nXBGa5NuN/1bR2Y85UYvAUiHKqYDdZQ==
X-Received: by 2002:a05:600c:1c04:b0:428:10d7:a4b1 with SMTP id 5b1f17b1804b1-42f58497f61mr29413145e9.25.1727454895930;
        Fri, 27 Sep 2024 09:34:55 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4a79.dip0.t-ipconnect.de. [91.43.74.121])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37cd564d01esm3012052f8f.3.2024.09.27.09.34.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Sep 2024 09:34:55 -0700 (PDT)
Message-ID: <4f07f599-ef6e-42a8-8b21-b1a69f9cfb7f@googlemail.com>
Date: Fri, 27 Sep 2024 18:34:53 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 00/54] 6.6.53-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240927121719.714627278@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240927121719.714627278@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 27.09.2024 um 14:22 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.53 release.
> There are 54 patches in this series, all will be posted as a response
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
