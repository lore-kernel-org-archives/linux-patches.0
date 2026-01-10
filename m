Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5084178F2B
	for <patches@lists.linux.dev>; Sat, 10 Jan 2026 05:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768021434; cv=none; b=ClaPwohMRfFNVGj6PPYxDFolIFG+vNd1+InXbTr6lAvoyefkiYZ/Syx0N/xQ5gL352K7Y0chu6/WEnBrm8435rSWbm3gmMr7vwwbAhkP/yeOy18/hk5C2X+/icOQCzSvn5opDAyfkwIqByznLqgvnuzCFM4qVB48GVCbkBb1wVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768021434; c=relaxed/simple;
	bh=QmsyRyupDkNYP2ROO7/MGNRneU0BZcN+NXktHjtRr6I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C6q4nStPAx6lmvYgD18nDm6UuhA6FB1cHynsaZHhN7Rw4HQySm+MehSdQohmnoF5tlw6ZgZIfvdgKkBfvW7kj/lw5tIy/RpjWzJbH3mj0ubRL8F48p0U2/Q6vQE+mdtHpoXxZ9t9s3t5I99tIhVoX0Yp2NH5BPJnO3wvR0yDl6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=PUstguym; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="PUstguym"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-477632d9326so29617905e9.1
        for <patches@lists.linux.dev>; Fri, 09 Jan 2026 21:03:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1768021432; x=1768626232; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SkfwYNksBv2+Yd/5xYDV103bMEakN9vgXSxeDSRzLns=;
        b=PUstguymW00Qpmr6KAUemX1PwQwyIV39Gtces8v5f4dRIqt9PGZP1v4dH9Dj2JqK5C
         J7UPqb8ocAPqthgFSDv+O5jLatBNCicaOpWn5IzQ0Gs4kDxHTtmPFHwRxk8NpNDAvlfz
         fAQAZQBCvVinS2qqgxLsXroJUnfSLzXzq9kbj+hJnKwcaeQMg12h7BiIvHfY3NeLJ22L
         b5wmmbQLe78yaIrPrFU0m4hukTVUKA0oO3SyF5up9FQmV5ayJNt/JGr3UUwpLF/+tqZq
         uxtEYhhvF63VWmd5zZr1zOfhizH/ZQUTXztgc2ExDCdQK6O3njmNAW6IpwW5/u7Z6ljY
         Tx+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768021432; x=1768626232;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SkfwYNksBv2+Yd/5xYDV103bMEakN9vgXSxeDSRzLns=;
        b=r387uA9ugFqGXhRV1pb/VEEaOgnf5weqgAHJSNLBAPorgh/zvVQiRpJyRrh+9WM++Z
         hO6Uxierq4LZXlwgopYYl3WFqKykAC6h5Yx2vrJYuluq6kokR9aUj0mZJtb4u4RGYRxP
         dBKA2z866Jz+hpsTXlabo14LcBC4ojkD+6ljaLtcZRWD03NRliGvSb2A5jwzYkB0jwrl
         V3GMIqq6ppMD5pw9dfii4RXdKwMyjXDDVkCPficKCIdjI8WRJU22464TcLlQQS3L6LKk
         vPQ681PZbGHUoCEVSnLr5rJu8ZOhX0WvyWt84uf6U2GknG3QjvMJtC6bSVwNVLKfFlI/
         vIUg==
X-Gm-Message-State: AOJu0Yw7gKOj0qSEJovv3kIo3N7R/02BbAAkaHB2bEZ/s6mYMMq0OuNR
	1G5p1QORlzjCjKKtB28LwycoPAUdjYzR/AagyabPtK/I90Jviw0aegE=
X-Gm-Gg: AY/fxX7wdL1G4qjKimZoBkXRAL70fqDKnra4ku7ie6AoVGoz2tv++snmA2G4ECE/3JE
	mDQ/YAV2JFkw2CcGALCJLdqBgzjrdUr+iGig6+RAgwhcHI8xiQ/0BhYOeXxOYXAR6pMKwJgwqoV
	4SUmASMD0Bl2rNAb57cnu4Xj2mSGjX7RvUlkSoulTDMw3HvtNIirL/c0dl6RU9U6FCVgZ9cCfx3
	s8TsWjVqOR5bIlR2U37YqddcKKAqs3EVb6E1AFVt2/VJ8D6p+QH1xIW+PjbXviB7Jk7F3C2VGht
	IQ4fsPPzaHAdC1SDEXz6DYklZCo06ibhto3bXACDdtQePcnpK5dQj4LWBUrMUjLJZ9rF7+2wPbk
	7ze6hetZL+QjWdNbz6FAH1jpPes07YEpZdVYzYBM4FFRdk2u5ok/Zw5KV8BewReIamPCW4V+PK1
	FCbQje1S9js8BIRsxhQ3ajPxEmx/YEU8IcD1FBqsYHmJaQtUiJ0XeACne3fU684NlYK5T6Gpcdl
	A==
X-Google-Smtp-Source: AGHT+IGK1885DvIghdc2ErpVZT0GXmuDOF8nonISDwojI6/iV81wnB9mskmxzwccVmERFAtKKnC2gQ==
X-Received: by 2002:a05:600c:8706:b0:47d:4047:f377 with SMTP id 5b1f17b1804b1-47d84b407e4mr133081615e9.36.1768021431478;
        Fri, 09 Jan 2026 21:03:51 -0800 (PST)
Received: from [192.168.1.3] (p5b057af3.dip0.t-ipconnect.de. [91.5.122.243])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d86372c92sm87105195e9.0.2026.01.09.21.03.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jan 2026 21:03:51 -0800 (PST)
Message-ID: <dd29e500-22b3-4583-a92c-e338699d7882@googlemail.com>
Date: Sat, 10 Jan 2026 06:03:50 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/737] 6.6.120-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260109112133.973195406@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 09.01.2026 um 12:32 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.120 release.
> There are 737 patches in this series, all will be posted as a response
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
