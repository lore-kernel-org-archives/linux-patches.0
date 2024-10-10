Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA8219C57B
	for <patches@lists.linux.dev>; Thu, 10 Oct 2024 17:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728580742; cv=none; b=OHReWQrOdRqHgbVrH1FCJgOTaaGUcuChrLKK+cw3lxIZ+0h7Pf0cqg4eqnfcipUE9YfnVKEX6TxZ2P2AY3Umel2LBgkXs8Cy4vS3XQpTszbspR0C47lqXW4uueFxP4tGZ6wJXD5vImIXr138rUALXKgkPE0KwFR39np98XyWxSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728580742; c=relaxed/simple;
	bh=7AfwBx0KrRdZE2Nc0wEtIN3SO9w69Z+D6PzQdmgv3+M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bjfkUgrDzbTaDM8M31pvOj+7kj8eQIMvL2tAxCCcPLeP09L7szEIwPuISil+N8vh4DuIcqJjw17Z6cCBwzSVp+lFBDWchFoWV0bbDq0aDq4l7KVt0OyuH82X8PBLdL4MHvnL1VVY3lvzIuQ42ntFyW7lRce623qp8pwGr3uUkWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=hO+H9pkj; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="hO+H9pkj"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-539973829e7so1244698e87.0
        for <patches@lists.linux.dev>; Thu, 10 Oct 2024 10:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1728580738; x=1729185538; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lLPtmjy9vjMWMTF2rCSUMPmTkeRCqgbGtEZX20lNPD8=;
        b=hO+H9pkjWu0omw8WDU8s8lx7YN1KWXo7BL26kMHCxtzLscrmmuUIxvW275gzYGQynw
         hTlIWbTc5P8fFL03+DSXpQI5P0DJHrwT0KpvAqgNbPWZngsayYWSmWBqkyVTOcP/BOEe
         bClD9SEUncBhgvwoGQeGVmJWRH4eyU+44+wOtf1qD3OJErPVgxhmK6lsHiRxMtnvY8RI
         VA5fuplqfEa11t67aeFJ9axuM7D9tblr/J7+Yy7giCOl7HEcnyOMe62fg7NOP1ymq6hI
         yjC7CwDjRP2NlXUVH3moLc8JEvt1ykejg3ijjyJ+xUl9WPBTUwmShH/9raYaRlLL2esM
         tjiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728580738; x=1729185538;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lLPtmjy9vjMWMTF2rCSUMPmTkeRCqgbGtEZX20lNPD8=;
        b=vR1XM3lm/NQaJkS0n3efEynI8pB/M36DY8nAbmzcDGy6b0ptz+3mBqNwISCwihi0iB
         9sMwEz3bXjYWLCiRJOqI+Gf2rXD1D1cQmiIqhosHVGTZ8+uVs9xZRIP/hVvQVy2i4ami
         z7ySHl2TXbEg2ENuzIYU88fepfcZosOYG4Iej01Hv4AqTXDa+EtM+Yhu8I7RNN0/MJYD
         gs65DCmj9zfmxiJZ5Q/iglZEhUnwGgat6lBM6kyKUHpmdHEZxrrMXLELlOgN0/G/YOJU
         2ebLCh8l4nxegItX5DEAiMebi1mdGIC5dpi3uqJTjj0/kxDnap9X/4lUHvjykLD93aDW
         +nhQ==
X-Gm-Message-State: AOJu0YyoCMo4FQEYyC64F45wedqQ6HO4uTSTLJRCggu1nR3sqx5lCzgD
	p/0IO0DzhVcPIlX9K4/37CJjtqvSDN4abHMMrIpNTjAqHSE4zY4=
X-Google-Smtp-Source: AGHT+IHo+T4k3kMGacfyrzoVyByXdkR+c37mFkM03i8sydsrFr+og0a5dbRThE5h2Au/GU8P0EJzJA==
X-Received: by 2002:a05:6512:b8a:b0:539:8fef:8a80 with SMTP id 2adb3069b0e04-539d4ce4bdfmr156101e87.52.1728580738012;
        Thu, 10 Oct 2024 10:18:58 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b485e.dip0.t-ipconnect.de. [91.43.72.94])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-430ccf51753sm53533315e9.23.2024.10.10.10.18.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Oct 2024 10:18:57 -0700 (PDT)
Message-ID: <86472ad5-6fd3-4273-be9b-e4815b54797e@googlemail.com>
Date: Thu, 10 Oct 2024 19:18:55 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.10 000/482] 6.10.14-rc1 review
To: Muhammad Usama Anjum <Usama.Anjum@collabora.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20241008115648.280954295@linuxfoundation.org>
 <05ef1fc5-6947-45f1-bf9b-879681647107@collabora.com>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <05ef1fc5-6947-45f1-bf9b-879681647107@collabora.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 10.10.2024 um 10:58 schrieb Muhammad Usama Anjum:

> Please find the KernelCI report below :-
> 
> 
> OVERVIEW
> 
>      Builds: 24 passed, 1 failed
> 
>      Boot tests: 510 passed, 0 failed
> 
>      CI systems: maestro
> 
> REVISION
> 
>      Commit
>          name:
>          hash: d44129966591836e3ff248d0af2358f1b8f7bc28
>      Checked out from
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> linux-6.10.y
> 
> 
> BUILDS
>      - i386 (defconfig+kcidebug+x86-board)
>        Build error:
> drivers/gpu/drm/amd/amdgpu/../display/dc/core/dc_state.c:219:1: error:
> the frame size of 1192 bytes is larger than 1024 bytes
> [-Werror=frame-larger-than=]
>        config:
> https://kciapistagingstorage1.file.core.windows.net/early-access/kbuild-gcc-12-x86-kcidebug-6705246a7ef7358befb78db3/.config?sv=2022-11-02&ss=f&srt=sco&sp=r&se=2024-10-17T19:19:12Z&st=2023-10-17T11:19:12Z&spr=https&sig=sLmFlvZHXRrZsSGubsDUIvTiv%2BtzgDq6vALfkrtWnv8%3D
> 
> BOOT TESTS
> 
>      No new boot failures found
> 
> Tested-by: kernelci.org bot <bot@kernelci.org>
> 
> Thanks,
> KernelCI team
> 

I do all my kernel build tests with CONFIG_WERROR=Y, and I found that due to THIS driver, 
I had to increase CONFIG_FRAME_WARN to 2048 from its default 1024 (which comes from my PVE 
oldconfig). This avoids this warning/error. However I don't know whether a driver, or any 
function, using a larger stack frame than 1024 bytes will generally be a problem.

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
