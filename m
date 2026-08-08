Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C792EC08C
	for <patches@lists.linux.dev>; Sat,  8 Aug 2026 01:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786152080; cv=none; b=XLyf9vJlkNSMoIveBCe78wL4R6KhXiMTu0DVnukeuQ2jqAAvBjoAqwvQimEbPrte6PL3je86Ss5y1sKL3U9eCOkZpWtyK9u380DEpp/qEHZnxB6lualnugLwDqnEBHkG4v/bPlrWJT9xb4VyA4ilZqPxkv8kUEgTR3GGqRkrj2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786152080; c=relaxed/simple;
	bh=rNkmRRpHkjSa3uaDe3c67+rPcGRwfoMM6FHkaO04Gd8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OjT36u1ae2JKCm+gCii9zSqZ619mtymP4Sw9m1K+0tiV4VC0rpAxPZYb8cWfHFkeYo9wc+EA2p+8GoQQpy/2Hnb/YupRaXDoKgc4WK/hRbPhZyCM5nDeFq5r1Is3C77jcMdBIyY5wLsjP5dOcNbUoLTq36YIPee2Pd+jcW6YR+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=FGiZXb4k; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="FGiZXb4k"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-47f703a9e5dso31349f8f.0
        for <patches@lists.linux.dev>; Fri, 07 Aug 2026 18:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1786152077; x=1786756877; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8rcoxkqGpzG40Z3CfGl8roTFSAXZr79E6UUmvO3lWu4=;
        b=FGiZXb4kkZkqkpaTDdjsyO9/R3OBbHLN5bVfgbT5lSGdpEZoyD2diX+OUnz4VFviO2
         KlNHmgzm/5/L0gQNoMaoXQFJ55lwSb6GLHQFkpumYS4MgPCDBMakjsxSkpZLA/gTaQtT
         Gbr/oholcE+JpSI+hNWS4l5wn3PWvv9leLKWLaYRLMgk51PYZApV/5hyJttsDFmogU2T
         fNzS2cOkv0QicvM8pcn3SJJYzybmqtVPYgAMAD8AJ1AUqia93HMuvVQ3qpb/qV0zeDty
         fxJZB5bBY7syRtgcMexQiZWQcM7+EufIA1vewDx/6QdWDgMb4ieRPZQRgrbbl4sW54Sc
         IM2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786152077; x=1786756877;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8rcoxkqGpzG40Z3CfGl8roTFSAXZr79E6UUmvO3lWu4=;
        b=bHZC3RMm3UBVNXa+90QWyYDrP32qawYF+dnCCUBxLXfkJIk0B0K0OL5QN3OhgCeknI
         lNsNc7z+F/ZtHf5MIUoD5kHXmRO3uulSxW8AbMRKzw8RBzYH0D9uulI6GcoOh9jB79b+
         3y+F5tl0kx2TzNb0S3H05M5AB5LfM2GNQz7hfqGqiVYN0TgKofLnS8XS5YuUAE4G78/n
         E76tb0A6nOIBYkMv529qDDePt8CRaLs9Z8NZGffxkcLOPpD/j87D/q3rZYc8GAw41aJD
         GnjFTnEnAEjVtVg0NKYHCRfiYc7abWlZo5O+3w2GfUnfJzzV1cwRuEOvEC1bhjKe/QQk
         ztbg==
X-Gm-Message-State: AOJu0YzwftV+1MvABkFJ7as82XNEPnu/HtV78o7yaLWO2P0Ck9dq39q4
	cyCJaPooByfxQ2qyIYbEHPGcVKbc6klBeV5x5CAWk3kDXFCTVSeuAQY=
X-Gm-Gg: AR+sD13PKUp5vcOt286E+Erh3WOdFZzgzDSQBFhbdMTEMJVmrvhquuv+B0VvoQJyF8W
	tGTli2GSFNoI8LA1TluLFF7F7RZGgsuie4QkddOwAvZBEOgEcbpgtYUHKCPVYItgAlh9GyV1Be7
	tocXZwYkPFzGRMqZm8rNq8Y2U+t6TZoQB6GdkOUyoQ6oqBq3qKuN7zddKd0U2GizyHTERAnwIBz
	AE0kAiAwFfvCs1UczYLzv2D5NHB53E29YCilyldV+7GqReaeSQuzfXEX8LKRKNu6zCpMJZbdnHR
	AI3m4UZGYCcP/m2yMmEVMvHuhlJ1B14na7q78JuUXfUMjfiqW/p1BHU6xW2yD9jaK1/3i7pLlxT
	UIsgZ+55bzHcQyPUwwQ0qwtnsF5e4joO584Ubw+F2qVy0wJBeX14kesKLIGhleL9nDulKFL1+9R
	Yb9AZuKdCABdqQaBCTAhDvMradJfI7THv7wXOuLPsMqRuWkJ1HOicNIryCuP5wUTP4dz5gbozN7
	N5Y8/X/7cJRXj2xD4ForkkaNnmXpJGh44f7uRw3
X-Received: by 2002:a05:6000:29d5:b0:47f:2de3:b351 with SMTP id ffacd0b85a97d-47fec63538dmr30399389f8f.26.1786152076941;
        Fri, 07 Aug 2026 18:21:16 -0700 (PDT)
Received: from [192.168.1.3] (p5b0574f6.dip0.t-ipconnect.de. [91.5.116.246])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-480021506desm10520745f8f.10.2026.08.07.18.21.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2026 18:21:16 -0700 (PDT)
Message-ID: <5392720e-f6bf-4ba7-8e44-fe20079c4c20@googlemail.com>
Date: Sat, 8 Aug 2026 03:21:15 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/261] 6.6.151-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260807143415.358597922@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 07.08.2026 um 16:35 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.151 release.
> There are 261 patches in this series, all will be posted as a response
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
