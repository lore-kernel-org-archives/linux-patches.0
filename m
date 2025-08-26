Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5182E2DCB
	for <patches@lists.linux.dev>; Tue, 26 Aug 2025 17:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756229924; cv=none; b=mYVlKRRashI33JwUyLuGP7Wtk6R8DaRcU5JmT87uPqlFOs1skhNtaGqMuKcSrsd1gb3BxBLl6WqZWJRF4GUCX0B3msUyY/ypr43+gRAyQq6nxdI3UmG4Vu1s6oCI7BZHhOJmM6qhVPR+bdUZBqB3iEvzqmJb6wVzjGovz9duz8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756229924; c=relaxed/simple;
	bh=ZY0Nqgb9CgNDa2G+URK3Z5pq819+PKjL8HdDDaJHs1Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BQJMbybIF8ZZ5Jma2nsHqqB7PQ5RGiXBpBlbDoD/7q7JG/fQd86dOvqjpuZm5ucnxEFslg3ZlJP1XPd8+JSQ/hSEQFQAjb/fkN/OEXN5lhBY8yKVFNjXbAqr6SliZKfVSUnBBJF6EhigewR99NMZKTBXni2X01XoEW56OTDlhoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=U9rH9pPj; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="U9rH9pPj"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-45b4a25ccceso35315245e9.3
        for <patches@lists.linux.dev>; Tue, 26 Aug 2025 10:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1756229921; x=1756834721; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V/DeFB5e3JjBkmKYycUrxoBdm7wpBiHToE6tdlPi1jI=;
        b=U9rH9pPjUIeHMxHtKBFd30LBSzpv+4BeOlk5XZgzY8cSn45jGcIb+vJhBUnQHnDWLO
         qbRa+8x3qYo6+a8W3VWBAp/4G6+w7XAidSi3O3jvr5tPaCGsSlf+SsXiq0mMkSuH8+xB
         zdGWIbdu/toCc8oHA06CXN4tsLs1yDD8YQJ42lMa09SSa4EuMC407j6hyBMGbiP5xT0u
         jCVBmiHKHcWUSZD9pjsMee2z7viJyjw1HtIG3+KddpUK6PYn5hLCJVeozfKDIqZRwOwk
         c1CJbjQ8MRT0mlFdOked6Aq5+QnnpmUy0BzLRq5h9iiQrX56tx8lzLgb2z56A9p0jSlO
         Zx8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756229921; x=1756834721;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V/DeFB5e3JjBkmKYycUrxoBdm7wpBiHToE6tdlPi1jI=;
        b=pCcipSGKMXy9aEO9I/iXDocaiKtNMWEe0hTY+7sWT2kBqloWJH4qz2ht3qPEfRAgLM
         iUTsbvYJyf0COzzPLYdl4N9Sw78vVZeXJrownu32Juqo1wX0M94fIRIqTkfhyfSGBYko
         9XkajPKocDadgmAM0j0HV1JG9qt82cm+WOz9yfmlmw7g+SuiggCDl89DMw9SvHEGph0u
         uO818k4GENVmkp87OlidYgrXpa/nQIDGkVCSec1hero1/XR7mu/Wz1w82+NMvtxqiJTw
         Q79AqOvIa6Dh6m+d+iQFlBUo0OaOisAtozfeEQ7rIhFYDNz7TbZtf49mWr0/O2XDuGJX
         myyw==
X-Gm-Message-State: AOJu0YwVdQ/uYO+hV7ukorS8a7H1kI8PYnwLXDEi0gc0ZMmeXqiZ1qXl
	E9nDlSrM0zyr7a95MXzfEH6fxFektEDgsEvMQRpinOw9mQsUGUepzOc=
X-Gm-Gg: ASbGncs42MTYv4SXjPoTDYwuJOeLhHiviwG3oVMtw933Sf5xGQr5fZ6bpkAKmx+/JqQ
	SqOThidXQ3NtbstR5+lGHmPuELInc8H0+wL9x9aTqb9BOcAiTa8JHk+R2t4Kdw5VOcOn+MkJAoZ
	YGg5kmgJE/K3GxU9/hpke5fxDjyCtdwURhVvaiYp194tqI7VNK4dfDnQlCnhwf0maLw6fKiCeBZ
	pv2AxJLUSwdXCw3zP8JnRXArptqqQooVyUTQMKziUqFrE2/G62msXfX8q02aYx5aWnzboc/kPIO
	vPyb2knBaZqNfiLLigp8eip5Lei0NJjGKtULcozH9poayFhhFBkidW73WEOkDgrwrE3Du1jTt9N
	3Yfme9CKIEdCl/7gqUgp9b3FXdIrCJW8MxBNgpgtQys65b11A+bO1QuOIQIJpCZI3NaTAENBnHI
	kMowqPF/pO
X-Google-Smtp-Source: AGHT+IFfc4DiAti/XlzwdzNIKfX0igYZ5i8ahHaJD5NZfy57ZdwW0mO8SjsPI+6IxgJWq6LB+rnunA==
X-Received: by 2002:a05:600c:1c1a:b0:456:285b:db24 with SMTP id 5b1f17b1804b1-45b517d9008mr131562355e9.28.1756229921192;
        Tue, 26 Aug 2025 10:38:41 -0700 (PDT)
Received: from [192.168.1.3] (p5b057219.dip0.t-ipconnect.de. [91.5.114.25])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6c5b2eb8sm1402545e9.4.2025.08.26.10.38.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 10:38:40 -0700 (PDT)
Message-ID: <0afb7c90-856a-408b-b3ed-deb85a58effb@googlemail.com>
Date: Tue, 26 Aug 2025 19:38:39 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/482] 6.1.149-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20250826110930.769259449@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 26.08.2025 um 13:04 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.149 release.
> There are 482 patches in this series, all will be posted as a response
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
