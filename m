Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53BE37B018
	for <patches@lists.linux.dev>; Thu, 17 Sep 2026 22:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789685149; cv=none; b=P3d0u6hvychyF6vtAYXrg1S+iuAxeOXFjEWFd88ILBu8y0tp1NDgYoBR8wDofCc/6FuP39U7TYkL7DYGFSSC6rOt+5bHN6mtJezVPZcmlLESGLJ2M6drl9TMnK7wlkCowDkK5xlgTsNDEa2i33j/jq51jzcl2wQkICH+gzOGyP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789685149; c=relaxed/simple;
	bh=akcJ0MmLlenQNjkoQU/ZAksKJ827LifeS7rmDdrnKsw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UcUnZZaJrFxieC/v6ND6LyX2Yv2w7UBi6i2DxKEOesJsOPlKb5N95utYFFToY0jeUZs9cKZu8Akr8WPhdRYntrQAcytKyNNqnWTJc/qW31sI2xTsJCFbMGpVnehKU9puP/kVBugyWomgupEKmI3jgZBhARiTX5wtn34alUid+nE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=KR/Z4G5L; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="KR/Z4G5L"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ccfd61ecaso1154405e9.3
        for <patches@lists.linux.dev>; Thu, 17 Sep 2026 15:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1789685144; x=1790289944; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8vbbmySAgXmsI40pXiFD1Hh73sth3K7z+LhNCUvEReA=;
        b=KR/Z4G5LnyZxEkbOp7acG9di3Uis/WxQxiIAfRTkM/YZXIyGUzTQkhpS+J9vfHugLL
         c5arG+OEMmFTJtTlpdtf8nbpKLHZjJLcNVNhoDgVscKmjSJdLxlU1mRbUWl4Ri4FjBfQ
         Rg1A1n5qJmjnsQOXm7cjFSAFZaJKWWKCUJ0ypB9Ztw92y+4YRoLR5jT9/uEjO6c0c5FX
         CpWUCl9DbnUivKVpUKXo0UJ26n4u935XBP100SHvbNC9Y4PCgR7DzNBlF47ioK86j4ks
         LFb62njdkyX9BYdP5eFsPWIsz8dPyGBgR2yJqX7qHLNGLPupRr3ewetiT3BrTbxJqh8O
         XcnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789685144; x=1790289944;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8vbbmySAgXmsI40pXiFD1Hh73sth3K7z+LhNCUvEReA=;
        b=VaTSCpks4YkAJkVxeT1xg6hr+raACR3DC4aHkwtMu0lTqm9IQZGk6j2ZGKyAyuEdBK
         nTklQ4jQ75PguUjCCCzwHO6JAgw1KOpoFI5mGVmOiy4OyfDDa8js+spPPmxRTdNTDk0w
         8pcUQE7iPtYDFgrks9TkV5Oyi5O5V3C8dYWL7KnQbX7W6I38KQLMWa4BvspW+j/a6hVV
         5HhlHHZyHOJhBcnWyVGr8/5mIcPmZ/0rdGiOhL4nna+ocl1P1+VKvK4Dl8/St3Rm2YuL
         xIPpFtSstq8PzN8Gx+ZKsspxKEDv5pWMWTftH8Pu7LBaL+KKunJKKb6j87RREkLeRssG
         VwMA==
X-Gm-Message-State: AFuF++kuS7/tVCNkXGKEA12VMCY861IBPuc+fbJQdHUrAmzdjXx7k19d
	PjUo5yWG/N8eAkdBgPiG1wHKDX24dCTIyPqFYveHYCL8BhmViyLSzaQ=
X-Gm-Gg: AYBFou2oH9Nz4yPMC9pLLLrYhyR0SHogCjIj2FDjecadA/bJ6LR9zuqu35VxbpZWP7j
	dW6nE4rSQFZQi7iNsUfEOLJSS3Y413IF15lcCkqzF4+dO7Ycm33Ktr8YGSgc2ccSXNRLXBp51MR
	SRHr40u0jgQmprRc/k5tOFnNcj4rmuAaatngpvEdNJW6jcaASs6ZIUA2szpsVlADdT/nhiMEfxh
	82vTnVjMPjTGj3Ry/Be720iw44e3R0/FLQF4/wPBK1u6D1N9yZb+6zc27SQjsd4MUvFRX1plOHP
	CHU2WoH7KSuPLnZxKrXh1tVHqGHh4akLjvw/M+2HLV3wTs9+41E+CMebW64iIPeRf6aSm0Wj/uc
	pQlXhJD0F3a2sq0R7rEUFYWm76Z/T4I8VkAL2726kkc8MVpLwyqlhdKuF3QjWThlKS6WcaJrK/j
	kqyPkcwDWbx4NagYgDXthkS0Zvwhczq/jP39mC1UywDF1/RyPmIl4MaN+BEbGEedANxMdd8Lyi0
	jsCPMxGznaC5iMdPFiRHmuFJknpkSVJvnpk81sSzfCSkSc=
X-Received: by 2002:a05:600c:34c3:b0:49c:fa21:e74a with SMTP id 5b1f17b1804b1-49fc5757f73mr4006775e9.32.1789685143622;
        Thu, 17 Sep 2026 15:45:43 -0700 (PDT)
Received: from [192.168.1.3] (p5b057001.dip0.t-ipconnect.de. [91.5.112.1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fc5755c40sm8484455e9.3.2026.09.17.15.45.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2026 15:45:42 -0700 (PDT)
Message-ID: <047bf331-375b-4dea-b847-e5102f377411@googlemail.com>
Date: Fri, 18 Sep 2026 00:45:42 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 7.2 000/733] 7.2.7-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260917151350.597953846@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 17.09.2026 um 17:05 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 7.2.7 release.
> There are 733 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697v2 server. No dmesg oddities or regressions found.

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
