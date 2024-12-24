Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35510190063
	for <patches@lists.linux.dev>; Tue, 24 Dec 2024 11:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735038232; cv=none; b=ZMnAdIUtjhj3VvLTTaoa+gWMd2UE/XJjuyt4pj0bous2RxHU9u9SZreq6+bT5Shd9YsluZd+pUlpRpX4gVoSxXTP81byY4D9jEbj5rfFwQvBguiYIrpV8QqHTFdne4bKi1p4+EXTbiyZr1XtTLdUDrBGR4E9Y7T6OKFnjuDVYWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735038232; c=relaxed/simple;
	bh=JYv9O6Z8cMpT/DvONn3axjUUbzsMVDz6wMcWWRdYPQ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ziyhk2W+kGb0zy5NkKG+RloH1Ze+GEDmTOuMgmLDnmtzwVdgaSwk6iXC6dgu6oEYjwMAQm5dax5Gqsv7hSCAFZ3YVrpOHR4Zd+KWlaCzcU7c4zxtkXl5R9COSs6CNfv4YUvocTBNg0TwKD9NRvG4S7C/BDMziM+MrRBAyUq421Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=ZDz+sdJE; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="ZDz+sdJE"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5d3f57582a2so10856714a12.1
        for <patches@lists.linux.dev>; Tue, 24 Dec 2024 03:03:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1735038229; x=1735643029; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=y+SEVkpBE7XvTYlML0KQpN3wLBrjP4uYD6OOiyWpp/s=;
        b=ZDz+sdJEMDwciRTL5HNkEA8lqEnjStl+LDc+h/LqhnqIUiDZj/FHqvFn/TNL/abhTs
         Q3fxjgsqEle1djbN63o9l+qw5h6TbXPga+4SJ8YEVWCvdmLIt271YaDMGUKBzdDpYEIj
         RdK2lDhy1C76Pj3dM4TJwEfwyarkm+A9DrHedIhBJ1PStnjS4cXWWSOT3lQKcp0kMuoU
         XFL+Jwn9fHBbNJ/j3kwGwpZT+k7y05T4zl0Bz6qByOeR9LVXPjd2JCwTUySwAPmVAHHm
         l4WmhnRr7f+3vg//lneku/+AQV6JKa0LrJ9PVVzkqNH3rpr7mmQ9inrsJxyJMdxjEcmX
         ZGmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735038229; x=1735643029;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y+SEVkpBE7XvTYlML0KQpN3wLBrjP4uYD6OOiyWpp/s=;
        b=XRC0J4l37NdgL7ZktKfeaKu8vrVzyZRRr+r2OFzzXWw0KQExZjMDbZ63xVX9MJ9H+U
         PXjODsmYFTgGMZG323BXabAs/Hb2OrkywWl6tPy1Gyg8mo86jtKs9twwHg35qwmUQqXB
         cNczH1fvLCD78782VQFXyhw0OK7nHvkqAO7e4mjrjR6yfCe7Vt60SFpE+rOgZujzHrDH
         3dUGfqIgxf27U+zAsdwr5ZBwL8CIqvYEyAEVdDA+/tJdZMgGrNOLyDH2rxehp7I58ap7
         zViGJL2+/4UiVXqsFdGFkXeemUNMz9mPuojU9DuULYwXKgwSTPUAM0zKRo0xMZeF0AJW
         LDCg==
X-Gm-Message-State: AOJu0YxycML4SZcVkXAPRy2ZVn+GmBYuR0zhO4gwcVpoUAV1PY1EIYFo
	mVJ0B1hyQULG2NhP2aazqXhhPwJHURETIXJ+f7fGmu36tDKPdXI=
X-Gm-Gg: ASbGncuOFxk7Gmm+zpTbux3AhHYUJA4xNyAaU4gEcdMc5P8GlhQjMVEqfIEnPMYWi/5
	tuDjhXIM88UyQZrxi3TtH9vPXLKAfhsYbQrt7R5fcVTeFab6sII5UjA2c+8Cpk3GuxtCFwV+wCS
	cQZOpXBAMooxKzvI0ue9s8wlOVZghQjUP7hLO1H7DpaxS9XlneQoNbJvFtVrZPiuTqlcm+Jg8bl
	JZWvh0Emh16bBBD+1lqh4JuSF7DwU9JOpmZhjZwy6JAC+ShjyDDO0BRiwCvM+fqeuDfjnf8ly5N
	zOUV7lO94O+cCjVjmQSYosUjtkQ2gmgb8w==
X-Google-Smtp-Source: AGHT+IHOZlD9aLeFV4qen4/Q0f+49bAJOVCLjn90LDTVjUwoQ9w4VXGIxcbl7/ApfwYNmOGyM9+gsg==
X-Received: by 2002:a17:906:36ce:b0:aae:bb48:211e with SMTP id a640c23a62f3a-aaebb482becmr746344666b.27.1735038229167;
        Tue, 24 Dec 2024 03:03:49 -0800 (PST)
Received: from [192.168.1.3] (p5b2aca5b.dip0.t-ipconnect.de. [91.42.202.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0f01228bsm639522566b.143.2024.12.24.03.03.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Dec 2024 03:03:48 -0800 (PST)
Message-ID: <69809e40-7a9d-4758-b455-1bb4ec2ff876@googlemail.com>
Date: Tue, 24 Dec 2024 12:03:47 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/116] 6.6.68-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241223155359.534468176@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 23.12.2024 um 16:57 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.68 release.
> There are 116 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>

Happy holiday season!
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
