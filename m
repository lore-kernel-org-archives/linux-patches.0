Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977A319597F
	for <patches@lists.linux.dev>; Wed, 30 Jul 2025 18:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753901192; cv=none; b=r9SIYLkmv4s4mDfv+kQf+a3h/esDLtBKewhwuuxkKiouPOsLNi69UPYajA3DWn/0dL5Bf6iD7Q/Rx941pMMbugpCnJQySUrTG7Zbzj9jZKlD2vERxzxf2W8Yi3iGvAdwdKXU3I906TSKkbHPKq08vGv+47ZKsgGUj6IioQg2XsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753901192; c=relaxed/simple;
	bh=9X5rB2DD9NvDA87R6zBY/jLfEC/DuBTtpZ3q4uwJEiA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R3GZPcs67CUAsVsrrPAGSMoTv0tkqpNxOLKKfYlvhzdBCi0U7BVMh08T3kgF0dml0AHDQG7AdHExW9XEidtaoBzGKmmLc5rEPI4NK/W1yIed319pKVvz7FLAfMzoBgAusmNcz6WZc5kYwb+/tlRNR7Il2SQtfzOPuLGMLyBFmCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=mWthIN8B; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="mWthIN8B"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-455fdfb5d04so671875e9.2
        for <patches@lists.linux.dev>; Wed, 30 Jul 2025 11:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1753901189; x=1754505989; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AXT96IcPXUVEl6g+nGD58CFvGJlPwbsKBbwPj8iXt+w=;
        b=mWthIN8BaCbMXqsLjbhnu/5H68DPOY5MPoy0Sg83lqL86HiSy09D8l5i2pWFbu3PQu
         ldoy7ncNBNw0UR1pGxCMEBz6vktAIhA7IBaI8IThRcgp+Zt14eQudO7hLWFCQlQUm2dy
         Y5bqVagYzLhuqVVvpTvXH8o2YIS5VNh2lMddg7i7AMbpEU+DeirVYYWuJypkHUUfEa/u
         OMMWrh2JjoCyTvTYtNA2DYnaJaKcpLS22IbnWdMz5uPVQgnwpFcyskJcNSOnk7aaPAhg
         7IvYntxkWgs6PnQnEnTB2kLKKzZA2S+Wxyu9WXmr5jph/aKtO8g7HL5Qp1YurjPw0d8D
         slVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753901189; x=1754505989;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AXT96IcPXUVEl6g+nGD58CFvGJlPwbsKBbwPj8iXt+w=;
        b=gf8C+iZRMx0cYECIkTGd2NACZohjE55bB6tjRZ8J3+KZmdZRT+V75wpIClldpYG9DM
         rJUG/zQ8nPR7/0RoFlSAqjMfUWahrBP/qxF2z/0eNR/uysITg/AnGA3/M62eWBtSnesK
         vaAtumEOAmeJJvzIrZ5+EtcUyC/6cqaJfF5Sh3nexQGLpnM84OHSYMSM+St7Wv8uf3Bk
         cAf33VMJHeT4Li7szhiFdIxA6BOYjUyOkkIGbU2dAMKgfZq79iUnB9TCsP4hoNc9cYVR
         2eZNbTnXY+vVEM7UAoZV1iHPEc5/Amm9fE03UtdpaCn3JMFe5pGZo0aiJcgwFB5yLpY9
         AXIw==
X-Gm-Message-State: AOJu0YxhP51+vXGzziz4WkfAV2f6vcxspUQeU27TkZXz34rY2u2YuxkD
	myxqh7jh5HSfHLFbiY7CpxTaW2jvdz4rCKdZLmooDgE7r3PoWnXUj5s=
X-Gm-Gg: ASbGncv6XK2w/0FVBjOm2PXVjuiLAYL2Z9NleHtpoMDE71LupVXxzKvHJNSnCW1KKHo
	3JWZ05MlwC7AQSuS1yPHnkDvaDFadX2RxkfpsAh4YEwuewOTu7rVaBhUdgzJXUm9rZshEbFWwvK
	Y2uPKT0OGY4+Upj3mmI7OyiU534U5Gj8h+uRT6nWPgCHa1NNemktdvc1l6jUtUaxkvN6cPhEvfh
	5uuoB4YqD31ghwxbUmlI1tN7tHn5y9Pd6BKQpMLTw28B8tSM6R///YwONlnOFvUUs+fFyiIQ2Nz
	oekao9OsKz8P9bt/RX4tiGcii6QdCZK+XKkaKR+X9HJwoByeMfGaO8hs7lm/ysBQACNy9pC3bHF
	ADQ+KgxKhUzEoqq1XW2As7wztwYWW4tkbkgRezOou2hWR6lM2ZhTdDyjMcIzrRpb1XDCmdBAI+C
	4=
X-Google-Smtp-Source: AGHT+IF/pbzgQd+sQCZHmuo70hAr+91gxeh5dQb8U4efTOyD82aT1sr9wb3UzlFSREtkjtbyKAIjiA==
X-Received: by 2002:a05:600c:c4a3:b0:450:6b55:cf91 with SMTP id 5b1f17b1804b1-45892b94d5emr39235455e9.6.1753901188618;
        Wed, 30 Jul 2025 11:46:28 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4284.dip0.t-ipconnect.de. [91.43.66.132])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b778f04009sm17082353f8f.38.2025.07.30.11.46.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jul 2025 11:46:27 -0700 (PDT)
Message-ID: <d04970df-1884-4007-b0ae-8c964d517dbe@googlemail.com>
Date: Wed, 30 Jul 2025 20:46:26 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/117] 6.12.41-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250730093233.592541778@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 30.07.2025 um 11:34 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.41 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Built wich Clang 20.1.8 this time, boots and works fine on my 2-socket Ivy Bridge Xeon 
E5-2697 v2 server. No dmesg oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


[    0.000000] Linux version 6.12.41-rc1+ (root@linus.localdomain) (clang version 20.1.8 
(https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261), LLD 
20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)) #1 
SMP PREEMPT_DYNAMIC Wed Jul 30 19:42:27 CEST 2025
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-6.12.41-rc1+ 
root=UUID=3842ebdd-e37f-4e4e-afd4-d7eb79b41984 ro quiet intel_iommu=on iommu=pt 
vfio-pci.ids=10de:1201,10de:0e0c
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Hygon HygonGenuine
[    0.000000]   Centaur CentaurHauls
[    0.000000]   zhaoxin   Shanghai
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000096fff] usable



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
