Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63AF47080E
	for <patches@lists.linux.dev>; Sun,  1 Mar 2026 00:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772324306; cv=none; b=aKHNTAd47IJMA6olV4PxutFn+TfmGfeS+E09NouSWJ4SCIaEzk5fvHbFcxgISj51ohqljcnMsdnII/kLTtRRDQMBHFQadMouFbxVOD8eQ7+DIS1NV859dMvUlRdpndZ7PM6PEv1HI14bwXxG599vN9Y3Kju/FWtkIm4hhAEZhfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772324306; c=relaxed/simple;
	bh=Tej4BScblLRTyLzWX7iaHyREqAFL/TqNjNa0l+wUk1Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=srTaFk7mqlT1T5+8x/7bSL9U7TEM84h4X41/IsHuRpOPJZ2+4gh/ma4kl/7niPH9G0F6Y3ZLIT0UPeAkYqalC39y212KMqUvowxRo7Ypw83ZWLqPNFOBjvMJhREt0G/sptGxHHBCNbmILG8ii5fUwL5pIC3B6E+09e/JN+k6Ir4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=e+4GedSY; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="e+4GedSY"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-483a233819aso31561785e9.3
        for <patches@lists.linux.dev>; Sat, 28 Feb 2026 16:18:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1772324304; x=1772929104; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MHE2ewhG8k54UEMPAi52HxzyK7PCP25Pin0r4ScsA5I=;
        b=e+4GedSYf5xZLe90B7C999QPbyl4iidxIeDrgtWHtRB/Gr/WRMXSQZOe+drWpbvKlH
         KBk0Dmnr1NKMTKJitEAaRekHWoPYSAE/gwtrqjgBXG9vjCypTZBJQ7x3lI+4vooTEcZ8
         aydpoq1OfMv9M2O4RPIbxvtsfA4SkX/DJeJ+HbOfarGsObxFEwroyRIawXvtUiojk6LB
         sHIc7MgqKIFVgUrh5hQ28u69cxDc2Puw1iaDUFMT05Kv+Wa4SiPaEngYZWIhHJCJdI6U
         vRx9D3fKIodOTgQvJZy21Wx5j5zzSRk5vgDPquHFN/JS5n/H34uEoEFMs+1lDJFyN763
         Y96A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772324304; x=1772929104;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MHE2ewhG8k54UEMPAi52HxzyK7PCP25Pin0r4ScsA5I=;
        b=kPRv6YiXUDkzqoxw2S4trqJYKE1jtlivh6hj4birkfIAzMIeopq/TWRUiSO+acoCha
         anf68jdFGBH6VSUGfagEcrCgQ9FWFZl8lYNIuW4/hjseLy34VDv4qnvQmyCqDaSkeVBr
         9C0XC8ArYB0hwAow51uE2aWumYlnYE4MORelTqpOTnPDu8MB+MjAnTzXmkWWFLExuU80
         uQTGLbrcoIyUpaVBGP9k6pEiPHsDTDKFQm8daPY8SBljbfwmFMk8K3Fj8zgTrBGYFOQN
         7Q8BtVdnOJO863W9TGrlQ/CZDIrjpc1o+yDYjNqQwmYdh3tcCAUVgnAMH0J9RtJmQh+H
         JwJg==
X-Forwarded-Encrypted: i=1; AJvYcCXfKjhqgXcSw462JG24hKpGnV2+8zABEivAZj0celUaogDdmP4Ciz6nRK77KCdEo3RuOkF0KIix@lists.linux.dev
X-Gm-Message-State: AOJu0Yzzrl5AnVmByjbZJC0FMpLJOASpVIeRR1klBg1qIXzV39wVziXu
	pB3GBrqj4hfE+KUIKNU1I0ZZR+0/9DN6ezPka/yoqb8wYxl97tJDOww=
X-Gm-Gg: ATEYQzwm42Jzb3GGQ/CEk7XKFyN7WtuFYPVgK99CvHly9kp4saAdHq6OAU+rfs/nbfz
	yUpaV4r37Gzcrjgt+exB1W+o1jUm1/6ubzQXWXxdCa4e6rjOVlMsaXNVwV+ymyR5MaokcXSgm56
	X57G/0uZ1AHQmm7Yt2yWkdkM2A0RjKu1Xmcx0MVv7/RfwG0wJ8rIuhV5xWbpJOmvG1J0fl6+7y+
	+CZ5cKDhJWANygi666In/iD7jtfsWFATdoLYnxfS+cG92+lDLQoog3Q5b7YUFUmlhwThcB1eE20
	IdDmS/+T3jyqbpyU17zeE1UAapmFGQtxuWYbTI50lDE47nqjkESOpB3+ZqMQff1v21XNPEhvtdD
	wTkCJ4ysYqmVr7WC1aA/5fZzT3jrYKincOgazfWhP1ZgZaW1yJF+vXRru+nOa0My8zLAWbZPNVA
	K9mHqh9Yj3HecFY1IwUFstBjdPWq0fmRM2GmQR/NKLaiqF/aRBIn3W0+o1mSjtPrtvcsoP3Ao6e
	pPNRi4Px7VCYN8=
X-Received: by 2002:a05:600c:46c4:b0:483:8e43:6dce with SMTP id 5b1f17b1804b1-483c9c2143emr122483575e9.29.1772324303505;
        Sat, 28 Feb 2026 16:18:23 -0800 (PST)
Received: from [192.168.1.3] (p5b2acadf.dip0.t-ipconnect.de. [91.42.202.223])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483c3b3d24dsm165085355e9.5.2026.02.28.16.18.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Feb 2026 16:18:22 -0800 (PST)
Message-ID: <f78a20c5-11b6-4f33-b97c-8ecd0fc8e689@googlemail.com>
Date: Sun, 1 Mar 2026 01:18:17 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/232] 6.1.165-rc1 review
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260228181119.1592516-1-sashal@kernel.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260228181119.1592516-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 28.02.2026 um 19:11 schrieb Sasha Levin:
> 
> This is the start of the stable review cycle for the 6.1.165 release.
> There are 232 patches in this series, all will be posted as a response
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
