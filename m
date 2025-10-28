Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E844239573
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 22:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761689958; cv=none; b=LsZcpVnX4aNaGcNKyig1cMfy4XNzX2ZvzR/VPfY4taTwpa1m1jzPAyGTojBdFyxCZas3EPTjUwdQ/ptGDGEeuJF00C0ey1DxbHaWrkU0rlFgNZDbonBz7jFoEx+oNJm1568reAjhESAQFQn2u6No+7wsR+N1Jh93/34dhQk54po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761689958; c=relaxed/simple;
	bh=mevXSP3pEnwviu7Dtj0yYMRGZGl7rzL2dcYI/FArHso=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N1HYEqy6SV/nNzw7ftBv7Rw6jVILsl3759B3In1lAn6EGNjCYy7WIKEz1I5NkZ6PzKtts1/z2uywXx0NHQgOLQ0LE1ARKZwSvT7Go5RuUyUFdiGpd1/8WOQW8STFtxegjLDGMd0Nx47nwNnP00gtwew9xoo6nxBpoIFSBo8axFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com; spf=pass smtp.mailfrom=sladewatkins.com; dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b=Fjt7fnX0; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b="Fjt7fnX0"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-89ead335934so464451385a.2
        for <patches@lists.linux.dev>; Tue, 28 Oct 2025 15:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.com; s=google; t=1761689955; x=1762294755; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=56ATqaJhxY4mgO71KSReEDqtQk4ZYFmHYwLd5aGRlu0=;
        b=Fjt7fnX09+VEtTBXfH0szHOHZEmf87rGwi8PolEZMdUiejFL9wDj5aLC80vQ7gIxbG
         Y/EHqGvalrxTcIsK8RYJspBjHLdLTZvUA1mc5AGSG2qIj4fEmM+IWVo8uyvDYM9TJZeu
         TLUflolr1EKTG5iF2+NShatLdxYfYpY5ABAGVqDxSJ3xAygLF3oinsh8t5Zm0tpvcLnx
         u8mH4xnTs9hnrxlzPv4BaqXqwNdnJAgdSfWbg+cJ4Kkz0QPn7PaMKSNtY+vWRMz7nReH
         gNxJTqWnaCISVc0Ohk7fLdecoKrjbSiF4UW+Xjt9VulmaIlo4zf7t8DSypiVYSqKnIOF
         jfXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761689955; x=1762294755;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=56ATqaJhxY4mgO71KSReEDqtQk4ZYFmHYwLd5aGRlu0=;
        b=iy1KA4x8+numKKad6yjjwiml6SPHZLz/9KAJ+xIsDfjK3KTk9BVYKCSAXepedra4FH
         Qoesazc+paN9MLnCgopemFrOEpdpQdIURiksUAkfch8veX/jnL64Jzv+C6eLA5yPcDE5
         HwR4hXYrDae095EkIeQwlRQtlNuZkHpQaRGknglEakxGxfHJl5gA3e75Ng3dy3Sx1Rvw
         IfB3gjcREazCT8E9E/7yDyVR/DyZsIse/7VMrShExWt046APedEOGuENoHEET+dTnMyr
         zVABpVQl/dOBFU4S45a+fNE/eYDMvf2Wx/RxmeZwgw/Rf7whhvnkNHXvHh1MX+49Amk/
         lJ9w==
X-Forwarded-Encrypted: i=1; AJvYcCX/8GITOe+0bmnjY5mm3YlrXiEBla3NniWUkEDgeuRltFqKDsC3FHdDobotzw9idz8d8epJ+K/P@lists.linux.dev
X-Gm-Message-State: AOJu0Yw8IJGcfg+VsaS4WBD7+AyvmS9+g8aHb8G+6WxyNedSwAJ9kp5J
	6sYPMc5CxWhkDhIktLcRgH15Al4qYy6iGLzZb+1RIBnezk2M0X8102ThjhRTYcUroac=
X-Gm-Gg: ASbGncubhR5Zz5FwvYinE5d8lzLzLxdUvBXM7h1I78PyWiE/s9E9gxA9xGCmq1ka7zF
	k9iKcuhOUCH8z8TF8Jf0SkIS+RWzQMDjI8FH5yVU51DXSELC+XxMaG2dJbZ7PcmibDyLolyw5GB
	N20tPm1LuGBGqX8+uYnpYE+ofiql+dHts2Z7YWmyW8dQYNFEqdE4PdinQdZyuluv0hRJoP0bFds
	ak1K7HwSqk2nzdaLEFaUu6ktjhSyXTHnM2lOK+zi0iMo3nfEREPKd4PG5mVMEYjD5oC2/wB7cwX
	I9iB4RPO785/E2G9vHkBvSnTVOlc9Pm7QUORHS3Bj8tEIqi7vEZG2u/azuAJKFMy8KeVl2EiNUM
	Uwj4795fMZvvdBIKLuu/x9/EyKOm79937ak6Wim7R+5VCxf08p67h6bpXaLI7pge0jAUuw535qQ
	8tWYeJLPuk/RXdDQ==
X-Google-Smtp-Source: AGHT+IF8GRGi5y+TVmHqaFaB9DksAsq59HHx98BAT9jVFEgFA7NH9GIYqf3/VizIifdNtLOSDGMHdA==
X-Received: by 2002:a05:620a:1a18:b0:8a5:331:b22c with SMTP id af79cd13be357-8a8e53d8000mr152397385a.43.1761689954189;
        Tue, 28 Oct 2025 15:19:14 -0700 (PDT)
Received: from [10.10.13.73] ([76.76.25.10])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4eba3830f16sm80099491cf.22.2025.10.28.15.19.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Oct 2025 15:19:13 -0700 (PDT)
Message-ID: <b6e926dd-810c-4123-bda4-5ccded5f8b6b@sladewatkins.com>
Date: Tue, 28 Oct 2025 18:19:11 -0400
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/117] 5.15.196-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20251028092823.507383588@linuxfoundation.org>
Content-Language: en-US
From: Slade Watkins <sr@sladewatkins.com>
In-Reply-To: <20251028092823.507383588@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/28/25 5:29 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.196 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Oct 2025 09:28:07 +0000.
> Anything received after that time might be too late.

Built the new rc today and have nothing new to report. Stable on -rc2 
and my x86_64 (AMD) test system with no errors or regressions:

Tested-by: Slade Watkins <sr@sladewatkins.com>

Thanks,
Slade
