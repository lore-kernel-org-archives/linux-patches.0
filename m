Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15BE12C49B
	for <patches@lists.linux.dev>; Thu, 15 Aug 2024 20:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723753583; cv=none; b=mgOi/ltSuaeQ0VTnASgulrlW6eKNxbEyWW7RanPeccspNZLwxaer3fKm93erD5lqApPdeANn8XYKa9I+CfmpePqD5rPKftZQiNOj9T+BEDCWYM0FaX0KI7kadyma7A5R0rIKGqqIXhFLu1jWDgDYpyv758zC2unWjizEkEElZyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723753583; c=relaxed/simple;
	bh=8s4QR6foH/O7V0kChpXanieVCwaKYV4xvDze0R9On2k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pkbf8cfCOdui/c+WHTTLp2R06eDxPw3r/NB4PRWDZQxpsVydp+6iU8JL4F0vH9BH2NVHgtFv42pz42P++vUW9NhhNJlUKZxZOysbZgXlgMods1Kdg3MbJo+rIH9NWs9hTC2pqgL3mHT2zetkgi3t9jIJj0lu/gGVrR/Walz3nEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=kF6uoxtT; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="kF6uoxtT"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a7aa4bf4d1eso187407366b.0
        for <patches@lists.linux.dev>; Thu, 15 Aug 2024 13:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1723753580; x=1724358380; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XTo9UcDPJTTdaOu1u8gvMy8MXEwpXWrXxp4eqgmQ6bQ=;
        b=kF6uoxtT/g5iBGgNordHDmjhDqEakKFl2CAq5E1vBq5BNv9aLTbio5AdfG/vjtMuDg
         GBw5LCFO2wrJ9DApIv5TnNj6XyvGQW8V1EXmtI6gj7eRpWP5ofMDia5aD1m/6vshW9TQ
         eGzhH+k+clMdAMucGW5GgWVhuRUpw7Y+iUlzHmnWoJvRSsn+VsUkGYorzoHY5E/drkdE
         +9VLdHTHA07TZm0gxXmvwSNNNFOL7Ha+IjGD94pr+FRcuV/VreUnEyba7d7DKCn22Uor
         Ocy0aSwJ1naJ6nAD4OUR2weORRC43KXE5jVRN2VBENpzDbVdEFMhs+DcqhhYQrn8ITEy
         8+Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723753580; x=1724358380;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XTo9UcDPJTTdaOu1u8gvMy8MXEwpXWrXxp4eqgmQ6bQ=;
        b=ATZ7m0WuK5eZNfv4rj3TJcDfhqQ8wcAbFTMLGqQxhIxXnH0MocJo259CH3H01GqbP7
         Km8MFLpA0LMDDmugXwp3T2iiErXmgvb3TeKPTRQJpF5YgVpwhD7djJ0/KBkXNa2tcoMV
         Qpj6sx7tLCqu7/zVzIToQl1fdW3OBkmMoLV4CLatpJIqMgZCmxej80SO71EGU84lflhg
         aFWOfUArpUK1g7mKEJZIFlgcwPd5HyzcjjRSs+sEDEDdZ19o7+3QtizXIl2xps1bIaX3
         JfrtBsiQOG7JmZ4kgaWQFnsRFI3INx/eBJTYICaKCg08E6JADuRlfZVfddTsUbLAz1+r
         FiDw==
X-Gm-Message-State: AOJu0YybAADIXK1nnDTrQSZghIsN/JlBem83Gcj1ph7MOziIBuSZ/XeB
	ZDLKywgOR58USs3RfAHONSWcNGJvItsma7yqeObfI+eFnR74Deo=
X-Google-Smtp-Source: AGHT+IEgyjIkByZisdAJSl0YucYfm15NU2r0gkdCcr1/zItcwKj20vtzJOTNDSyZQLOhE9+TR6DGAQ==
X-Received: by 2002:a17:907:e2c3:b0:a7a:b1a8:6a2e with SMTP id a640c23a62f3a-a839292ff2bmr46830966b.28.1723753579884;
        Thu, 15 Aug 2024 13:26:19 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b41e6.dip0.t-ipconnect.de. [91.43.65.230])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a838396e0edsm148923866b.222.2024.08.15.13.26.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Aug 2024 13:26:19 -0700 (PDT)
Message-ID: <aa0a60c9-17e3-4521-9b59-5783d7145325@googlemail.com>
Date: Thu, 15 Aug 2024 22:26:18 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.10 00/22] 6.10.6-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240815131831.265729493@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240815131831.265729493@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 15.08.2024 um 15:25 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.10.6 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


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
