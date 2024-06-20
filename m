Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409391B47B0
	for <patches@lists.linux.dev>; Thu, 20 Jun 2024 18:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718909854; cv=none; b=iNnKAfs79uVTLzvl2H/WfncQjEJLwwozi2YGZcJb/NMnFcLFA9mjNwaXLzzBLS8SE8J4eLx3HkD8XWvhoo6fap4inFE0DNjiYAIXn4G1Q86xzmJ9eaok34i8LTnSIqRDWRrrzr48mdnhbachXHFimlU4paj/Apy1dTVeK/GkXCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718909854; c=relaxed/simple;
	bh=WmnGzckqoS9EvXVeI4BC5/GdFfAZx+Tc5RYpLkbmGV8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LG6nqlVT0T2lFt15hr/srY7nhV5oLtgCZxnnmw+arlv7UH+P/AHpP58AaKlEw/YVui8Ix9fGrXmlUP6HwlRY/6V/iR3W4nmHdWDk3rhCsXwLXSXObnmKFjnQQNQnZe+jgF3Ifci2FSuCr2gN5aAS6IE5l2sdjxYqtpsMIJMcQng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=iF0HEWBY; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="iF0HEWBY"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2ec4a11a297so6819301fa.0
        for <patches@lists.linux.dev>; Thu, 20 Jun 2024 11:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1718909851; x=1719514651; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wSdNIerYh7HBDFHCUKiEp5OmK1zvusg/xzfllJOo6rE=;
        b=iF0HEWBYULrXfz0AHgVXxqDa2hYhEgsmDtKAJGL4IoXsz2J3vQiq1xymbSwMcZJJE7
         TqKPPh0rpg7quaAj2vpnTEji0q9F6E2E9CpswXFETUAK9e3mImvQi6rsA8rXDE0a76Gl
         4mAC9Zpij7irnXGDyhonEFTgUQ+07T+cgV2yHZ3A0xM93P2EVFPp8yiLxxVl9GKAvds9
         40riBhwXW+BFuPbe7j9Ijf0SojSBshb8+VadMzQcIAv2zyl1M4+GBAQyQt1R6dmgRGEG
         4yXQlefBNno9u1X5XhoAJytj6Tv+mIuUZ3nHjKmH3oPu48x7hs9MVDf9f8oYSz6F77Kk
         3FMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718909851; x=1719514651;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wSdNIerYh7HBDFHCUKiEp5OmK1zvusg/xzfllJOo6rE=;
        b=FcuvcS2QnGcOmWsogxHtfcpSXRWv2tP6CUHJooNWjpVhyTza6oSHWU0N8YYQ1CvbH6
         2v1kbMDmyzgnOSBDMna/xmaLIYx8CxF5uBVmHBCIH+C0ieu+cV6RYtshiiro3hTpsgyh
         ndmTfx4MVGmwr7TD5miwCYOkABCxFjP7ThwPFzYjuISo6htg0DWw/XeoCaVD166RWpXC
         sLfaan2UE2OQZs0wQ7ndfK3CUO1OPlZ17ohHSfxPtVayrH7wimzLvpIPMKN3iA/tKvgC
         5IpUQUlV1z1cDQSU6zaIgtFyTzOew0xL0sXSNJf14ZrKH1Fhs1Iae1x3C4CXo1us783r
         Pibg==
X-Gm-Message-State: AOJu0YxqHrMrafjccFcOhIooqad0R0qF0JsL6wfVV3atW9PUw8kQDPKP
	8oMY4bRew9D4d3bYORuMB42eaKi8VfNQI61OuVykl5MR37ONY64=
X-Google-Smtp-Source: AGHT+IGgy8JPQj0MTXMmRfzDcTg+RoUYxrxtvDj1FYjjaBOAkLKPSQdJH6gnOc+yypSYQhY+T18Qvw==
X-Received: by 2002:a2e:9984:0:b0:2ec:2779:32bc with SMTP id 38308e7fff4ca-2ec3cfe9a30mr40320801fa.42.1718909851071;
        Thu, 20 Jun 2024 11:57:31 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4f33.dip0.t-ipconnect.de. [91.43.79.51])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57cb743890dsm10021703a12.83.2024.06.20.11.57.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jun 2024 11:57:30 -0700 (PDT)
Message-ID: <9f8953ab-c075-4bf8-afbc-350574765214@googlemail.com>
Date: Thu, 20 Jun 2024 20:57:28 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/267] 6.6.35-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240619125606.345939659@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 19.06.2024 um 14:52 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.35 release.
> There are 267 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

What can you do between two soccer matches? Build and test an -rc kernel... ;-)

Built and booted successfully, works without regressions (built another kernel with it as 
load test, using 48 threads), no dmesg oddities. Dual socket Ivy Bridge Xeon E5-2697 v2.

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
