Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E832E639
	for <patches@lists.linux.dev>; Thu, 25 Jul 2024 20:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721937888; cv=none; b=FWLzSBub7otpALAhGSuaverVxOTW4aTBKEqeHRS34ubut3XiFdDykMXtf3ba1AhA/zHia9Fm8YjTFzxEIY87fE4/8O9BjoQdUHWiuXHAJaEhQi5zciSxe7LOAa1hGxcDje2MffV1PZ9y9VeokVZ78TNXlun7CMVK4iwkHIwFlSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721937888; c=relaxed/simple;
	bh=0zB5it7uK49pQC3YTBqbw/wBLjvQ626Ng1xUR2KMEEA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Stsx4nraceqWMN7een23LxOz1swbuUdoREQGccUEjYQXYElKdDypfRitLEPI0AFSNhvybQWqyfr/o8FpGCSt3vrWp5wJiewQbGXzvcYwopzHrqW9kqtTkZCYMM9wWVCiDjfaZqqvs5bRDSNxFH2beSdX4wb4qpJ93lfPST2UwjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=TSlwMyw7; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="TSlwMyw7"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a7aa212c1c9so113475066b.2
        for <patches@lists.linux.dev>; Thu, 25 Jul 2024 13:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1721937885; x=1722542685; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BJIispQ3EhnPiKSUP/X4tjbEqf9+Q8SqMXAI+5oyRU4=;
        b=TSlwMyw7nRYSeNpuDIU8labNruhq1leUw/a3dQkFcB6ZRwz5luXamzv5g58gkRKoBw
         t5y6v9h36dzHG1p/UfpPe4fv/eiWJ1qbeuyFQHJLdJhw2BCZxNFtMsfFWZ1Kh5axl5BH
         ACgBoxmP1xINMmM20n6CbAbNdSf3USF7bsjmlJ31MVxcqUL1V8RA0I3Dbz29W203QHKh
         0EfBVvlRPZk/AOc9uXh7y6rQ5OXf2e41XRiF8UnYaqM5RCX6Zz/Ry2i9zWhI6gIwhRX5
         WDMPvkD950TTNWUOWHXCX0gnuy7O/fHxc10BPH8m8YXie6bpm/HjI9Leh+rG5T7MnLn3
         AcbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721937885; x=1722542685;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BJIispQ3EhnPiKSUP/X4tjbEqf9+Q8SqMXAI+5oyRU4=;
        b=a/x8ifX43ljFGn12cizFAbcP8uP8866OSIK4qqOMBYr7YzsEYSIKFeMYxPF4I7vDmi
         VPw3XmND4zeruXDkl/Fd7wQSqDxMCi7ESU2jd4+576/inJJ30PVwX+0OggLNjbBmLp8R
         7z/qh/Si4yv0/1zcwybNWiuG53Qvwdw2AuXj0a0Qwqt4KBwFIs7qmMpr+9JQMd4RIrHh
         nKeguKF8cyaSnm6ccOs0nMuntnuk/EACbvGmunuRFABf/2BdnxLFVBf/stItPIOtVqx4
         LsqJcetxkVPxGGiSieKEUmr5Ii2O/phl8K1llNbIxoO5uaJfLicjkRbMAblH+wofHATe
         8rWg==
X-Gm-Message-State: AOJu0YwwS2ozXbNqwbhrqGUGtvXynvgmZpL/QH9d/1wWJ/uIAvz1CoMl
	YS3V2592Wd2eikrL9qBaH2X7L0aXqXungu065R4LnNjVJF8mojw=
X-Google-Smtp-Source: AGHT+IHv+JcRw52C81YjbNlPDk230BPZ6wrLJ+DFbuw6XvAOhzZdLdGqm8xx+I9UbYb+HxaG+LizZw==
X-Received: by 2002:a17:907:7296:b0:a7a:952b:95ae with SMTP id a640c23a62f3a-a7ac5075296mr326877666b.47.1721937884882;
        Thu, 25 Jul 2024 13:04:44 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac836.dip0.t-ipconnect.de. [91.42.200.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7acab50cbfsm103131366b.47.2024.07.25.13.04.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jul 2024 13:04:44 -0700 (PDT)
Message-ID: <af0ac6f4-8c6d-4a02-b771-d47347a15a1d@googlemail.com>
Date: Thu, 25 Jul 2024 22:04:43 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 00/16] 6.6.43-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240725142728.905379352@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240725142728.905379352@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 25.07.2024 um 16:37 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.43 release.
> There are 16 patches in this series, all will be posted as a response
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
