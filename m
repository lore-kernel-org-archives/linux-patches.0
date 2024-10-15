Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EABB61714CD
	for <patches@lists.linux.dev>; Tue, 15 Oct 2024 04:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728966153; cv=none; b=Ivu3r70poguD6vra0seuyH7yZcI9r3130fjVK/fWxNleUGGhE9jZ0mNaivEclG3euD0u/VIEW3jIp6s7E3lY0473zdnWzpUzZbjFl1DM6X+6eXM+YNRZMTLOkGLNkAdiVbZmUUIY2uAZEGaxbErRGzYgSkccBAW2ga5QrdsEaA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728966153; c=relaxed/simple;
	bh=61KFHvrvvfdW/zqcDP4tjMM0jeXhHyPuStkPQ6pN79I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WvGgqDfn2N5FYg9FS3JKiaA32kro244rWtpO13vDQQqD5miVkeEB6u66Y8buvvP/HYpccu3NsBztzWZ3qYqqV2hnywf6bhptdyOlB7KuAiXmys7o4tn7UFza8uo5fD4Nhu1tPxYpa+DEOy0M6X0JS7wig0HEAcbg8JNTU5vT6nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=POKS6Ip9; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="POKS6Ip9"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-431286f50e1so30118275e9.0
        for <patches@lists.linux.dev>; Mon, 14 Oct 2024 21:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1728966150; x=1729570950; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ITw4CfbIcKJl5WiKfCPeay4AHZuW/oKHqtGIMSVy204=;
        b=POKS6Ip9gJ+I8rPjHWuRQqXDIjQpGUjBfGHz/If+HVXSWAZX+8IIhfA7nmdB59EILB
         bweCUwX5qyoZ1ILS5t4/BNuf3VUQuM5d+KNrhNsvQAaMxyZ4WVLfKhu4uJ7kMmVd+w4C
         cI+tir81/A6hSfYMcBRQT1drDHIKdwEz+gySFR2nHyMSVCo5RtSto+zihvAlw0jbn4yD
         6fwjGzVLbZpok7aIJ7+6fcU/2pa6jMDwV5VO75AQi0psOm5gCYMPQKxElJE85SMeqE9Y
         bt2PlVJoPwC/MDRubfTIIYXoXkEzy+VUhf5tdChbJkCCz/xtbaqLUHPMTiwDI2Rf7ks6
         BxkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728966150; x=1729570950;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ITw4CfbIcKJl5WiKfCPeay4AHZuW/oKHqtGIMSVy204=;
        b=KJoXlfkE6QUxuqtrgYMEkDyIX0vQlyA7irs8d0VGvrO1afTU43EEW9slAHOW7rsGQp
         YQ5yJg1hku+Vbh3WUZP3fi6C1TaukAn581MZDRrMc5RYiRy0rDLOls8Wg5gp9yXJ3pkG
         QPbiqO+mRj2GAwZGRyDBqIlp0UDiqdacDT7cKnvxgtiz1ZPOjlAQPofPTUbGnzW9v+Tk
         AyLiT45Am2PuzbD6zAhXVd0GVt6Mi3D7AdaVWpKYZx4bK6lhDwn1YI8oddTTkYFj9TSM
         fRiE+IblJWOUPQXcx+XwzmHyfkYIthkwhySaQQf81+SF50Wq7z3/sHhUnp8DyHsXOfKk
         8h8w==
X-Gm-Message-State: AOJu0YyWVEaiXZYGLtklRfAN+mkKyfEyj8dPvXt24RzDsuSXzwDnqciX
	QDo/5qQ0NaHa75yBb4m1MWHViiVBVwow4gPtPbQimlfU2181J+k=
X-Google-Smtp-Source: AGHT+IEBV+mIguXbxqTL842Ev83rmJsOnrUq23Q4t56ITsC8zwy3n83uQmYy1f+nZWdQZj41O3ZG0A==
X-Received: by 2002:a05:600c:3b8e:b0:431:24c3:dbaa with SMTP id 5b1f17b1804b1-431255cea47mr104986945e9.2.1728966150110;
        Mon, 14 Oct 2024 21:22:30 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4546.dip0.t-ipconnect.de. [91.43.69.70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4313f5698casm5533395e9.14.2024.10.14.21.22.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Oct 2024 21:22:29 -0700 (PDT)
Message-ID: <ce75d067-08ed-456d-ba57-60b7a595b7fc@googlemail.com>
Date: Tue, 15 Oct 2024 06:22:28 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/213] 6.6.57-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20241014141042.954319779@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 14.10.2024 um 16:18 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.57 release.
> There are 213 patches in this series, all will be posted as a response
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
