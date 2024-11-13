Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3B21FAC53
	for <patches@lists.linux.dev>; Wed, 13 Nov 2024 18:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731522906; cv=none; b=InddLZqmTUIxJBq4mdeYj8bHy/FTGEs0dVAsJJXSfVsvI86kOKS/eGiLjH/jfymVLn42eVdwWavLu7f3ArXJqh80+BG085At9jk2pjFnBTSNkVu0UdBBzoCR9UrOw9txTGiIpFix2/f0Y3bZUbjfYIUpt4wcv2P3t1214XhQEoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731522906; c=relaxed/simple;
	bh=51y6F403UODXm3whUG/pdVxPEOiBvrwCx/j54xJhKgc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OdfjZe4tZenWpZgedjtvsgaAmZkMVE19f2OmFvV1Tsvcc9Ct/2VwOJv853dVEUZsBjyv1fXX3sdnEJY25KWDd3Q35etWEW5dQUTPyj4OibQbHb0yBWxWHNxdlA5sGMKqHn3vrpamTwSH1jFzc00V5s6WGKsg3AO51nyqgz2yVB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=CcIZl5Ga; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="CcIZl5Ga"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4315c1c7392so64330865e9.1
        for <patches@lists.linux.dev>; Wed, 13 Nov 2024 10:35:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1731522903; x=1732127703; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dYIrf86hdksI77/Sc9tKNsGUwcT5OsY2/UWt/XQJeXc=;
        b=CcIZl5GaCKtjxdrXf5rL5yqB4jvGp4ZzXnYEIl3zsbieb6DTr4ZY/ua3p7aj1XmRxF
         sAvuBllbiUVbilfy+lacEZPRGDnAiida5FbT4cyFTV6ymhvDVYaE71XsxxRQkm1q9N1B
         NKUcuvvOILiWiF5A1T0KUQ0OzUTrcYXgUHY1/hf5JEjKdk3hWcS2c9zlLvXESQh7xn9S
         o3u0PzPejXuCTzg949kDeUWet/AnDte0dLl3GmxKi3RKnmhhSL7AeYMFql5a4vDpKHs1
         w1/rAW5Ml50nGexTqmp36oWwdWdM7DtHIe9Sbtnfapp9itcRBfMq8uvLfLkSdjpMK1fH
         tJrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731522903; x=1732127703;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dYIrf86hdksI77/Sc9tKNsGUwcT5OsY2/UWt/XQJeXc=;
        b=Sgw19ZU3CoMrPPMd6wkwBOEbCnKLitLmDE5iJrOYKZRmVr9QE/2LJDOi1JP1rEu0Ek
         hJbuNLvBeOOQ1FQ1Z4ZGZaLmhsBgRBz/DAEotoZCv+1D/I3eK/pX1Ujd1cR2Pl4Xeeh2
         ekuW50/AfaSaBlp9DtfF0QaCPJaZQZznhqiECh2tHGk0B+x7NGxQUM/kfV6sBv7fVVW+
         WfGUR5ODsjzDNDuEj/pY625/9YAxi2nrtRx5av9vcoZPUlIpC93AhBbXFkiZwqWhkNRw
         n3Wq0RCbdeTYCITn7CYMBmibvUXy2RsgLGNTTya18pLLDOlQVLhnwtjEHw3Z4rnqbNWt
         n0Kg==
X-Gm-Message-State: AOJu0YwvGn9ts/yjH7dDyonrx/sWqY0PvA/ZyaKqhXqfKD2sQp1T34N+
	iGgPsKvHnOyxuueS2CqKYFlbFqKjVnsT6+jlS4o1qOvzBYwFT5M=
X-Google-Smtp-Source: AGHT+IEeO4H3EiQmliZJ4Ro7Hz8QAOIdCTKTPH4cJ66FtGc576wuHJP+9pnAHNheyygcVbO6WfXt8w==
X-Received: by 2002:a5d:6483:0:b0:37d:5364:d738 with SMTP id ffacd0b85a97d-381f18813cdmr17524979f8f.45.1731522902692;
        Wed, 13 Nov 2024 10:35:02 -0800 (PST)
Received: from [192.168.1.3] (p5b2b4ca6.dip0.t-ipconnect.de. [91.43.76.166])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-381eda05f89sm18952980f8f.98.2024.11.13.10.35.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Nov 2024 10:35:02 -0800 (PST)
Message-ID: <e7260f30-ee8c-45ac-b0d9-55f2f260989f@googlemail.com>
Date: Wed, 13 Nov 2024 19:35:00 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 00/98] 6.1.117-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241112101844.263449965@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 12.11.2024 um 11:20 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.117 release.
> There are 98 patches in this series, all will be posted as a response
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
