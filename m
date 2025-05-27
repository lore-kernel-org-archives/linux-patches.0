Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC1121883C
	for <patches@lists.linux.dev>; Tue, 27 May 2025 23:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748387626; cv=none; b=C7hzFqifVAyT7a2tFS5GfBbWGnOjw8lpttInnuSgQCGTxT4KMW/v3mGV9tXjjUNQ+iTjjDEHeM19YkNbRfHCc5zcJ9o7P0XsfH2TklXzxPapF+itDTsOiJjrdVRQUfVF14N2LQCG8XQQTqVu/fzNX15W2/jNldiZs6zRWjEeE7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748387626; c=relaxed/simple;
	bh=mgJlmbUc2ro6RV6Em3XK74+pc/RXFJAn8arY4O8Gn/k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Veb96MUP+eW65T9SL0c46yoobH9vB2d/2Ex/MM7HHquEneBcmsQadXllwZdDbMLIcL19Nt93NSa96XeMA0UpWaeNcvEpUlHMS6RVIm+mTtKmcV60KRyFhShfCjCOhWTlBg/FqwhcoBhafwAN3WDim+a9ltFE6x0Pk5J6gZomxuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=jTexYDTr; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="jTexYDTr"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-43d0618746bso31938025e9.2
        for <patches@lists.linux.dev>; Tue, 27 May 2025 16:13:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1748387622; x=1748992422; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=D3Lc6Jwle7E9Z1hz2kstblSBGOT4ne3Fyuf9Vey2s4o=;
        b=jTexYDTrHPOl3c6saWO5FsdLLNc1mQzZs3d2MQZdAq7cY3kUFPDma8B2gyUT21c6u5
         EPM9geUtPTwth9kfewv9NSSnxEwyPjDdioYqhRA5+4MbfP9TQy89JFjGMW/7DQuurZ9G
         53o65mKdT9CEyxLmzDDmYIUrOyUeneC5U5riXNJa3WySd+eTOeighHoLSVsBXgGdU2MK
         936izni8aIxLab+bs3AoVQ7kstHr2mjJtO1V4zdguTBI1Fq9vvyjpJElJOpzt7OR0c1q
         BeyS0tS/IDEf6FVcZXz57g/jKr/mkpcqv7vhtk22YlJt4Vya1huWdQf+2GZc6J95nnf8
         gCNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748387622; x=1748992422;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D3Lc6Jwle7E9Z1hz2kstblSBGOT4ne3Fyuf9Vey2s4o=;
        b=ayBhekAaVCctBfUv+r9UoqpB/BRUcgBhHhsKQ2Vbhn9sjsFv3MEhud0iFj6MknWa6f
         og4fYGFRwGzkpG44BMKG7lpZaKD2a0hq1mEcTNGXWm8eLs3LCzGA4U4IKXGWHdb+sqEf
         lCJUxITwuiuKMbLeAKlarGRfoci/l2mzvHzAxByJda93gUjDcp4vU5XwakoZb0U2xFU0
         DIYXwsRZ25C+MxD888ppjrFaTnm7uSrcrO6oeTKtHpshAlOcW3cU2H6IR5CevQqEtPHv
         VOTh8g4lf3E/BjdGjAabt5usZXMJdRfsY+1wT6fCX0qRUUFH4gA/654of6vDdc12a/8d
         V6WQ==
X-Gm-Message-State: AOJu0YxFbzsupfeskWSlJthDchnr46WeUBP7mxHZRIuF1m/t9pSoWo1f
	BxT57qf/zX5fRVDU1k6+PILNCt5D4KwE0PYUujGL0MKOFTSDQklDnpM=
X-Gm-Gg: ASbGncvnWxexDBsm8z5zTO1jVo/IbcgBQKFv2z828eoaDzL4KswaL2UGqSuVLKpOcmc
	qWuafTmhb4H60hEziLbO/V2j3d58kQihymr+6mUreMK0tAFwxUL5Q9843D99TfIlIiTEbrhRp1+
	6uygkATz3OhNyX56aYyod3EdThehimD9Pompr0XpC1IG63ei7ApwrSTUAHFK5lJiVN+Hqldxled
	Xre+7dmDQHlF5GRMdQVm5ioJ7+o8ZrbZJPoPUunug41T1Al3TSb30Ay+chWQWsLiHGt6FY+jv+K
	I91toy75xwQOA9cuue940ttMy29AsacmO0GId27PUMdpWvf0zPssO7EgyJ1xWjAQr8rtEIT6lxk
	WUGcpXM0PCVD+Pu88cdpfhBT9XFQ=
X-Google-Smtp-Source: AGHT+IFBeUh+qlVxssEXGivv7mIe4rzopkh+j/jyz9zm7czpZpVxm2UnFluFidGi63ZZjrI8VVRijQ==
X-Received: by 2002:a05:600c:5294:b0:43d:2230:303b with SMTP id 5b1f17b1804b1-44c9493e67fmr111553085e9.20.1748387622283;
        Tue, 27 May 2025 16:13:42 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b402f.dip0.t-ipconnect.de. [91.43.64.47])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-450064b53b1sm2779155e9.29.2025.05.27.16.13.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 May 2025 16:13:40 -0700 (PDT)
Message-ID: <18f3959c-e7d8-4d57-a5a0-cbafbba91281@googlemail.com>
Date: Wed, 28 May 2025 01:13:39 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.14 000/783] 6.14.9-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250527162513.035720581@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 27.05.2025 um 18:16 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.14.9 release.
> There are 783 patches in this series, all will be posted as a response
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
