Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51DB23F277
	for <patches@lists.linux.dev>; Tue,  8 Apr 2025 19:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744141401; cv=none; b=tuMGcJyHQPxmE8f0DdFKHqivMyqAfjP3aex6SxMhnhn6KITcPSq//qW1572fWeVOEx52a3GhImumMZBRQcd6HWAO4u/L7ygaH1qZNQ9YoMT+5mKVlOWj/3e4ZfMAb6CzRoLvk614Oa3zWO5fA2I+cpe/dBnhPdLS0THTJCjPbbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744141401; c=relaxed/simple;
	bh=yV15HTrE/vKKBCW27J0iRu2xsmctgldlTygl0Il5Tic=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y3uOX1t8redY9QmqUl1FotlIiDx+9jO0GSZQUu2XDgK84cGv3QrU7ttWSIaS9yoV2rlLTruhkzMUGfjBE4V2FsvoNHgk5Ub+a6ygl/eUb4TORQYpMO9b1OVWxozFnJj+Y9kzwEXYckt57Hyo9ODE/hFg95wKy5GHjlnRnLCyygU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=eB0K3+pB; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="eB0K3+pB"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3912d2c89ecso5267409f8f.2
        for <patches@lists.linux.dev>; Tue, 08 Apr 2025 12:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1744141395; x=1744746195; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hhaVg/u+b5SbQYX4VE9hUR0TbRx0qr+d12G30wYA5Vw=;
        b=eB0K3+pB0EnO/tx5xsM//bla/HcJV/EgaSCn/d9DDIzG22H2xUHhlFlvOJlzA4rDwt
         pbWO/RixFj5IUJBkEp/STXuzeHfPZlE1ZRVTLiyeG8rP3ghB8tPSAi7yMDd/8I9tY/XY
         ZUtCs/X5SkPJ5227YCEzUUrFsnoLif6H/LuV7kc4y0Jt17eVgie7EO/oHxau4EXp0QTS
         vB8b70D2c+/1XdWOoqSyHZy85cdYHztPW0W7+/+crEui8w5ZS4GXtRyUtD5TgXevr+zF
         hT2KpCEcWAzd8n+oKjk4yuKBEitAAC+5BE8riXv6GyhS4X6eE/vu0ItC3PPszoqyTRzA
         M0RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744141395; x=1744746195;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hhaVg/u+b5SbQYX4VE9hUR0TbRx0qr+d12G30wYA5Vw=;
        b=LOtwQQmwwseytc2/IwkyFf0eDzK1+dB8tiY/i4NI6Hh69DJyrB3KzpOu+PqX6OfyuS
         ddpHRTRtcxGITvdd34U/bCDSVe66UdKMu/VdZZbHZoC5zisr5fPKzutHoskOmu8v7/dl
         TgC3BVNpNNs7CcKq1npXaMteVX5BsOdfJXaYgMr841wTF1TZ1tv/ZN2QKDWq7tvysDl9
         jlhm4pkKb5Id20ijV+Xu0polOqWkK04E1yfTUDffqBairaqrW49OFZeahe9p4POBlOJK
         Oj/Jal2Jj/TaCs5IVXUvrK2349yRUmBjoMjFsDOKNa9aUe+V3uXpy7leN093R8ybRG7H
         0VXg==
X-Gm-Message-State: AOJu0Yzo+RcIiPTOyz+eiv1Yz8WuAxWvlGsB57tIDKg37958ZpGU0baK
	Hd483MmYM/tzriVey4x1RhOHt4xV64iybQ05l8GMig9JDhVes2I=
X-Gm-Gg: ASbGnct1aZfXF5GqXqxYqeCg0pOXjMOqTlK+s/xxzXGfMcx/NkwkPHO8spmufG8hN+S
	iCAYecSEIXHzI1a3sSS2IlkLcokXN7Xr84LlfnqMOfFCjGwxSwu8qHBllEc+Cq/dA9NRi9PSMEi
	O79Z8BG2oESTIvLKDTWPkbcFUmFAeaMleSUbNqzEfR5pnHMZIqsM0bqnv4s/kiPqdStQG+bXsyF
	FvZiNYWXg9uqs3Mf78rOOqoC15gHehus+QnTMvZLl4kVW/Ob3PnVsXcLbwYOdm+oqxAiLQddJv4
	cyBGEY/XUdcXXfhjgC9J8P7G+JL/oC5HtbAVtBLu0PhJeAquqYjiggk5Y65MwaNcqQgEhQzd8B/
	1P6p5L+PSuWlTiJGJ5mkLiQ==
X-Google-Smtp-Source: AGHT+IFC4RLdzeq9tc5tRagXQaUbTZ7xImbPKse7l+EXFdAMRZ4Lk6cqBp9PptCPSsId7erm159yIw==
X-Received: by 2002:a05:6000:228a:b0:391:4bcb:828f with SMTP id ffacd0b85a97d-39d87aa7b53mr401576f8f.14.1744141394866;
        Tue, 08 Apr 2025 12:43:14 -0700 (PDT)
Received: from [192.168.1.3] (p5b057de8.dip0.t-ipconnect.de. [91.5.125.232])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c301b6321sm15491218f8f.44.2025.04.08.12.43.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Apr 2025 12:43:14 -0700 (PDT)
Message-ID: <1f2803ac-3e1f-4605-89e6-fa5b9504f470@googlemail.com>
Date: Tue, 8 Apr 2025 21:43:13 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.13 000/500] 6.13.11-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250408154123.083425991@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250408154123.083425991@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 08.04.2025 um 17:54 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.13.11 release.
> There are 500 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

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
