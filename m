Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90952206F35
	for <patches@lists.linux.dev>; Fri, 21 Feb 2025 11:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740135867; cv=none; b=GCVBhExU61eQPLjNKPquSGKTOJUuzYjp+tphrAKMh+ZnpSYGoCE+g6Pw50d6xPkAci57FgVoyZq+VjdHSAZQvuPTMBgC3UB84nVKGgtd4LRhNd5+hSIMD9pi7W9zJif78cQJwoMtWm6t4SeTwU3+8UK8pnceWJTdyCwFDdpzL3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740135867; c=relaxed/simple;
	bh=BxAf41+oMViMRHa0fuPqM32XRr5xamZXfCW+aloR844=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z/BmF86GlbZXMc8Fu4xvbltNarVeKW2oLbGCao3NPVlTVRnuHCRAuUGXB8y7xZwCigZgIMbQ2IBhYUBrtTg4NiRT8PrOUhSE8fSBjW1TonxAVlc+AWLJ1r2fSn7j09YmAO+rvHbKf3FAJc18ILAuI5xrZP93DW8uJCi/04iF1VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=W11R7tx2; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="W11R7tx2"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-439a1e8ba83so18903795e9.3
        for <patches@lists.linux.dev>; Fri, 21 Feb 2025 03:04:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1740135864; x=1740740664; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oSilo/wdscUK3kV8MsIT8Y7RL+OEB64ml/2oWr697Z8=;
        b=W11R7tx24D7/I7Sybqd5d5YKYIR0VReQCia2l/sz8UMWseEbN2arWkf/EX/JkDanAh
         c45IuB2P71IUiBLnZO1ijSqajrAvpNiALmeuyqGZhXdDL+pCbosKJkkGYrMDFYBw6xp8
         t1EHG52oZoDwM4VfTCVbhZr2k7Kcd3krSCPWoZXnUHWT3KwVM+dg4U/taOg+OIYDDi8a
         xWfuwArlO0elRoL0nsQ4SwaAkRrUuU/E93UJ04aEFRxoliAjYPgt6WCis2osXVjw+IaY
         qZSME4OOS5V10OBFfSeWEEQlhQ6qdUmkk2bsZRWnNJO79NJXPv0KIIqCWadZX83oVzp8
         7U6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740135864; x=1740740664;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oSilo/wdscUK3kV8MsIT8Y7RL+OEB64ml/2oWr697Z8=;
        b=mcI01PIY0ml3DJRZgKEICHiUKtdD4CqpRo8RrCF6FUA32HORrCylKUAnUooRt4I0cF
         wX8OEf0zaQBXdMaEYtp0aNLChMXJLFx1YktwWMeqEzLlavJO0URCvhoMPs0PLZXUzNX1
         fuWzLqdpvturxFFCK3ocpaacV4Hjv2mSIZDO0AOKh0xfoXHWe9Gclbjtr7YIDEK1WtMv
         iNt1sEIjXhzYafKMViUoJP3XXojHfTMAewfnx2u30FFIIPQ0RqQaIUWQl/g8G2MZSno6
         tkGKvrytYVqmIW1bnnhc0xouLuRIrvRurVFMB/kyD8p949haw8g715Hewq0bJX44pm2V
         PYpg==
X-Gm-Message-State: AOJu0YzokFXl9x59PVl76rbw1ndobjZNMW6DqNttt+scjVEeNOJIWtz7
	XUz4lJIKmFo+6cuJxrZIKDB+FKpIytL5cVi3pir7WupKfOzl5Is=
X-Gm-Gg: ASbGncsLaqcibSJRydA1yQXdpzix0h/4ZKMzwFdf7gTbtu3K0sDbG6aiZq/9W3tBPzg
	FDzYyn70qzrtH+jgSzqJwEsjE928jW6AQA8EA6MSwdv0gefUvi6BQcmc31LmUB2tlsDKbml2J1Y
	bkv3JCsjFFuVTkmp6w5/snXGvruL8qNFVEOxl7+avB143nyDgEdouwrZOdNXdO05B06nLrLZhFk
	8+9VEZasyBOi7ewzGnKjbgcWmKwYkM3vfGCz4xlnOZnNXU5JnFvALJJ3izHce5MVIDYkE+PZeMy
	k1kOWFNQKSG/lWLU7REICrMoxlPAqBx+VMGmRZPwMsct1sB3An0c84KVwmRFLBvPHlGnHWOF71V
	fNoo=
X-Google-Smtp-Source: AGHT+IGhDg9gKTPce4JVE2GBV+POBxVmROByI8CH4RKxLnv2pIiFDXeep3kM7yKxGhiLRmGUNjIHpA==
X-Received: by 2002:a5d:64e6:0:b0:385:f6b9:e762 with SMTP id ffacd0b85a97d-38f70825ff6mr1942837f8f.36.1740135863548;
        Fri, 21 Feb 2025 03:04:23 -0800 (PST)
Received: from [192.168.1.3] (p5b2b437f.dip0.t-ipconnect.de. [91.43.67.127])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f25915785sm23758697f8f.58.2025.02.21.03.04.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2025 03:04:22 -0800 (PST)
Message-ID: <702f4288-6afa-4c8a-9095-fda1a476afec@googlemail.com>
Date: Fri, 21 Feb 2025 12:04:21 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/569] 6.1.129-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250220104545.805660879@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250220104545.805660879@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 20.02.2025 um 11:57 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.129 release.
> There are 569 patches in this series, all will be posted as a response
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
