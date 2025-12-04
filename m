Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA13C2882BE
	for <patches@lists.linux.dev>; Thu,  4 Dec 2025 06:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764830870; cv=none; b=DZhTwzdOlcLxM/eeGDWiJCnbme7gnat/aD2oF+gNp3REgluk/jFyEuRmxPQPgSFqRboB/mnS41DERQ3lYNeHzstPF3reydT8XK6nYMyExlRNxrc+7ZI6kQoYxyZchBf8T05nztf3jnmSs7km/XHN6I1zl19/GYk1P+9VvIKoO0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764830870; c=relaxed/simple;
	bh=5TH8jSxgRBK0Mx4NU+4zrUT3lUcr1yryUkNy8igJ/qc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bYcdAD/Y6k9dH4dalzMKNx/lphMrdhU8IyRSFsUoX/gyihd0AhD8NnHw8M6YcNGUxmI3jf5+5mB7GbXYPk0rCqE7lJhmh+pwij1R9qoz8xVdncpMWxLB7vjd0L9dBndGiJr6/KltqMEL0eEsULksULCPvnB3q5r/XRtMooug+9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=D7PWOY3R; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="D7PWOY3R"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-47796a837c7so3798835e9.0
        for <patches@lists.linux.dev>; Wed, 03 Dec 2025 22:47:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1764830867; x=1765435667; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TdcU8Ukz/TGTW7HeVVp4M3/aeghpwjrkW7iKaooXt1g=;
        b=D7PWOY3Rj7MWjQOh2DnoDE73izzJKvdPQ0MkQEWgycWUazaj6tAdkuacJ69oQiATVb
         5of67rJku7eHpeWdQtqbcIzijNq+0XyndeJkY//NeuQwK6sAHUuAkvE0MhKRk0Tg89JW
         lNwVmYegBNSCMGK8m3jjEHNt7keJcOBXvvUX76ypZPlE8rMvMIazHraADousTzQ2IrLg
         QnRfsj/Q/9bYmWTunXShJ2b2hZE1Hskt9GclrSyDr1YG2FW2L2/MPGgLeR6n9Gb4B58d
         gyv0TJLEeXT2DXrTcxxeJ+DN7e5A5CxfhZXa4VpeLuqN0ro/wxwFpZmKJW1z37tDJgLq
         m9YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764830867; x=1765435667;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TdcU8Ukz/TGTW7HeVVp4M3/aeghpwjrkW7iKaooXt1g=;
        b=TjYvFjJI/SmyrnduY6txEAE8c7Sdp++HO39ScPUlYoKDnT1++i1kdzl/G595CMfFxr
         vMhhgvMmy4U1m49YzZhI2ofEefwRevgHS0QZbRfncRYiqTYTzKk6tahQ3gdBlyfqaurx
         0YR39pJ9IYkDz+Xn1GW1Es/PN0b9+V2SyJF0R2OfcLjNOqafsbiCVQyccetE4+TOs2nk
         1dzFA0FbW6zB8dvODBqg/o7gxHyjhTd7cbe/0Y8uhYo8VbBlD0RQK28mqHVQz9Z2R2UM
         jhCkeEnMJipfdLZ4QGXz7n6iMbzfpJLCSuSRiww9ejQv8D+T/rxkpIm4Rao1bobHYshi
         x4Sg==
X-Gm-Message-State: AOJu0YyJxehABRY29HJkcVEjIrp5gTQBljknbO+yTDtwpIRR8ADsHfUz
	OkpvogjYL3sbGMXdrH9AL1YfkdEJ+lmgMw79pDoMgLkimym/ZLQ9tI8=
X-Gm-Gg: ASbGncs3JLOBW51sLtm353Cqvx0ODSRwu0lg9tWMvhHA8HD9dGqH6bplvlp58vLUvRa
	Bxi2W4EZVoMr7koVlSpFWxAcpEs+8L0uQyzLUaZVLkQShKY2YDE5vdL6hA4Oh2pHO+dRMBm5x+l
	a/R/OlCYt7elsDAy6m4QsA+c+qdW85EUBS7r+3s6bxWN3sl66jxnMv+5ASxGGLVhTOBRq7ypPbh
	xT9B3xyDq2KghhB2WNHNerVvBvOD68e21GUcfETWNmw+r4CZ13/XyWqkngCXZmWzKdmOcJfDdSz
	06nFrynQMsZLYhB6D1exjWLgENgiTFqQMA+gmpNHvMTec9HG2lo/skDgcoEsOS3cG2RCy21S/2b
	3m86dFqHUHUyPVMJFggmX4N8UaSx+d00mPEzwo4yposbqS8crZmHi/dTizms7stz+FjTb306SZZ
	212WyPCxaCNTs6hx43yGIgTKCJQsayTPdv0ZdotCwrqrKX49rQ9wWaMmqp8DRJRsUb
X-Google-Smtp-Source: AGHT+IGG/8T5jNcj/rl93miCheVqoRkg7y2S7lTb3oL9kLEJt+kpGHnDxsLtXY4t2LVXrkLJLEG0KQ==
X-Received: by 2002:a05:600c:3513:b0:477:7bd2:693f with SMTP id 5b1f17b1804b1-4792aee39a1mr44542175e9.6.1764830866832;
        Wed, 03 Dec 2025 22:47:46 -0800 (PST)
Received: from [192.168.1.3] (p5b2ac6aa.dip0.t-ipconnect.de. [91.42.198.170])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4793093a9dcsm17206015e9.7.2025.12.03.22.47.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Dec 2025 22:47:46 -0800 (PST)
Message-ID: <efd5a144-21eb-484a-b0f9-9d0d46f68652@googlemail.com>
Date: Thu, 4 Dec 2025 07:47:45 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 00/93] 6.6.119-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20251203152336.494201426@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 03.12.2025 um 16:28 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.119 release.
> There are 93 patches in this series, all will be posted as a response
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
