Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D468A2BF3F4
	for <patches@lists.linux.dev>; Wed, 13 May 2026 22:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778710965; cv=none; b=OOej1h1+JEQ+vPRX+YuiaEmKmMlF0wrKIU4/6GB2UFZspvdjkb9+zmNfh6qSTSzMbDBnhL7oheQyyR18SyWZwz8VX2LLVnmDvdM4OB85SnJPwmFifJDkHVFFUBgUM+YvZCttghf8rhHdvmzEkuUK88slaURwcIzEXld4fl2biYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778710965; c=relaxed/simple;
	bh=+H/yxd5K9nn+nhvqGlw8mcNM/DpbIwwmMzUSEH+Y6Zg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m/ufhfwQamgKJAcBnW0QcKs//Nw19sI9d0WSzPYyq6L38q5k9oR1T5/MEV1Xr14EkpLXmski2HU7qd4pzt3h2Kesmx4L+0D2IkLSC6WZwy17VftKkamFrOz6QHaCqsmbnb8JNL+Iu/HSHN6rlpX2Qoxzy/t1MZQHuhYweTEJnBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=oeJfrjV4; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="oeJfrjV4"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-48a7fe4f40bso83197675e9.0
        for <patches@lists.linux.dev>; Wed, 13 May 2026 15:22:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1778710962; x=1779315762; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Nc7PdcjPTXGOgaYBtgkZdnvKNVmZOTErVou+sL6n29c=;
        b=oeJfrjV4/OhRFoDrHsb2kbuG0NjvH0UDztWLoh+tg4MWZymwrEEy5U3bHLWzzPbU2D
         W3c7nDxArEq9bk93M/tRMKi5b4QJUKNVVdyDEYo+q0gudIM38ki1nPJJedZix7OT8LLn
         7bWCRxV2O3Rou+s1htK7+bFFA2unJANRX/4qD7ZK93YTH1bb1kk8ee4zbi0AU3C4SMPs
         LFihS2ROpHfs2HDGXQSDXbGOcYyJ/5B8PNZ/Ukyf5OejxRZosdLa55V4m/seCVH+SkR5
         L8aHocDZxPJJRwCrHnwgrASavYhQ+/knTEhUsPz70cbBgGjESrm+kxqBbuY4LxrNcrj7
         23+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778710962; x=1779315762;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Nc7PdcjPTXGOgaYBtgkZdnvKNVmZOTErVou+sL6n29c=;
        b=bmEjL0WBVAdjlowq/E0XV4MQ/g4eboOzRISssBGXC8UGUZJbZKZ7c6ZblhOa1OJV6Y
         gvdt+DRNkoy5ohRThS5sniSQjkhtoSvWaASoWLKRDuFxXblYi/uy0c4w4igSDEsKH0s4
         sB33qIwzY0KujBI+3Ol/QwB8N9Hy1xjDrpZE3AMSycW/g5v4C9BrroRcJ8Zn2Q1LMi2L
         aNmNh3ZCmK0UX1mhDH6deco6QkIigFBijhiDRzTW4vVQCWreADfiQi6g7KbQVgGA9GHt
         e9KyjQCRfsyVsTqBY51sY1wsp3/tHiaGkifxtoIBFK2oL7+DWuJOf1da8xzTQsmhQCLJ
         n/JA==
X-Gm-Message-State: AOJu0YxbvY1AQoG1OCyn8GuDKoOHTG53y/A2wONuEzEAx0y2lhSwAOxt
	8PlRBIo5KUjAsC+wyyQzS9oVYq/9CINcDqEtbvmDimZMpK665l53RAY=
X-Gm-Gg: Acq92OFcrvOdlXWJNwvAnb5RwHESWuXtt+sFXpTwgkSU5MuieibyNYe3CxmRw/V2Zlk
	VKRRpwgrbBp40IQQqTwi/g2rp/IPgn87iXIV+FEjIZTv7QLEt7VignWvH2KEuPjiUX25aBxqF4Y
	Llm5VqW1rORWgajz7ca+falRL+xmtV9GjBptn3Aq4qsIKYyo9Gt8efmpOM/bjPuBmduAOvyPv/4
	rU5FyTh0HbP4HjbLMPr8oO4hU21nn88FqNvSEO0q8iqjk1+6OyJlTjv36tcEAZMphSlF52+dlv/
	gbixkPz9TloN54u4nojfj5fX5mQyFSh60VgVRk907pdXPv2kQ+03I898AaXZzfM51e2tpTuAfOy
	0GveScHqm68N7LsntN1KMbWUs1uzr6BRP/Yt9790NaFq3LdYb9PlsSZ16TfUobJDJFSNw3XFVth
	zzq7lyDQc8uHye2eZlWhkF61yNORHaeRfxmeiI229KI9sw+tvEbtesdJzzI8IzWNIYqUP7sPhZC
	Q==
X-Received: by 2002:a05:600c:19cd:b0:48f:be94:d82c with SMTP id 5b1f17b1804b1-48fce9e1a34mr73514725e9.19.1778710962051;
        Wed, 13 May 2026 15:22:42 -0700 (PDT)
Received: from [192.168.1.3] (p5b057262.dip0.t-ipconnect.de. [91.5.114.98])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da0fe0f72sm1926137f8f.25.2026.05.13.15.22.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2026 15:22:41 -0700 (PDT)
Message-ID: <f8262ddf-050c-454b-b8e3-94a63bec4d4d@googlemail.com>
Date: Thu, 14 May 2026 00:22:40 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 7.0 000/305] 7.0.7-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260513153754.934923793@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260513153754.934923793@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Greg,

Am 13.05.2026 um 18:17 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 7.0.7 release.
> There are 305 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

RC2 now builds without error, boots and works fine on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities 
or regressions found.

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
