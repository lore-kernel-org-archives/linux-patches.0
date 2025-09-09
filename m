Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA9934AB18
	for <patches@lists.linux.dev>; Tue,  9 Sep 2025 14:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757426934; cv=none; b=szpuy2oc9SGd259lwPec+wdVg4oXLKxsc85bh4WPUG5UbLP7X8lWscHP8m7Y4ek/33Kx/oHzoFV3u/1qxdq3OK84XmNd7/spXKxJquqzGEh97NYrabV2ACgThaj30KhbWf9mLSz6US2wBezwLZyH3Equs3xo1G7H2WI4dXYGKEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757426934; c=relaxed/simple;
	bh=sNnWLL29rUT0pKNPRkt2AG3hxp/8N4KzCnviTWEG84A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EOPUfTsbICTGjSGhmxxAEnJ1pdk7JYpu3wQs37oOc1zuuJyOL6JFhHdz5hyfMNrZrHp03hshOSwqpfkFuwoY5bNZJor1kdc4dG2LXm2l3VAqwGZ0zZRavgDjXtKbJ0oyDZP/WIiHTVgvGmMOtuCZ8o6aDlY/2Bxd8Wh8kVwy8rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=kUA5rvVi; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="kUA5rvVi"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3df15fdf0caso4357796f8f.0
        for <patches@lists.linux.dev>; Tue, 09 Sep 2025 07:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1757426931; x=1758031731; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FcsCbWoN3iCLFYC0GWMkt8bPrGz8pyO9oA3ZfhNfrEA=;
        b=kUA5rvViqU8rokLEj4hKS7EAHP1lj2kA84TgWuy8HjogpmFdQ6jzawzXeL9N2izpHL
         pNMqlnGgcADMp6L5aoGsWw8SsZV92t5BLItr5hlTU1fPcMSdememWmtcQTwgarqiwbro
         OQihApt1CpQ42c2skFrzws9ISlN0CfsYLmiPcwPulOpA5TI6FNOOZILb+LX/ICW0pfYU
         V1evZXa/aJ1rHsXZK75E487xxjc0kawxoi/xuCvjnj59fH3lVr2sl5ukGsCVUJMKnuw/
         K77FlYzmYADQrNLwPEcm8mh9RHjF/0UzXtUPM5xpV2DIOVj7F/sW4jZB5rU6E0iZNsgA
         /OJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757426931; x=1758031731;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FcsCbWoN3iCLFYC0GWMkt8bPrGz8pyO9oA3ZfhNfrEA=;
        b=o2yonMOjXnvuLvdXpfWzYgxmQh5uK9P48Up39Qb6jr1rXIFC58OopHPSgtMrU34Yb4
         pq3x4jDrPz/XhT53bksuwAX+b7Vs76q/+KT7fxsSZvtTsXUAOne8qlYoOx82/RgywpT6
         uopy3f5L2xTDZmMNyyzv3/v2wrFv1p9WZ3MPhYakQQsy+HDtgxjfZq9qnjeXNja5c2qz
         5mOz+Z0DgbEKAj/5RYyT8s/MPoV+inGjn5VC7+GjAcel60yM+9qkUiSBrXuZmzJwMGiF
         V0ZC+/qoIxoe2UrHjEdGL3VVewnryOQRebgBux8j3syZAlKmKyBDtd3Ln5OQMvG8C0tY
         c2mA==
X-Gm-Message-State: AOJu0YwSPkbYWXZjxaJiFhTKbGNZ53soTlYe0/t03xn9bBU/tpJ6F6C1
	sdPEHwI569UUbsQ1aRGZ4nvLXOo0ti6LQDcpLhmp7gr/lC+hiyBZgdE=
X-Gm-Gg: ASbGncscKbeaj77Ifb/d7EgI0cpcjPsxYdIVLlhVy+rPaWCed3V+QKA4bbH7RgZk6Jb
	DVYu5KbloSVwaH0Ko3XXwS098Daa17SPoYUqfAZCSoFe2svUiR5LRrEEC9zgEaqtEEfxgmb56DC
	UJ/toVg1BPfcaT9+YAdNH7qCCwXuabSrY8ujr9Y86lxj44iRe712u0z44G/ou2H61ok1Sk5uf7P
	r+7jbi+y4BBgf3wMYsGGKGHhijiAccZkw8i4T3R3dJfqSK7sxlRE93nyUVuUHyr45hO9QyZTkMu
	v4zZHvuGzl1jezwFj2rPHRs/e4D8vQRyXB8PVWHKgXzLOWQ5HQ80JRxN4fmLEaFr4iQqjtM15/u
	trUVRBL48rEpzLX2SDlCHW5OfqlG4sEu0Vv4+ex2ccK1PMj2c2B3PWo1RVA1Sb1Zw8hGqOE4itQ
	==
X-Google-Smtp-Source: AGHT+IEWWpTkOQ1mRMXr+JVzPNgGbgKVdcKr6veRQ6y6ofzrdD9M/cpyO4YaQuUO8aZE+eAwdHTpUA==
X-Received: by 2002:a05:6000:1846:b0:3e7:44c7:4bc5 with SMTP id ffacd0b85a97d-3e744c74d83mr9153674f8f.25.1757426931164;
        Tue, 09 Sep 2025 07:08:51 -0700 (PDT)
Received: from [192.168.1.3] (p5b057250.dip0.t-ipconnect.de. [91.5.114.80])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7521bf610sm2814855f8f.9.2025.09.09.07.08.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 07:08:50 -0700 (PDT)
Message-ID: <a423706e-b5da-42b0-a759-1aced1775402@googlemail.com>
Date: Tue, 9 Sep 2025 16:08:49 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/118] 6.6.105-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20250908151836.822240062@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250908151836.822240062@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 08.09.2025 um 18:05 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.105 release.
> There are 118 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Just like rc1, rc2 builds, boots and works fine on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or 
regressions found.

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
