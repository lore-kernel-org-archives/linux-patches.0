Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90715247DE1
	for <patches@lists.linux.dev>; Sat, 18 Oct 2025 03:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760759628; cv=none; b=EphOKdHCgfo8YVTU99rK/N+NfC6N/GdEOuG1YUIgzZVTy7aK0kvgxzhusSFgJ19bdDFT5gsIdjKX8iAuzJJCSzzHYDnZ2DnikJcfRa6R0gL4TXtjhbXaOtX1p6Jz9Kv9Ag/rVhT5AL02EBP4bkwHmmoCJedND6nXlE+4iociVNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760759628; c=relaxed/simple;
	bh=uHFmmTjt0vc02+wTfwAteN3orrvhT+UgW5yCHpFvPBs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CQ7+6xVVWvyaHJa2TdBw6pgDOfdpZuv8DfBucVLYiEOYX7wovrqIBLdIxzOhAxq4Qt9Y91HzsKD6JtOteQ4cEhFV3LInAXnseQ5uD9dU4+LNVGSgsm0IVqJ4mK+dZI0ZOgRejWkMK216xTtlnG2wK0nFQtTmjcqUnYCwM+kRNes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=BnYGV8aE; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="BnYGV8aE"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3f0ae439bc3so1252660f8f.1
        for <patches@lists.linux.dev>; Fri, 17 Oct 2025 20:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1760759625; x=1761364425; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jL0abL7hS1wNxZfx8D6u2myeTv5rkFlq4vfgdvw8ndQ=;
        b=BnYGV8aEfmphzfyZf2QpVZmWQWwUUkKccwSb/SLY93uElce7Hj/z//V3tNpBGS67yX
         ipcCUXfPPFOvKVp6LqDpZahX491LeImTXo7fKaLfZYPo487h+g2aCAyUmSM7pGdFPXWc
         vmhBRctRHAMdygoHS5wqJxI/WsQ7HG9EYozh4ozdrW/qr/XB+hOpDKKHY9CConu3xSTF
         1dJL3Egqu7V95QUWP3x0oQccmV0kuLzX836FQkJDXVi9u01D9e4yE0uTa5imE4RQFFcr
         PnEQed87FtxsJhVWCo57vWrzYGBmPAUB6L0Fp7RwRKR10JOhUt98s23LDJuOh3MVnBwM
         YImg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760759625; x=1761364425;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jL0abL7hS1wNxZfx8D6u2myeTv5rkFlq4vfgdvw8ndQ=;
        b=paa4QjlSgpillecDbu5nG7KOlC3vtrEedHYap5ISwpzAsPfXf8wRv04iBfMtf6wwZH
         RsDIG0TnljMlDC7lOK1KdL20iN2s0QSic3KKWljicOChhELiBfQcxXFzS0FxCoIKUYFO
         0wGdoj7IziL/SQ8CifxD0cxPPNVTt3r1Ch2Ja2eDs94zWb8uJPu3hP5WJljZR7iXgukP
         gUdnsM+zAH7YFF/NWvlTcSnRv/HZeOwbp/MtqUwb0aHQ/e8baYfh+44v8E4En+AWy449
         TQwyz/MzNYOnTkyc4r3u5sSfLX5PV5McTlhEPuxwy6Ugv4qPCDd7Rom4DUYXnieJvHdv
         N6vw==
X-Gm-Message-State: AOJu0YwgJhC9QHQwJAc5J25YddFejPKQAfRxXwXfWCcPQTFRQRKK2g8U
	JYnm/saGFs3Deaf7SI5hiSxWY9hO2B+q0cUytw/gsOHvOQxX3m8LyTg=
X-Gm-Gg: ASbGncvvzOlAW8gpCy3RjlkVbYlwronyUXM14W+gyPTVTp+fiblR6LsE6ktteiwhxy8
	KUy1baoeKYi2ShtavxM/zQjkJN5xF3UBwAYq8hxcOSn9twacoefj87CTZ/8ZlZamC3AVrg+26B7
	PCjPklOuYIGYvQVnsdyy9A7ZSvTs2Sz+cX4sT7xx+/Xe4g2ZcCMcfvK/0oZZ/RTTNz0q70LPaDN
	IxM0B77sAYVosIiJ6115fSnhXn7mfzNbci/4RmGTbMUdwn32v3iAv3PcM9YExr2GJDMwi8IewcD
	0yGy7K5TUlXW5m6t0omjAxgMyRYka3OzmZTmzbxaMCDBfstkoZpNtlQz1vny3N0MBs+QBDimlwA
	+PC1LAEH7DXW6YjQb44pUM44czERKMJv9ftkP2KKqe7ufa/sEnEB/i3/b8c7om2aeEe3nVbt4qb
	KoKJL5/E5s5pw/wHr6XsHbNI8CZZoIcbxvAHaaxSuBrWbcSqPvDZRT
X-Google-Smtp-Source: AGHT+IG9plhdnHlXZGdT4B+VnjYq+D5C7vfXaHBjqJVVvO96WoRNs1XSe58bAVVYKHVYV0Bzp6AaKg==
X-Received: by 2002:a05:6000:24c9:b0:426:d549:5861 with SMTP id ffacd0b85a97d-42704e029bcmr4428076f8f.42.1760759624746;
        Fri, 17 Oct 2025 20:53:44 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b488a.dip0.t-ipconnect.de. [91.43.72.138])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427f00ce06bsm2417213f8f.45.2025.10.17.20.53.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Oct 2025 20:53:44 -0700 (PDT)
Message-ID: <54f0ab53-309f-4210-98eb-629cfbbab471@googlemail.com>
Date: Sat, 18 Oct 2025 05:53:43 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.17 000/371] 6.17.4-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251017145201.780251198@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 17.10.2025 um 16:49 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.17.4 release.
> There are 371 patches in this series, all will be posted as a response
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
