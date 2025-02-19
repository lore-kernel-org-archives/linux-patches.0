Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED73425757
	for <patches@lists.linux.dev>; Wed, 19 Feb 2025 12:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739967870; cv=none; b=HKfd18lsoJGsXI9DCzkd45qzbBP7rU+54GXQ/0P/+8b94aDQA5juye+KYCgX+O5HsK5eyiuizrv7IAWshMpWpmqF9epME0JqwrtwLwpx71tYEqZmqbo5ESkGsIMsAiasSdoLkbd+7uOJ06ZaTe1mvJb4WBRdiRl48zcPBBWOqPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739967870; c=relaxed/simple;
	bh=Wvowdqymf5/Dqdnx+M8deGxluothZgxktjlHvQgPEC8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H7ysKD1dfH9zTocLpUY3Yk8crc30dHVOQa0AiSrBqTJ030PgPTK7eKvLcjhmaE3Vm9Pf8AVMGFTiCYtdPWOJu0QCwQQHlo8tznaBZK63VwIf17VdbtekbrZD/ZNoGO6VOwMnCgOM1uBKBfDS4Wtpis7Q3bZkGl+XkxKD9jbZIKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=IQKJBFDe; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="IQKJBFDe"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-439946a49e1so12545875e9.0
        for <patches@lists.linux.dev>; Wed, 19 Feb 2025 04:24:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1739967867; x=1740572667; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HYKifUeShoq6767eZBZs5H40X1Lc9yEO/hHyexjEF2E=;
        b=IQKJBFDeS8XI+73FjP4jKFTIsuB7jovZlqOG3f5uBOGWWLfqULiNhkHm5RsOI+U6Ct
         NznEp9njfewVIRrUYqRYyqh6PxvWNjn05C5B31N0XAZ6KSZHQA5LU6EuDEL52m0t8a2P
         CiZuef/XcZ8mT/qf96+s7DqxG6A73V4nYmTX6V39wBq3D9Zbrm5OvfktA8kg9vkM6uak
         1e8Dp2KstjvSutBVmaOyNRHuukuAGgDmXpjdhLwztv26Ah2Nodvxv4yNyfq1GNiLyMgl
         9o4fQacgjWHBcPOP36FNPfraAHtEM/xvGW9zvQTzZw9GMYjTLIibJRc12IlUNl0RS8TA
         g4ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739967867; x=1740572667;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HYKifUeShoq6767eZBZs5H40X1Lc9yEO/hHyexjEF2E=;
        b=UO2O29dgWEQa/OaGk19ppjBPkRRegUDAHc1TZf0Q7i9+bC7QMEkNpiAsAVxEPhhJF9
         xrTeIEPU2PLAqzZ2tx4INgipRjlS4GIPB3tPG5qFbbILYIdrhtH/HWGjcgGyqvpIXZxF
         36E/Bxum24Aks3hoNLKctYD366ihSSiC4S8oKGAUENHZYyZzhzVkwSQBwbE60dZaO3Iu
         Gsh/18FA7sSKn7tO+9xGsEE9cA3RyWikvoTGB2i9eHYCMzWB92nMBX//bW0980Ss2JIi
         gafqb5H6okkoCbG+Ce+as/RZHZeWwulR37yb5ZuMkmsbXySfbJ9Y4gquN3EnD4FA3ido
         b1qA==
X-Gm-Message-State: AOJu0Yz/R4BHqPDQ8Z5g8xcM16k9GPhSGP6vPVYWbNsBAjcA21dWOvsK
	XbUwJRYibqVEL3w5X8nBlDI0r1E75te2IYZI4xtmmmYrQ8EP6Zk=
X-Gm-Gg: ASbGnctVGzQwq97yYSYcjdcNFoO7XrKUH4FT3G1x5VuPb0b80ovTLGrI/AYForfpD3D
	GBRgpcXFK9fnkvrHWOHdQLU0touIAbgBSgOSiRy0pgFIILrnevnztyy8a706SZ+f3kZ0D4BPK+g
	e7jp1HE5Fp6poSYt/atB0SF675ynbUmAZItMTzqNArh8ForpFSSOCg1DlczImtqDcZKb9cgiKwy
	bMWBsTcXpNSY5JuXU5wjZuqe/qyWVTuC63dUEPxzDFVH2gYahvGh0KKsKWSO0jD++FvcKF8QYyS
	FGHQqQNVgxvvYFm267I2qU1JfGvEhmmc9JysRRwASeWid95BYO1lDMB4IIZXI+BzeqVr
X-Google-Smtp-Source: AGHT+IECUoOne8WCiWHuMOBx74a4ScsTJCgDD8KlsTM6vvMn1KSLw2JesZOIE6aOV7faWfyLfsUaAA==
X-Received: by 2002:a05:600c:1c21:b0:439:98ca:e3a4 with SMTP id 5b1f17b1804b1-43999dd21a4mr23992985e9.19.1739967866834;
        Wed, 19 Feb 2025 04:24:26 -0800 (PST)
Received: from [192.168.1.3] (p5b2b4e7c.dip0.t-ipconnect.de. [91.43.78.124])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4395a1b84bcsm218515835e9.40.2025.02.19.04.24.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Feb 2025 04:24:26 -0800 (PST)
Message-ID: <a53ecf4c-ab0a-4434-a329-0d2e917fdcd4@googlemail.com>
Date: Wed, 19 Feb 2025 13:24:25 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/152] 6.6.79-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250219082550.014812078@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 19.02.2025 um 09:26 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.79 release.
> There are 152 patches in this series, all will be posted as a response
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
