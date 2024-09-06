Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB1E1CB154
	for <patches@lists.linux.dev>; Fri,  6 Sep 2024 11:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725623042; cv=none; b=sFxAIXWRg7QDhtUPX1yPjywdFRvqjKSEvExOk4s8G0E3lAfvVEo690H+WT1hAVduQnKmFw7U7uurBPr6ISjG0duEB+MCD4ORywWiPuM/89+LfkvMxtLfJAqbo+Ey1T0cBe/NkcGwDVfR/Fufcf+u5j2/NLeWZTyvbH4wk3Pz02Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725623042; c=relaxed/simple;
	bh=l8aLiUfVudm/vd/SUVGzTAzBmw1eCXX8xhWSjKpyNoQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XnTPXru2Nr2t03p6HXTg0G8qDnQNXHehCyS3vgxbt7aTjF7RO59DGFQaRIlgKy9czxz3uwa+hbji3d4AwnB0zhZTENcl0e6a31fVIqYXfIz7LpQ0ERIfttWyV2FNiVtqwaknzlasBznxdIes3e/Pl0K4+fpf+Fh5gL7VQ3N6nQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=jnByP5ZK; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="jnByP5ZK"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5c26815e174so2114171a12.0
        for <patches@lists.linux.dev>; Fri, 06 Sep 2024 04:44:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1725623039; x=1726227839; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oZFH4n8uj7LbYUyljomrXbAE8uZuiKQjDhK2lQm2YzI=;
        b=jnByP5ZKZN25YaGUvTClWa05ta2hO79qlc5b51QPEuxyPlDHs+dAjmEXtgIkgpY811
         CAu4BFz4J6Si0bZ/GXL1skfSW2+1jgHrPO0dmjsf9Lpi9yIAsH2TQHfmaaIFA8ujtKXV
         ikCZgdwTiUeztW1pzgVXdGVZ/yMVP25YbOUK4trygTO9B5eu1j0LuNd4UbeC7wdnCAKs
         W+LqTtsVthCfdubYnVCKwTaMP5dBMuNa8C7/LzFGqjWCBnWUr8c4AD5CwRYoktCM5Xzg
         swNWK+yNn4NAVJmEN4w5AW5luQlydEKmqExc16XQ/jUcfJomQdKPAwU0dcM3HJsfIdeS
         6wZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725623039; x=1726227839;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oZFH4n8uj7LbYUyljomrXbAE8uZuiKQjDhK2lQm2YzI=;
        b=h+ytc9Xqk7GDZ0EqAUHIBQxBgxiviCkjzKPru7Hl/nYvdzEAEsC27z6NGh/1V3Qpiz
         kRhrd/MYthBQVJO3+X4G1/5bWFdG98E6B29jdxx1X+u2wXNY/7VHN0pwV06BYoYkaCn2
         ZrJ9eufun/LzjD2SNGz22np5KdOKznOhdbxp3iF6tAlgPN8YpfTHSUiWv2ImSkClDPdp
         arJTajr/q5jNvaMPxOg/gaDHHI2sbGRlRMW6XYxHKobqPybSDil/D2IY7TlPtbeBvWm1
         bX3IZK+Pjv1OJHi7Ghe/BuOFiKAB8zxK+D48oZ7Xw5qLrLvXKZ0DmHeNblFfNq1QX77Z
         SyYg==
X-Gm-Message-State: AOJu0Yz1IK9d6yRQk3E3S0HRwNHu9kFIeHxvHbFgC5z0N1BIM0fZYyyH
	ZQPqlgpT2awK0u4KPrFo4r1xlwka3veE4Ed2hcWDimpxsvn5KRE=
X-Google-Smtp-Source: AGHT+IFCw8zYSN000juj26FedmQuKiZajxfLCf0UF8fTvienYRXLIOxkWkuV3DS6cW+Fy2eAX6MWKg==
X-Received: by 2002:a17:907:501d:b0:a8a:8d81:97ac with SMTP id a640c23a62f3a-a8a8d81a95fmr101434566b.4.1725623039218;
        Fri, 06 Sep 2024 04:43:59 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b40f2.dip0.t-ipconnect.de. [91.43.64.242])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8a7af8e46dsm174836966b.16.2024.09.06.04.43.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Sep 2024 04:43:58 -0700 (PDT)
Message-ID: <6cdc4ef9-8eee-4691-89e7-4d9fc5d27564@googlemail.com>
Date: Fri, 6 Sep 2024 13:43:56 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/101] 6.1.109-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240905093716.075835938@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 05.09.2024 um 11:40 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.109 release.
> There are 101 patches in this series, all will be posted as a response
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
