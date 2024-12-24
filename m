Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979488C1F
	for <patches@lists.linux.dev>; Tue, 24 Dec 2024 10:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735035875; cv=none; b=BPyHxoxkuqgm/pVcX512WR6vP34bF1MpJKBSgtOSNmYJCR3zGNp+aPlGGCcMfqtHyshPGUDR1AhSCxbn6n0qQxjN925rZTcBTOgQV6El9a5fOpQsYOSaLuMXAm8A3w/3Rp/WOkR9nPs1ii57kDFXxnxJ/W2V850R5S2Na+Mlz2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735035875; c=relaxed/simple;
	bh=/CA7NP/ZnP3IwCHSo95O1qm/7KGv2E/O4+51jpt0foU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j32Dsq3Idy3LISrf+sN9oELRvf/9DElwOfkFS55WivTWN6mYw+7Drs+7r8kAHmPkRGGLl23/pNJ9dRTH8GI8+dBeIuzuVTC7DL+NWfDi0PhtGZT/kDaVK2ljTuEGAm9awZHeXL63ScIWKZeKODbI2wB6rca+FQErxDBlUU59+qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=SRM8zl1O; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="SRM8zl1O"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5d7e3f1fc01so9525695a12.2
        for <patches@lists.linux.dev>; Tue, 24 Dec 2024 02:24:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1735035872; x=1735640672; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A0n78WpQljE2rbLAC4m2xEeIo/FCq72TLzeQgA1nLoA=;
        b=SRM8zl1O+3jfJkc3MXpusmzea+857S4G4gwWkeeQKEt4hurnh57+VdduB/l/2jF8uS
         gG9Dy84r+A4/r3sK2R7uY7JZzC4Lj6X7SyOF2L14ZVou7BcsQZvzkta9axeVrMh7x9XC
         IBaJQv+4n+Qyo8P3R7vlEzIECb/E7gl+zyG1OQfSE+dcJqLRjFuqZh+64DVkoKjnIqu8
         9CxeN/BE0cLi0onNv0LsqHma3j/Y+jjFHvGlSHLsNWb9WFzvu98jDYabHg/c9IRj6ogF
         vI7HS8P2HbvOfPjNQmb01CYfaeu4H4dFmvNfEABVNKOpKR00WVhih9J0MRMO4W+EYzKS
         KHng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735035872; x=1735640672;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A0n78WpQljE2rbLAC4m2xEeIo/FCq72TLzeQgA1nLoA=;
        b=VdYjtEjfYxTSvjZYVmGeOo/ORJrb+590qMw4OGdLliLwaETu/HngYPKqEYUTx0TaDf
         CDIPrEd8Dm4gJN4knfUoE7JsIh3vNn2VvtHu+Z8z6k00kopfGCPLMzMo330GLvsnx9+a
         PaPUeCp3nFdJf7xpKI/ISngSRX2nuTVcUr824OzRg/k2GuQS8CF0estczIWBC/wPYrpx
         f9Rggh0A9UzDvgO/rOOHsDV5jIXvTmHW3s0SOPvZh49IFO12EiZdxxB6Tu4JVz7BJ1bz
         Q1B0qc+UcrOpIh486g6n4IwXoMJgc4k7vGiMj+d1d+VAxwU9Z9ieb0hcmL0jtUCFLcAd
         lFkA==
X-Gm-Message-State: AOJu0YzcZfst8B0w2lVoxijTdlC4YbjLTB2gY/1CSv6ls39Y8u+j31Ck
	AzIWE3bUyCjmrlg9/bJ/Y3QOTacl6buwgZ9uB8CuhBsmCRO7nNI=
X-Gm-Gg: ASbGncuArcNgYhj0OrKdnXQgnh2liMoMREJx7bzpzK4dB70Ahiww2T06n5GxRVQu4As
	jNEmP7VXfvevgKvU0K/2ccp5CLE37wGOhZsHzh7hGl18VIFWYQv8Quj16616vI941KYzphUnxOc
	LxVYyGVZ5XwW3tPDkbInbRkmJiIrox+YW/adaUL8sLrdeTg4jZ60JgW0ALCTyUXryCF/FER/XS2
	nNKaEBic7fcwilQL23nTbZpzvNzSNdQZL4kNfwwJ1RBdoZ/r/RaDnf0W2NjzMQvl8zOI6JnoOTd
	x4L7gU37CVcb4m6BxMiebfNrw6z4+4LzPA==
X-Google-Smtp-Source: AGHT+IH2Fu6UrfuoQYzd/8BSulBII20PjE61FFFezoEMOZlUroC5nNqnJi8yGge3Oeksh/Ss8h2HFw==
X-Received: by 2002:a17:906:7311:b0:aac:278:98fd with SMTP id a640c23a62f3a-aac2ad80073mr1512834266b.17.1735035871723;
        Tue, 24 Dec 2024 02:24:31 -0800 (PST)
Received: from [192.168.1.3] (p5b2aca5b.dip0.t-ipconnect.de. [91.42.202.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0f066130sm638624266b.183.2024.12.24.02.24.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Dec 2024 02:24:31 -0800 (PST)
Message-ID: <ba78c121-5952-4cc7-907b-9ba74dbbec53@googlemail.com>
Date: Tue, 24 Dec 2024 11:24:29 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 00/83] 6.1.122-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241223155353.641267612@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 23.12.2024 um 16:58 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.122 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>

Happy holiday season!
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
