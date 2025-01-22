Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54712214232
	for <patches@lists.linux.dev>; Wed, 22 Jan 2025 15:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737558465; cv=none; b=HunTvTdx8HqtLFM/H7ZDrp+iZCISAArWiNTSvVYAawrZV7cOu/WLw4gOEZkTZY/zFFnUtu7vouUh9ikFmyGs52xwaFCD/V1n6ldv5iq/6ZXSRz5Os8YIkuHDn5o/KBBplj1jJaYaBCUwpiJgaWFjZGYoucMrS8ApcAViyhbLuwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737558465; c=relaxed/simple;
	bh=DHP2J8XZ0Yw8nMyu9kCS/XAFXBvYiIwgCfWQx3cVQgk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rxcpv2Ry2m9sziOwBgjqXPTWaRMkqNycWG2VhWyupF3sydLtEkLsampVktqNZtHQLVEs4s8NEx8x0IpZUZjlZ1avFq4QOBbtpZ1HvSj7hisfxQwiwiSlwirYaYm26IwC3z2ERyvSuZ89G7bahHsFtcZMj6N2/6wMeUbMqc8iSWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=GjN+pG6g; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="GjN+pG6g"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4363dc916ceso6778545e9.0
        for <patches@lists.linux.dev>; Wed, 22 Jan 2025 07:07:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1737558461; x=1738163261; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MaTimNfRI0T0HB8tXAjuRGpTIWGEQknAsF8nU3K8A8k=;
        b=GjN+pG6gytPydmizd+DrDB26XFlianUpvo7zd52Va4zBwpcq3l6nyq/k6lvf5Gi5yo
         nDsziq8S2yKchrFKm0QmfzCCyzJbRfjey0p8DqGm7U4fJZW4kn3HwRJgpxczu60Jy7mS
         HqfbGPDe3A1856xLj8Nw5CxoGfgBZDB0HdNrlib03S6tZAbGqYcfufCfIRrIkve0/qNh
         Pwf0zHIutc7A9vnuCXSO9UTnD0gBTcLU9Fgvr14mDBdq4pwPn1vnL1JJGHQmQvTjfE+y
         BkZsEciQ3SxYPWGuvYK0mbUCthsxxF3bQP6sSj0hwi3HA5x+Aqu7Q6qNsaCUb8FM6/wM
         BRXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737558461; x=1738163261;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MaTimNfRI0T0HB8tXAjuRGpTIWGEQknAsF8nU3K8A8k=;
        b=uONw9qnBPs4wn98UweaaOCEag+2NbCBBPquDaVfyHW60JhHIHyvkE4jMLcfx6TgvEL
         GgupvKjHe0HUpv5UdSXCIL9aXyOHjwduc/sRY6vV8Wa8Mip6X1bw4Fc4auHkRjOqq6Vw
         jv1tiCgKoR2LNKHVzDcCrkPUqOYq14FjjQkUKF645zkeDGR2iXCUEY9qdsEA4DlVhSSF
         7rYyQeKtvgR1BuzLRCgCK9X1TS6dPCwmIOpPRg4YTcNjOO/mpwwmUQG1U4AJiYwIudBc
         pTqG3v2NVcjY5ORQG65HAdJIx+d8XUVYMv8cSFpg3P3UdTfHKkPmKhIbrKygRn9TMfAf
         YQXQ==
X-Gm-Message-State: AOJu0YwCJxIyiPtr+9V1lIa1GqDGcaRZSZIR8ukNE11cz7SsfdMKX2Ii
	G9V94exwXTgoFEvoMC9q66M/aCOMd1kDRDvderko5h20Gsabv9c=
X-Gm-Gg: ASbGncuAhpeP167GsGMRgSkqVAzXK72IpOLrwqzIq8x/ZvlQXlr3PbnP1dJq3fIoask
	ZFZQLBI2r9re7i0s9ZT03ZmUtHlvwQv7nJl561EQjIWRs6qGoZhkt3pcF/7UQgKNQJfZJ6XnfmB
	ieGk3Rak00uXJpMVwJ6Bch9oK6rlCNd4E7G6Ulq+kFuakz1GdJZLlU51391lQdOOABWpx8G14cX
	qYRXk8CBsZl1NAXj6gsCACKnj5pW57bB6zrqjiYbhFQQh2wrly6iiczBbo/ZgGn33tS/qe2cI1X
	nPth16TK8KXu61Z/ta4rJYXloPHV8vdl/1v7kGEyG4XVXXw=
X-Google-Smtp-Source: AGHT+IEIKbkIRLYp5myGXq8eDJly5JbN6mshFFEn98fe+1seNHprdQpW0B6bkbLl70rpHC3nMxfmrQ==
X-Received: by 2002:a05:6000:2c1:b0:38a:4df5:a08 with SMTP id ffacd0b85a97d-38bec542ba4mr25939146f8f.22.1737558461113;
        Wed, 22 Jan 2025 07:07:41 -0800 (PST)
Received: from [192.168.1.3] (p5b2b407b.dip0.t-ipconnect.de. [91.43.64.123])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf3275556sm16821801f8f.72.2025.01.22.07.07.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2025 07:07:40 -0800 (PST)
Message-ID: <573e476b-de65-41a1-8c66-d5f8ae61637d@googlemail.com>
Date: Wed, 22 Jan 2025 16:07:39 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 00/64] 6.1.127-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250122073827.056636718@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250122073827.056636718@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 22.01.2025 um 09:04 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.127 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.


rc2 fixes the -rc1 build error for me, thanks! Builds, boots and works on my 2-socket Ivy 
Bridge Xeon E5-2697 v2 server. No dmesg oddities or regressions found.

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
