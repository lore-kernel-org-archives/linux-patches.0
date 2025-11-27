Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2B12DECC6
	for <patches@lists.linux.dev>; Thu, 27 Nov 2025 17:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764263432; cv=none; b=eCoc18O69QT+HSK5OJedPgXY7aOWHwL16qk6IFIK2Mmemj2vUW39yZT6yfqn1GK/2jTWsM0xT+sDyeWKTWsILs/zEHwwPzrev5qvlCgneCWOiwvmzA0WsWPdnbjGdzRjLzR0sOo9Y+38XfWF7RpZQKS9pAMWHsTQJ+3PBpZCjR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764263432; c=relaxed/simple;
	bh=FFJSR7QVGE1ZPDpVldLbU6gH7o/4h7Y3e2+amvvHE7g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CbMvpKeTkj1ORI3AJDHF9J49PNdc6NnPc40qs+zE41hVNJuiA3Pef2yXoBMeP/1Gxzlq+kRtwlGdmZZsp2ONvDvey7wc5vZxchttASBCqHc/yX3m4e6c6VzrC8u2/bs/yPmUoqoU03qmQfKIhKBNEuWv+TotbSeclywqJ0wOxzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=HX2661DC; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="HX2661DC"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b76b5afdf04so195229466b.1
        for <patches@lists.linux.dev>; Thu, 27 Nov 2025 09:10:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1764263429; x=1764868229; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JmM99+m+hpwo3DZMblc3kjgR0n0LNQa8ZueSm4dBnlA=;
        b=HX2661DCcOVq0MM6W51szowLdV5vKpbMiR/V/G7fP1UBzHggpQmutw9wDKxTPayEgh
         klnu5UF2buTuKsstrOa15HlWu6CbWMax1QE8dqe8ib2znFh3tT3gj5bLUHvUW+EgT9wD
         eJG/Se8RaryKfWcGsPKQRUJayWfueXP5A9HZJsYFl8VsHJ6z7E+lp0goIij4cs2n34Xj
         bW+x+pF/e/JGqRZSwX0vkk+dpuktdbENr/1ygdZlj9T3CiY/EBxXXLuFmw3rIwEQ0fEr
         TPWd9zMsHn14uF+0cF3YzFqhQE2tHdyCla1VjgIxITvjmTfMEg5EEvea1Pj5mcHNz7WL
         Ougg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764263429; x=1764868229;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JmM99+m+hpwo3DZMblc3kjgR0n0LNQa8ZueSm4dBnlA=;
        b=PdCtC3nKG/Hh/mtmy1z/QBQsFaSJqukb0ERT9Sx0aLaqMgnu+PK3mjffBAzfqhzdgc
         GRlNJW9hWPgB+lYpuzNT7B/KVx7IBCdoqpLAtwBf/QUBSQwMuo5c64XOFvqgfqmHpZ1m
         rBoZFyTeEdL/ALlk0UR1PI/r/ih6ms2F8sVNHrFLh/T1BLHtT74kKCcSY/Bu3ol7y6m3
         YWtx7Nx0W0dILgpocXPH7iWnlCLe3v0MLKe/hFEKz8X0/+I0ZAgTzL2j1Qcp8r7ssoeZ
         0kgeIlyFzvI4G8pp1Jwh5dbLMemJjofN+jz5wZPuIKBbfSdlgABdKjxgcHSWWffF9vVR
         ejUw==
X-Gm-Message-State: AOJu0YwYhno8NAxvoO40w7+309MU0UawR8xI5mOuOAzFZlTX1JRKe5Du
	8dd/ADPQ9PRp1CtSkYxFB+zGImU4msk3UqiuzTeHG+iriKWsp2axrCA=
X-Gm-Gg: ASbGnct4C6i9IToOkFozpahAO/Gg0VmeknLYYJlQFS3MIMk6khMTgV6qbhZ8kNYIKaw
	+NBuXJt4CdwIVti6knBHCjXbTTFWJDfUKsEJNz3NC+QedLV5CIoEW8iohLaGMn8aZ/sry1JGSm5
	7SeM7RkkX1WVDt3u1UGKpLsnz0U53yDv9bZq98efA7gK8le/Q0GIxxfx1u7CcsUOxc179Ac/Zku
	6OnXLTXixPjKVdRoQwTuPnmdBhkDqa3P6NRxJYrSDhq5bW7avIgeNeaK+9DktbnXJdcPBjipTQh
	0ZvYH0ue0f7krjjmweIQRk96QIPKwJEzNH2/vdTRqXeUPteZ0E68DKqN+ssQ/LEo+ruvGF7hBrj
	bXeVJl3PPPXipcGfrIIGr6jeeQKxGIbBU0f/BH1NMleZnjeqhrotMnXQHRCWL76h/OZsf/L3WrM
	upQnuhbNEN+YgZMvIKQLq05Td0TWZnNWUUW0oMw19Hcwmwpi4tsZNAqXJvOPPoimI=
X-Google-Smtp-Source: AGHT+IFdNH7VhxLObVgENX9rgje6FV1wZfYNMIau0c1KMkhVCs+KdfIoLVe9mOYpYpw3Znyy+63fKg==
X-Received: by 2002:a17:907:3e0b:b0:b74:f827:b886 with SMTP id a640c23a62f3a-b767170bfcfmr2591448766b.32.1764263429134;
        Thu, 27 Nov 2025 09:10:29 -0800 (PST)
Received: from [192.168.1.3] (p5b057472.dip0.t-ipconnect.de. [91.5.116.114])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b76f5a4b926sm211121066b.68.2025.11.27.09.10.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Nov 2025 09:10:28 -0800 (PST)
Message-ID: <2d55a9b3-0841-4992-a3fb-a889df34f5ce@googlemail.com>
Date: Thu, 27 Nov 2025 18:10:27 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 00/86] 6.6.118-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20251127144027.800761504@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20251127144027.800761504@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 27.11.2025 um 15:45 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.118 release.
> There are 86 patches in this series, all will be posted as a response
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
