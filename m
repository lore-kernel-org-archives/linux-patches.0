Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307B229994B
	for <patches@lists.linux.dev>; Tue, 10 Jun 2025 14:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749564786; cv=none; b=nVS9EEgA1lQqbfe9G1I9CbRSGEJKQJMxYUpJAsw6BvRib53aZIHSfQLc8fpKd9FT280XaNrUme/Oo/IS5AmfLcGFa4nMyMqAYxLGJZReld0QnZV7eE3fVpyzigKxcmLnbKK9RmRTPftdRPBphQD52P2WBBxpCYBYWp9Kyo0X03I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749564786; c=relaxed/simple;
	bh=fpsoKDI5uQBG0A/tf+KR5lMgKJjTIhz4S647EHuhAcg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eiW8uTqhT4+P8/wdzHuZSeTI4cHbH+o9XlBBOUoxKm5woB5hAZ7Mj47o50MseUkSWrge6MVbMfdHf8IORG84UNE7L+veCOCQ+xY+LgfcAZknbLAG7EFEGRmc8rZzwrob7EFwjOG+/0cdawvGEvIBLa24P643Txkrn3WDgfTCIfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=Hp3Go47A; arc=none smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="Hp3Go47A"
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-2e8f84653c3so1271445fac.0
        for <patches@lists.linux.dev>; Tue, 10 Jun 2025 07:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1749564783; x=1750169583; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EB37374BUiYYtPh0W39NXdXaP1PW8agQzueDQPq14KA=;
        b=Hp3Go47AMWf/XHaHX5D/o+l8AwH/4E/kvkGZLgFCcvtnGaM1x7BxzM3uBWjxorBJZO
         ipc1oTyL8K6oUJ8ckwvUWZBwZxe7Kp4pcmPavJ1ShkN5ultwFQ6aLb9PufEpTfVyXiOY
         81ff02E+Hvngr9K2Lq4i6Aw0GaxJ2RAk9/eHX3NVu5qmTVWiFRr6zAZIDkc06IsAPqvI
         Y37IsVg1BhDb6GoI5E9CWKzGKzwwaZ4l3ycR2fzeOvQNy2aHLXL3btwOecBn7tCJBjxF
         EbQ2l3y/afHJ8RHzA7dY9W48F2qNKpAz3WJvgOlEkzicnKozv0RhKiCJPSTuzGmON2Pm
         xQuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749564783; x=1750169583;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EB37374BUiYYtPh0W39NXdXaP1PW8agQzueDQPq14KA=;
        b=ZScP5RWHUdANf24f8RI7DKNrcmn42q9duo8npF2J5E+Y5swACVDZFwjtFP8HKVcMNO
         UZ5HFEIo6dxXK5Y5TsCAbpWVaNruoZ5ezFDeMvjSmE+Jvv9IPj0dlto0y9yhWFW+XuNO
         QxHONlsxSwOSQ5pUFFvP/TeDSJaTtnO9KC2CoZSUtyLJXRZiRfzw9evMsDUeazjnoqps
         HhX1bMeSaDIOF3WVROlolgmS5b3OWF1xvGuqfqffgUNazPsMaWhmjn/DkW6MRL5J72XM
         x8i7UI43m76CV7+izaypvaAExgkPIlei0UwukwZGRkgLix0hfdeGNRRTgmp7FqRMw5KX
         3BEw==
X-Gm-Message-State: AOJu0YzsbOIxWTaXvp2sJav+vi6N8IPa4BlBUhDNsZrCVpPjBqmFLQDI
	4etxKTosHdHS04Oh+sHlOiYzSWdDUkHGzpMEn9d9c38CydD/yQ2zYKWIIQBX7vDtBDOyc3jC107
	ivl4A
X-Gm-Gg: ASbGncssae5TdpXWVZqMW+kgrYovnqIhbb5tP+i6uEJNb+HjfKab5n7JeioRXLrcueI
	yxDUitDUtHfiqOXWOKUPsjtHSEHSAYjC+Tbf6z87+eTILH60vp7vDQcn/L66FKnlFXLK4Yb/k9w
	PCfy5LaYZTJ3DUgeAodydwuExWtsDASVBVZLFCQbhok0pF5qrPYXLurq24vkLYKYvx6SZuIzxTI
	6k6FDOSGrVmgp67wtJ7JkvbSaDVIdPKvrNpTsey8RclFBa4VKFEVzS2d0p64GpFV969wcd9Sez/
	RpfJBcQist3au8T50XHv/jM/JSpnxc0MFLdIxmIFK1TIftUui35c6s5NbM97dWBQ7UkEdDBuCs0
	mTODatmERh0m+Hz9ALZaKzAvT9/vVk31i7XXX
X-Google-Smtp-Source: AGHT+IHAbrcgd7SMwTbrASrunkgINOAH46uqCGl/ZheJKIvnseT/m5wL46bO3WtZ1gBizyI3v0xdYA==
X-Received: by 2002:a05:6870:1996:b0:2e8:7953:ece7 with SMTP id 586e51a60fabf-2ea012f1b15mr10055146fac.24.1749564783154;
        Tue, 10 Jun 2025 07:13:03 -0700 (PDT)
Received: from ?IPV6:2600:8803:e7e4:1d00:a49:6255:d8db:1aea? ([2600:8803:e7e4:1d00:a49:6255:d8db:1aea])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2ea071253c4sm2390597fac.21.2025.06.10.07.13.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jun 2025 07:13:01 -0700 (PDT)
Message-ID: <a6a4ab63-907d-48a4-8ece-2f77b16a1566@baylibre.com>
Date: Tue, 10 Jun 2025 09:12:59 -0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.15 30/34] dt-bindings: pwm: adi,axi-pwmgen: Fix clocks
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev,
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
 =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
References: <20250607100719.711372213@linuxfoundation.org>
 <20250607100720.893179321@linuxfoundation.org>
Content-Language: en-US
From: David Lechner <dlechner@baylibre.com>
In-Reply-To: <20250607100720.893179321@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 6/7/25 5:08 AM, Greg Kroah-Hartman wrote:
> 6.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: David Lechner <dlechner@baylibre.com>
> 
> commit e683131e64f71e957ca77743cb3d313646157329 upstream.
> 
> Fix a shortcoming in the bindings that doesn't allow for a separate
> external clock.
> 
> The AXI PWMGEN IP block has a compile option ASYNC_CLK_EN that allows
> the use of an external clock for the PWM output separate from the AXI
> clock that runs the peripheral.
> 
> This was missed in the original bindings and so users were writing dts
> files where the one and only clock specified would be the external
> clock, if there was one, incorrectly missing the separate AXI clock.
> 
> The correct bindings are that the AXI clock is always required and the
> external clock is optional (must be given only when HDL compile option
> ASYNC_CLK_EN=1).
> 
> Fixes: 1edf2c2a2841 ("dt-bindings: pwm: Add AXI PWM generator")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Lechner <dlechner@baylibre.com>
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Link: https://lore.kernel.org/r/20250529-pwm-axi-pwmgen-add-external-clock-v3-2-5d8809a7da91@baylibre.com
> Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---

Hi Greg,

It looks like the companion driver patch for this didn't get picked up.

https://lore.kernel.org/all/20250529-pwm-axi-pwmgen-add-external-clock-v3-3-5d8809a7da91@baylibre.com/
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a8841dc3dfbf127a19c3612204bd336ee559b9a1

The intention was for both patches to be applied together.
