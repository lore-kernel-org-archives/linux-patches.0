Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461C32AD32
	for <patches@lists.linux.dev>; Sat,  4 Oct 2025 23:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759620927; cv=none; b=TsbQD10nziiR2Bf38ptkwAZv8wdRTH6XZrr+9Lq2ENEbRpOkMtroYXmlsbpIN16xfbkucoYgHEtdxvXqSZfCUqf/G45IFT+ZuJt/69I4fWeQYmueltQ/a9+JKJFhiDWhziPqRKQd3MEPcG+sByxZ5gRcG337/aFeHkTluRz0iH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759620927; c=relaxed/simple;
	bh=I0RuDAZnK67fDIvuvo7+j5OVjOlB6bei3TOSvnVvfzc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n+29jA14YVVWvuPvP7v2eOqrUSBAGgp2aDLSUjhOPOWSAfEVbjtt+7clX/Sy5uN3SBaxxiGAqtgjU3sSh0CdcCrUgWDztqdz5LVhB8VXFU1WYz+HrIXCQ6akM4RPHhMkUTg4WvqHuCzulSq2wkEBmwBf4qhP7/nAKElsbHnVNzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=nfQyHZy4; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="nfQyHZy4"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-46e37d6c21eso24982425e9.0
        for <patches@lists.linux.dev>; Sat, 04 Oct 2025 16:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1759620925; x=1760225725; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DC/L4mdd1OngyUYeW9NdFnDzBjfqJNLL3d9hdta1f0E=;
        b=nfQyHZy4D1ZD8gtJUMgoxIfygBjF3sUKFi+UkOCactl1++igOWsIjjHc+2U5br5D1d
         IUWPN6888Bg7MVnotWsftYXnjUwXqcZ9TkuAJ56Bmuf28UdTWKF5pRbTeqkAmbOV6LRa
         mTDj96PkVZo24tvRPNBX7eaEdpj5wtJSMB3rJd1zFG9xT8wHJqsNFZ/PwLOAWnNFrppS
         d4eVXsc+nO4xk91CiBlbGaOYqYB7f3vNG2yXp0zi72vM9DypEqmG27h4YgvCIuu462p5
         GLummSLfm3AAtDhW+3S4hdZPdbdJCmiNaU1N+WOi2q/mfsCREtVEudBKG5pegyX2wMXe
         CbyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759620925; x=1760225725;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DC/L4mdd1OngyUYeW9NdFnDzBjfqJNLL3d9hdta1f0E=;
        b=tLqgg2TypCY8J8VjsOp+htzD4Oe2yZtfDONK3XNg78eDihU1/oiyJAkywn3OZx5k+1
         jm2JnJ8jm/u4c680Cbk9/oJPC7gp9RGtDVTBcqYxAMn/F4WjSdCHtcV9MSd/5U/kmH1J
         2VsnCcM06a68r9nXQFPU8GlQqAGCzkf5zlWwl8fV8dv/yUbrTsc8mJ2VeirO/u+MMrgZ
         JVAGMIum1B2EcdhgApoPiJW7b7pQaQFxUb87DbfVVZnVmsYkOkS4xTp8rEnszeRMuzOA
         1fcet+2btgnEHwAGUbKqphxdAESLLVEF8CeZedGAu9HKmWFZjBZXLEHn0G+KN4iVqGJF
         q0SA==
X-Gm-Message-State: AOJu0YypOnlE8nAfNgMzeWLq5BD5ceM7o6UIt2Lh2fsCOHJQtZ1E1zdC
	HgTZRSKvOAiQWicbTirw9/ewrpuWCfCBsZPThDvN7I2F+Y3kfmlJ8pw=
X-Gm-Gg: ASbGncuVT/8XqQBIUD2XqVn8BXSDI/kJFyGdp1CP7dJjejX9rZHMqofO8Mnkr/iykU4
	PpWX1Nvk0PTqdug1kIU50jHktBgEoQ5+elSjwH6ItpnHOaXBLdpriX1xvDN+fg9jYry2+VeuHz2
	CdH+08/SWBkSQwXP4rtGnyJLbuvMzYF/b57ciNO4MZnw7NZgpCyMLyafjE7LjgDom6eNTc6lgfJ
	treTwAvO1odMkg6VP6f1VDTyAYbIsUIhNx9I5qFckqQoHAY3b1YY3gluXEKCiWnWz8Mz2H2dvf6
	iYs40agWeIYCbJ4QdsBUWq6aP/bNkNiiNmTLA+0QSxTo/gh15Pl41s90bjIGP4MBFPlFJn/Jb5x
	SidBKRAj29O6+Hp847CwjN8JW6s2wbETa179FwLKHGmLh3FXQHNJq2SaJVIFD0aU+wnSXxSCKDr
	XUMoa15ibfbSmk44eTHsd5hzda+xHxKH/ZeQ==
X-Google-Smtp-Source: AGHT+IEO4DcW8huE1gnQomQOCKiIhr0rA1gJSe5KrVyDYKI02dHKwC1UD1xOFCCF7g3I/MKtVb+GRQ==
X-Received: by 2002:a05:600d:438b:b0:46e:74bb:6f6 with SMTP id 5b1f17b1804b1-46e74bb091bmr25477395e9.22.1759620924472;
        Sat, 04 Oct 2025 16:35:24 -0700 (PDT)
Received: from [192.168.1.3] (p5b2acd24.dip0.t-ipconnect.de. [91.42.205.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e61a029a0sm186407985e9.13.2025.10.04.16.35.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Oct 2025 16:35:24 -0700 (PDT)
Message-ID: <74e63350-4ec9-4396-9a00-4e257f987dd7@googlemail.com>
Date: Sun, 5 Oct 2025 01:35:23 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.17 00/15] 6.17.1-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251003160359.831046052@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20251003160359.831046052@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 03.10.2025 um 18:05 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.17.1 release.
> There are 15 patches in this series, all will be posted as a response
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
