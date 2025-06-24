Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2421A2545
	for <patches@lists.linux.dev>; Tue, 24 Jun 2025 17:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750784448; cv=none; b=jx135O6Skur6/v+ELzDIa4tn2fWiJNSlfAtWKZcitIl26yHNun+OKmRghuMH/4p0FbbiesH7W5s30FcuthQx3tI/wxk4JW/TyHRwA64WTAQnVRnPXdyxQ7/kURm2VS/x+CXfLR2dSfmQU5vTGStEu20K6AogBI71Sn/m95yUQ4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750784448; c=relaxed/simple;
	bh=rMmIIm4TINIxOqut0X/Io6lixllqSqzkHQn2mUnABFI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VtILmgNEzDIIlldrpjyrwDKEyR5NssOSku1a/mkzJhU0PqwktFYsfEREdY5LogXWeHmUCoyeWQrgYypx3WHwQjyLc+D5W6UkBr7JpvSiWap2kdZeICxeo1j+oWXjCYvgLYHW6sgtkTfFp6ARl90Dqi+DiQZhn50T1D4yp/aN3OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=BHELrhOM; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="BHELrhOM"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-450d668c2a1so503575e9.0
        for <patches@lists.linux.dev>; Tue, 24 Jun 2025 10:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1750784445; x=1751389245; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=te/STPrSTRQW9WE5N0wxDGPRRy2utQtxA+HuKmrb5X8=;
        b=BHELrhOMhdTPMzrL5jRvAZZLU/CVSCiZGZU33rYA5vCcnBgmJQUiTD5WZd3fM+YYiQ
         ML8EVinaJspCh5L0fakgXJsYiwP7SWj1ud0c9phQqDAjdy23RLeC9e0JT2We0mnjtdjr
         0AunBsV7C4qW+e1eM7i1WT3vwKhlTDhM+zdYy9T6A6xwk7aeJIsTNxKhYJv1R+MA3MZR
         xa0BJ8A+/h2Vn8i3sjHdDAIaxZ5IZT2a4cbInCAwZAbxUhH8K07rgQsR3GtEpirEzVf4
         xThDAdyAZDOokZguYmsCQWepGC0obuwGHv4xjQtKvb7TsculNNdvCU3geUKwS1n8hxO0
         Pf2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750784445; x=1751389245;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=te/STPrSTRQW9WE5N0wxDGPRRy2utQtxA+HuKmrb5X8=;
        b=aegqpCbxdURj3PcgOq2YWsJ2C/aF59lorFMRTf8Q5/cB5PUZn5mO+DOJyixIW8droK
         5llCRLKalJN8koXlZ+duAYBfCkkX/zyf3xsTAy/wzhIeDQbaHYfNxZ+PpHGpwetKHk+3
         T4zWsFbYLpAUrZyMTNFqRQlRpGRzO1o9sp6xSBj2fau1re4vN9TPvyWVVcolvYTCHnv7
         fLFzkHhzUwI8ytdMqXa99rZn+A9xfKsnY5bTrm4cP4FGUK44vPclMu2UAUnuvBEaZXx6
         Ez/e2nfSpaLFUgLguyHCXH2+6SuhEM5qceYrMMSdYhRs8N1uiPJwc1JMssooiP70+RXt
         yE9w==
X-Gm-Message-State: AOJu0YyQojrOK+wBsXPgOuCZW94xJVTdXNaM+A/iKqf1vAv1cLRkukAz
	Pezeun0aLxQvfRCQFizJBCsJkRHU5EbltAiccPKwrgB1EEC7LGibptU=
X-Gm-Gg: ASbGnctcrFa/PDqhMYJETtPLUS+DVJW6IySxmRmIZzu7psZxL6pTn4kMqi8bytPcz8W
	FodhF1jz8LsJjUK4aFKznHrJD/8j3chPpzJAjnD9GKoikR6vDqRfRD0S3NAHvklzXq0Nvj7+aWz
	0sKhy/yBsPk67dyrcMDtlb2Dm+alH7DOP+FUoHm3g9SyDn3guh7MPNOUc9KLLX9ieHKMP069De+
	ly9sPGOBUVTT1Qvn6b4DqT+id9a4Kj9HqiFHbbKLUh3nAI5sKcUsD/2yfAK95TThxQAiT/spLec
	scX8ZbUwe8bqtJtNKJ5235stPIMFhf0xj025VUIw1f/hlJ2YlLg/dq/UAnugH1ExpOKDz2ImDfN
	ofIaf4eaCSs5JE3VI8d6sSHj1qZD+DTzewDS7UH8=
X-Google-Smtp-Source: AGHT+IFUfVerv6+pnCu+sN8dHX/BLfNsI8/p8b9WCDAx95/po6UN9b2bRri9xUJSyTn8llRJAFZcgw==
X-Received: by 2002:a5d:588d:0:b0:3a4:edf5:8a41 with SMTP id ffacd0b85a97d-3a6e71b86f6mr3784089f8f.4.1750784444740;
        Tue, 24 Jun 2025 10:00:44 -0700 (PDT)
Received: from [192.168.1.3] (p5b2acd47.dip0.t-ipconnect.de. [91.42.205.71])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6e811039csm2338554f8f.89.2025.06.24.10.00.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jun 2025 10:00:44 -0700 (PDT)
Message-ID: <1010f821-c1fd-4096-9f69-49a91336eb56@googlemail.com>
Date: Tue, 24 Jun 2025 19:00:43 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/507] 6.1.142-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250624123036.124991422@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250624123036.124991422@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 24.06.2025 um 14:31 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.142 release.
> There are 507 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Just like rc1, rc2 builds, boots and works fine on my 2-socket Ivy Bridge Xeon E5-2697 v2 
server. No dmesg oddities or regressions found.

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
