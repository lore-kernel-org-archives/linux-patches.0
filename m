Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA14312836
	for <patches@lists.linux.dev>; Wed, 17 Jun 2026 17:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781719105; cv=none; b=Nj5JfCt33OgJMeNtZkZbJkX5MXp5QQzV1RqdMYI/LpFEmXkMg4brw12xr5OFiXTbJHoMPFFR3mNh4cTNa0F2X5EsjSe9LkFmGqxltCLr1fZ6kpgHq12ilq8vqUGvuDmeYTlwY8hnuN/Ee9zJe7+A6DGW92kn3p5xlpnz5fgxolc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781719105; c=relaxed/simple;
	bh=Guw0tA1J8byOmGpxmwZek6dbqqoxCDzeMh6YE1dAJtk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WiTuQT7s/HV8LLPpKnQJYxVGuMFaWiqtOZBbW+4cceRPqQmr6qY8jfvBN1DwGX8F5Ux2edkzEGxywHcOu7i4i2HquMf3dVWza4GDZrGjEENHhv2KkP3+eqWic5tmEk5zLIcnqvXwz0WVsIgNGWEbLWWJ4l1RirE+TdPy+hmpfvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=kvRI9WZQ; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="kvRI9WZQ"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-490ac357c55so57125745e9.1
        for <patches@lists.linux.dev>; Wed, 17 Jun 2026 10:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1781719102; x=1782323902; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7CL7rn3pRUfZddrPejdk+SOSMtwuDTO3Wu9e7dDN4jg=;
        b=kvRI9WZQDbZPPdaoRlFKuDBSRIfceUIiYLiNgJRu1gbR84UGcButCcB6h4Dgw32jyb
         U/TV8RJc2UpYYOzJAqbwgtlEFO//3o0Cc1LFeu865AzFtBR2gkp47Cz66YfJE1wZVL90
         FJBTsIuC71L+EgYvQi/pzOfHXXe8XXQM1qvJY7eueNi9FCTLJUuHZ1CnoFmPIxOWgfJB
         +p3Wpj5xsSZSLeGel1XYvBYS6/kQqYAL9DfyLtYne5YS9RELIAl7ibIfhBH7vN9k95aM
         MfPqYD6KFyDJTPlSlBECzMVylea3JsOKw4Wj6qrkO7BX22JK9AqZZB2d2uVHrKNKKIsu
         exvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781719102; x=1782323902;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7CL7rn3pRUfZddrPejdk+SOSMtwuDTO3Wu9e7dDN4jg=;
        b=EYceMd98zyBAyGZHQ1sWpkrcpWmYA5Fva8fD9fecbR40sVr3+2QQPyopRfimaL/WsF
         7FOQyZMqUz57II2cNu3t8YRLI/SQfqwD3tewZ1K/8BJnLxUWJYMPNLL6XJmTQ9Nnvnzo
         /6hRusConEgWnuGyXT6H4Xyiu4hFH+ikGVxaMXR//MbVjkM9CURWh3HbOqZUJhNpfHDs
         L83IueMHcnIgViII+FbI1ElvwSUP9K1s3IR95+bdAXsqgzb/RD8ye4WyDN39HIwqt4AF
         CD1ci61xmgkSYQ+snjsHFxogMscvyM+cwQ+zVDbBaXRaEKFJR7quAaa8u2GGuvSRxbYr
         ClqQ==
X-Gm-Message-State: AOJu0YzR7b04K1K0tv6DmTN3yBHSKHqiUYJ+G4XhGunMVnoSzmGAjXLS
	4Kh0n1N8T/yctnHZzqER0+w3wZN75JrS0nUfQFktfckpSM+ooPcw30I=
X-Gm-Gg: Acq92OHXoJfvqsJwcCwcO5TpKyVIQctsL7roF+RcZoPKhOmDQc2gPbSjDr1YdQ6WgeG
	HT/MUAwByLOumKaCYlJhM5NzqWgk2y/HJ/0rJBUNJl1bFqBZd7bH2GCSpWH8HII4live38PZbap
	9+FnysGdyNk37UnR3Lon5easbZcy7E1NgYC+oANyOp8voCheDYlJP2ybeO/4Ynnf0pbOFPbNwUw
	7t2LdvVJm+VwDQo90lOCsG4detdym5rBiiEB9luL5SedmnovKYSvAbFm+9Lddp7ndmcQr/DtSYo
	i+rCLL8lYV7GiPce6og5vBpw44a2ynPFcde2EPc+GrKw58HNyDsIQQ/AjdqIN4wm+E5675aUg5Y
	NMlz4jppwcltNd1K5pDouB8qYGtZnjLYXH1EFWvKnSSYuBB8cznWj3iLnJULFOFYqMcPZ0dyMKX
	2b7t+0JGMyduiYeM+j3CnhaPR0Y0QTzMy1ZdUJz0TdMuGfgAsEv+ugXzvsiVcBsmGddsYpA1U9H
	/Y=
X-Received: by 2002:a05:600c:609a:b0:48f:d612:3c59 with SMTP id 5b1f17b1804b1-492333a991fmr83089395e9.9.1781719101742;
        Wed, 17 Jun 2026 10:58:21 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4777.dip0.t-ipconnect.de. [91.43.71.119])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4922fa47ce3sm204165435e9.6.2026.06.17.10.58.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2026 10:58:21 -0700 (PDT)
Message-ID: <e8462f98-9722-4679-b162-748174c607e0@googlemail.com>
Date: Wed, 17 Jun 2026 19:58:20 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 000/325] 6.18.36-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260616145057.827196531@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 16.06.2026 um 16:56 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.36 release.
> There are 325 patches in this series, all will be posted as a response
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
