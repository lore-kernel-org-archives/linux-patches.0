Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289DA1EF39F
	for <patches@lists.linux.dev>; Wed, 18 Jun 2025 06:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750228753; cv=none; b=H9vFBfq9EzGuCUg2ok4xXGhEbx14WnCH9Kw/W1xi4eFLgwIEfLvYdeCHGa/HWTUwIG+U+yzpgnbZtdUNeo/ClYXKv2f92Ez0agwYSGe/y3L4K0GHRj3ltVhjwA3YRSMz3HWF1dwLuh5yUPZOYFfdSHNwlWa1SaNUkBQ3JXhvRPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750228753; c=relaxed/simple;
	bh=yLKXkq2hWzm+CDK8b1OfCGIFmkTLFTnZu6jQ9olvnQE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RhqqRmeYZ41uGmypjAuO4VHVYc+n6l8QBdYkfdp9ePX87FfeSvzqqjRZAy8y9qlHs/NPCy9q+jPlAY9MC6osxQsN5MnsCKi+nbdamFIf1BvYy38Fo+lov8KFT6N/smGYRRng14u23Folz/iw2GvZn2lZpO6W2QrB4uA6+TFzgig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=dfjy/BvJ; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="dfjy/BvJ"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-450cf214200so56044195e9.1
        for <patches@lists.linux.dev>; Tue, 17 Jun 2025 23:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1750228750; x=1750833550; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YZvA7RNXYnHWimVMEH3iW3e9Ck0yo+qhfNRcio2uxRM=;
        b=dfjy/BvJkw7FCAf2JKDwD4oVeNZ9QIhQQMjncWJb/zY8QQVG44WDe3PNVjHzcw/IZ7
         cNoqtZqRQcEr6bYaeD0Q0kycT6JKOWw7RVycKNC016fU6OQZsdQp9qrziEnVLn0311Al
         X8LOW09kWYmRq04r/CDSTFFNBRBk4/IhssFFFwK0aI+R4uWt5YVga/uNqpXJVSvcewJV
         +QaniSO4hq4dlP42ZvS3KC3Zc7ZcebQuaDqI/QCOzntLzP4NQvX9fWsj92gsi/PqlbSX
         0g76K9flaT4RstWTxWvaerMPPp9pfyEaL/O9AmxqZm+fLXud13nva0C0OqIPkeqnBh+I
         aAdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750228750; x=1750833550;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YZvA7RNXYnHWimVMEH3iW3e9Ck0yo+qhfNRcio2uxRM=;
        b=B1lsenK+EsJci0yI9YK9mTsMviV0yAWfN9J2troR/+KC0qhLOGKgxAW/IrXV+Xs9vE
         X5zonHPg3lJD8IrSct6qbCGR2o8PoP75gJ1Jo+CCf9ZD2MC4P9XsfDe0g9fTVfVe5PDD
         b9uXW7wAhbc70ujvtttRbVbIiIQfxPoCwYmF5DmD+ydXicREzMeNY0xd8Ln9//qYSyMQ
         Bu7Ee8qwCDvkxxSjg6JLwYS1NiA07caTABEpnBACaFcDdfmPl6TmctCL2QUOxY0ZDxhF
         oh4dDQkKAL5wW1QrnGXHeYCgnLcFfl0dmQ+b52SZoAoSLlVfuo4nJyD+1QUEexdw5hGi
         F67g==
X-Gm-Message-State: AOJu0YxPSe14NnoaiD/GQW3Q+dtusS02kRQ3vqBfAPISCrwbOkX3voU5
	bANjf+57yVj2yTcqwqlVum8Eso13zV0hKE8I2O69VtZDf7Q/PL3yCeA=
X-Gm-Gg: ASbGncviTHDjwTEJQLzZ/nHBskdW4l2YKhJ8evsXX3JRbKoKO/xfBzF1uJ0gyglq5Mu
	3iYgLWevLctI91yzTTFUXb4sYLpO4H5afXUsejHjmseLbFClI0X19E6wFzsJZomEprnyRaA2UDb
	IbZsaZJUVzuokXxGx//ccDac1UCYYtUZzwJXUWObeUvB5Y8sb4/QGc/U+C9TdjAw30i2TgGQJKl
	OLupKR3okxa16NvHUvtSm4NSLVc91k//WABO2LkeAh0RHqmMg3xxseyhoGOz4SoIEltspipvgVk
	/j5lwZiN8xSGia4TIBFfDa2bCQo2Pa23pWCwSeEu4RV25G54SzdXc4jfL4bG+fnTIj5yPKtWoJj
	JG9ivGEXRVZxWQIoqcpvJpz46REI/B6Y60w+xNg==
X-Google-Smtp-Source: AGHT+IHEtfg3IB7HB1Qx7tkzhra4fFOSKPEVHYVs49aCIYi4XUVNknTwWAyV+lGHTwurGsG/s/RK4g==
X-Received: by 2002:a05:600c:6211:b0:43c:f8fe:dd82 with SMTP id 5b1f17b1804b1-4533cab86f3mr152258125e9.18.1750228750144;
        Tue, 17 Jun 2025 23:39:10 -0700 (PDT)
Received: from [192.168.1.3] (p5b057357.dip0.t-ipconnect.de. [91.5.115.87])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4532dea1cc5sm201907855e9.16.2025.06.17.23.39.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jun 2025 23:39:09 -0700 (PDT)
Message-ID: <22e04ad1-2267-4dea-98c3-6fac1a4edd84@googlemail.com>
Date: Wed, 18 Jun 2025 08:39:08 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/512] 6.12.34-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250617152419.512865572@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 17.06.2025 um 17:19 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.34 release.
> There are 512 patches in this series, all will be posted as a response
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
