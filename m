Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BDE9631
	for <patches@lists.linux.dev>; Sat, 27 Jul 2024 01:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722042348; cv=none; b=u0Lg3ncEd3/V3xG/hXriYPvWM/Gqp3up/355E+h1wm6pVv8nPMVJGw8TGwlFt3owUdZA+89FrWwkbussXt4Y5Hy/Gp23O0XL+cDWNGQZgkqvPOLXmVnPJout7qU6PRFiZnWWAr23m4AguBHdl/N/HHMXDDohrmBt2ILHgLoMTQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722042348; c=relaxed/simple;
	bh=eBM00HPHPHHPgnKiqzyJspcHdFqwmz4Hw91GAOe7BsM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K6YA3y3FuIO32kmYoNkN3ueyhwejPVf8MA6Jln7BYDGlhdeoU/1Hz7TBm+GCRQkbiw4B7ze1fFQJeCYb5TgDnUuxMoFhilK5ZAYJQ1lazbeZViJbH1rwo5QKDC7oRjjftuAKi89AWchpjH1h+tCY62nWM41EN8kvyG+NBSOaUhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=A8PsrObf; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="A8PsrObf"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2eeb1ba0481so27182571fa.2
        for <patches@lists.linux.dev>; Fri, 26 Jul 2024 18:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1722042345; x=1722647145; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YCpYlMHHYU/MQ6aVrJgbcTOmXWPj7kp1NEbwn6nBdTQ=;
        b=A8PsrObfoksyvkRbGnjpmGuXC8CFJvpwcGzW0t8/P8ZAW60STkW23Te7/ZfD0u3mCW
         tf6QZSXD00e3SJ8799uLs5GXl9+XbnzFML9e2rQYbP0R352rpq334o/ZznCKGx0m1mHT
         /pBPluWN+qlhfGl7Q3o87Oy2FtSLdq4GfuU3fuqKfG0BxK2J7uDpvQwJ7ixnt91/YJGr
         uX7feqpy8qBFn8O3tzJcdfp7zOryUEjJq7m5SpF/kaCdRysAhhILlinyp50tYfXtIovp
         YdcoGDi47XqwTHxRQnnD8kPVbkVZ671zJOhT5eolK4iw9aE39Kt3WejE/HKdUsN9MgY/
         sQZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722042345; x=1722647145;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YCpYlMHHYU/MQ6aVrJgbcTOmXWPj7kp1NEbwn6nBdTQ=;
        b=XanoYJxC/L6xSWHvlSRBTvLFQEQPH1nyrZYrXVZWtCEPMDfbdp8IJk4uwOcxpR0TaV
         BGXaWRyMak8Pg/9mbgRZ/G175RP7Ty8I7J+UubLX7hHjQWc2Z0LCP32pKaCZqQodSk4T
         JJiZu9VENwrx8xE64pyvaI0mGmcGeBBXDyNREF3bRH91LrjHP99XTT1YXc5gPe5PrTIP
         ltNCIwiLKp7ksIGo5yqnepQlAzNRWYFSaWb6BGEFEIUoRFJMqrMkfonmrQRiS8SWeQps
         a4zES9u5dXnY8wm/HjGuTND4gq8gWpRLJr6f0uW0ez/jF5O+E9fnO0XVePdD1U9EtJzU
         LmdA==
X-Gm-Message-State: AOJu0YxqddmyPvgW3FTSH71yRARUVoFqSqxRZRLqSKNJ2lwowvpKgds8
	PHFgUoBHasHkhJSxyVrUgjiDLJg3JNi8nvfRbaHONdymu6YTTX8=
X-Google-Smtp-Source: AGHT+IGtGvxhQRAK565ipUYI/VEWvAFVhGLiYkiIBm6tZ/FoMfehv5V035vAuked77InbdG60d2IfA==
X-Received: by 2002:a05:651c:128d:b0:2ee:7a71:6e3b with SMTP id 38308e7fff4ca-2f12edd8349mr6462661fa.27.1722042344897;
        Fri, 26 Jul 2024 18:05:44 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b41a8.dip0.t-ipconnect.de. [91.43.65.168])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5ac63590cedsm2496802a12.29.2024.07.26.18.05.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jul 2024 18:05:44 -0700 (PDT)
Message-ID: <4fd87233-ad60-48bd-a6bc-fc14fc8a45f9@googlemail.com>
Date: Sat, 27 Jul 2024 03:05:42 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.10 00/29] 6.10.2-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240725142731.814288796@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240725142731.814288796@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 25.07.2024 um 16:36 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.10.2 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>

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
