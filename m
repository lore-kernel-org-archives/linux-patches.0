Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721953A7582
	for <patches@lists.linux.dev>; Wed, 17 Jun 2026 19:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781725900; cv=none; b=DCvy6dC/8hnfid8tv8X/QpMZvV+QUmi6RDJ8r0N2wi3k/UhbTsVjZ9HUc3uAtNL6+y20V77YJEO3L90jQOXO1Nx0tfUqp/Sx5q89LrUHmQmEqBh79jewGSpJTtxlfRfLysygTnkQ45z+cbV8jwXAZoeIOfDI9N/Yzjc1ndQn3QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781725900; c=relaxed/simple;
	bh=YRWp0QBY9So9jvC++gDHCc2QC2B11a+d/rs/bKIKsrE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jU2wJoj1LUUp8G70pv8gLVeV9Kvc7WvsZ1tV8wGfgZ5JtSO4jb25RLbnPS1kriYbFou6iqetYFtrQkDyppXyN3SQGNMYuiiMCNu2trGI0VIB+PWNhLbjnaZ/yVhkRHBHrYQEs1iZtpnnzi9TAeA2P4jP76qUBw8nAauyObKOsOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=IsEaNMJ9; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="IsEaNMJ9"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-490cf322ed0so730695e9.1
        for <patches@lists.linux.dev>; Wed, 17 Jun 2026 12:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1781725892; x=1782330692; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pfGIZP62uh7PYVhHDF3yN5s7VorHMzFuzJ11i4tucO0=;
        b=IsEaNMJ9DRYiY2nUMMJc9Z+F3ChdhEo0h5vKZqaZCHBChUaxY1/e5tNMM1eeutvoX+
         +LliJZ/0PxUoCKrD/SnxANuXvAY6xfU7+sjxQWzbhsc7rSvtFnulXR/VuKUej4GYckQY
         DfPGLMwgttwFyEWNH8w6s4kfPexDZ4WDK8vq6M/1N8PkzZl9VRRg4qM2OiJiRSA3layl
         oNXSutrM7V+yVijubsX5u19/v9be/dQvR3owEv15x1OYAfGXPjiJdmNDm4WDTGA7++Ko
         xzdyAguapgn/eYGmxdtuO8uPNhgRemYp8vaLrdRj06l/oQApFgEemRgslYeQU/9NSSbS
         s1Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781725892; x=1782330692;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pfGIZP62uh7PYVhHDF3yN5s7VorHMzFuzJ11i4tucO0=;
        b=RoWraTQIJsfQI94JNBYpC2MTv6bvGMnbUgbHVY3hcPMSVz8g6fXh0zj9/OXcIqoFFX
         +kF0F/mMkdfOpwflee9hVYPyv1o0VFNlmtSzvUwQ/L+YkoZ5SiYC4cV4qlHL8jRtPlso
         LGXxQj4v9CorhN1iQrXuZrZSgW4JomkldojeublgkLO771Z0kOM0LnO60ekU04ZzMqbG
         VCYhr1DThCVrUs5bJaTjN8RhRTBgOFy4Y4gbOBSbESYgQ4KZ6otDDZkWs6Px0Fj2cxEO
         dLov+Qol1OULMGvt0zmlDSwmcfT16trxVx8bQTnoXYuC+oAAffsZfhvKaRGgzc62/X3N
         QicQ==
X-Gm-Message-State: AOJu0YzkPgCzZkXp9I9Fkj2E2U0RSgG43o2ZLUJWMCu5sKjkqMQED0QO
	5kmq76PgqH34fP3Aoq+fBDeG5VIUtXgrmWu4nGYGrav92FjlHFIlfKI=
X-Gm-Gg: Acq92OH0SLsvmY9mzyUtTofjsB75hk1cnYYxfwUiEokbqN+wXU1QpLLdEqL/gA3PG6R
	t8A5gba0I8DPVYxo0yoG3JGvA5PN//P+5OYwSrimVniixzTTz1JZBZ04kukmeSIEQvhJ2yC+MHv
	KCRpIgSoca92479ThUuAHtVoiUJmVLT5hjtkUGE7YgBa9Ytl2X4lTYX7TQuMBzGoHyI+4dWva0u
	l01UG7cIolDwpDB+qE3v3q//2cgiWXlTr7Laj5FoJNJbqAjzS29OyuEVC48L0nGLnrSyfQWunD3
	bbiW5TFUdSgSE0Od6/3ZkFVCARBV+J9qENlfGdI7+vcWhaCyKZ/PZIAQPB6ye6yHGqMnWah/52W
	IQUaR2llP4tz82oinZsGj+xCzGiho/SAPf67blf/ZHOpgO1b0iusySy2Xb/PrsXMki8Yk8/2UBM
	vhI6ElzrBfG3FjTGtufAnVUE2liiTqGg+ZRqpri8tc+c51mhyPneBmsZ1VtMSuVZx0
X-Received: by 2002:a05:600d:6443:20b0:490:5e2a:f924 with SMTP id 5b1f17b1804b1-492381e2430mr11808775e9.7.1781725892360;
        Wed, 17 Jun 2026 12:51:32 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4777.dip0.t-ipconnect.de. [91.43.71.119])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4922fa47ce3sm211320875e9.6.2026.06.17.12.51.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2026 12:51:32 -0700 (PDT)
Message-ID: <a937041f-31f6-40b3-83f1-1cac8deb1f50@googlemail.com>
Date: Wed, 17 Jun 2026 21:51:31 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 7.1 0/8] 7.1.1-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260616145523.335696673@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260616145523.335696673@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 16.06.2026 um 16:58 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 7.1.1 release.
> There are 8 patches in this series, all will be posted as a response
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
