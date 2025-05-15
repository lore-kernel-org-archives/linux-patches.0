Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC4920CCE4
	for <patches@lists.linux.dev>; Thu, 15 May 2025 20:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747342688; cv=none; b=XOOvHwdjTJT1kQMxHhGud4bCvNDoB92YFqCmE0TVFiom8jWRX1wnJkJd4qYaLCcsbMOY4XWvJMftPA7GlEBRyOo33p4W84EHEw0YWxEkR+9MgPnFpK7AuBmWvoIumMh0AaHcv9XrKtI+sTpGqsf8sw46b2DyEc2+yonip8zqb3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747342688; c=relaxed/simple;
	bh=21dSqdN6f0BAIZMZuOM/DzYxEHIJQ+4lqQxhhd0kMes=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SkGlALfJ7Y30CT87WglCDkfvXDlg+wb5fhNj6zkV+j5u0xbvWIGREoU0THKD3Ik+QCpt1TqK2ycJ2a1NXsJraM9mkB/Ni+2YW/HO3YSue4pVc2G5FWX2Rkf2Lfo84wvslX1PxL7TsthHDg50L5mm6ZTE/z7DGCnz0ZBo8Y8LNtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=Q8Rgz8Us; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="Q8Rgz8Us"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-442f9043f56so6300095e9.0
        for <patches@lists.linux.dev>; Thu, 15 May 2025 13:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1747342685; x=1747947485; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZpW7hv09hrqBEEyMb/8uxWZH/simIUVzd+OZsHMzaoQ=;
        b=Q8Rgz8UsduMhD9MhrsEbQ/x5bAlovxNH67ZFvmRaE5cdHPHpXwNvUPPw9Wq8M2eFgy
         noL4Mps84BwdLkYiVJXUUULWo8Sjt9wxrbpVw/6mXnKO2nyKfJYzgap8RLzBl2B1NxD1
         oe0t2oD91L7ZotYjhorMPOrvaKXJPWbGLhKABUDapCAuW4LmSQ2K1SLUiZbKCZ42pkw2
         q9YjJQW+T2Xolhkw9lwcTO+BxFNUMFuWavhU51FJwajvv7lgOsSbkZnrnFmynHfLEVG8
         3t5PFY9QBdztmXxmiWtovpeH9Jj6IKaBUI1sOW41n4KxtWf+Q42CM1CPVUAQqTkWe+Mz
         PEMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747342685; x=1747947485;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZpW7hv09hrqBEEyMb/8uxWZH/simIUVzd+OZsHMzaoQ=;
        b=RzIPITIbog0+0ybI+RnfKq3o2/zNR5uIYmL8SJtYhmjfs6OLoXISQLJ+vZW8/Q+hO/
         inAYCZcEMndjQFIaUkZrLOBokkbxguHUm2RadoYOZs7WFYelefm/mw0HsiU9iyb1Xe5K
         NNnG6PRJaLOujJCWJv5rUhiTQ5r6XqiBqYmVPl3NreiE7j3JSXa3A76Lm6ni076LJvNK
         IjNB2erP5y6RMFfVxDiNCzxOX307zGRaiZjfzf7N97k3sz9huYdoXXk+3+fe/NjylW6g
         JUEj1p1zjvlANd2f1AvVCZ0UFUleWzj0ho3WBP9GxV2pc09KqAcY4ZBtnelQo0GNu1qz
         wSow==
X-Gm-Message-State: AOJu0Yy3DTde6r76/0KtGDJ6IgM3xc8dMFiTe/Vny1TC7Sy1IiNYZYJD
	iV+IBOQTe1yYERPos5chXv8Dwnke7eCa3+CIWqLZQEkh4wlQ6gI4dXw=
X-Gm-Gg: ASbGnct2oNHUV0rzGPn5bUV7mlAkjR8jRbJ6wJ5MzPu1IBmO9lizQPQ4rb+FNmRaty+
	2tlY6qWUZ6J9cUhCx3eb3IGAx0hLS+MILiPPi1217Our7wTdF1+bT/d8YYPsBXun/LUVIuWNH2/
	FoEXMDBRRjQzeme6MX+n4EY8yMeJEuAXGZnzsqv9roii5+uIq5QKjP0+/uvWvvZ3y5KLT4DIJn0
	9xJYo5iJCQfjPnw6baZ6+iBDsiNCAe6BjElEf5sy+2c9F1ojwe52p3hLVLOrmKuWR5aJFKUiusD
	dCuWdc3JE6iLkfAarfk7wJ8TZo2zV15DbzlNHeAlWouRog9uQc1qmZ9hKu0HIaJeX1/tDotERl9
	iq9lrkVz5yj6Fe6RA4cQfn6z9Hg==
X-Google-Smtp-Source: AGHT+IHAUUDTqgPWXcXetjIx0Km+QEVH26IKZatTuvSC7MLKW1sHvOGyuyw6u/DD1/hJ1Pkuf9RRzw==
X-Received: by 2002:a5d:64e5:0:b0:3a0:a19f:2f47 with SMTP id ffacd0b85a97d-3a35c853278mr1150277f8f.42.1747342684618;
        Thu, 15 May 2025 13:58:04 -0700 (PDT)
Received: from [192.168.1.3] (p5b057603.dip0.t-ipconnect.de. [91.5.118.3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a35ca4d204sm611628f8f.10.2025.05.15.13.58.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 May 2025 13:58:03 -0700 (PDT)
Message-ID: <685a60fc-d6af-4da2-bab7-1470e395ca2c@googlemail.com>
Date: Thu, 15 May 2025 22:58:03 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/184] 6.12.29-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250514125624.330060065@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250514125624.330060065@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 14.05.2025 um 15:03 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.29 release.
> There are 184 patches in this series, all will be posted as a response
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
