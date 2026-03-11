Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 745831A6807
	for <patches@lists.linux.dev>; Wed, 11 Mar 2026 01:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773191730; cv=none; b=ggUCkjr/odosjk/THgo06at8yYm24FdHxfqTQobxdlPLJsCuXBuxNW1DWiCGPfAVydS7QK+apALyWERpOAqyKixxnJZQCuuMfNNEuq4K6Yx8KeT3SLINBRCHwmWqArAgVzSmDmlex4M1V7fnfXjGyYiRAvSJqIIvz4JQ1p83+lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773191730; c=relaxed/simple;
	bh=e5WdPqbigc0gFpaeKgAYvqcpgYmUc6LxRC8JbxuQJaE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JH31sMu23aYDTilLwt6uAvUp4OhYE88HuhDzUYzU1r4jH83+TNXcOSqwifqUDjnCjam2aDp07ZYBxsG5DLEgYnWS50HVjjsViO2MimcYbzPuU0QvpG8udzl5czB7CZY23WKx5osi5+hqNGrAOEzKK0a/lZWVcZDoLbXv14hBQvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=RpRUsE4P; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="RpRUsE4P"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-439b6d9c981so297498f8f.1
        for <patches@lists.linux.dev>; Tue, 10 Mar 2026 18:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1773191728; x=1773796528; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xXhD2GoMczx/1OfEQmMSJ076ACkSGZw8MD7r/tb1zlo=;
        b=RpRUsE4PKM+8VOIUn+QwNZj0H6NvxCsbjuiADY98GsxBdSEl4j/z16vmCDXZtuZLCo
         EEY6nU0/uon8j2O/8HOQImOQLuLFYa+kkivu4en4Ahb4IpPm1M3vkyh8ALTzBRFxuDK7
         JbEQWgN5GYa3kwffukxMPfCrnKETUTBpXM3rXdrPJV8Siv9ckNy02UUBKpMThezOLf7o
         w5FUOlS5rnEGmXIr949IiTwG7xPR8GAA6doc0gDMIufcrMov7w8u/Yj0/pwKzwni+t87
         D5t05FM8J7FepTe3zPTbR4vZsMn6zoD8mOgFMn1D7lmw32LGKHyFhN4fDR9jiuA0cxzG
         grZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773191728; x=1773796528;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xXhD2GoMczx/1OfEQmMSJ076ACkSGZw8MD7r/tb1zlo=;
        b=UQ6Zh5UE9sQEJ7WvoKQG6ULrsRTsGWvTmILi3i2uUSGRq9yO1V9BZzkO0RR2/hSiv+
         t5DjLhBKeFaQdTuxX7EeXNnw7ocMab+QorBEOodob+riaR0NO7jsECJuSMqIi/3Z264X
         0JFnJrQ584wpzHAPVQi6zTNv/sejfAzlMGGZiFE+SsfdvgS9+gR198pX/CXg+20Im85i
         KTMLbzGeSe8GhZPJBTp6tKWgqHT4NpNVYYQr/m8pOziGfGaGW66AUwAaBGPEMiJvZcwH
         BE/29S0xE+IMC6pPmo36nXX3lG4NQZciubmbE9KCYBZalT+RRkajkSBme16OvSqwvAe4
         SNWQ==
X-Forwarded-Encrypted: i=1; AJvYcCUrmv6/VEokvMWGfM0weyGwzeQUmb+lv8pb39LpP9xBzPyNmjOTt9/XyuE1w2Q9US/solsIAGg7@lists.linux.dev
X-Gm-Message-State: AOJu0YzqUeTh05doE0fc4y4k4drvLemlGEISh/Zgx4ecsXQwixQm421G
	p45wWtmCMGPjgfYcOiwYIwYyGXG66t+Mjx27t71pjGiBhaUuVBLT0pA=
X-Gm-Gg: ATEYQzzmneFxCxyWrBAlvaSy8wfzxSBift/oOISkW7hb4Hcs89SLiKxZ2Uuayw4VEKy
	lp7vyorpJRoFCHYo6LOBJIe5HKTg9Ag2Jqv/4cVgTVvTGgNkr1+od5QhO+8d+wS7ZJeVZ0mBOa6
	UGZLR48FV0sHu+Ymenfw+IDdLI11pKJMl8FFBMVKYo1VWSOB7wNBASEgcVIZ3CWMw+AJQwph8qO
	keq9tMTDezLM39FahXl/G+qd43vOp7WfW79acoKreGfrX66nyctcBC6GOr9gNQUs+nagL7QV7jn
	9aJbOKsrsAQ+SgSChy6e9eNn82yxBrYsnEwD1BpHPoa6dfC/Q5F+mQkL0ikDN9Mw3gVnFfFpkC/
	g9hSnGpJazb0S5HK3IRF3cAsom7fOVvZk5hNWbZ8zaYfAmscO2er1U1AHfCbOiCIMvdbLB3SKA1
	25urh9hNyAXLy2EQGtgvhJO0slvlsWHW2i3kRhuPE+EMykHm6GM+tdMNx6nHfXn3AZQLVROAfep
	Ls=
X-Received: by 2002:a05:6000:1446:b0:439:b775:fca2 with SMTP id ffacd0b85a97d-439f8c0643emr1267352f8f.24.1773191727593;
        Tue, 10 Mar 2026 18:15:27 -0700 (PDT)
Received: from [192.168.1.3] (p5b057cc4.dip0.t-ipconnect.de. [91.5.124.196])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439f81acc22sm2091105f8f.16.2026.03.10.18.15.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2026 18:15:27 -0700 (PDT)
Message-ID: <45265f4c-99fc-497b-8ec6-e0c45d413b13@googlemail.com>
Date: Wed, 11 Mar 2026 02:15:26 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.19 000/311] 6.19.7-rc1 review
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <cover.1773140654.git.sashal@kernel.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 10.03.2026 um 12:05 schrieb Sasha Levin:
> 
> This is the start of the stable review cycle for the 6.19.7 release.
> There are 311 patches in this series, all will be posted as a response
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
