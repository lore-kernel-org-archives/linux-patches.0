Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 148F278F23
	for <patches@lists.linux.dev>; Tue, 10 Dec 2024 10:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733824921; cv=none; b=cE/guWghkQaey1iQ7BHga7THOVcLRkVZjzjsGEHJStARHEEVIn9MYRDE+vt67ecQ36lJW/xuvYANmg0A7pzgGGnUixxlXNOMhEpkMz0hWrZlV8OdvXHdbZpodCuwuUY/ztpja4vKJt+9k/h4h4hSJeLygGNcVKS+HAHEPmDoyxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733824921; c=relaxed/simple;
	bh=7XBDDcF68AQhVjxhT/ZJOXSmiiK/0eaXezVOSjDr+98=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BCgHlHa04wkyXoHl2hjRampB20W3zxotBe43aIq/QAiH7rvtYtADRtw2WF1frZyiqYzK6DJKwofFBfejgpx3gQFjSDC7l5Bighq/OqGDrG4Tqb9AVedQ4R2cLQEo9jfOkL/GYifIynxy/HFiLvxPzmMk3r4XvrgYRLidzSAEwO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ikzgE/OC; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ikzgE/OC"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-21628b3fe7dso28899325ad.3
        for <patches@lists.linux.dev>; Tue, 10 Dec 2024 02:01:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733824919; x=1734429719; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=/F9Ua4kvSt8BL79rBMm/hToy3OtGMQd8KjA+7WBB/UY=;
        b=ikzgE/OCRixqVwGrrz9ynQdxb8xbHEuj4i7sUXjn+HRWXk6mKrYtNpsmO+fNvVvvLK
         tBGpEM0CWuVs//qReug2T9kYFHTesnoulOZ4SmN522AgnVOwa9RDhvSjjM30xtBBhk7F
         SejLWMk/IqdU6RETsDqlRaZybHtbfvaRbkohNrjdduJm2VZAf0vWqzo0JPvrXal/0/qq
         H/cuSef1KmJGjb7+sOtV6ETgdKIlJ3qm21n1CxkVmnMoA+A5NgtMq9HkY7qBEQTIUdqA
         Nseomdahzs3lrwxnUp3O9BUoye67D7ZJg0GpnPuoDCTH+HIr9fdQRXCiXs1BMBos+KOF
         JFyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733824919; x=1734429719;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/F9Ua4kvSt8BL79rBMm/hToy3OtGMQd8KjA+7WBB/UY=;
        b=ktFcVUrfnWqjC0cOHRD/lxZ7gbP5i5TzLFGLipC+scQ9ZRlqsF9AqWHDgnyll3OEMK
         QXulKbPVR6HRTgqnx2NNNvzhspmxvu6zRwnRc1299+xLEV/CDQBiw1F4FiW3LEEZ9xdI
         QChZmmo6BOkhiK+TfsdsH9L3IQmkSw25CJnmNEWgHGQDJGdAwd5XNW7hXmkWE3I8iKgr
         NaudCoaoxeloKHJSokXT8uhAhIdegWtxd/DaDklqfXOZC76lSqiecq9p/lqVxHQKwQ7J
         rSLkEvQhg+MfgLpDkev8uzjYitxI2vt0mAnYbCD/YcBpN6652Zqgat9bKTBhQzHDl/tA
         eRnQ==
X-Gm-Message-State: AOJu0YxJnK1XJWnGub8VLViNlo6MaUgruA5hBCxgGTrAQR6ZrWNDr5Mh
	9VRjoiKG+QNYBcEsBsAtziwIFlEgcOXFdO14/fK1Olke+RqVC2gt
X-Gm-Gg: ASbGnct6rWrqCg2iXChzgMcsC1R285O7s0Jl2W32kaOB1J/DfkgbJ7xVXscnEq5nfCc
	fljm/3Mp3NyyXJHJhwxoiD3Xrpb+ccM1g4m6cAiDdF8tm/12Q750Yf9zfaNoWmogWdho1+GkBFb
	VqaH9m5/tw/bjRUBYbcQ5MsXjx/kqAszxI7jd8RPafcAskiOUPpF4ArQ6EfHxRCfBPKEMlfDynt
	ORQwZh4bK4dZ0qKlyAY6GdKz9XaFd7kH0bCy0PvXcCapSmOI51KbhBwjT9P5f8CseBls+eGTHWT
	WfowDX5hoVlilTzh7MQesSWWZdY=
X-Google-Smtp-Source: AGHT+IE4jkAlNlEo/jdNOzHy/0qGcg0edxQ8DpjFAykqcdAZmWzMXT2/T6NQrspwn62zfEi9FGTTJw==
X-Received: by 2002:a17:902:e751:b0:216:26f1:530b with SMTP id d9443c01a7336-21626f15afamr179976045ad.51.1733824919153;
        Tue, 10 Dec 2024 02:01:59 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-215f8e3e7edsm86537295ad.22.2024.12.10.02.01.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Dec 2024 02:01:58 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <e05374de-a45d-46b6-9ac2-a4aba932c6d2@roeck-us.net>
Date: Tue, 10 Dec 2024 02:01:56 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/676] 6.6.64-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, Stafford Horne <shorne@gmail.com>
References: <20241206143653.344873888@linuxfoundation.org>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/6/24 06:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.64 release.
> There are 676 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 08 Dec 2024 14:34:52 +0000.
> Anything received after that time might be too late.
> 

Building openrisc:defconfig ... failed
--------------
Error log:
drivers/tty/serial/earlycon.c: In function 'earlycon_map':
drivers/tty/serial/earlycon.c:43:9: error: implicit declaration of function 'set_fixmap_io'

Bisect points to:

> Stafford Horne <shorne@gmail.com>
>      openrisc: Implement fixmap to fix earlycon
> 

Applying commit 7f1e2fc49348 ("openrisc: Use asm-generic's version of
fix_to_virt() & virt_to_fix()") fixes the problem because it adds the missing
"#include <asm-generic/fixmap.h>" to arch/openrisc/include/asm/fixmap.h.

Guenter

