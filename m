Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DFEB8F5E
	for <patches@lists.linux.dev>; Sat,  5 Jul 2025 04:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751689216; cv=none; b=H0NlaA/mBJqFVFS1mAMTC4IL5q4NNXuznJJByOwNKV/ZQuTh8wJY5VaFbddxDUIIT1XpCclCFQ5vqkNtiC6UP56VULmACbqfxK4dqf9iu0wXvWuj+zz6xW11DHGh7MKqCjteyNLruvtGlVNfTADhGqalG8GJUBMwjdJYby0RaR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751689216; c=relaxed/simple;
	bh=PP2tBK0K+j9zNRE3lMtMvzqQ+gaIJA85DfLOLawjxDw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KQEZJnd5i65HRDWHBmhe30iKWhGVLA3inqVR3Evah17RCi9DNbUjSjqr02ds7C7qbdOGlS5xTGQvxGp7NsHdfNUg/ZstZl5y/MMqGXhnfF/pTWjf0CjJKhnzOfL1gUYUcbEZVsCMImd9x9UoUqF0x1ov4509dmKvRZh9hzY/p2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=X84ISKUa; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="X84ISKUa"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3a548a73ff2so1429655f8f.0
        for <patches@lists.linux.dev>; Fri, 04 Jul 2025 21:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1751689212; x=1752294012; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4QX5ca/XQ9bTQip0jvg8XOVXm9dQiuDFX8AvyvylwPg=;
        b=X84ISKUaP9tNqmfSJvoCXy3scFu1Fy/kasqmTM/l3/suwoOevP9X/nLIX9e+n+qN02
         J3ePq+8LuIoq5UroUY3DRsVIksjDAvZ8Wes8iaLbUPICGhJ2VlWx5hPdvqomEofZesgn
         0Wt2iGLGXKOwel4kNZK6abTlXvzyyXkoxro+GZ0xjUPdISoXILInDDiaxCYGiSh+1ixK
         YS4/ty7uczVYtH4/pFxZgb3fnimtQTJI8MnyfpY//52NOno7PmwDXaMXVlIe9YnU7v06
         AFXE812fXqumufiOsU2SrmPXTfFYdd2u627a2SsiAeYkV6eqUbsGXzzXRdGmfXVjv+22
         ZppA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751689212; x=1752294012;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4QX5ca/XQ9bTQip0jvg8XOVXm9dQiuDFX8AvyvylwPg=;
        b=R2uT0flmY6R/A//XOGfFFTQDlxzYN+OB/wNO4dIXb1anN67FgQOTI7UI8kVLR6d7es
         3UEtiDs1b/2/rpWJ35YT08NxIN+LYBxsdvRS4KRVameLTctijEApFhOpAe/WSHd9NCqf
         2VwQNY5zdxSdZFrdPwOselZNlQMkpiNilEXte8kCbHsVI1w0RaMl/+7WhFo2BefyhuB+
         0JBLcWeU5Q6m4dGWiO+/gp6TZ2Y1FVLq3uVaVram65kYXmAhna0V5AS6hqoMUEgsRdyB
         fOOscpn4LhGCe5YGr2r0FGWQ+zBW/2IEFiF9Yo44hzwpj4pgOwhtkyUiUjic/3489Wp8
         i1Wg==
X-Gm-Message-State: AOJu0YxwMsMHbGNzW7ZZhl13h4SeaGq3YY6Ux/pTu2XlR/6Q/SnPhGjf
	QnCNxBsOGkWXQKsGpt3C+ttGBTIkWl7iJVduJQ92Z86xFOjYO38EICc=
X-Gm-Gg: ASbGnctxN9FLviUguwhJ9B4QOq+3T831o/+w7lIiitqtNTnLRzZYxfSI9+4VL0/vGSr
	n3it0rmgb+M/NvXJF+iYhraRmRQwxcVO8eqD1MaPIE8NrCk1w8aicJ34mK+otf9z9cca5syg7QC
	C+WHXQi3xFj3VducByVe70UoBYwM+9DDHE4o9QIyDrAAEArHFwsd5ADGh/YwFkA6CT9ciStvAPx
	0X6qGVOqD8HWedNpAWSwPbfwr9NWZymSLnc64IkS38xIvgdRVJGkeAEVDuYrJXregmu8ofPpKm6
	wreejaOSWX1Iy7ShehKRD3hwcCRJxSM+hvKxVqQvM57PDFgD6Zyl6rKurFfod886wt1iAx0+SyK
	ckfjjD7bKR3XkSv4dq1xSUg2XgLt6mAh7WtxFrbI=
X-Google-Smtp-Source: AGHT+IGq05/HzqDo83u3mYS0XfXV4K75ereAbVKbsQQVAGhWGSGG68sBKWSKgTF80QzAXxQ6JMiXzA==
X-Received: by 2002:a05:6000:481b:b0:3a5:8d0b:600c with SMTP id ffacd0b85a97d-3b49aa0e7d6mr505729f8f.3.1751689212270;
        Fri, 04 Jul 2025 21:20:12 -0700 (PDT)
Received: from [192.168.1.3] (p5b0570c7.dip0.t-ipconnect.de. [91.5.112.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b47030ba77sm4085736f8f.17.2025.07.04.21.20.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Jul 2025 21:20:11 -0700 (PDT)
Message-ID: <e4d40799-f59a-4d3a-b103-6c3e6f330238@googlemail.com>
Date: Sat, 5 Jul 2025 06:20:10 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.15 000/263] 6.15.5-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250704125604.759558342@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250704125604.759558342@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 04.07.2025 um 16:44 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.15.5 release.
> There are 263 patches in this series, all will be posted as a response
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
