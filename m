Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9367C2641EE
	for <patches@lists.linux.dev>; Fri, 29 May 2026 12:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780058488; cv=none; b=XaI4nSPCWw20X76G9ikVg25erHQ8RIKTXXymqkFdqA0BuPdHMP68z+NuCY0lidFkkFJKMHoG7sQNNfWliAEZlqdYj/ZghS8rzyH2hTmCKz/Fw9NErq1udumDyQC5fnC7VmNMLEEkG4fP9GTt9H5TufwoGw+n2JlEIEy4fNs1+kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780058488; c=relaxed/simple;
	bh=YiDK6n2b1QGMLZO4K1qXgkhW0GAIX7vsmRnLupBxlRQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L0i8ceTPJ23LUbIcpqJWCwVU519g0rGDQTXIZtx8P8K2L9lDRDyn2yrlD+s05WL97imL1bQf/7F5Qc+Lmzf5e22lINtYOLDEy0Kr1S5fnS68C/xFicR18GhZ8ke+UmQ4EWEg+lKC8WvDJM0HMk1nOYNtcUcNs7D4YyRiU7PevXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=Y9CH54TO; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="Y9CH54TO"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4903d5c67bfso45336565e9.1
        for <patches@lists.linux.dev>; Fri, 29 May 2026 05:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1780058485; x=1780663285; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QJtaZBNX7TDfrNfEwglPi8SAZdfZecurqD9zImFlbIQ=;
        b=Y9CH54TO5XAoID4Peu1rQoqwUxxE1YjiOz+BeXvWPkjYcWl/gAqhPl0aTElg9w6ekR
         bqaI5kZ5TNvGviXmMq4JAF7KtKeC1ZajKasnyFQW9zaxG0URBiRoCmryz3QTr/bfxo+W
         dcdqTc54JPnRDn+brzxsETP+a0zx0XCGrj7n+VP/COhQrLmC5LujNgnRjeOOP4m+8HFe
         pYfuTYqE0LwYVZt1PSxxbtfXzaJfNah1EtYn+AgdBu8Myi0W19JLJnvuk/p40mjF9OrV
         L6EQYiXvgcFYDMyi6q7TB4ZqhB4ch9pKV7mhxDGS+DQiz/pjpoFjtx4o/RHkvHVD2/Zp
         JoRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780058485; x=1780663285;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QJtaZBNX7TDfrNfEwglPi8SAZdfZecurqD9zImFlbIQ=;
        b=ZJ3csJDHMdZIHm5hsjNV2NO7/rh/MXTqgRJvx9dkXJ9dOiSaFHeSbkTYOEFv+P1sSc
         wShnBYCQUNGEzIjCsOpFhkyYK7N6eCmKMMsOtcYVkTp8/ihOXKnlftuJWYc49PUSlCe4
         NO+/xPsQeSMFaWqxaYqY89DjkGfWhkP+2y+07P6x3fjwM6n494gpSUFKfEZHLRUnkcht
         1giD4EfD7dthwRl7wMHMPNmiBUWTYrOiZFAGewu7uEpovRgpy7Ci/W1aCKpzyIITIUgA
         SRnbtUUFRU/w4KXdWaKYk6Uyf7/WygAl3RzqSTIkH66Mvsb0yWZTYDhYdc6LdYCNWv75
         fXJg==
X-Gm-Message-State: AOJu0YzrLpmQl9/UAphGQ311Go47V9zs4UNxOVP5FIAWbX2317ewxpjG
	z5/OVmmt9Ulo+98wlVwSKBV/3fp8rM2xXhMYigJeLItHeA7vZTHKGmA=
X-Gm-Gg: Acq92OGwbni1TKha0Z/1waU7XuMjXv4d4Mx0bKRi+D8FXYq3mtC2ilNJD6g1PcvePmg
	KOWoKtx5deCvjn7A7Hrjx/v07VFfVT/A8W63YL3p/+yN7UPTxCjD3flJVUVKNBge5ibZDzsa6/2
	Vta3tgbdL28Oq3WdPyoKy5XWZBTB0hwZLdvfGnyNiysKsZdqL8jnk9vbWeeOsB+r6YX2bLd2Z+k
	bmVu2UkNDbCMhjbwOe6Kt4txMkDp4GKcPzs8YaE2aS6simhKoh0NBeuM7VUYSHms9MEVnwjKhIY
	46pD9L9IOQFBfiJRNsv+UekCfpfHlgLluvv8jEfk3arBoRivpZqnRn92aqb0ksXoi6XF4/rD7nh
	RpI3Ojezq5wbfkFK09UJ6Qdxgg3ERYN0op+OPIki+EGcGS3rttfeIb9PUkHBkjAtGnskejQ9yr/
	jdX74hcY0N1RJMJ8In7QeBzOoTF+vUcbsJyIQEvnGaLtKP1N3z3/A6qp/WL2oF53UFuDYqxTjR4
	WdWC93WnVaOtg==
X-Received: by 2002:a05:600c:a40c:b0:48a:6fd4:d3d3 with SMTP id 5b1f17b1804b1-4909c0ba8bdmr29887095e9.20.1780058484793;
        Fri, 29 May 2026 05:41:24 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4ac5.dip0.t-ipconnect.de. [91.43.74.197])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ef3559645sm3319328f8f.26.2026.05.29.05.41.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2026 05:41:24 -0700 (PDT)
Message-ID: <cf7c08ee-ee23-4ddf-af38-f51c1e3196fc@googlemail.com>
Date: Fri, 29 May 2026 14:41:23 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 7.0 000/461] 7.0.11-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260528194646.819809818@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 28.05.2026 um 21:42 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 7.0.11 release.
> There are 461 patches in this series, all will be posted as a response
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
