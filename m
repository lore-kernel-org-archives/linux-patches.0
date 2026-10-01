Received: from mail-wr2-f35.google.com (mail-wr2-f35.google.com [74.125.225.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87FF38C2B8
	for <patches@lists.linux.dev>; Thu,  1 Oct 2026 01:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790817020; cv=none; b=KXRHQXQq7YUgIWXLlhDK4fABiwujBMJDFCPntOEiSx+spd8aC8gbcaKiJNzwvgZuMsmYwFZjXUWdGpeFCC30BtgFKPuq5m5BP2bYfDhdcHDP4zcDbgkXU6G8hkUyna4/8XleLFiav4iio5BJPbFM3SmMW21nXCKI4Lp1G/Sxt6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790817020; c=relaxed/simple;
	bh=Tq+EEQZZUSkW/OHULP4X5a3jFtNXvLlkqUIM3wN+i+A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GI+Yyn6zawDJCyl4bY9ULXpLo4X2CMQawfN7xUq/n+OmYzSb+iHa7XRaw/PhaqIjB+yIAsjfoDAjXDok9CB7t1UmdiZaE0sELNZzvqgulez/XtNOyKna5UwHc4pTJKjJvDoQybu7wjVz+zm1rRbsr6dRqPDC851Z2ra0lhtoAbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=TYNIBPjj; arc=none smtp.client-ip=74.125.225.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="TYNIBPjj"
Received: by mail-wr2-f35.google.com with SMTP id ffacd0b85a97d-48b05fdb2f9so446610f8f.0
        for <patches@lists.linux.dev>; Wed, 30 Sep 2026 18:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1790817015; x=1791421815; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2Hqg7fvezYx0gMAe4vTkP11iGpswB7iKcMQUSEGGhy4=;
        b=TYNIBPjjQ2JGl4kBquClOBEjYXqLexfyJNIqvqbDdBiWazITmHovxIxHIWeslMnFm1
         gdXvxp1a2ZWp83DVvTv4EUi3YlYPZdgu56eFSLDmqoDoKRW0qf1UzknPGRLdd2g1hNxB
         I5bqGwFNY3Z9BK+UnDZNA/ItYcIYVdcmeZpkNEqqiutvb9R5BIuP9NcykD8C1iRuW0sM
         4OG1e/zAMVgh4o9rL3dWUJ2OWmEC/tz1RL+EUaaAmBNFZADKdsUxAHGTH1YdNcybn8V0
         n99ZlP4tyKKxcbE4opSZfqL4zwfDTuFQu2vA12AR2NeMGSnxEdyrVnR91E/K4BfT96hh
         DJGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790817015; x=1791421815;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2Hqg7fvezYx0gMAe4vTkP11iGpswB7iKcMQUSEGGhy4=;
        b=v5yOdK//ilwNJvxd/BJwW9FUL1SznszJVnsmlvynRezCZakHghUG4gA0EM6kI3JZO/
         PfIP04lPmwTSHIl10Yk8qLP4d41lr6KDgMX5I55BWSW1sH8PnKWaz/zF36djUZQRvxyc
         yJkeLaEreGqSOZq7Uy0zewTsLvMfm6P79tByCW/15IyY9SwgY5qd7tCQ7/N0BfEeCZSV
         3ZFlCJgKprvCE6SwcODE2bmbxM8A2BIw52zhaNSBiJRmO6nzx2um36rsUt0IoeI0XnWL
         ezzgn0XuQw8twR3hoYOeJgnDfOOQE8EGpDw6JGV3whbw87v5idahcpC6psbRnxOq5uWZ
         X8gQ==
X-Gm-Message-State: AFuF++kg/iQQ8lkBArestUH6W0UCnMoB2PTWKAF4MxOHeTwNSB1aJDbK
	mRZ3qMoqoU/LuO0JjkIEUmXEDaPg93koKtfmSORvdxTt2tSuS6ycqzY=
X-Gm-Gg: AYBFou3Rk9rpUKYYknAjCz2Ry504y2dBh+xo0HZpI32N7wR72n8F0D0TQuVrYCMxOID
	49xpB1+ryMniXVrY24wEPETCaftroubEG+vrQXsMsaes3VHf0YX9MP+QH5jppEhASIIHCUXop4T
	8l4tMpn9dM6BR6ZfnFJz5RmP6BD12PYdQPo/JNK84nwUKUtSJTBrDDP9d+nz9tzL7Wc8vLsTSDh
	Vb2ERt33PU1X+sxSksTWXv2xNkSwJzw6FjGXR+6/OOczfJDeYYDla2RxXnqFEcj8L7NRZKjwOYF
	L9mw2caRMTBU3Dsez0uAzxwnQyizQQFZ3Ug4vn97svAVe6924Z8Yu7EPlEn0wHFm4dpQLxvd/53
	ceKt/5jhA5qYCsMnz3wbTNAPxyOkJMr0XayH3QHtO7Jz1X/tfLIg+WAEvjSP8Zyghaef/jxbbbj
	g/bE0GqTh4ESxvMFwjc4P9Y9wBcB7fTwKu2htP0a6o+RKRQCfM4fH2g/kmus8rOjBGGzO0GeOOb
	Xq/kro2fhBQZR0V6FQ2Ud/AptTm2cJlVsnnrCnzUjVl0YDv4kMTfAUChyT0
X-Received: by 2002:a05:600c:8b88:b0:49f:e8bf:8f9b with SMTP id 5b1f17b1804b1-4a01ad98373mr50081855e9.4.1790817015182;
        Wed, 30 Sep 2026 18:10:15 -0700 (PDT)
Received: from [192.168.1.3] (p5b057568.dip0.t-ipconnect.de. [91.5.117.104])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a01f952931sm26870905e9.13.2026.09.30.18.10.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2026 18:10:14 -0700 (PDT)
Message-ID: <f7456596-f978-4d75-b949-f61e21f4c798@googlemail.com>
Date: Thu, 1 Oct 2026 03:10:14 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 000/395] 6.18.55-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260930152340.591469096@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 30.09.2026 um 17:24 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.55 release.
> There are 395 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697v2 server. No dmesg oddities or regressions found.

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
