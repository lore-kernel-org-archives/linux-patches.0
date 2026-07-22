Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C43940BCA4
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 04:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784695349; cv=none; b=XjflW+VbRrDIVVMhVX1avx0ppG70PoUsfTSamaThb8M1szCIYf5mtczA1bMZn3FGRYIlTm8EYVFlpwy2L8q/+G9MpFTvW4u7hx1bAMF0HIlVPmImUG8d1Bp2mCnSwUPzcCn34S4eAea1QUH8OSmKj2puNiQZUzJ2gU38BXkfXuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784695349; c=relaxed/simple;
	bh=UDwEITqIh//cs/uc6EAZsKevx3PgNN5PHdWvOK5FIXc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s9xtLrWVrsE7J1hAxx09A7w4u71YfxxjNITCUSrgtZiPqbXAQDhtjZ5qyvQ4yBPUR/pXvSy8pA4dF8WtO4HHhAW0WJVUWHDD7eyHEC+mEii+MJuzgsDHIpb6to+4SyQnlkEgo/JudhJKxvTprFd5EqTnlLK8du8ijGOyMrEgaNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=Jm2elim5; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="Jm2elim5"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4954df200ddso28644245e9.0
        for <patches@lists.linux.dev>; Tue, 21 Jul 2026 21:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1784695346; x=1785300146; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=HtEJofhzLlm02HKE+RTIuX6GzjO7GsDV1sElIk6QVJo=;
        b=Jm2elim5hENcKgzeazG6v01QAvvQu2Mtjecj6maaIlejJszRyFSbA7BCNbSA4Kjyij
         4MI1cVpVUcapbVplfdkGI6d+vu+aGFJbC3lk78/C/3GB9GcafGaTQRZOkt5grjyRhGl6
         XdxLkF1hmGIRO/rX1HKTobRo+k43/pgdBMKMpm2a3S3ywNShLdcohw5/Bd4vNUC9tEvw
         aIlGIFyreIfvBtAQzrqxEeYAxeWlx0LJt4vMStmPp3K2CH+K0H+OVPGcSNNQ/ENgHCK2
         gKYUCUEeMIRaYEOB837HteCZE1Gw+tfXygDSSGrklpwQN8M4gb5/0oVcYzRqvFMTcifv
         rDOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784695346; x=1785300146;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HtEJofhzLlm02HKE+RTIuX6GzjO7GsDV1sElIk6QVJo=;
        b=BIugE9B822s6EQnluOsQOnxZAkpbgBwMowddHlM7V0iTG8bNUeF+95ZAAT0nBWRWLQ
         BM3lKNmPsNqCf7+IfS5lxxftaMa6HJ5HJZB/ZCqrjofwt8b+hZB09d2dtl8DKynJnIC9
         YnqVUsmqAEQRx7Qa5Hwbq6eRhEiVBJeabcfBIkD0MSGN26BZWZYA1zbF+vK8lyAK1m5i
         T6mAIydMLCyfgCu+/mN7lSfKJFw2scoeL1C1Z7hC2HhPevNLTW5eKmHA02mU2DNrhmoz
         l5+v4CSBWaHf0TM4hDSYk/LvVOxRn4lb7dkkyuk880roiMoVwfhG7mFboynP9HAqzDc9
         zp7w==
X-Gm-Message-State: AOJu0YzVLPNn0eFQMRo73pyeDYnCx6fD0rfe8fA30/0b0xgNKkLL2SuC
	VnMQowqyWzmgDVDXiD8DBK7L+JBwSBmUIxXyng2klSLyMK3A6WDjO3c=
X-Gm-Gg: AR+sD10LU9CcNz0v6BFK2DIymt4wN9hjPMkAdGyNogHDZr/SPfq41JyjecySHulS+PG
	gPnvNwy6VOSCGEpEUPOtWOVdwXhPNjTXOX9hyoUIhIOihA/MgFCiice/O7+eYKGxaRkLEadjsOq
	yizgg94FERPkpkR603qOpK8qoEA3j39wcCAqne8ROtEgvbDkXa9r76SrZm5hBhFJ1eawZrkfTqV
	RbFD5Hcx3yATKasFs1ustgRrHFhlo7WFGbsbFAia/GKFD2bd7KsuwodEVs2+z1siLn5vP1ksfCR
	hwuMPl0SEBGPx6YJSt1n1P1L20Hn7iVbydOUSpka2o5OzAsuBpJDJfTvYvvOtMsG0Z/Ui6j0AHc
	ZlCVMAgQ34LNjqxpHSYeC19H1RWgtvqHEeAfG1v4QshIz9cMykZr6JcAVffnD3pNwc2wsZwE2Gw
	3Z09bF4SEnsfiAyCq9bzjvkLc72Be9i8kxWv6JxLBJ2/P0MqpEsE+GbRqf0CKyEcXi
X-Received: by 2002:a05:6000:402c:b0:47f:7759:89df with SMTP id ffacd0b85a97d-47f77598aeamr14551185f8f.3.1784695346324;
        Tue, 21 Jul 2026 21:42:26 -0700 (PDT)
Received: from [192.168.1.3] (p5b0575c3.dip0.t-ipconnect.de. [91.5.117.195])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85bb5127sm2524047f8f.10.2026.07.21.21.42.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jul 2026 21:42:26 -0700 (PDT)
Message-ID: <74b89e01-4a1f-4c0d-9d52-ebda6e980548@googlemail.com>
Date: Wed, 22 Jul 2026 06:42:25 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 7.1 0000/2077] 7.1.5-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260721152552.646164743@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 21.07.2026 um 16:54 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 7.1.5 release.
> There are 2077 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Wow, 2077 patches? That must have been the biggest stable RC patchset I have ever seen... Yet I found no problems 
testing it on my machine:

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
