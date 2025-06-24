Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132AE2E2EE4
	for <patches@lists.linux.dev>; Tue, 24 Jun 2025 16:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750783261; cv=none; b=MgBAT/bzqHZHSWK2KatzbgXp9kwN354uEbzpq7t2tlsW/KyVegbhq823mSSLKY5z7TTUa6W+CZH7hNfEI0+JR5I4+RnytugWkNJUa+xox7WGpkYvlDoAIt0lr7KWPgqCpiAcFX4NcNuwLwohvNqQkgJLLzbN58utvZNRwkntuGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750783261; c=relaxed/simple;
	bh=bLv2ZvkgYW7eElSTuPTXO/NeEVfHDPT1jlpcZEZNU7U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c1AdG3Z9DkodRYMOqXCqTBSTveST84SujN7erMewyOPXz/5snzffa5ghknuRMBHsH6j5iROgaFOxqJ3ZYWvcZUIvVyA9MPA/X2NznIKMr4ibfRz/hFAGY1jR11YlW8I0ZCLVzznDvzrvOV8R3216kDoe167EhST+l6GA5SCYGXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=lOlajJwG; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="lOlajJwG"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4537fdec39fso2912415e9.0
        for <patches@lists.linux.dev>; Tue, 24 Jun 2025 09:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1750783258; x=1751388058; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Vf4F0rlWcp9KU3CJvu4wbkYZgfX0ZRwl7p2Dj8IyGas=;
        b=lOlajJwGSOka5pfPk5Dmo4QmUlwyC90ujr/Z1mfxrzwhsNfyC3LDMYuS5eh8R40YnS
         fmDkjrIVqjK+vMhopjFK5NBeBDh0yEsVUg1HqlHpQQW01bfHyj86nDXxoDj/NEiZuAdb
         /MNswgaOXVwhpDtKYNy4X79H4zohAqVZUqla3a+3kAXk9A48CbwJfOzlBs0XgTUTOTdq
         QVv1arH9Rq64qsQwN3+7Kvo4kqLz7xjZbmJLZaNMVk4ZnOBjwTvXNM5355i7jJZmcn1b
         esIrCGLHuYKLt4R+NZgCJjFV6TmelEq+ra9B4T+KwU4Oa6xzYwJAvwQhYBnxr/LcxlY3
         4yDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750783258; x=1751388058;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vf4F0rlWcp9KU3CJvu4wbkYZgfX0ZRwl7p2Dj8IyGas=;
        b=rdcvwJmIiWsxHjkwpl//es5oK0I2HchZi2GBs9IiEKzeulIJYeZQpn5+dxr7vNowAS
         0LagYcb3g41rhzgS39s0Dv75oOL/oyizj7codoZmPDUd1yT8R+fv+TMX7jUcBFTcxXj1
         BOWz3QWA9LKfqBj8jIFLUHHBFztP5l2wgp6xX82iDC/s3oO66ot4qfk0GyZvZN6nbS8n
         1F3G/ixay+1pxr0TN8uxRxUdpdmnI90r2ikq48cp8jY178+PC9LpH9b1E3mpKTiXIBMP
         veh/fh5znJMDXALSnPHmJnBdUvB5eZ3otm7Fa9b67vEVN8YyWbc2he2u5OhRr/Soo82g
         X+ow==
X-Gm-Message-State: AOJu0YwsYiv91wgU1QBXjkQ834be/plCKfVht/BoGGa4nOarGkxcAT/8
	8k9TyO0TR5A9gn84NM7nJeQTW3ndlLQcAmXdsy7a/mgaiX8q4A4nlSo=
X-Gm-Gg: ASbGncvXRBS7pgCAwsizmgIDBa178G+0OZLxTC3cY9VZ1ANpDvD4sBd41waD3hllMJv
	keyBHditu6Rc2D1ISQcintNWllilxwRc+2IG2MR7IxtkDIBV75X6/B7jGe89ybweCTeGJig2i+S
	XVd2qQcWgl6LbVqVbcsX63+67UoLXcyxo0xg3SStgXMZ56ngHhP9/t7pfpox7xVV8uvpODq7Dhg
	NXYE/l0xKjkZg4legQn8oXAH/zf6GDoxbx/QN6T2lSsNaRsIWDMQ2eG3OEfX1p8Ui7LgAh5oTJ9
	Rpw5Lxkl/JU1hBYkOALZT3YDS3N015+hzMLzZhiBkTpckN+sJwiz3qD9A6BjLWuox1EEA542cTm
	eIcpEwib5CK9as0j21wAW9PZ0BHY1C4Q01fox/IU=
X-Google-Smtp-Source: AGHT+IHL37tk7x87MU4ZTonT26CiX0N0ee272yuwd/21jHdnNVtMyb7eo70HBqeMi4qHY2RQmZWlfg==
X-Received: by 2002:a05:600c:1e8a:b0:44a:b9e4:4e6f with SMTP id 5b1f17b1804b1-453659ec1b7mr149785565e9.16.1750783258235;
        Tue, 24 Jun 2025 09:40:58 -0700 (PDT)
Received: from [192.168.1.3] (p5b2acd47.dip0.t-ipconnect.de. [91.42.205.71])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4535e97abf6sm179158175e9.6.2025.06.24.09.40.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jun 2025 09:40:57 -0700 (PDT)
Message-ID: <0b783dcd-75f8-4b1e-b0e3-9052e419e62b@googlemail.com>
Date: Tue, 24 Jun 2025 18:40:56 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/288] 6.6.95-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250624121409.093630364@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250624121409.093630364@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 24.06.2025 um 14:29 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.95 release.
> There are 288 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Just like rc1, rc2 builds, boots and works fine on my 2-socket Ivy Bridge Xeon E5-2697 v2 
server. No dmesg oddities or regressions found.

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
