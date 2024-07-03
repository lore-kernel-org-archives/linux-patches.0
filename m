Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D34317B407
	for <patches@lists.linux.dev>; Wed,  3 Jul 2024 16:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720025689; cv=none; b=UvWNIsQ70HfYuWD/9EDjVzyfgxInsUyAE225+AH8T6QkoDclUGLxKViLL2J7iqmB/c0kkriKbC38JFHIcidsidE4lsCMpy6GZWkWc8bMU8Uk+haE7JLKIE3D965WpNh+wTw8+bQGkuqiIFQsIUF+NdNpH74iq/xY4twtAPJIKLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720025689; c=relaxed/simple;
	bh=Sv84Cuh4iseHWvlXvXyU8mQ30EZU4NbMB5oqIqEBxis=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sQe/JVR5ItG0Rx4oxRd3w1/yPmz5Rk+iivQQllZNXXdB2myW4hL68V3vj2VEeOJrHQ1MgTlp8yeTdIE+7lB1+KotqP0JM5C85ht0c78r1PxJguF/9Ft0fURuO1xnxIv/icBctn+RNu6QsFMaRvGrcoWy9msy9ihis3wDtwYXM9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=Kt3PYvQ2; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="Kt3PYvQ2"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-58c947a6692so1835133a12.0
        for <patches@lists.linux.dev>; Wed, 03 Jul 2024 09:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1720025687; x=1720630487; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u3JMF8+gV4sO0O/ZbwGbcfKFD+3y2b4tBzO+SesbF9Q=;
        b=Kt3PYvQ2/Hp7jWXJ44k06Om58NbyzeFqPRjtDqdL+H+B+y09miQiUIVWTpligqzbuH
         66Y4+avoflsTTtqpmsfoCD17p/VIGgGlhBoFJUP9JlLYcv7S6wBk1UkMYJx98+D5HyKV
         8s695BLxoNLWRXUoaRhLqznb63lBIfXj/GzwX27KbqvDxPEid+fgieru1z+6vUbSBNWf
         TrYeanEl/snJdRfG0qh7YnV5iRkMvk82VrG8NHvaiB8b+PuAlr1Jem1yXXNpeP7DS3MH
         +/S2G/msxC2at8xMbRE7Oel7HEAirV5+jBr1uypjBUPvxqal/pSAMieGU3PLrR1n1DxB
         XMcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720025687; x=1720630487;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u3JMF8+gV4sO0O/ZbwGbcfKFD+3y2b4tBzO+SesbF9Q=;
        b=wXNgsk7ssxup9QFhBqK8zWNZ+TpzmLSROs0ktm4+2TeXYGx30BRluuhkMS6JHKwZI4
         klGPr+qFyjpRFGo4KSsVXl0REsD8YcSAuHN8O+JoGFIrs7+x41EAfKOyqnKhRX9ZI7+c
         DwwXXDlxXKgRyTpWLo+S/AoQ7pCik1LnSisAqjllO74YY92iSCnAhIFm+UAuOHtzX4Pe
         tJz/RK5Ue6s98ev/ttsMXQqmpb3+GpBUyPSFrkoyJYJYjmPApomq2UZh5bxnPBOB4TPj
         U4wy94TgVpcR+venjKLEYJYAX/Wuh7KVdRX1XBMKHZbFXEPxVqFzeyfQn0DuHWDg2S7B
         EP/w==
X-Gm-Message-State: AOJu0YxDx+Ws6baF+vQC8R2J9hYLSFq4Pv7OBWuo92I+ribPf0VfbU1z
	sVOq+XNfHxKdyq9QLqOKGf5s7uCx5Tr7E0zQzqX4Glsm+bg0riA=
X-Google-Smtp-Source: AGHT+IHIiXhPICKwjl3o4henIEjmhYAWXRonYHY6ZF5viha+yKcuyNtQq7gnd7JK/2RBEOT4sLI5Ag==
X-Received: by 2002:a05:6402:26d4:b0:585:a885:da28 with SMTP id 4fb4d7f45d1cf-5879f59bb3emr8688869a12.24.1720025686454;
        Wed, 03 Jul 2024 09:54:46 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4597.dip0.t-ipconnect.de. [91.43.69.151])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-58dd6f1fb85sm152465a12.77.2024.07.03.09.54.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jul 2024 09:54:45 -0700 (PDT)
Message-ID: <53f16c23-c6bb-4b17-a254-9c8b73109c2b@googlemail.com>
Date: Wed, 3 Jul 2024 18:54:44 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.9 000/222] 6.9.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240702170243.963426416@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 02.07.2024 um 19:00 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.9.8 release.
> There are 222 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

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
