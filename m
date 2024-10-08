Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7F61E498
	for <patches@lists.linux.dev>; Tue,  8 Oct 2024 16:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728403526; cv=none; b=gzEF4tIQi92KtRY8yIUnQJQ3/fprTE6bW7Bz34sXB7btQxeCuKgdIIWnWNrl8tVnljOwcav9ujvM7kf5Bg+PUIgkpsP/0ll61VYKReSG1KAIwa8veap7MGpRMLdTkcnXsvTNP737EPDyUfWZiEUGlR9zcpDUe72kWn2seQPZoeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728403526; c=relaxed/simple;
	bh=W66HPaI7vCTTXRg0sHOI+UJgtuGeaYK/rqCGihZVcsI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rO/nWgaM6TcAo7xEFycP0GfCRg2zmEUQpFa+hCdtiBzd2QnQj0x3cIlvwNePOqPaHrF1AVP/G0nwYw5eF5B9087tncKTkJRGmk0/oeaaIK8Oz9kln73yHgDyys0CiA6nS3KYnHgvBzxW69lCoRFJOh6poQhTnOO7iA9PEfi0GJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=h9MrABVs; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="h9MrABVs"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-42ca6ba750eso37006515e9.0
        for <patches@lists.linux.dev>; Tue, 08 Oct 2024 09:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1728403523; x=1729008323; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uyg5938XUdbci+Id2jSlJ3QKaymXAYrdG/rjhrWuEI8=;
        b=h9MrABVs1WW16sxpfKGmKeRwo/1Ojae05u+0Lwbq97+y6NNNHShwm9TTECWX+d7gnR
         Tp/SBhoG7HIk1Es/yAMD4BhPwMpkzCpr+bGzivJIjHlkkzcjWYJWuM/K4sbw5RyvZbRo
         kgVTQaZJpPs7m5IyzHhQikCy58YpESXOPkV1OsY3xjyHGyEw0sr2OCyEWLHApLvWy+DT
         v6jE4MBOkUlz0uiBfKM+42bGhkEdWElhW6/S9aa6L/tmsB4CTTadOLP3cGvxxnLYjlHC
         yZcSXSvZt2J1ubQ+wykXU/rasZQSWBeRHLGfTRai/YYstnf8TtkO0P0hlLNGxM3vdRkC
         dmsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728403523; x=1729008323;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uyg5938XUdbci+Id2jSlJ3QKaymXAYrdG/rjhrWuEI8=;
        b=gdYDJvzTCT5zBNDdfRRGXah62GjVy+GDUyqPxT+W1P7xk6OqqdMGESm1lFeZk8tul8
         V062kwQfq9XenjonQKsPBUccdPpZuYJdohRW0GYE17oAQ3vsZKSXtNfyK4SczQsZiN+9
         eHYKkXeKv7zSJ4NbjekLJhmU8+gDz1vb1ncxTYNRV0RbcmggWkPgnzJeMr4gj+Ao3nMf
         cFVKehhEdIyRjR68J9qLI53cJs4oKj2fmEjhYvNlx+aWLd9DK5Yaqilc04atUYk8P0Cv
         5GtxP/O3JW46yt4a0sOq7u+1mTPoZTmOkQ3tFuaqUOsIYwBLLHQzZtD006SYRUmei1D4
         k1Ng==
X-Gm-Message-State: AOJu0Yw5TfRTarplVclpV8k4QaxqXbf8HJH5ASuHFNiMQzkeK/d7VVFx
	OmLf0W7ZbvUBE31nPsTrmWHQ84oCx/Q78GbnkBrzig5jO04JLPU=
X-Google-Smtp-Source: AGHT+IHI3HNkUhkt+2Et79RsDlbHBNOOu28DFhEn8C0r9PruI3pYmDHi7Vz5GxFuYkTpi1aT6S9+/g==
X-Received: by 2002:a05:600c:1391:b0:42c:bd5a:9471 with SMTP id 5b1f17b1804b1-42f94c18e42mr24494485e9.16.1728403522574;
        Tue, 08 Oct 2024 09:05:22 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4723.dip0.t-ipconnect.de. [91.43.71.35])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4304efc442esm19349255e9.1.2024.10.08.09.05.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Oct 2024 09:05:21 -0700 (PDT)
Message-ID: <62aeeca9-ab16-48e2-b529-1587556bf19d@googlemail.com>
Date: Tue, 8 Oct 2024 18:05:20 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.10 000/482] 6.10.14-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20241008115648.280954295@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 08.10.2024 um 14:01 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.10.14 release.
> There are 482 patches in this series, all will be posted as a response
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
