Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23EFE42056
	for <patches@lists.linux.dev>; Sat, 11 Oct 2025 20:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760214850; cv=none; b=crfkg5KI0n8B9Y6EsrY8nUVb50nGQOpGFmNdK+vLfuIcjJL5FjDMnmqumSnAobALUgCd021l7S2Xg4vPBQ4EviKtlePQTxLo9U2h6gfcqazpXxvjAY9duaP1eWBfTwOjMKcKllhcieJhVJhfN7lnMVgAIk66lNtb2BkEIbO7JrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760214850; c=relaxed/simple;
	bh=uiS1FkGG+yemWN7mZxq5ONbvirHM2tWtK7mDT6LdM5Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kUSXPDKyF4cqlQsQmxj2LOcr/OR0Gq3d5Wcj+oSpO4lETGfJPXzk9WRBkEd7dH6tMpGc3PWsMuXtzOX2kgYRjdHSzlWwf0F8bGLmwVo1vtj2PT+3g50EkX0bXSJO5sALUyvFXmC5qvKOtZWBfHKQvn9ryBfREFJ4BJFibQkNQP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=h6hrbvGI; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="h6hrbvGI"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b3c2c748bc8so430216066b.2
        for <patches@lists.linux.dev>; Sat, 11 Oct 2025 13:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1760214846; x=1760819646; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A9gwbJotZOCrW+prxIpkEfE0iubkb2OROKcfJ2ha4J8=;
        b=h6hrbvGInnoJgRnSZm+baQYa4b/oCOoHdJs9MChPmkD0t2yC5gIZGMAZQzW09RdAnb
         pBV3YyV8c8BAgeFRf5oSdRLMHLNotZY9cRozLIadCNQ2mBYodctbksU9K9JFWGObW/Bi
         WE6tqXZJYo8OM+LnOAEihMz5QTJScwtJ9wNzvAsainV3D/+vTb3+V1sPqGdnKNHZIL6H
         9wZ9SEesiciQW54gnBi7aetgwsI+xZCdekmajF4/auNaDGJiVSPoajQHy28S4yM0mD+m
         +Fo+GUamKwOvNzXCP8NDQwguiCUwF+aqhOoAfbrUd8Dhym63UVfGSqrhREk8Qtx+fqGm
         llAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760214846; x=1760819646;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A9gwbJotZOCrW+prxIpkEfE0iubkb2OROKcfJ2ha4J8=;
        b=lsPPFX06x1n+O9zk9RY5wRSTBDVYLFzGwwGe1DZnsD5tSGyrBXBtIXcq5AFMuM7T49
         ggidDK6on/de7nb+TX9/MEkb6/YoZ9OTZbLE1zUIrA0fNE/snBHVCgvTDja5Xmo7fNzZ
         l24yNHNzP2ne0NAD/paVRV7e/7x1iZoqLrgbFukwYJv+n4+J70nE35fccKR20vifNzyp
         Sp8Upts1kCCrSZ7BOKDR0cMT6CrHp2Nm8EGt49mTSUsLEkERJvFUEMqVz7Jiis3JO14z
         zpcwS41tjjVvByt4ZrMtMVEUBZpkiRSek8OzxjA2TYQ6FLQGOgeylrGm75/1isiGa6G/
         HSxw==
X-Gm-Message-State: AOJu0Yy6ICfwMfK2Y6D+oNEOkRyCGZPvp7/6EGG7eG9u1knhGvno4rf5
	Sj+3AMBeF9v48nSPwsZM1+NRl9jDKKpU99PmsAfjAKnh9d4QkrkbA3w=
X-Gm-Gg: ASbGncvm4f1Dt/GqfsmYmIum1fsy5BB1R7dKM9CNGQQzuJxqkKHt2DPfVnIHcstPDlv
	/MaSk5sYL0Assj+2jH/H2w1NHo5nN4pZUMqLe8++f+Zh7OhfPu2KMFZ3NFD043jJgF7V3sck3fA
	fOkFgVhEeL7vfwh92RA9zdLS1Cup0yWne3Svckaf8DYxySMop/dbzITYj5MvJFDtbJ7ogSuNLEq
	hpLu9QxUnZ+PPoQ2NdI7e/0Iu6Yx1dBGoYdoyzHeumarHWpkiCGKeInfAVK7hjlEAaSsf2KeDsD
	oeeOX+wi07QPhy+YGnJ35VMLqlQE6cZ4CVX1JwGcDkIR1YBNhJrWsDIoiQinUU1PBHQijBLqynx
	g8vOzunjzHeLZFFs60pdm4aVfWsylUzqgwQ/DB/V1yxIGlfy4EYyYnUsiATLak6+e+1o2s31Gu9
	HfvpiiE3GQP/rqm+MwDA==
X-Google-Smtp-Source: AGHT+IFUGLVBIVIYHcomGPL2XT0ezPYzLn2d7BMGCM1cqedqmfG5bPAhYq81N5HIov9FmaMCMAxvfA==
X-Received: by 2002:a17:907:97d0:b0:b4a:e11a:195b with SMTP id a640c23a62f3a-b50ac7e7627mr1567961066b.44.1760214846173;
        Sat, 11 Oct 2025 13:34:06 -0700 (PDT)
Received: from [192.168.1.3] (p5b057b9b.dip0.t-ipconnect.de. [91.5.123.155])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b55d67d2ce9sm557575466b.35.2025.10.11.13.34.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Oct 2025 13:34:05 -0700 (PDT)
Message-ID: <50922be7-e209-4578-881a-16a533470e8d@googlemail.com>
Date: Sat, 11 Oct 2025 22:34:04 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.16 00/41] 6.16.12-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251010131333.420766773@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20251010131333.420766773@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 10.10.2025 um 15:15 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.16.12 release.
> There are 41 patches in this series, all will be posted as a response
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
