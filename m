Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1115D166F23
	for <patches@lists.linux.dev>; Fri, 27 Sep 2024 17:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727457166; cv=none; b=eAW9BySWrmKQ4H1tuZy4MAkVUeIg05Ff+oJtRJ+BDWrmEjoKVHbN07Ixt01Ht2LqoIrVAjIicoKpebvdYJpxoBUFD2ihDj0rFxqgPCaOFVBNc8+QHj6uA6+Z6q1vp9lVyrhWipPCQCvaUfw/9ILqORT5G0m1DwwB1/XBEOKP8X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727457166; c=relaxed/simple;
	bh=/jjF3BNyT2uuFsUCZVq5e8/Ab2HvHiL2Vr+6m81Zjj0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fBxvQRd8BjhBclVkj42DwH4fNor11LgzCiCAOcC486JbAD5gieiCXAcgrIbzUWSStIK/kpKcdsBF/lXlzQ9S/a/itPJn9gvc3YY3anB1I7j6kNnq+A8zWq/DsZeYXIvwkONRQeX3JzEYc8PelAnwGbieDSZbmG/wilGnW849rH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=SRI+wvJ/; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="SRI+wvJ/"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-42cb2191107so20197845e9.1
        for <patches@lists.linux.dev>; Fri, 27 Sep 2024 10:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1727457163; x=1728061963; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gmLqxkFKdXtbMxAbTeqAObhI7W65HYdB4Pl+s1JbGNg=;
        b=SRI+wvJ/0tfwcggBpaz69T39r+GUnZOEtWaE1W7ZFiB4taLDIzFs6gQqcvX5zMkHFY
         aLSlRYswxltVCryKA9m4L6QLbAQ1QIIy/ggno9zwkpH9BReO4o8j3uY3d8sLMxxy+MUR
         w1Q/05z9ctgiN5bVQ5sPg7VLy/mbEl7FVXaWPglQoX+Iy3oxufL2oBJDA4CBI1hK4AqB
         6V4IGHw3M+y62+LssoBAb48uazut8omRe9tbbI6AIxBNPZ76JSCcYqzYdHIcQq6iK7bs
         0sBWxYxEsl57Q1f34qXRSCVOlBLp2de9ZJOoz8EeWTGQfBCI056oa9H2dfIbsn4TOY3p
         euyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727457163; x=1728061963;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gmLqxkFKdXtbMxAbTeqAObhI7W65HYdB4Pl+s1JbGNg=;
        b=aKSb5B00z37iPpSlitQIwM6vNSuoNTVhWC/lNBGPNjyCWSXSLxxO+Kr22RJdG6FJJG
         ODejaGo428RK1YSk/MpsMnqlsACOOSV+uivFZ7qTEdCkDi/AuXNIwN5ajPJdBhq24UbI
         6jAypHYFqTVepQGlGAwVYzlC8Cdo1Elx6o/ccZulsJBzaRygKhYUNeUkOnz5/hs43gXA
         oOCo2UNQiaXVhgcMuMjtzcht3u5l8IgAf1RtN9n6YP8EQ3I5G+NEU5irBwEgyHgRr8Iy
         WJhr9+aqq5Z+cXXsPi/+kkqCJvTG2aR4YpXLuG6M7AvFuspdPEuPcZnnzss+F2JFEe+M
         m7gA==
X-Gm-Message-State: AOJu0YyoAC6utzkF6uLKQRqBOmNtFrIbGwoWK9cbw7O+AxFu8WzplO9Z
	eSzATbpxQJYsvUleoOi24wybHySYbsklefZ5v+o8xuu0JFW4piI=
X-Google-Smtp-Source: AGHT+IGgONjs1Ft/KCGwrReAJ25RRuTr1ppc2rdphHCJBObHfx99PM/ELeo2lNAWuDX3fj8o1zzpzQ==
X-Received: by 2002:a05:600c:4511:b0:428:1608:831e with SMTP id 5b1f17b1804b1-42f584870f4mr32751095e9.22.1727457163037;
        Fri, 27 Sep 2024 10:12:43 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4a79.dip0.t-ipconnect.de. [91.43.74.121])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37cd56e6875sm3015245f8f.55.2024.09.27.10.12.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Sep 2024 10:12:42 -0700 (PDT)
Message-ID: <3f481ef8-2c82-4f8d-9e5e-223be478a183@googlemail.com>
Date: Fri, 27 Sep 2024 19:12:41 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.10 00/58] 6.10.12-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240927121718.789211866@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240927121718.789211866@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 27.09.2024 um 14:23 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.10.12 release.
> There are 58 patches in this series, all will be posted as a response
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
