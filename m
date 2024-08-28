Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF8384D0D
	for <patches@lists.linux.dev>; Wed, 28 Aug 2024 04:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724819056; cv=none; b=KjDLB8vwzu2UhnyIyySnFd3txp35GLV2drNd78oYFv/l4LY6QntJ5H/5bUWECWZPOxsZfIO7q3e02av0ys/Fhfnms/+c1MVT33RdQEex2XBFy7mivOv4nCEiLMxx7WV8ICdbdveDGmpELGFZl28mSLt+lwYt5cu5CGp7nX4kA0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724819056; c=relaxed/simple;
	bh=iSeEtXxbuAC+6rlIpyEzQw5/FyLhOZ+VSNh8g3YqTnc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SPMPT5kQbPDQGlbXnDuFo6V93kvMU040OgrxjlFPyRu2UmOgVnb+FV68TFYkV+M+x6GHo+gwoCz6nIl5hohsDgz3IX1pvR204nox4uSLUTVaU6TpsOBdoHmCduZoOYatyER7QLBr+6eP3BivmndkHsnIca0oj0uufEUi/bS7fiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=T22128jC; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="T22128jC"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5c210e23651so685588a12.3
        for <patches@lists.linux.dev>; Tue, 27 Aug 2024 21:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1724819053; x=1725423853; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gEp2WWF6uAzjFpYV8RUuP3nwjzanyudW6qAn5FJB6WI=;
        b=T22128jCMduanduRtXe4wZgzA8FeLNWlWFVS9hUHhdIURxHk6U33N0mDpiGh3w1JB+
         9uk7dA/N2FxXF1XN51px0gU1gy9XcKKhgdFWHFFMcV+NseXXoqF2APdcuA66Tn2hHmOG
         udF/M7BzikVUO1henmyn5aSqEzRsxrh8FYYSoNzr7xZ0AWm3wdQdr4FD7DiGPXlcJ4FF
         YsWBx0eSH7WhAzWssE297OtQHk0LTtZLlLLW5zkpL84Q8q3fwrgXLgcghah/ysYnyp3P
         C5ZYTuypOWM1jy3pPc94xJnoY92rS+9DQ1KCkTL2dEQhha1GvEkUVyAwfc+BcsQY6+WM
         V6Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724819053; x=1725423853;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gEp2WWF6uAzjFpYV8RUuP3nwjzanyudW6qAn5FJB6WI=;
        b=fjjnqrVQvdsRsQgNSTqDxHHVgl/GbaCCMHiA3OajExNlRRF/j14/B2WhbFS93uVzqW
         yg8+KryCbD7ZA7iHo5mXmVOXunPlOJ0EKFjm+YPJMiZwDu4FEBZW1/hggFS9tu/z230U
         naX3yOmLDcZFq3TxKeYJhSiz+TnAGdKES8ieQVGrgsl8fQAWv6TCChy1Nalf9urRldVt
         wmHuomOOTr02qOHjpeqDvs23LSNFGremJ2mSy/CIdbT6jw0VV0pudJ/lV3XUyjY294ek
         Ab1C/HdGjJ8lILSDCTojpm7SXUTwB/puKIpTZXxuqD3sz49Z0ZupCuxIieEGexmCgZ+n
         BvmA==
X-Gm-Message-State: AOJu0Yy+XhrDmKQB+wuhdBex3M5nwekBJPKzYchpqYUCvewN8DnYf9fT
	5P7iIM25H4j95srACc/Uvc7YHARSjwhpLe9YgcMA3hVv7OG4A5A=
X-Google-Smtp-Source: AGHT+IEyaZZUdpDX4j1cUEdZP3kE2zHGP4i7DiZMfhzfMv4yWPXAK/wgq1Wo3eQ8OlE6Hy+UaWG40A==
X-Received: by 2002:a05:6402:348f:b0:5be:cde2:861d with SMTP id 4fb4d7f45d1cf-5c213dc0aa7mr469172a12.13.1724819052764;
        Tue, 27 Aug 2024 21:24:12 -0700 (PDT)
Received: from [192.168.1.3] (p5b057ded.dip0.t-ipconnect.de. [91.5.125.237])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c0bb4722b0sm1703477a12.69.2024.08.27.21.24.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Aug 2024 21:24:12 -0700 (PDT)
Message-ID: <fa59f2a2-a8c5-4d73-9819-f7ac6350dc8b@googlemail.com>
Date: Wed, 28 Aug 2024 06:24:10 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.10 000/273] 6.10.7-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240827143833.371588371@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 27.08.2024 um 16:35 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.10.7 release.
> There are 273 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


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
