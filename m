Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007142D6E6C
	for <patches@lists.linux.dev>; Thu, 27 Nov 2025 20:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764276616; cv=none; b=BYBFybrXFhrfGYiDoG8qsSrprR2epncXcCmx7DDiXaKpU0ik1Xq03e+MNU0vzRzVIE1xqAyVqFRUqMw7UfoMS6epOJCIUtijNAq+KBG87pjLqeFxqQNe0SjY9MVjwGBG4xG4tiw4tUkLDngiWgHK7wBt44wxoyv6oxQIwrl+jWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764276616; c=relaxed/simple;
	bh=mCeCg4D52988DKNuF//3bxsktZksu3PPAezgHB+YepA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qRmqrxrLKF8s5fwuBGCMRp5E2ZPKQvOFBw7LB3JHy5Z3+bqE35ZE8yS8eA8wZnxo7qoXMMT9wHXTpLwrn3Rqyw+29OxCcwzHxagqsydWQH49cC/lmcsV2zm43NCVT/QDfXEPiVZL08x1ZDVpq7evx7U0QvB4gyb7uDpKrMlFEv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=KpFDume0; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="KpFDume0"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-47778b23f64so7229155e9.0
        for <patches@lists.linux.dev>; Thu, 27 Nov 2025 12:50:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1764276613; x=1764881413; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c8Xdso/vJUzrnGDGaQ4k94sfnF9stKJvelC7TfngjEY=;
        b=KpFDume01yGlu4wOKjKme29Fh0ufBlLlABfobEjfXitCOwQlknc+qDsAiEsUaBsdxt
         HJDzZ78nJxqPKqvydiJ9i71wDrlXn+UC3YaEBTCHSDEnSlRdXkC/FBlyIbbuWZdcj+aX
         3jB1dYewxi3FwzF37fkfCzF+asCy2fJ8pr83Gk1fyhf3uHF38Ux7Y1zlJJe3xTyzZ7H/
         zAM1l+6s/+1LqwbOn7STNIpBILKn0D9/xja5HVu5tlZbifxeyl5/fmQZVzuFkOMZD5Dv
         t/3/JfOU8u4x8h3H8ODIvoFplWaIK4DYcfJkhm3AMjPmDMoPRGX3Lq4P+b3lamk40rjF
         PP/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764276613; x=1764881413;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c8Xdso/vJUzrnGDGaQ4k94sfnF9stKJvelC7TfngjEY=;
        b=wKt2xdDaKMxWImYN+uBCfajYduiTKnmlmTZx+pXs11y92kYmQbVC0B67eBmuwrsV3s
         qY5ghr/x7qIQflNFSQyjXMa28D/8l2tiTH0evXtItTPO5/CDZ8NnCPHZ2p6merk7SjtP
         flW73a/x5zdcoOEIXIIa30nfGOJVMcv8GrAYjmhkcvvs9n4ETMr7yv7o61ico4gfOo7u
         RFUiCfCk0kVrHlmygE20S++LqQrfFaOuyPTnVmxRu0YZQ47TUyWAVK+6eBXmIgeofLvB
         gYRJJwlR3eEqvwZuY7eeVpRt/plU/GWuYlkVhl1NUnH9FOG6FiarsIJ352hghko1nggW
         NsXg==
X-Gm-Message-State: AOJu0YwZdPeQjUixET/YGEMg7P+lt6/FPBPlsX/r8LLn3qb/ZnA+V4Yr
	H8jLnH9vQlmmSHiuMVg//AeHd66mbJ4PCQ8WCxkiMPSRB9RiMNh5SJw=
X-Gm-Gg: ASbGnctl38JW4TlkX/kTJC9Mc0Z593E1LIR+OvBjhL/4kK3hSF853SIoJnO12QSAxEz
	ZtbIdnrl7CC80R1BFoBmQM0osBFMb6weAahnpGPehGWczlw34n8hGjibOxwiuQuTfp/8F3sih4D
	LVZgmFn5BUn1ZbEO1ZnuHStu0jmaLjPetSd46kcMYXMMRp1KG4JIPzt33GGECr/yQXAFQblPWBc
	5tfAZOzDetIa8RNd7BzLslJlxWE/7O43egdjbBG8ZnEcWRqO/qhccEHuNJRQZhYJbtN8twuS55N
	QRtgcAcuRl3JQF/b1WjoUEizVPqxkEl9B1//KuhmqHKmcDEjmHfnLtZBinUcbHG+3Qnf3nvamps
	zb7WdbmMTM4Qq22oeN2APSDWiuIUZK4mRrxwo6ejVEpK37huL4sfOv/M/1alHlfycWUjkIPKCDV
	CB3xW3zzPJz9tWUaGjb9k5yVzLal2fjsCH6qsJZdC44qqRNljPGx5VkI91vLCPlKFuupcDWVX6w
	g==
X-Google-Smtp-Source: AGHT+IFqZufCO58HzmBVCsCFsx6gg27xqeFrFAClvB4ROtH08IZI39LROMTEKx/loElPsGPOmbPwMw==
X-Received: by 2002:a05:6000:2309:b0:42b:2fb5:73c9 with SMTP id ffacd0b85a97d-42cc1d23bdcmr26975766f8f.58.1764276613165;
        Thu, 27 Nov 2025 12:50:13 -0800 (PST)
Received: from [192.168.1.3] (p5b057472.dip0.t-ipconnect.de. [91.5.116.114])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42e1c5c30b8sm5555753f8f.7.2025.11.27.12.50.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Nov 2025 12:50:12 -0800 (PST)
Message-ID: <75ad2d09-c09c-4cb9-847a-c5a33f237f40@googlemail.com>
Date: Thu, 27 Nov 2025 21:50:12 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/113] 6.12.60-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Sebastian Ene <sebastianene@google.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>
References: <20251127150346.125775439@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20251127150346.125775439@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 27.11.2025 um 16:04 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.60 release.
> There are 113 patches in this series, all will be posted as a response
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
