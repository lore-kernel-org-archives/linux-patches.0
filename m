Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8954D46AA95
	for <patches@lists.linux.dev>; Thu, 30 Jul 2026 19:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785438940; cv=none; b=STrFYscHDpohf/jO10SLNUUTGGEPwozIICAfVk1jZCfBMWsBuyR/h1tgbQjcJNzdJfvh1bwDL2iimmDf5rBe5lVh+E1Kk50gOj6mfhDH1pXLnz82aU775An8T7cpxqOkxoTXLJZvZCS+GAl4mLNqE4lPdmRWxQ1FA6Q4oq9ZLsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785438940; c=relaxed/simple;
	bh=lojbZy1RwbOgF4vPX/jUdyX82yx8NEKiG06onugIRgg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SAVz7PLE+AvpHHh5ELoyrYpJPG0JrN14pFLD6av/vgLkh3+2O0fWWt1qi0ZBdruT6divDDtd5XyqMVMdCukMqOwgUtFwijmXokdRJWrs8VM/+ziQLej2fGdS7aQnPc+02D2susdKJAkxf3FuR2oFDvo8exVJz97Q93ivh7qCGyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=oXdN2TaW; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="oXdN2TaW"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-47f9ab7ee38so42143f8f.2
        for <patches@lists.linux.dev>; Thu, 30 Jul 2026 12:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1785438919; x=1786043719; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=b10f7zQkiK/pqILj1qVkqYpjCdKGmpebJhDPH6RMsaU=;
        b=oXdN2TaW1GO63i9ZeKQ644+sZuw/1Hq29jVONB1ulVDyQ6J8QhSfiKEHP4v6sOVvDP
         R3Ffu0uDwNdd4tCzjCYNAu+gcZWV/lXkR5rROAF3UQB7TzEjFEmdjZEzVnVWyBn09Rnw
         3utaOcLjbjQ15iTdIMW6ufSjwMqe5ihcWUtzkC/wbITieFYaXYlGc6J7KuBpIL75NM72
         4dpouFLiy6yZvFO9FB3skXRhytu4rtV08SyGmBcDEC+2qTWSBpD7Gnu9VQpYUXPna/jE
         DM54r/uPtjOWztHWU3TH0uC29uhr8Xz/vmgLpUA1RZVJXQocCs7fs3bJYFw9MMIMUWEk
         eu2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785438919; x=1786043719;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=b10f7zQkiK/pqILj1qVkqYpjCdKGmpebJhDPH6RMsaU=;
        b=kbXtEA1gmLV0UGd5LcpqMBd/Yl1NmY4GYY3Klirn+rJrN5nG/Hx3s2TRZouGJPXzZp
         7GnLJyCyQ/r+ge4KLTCf4bCyZqsnQzs4FoResimMQwM+51N6LI+5oEh/eKWlmqatDUn4
         +LWVM+vBktk3bufsZ8HKsv51mMK68xrR+ZF9ycOKTp4WudhviCO60mS2EbqvTCGHNoG6
         Po4ZXdUYSLmfItLdkd+bLWn6kBWj4fUGwOPPfs30rmvv7HJmEfRBgJQfHftH1SZT6xUK
         BPH2UI5D9joBVv2kyZyuN4rReCfYFXE0GsvtFVwql2WaYlncVvGD1RsbtwBVQWCbgfza
         APKw==
X-Gm-Message-State: AOJu0YwkgGMglpRNkUl73J9zKoRW/FtokMS3OtxT6Z2X8vi9ABOCzJGA
	SS00LYdXH2u2GdAE+mjx1qnLR1/6zHPAbM/f5Clqn1kRYPQqfnRvS1Q=
X-Gm-Gg: AR+sD109sIj4PlfJ4w+yqgMVC5gszxmG2rSm9bqPqt7E9qvRe3aHM/jnYQwO+3rjcah
	9zWfbsW58cxGz7zhciUp4at0/cIly3Igp9haVCtk1WpZ6cgc2a4TuIUCysWJ+FAKOHP25Uw6hKx
	E2S0H/F8Vn3v/zfSEMOOJHjouSHIG9UC2Rd9eBTkERdneT2Wbr+XNh0G4dEzp7dIHKfozceXVtd
	1tQJ/697dhxs9U1MZmczm6Vz6isba7PhTq8jINWRoHHdZSope88K1NLcXgt5VWZlX39dHg0H/u9
	04R/6Y8WIOiwUFTZsYStEkmd9+Yd6kn0egcVjp2M8MZjNc84MHE7jVlUWviPL3bSIzibcByQPPR
	SVP23XJPOapnon9mQDhMxJP47N+HMKRJzAxWPf+oftUtBYa+sxQlJULcicgfkKH+VDlHK46idm7
	fV3Cl7sTyxcRSa4Hcv2bnbU3a72R2iwGjqjIUuv531mr14u+sGu+SmHTP+WZmTUe/OkGCKk7l7n
	vXnKPxsheonyMmuGwhgmXvEgonpBdy+sAdmvXjPQGN5ZtKneQ7P
X-Received: by 2002:a05:6000:2910:b0:474:530:9d with SMTP id ffacd0b85a97d-47fc81f5604mr6403589f8f.13.1785438919286;
        Thu, 30 Jul 2026 12:15:19 -0700 (PDT)
Received: from [192.168.1.3] (p5b2aca7f.dip0.t-ipconnect.de. [91.42.202.127])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fc88e3c73sm9028629f8f.10.2026.07.30.12.15.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2026 12:15:19 -0700 (PDT)
Message-ID: <d0831438-a21a-4eb1-9b97-13e0f2678a6b@googlemail.com>
Date: Thu, 30 Jul 2026 21:15:18 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/602] 6.12.101-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260730141435.976815864@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 30.07.2026 um 16:06 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.101 release.
> There are 602 patches in this series, all will be posted as a response
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
