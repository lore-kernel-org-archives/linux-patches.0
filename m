Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA4F4DC531
	for <patches@lists.linux.dev>; Thu, 22 Jan 2026 15:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769097098; cv=none; b=bMCr0rxLwtu5QsrPTU1amiLe97QESmSktNuTd/mt3P+noHX+5xZb45xIS9BGWho6NIOyHlICkMAN8Mjkq1pSqxjuKHLCazvgV64xvnzkmv4F5EuJ361Ex9NmMkmTkGbD/L8iC1mUjNaQQHJ9aPhjpnSvG5tV1krxLl1tsiD1oXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769097098; c=relaxed/simple;
	bh=rmvs0wUA6Vknh3KvKwpYhY7VCf5Gt2lC67JAUIj8J/c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ittAamywtRqQrzif2Yrg7q+dpTm+rMrrqLJ6UaxAOBCYkbdoF8h8FB7NUOoYEg7nrSyHrUAyyJAfCK2kOnX2hpyj3bqEqLBXGsxlWnZmfBGS2Q/q4JFjgs8fMcdpAC8G6gek3UilyxiT686PZghaQbnHrUHetZStmyd0xfk+aOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=Gn7xk8jc; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="Gn7xk8jc"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4801d24d91bso12339245e9.2
        for <patches@lists.linux.dev>; Thu, 22 Jan 2026 07:51:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1769097092; x=1769701892; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c19nhZZPPkZH3viVYUA+n7Wk9ieUTEkhR5Y9vgtGhyU=;
        b=Gn7xk8jc79oPLYR0hzdm2WbJua0w/HU7k65usq0pAsd7tHFFjIwroFA24NwILGW9tR
         vMchlVXqmDwRDnubtxT77wgQZAG/uYXOSVGoNKZwnlDVFWPl4oJZrFsl8o1hZGisUvDd
         L72h63CBBIuRxMPZxBJicpoadtaa2ICeYcsZG/h4b0nZPnTtjKiG8SvRUmVgkfUo50xO
         WgTeQEocGoqphqYHoQXOxvcxw5Z3P37EHOaJhx+nk2U4xVT6KVYkjxqcjp/ES7sEMRWu
         JomcvA4KzUA22HwJmry3j3VdIOmjIuJAn9NFDsu2BQvoaVr6ZRdlxcFDkmpXODVPfqBW
         mZWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769097092; x=1769701892;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c19nhZZPPkZH3viVYUA+n7Wk9ieUTEkhR5Y9vgtGhyU=;
        b=jD9IF8RoXyiin2CFB63CgoGbWpPBZR/cgtCg2zMdsSTHkIC2JD5r0mDsEpE2Ee7o6Z
         URnypumm1AfcE1j9Xl/CUVJfaeISTRks3Hv3I79CkOjn47uZo5yH+HBeG6wkRkxvBE8b
         LNR8KsbEkBaLr5NatVsbRvYuKaB/Oap2K7mYzvrQ6VpWiBeqD4ze/qjvToKVKaosXC3z
         Rok9+QTUg94VM0M8IhbvkUc1zAnXarZPBItlL1Q2SgP+6tvuFgNjSSepEvp9rt12UVm4
         XxJoifxq3HIpUpTs/jbCou/w4FuJ9wT7k2HYbF3z+U5iXd3PY+t5qhrXLB3ufWdbC9gK
         XuVw==
X-Gm-Message-State: AOJu0YzoFRJ7bPf2miokeqwm9e8rGTJenhGY42/W/fjbu7qsUnMf7Te3
	Rtku56O+S5yaVy7YcD5zD5GHOwPB1Nrf2vS64kwHCsALUSA/W8pQ/Xs=
X-Gm-Gg: AZuq6aJuvcdIlEdN/SiuwxnwGvVfSSKtxhDlUttRvPYz+fVrglZTlXcsOR9zmxpNfli
	nebQan5jb/Xc90C8Mf7RVk+KoH/f97tvZ9kW7AHKwGu6JTXHOiYoUcLrg6gpA4MmukAK6A6p/Vh
	RtlY65gsKzuTNx7mrMV9WwZvkKR3HNqBzp5tN+0c2Jty+zqsGRb2TcbS3/QfzU56+GTdVbJ+4nr
	K1e+uNP38CevPCzWyCRJZ/cVowDd6sn+VUU8RrSkZzAykMWIvrhaAvEMeXVv/KRgoihc4avy9m1
	BAWVre7yT5wkrfIZQHYeJxdDgPd0DfcfLks8n/pyeDm4YWR9kzV//3o8oySeRqIQs8QYPFUsNeZ
	Za8AHAgWIe4Nk7DraV6iDf6pG/SG37kz28JTS9ciiskDtf2iWIXdki39hzF2Sk4nQJCvO25xcGn
	dtCtEk1Pwdh5VKP4MjtUAyFHPvIPG15gTMXy5rgSQULSnefR3iAGpjcMtEkbYVXb4=
X-Received: by 2002:a05:600c:3e10:b0:477:9814:6882 with SMTP id 5b1f17b1804b1-4804c947a33mr1434825e9.5.1769097092144;
        Thu, 22 Jan 2026 07:51:32 -0800 (PST)
Received: from [192.168.1.3] (p5b2b44b4.dip0.t-ipconnect.de. [91.43.68.180])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4804704b4e6sm77029785e9.7.2026.01.22.07.51.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jan 2026 07:51:31 -0800 (PST)
Message-ID: <a45313d2-2033-4783-92a4-b0ec2786cd29@googlemail.com>
Date: Thu, 22 Jan 2026 16:51:30 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 000/198] 6.18.7-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260121181418.537774329@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 21.01.2026 um 19:13 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.7 release.
> There are 198 patches in this series, all will be posted as a response
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
