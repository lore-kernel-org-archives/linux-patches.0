Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99DA275866
	for <patches@lists.linux.dev>; Sat,  5 Jul 2025 02:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751683711; cv=none; b=kGl6s8JGGq8u4WsafZRNGRXy8GlbcNrLwmcPwfNAyh4d4zPAV4hu9QToQsk7Aw+iOhhUaOHmGma5uEm7DWapNG8d4zwTNs17UrFEU91oBvV7ZNVokf6XOmD6rogOSjKEZXdc5uj39FDH+Z30aXJUHQghPiB0OMDdsnJkcucYC9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751683711; c=relaxed/simple;
	bh=imfFZyMuzBbs0QEQxdBQnbPOZu4GObvS+2QnEyp8plE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XS//URA0r4Tae0HJbbBX1JaphNdX/RZ8LX3t+zlfvsPr3ql5W18OPCK66HToMexRlc5s92Ka6WcOwM+zXCjQt7EgYrpVShxyga0xxUHh7C/cyhO4/lpK06J3BU+RqOU0u4b1Qtk97Pxob1hRVJpJNpafOTBgPA32Wzh0mxegtv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=JGin+jLa; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="JGin+jLa"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-450ce3a2dd5so12747105e9.3
        for <patches@lists.linux.dev>; Fri, 04 Jul 2025 19:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1751683708; x=1752288508; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+FTc1lp2knc8DjUqKz98FvcZs+AiwQeeISv5z2me7ls=;
        b=JGin+jLaEbclHNhR9sXAfNj23hKva6UOBwqs+gICW68LBUi1xVxFhU64iZNSc8ASw2
         Rzc65d2BjEj0fy8gg3w6hPCrPWSru7Gn6qTGQCvvuVim/FgNG1/IvKwyREy4IyNjUiKD
         vxea/xaV/iO6GTCpa0cAcH/aGksSF1KG/SGLyIfhMJ850zUygVsUSNlZbjCLUmnmYoEZ
         tDx9AAtZZsb3TDMLeRLkCOZ48h3Fo10gziIzkxn5EVoKtXLbwkn/RfOn/VtYueohO/i8
         EVb+6n7reu9l/uAc8fREF/pdAyr+bYBnvsZ6OYLxfUETUUteBkkY9Ssy3Q25I+YisdI9
         gVIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751683708; x=1752288508;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+FTc1lp2knc8DjUqKz98FvcZs+AiwQeeISv5z2me7ls=;
        b=kgAMdGfmqyecTLBA7zkNYT1jruAcw5GYQyBa2TASrXYVQXXi2udp6JZYe/AiNsvOzJ
         3lDIe67uytXEyZKE3EQeVdwhVskcQJjeOE5GcfeR0m2Y4vPMM5ZOgi1quBajp6eaTgqx
         XFC+I5VgyAfk9m+SyVGVv3p2TEjY5H4BANjoalYcs7j54pwCCjbj6O8vWNIUgaQv0eww
         +W9/+SiRhh/yQT3itIqVdBjy4bLE17ejWG23NQ/TA0g2BmgIZVl0/Po/xkqzBrBFXTY/
         TLDHQLjY7YLnDhxe5wuTlIpTxa8bgLQsU8m+0yDU79H/euRQPXrwaJF1o+YLv3qigZqV
         xe7Q==
X-Gm-Message-State: AOJu0YyIqwxcfFRkppvVTDzMJSln7RC0ZDn6fHE7Ji+euS4fF+Xp06zg
	2/lzQxaK/2zaOex5nlIF25Q6AiYrCLBhg6/EcYKLAwfgzaQZzNkvUnY=
X-Gm-Gg: ASbGncve389bZPASeba7fBwKU4l+bOcJ0mK46jKpeNERpJJNjLpR1gIObBja8SIXdcw
	IKEqMtk7fdcpNJhBCpvQXkx5//bAWlWTTMTDu6nXCbj4MzD06+i8queA3oo2BNUUJpC47EBlK+2
	nJ/5JaBCjynp1MFE1l+lWQvQ+c8o1k2mPMxk4zhnPLYzMUh2tM/wHfSX1dWieiELbm1maprSTRJ
	lOzr6vHWSKCL7vguhzFO5LFcl2Km0nX9PrK0tpCRNWTTJZLY9fC+Hf4dmisIDDwYtEQMATHKF22
	TiW4fdrkwgBerHk5FhriqRd+V4T5ae7S9DMfivdwXPA3JMwZC14cyJ6Rn/KukO0FGPwoyhbX6wB
	FTb8gNwD57Vx46SnuVlx2KY5n8s+Bs3qOuujYWbc=
X-Google-Smtp-Source: AGHT+IHcOyBgdFMIsBgcKMgtcgz+vJMHffGBz9giYBlh30rL1aBDoJtL5y4XRqZbTLHnuYIV18H7jw==
X-Received: by 2002:a05:600c:4ed0:b0:453:9bf:6f7c with SMTP id 5b1f17b1804b1-454b4e76919mr44490545e9.9.1751683707630;
        Fri, 04 Jul 2025 19:48:27 -0700 (PDT)
Received: from [192.168.1.3] (p5b0570c7.dip0.t-ipconnect.de. [91.5.112.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b471b966cbsm3836740f8f.49.2025.07.04.19.48.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Jul 2025 19:48:25 -0700 (PDT)
Message-ID: <0259106b-cafa-42cb-8af3-85bac6b628c3@googlemail.com>
Date: Sat, 5 Jul 2025 04:48:23 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/139] 6.6.96-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250703143941.182414597@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 03.07.2025 um 16:41 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.96 release.
> There are 139 patches in this series, all will be posted as a response
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
