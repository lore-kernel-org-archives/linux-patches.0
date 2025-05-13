Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F472BCF49
	for <patches@lists.linux.dev>; Tue, 13 May 2025 13:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747144552; cv=none; b=VSllIjdOWl6/4daJ2Bx6Z71yNAwOg1vPRJVXcOr8l7Bqn1d/ZVEHZMdyBwGoZi/Sr2M7ZK/xoXHbw4AEW+Us54kvS7D+PSIAGIQx3/tnfx6xV8XGhwLFTSAKlMGehL23Q8SxvNYw/lFTVeH+QgKxgf5KXXT0vy7CwdIn5lrGXIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747144552; c=relaxed/simple;
	bh=xba21NOG7rOPSMa3tD/pBNgqk2u75/Ck61P3nj8vnGI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T65Zbywtd7xwW8Lapx3NDXqQBNbG1biP4Y47/3pKitmk0lvGjYE5gE6GEkTcTnCNYO+GEUfAh/Mff2D8T+iQtl7xkwfjyQZmSEpJwwS5XPO3physmZgfmWXfZ2z+4QmhdfUIlAlISO1ZSLncRBAT/qJDJmNoRb4bh3ZHfC5ksOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=DHWMedX9; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="DHWMedX9"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-43d0618746bso43161045e9.2
        for <patches@lists.linux.dev>; Tue, 13 May 2025 06:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1747144549; x=1747749349; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JiwK2SmUmEjixY9V6aTByvju0iHDjXppkgr75q/PvCw=;
        b=DHWMedX9YtqJ/+LBxOsHwq9MBZ38OQUevonXfSY+CrxChi9Wti99olVKoCNX9wwI9/
         dm3vGPxFAtPjGDd1w77H717FEeslpWMQapokZxX70aw8L/svh65j0SurHcJ4QzoB5qLU
         hDPvGjeXRfpJeQTSv2SQ3oIpA9Nq2rJblRKqcCl4OoXLUGjo3OTwFj+lGzX5FHD1WhfU
         AFHAjAz3IXV+SXrwIoBwlCTEPi4VsO5gctnrI1RqqsKfKrtWCq5dkoTLOgjUKHeDGhMN
         WnL1JjL1fKMrT5mT69rgGWIeoTiObaePzDCaQRw3TTLXaLTM3xgwMm4ZSroU9iBn9bkN
         p0lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747144549; x=1747749349;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JiwK2SmUmEjixY9V6aTByvju0iHDjXppkgr75q/PvCw=;
        b=qcfnhyH+pxNP1xKmTbmkNFUcMUnbvy3fKC9YBYywsEG7DfqqLHls6A+enF31PrEFcH
         /UFM25amMd/UxPiGL5YFAS4U0BIxBZUq5wydNvLMvBeg26Tq02iMVOHW9gd9vUqicypQ
         h/OwH6cKTJ6JGyF77BAFoYkf34uoZ+S8O2Z5bvhRwxDRp8VdUTmANlx10e7B+0/8H4aH
         AdLDgzpZaM3mwWrjGroctPgeQfQK4lkyw0DKfAxxm6ZX8/wZnQKbmWsuEwoFLxMoEXZZ
         YyMSEkk3AZn9oKf1IjPX9nMMh+80vaeFuhRxMZoAbAeHwBAJo9FxCzNOK8pEYZJUxxEt
         JOCQ==
X-Gm-Message-State: AOJu0YzZCPe/bfQ5ehQ3tlWi2FMSBy/JD68J0l2tk7gHUVRiG29U6X2E
	HTEXoKXso3oh5ReApFAVJ1hs0/fM85SlC7QjY3q5as+BulKC1kA=
X-Gm-Gg: ASbGnct9yopSoa9xVeoqVQsPFXGTLVs4AU6s35OVx5H++pHuCOoO/cZ0J9NsrDNf994
	TjUaTNdOEDz4FETYvxE8+YE8iqdYrCexAyD9mBtHr6ygGRpqGld55D4Ci1p2IF1Ef14Bo1+Bt+R
	fjMlh+ANxEdIHmRQtQPUmoU4szzsilmX/1ppjqbuzQ8cFKA8X6Y3vgpbRfHvlaycOU3Y60MFLKE
	xQJ1v7jtRUNEWtsyn/Ex0/MLounPI57lqRlqgOkdY/aX737XmeQKWzex1V28gA9fjEgU2y9IJDM
	Qz+0F8sXODFMITBW1n7gzBnnocWKmP+2x7Hw/S4shdTjHbZD5K5+F8t2c1kCxpjd++ll7Xw/PZu
	KT/SR2tOlN+kWpq/zijBgYD7eC1g=
X-Google-Smtp-Source: AGHT+IEGlSuTKL4fmNNNRhzmQjtY+As7pEhqwbmEI9ncsp5AvdxKJcrNJ/Hx8amETLQ/f9NE3zQuhA==
X-Received: by 2002:a05:600c:4fcd:b0:442:dc6f:7a21 with SMTP id 5b1f17b1804b1-442dc6f7cd0mr104539115e9.3.1747144548505;
        Tue, 13 May 2025 06:55:48 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac006.dip0.t-ipconnect.de. [91.42.192.6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f57de0b2sm16620420f8f.19.2025.05.13.06.55.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 06:55:48 -0700 (PDT)
Message-ID: <2e141e82-7e1c-41d0-9ef8-b98e2633301d@googlemail.com>
Date: Tue, 13 May 2025 15:55:46 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/113] 6.6.91-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250512172027.691520737@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 12.05.2025 um 19:44 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.91 release.
> There are 113 patches in this series, all will be posted as a response
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
