Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00779214A6F
	for <patches@lists.linux.dev>; Wed,  5 Feb 2025 21:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738790849; cv=none; b=bvNBDNdDTjtX7hB1A0Kc8/lJzzhNAX22uv3C/iHG6leL22zazsc83NfnGRLylqyl+Al8J9ECGoNQYwXm/abX7kS/vjfd4PxZOZF7iwaXYzn2TTz+j8+ONDLqSKtV/aSRAxbc2rwlEzEZ6576T4AfH387ivOL20YVBRQ3x0pKwJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738790849; c=relaxed/simple;
	bh=QD9y9LQemVKTii90PFWUVbywYCREixrRCd8nLKIawr4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fk9A6pco0nBFPhRrM0DTqM5shu2XUMK5FvfxEzv/xCpZXMErZSgyhof5VTlNwTTYh/NbDVEw3nRyxpjTIkIv4oztMRSMALrza3iG3oIEwBPfwH7bZwDI4wZYO2oFE0eJQJ/XRIFNaaZ7PGnJh6T7R04VkOL8yMVWzqWX2jj7A7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=bpkwWESG; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="bpkwWESG"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-435f8f29f8aso1394625e9.2
        for <patches@lists.linux.dev>; Wed, 05 Feb 2025 13:27:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1738790846; x=1739395646; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7Rf2mZryoWttHMkV+6oJudmL5GwtECSwKDELUfw8XxI=;
        b=bpkwWESGdUJApNxaCJd3IcDduUmpZT1mnVQzkrJWrAWap3Tb40T0oKdA29qD5PNxNn
         gFB3dq6C9cUcgWVSpS0N7V7f0qaEokQZPXupVngICHyU2GMEt1wUFO9jRDAORdJxyiOI
         GrpTOmwdawIa4/L/tw3ZaXz7kLgFq7qNR0uCCLITh5gLrgTF+tLCMHR7t+EUjKZEUXMs
         Onq9SE0dKHDJqgTavad2ZOKjj4dCvAhPiForXtpwI/WZMkycgaoj8gyD4KJHhVAvsZxe
         lCe3l/0AHDfy9E5DcQpv8uY0jfo9lRPOq2oaehyJPITatet4ML1RUhPBtZmYeC+fKj3r
         eTGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738790846; x=1739395646;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7Rf2mZryoWttHMkV+6oJudmL5GwtECSwKDELUfw8XxI=;
        b=Vv6jSxBJFRaVnj3AbcjLF1WmcHPJY9fITbG3UMGA+bS1zf8Iphb73uee5wkqAoa56B
         5vGJr+XwwVEvyuXLiVIjU1rEkY8uj9NwBSpSPLapYBJ5BI6P76h6hQ3SnJZ+UyvvfXdQ
         /pxWpxpasPQDX5ip6DM7K34f3Ss0dyXmymfbY2F2WKlkHV7OOtthUhpKy+UxTe11SHOw
         NJ+CzXOPCgCiDcK+MefVBqWi0K0+LL34P82/rIVfDOUoYAHsYYt3dqpDYmRRW6tRzXwA
         9NR7X5sRXwt3FXtv+esk+DUxVSOPaPp670RYPabLsy65Nmp7RzOe1w7Hmkr/2lrZqyfN
         IihQ==
X-Gm-Message-State: AOJu0YzedbbtLNgZInfaEYHHYIFHlROr7jV5hHeLkvDPsaDl3RWpauxN
	VrFkyUZXIXMdYO1tMTOdraey17pQb4QipxBwnp/j6wkHmDTDIW+qPMLk3Og=
X-Gm-Gg: ASbGncvP7ml4k9xtoeKFcD9tD2hHnYxcF7HzpXHgk+rpfGnqiERoUCQodDyA+d+Xm4L
	Gk1mqHPFiNtlVCBlGJJOx8htc7SGUjM1NkGzktr+YcVZC6jr3OcEHytflrjqP0IK4DEvPmuE17u
	4/jn6vEPLvxJbJE3uuic+gGnyVSmu1wUg7FoTeafKUsaPCpFaqTCbh5SWx5woFbz5WTSsh1EvMI
	l/uYzdqzZZCisnGFF67Jy6YiAwt5l0H30yf1/L5q/19vcCJbfuUnO5btTo8bFhhI9UOb3kNyaOI
	hwxqDybUTCVPQWk0i5C29qmfpVg5swIcgdlX1SeacubLAozYJKYSLLLhtAGfCA6NPbbe
X-Google-Smtp-Source: AGHT+IFFQpAZLv7hW8UOdcGZ3nVzkW+8Tj96nnnPtvS+Rrjykn9y47soqVCJLvivO+CRYt2RCFFHRg==
X-Received: by 2002:a05:6000:1449:b0:38d:b107:d541 with SMTP id ffacd0b85a97d-38db491f553mr3458351f8f.37.1738790845944;
        Wed, 05 Feb 2025 13:27:25 -0800 (PST)
Received: from [192.168.1.3] (p5b2b4bac.dip0.t-ipconnect.de. [91.43.75.172])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38dbb34ca6esm523806f8f.62.2025.02.05.13.27.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Feb 2025 13:27:25 -0800 (PST)
Message-ID: <163e78ec-5c5e-4b9c-8c93-44179f93268f@googlemail.com>
Date: Wed, 5 Feb 2025 22:27:24 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.13 000/623] 6.13.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250205134456.221272033@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 05.02.2025 um 14:35 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.13.2 release.
> There are 623 patches in this series, all will be posted as a response
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
