Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E376E2DA76C
	for <patches@lists.linux.dev>; Thu, 29 Jan 2026 06:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769669491; cv=none; b=QjXzNJ4A8RsRiBdbnYYU1aR63IXv0Nrb7ohum3alD0JwnbTrrngfot8kJjTUxPgvIdhcAr/JD6OLWigcC5Wu6+x55LYQCxAXB+aeYsmCnYJ69PwGqjD19CT4IXApwUoxxIYzlX09j53qibGj3IpHw+2yC2VDez6S1BOcez3MGEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769669491; c=relaxed/simple;
	bh=GA7NO13XqJln2AHPXGt8+LGXh56hs2XzTsmQUiyTfp8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ojV79i8RwxQzIgpFf9h7E6ngryhkJGF8vtKlvWVSY37VtShYoTd+tKtsQEuk8LURRJLXnsNaxCmEqs2TaD6pmr2Ft7bSiW6h/rG9QrOU51d3NC33+eWsS9QbJ9kNdPKgQw5d1QY+20bXMk59xi5QZcycib01qmVuejn3ONIOLzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=hOVOLRRD; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="hOVOLRRD"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4807068eacbso4546635e9.2
        for <patches@lists.linux.dev>; Wed, 28 Jan 2026 22:51:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1769669488; x=1770274288; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lj6177TwkscO8D9ati6ziuLwQ9fsmOed53ZhEji1Ppg=;
        b=hOVOLRRDFWLczcRam57VqHoRLSnZoV/2GkE2qtS7feVhuD8DaLChijFn2Xf4FiS8U0
         o8KFMu0qgYzjZqJBk/QA38lIy7C0dOGuCzfOjgYOSMQV0krAUKtnvjCJysdQLDDOx87I
         f/3Qj3JIGSGIsBBKeti+DciEfgprHOS1/y4raG8LLDRm0hPP0IF4zBJBPIwPyK/sy38P
         70lLX1hKVktJpGSMWCk7y3R1JdAzvxRMv+7rWyt+GmwTO7mraHl56xDl2pxSY0UZHnlQ
         XzpiXKVSohSHOw9AUmwLK5YFTzKfWE7zNcAlN9N6xL7gQTCI0irPQa6kgV9vMU9K0nSP
         Zk1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769669488; x=1770274288;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lj6177TwkscO8D9ati6ziuLwQ9fsmOed53ZhEji1Ppg=;
        b=fQyvMcK+b6hmsTEAMmybstCjMKy3r0XgnoJG78EGqDzFozRyPfTVogArS1cPy/dZnd
         ScwZ64NdTo+TcbUgU3cxkNvd5qPqXJcuQ1Ws8ut4fuwi4tbZb88Ok7VjFQOADzI8Kb9n
         nh/ImekWdy7hoKYxbxBj6ExtLYo3S9/HhzI/Zk6azHvHUTzywhSaX+qZuIIBZD1jwCII
         kf36AxGH3y/N54cIoM+3w/oAPEXYCjwLrb7FnzqI1v7TG2S0z/BhAl0REKp79uWW8wXo
         HPhREUJF+Dkt9msLks1uMrXm1fjeGUlfyI1yYpXuSEohEPFDKzTomfZNWR+9PYGIw8o6
         8fYw==
X-Gm-Message-State: AOJu0Yys7Z2yFHK6St2ZgS3YnVit4Cl/aLSMrVLNnHGe8j0wFFDK9oJM
	vSGDrA38WHEPG8v/QNW41RRZ/5ITfAf/VTydZLjcEsY/fNCCA3agViA=
X-Gm-Gg: AZuq6aJyFMnm0leMcT0DMjC6am/CDGmnCKUDi1Bay5EuJGjkl21WUiFLhaUaro1Qk0m
	Coo3OJlHmk1Uu1hHfKyOQiDIKjbRSVmjhlZY8wU5ErGafTjNyRjfJo5wTRryZQHP7onwOwP7gQi
	YCHfLuPSd68FDa1jbj0ugPjUgIi02fd+777QPM7/mdn/3DZdCV25VO8D2BDSgLPdj+hdY0XU9Sv
	MaPjugVnadk085bqdzHCbN4iGlP0Jehsts1r0Ck/VtIaZhwGjjbVSqjtCCTDxgQ4ysTFQlroCGf
	SOK/ia02nRQ5QXYqk6d6kwcUC3cAIQ3sGwsNOEf8ZY6HBseMhJkthdxGmj6IhpZrWdNE3SBMKX/
	vJF40ZFdPeJ2JNwSZyHFoMa+GelCqEVJQIxHEspbBoxhdAS+2Ppt75KyMvyCQLEvOTizxNW405/
	lamOjMnY9nriEF1UHdoZPlyIDPOx45WkDpVgDweFMTzp2jfmeeUxaV4HZFBtXl7Q==
X-Received: by 2002:a05:6000:2483:b0:435:95ce:84cd with SMTP id ffacd0b85a97d-435dd1cc6e5mr11967628f8f.54.1769669487951;
        Wed, 28 Jan 2026 22:51:27 -0800 (PST)
Received: from [192.168.1.3] (p5b057921.dip0.t-ipconnect.de. [91.5.121.33])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435e132303fsm11932380f8f.36.2026.01.28.22.51.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jan 2026 22:51:27 -0800 (PST)
Message-ID: <7c5452e6-702a-4cb7-bc68-a6115ee57923@googlemail.com>
Date: Thu, 29 Jan 2026 07:51:26 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/169] 6.12.68-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260128145334.006287341@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 28.01.2026 um 16:21 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.68 release.
> There are 169 patches in this series, all will be posted as a response
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
