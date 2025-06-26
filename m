Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E32B2F1FC9
	for <patches@lists.linux.dev>; Thu, 26 Jun 2025 22:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750977245; cv=none; b=VkB3tm+hvDhrrg/4oNrBvpjCjAtFIT1gGG5+6ctU01Ciqzk+ejY/P3pxxGVjO6bcEh4nWMBWUWPLpbsuTp0/qCSvIenu8ljLstz9TbVnG76X8ojMh20pLW26Wk9DO3D3SpY5+puFkI42P59dpbKVjt/WAvbhcgdmwWAHd5f7uyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750977245; c=relaxed/simple;
	bh=Ml11YTIUf72xieq1cUkCUHiMB6pPlDArwfbYfvU7a1w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UI1OY9SGCuNO9tl4k0I989eXq4moVDs8L4h3OjdiWbbrasKWh8fI38Adyw7MulvMmsZ4cQ6fwBPbSqt+0HWWcF8u3Q64zC0tnaxSMHWx7jim3OfK2KzNPs69NveAb/Z1yg7153QqO2BMvE/Aq1Hb3iC7YgMPcNaYsvk3xAAgtOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=kljsoG+k; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="kljsoG+k"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3a575a988f9so865109f8f.0
        for <patches@lists.linux.dev>; Thu, 26 Jun 2025 15:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1750977242; x=1751582042; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WRr9Ckwsw7SMw3MOv9t/vxBNGytl36tGaFii8n1LWHA=;
        b=kljsoG+kntIQFtwdP1Smuqc+6nkR4m0yS8D4jvPNS+SyR/ER5AWBa8Le8Os32qpW/a
         PNc5gUuhFGUbQdVbHhn5EI2p1At1dk3WgQXRdvMpfKpHsmFlb+xVmIl24025iWllv7nw
         5zF76boG2JZlQ6/iFSkqWqu7VqSW8LthIBYzF1gw1L74DODaqJRcDBZH9/B7L9UcOa+u
         7n7Ssky4FCWeGr7fRHTi/6wYa6pXc8CjsP4peCcXyxZLj/+ylCU3E1Cz+8l0j1WCxEgG
         /8pntp1p09P/nJHKLC5aOVXNhUWHOaUsIf9GGf5Q137byZZB09Euq/YyDPkm+tzLeyjd
         VUCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750977242; x=1751582042;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WRr9Ckwsw7SMw3MOv9t/vxBNGytl36tGaFii8n1LWHA=;
        b=oCdeiy53sDQPsfxRaGI8rbCtovtTLdLtm8eM3Ox8gFQsva7xB4J4Zgk3VmhIf8tTR/
         4g8+/KamSU7MAn5A6rtseUibKHcTw5UM0W3iKu2L2dq205f0/kfIF521IZbIJOLHjtHo
         uTrA9alawjqO54TIN8WKfvsm6f5YasQLgXN3LtFAud5dayAumFee4i4abE3f/Ayt8iHO
         BKRcBzZogYmr8p4B28saiDt2a7LrgDUftAgMD60L7TKJvKkjME81gibTqkeQDUALQbKe
         UEbsPOl2SNVLjpJTFFaYfTj0rn5IGF5oc+XCCalKU8RV/YUFmEWmJ5taRG4ItkDXkoWM
         XGIw==
X-Gm-Message-State: AOJu0YyzzsV1P5HSo7m6Cb4eCs7vTcGFSSBfCcpvBqb6FQcfuAPSryUY
	oWL5jg1MbhMTGRhcazlATZKu2IrByo9GlU9Mr1g/HzjZRaTEmr3x7Pc=
X-Gm-Gg: ASbGncvun+WdrT2DPDDmCY6wgm16SdDg1SoBSUnf53ojc6RH79FhPO12l4gVtrmoP2W
	BKSYy0yukGtSimzOPJvbulRJtQKHZmPQH9XeKJGRRR3R0PmMiP/nZ9fckYt74BBU4TuUsGlKDa1
	9qD1ZWL8AInSsp+JvW+PsM5jAwjW3mqZqhw89aP2KiAb1EAowJTasgFApQWnnTSOZmon1IuNUyt
	YjIQsuyn7V9ZTTRRnF2cglFKF+meFO6OWugw2BgpfIt6iIm8w1hKZO1/P2Y7rFgXDGM9JxeZ4bm
	UR0NJqY9F/x7QO3rBRHw/skVEFjUbk4vV/NMDHf3AQrCLtCLorK/g/x5ZVqz0u/jO6IDljRgBBC
	ZLg7D4MbnBBdJBV3NtvgqwkqFBejtnGSk1FEDztgj
X-Google-Smtp-Source: AGHT+IHE3mEWCOk2D7NMvKDWFa3ExDj855vpBsW8qfc7kytidjqXCeSA1XBf8xHQ9zw2M4DUiOWsUg==
X-Received: by 2002:a5d:64e3:0:b0:3a8:6260:142c with SMTP id ffacd0b85a97d-3a90bba866cmr1146249f8f.59.1750977241795;
        Thu, 26 Jun 2025 15:34:01 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac2b0.dip0.t-ipconnect.de. [91.42.194.176])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a88c7fb20esm1026644f8f.36.2025.06.26.15.34.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Jun 2025 15:34:01 -0700 (PDT)
Message-ID: <0614617f-be49-4771-8bd1-1b227e6d11df@googlemail.com>
Date: Fri, 27 Jun 2025 00:33:59 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.15 000/589] 6.15.4-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250626105243.160967269@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250626105243.160967269@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 26.06.2025 um 12:55 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.15.4 release.
> There are 589 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

rc3 builds, boots and works fine on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No 
dmesg oddities or regressions found.

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
