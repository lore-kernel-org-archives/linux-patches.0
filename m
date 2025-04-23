Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23FE028CF4B
	for <patches@lists.linux.dev>; Wed, 23 Apr 2025 19:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745436993; cv=none; b=g4s+bBmQL6cLkM/hZwceZ+apTQ9qoWznk+xgscMDtzl4+SWOZYUXATxektACWbKbxftzQTv452+8dlRzFgNMWLRayiFvrW5fXUh6fMlf02N1axywKT/X8PXLyaq3mw+cZBiSgmHbg4ljgumWZUe9iBAfysaUTP++fVk9lCpI/Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745436993; c=relaxed/simple;
	bh=F8Lms9WWcqbi9UKLZVM3A4yA8hdTJR3kmzCK+DkmcwM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WyV1NmSO/fIH5lBazfNd9e+FmWL9HYfW8ID4uT8Z58xTb+y7QASlgQi7CsK4XBD0MQfybZKMLZZkMhgsQFpCMZUSb5hao5EsLPxN/g8xlRVkzuk/4kMX16nqjL3Bace2slls0bgyyCJURwiN5/0+RftEcHUzVU6u1KHnMHHx1lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=hd+E0ubY; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="hd+E0ubY"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-43d0618746bso1549835e9.2
        for <patches@lists.linux.dev>; Wed, 23 Apr 2025 12:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1745436989; x=1746041789; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J13/1f/4bpG2OkBxc41bbyLlaHxbEughKpa7FrPZ83o=;
        b=hd+E0ubYhojShXywCzmNd1mgqDUhMO1iXcHYgmVn2+EsXM42cyZ7pjnYRwUvWT02kw
         GLvr1nLbutJaBOQH67AH4VqKi1JkmcydgHXWr9EcBdTbAOToRcKq5jJbYV5fHFfUh2/v
         C2/VQvFzc3hS215PXeLn3U8rLe0K2vb0icT+SBtefTkkKwaRdU6acFnRXwLU94/RIJgG
         kgu4KPtbedynTvP65hV4do9vrp1oIg/GLVzuVNsToq1d4PZfbSqi5qDQPeF4Nr65TS/f
         0kE19ghAICIyFv+eFObyJF3x1OMiTERIg8bYyM3bu4vJ0wJ0rx0515KACkSpMGg3iGOb
         WdFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745436989; x=1746041789;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J13/1f/4bpG2OkBxc41bbyLlaHxbEughKpa7FrPZ83o=;
        b=OncrPnYyZ0dS1hYbUXn0shyF1/QEWuvSroeoauug1Ke5dsFbCTWlk/KZYRk5zEmv4b
         N33kmww6V4aHE138J4uDdDa12YfdkHIaIB5ARID4F8khaJGZ4BomBk/a5W23QAL6X+lD
         KdOp4HWufc2//eZT+UkU4iGub5rBRLThPpytD3jLD06RoVQNyl9fyKz4T8gUy3V5aRQ2
         /OtnMffHeCA34/LlknpdtLMnRRX+gJuOsRFQBqhqPvex7Yz+TMVGqVU+DSb3OASBXTD8
         TBNPctSYAN79RE7LsQpi6A/ivlwtc5fynfNEmj+/43SB57aIgkaBCDEbmvCX2+IeltPl
         Y4sw==
X-Gm-Message-State: AOJu0YyfgT/IK7BNOYZ1Aj5SHAXCH3AOqIBP+RQfDWUBMiH8WCRaipRt
	0xl5MRNnkm6Od8vc4jc5QJdn6/UcW2lPjEi9pJie5476e6ju224=
X-Gm-Gg: ASbGnct0AR3ePt5cCiiDOT6k47uAi+cF09s0yW1kfOugqEbO0FtbX2C9IqlgySPgJWD
	zbF60oH+D/LeELk0dOohh76z40BAv8JBEmSGE0ia9fK9VSR/0K2oYBKzhyXHBhBnpgIGOriPUm0
	VISeXB9CXwbUgnsD5eTSoB9QumWdo2NnIZCMSIxBmDloICIuUgBWkOl46MRY3TjdtIFkvG88Pit
	WvaGSWneBaVWZU9J4oKvC84+cJJ2ExFA8q6h5Wgrj45MaUn/so7wbIDR6JUfVnM+hz66XoADLzL
	zyLmBnyiOrWaHgIg/RTzGb5OrTOg9pfyeibAWIkz150jfS4sG9Su8C6yFFDiFe3JYMXbjfIGeP1
	W0bcyJFRLfo3T1sROSg==
X-Google-Smtp-Source: AGHT+IHXrAT5Ym8Wfi9Mv5P7WsaXUZaJTk3APhWCaUhtxOeEgA1taGsSqysoypMvC/sD45jNiPBpgQ==
X-Received: by 2002:a05:600c:4e8f:b0:43d:47e:3205 with SMTP id 5b1f17b1804b1-4406ab99521mr172733875e9.11.1745436989205;
        Wed, 23 Apr 2025 12:36:29 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac758.dip0.t-ipconnect.de. [91.42.199.88])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-44092d369f1sm35725315e9.29.2025.04.23.12.36.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Apr 2025 12:36:28 -0700 (PDT)
Message-ID: <0f058a7b-72ac-49b5-8121-92a189e7b82b@googlemail.com>
Date: Wed, 23 Apr 2025 21:36:27 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/223] 6.12.25-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250423142617.120834124@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 23.04.2025 um 16:41 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.25 release.
> There are 223 patches in this series, all will be posted as a response
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
