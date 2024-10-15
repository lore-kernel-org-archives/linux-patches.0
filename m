Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E3A16F907
	for <patches@lists.linux.dev>; Tue, 15 Oct 2024 05:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728969199; cv=none; b=Jx17z9h5cyZB+VjBsp30onplsQDvIXRd8hjMgPTtIoDqLGCVBVoPYkfxnKLQvMFgtMS8aqNqbozduvu+bBnQjvkV1h5/rUzG6Obb4bSaVUVcGpWlut1OVEyxjS/0M362BSVHyZBHxAX68JwHZnwU6gEiGHtSuSG7XGAc9WqT1Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728969199; c=relaxed/simple;
	bh=3uI3OWuZrMmEXJ8l28iAIG1EYkp1PvXzt0XnXFDbBLE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F0OVRUnTi+GE/5v42Z6IuuNhgl3oNtWbBWJyc/xtUDqGwA/dPNLcDsWWMVv0G+C/pvVdKFEUzppBpiaD/x+6qIHEcmRt7nQ9jnw+H5mByb6gCQoagWb8GWRIns6ms/oCdVUcl1KsElMrYRmMd73erkywwgsIuvsZemklNgo4b28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=auCaN/XN; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="auCaN/XN"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-430558cddbeso33201705e9.1
        for <patches@lists.linux.dev>; Mon, 14 Oct 2024 22:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1728969196; x=1729573996; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PHik4U7KOw/4dIRDWl5VwjxD5vspBFtD0hwaXOoLj+8=;
        b=auCaN/XNZVmMuskvhWkcGyiHKi7seGht3jP31giGh2+jUrskwzf+Chi0glTEejpV7G
         Ixu3rXsmNC43SBscCqvbm5ZxaFdARWFErUbdxeot8i0fWxUUcvNrN5LQWoLMFbe3EYBo
         RYmtqFag+N+v+vXzv/Cfrd1QFtyKCnJgpqukBcWfO7v5fKod/Z1EQ0Kg7oLAhX35MhVC
         iMVKGKuPOatpBfsQGT+DAPxECVQIqWdVfOl2K/Lu83nDMJIgwvdNnLauAScpTXNpLk1p
         1U+xTyzYnmi5SEyM2BIMJgAzHAdslfl2djMrVIHP6xm7uPH9RLjCjhS972mR9UfLd0Mu
         T8GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728969196; x=1729573996;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PHik4U7KOw/4dIRDWl5VwjxD5vspBFtD0hwaXOoLj+8=;
        b=q04PCK+gvBc8ZA9NDgL9+m/q78UADatcDU9F1dw6wtJY3DoT89FdHoR+T3tOJocc0p
         CVIRS0liFLpamEK5uVmdXQc9XVOtKMYe1QywjbL9oz63fUE/4ZBNyU1OSQBi4BH6GK/Y
         EpKO430l7bdu+0PqJ5OYlTWEEo42eu1RYipn/xWcMGyY3iQYCLO+kogiOCODyizOSs0E
         YzO1JiENbH8uTqrmVpvigptNQhBOjFB7DGaURVk4JxgZpWt0PWxlr0SENMo+igfHcT/Z
         H5WgCS3mCMMv+xwZpp35O4TV+GI9lGJkf86luemJOkrWoYWt/aFUKruggAO6Sh10WyAf
         UJhw==
X-Gm-Message-State: AOJu0YwKV1BjMhzFwZeqjn4JN2diJ5plIpZ7CWxrmGV0KNJ1t0/w3zsH
	f8LaNubbcF03kcrRGT0/bgxELYISoXjFjaOyfU6d2nV1118cfAU=
X-Google-Smtp-Source: AGHT+IFYKWFkTetC2jsHx2cuWQS1f4EkFAT2Xy1LYi9zn5BWKEWr8Mg8OO1edr31ys6yhXGXTilGkQ==
X-Received: by 2002:a05:600c:4e8e:b0:430:4db2:2b88 with SMTP id 5b1f17b1804b1-4311d891c4cmr103556005e9.5.1728969195718;
        Mon, 14 Oct 2024 22:13:15 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4546.dip0.t-ipconnect.de. [91.43.69.70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4313f55deeesm6519045e9.8.2024.10.14.22.13.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Oct 2024 22:13:15 -0700 (PDT)
Message-ID: <09191ba7-304d-4e2d-b5ae-8ef0818e7675@googlemail.com>
Date: Tue, 15 Oct 2024 07:13:13 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.11 000/214] 6.11.4-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20241014141044.974962104@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 14.10.2024 um 16:17 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.11.4 release.
> There are 214 patches in this series, all will be posted as a response
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
