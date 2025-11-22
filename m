Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F17062C3248
	for <patches@lists.linux.dev>; Sat, 22 Nov 2025 09:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763805431; cv=none; b=LiDwYaaFiKcwg5Ddmy4VUywOKZEJW6m3+WLO1h2/tRccqXZ20Ymj6MHaFrNQ9e+KigzYw80gcvSuGP3IY1ICSh/abQ6mb0gn8fJ1pFvznlzzcmNFvYwwbY/VyJoApnWuUqpP780nKVDrDhwNjX3kfgODx8A/Tpp6LiMjXYyrekg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763805431; c=relaxed/simple;
	bh=jNSg5IwqslMSi7flsNhYhvjFu30bVkFbwI2qkNAVHWU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jk9Olo+wKtW25X98dtazdQEXW3aXzNvMvcfg9g06GXwMjEfBtC+jJN3GbFvINOiDWhpTizdPPE6dv/EzVBmBfZ18X+c1+FQYR5xTqbHmIisEfTCP7cgnIUuOSWeaxRac6RXdW5jFxDLVO4R9ImvwoI7ZF5Bi5hYjmxHLia2uepE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=WpvTSbqk; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="WpvTSbqk"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-47118259fd8so24631725e9.3
        for <patches@lists.linux.dev>; Sat, 22 Nov 2025 01:57:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1763805427; x=1764410227; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jz9kXapfXThQBJmIvVtPBo1fqBtdPm5tbxV+npzEXp8=;
        b=WpvTSbqk5YoSQdis+/l2uFKMMvPUJ42yu/zxlXof27hHxyZlPlvqkODYr0dvPrdgoL
         4/b7zSl1chIDZbSq9gYmCjge0vY3XLZtH8zMgEky9aF79vR6BfoPWx/C6bXZNm19hefS
         UgTsWa8zS4UkHtxvdQV1RS3Qdt/8r3FmYoNaEAiOCYob6tjzGks9tMjZsqVaSzolpx66
         9JZkJyefE77BIhHon91+OjzaX2UbYWD05TFaoyFglRSFCUhdWQR96sA90FElsNfWBA0J
         7EgO7HADvcVHYEQqkk0X/ENF1fkuaiJ9hXXIAnlRz9QaRmnWJDIJfAIkmW3/1wjOxThp
         J4BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763805427; x=1764410227;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jz9kXapfXThQBJmIvVtPBo1fqBtdPm5tbxV+npzEXp8=;
        b=cXtpr+iDFIiucngnF0UQPD88pW90g6dlV8gsTCrOKlu18qOX/SiDk6knzgr9bb9YT6
         PH1QLwrX+akj8TQPhPs1FrbSSlK7LBUkPrufU0/u74Oc9oCeCe0S/lxfid+HvPOjSLft
         0fCvLyjRgQtZabJwJLbx9inCWbmfLt1D5Ykea2FpJQ+Dvr8MmAgWSr+6W2xjf9ckV0hu
         xTSaqDnW+kQucw4a9/ZNGad42UtEkYoVEXPTeoNdzUMDIcHT6PE/kQaxqlk0hJenmHaD
         ZwVO8Le1bahhJJiyV2W292En2t7ICz8eC8rhWLvVVsk6w+nypxAMnqcbvx0KQRX+w4+W
         2Yeg==
X-Gm-Message-State: AOJu0YyJVPoJ6aUyacT/fNB2hCoHQbmpGHZEJotUbAY/eHyykC51H6Tl
	Jl3TdyYa9h3awgAVxnZNec1R7ukjWTaH5Ef+eHFM2cd920eZ8lqVrMcEnISRx1A=
X-Gm-Gg: ASbGncs3+MsxVeNfAIeSOSbp4rM5gpbsV2oT8EsoMeHVsgj4anLCeKNKTjPN40LEOsO
	wloX1FKnjTTulhQkXSDy5DFn59Zzf/rBsOiEJDAAfdsEiigTDIGZ28m99LYZfW9gXqOfVqt9jNX
	rY6g7GKfhIgzi56mNCaQsvhjlflfT6zwaTbM9DCiCH1JrS2b0FcHiV3r1tUo1yKz5KroSIo+t6b
	+GuXi6U64xNjLvyBriNOGLZM4bUj57PrTa6+n29bSQPSeH601IgIZM1gP9lzQSqWSQ42yLV0cbW
	IhwRdsViW+3bbtYCfR+fN5Oc1cMja9BLCvqfg6+sYIf611TdyV7xEcQaHXgPqYEBpITNx0mY5E2
	964Q/u6WlNCbnnp6rYC/SjEBjG3QodVe2e/onAF+iotESaU/+hkgUYhK0tMzzZ2cYyiTVsJd1HD
	M6FrMLQbo00OoFXK50+o48K09IKjyp4sZKJ6J+6w5N3ksDt9k+T4mdst8JhRbqfA==
X-Google-Smtp-Source: AGHT+IEF4X4a2a0VmDD1A4naVFLH+o5kC9UOh5bWGAlH7UrcD7UF2ip4OdVzuxLdO7IUKVhFQ/S5Dg==
X-Received: by 2002:a05:600c:1994:b0:477:a9e:859a with SMTP id 5b1f17b1804b1-477c01c0073mr48228515e9.22.1763805426989;
        Sat, 22 Nov 2025 01:57:06 -0800 (PST)
Received: from [192.168.1.3] (p5b2ac108.dip0.t-ipconnect.de. [91.42.193.8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477a9dcbca9sm103393785e9.6.2025.11.22.01.57.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Nov 2025 01:57:06 -0800 (PST)
Message-ID: <0dc36230-e5ef-49b4-95e2-e9d76d7eb871@googlemail.com>
Date: Sat, 22 Nov 2025 10:57:05 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.17 000/244] 6.17.9-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20251121160640.254872094@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20251121160640.254872094@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 21.11.2025 um 17:07 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.17.9 release.
> There are 244 patches in this series, all will be posted as a response
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
