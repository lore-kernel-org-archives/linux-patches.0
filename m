Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7281A32E6B8
	for <patches@lists.linux.dev>; Fri, 13 Feb 2026 23:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771026898; cv=none; b=UBugDtO3+o2MDv1E7iBjZklwnyUYt54af1W+R0H4UN9a6CgLT1AbFpbVejrm86zlRmfCT9s/Sk9ELqv1WKiHpld9wvetuqcyzrpRuhI8DdybxwlA6arPN4m+zana+196g9S3u6CXFrmIjG8qZR17ZFubCe/t7VVK8LwuPXrGNkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771026898; c=relaxed/simple;
	bh=iLi0x8ABwqvP3VGdPPi2F+bpEB7csgv6xB7LFpKm8DA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZlH88c8J/V0L6aKrN4YbHUdL09sHlMVOP+H/xGmf5dqn7W5xa03Qsbprh3NUzHbTwTUSUI5Kc0qCsUgM9HSH42taAWrS0hzo8gkViEnEPqG7ljbDxRIF1m3Sg/iZQM/OSejJtCO3WUz7sLQHT/P0x1zwcNJ1vU/lz5zauZrR4jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=Fi9IwPZ5; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="Fi9IwPZ5"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4836f4cbe0bso11673575e9.3
        for <patches@lists.linux.dev>; Fri, 13 Feb 2026 15:54:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1771026896; x=1771631696; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CBU16V7AQjuzjpZAHD9wwaq5lF1T4FgGsAyYIBiZCbA=;
        b=Fi9IwPZ5ItWr2tkqpENrxqzjy/hmbVtnhGyzEaZteauzMvynTE0PFeKyXYZaGDSi1K
         Dfa55MWEUiRiPRktMGFJSvO1f02DONcANPvm0/8LIxYG1p0JmuGqRd6vt/rvw9NWX3nI
         sUTZoU1YXA7wqsqR/jI5UM4cAGSaMSwCGMVvU4J0DkCRNWa+iHnBVU/APsEOIqo3gm1D
         Yc2CEiMvKSOkEOjwsrNaWTctFWl3ZTrttSejcE7gCWCsjh+XqiM63vkzDk+mTuQb6HTq
         Zc1Y5gK+Ssm/aodtBF2vLbBerpCLUUBGFumo0qgACNhUujQMlkTfprL+GCfqmF5AfG9x
         X3/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771026896; x=1771631696;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CBU16V7AQjuzjpZAHD9wwaq5lF1T4FgGsAyYIBiZCbA=;
        b=pTMihIh6Io5Hrry29dTKPONhsKmatkqLdAhcbniiZGBJxsaf4OqOV0Bi8lYyu6nGxr
         +NdEMMlP+TxFg/eCSGUnt58Iyom24RBgYSjp4cz+ySI5cZktwpwg7GcEG4FdeXTDz79R
         3i1Om2qUQexZa35gFThVd4Ztr6wdUznDrI7XgtOuBY2M82A15E6FnUN3npPw1X6YmC7e
         Er8NRPetWjZR+ptXpeUXAFq0GT44gBhaU2mjcx0MpgtoIB4A7dy4qc+Y9+eP0msR3yuu
         qN/YsXg8qNleOKzghR9r/7zDNLpxp909C3vq0oIKviq/sVffs/GQC6Gtcx2JcYtBO84B
         O/Yg==
X-Gm-Message-State: AOJu0YxBnWOnaSV6e+aWFwQjFOwIVTpRjBT7C/HjM0A9seNKQ7/y1X2+
	UHiqpkN03MB/lUPH50EtRVcGbLK5qXYE+rfRw/D3hHamaA+6BOMk9x4=
X-Gm-Gg: AZuq6aIC7LKKJW/T0MdpSsQg44Jedqp7FvxZA3wsb12etdsFGfNYJCHCtwSfkuShSP9
	8jDJ2btptjOhAV4/ZTsXf3lc5AC7xjAVMxVjzm4wDltdWNTNPHGVr/EsnprcwqAyPqSwGAAV9DR
	M4O2VxQ7jVTPaz1GbferAQ3TKJzqy9rljUgLqFHtCmWdhliFw3zT8siJGDoYic9KWsJoGmGPuc0
	ZsrdFoOx0+PppUMX6oHjk30qEQQ6UvJEoBNxHVUZmVlonC2xYLaUawRny0kPYVbF75H4i7tHVKt
	U5EUtrC6TX1UDNgj75hnZCMBjgJA67dS/Pvkj0gL0UZ4oHMh0mP/F6Dt9PrbeDOEOlIfuMJ5J74
	+1Iv7SmSFiV2xKI11Qm7pMW0Qhh56VzXlFR0k7jaIKilxBMP5HNBvSB1yUC433fh5cRCbJZHIHp
	QnlG3fbVYLMOa/PZV0KjuNG2LIAGDTQYDCfjMQsTKyFoB7/a1iGJquPEEJVYfqONO4vEZl0r7gD
	0QK
X-Received: by 2002:a05:600c:314f:b0:47e:e970:b4e4 with SMTP id 5b1f17b1804b1-48373a6e371mr47029055e9.29.1771026895679;
        Fri, 13 Feb 2026 15:54:55 -0800 (PST)
Received: from [192.168.1.3] (p5b2ac4a9.dip0.t-ipconnect.de. [91.42.196.169])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4834d5ebd1bsm323916795e9.6.2026.02.13.15.54.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Feb 2026 15:54:55 -0800 (PST)
Message-ID: <443570fa-1e2b-4043-9625-43c740551794@googlemail.com>
Date: Sat, 14 Feb 2026 00:54:52 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 00/24] 6.12.72-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260213134704.728003077@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260213134704.728003077@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 13.02.2026 um 14:48 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.72 release.
> There are 24 patches in this series, all will be posted as a response
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
