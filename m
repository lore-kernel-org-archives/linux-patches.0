Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577CA4A13A7
	for <patches@lists.linux.dev>; Wed, 17 Jun 2026 16:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781713821; cv=none; b=eGnQzvkFEG/VCYUQLphzb0xaWVf628/vueTOeHMbADZnu0hAiaDjtGUOjVCLvQtUwJEBkqI8L9glKjaAvH/ZZdAc1H1DP+ATH7eUYQC3VaM4onZnTd5y0a+cqbEkWpN5EMEnv78vq1AMTplyx1zx3j/Pf4LTfjL259f3rQPW7ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781713821; c=relaxed/simple;
	bh=hsewUNouosKGNpJS30V7SF+ZI6qWwdZuSjy4WguIEJ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Yam69bZRYC1OtDRrMXz1EWwqYYqUbPbA9HU9pEbYuH0ALkvpQ8jKKIThxsBS3ROd2GqT6eD3dgV71lxfPPn+bKjqhZCGKGbErfDpTS5QQo3MZXY27p5ohu6FJESyq0qdTbL0RdjAe4o1Y32wthyo3IGmX833Z+Jjivr+TPorSmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=M44nxz0v; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="M44nxz0v"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-4629051c9d1so4151f8f.2
        for <patches@lists.linux.dev>; Wed, 17 Jun 2026 09:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1781713814; x=1782318614; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=i2Fz0gfXChJSjKov0DWWEtFMC4KgxCKir1jdmeKrCPA=;
        b=M44nxz0v4IrAGbkWTolHdSzMQvDH0Ebt3N1StOM9fF+KcW7XmKCk3nQVMqKrD2XJ45
         Dv3VZBd1Dnvol85xzPygPyLgJ5v6f+zwWumlHYeii2CcFKEvqSb8q+eCMfpXvA7BYDB4
         uIlPhRAcslBc1NoLANLavf/GOID6AJo2aXvhfayFIFtmC4FkTCdazUJEqsBtH2/VMTIP
         vM7iiZ5A9hmF1qzS17eA8mo7wYOy5h0VaU8wPig01Dxz7HYi4y83XT658y4D04ewkUc0
         OtQzl6LUVVQo34Ri7CCatDhEF/I3B745eANFbTeiogHQvSjcW2rh7YqO287LDH0mnrd1
         DvPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781713814; x=1782318614;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i2Fz0gfXChJSjKov0DWWEtFMC4KgxCKir1jdmeKrCPA=;
        b=cHwvdrOstqoIcgxfOZoV3AHSXHvTSjZTKaR3sRFaoNnpgpTvezU/w9fv+S2utMBHuJ
         P4DAIIRr4T8yfne0gzai62nRoIIHkWRcM8oh+/LbyXXNMdzGLRcCeXhDav79GRg497Cn
         Qt37FBVEqjiKc8GfgBoTEuYFxmYriuas2Jt+2f61wbOVXLKT5sMCebvicCr9bq28mRe5
         1Waa+gcvkIbttCkIpH7a8h1L6V9YgD0Ezm+zDwkzoWdhq6z0lBglnlGzaOgddI+7PgnL
         ddyFHd0nhbxJ2kZ9mdF9e59fbKp4ilhH5gfrwEdT3qi9R3YqQpkWLPiQpsX3Yxv1TYd/
         aLjw==
X-Gm-Message-State: AOJu0YxP6lv01NCaIBuQ9akGq7nqWfaL2mpE8VLZzC4dlTjlRcnwsR8d
	ubBH1Zjpzw4AGHbKeHnx/lRbWaCJ+syEWfKc8+hhGhNVYPq6K96QBUI=
X-Gm-Gg: AfdE7cl1M+FxE06B6BMCSue3ecZp4Iis2A5jkoYnCet5fqkgBlWGXAn/0ncv9+nhSRY
	b8wixsDRQsyxkg+Op4w6qLFbZooTJ3e/ijFDyURj6LnvZ8W1gc2ZVnZ3NX3uwpTJmoTKFUjVWhP
	JjLazqJmTxt1IVCXDLoMwJqYRqPIzU7UaP/quDo+J27O4n/34dYOTXX42TwHL/YGzR89WrFALF0
	6piyUH7jvBFFGz0Qek4oy53OLI4IisGT9RE7dov0iOKp4XignN+/xhFEiCVbGdJUUm9zVqALDal
	YfNAZDPUyTX+HtkF6H4Mdxj9hLPgyzRmzmDVDpo86uMQuuiuk/KCBfcvC1DyzvN2j1cWfYdZImH
	lJSwEe4Umnnur0EkQW+90MbDLtaLxb0gkcKOgqxrczXviRO4WkK3DPdRzSzpQbkeMzFveRJEe9E
	L32bAVNRXFzh9ITmbYtTLGQ3P23kz/L9+dWn5Se56hrTRl0HvFS3I7ri8oEI1NfGQ2MCld0+ru9
	rk=
X-Received: by 2002:a5d:45cc:0:b0:45e:945b:276 with SMTP id ffacd0b85a97d-46237d5b277mr5616577f8f.20.1781713814234;
        Wed, 17 Jun 2026 09:30:14 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4777.dip0.t-ipconnect.de. [91.43.71.119])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f26434dsm56803202f8f.1.2026.06.17.09.30.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2026 09:30:13 -0700 (PDT)
Message-ID: <96791227-acbc-4a38-b779-a4238f0c2061@googlemail.com>
Date: Wed, 17 Jun 2026 18:30:12 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/452] 6.6.143-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260616145117.796205997@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 16.06.2026 um 16:53 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.143 release.
> There are 452 patches in this series, all will be posted as a response
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
