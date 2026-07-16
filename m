Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A550C3911C5
	for <patches@lists.linux.dev>; Thu, 16 Jul 2026 20:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784235414; cv=none; b=qk3mb0bpEGkP5mdAe0TjK0JGUWKYSIQloEO1akwCdLUIPiNSDSW1jiGnL9C9Ya/NfrziTlHsMigLMHgxaGxpfxOp9Pd46BO2NZ+jEVL2LTSxotS9bDhLKC/z9qltsZR6zUd5McdVsnbnglXQHAuA0Qp8YLHHIjJ0mfmIW3sri5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784235414; c=relaxed/simple;
	bh=OzPUmT5iaZU1b+BnKa0fn5eBg8gtXay07Y7zCPI/gnU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IHE76MCjPCw/qBoZhT8OmwldXRuq4TXendP/a3iUG40TmtcHvENycbQkw6dpXfwQFYThpfAunfo5pINkdECp/TRIYTzCD5Swv/ZOiO1cr9bblr/XwhUkL/lM4HqQxs0xLTYsKxrsnLsSl09rLxS2hfv8aSKWt5gp8RuF4+Tc5Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=kj2biaJa; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="kj2biaJa"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-493f4638f4aso31821425e9.3
        for <patches@lists.linux.dev>; Thu, 16 Jul 2026 13:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1784235411; x=1784840211; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=MDJbJlewyjq6vxesHaZ1UyIxdgRbYxt4PQHjBK/r5VY=;
        b=kj2biaJakGM6EGUaxKDFukevxOImVfLr2Kg0+E6vY79GL6a2FEMH8txGFNBYfBT365
         pd0t/73uDX8Gb/OT5fEJNJleu48hBf8IJjacamxGSRMsjzpEGeyABjXEcV8yNGFcTFEM
         v/ceMy+lwTIRN/GcOaRDsTHYQ2SCtsLFID6yi/ggQDi+29t5gjUQNeJbZinOybIzPow8
         wTbIgMSuff4RwyvGmlGhaSRKUXg0pr6AQ6mqF1gArolvXtbxiDcaBqmfcZE475trCeia
         EzvQl/w4/zqGnqYcRw/Gsx+lHZLK/eGnumugURV2f7Wgm/TL3qipJD0n1RUqlRYc5bOo
         eL6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784235411; x=1784840211;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MDJbJlewyjq6vxesHaZ1UyIxdgRbYxt4PQHjBK/r5VY=;
        b=RRAsCZTKvb5Qc4kiKXr++PLm0ECMvO/u8aDqkZ7YLkL8bslVCvrit4grJUnBTy0p1O
         HAuJRBrfovaTaxiCPrDIbhIeyDfzloKeRPrmHbFM1oO68MPpCG0+c9NXc3qOqc0b+EA/
         2Prj7T9wVkN/E4pAbwlrpyrIVVSwR9ZvS7c3q/12SifWbUSWRb4/UGm0yTQE9+iE/LZv
         1P2W/iZNl++uDDPhuMahLcxKs1UmzbkWYE+7hJisAJDtVBPeExJ4SYYz7uH8MQBOg7Bq
         CREFmehobpVCdbA29YAvLaqk+4ZQCsDHp3fvEMyqLidTi4e9WJ6LRuIEWtJqkiQW867n
         uEFw==
X-Gm-Message-State: AOJu0YzzOCLYP+r6EixV6n8aDM3mRdUkMliVIPjEF7fn1ym7fHBlOa2B
	DiVUN8AYP14a5o4+4pPJpiD0TgtH9pYcXgx/KLozoey8ftCdJ8Ws/7w=
X-Gm-Gg: AfdE7ckNJgtikrRK1ZBQP6lALPVSVl1PQmnT0jySxdzzKKUoEFQYHOE0Fi6rEAx8WYf
	nznaT9iqJyYWLt/s9gOasP7CO+QRZfGxK3u37FJsfA/NycBEjVPl8fQ5fDUGZR3vxj7qeUn425P
	Z+zAEhLxqPEc4P8dwVjsozHqtPc04GX5ASIrph+17Osmu4y4e4KeK71vM21qPbb2ET61Nx5qEyX
	5cDvrXzg+KQC5JeTKzVGgHyblsM6kaWPFNkw1zSI+d8b1hBXpleVxRZO2X+JzOa2v2XKV/qVMir
	bh02Ks4iCBadei7cjd86VOhp3aYZDlbMo6wk/WxMsPRagunLYTG7LsfItwsLffbNDZiYlcNIWkL
	Y+SkNnuuoKmMjBqrBY5OqYvYKV1ARlcsLnvymLnilrTyQ5PBktwlRmGJ9Tk6i9ws4iswlOYECRv
	hoOot94wd0ZDl5Ugma+p2W6N4NSv5Cr9zJ3h138TGPQxWY/5meM87COQ==
X-Received: by 2002:a05:600c:350f:b0:493:f7bc:26e4 with SMTP id 5b1f17b1804b1-495483bff09mr9132235e9.31.1784235410739;
        Thu, 16 Jul 2026 13:56:50 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b44d3.dip0.t-ipconnect.de. [91.43.68.211])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f464caeffsm25298782f8f.36.2026.07.16.13.56.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2026 13:56:50 -0700 (PDT)
Message-ID: <dab0da1e-1e33-4414-932a-0c99c0a58318@googlemail.com>
Date: Thu, 16 Jul 2026 22:56:49 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 7.1 000/518] 7.1.4-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260716133047.772246337@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 16.07.2026 um 15:24 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 7.1.4 release.
> There are 518 patches in this series, all will be posted as a response
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
