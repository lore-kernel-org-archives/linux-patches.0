Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0405432D438
	for <patches@lists.linux.dev>; Mon, 27 Oct 2025 23:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761607600; cv=none; b=tk9mcKUkuViJ2C83F3/n68ynhXlO/f9cFf6od04dTyZAErmLuta7wJDjGGCJhZbmVG0nm5sa99QpA+HRTqST5Eo4xA7+MRYnyEEnvuKtyWUrKrqFuETVlNTV5jdz9e+Jx2fQgQ7PGQsP7xjGs/xDXcsJsrJeI2bFwEySL+8hEIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761607600; c=relaxed/simple;
	bh=Nbr5JRXmrsBLv/PGndUKfdr7dz6K8kLXCFBOlT6YKXE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vh90VQjtxemfJZWGGonFWouN2jqigzn6z54JW7wH4WAGSAE8nImt+GdWBDF9sv2X/d4AxOmwly6+Qu/rg2tLpQyWNFyRTXsJgh33HzBdz3u9fWUMdF6vR23BzNBnbEJkb9H/o302TVKLeeEmrKduI5HzfATOpTSca+U+xM4j5HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com; spf=pass smtp.mailfrom=sladewatkins.com; dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b=TAUKGONU; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b="TAUKGONU"
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-430d08d56caso22892825ab.2
        for <patches@lists.linux.dev>; Mon, 27 Oct 2025 16:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.com; s=google; t=1761607598; x=1762212398; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iikffhOT1WMi+y0dl8K7FDqmN86CXPbZoc1p22Fu0gk=;
        b=TAUKGONUVSVe6ruGB90b5XM8QBufNirFPZ9m3eSscxVBNiSkKBHSzcmvUMwUqle9gJ
         u8niS1doXEJ2RwMzG/0mEjTE7lMt1sj73S76dh8JyJZcQPIvjC15lEVPIrTrZh0pazdh
         Lq3EEwwFpfRMcrexuKQami+/Xqupfpo7O9DTZi/jiF0KEUf/nkNZ5NJFvdTdkQi9iTvt
         arpCBGvbTojmTdJaSpoXnW2KakhG3dGmXs9ORSnf7s3ihygQvcvf1XsqbfYehS/2SP5t
         tDGmOPf4QaIDKzcXDGhJm8FPhOFpxEEOP4SaZPFtqitWc8MkQiT1688Ju/YqxZFbUaTP
         4MIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761607598; x=1762212398;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iikffhOT1WMi+y0dl8K7FDqmN86CXPbZoc1p22Fu0gk=;
        b=DM8KRIB/hWUJ2+8qwq3J9ucXRzI5jWFSuv2bfV+gu6DlbEoLH9+/dLrxqF5joY2wLC
         F6fsPOAl7JHeIU2oAhjnLeGry3GeuHyJGlgyKDGyxu2C3hA69kXSjIUxlzdXknal+e2K
         VIMlvBk3uujPntMsomiQ4DJDJbJtzB4SwX2P/eWmikf7UJdruoiUyFLzn0QYmIRL1Jdf
         ehHIgOZLdBwAoZyCUM8biC56e33/xAHISBdEtFRv5gqOKhMC2dDYgw1y1sXXuySehjN8
         Nq0+8c2EWhDTl3ex8+fa8sNdOZpNjtkgnbBijdwAi15JzXRgcDScfUBG99QOzh7cdAAD
         PPjA==
X-Forwarded-Encrypted: i=1; AJvYcCXr0A2hkssOa2fcaCa0shkTZJ+7VSS9FGlZ6CRY95uKSd2aLdQQmbj3EbFxNRIm22l+etso8a76@lists.linux.dev
X-Gm-Message-State: AOJu0YxK8+Hy3JFFfaSNIxB0YVSrQAqptDuEuZbaNBhTqpxBHW+w7B+P
	bJEoYILWfZlqsPOWRD6hp9MprKjayWuFfXWEo6tpueb+Kxvr0J9wJwDjQKdU+mfSQpE=
X-Gm-Gg: ASbGncuECysZBBOz4sI3jpP9kW41hEHVfZRj8zeC3lTMNGwZXtiL5IhaQs98BsjI8ca
	lO5Y2k8JF91t81zmvsVtoJ3pOjv93ukvHbCb+akD6mNaQqT1FW+K8fiREXVAUNviItUOBVhRRt2
	aewbuoWKwyyKoG6mDC6qcwZ4QYWLYW3I6LnhyxD5kofy4JPQBw5rP6EeY8b6mxyOwgggnXVwpoW
	O7aUjtBb52hMrEt/AnLH0oDoTwgkCcTLv6MZyxIfmIAaRYl5P9F9CBF8NU4SwK0Oiu72luf25dT
	k9c4viP7v4Y3SWx6jkg9Kp5NXDiOib3rhoTkk8K1RIOIielUkEmfrdsCoFSg3Yh5cWqlwlTmNcr
	9GWcdJGftIIQUC8g0vZB+5J2ak8g7Afw19KOrap/9T/s/kwcMQ4DzUtI1IJ0iBSLyUu6cT1dEJL
	Wyj0WsgGvecsu6MjM=
X-Google-Smtp-Source: AGHT+IF5tkBwJGXPq1ayP4IuAEH9VPpB7/PafjKE6njHLWA5SWNWEajU2jWwAJH4Gs9Tr8tZJmXM+Q==
X-Received: by 2002:a05:6e02:b47:b0:431:d7da:ee5d with SMTP id e9e14a558f8ab-4320f7bbd9emr25705695ab.9.1761607598127;
        Mon, 27 Oct 2025 16:26:38 -0700 (PDT)
Received: from [192.168.5.72] ([174.97.1.113])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-431f688c085sm35588285ab.26.2025.10.27.16.26.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 16:26:36 -0700 (PDT)
Message-ID: <16a5f83b-c2f7-42ef-9685-38fbfd45c207@sladewatkins.com>
Date: Mon, 27 Oct 2025 19:26:34 -0400
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/123] 5.15.196-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20251027183446.381986645@linuxfoundation.org>
Content-Language: en-US
From: Slade Watkins <sr@sladewatkins.com>
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/27/2025 2:34 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.196 release.
> There are 123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
> Anything received after that time might be too late.

5.15.196-rc1 built and run on x86_64 test system with no errors or 
regressions:
Tested-by: Slade Watkins <sr@sladewatkins.com>

Slade
