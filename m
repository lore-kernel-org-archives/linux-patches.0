Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A54C13ED13B
	for <patches@lists.linux.dev>; Thu, 17 Sep 2026 22:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789683168; cv=none; b=buN8kUb/psxWujUZvhzTWiCXVjAW9vmRHyt+LtqHuKCAt5oJ/gbavdrxBQMvXUZvBJKZ+mVh/MBY/J0PaVgWc40j5KEpvXKDBQxrt/OEtLBOovP43lc6wllsR3FUDUaS3gr6CPwtWVSKp0y+IAeMaJwkj7Q0T+ibtZLDLLgenXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789683168; c=relaxed/simple;
	bh=V6nnwvB9sh6koSriz+lfylny5m+Sh6r2d5ywRRJaQwA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mPls0cWwT1BbyTN9mnXsQp1VTrdjydKzRxnbz/f+2TZFIkElimK7/ZkyeiX33xnColPDn3fc7XBO84NqQvq2IAsIeM5lpYgQ1VgtSNflvsmQqvDXg2A3VMhT9i1pW9lOiAG9yrrXxlYfRgYCp/znbGx3dMnwFx1x4/VQCrXjt1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=VTPeilr7; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="VTPeilr7"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-4843e397f74so34658f8f.1
        for <patches@lists.linux.dev>; Thu, 17 Sep 2026 15:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1789683165; x=1790287965; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=04M0oD7PJnXKwygY7xXBRwcz1/IqxGd86V4FW9s/qsg=;
        b=VTPeilr7YGre3V7U9ejYHFcrxE/HadQk+61mrRWyAupjaJsS4mJM+nN69casJMUtFX
         zjxnKlxwLfRfdXiDyIs1rqPy2wY9H5yi9ty7VTfIvRSc4v5hHUYHhKH9jbeQ2Mepqga3
         /rSoE/8hmKaP8Be2peZIO3B54a4fRc+EVLEeXVtqYy8EEam6gcad3fNRh2jDxm0pwx60
         2SYyili0GezgouBh3N7ln6WMPDm44rSQosv6/DBFKjjwkFiMHIxUePWzBJoDS3Qxw8vl
         0XVdLvPgkpHnC/mOE2fHnSiBSk8GK6hINmPnIipfpp/u4J9ITWq/lJYW2vyV3Un59qSo
         iKLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789683165; x=1790287965;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=04M0oD7PJnXKwygY7xXBRwcz1/IqxGd86V4FW9s/qsg=;
        b=C56Zewd4Kj6LN3GBF0/5YCRF/mwonSigI6jH/k79z1XBCqt3ftOEXbuTOyARWTEgti
         48SZdtWGMDiL4ujf4DxtB5V2jqzrxT1Fv24KOJZWqXrFoDcKRIXVNmsqF5ZTfJdbtqWM
         gZP3TOKp16ErdktsLAPER9mZUX651dh5NA5hQh9hB/+2wxQP/l/tT2JC4ZApqb9xhTHi
         XfIU01Fwm6FlH7NZytYE5SDgFvhc9FHlHFg396OQX6CSXWQTs68Ww/Ymk/i+SoCUN1u0
         Vuqd5TBCvsM9Axm9DZbHK3z5eJPmWGaF7rYmOobtW0m9BGA3Mo6tEd+gqgu6AArwZHH+
         3HMA==
X-Gm-Message-State: AFuF++nejbQBMRn9xRXkiSLaKXfCRIv4QfFhhaTPyiO4zQQkqNNcQCUs
	BtvXwgPau935yvuZqQrZJSNz/sNay2+LAiaIiYsG7ovnZi+uDK2QEfU=
X-Gm-Gg: AYBFou2buSljFNjmiYwswvxFRbPX2y5yk11wyXUIWROg8el1RGfHxD1/l6R7HyEzR84
	eei9xOyZtsmNLNgMT/0G1AfmKtdwwfT4J7zzzObTwddEajXWKe2MrcF8wcWsmICROxOu+zFwPG0
	R1DRaIkiTIzeK1HCFWVOX9O13Uz7lSgj5G9Z17hY9rPD0DqYfjjE5kQvmo1JoS45zQJuhByJilM
	XxjfHX3VZWiDYTtISoHdV5wwjAi/lxCzSEfoW7zG0WPWx8eOQCQZ5be938zWyr+/whqlC1qWwdn
	8XHTotZEiEM1lOhPk5K/ZTpNca0zwO1a8MafS8kuvEsFhInogs2LOBhr24S+jy3qwIiCmC20Dhw
	HAKD+tAnV8qdHOadMKVU917lfmqfI+O7HTuojRx8qTM3Vm0Rvkg2/y6UDMa4B4v7/EXHkEkqSNT
	1sXZPnHUfXPuoNk5Zr7gqOGT6trS/BEdcriELv/DPmXaP5gOlUIMIEtBQdIjHTzNtJI2yvs8bVQ
	EeZfDRfE5eowgSEMPbTfgZrRuRbofErvo8IPeNNADvcFwDirRwpViJVgQ==
X-Received: by 2002:a05:6000:643:b0:487:955:e6c3 with SMTP id ffacd0b85a97d-48713a887ccmr7483885f8f.0.1789683164645;
        Thu, 17 Sep 2026 15:12:44 -0700 (PDT)
Received: from [192.168.1.3] (p5b057001.dip0.t-ipconnect.de. [91.5.112.1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4870bf1fad3sm17073721f8f.12.2026.09.17.15.12.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2026 15:12:44 -0700 (PDT)
Message-ID: <35368918-5b16-4b29-937b-e652a86b0393@googlemail.com>
Date: Fri, 18 Sep 2026 00:12:44 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 0000/1250] 6.18.53-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260917151551.901433442@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 17.09.2026 um 16:56 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.53 release.
> There are 1250 patches in this series, all will be posted as a response
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
