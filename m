Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F9BA15A8
	for <patches@lists.linux.dev>; Fri, 27 Sep 2024 17:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727459177; cv=none; b=PPl6J0O1DKIx302E6jhFzmDqfnCKISn8u/RBVAj8/+Si3SU2dttTAOsT0DMYz4icQjw7nqO2VFaM7NNywoMNvuacC+dcep3hLAQUp2Df1WPoHk5n9obFarKemUTXbYQ8luavppIpFyZN8a4PS4k9vc0+z4PJEE4qeYxrSlpFtQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727459177; c=relaxed/simple;
	bh=pXke/yWzF+iJL2atwV88Fvb+TbniXvK2xmpVa+iqKiQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p4n6WWZVRZ7Wjp3tYAF5+SXcElwkSJIwT8sube0LLy2bhti7AmkyYwTAvzkVqdNCtZMobChcN0l5P2NBYsQ3ec0k/i/c4zWQptCSub7XAQKAdwD0Zgy+TIBYJ9SHqFMQzDQy0Vqt1CZ3tzTMg7Bz49Se1HN15IEgUh6hW4+BIYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=gB6IOTuZ; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="gB6IOTuZ"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-42e7b7bef42so20364055e9.3
        for <patches@lists.linux.dev>; Fri, 27 Sep 2024 10:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1727459174; x=1728063974; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3wD0JXAsG8Ubog6V1ie1Srm+ox3RskQ7wPF8YhVJa+c=;
        b=gB6IOTuZvl+JuDgMP9vIYopOMfB60UHtIS1CEAdIOIxxrai8XKDoldbbomMCZEpncz
         C0kgNd/A5/cAJwe2r609SDkOzbGpP5ah0+X3jvcmhQZsFfYCaxXz7dxmE7vOu+/6uwzw
         KGTBZDTWMvcdUdAFB7T2sxBzAyplLJTBA64Df40y+7OkqXKuJXbNLUUo4VU7imHsdxri
         Fm3i0fsOKFMLbGWIbBFEROjcPr745fW4S/zMXeoNAxwzgrQhmthvMLj5+x2qKYP+3/uR
         aiHbwJnaxO87ZheqQyt9ftyXQEa1WY/SVYxrD6PvbfRTrK56WLGuxAvGY3G364+pugzy
         15Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727459174; x=1728063974;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3wD0JXAsG8Ubog6V1ie1Srm+ox3RskQ7wPF8YhVJa+c=;
        b=EJo24+PGnQp1uuDruHVM4l5D01S0UFZ9v3eEQVDeB2DfZ1YKi2KqSB33uxDOKtqE7r
         DbB5+//3DY0I2SEHnA+QsYiNWhT5cB8eBP7L4dI/mSa41ZSwn+NKVW0KNbzTsC0j/meC
         sIzARwd8eetPq/lkIQcuq5GGfOTvfmMd2n3q9IRteXN/IXmPpuWmFfg0CiPx9F28Q1sb
         HsCP1XXw2z3LdmQ+Ch0t5kJBwApKho+Peri4pYYrB+/mDl9kGS336X/L+zus0f0r0Dm5
         aSBPFKB1dGYPvpC+n7DImfiRFmEOMKQ3X01Oek9c2grAkMrJ0bS2WlXPuW2/L6rTq4Gg
         N4VQ==
X-Gm-Message-State: AOJu0Yz0ET54Oct4xlBldKcLE8erm9R0edhiDYnrxrGrNPaIhO6WcoH8
	GqOBOlTXPsiS8eRilPTCo50bBwkZipxuEwJ0RX3uy9qPGcU+GYLGqvFrucM=
X-Google-Smtp-Source: AGHT+IG+qzHQSB19j5/MztmCoLU8f4n03yN+xoDvvFyMvuaBjGnJfLXyLv6BjpOLkikweamwi1uhcQ==
X-Received: by 2002:a7b:ce8d:0:b0:42c:a8cb:6a96 with SMTP id 5b1f17b1804b1-42f5849939fmr32498185e9.31.1727459174318;
        Fri, 27 Sep 2024 10:46:14 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4a79.dip0.t-ipconnect.de. [91.43.74.121])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42f57de120esm32907965e9.17.2024.09.27.10.46.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Sep 2024 10:46:12 -0700 (PDT)
Message-ID: <933ff11d-1475-42e6-a7b7-799510df5743@googlemail.com>
Date: Fri, 27 Sep 2024 19:46:10 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.11 00/12] 6.11.1-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240927121715.213013166@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240927121715.213013166@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 27.09.2024 um 14:24 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.11.1 release.
> There are 12 patches in this series, all will be posted as a response
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
