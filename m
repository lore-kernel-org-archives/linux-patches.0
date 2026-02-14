Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6DC1E1E12
	for <patches@lists.linux.dev>; Sat, 14 Feb 2026 01:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031161; cv=none; b=rxdAI+mLIHeFhGll/I8c88mq1dlq1hkO+gFJLD67PjolwU5HnTBYGYoK8LdXsHLm8jmBdT6LT0pW15BTcJCWqvto7nsIYFIzXd9c73hhlBQIqTPpRiA32gbtePa4+8Sh3OFVYW3fX1AtdT0Dgw2UPX9VgGQc0rt2H1q4EUQKfAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031161; c=relaxed/simple;
	bh=FEmd0AKqUxl0fXw2shyi1YhQuDt7hoHaK3mkhmqaYiQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lm1GYcZTFjwnlqgOdAEBoUPP7PkP/4YeGEk9N3NRCA0tCzySwYH69IU0Za/VlbXU+rBhxME0Qq15WPmRgLWAlrY6vrlxyh8eW+QMqKmYIgoL695eLSDNipjBXGGBdYbJM49Vo5jkFZrP99YLr+1gcVTqb40iEMvmzuQRtExkEDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=lXZzpF/6; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="lXZzpF/6"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-482f2599980so16327645e9.0
        for <patches@lists.linux.dev>; Fri, 13 Feb 2026 17:06:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1771031159; x=1771635959; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A7lM/++ZWcxxWntKLxyYjecJbGQkBr43eWhSpcYnMls=;
        b=lXZzpF/6Us3ohUfVQMqKpMbi7AV00H81OdnwQy4Hx1CNS39/zKBbYTvXz64v1TkiSg
         RNYIuDyIq98gS4RzZZpETCbG/h2WJ8M2XwmnwKumfexCdRUvxrjFUj99XJX8xdPPGPln
         AfDTW242qX0nnUnQs4WugQ9aryrahPQ5KtfCXFvXtt+MFhgyZfUH6jO+sFgW7UWk0QXQ
         Kp5YvxFLuRv5uWy+C1nIq0xedre5r01KKrpmT76Hs2NxHA7ci4MbfcVifq0ZXJfeOojy
         K2SMpUaUd9bi243LtfVqfape9WcPj9KWzZmxHI8vLeXyOyEzwlkv+rW/tBvjeEJ5kvMG
         QBkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771031159; x=1771635959;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A7lM/++ZWcxxWntKLxyYjecJbGQkBr43eWhSpcYnMls=;
        b=jY4DiKoSIOWVZ/1NMqRWzVQQOKYKWJtoDYq/pxD7Usfl9IHkuEwPuXuaCWj4N73v9O
         jj8QLfR+rZ1g4wYeE6kLAjq3TdoTeUbQTF17HRKaOJwHcauEPnQIUwBvt9vCVl2yc3SC
         aFbvhX8YRoeMVZzhpNUR99A/xirN9DcHFNKYCfNmEofZEHA6YfUcMbQSplYNwDRE3BX7
         R8RAzb0h/uQy5y728q6m0f9ODCS9gGtXvYtNy6+yBrWrQT0eQqvHxM4Qw2OqkxMhgngZ
         H6+cgf3ps9b6qW2raZniNt7BbhAzIh/83D2YgqnSNRy5cw0M3csBELNhXVQpIAxF/WZd
         FSvw==
X-Gm-Message-State: AOJu0YwFfFwmhueiGEXaaa9ExHn5v8gRQexbTnevAIQv/GEfIPAragOh
	e8ojMFZVlPfUIC3D1XlW6Gua2FYpr+cjK0rPRJ2G01rXHWY0vmOjJ14=
X-Gm-Gg: AZuq6aI/J/Yuy/ABQMrtMy9KOuvXILbwdLHzkXh0Czpy2PVA4n5BBJ0AvCkDJaoojho
	FX3GkIo4LlE2wK9ejPbL3Ik8x9Dhg30GQLEhN52Fhuj1R4ZyfWfw5Z3bR4pQiHgkwM+MEYgQjoH
	Lgd0T0tXC37x5J7+L3Khi3vHFRzOjfIPeeQcvgbKQl/OFOQGxu5ElKyKNm5PMrJJglGDShxhUQX
	hWZ0uNRqmD8kR8E4Qlyu3MJzju1u5b7/s1MwMAQF4qjR/oCVAwCVk8jYF+K9Bqhrb8AEb0G/hfz
	wmEyClMJkEgHxuaEfGEDpzfAIR2nfwH+1XwUAE44BHtuBKzk6ZYAJJ0oyzMGLClYjqORWRqRr9u
	ateWMymsgABz3jB+AgW0yTUc8C1jClWcoMjBDJ22i83XckVvl+SQpmRoSelsI6vwp/yFgy989BI
	gTjkmBCQwCuajjQ6lo2upAhAjfHZ1roOBk67VJObYCtLwaa3yZjGNyBkCR4ozNyrokg50mlkDkG
	YcU
X-Received: by 2002:a05:600c:4e92:b0:480:1c53:208b with SMTP id 5b1f17b1804b1-48373a7bbf2mr67553285e9.36.1771031158546;
        Fri, 13 Feb 2026 17:05:58 -0800 (PST)
Received: from [192.168.1.3] (p5b2ac4a9.dip0.t-ipconnect.de. [91.42.196.169])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48371a3647asm26346165e9.22.2026.02.13.17.05.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Feb 2026 17:05:58 -0800 (PST)
Message-ID: <db777a81-1611-47d2-bf01-c6cced29a019@googlemail.com>
Date: Sat, 14 Feb 2026 02:05:50 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 00/25] 6.6.125-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260213134703.882698935@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260213134703.882698935@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 13.02.2026 um 14:48 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.125 release.
> There are 25 patches in this series, all will be posted as a response
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
