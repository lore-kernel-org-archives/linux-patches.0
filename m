Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5F315B140
	for <patches@lists.linux.dev>; Wed, 24 Jul 2024 15:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721833765; cv=none; b=FDByjW/Z8kxjs0ysYwzq4ot4njw7Lvixkyi2lG/Q9PRQvyZkI1vjtTEpBWQpJM/DDioskFG9WyZglHtG7WdeUXUrQ+ZsCZKXlAv6GeC6vOoarfeLxW0Gugf9LkcaWyg/FQ0lxgtUi9ADb4wOl72yR/cqmbb8Zc5F34n2MesC/ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721833765; c=relaxed/simple;
	bh=e+T00QYZKezNCUrQ/yC1u4Cds25lLnfftKUX6C+B4SE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T8sWpe3oJBY0oj8n3yEf41ouXL1kivX/B4rzWgLRvfu17l7eWm2dBCZ/HvHcx+GWMwghxinxKWSAg2FQmEku+IgwyAj217ykL/5BJWqfAcxb4TE+mSQcmpw2qXKJTyun3ci9bTNWrWffZtEFFK7hY0+G27/MGJLy5ILnEPuiPN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=Zj6oakf2; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="Zj6oakf2"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a7a9cc666b1so219890166b.2
        for <patches@lists.linux.dev>; Wed, 24 Jul 2024 08:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1721833763; x=1722438563; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=h6pFD8lMY2y6AZAQlT+K+Y0TFebcOoG5ZdhGkDtJVwM=;
        b=Zj6oakf2g8bqKXQFI7S4lfyEeNxy/k/vSQB10yzcFbf6SJ2sbh+l+w4+0b6GWPy6A8
         8ZxDyTYWlJsRKBFr1elpBd2/CYvL1KvhPJzK61eIfC0hAnBdQeuXFuPCc4RTIjjDMOTz
         8e//5rWq6BCrVkqEzlSgLvDzdVvmz725SGFlIXmZRvTTK/xCadR7d54Y3z5vH7RCvQTG
         y1i9SS1f2amcqcF1GdoOokwSlsYgP5ujV/mIO9yay4hKPo/8BRTPvt6wNI2Y+BbsuC3A
         nw+jg180vH6NvwykUW/9KA9xswej7pcE8i6LmxNfT30DWvJTt4IKeHpRvBcmrtIjxhNA
         wJFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721833763; x=1722438563;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h6pFD8lMY2y6AZAQlT+K+Y0TFebcOoG5ZdhGkDtJVwM=;
        b=T1d6zyvohlqL/PtXRHHKplTsZ9Yt/gXwKP3Y9dz4DNWVAtiRHZP42o7ndULcX8zMA9
         Jz0K06YInDXYDVZ96O3KsbIsN+/2oqA0JSjrS7TsuPfrxiR8ZhvuYMKat+s4KKt1CUEr
         dRGYv+4txE58HLPI+5Y7svXdkDHgKYE7x2DnRGcvxy4tYVsTrRV++2T4JBMmGaGiOVpe
         lX1G+dioclIplogeHzdbSCekIIOkXTIfyOMZsbEFc3RiHXoBWWhd99X6Y83GqVEU8p+r
         MwBHqlxFk4qLPIOhFCgXkBWjUzLh8rb0pR01VXz76byjNVdsfRGPUkSs75zydrgLdOws
         Zs8g==
X-Gm-Message-State: AOJu0YxvbkxAkXBf+Q9g0j4WN/coWsTEG9Un8RjXq1ePMX7Ssq763mx5
	30dexAs09mcTYUan6+29cyPY+7Utj009ZzHr7Dh/1PWTMR6SKxM=
X-Google-Smtp-Source: AGHT+IE216cUStduxqsRJC5ItkiDD7My1lRhgMj0JEHbhShAjaC7eI8OtGGhSKCCTI9YQamdbK1jvw==
X-Received: by 2002:a17:907:9694:b0:a7a:bae8:f2a1 with SMTP id a640c23a62f3a-a7abae8f633mr134242266b.42.1721833758124;
        Wed, 24 Jul 2024 08:09:18 -0700 (PDT)
Received: from [192.168.1.3] (p5b057b1e.dip0.t-ipconnect.de. [91.5.123.30])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7aa08b6f18sm162798866b.46.2024.07.24.08.09.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jul 2024 08:09:17 -0700 (PDT)
Message-ID: <109bd280-a1ef-41a1-914c-9fe6f96c31e2@googlemail.com>
Date: Wed, 24 Jul 2024 17:09:16 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.10 00/11] 6.10.1-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240723122838.406690588@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240723122838.406690588@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 23.07.2024 um 14:28 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.10.1 release.
> There are 11 patches in this series, all will be posted as a response
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
