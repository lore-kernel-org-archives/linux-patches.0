Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B487D272
	for <patches@lists.linux.dev>; Sat, 15 Jun 2024 01:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718416749; cv=none; b=KXlsW/b4wrVrXVzyD+3JwWU0CYdWr3LP4qy8z5brIDHMGRe2c1xLi09QduhRtGNZJ2uCxJ/ErQ2pzFckEwTW4CN87WTv7liCREhCV3AW/bAplpw67bEkm4E2AtodI2J6cs/HiDt47quGSzO5lr65z5x34Dhnw87+5lJTqIJT/HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718416749; c=relaxed/simple;
	bh=ww37zaOiEY4YoIR9AYfLzK6DHmdS62JS+qyuTD4w/uY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LPiiz8H/iEp6kzK4C3iYPSFrcCJBOYV7a/0Hlp7KeW7YvrQpxQcq2tX2FPJBuGRw4ko/s7aDwc8cP8ecmuUYTxlnJtibWaqHHwbpADt+sx13tBozn79vWKxCKPibQDhm4aVSJarHYPbrGLKBURutCp5OXswjRwoE6uKfIp9De0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=B5N+IOQs; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="B5N+IOQs"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-57c923e03caso3068328a12.3
        for <patches@lists.linux.dev>; Fri, 14 Jun 2024 18:59:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1718416746; x=1719021546; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SnBuema51sIsa2QQpd+nX2kLoAJ6QBxAxGuxApnIuVQ=;
        b=B5N+IOQsCHGP7XeMLRg3qsmZcNsJFcnighVGTy4ajxbsuEdznDG/2IfsHQBPwg5Svx
         sXM536kUWMs9vEft3vED6EEYdkKBveSQnxm5jjQT7RGcuQyG5b/vIxyi3V0BP/9MnCnZ
         WVSSJe3HeQH1N1VqF1mg9EmkEmF3lgjp5gbuc3VN2kg3O2aaERnrfkg1jTU2Tv8jDQtp
         hY988IaZNY7wnOZc/6KF175tRuZa2L9KWBZUSRb4IK2adRx5KVrRI1smEs0iM6hbnIIa
         PvxYi0m9g9z0np1UIi5i7/FunvH89sVyyS6vZ2oIzeTBQKSjU7q1stXnPXU41HMUHDcs
         h+zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718416746; x=1719021546;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SnBuema51sIsa2QQpd+nX2kLoAJ6QBxAxGuxApnIuVQ=;
        b=GSuva1/hcMc3TKHf/56t2FFr09TsrSWROt6cCHO5l2Sal1yOlhO2U8rZpuvAWDDksr
         Nwft6PvoGQLiunOI3dOE5RJmxSeZTQJP/GUtscSCUwdN5yL2ujvRsF6CdKAXNrdN7PRJ
         WMROi/pn/qNr6bG4ruzJBqwzlES5ivvWM3lCL+lAlnZW19r8a9n6WGaL3RSzbX+1IH6A
         nckQmqzTLfTRDkaJl5tpHKFPsJuoFm26a/hvWNOTQ0wuRlcpZ/btBjkNxyiWlxvUbjOf
         ooGoDxepq35JlMk0yZEsUxGMczD2oFnLPz0zvahlg4fvu841fUqAWG1XIT5a7cHyoSLb
         hQdw==
X-Gm-Message-State: AOJu0YznMKtTi2WvUdkWgzN+5AvSKUCEqekadGFFr2tkD8gmY+TMuGEH
	I2OATSneZe9PwH907SVFG1ANbDCuBeWuSprsnJCMv9uMQPJg0AM=
X-Google-Smtp-Source: AGHT+IGqfx4zl8pmHjaMX8jFrVGJShYsFAvAovN1qGxCuTlQKDG9mo2UcglhTiQR7gmxLmyHs31J0w==
X-Received: by 2002:a50:bb64:0:b0:57a:2ea0:406d with SMTP id 4fb4d7f45d1cf-57cbd652479mr2588820a12.8.1718416746031;
        Fri, 14 Jun 2024 18:59:06 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4225.dip0.t-ipconnect.de. [91.43.66.37])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57cb741e70dsm2924217a12.62.2024.06.14.18.59.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jun 2024 18:59:05 -0700 (PDT)
Message-ID: <d8e7a445-5918-4049-ac39-ad222536ca6b@googlemail.com>
Date: Sat, 15 Jun 2024 03:59:04 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.9 000/157] 6.9.5-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240613113227.389465891@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 13.06.2024 um 13:32 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.9.5 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works fine w/o regressions on 2-socket Ivy Bridge Xeon E5-2697 v2. 
Everything looking good. Except from simply firing up 12 VMs, I have not done any serious 
load testing this time though.

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
