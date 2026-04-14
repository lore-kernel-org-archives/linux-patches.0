Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C305389460
	for <patches@lists.linux.dev>; Tue, 14 Apr 2026 23:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776209686; cv=none; b=fY6+3pWGDYaM6RC9NkevjhPGMweImvkLMvoMt8ETV/kkuIqgI3Rlxh1UVWA+jrLfLhJ6kJxevY74EewdWPLcx/SHKV+MxD4mNzukXC5GUzWUTHRF4GrzAkkY5j8rTzrryaehU3UTuyi5kle7wW+G1I74mwnzCVtJVh723qiaX88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776209686; c=relaxed/simple;
	bh=yJp7aLhCR8Chv9hmeAJXbuIdN2vuZdLwlw+EP3zRKoc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eYap5KE534H/lXHUhDqZAwrh6o1WvisTlntSm2OI4O88vfTyOaTRbgps2opDqxabIMx9wMmTEQwjpierWt1+Pfu6nfpQuSMbpHMX18gmawHAeJUGDWz1AEDd7gcey2dhCtOccgSDvWUHsPLVCgQLQnbBXgFmiYIUHRXh1isBWSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=NDFmh4BJ; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="NDFmh4BJ"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-488d2079582so56343225e9.2
        for <patches@lists.linux.dev>; Tue, 14 Apr 2026 16:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1776209684; x=1776814484; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yfiA+tA6Qcia0ueG4XnnPpFxZvTCuq8kSK+6Z9YaNfk=;
        b=NDFmh4BJazhueMEOvFNhFiRSNBaNQacw0EOz5zLQZGjFZntSKdhrk8xFEiDbutk8uS
         YZxPQOH5LdSRg65Jtx175WJ494R/c3XeLZljRlmTqvaDjG8D3dkjagE6l11PzERwkCD3
         075qySLEUDRydW0ARhYUvWPhFW2EaWghMCh/wZIex+XfROjNkr3mAjXu6Pw5dYhircKn
         T2hE/y5ZUWKuSaWTJhneldjQvvC7MW8pmSqh3jXsXs2cpu8lmw79tj/vrwrJdYbtUJk2
         cO7K0umDsgSmRs3kqrLBY4uLkhX1N73fvPzOV05KqLOL/gDNnxpHcH8V4LwyLoVcpow3
         vEmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776209684; x=1776814484;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yfiA+tA6Qcia0ueG4XnnPpFxZvTCuq8kSK+6Z9YaNfk=;
        b=JjbY4VG2kRKZwKZC4i6nPJe6NTF7rzMdr7KHajfl/VYOPBS/lsrJBlCjifrm3umgm0
         Kn4e7WyASJs3etdF35a9OUrZLce29beQHVDGhPxFoV5H9QxKKpKChWy3gK+StFjY6z7P
         dfQC/Xm/aipcf8QaiN3g+/5eb5upaWQ6Ln5JWXz2BohWzpfEn79krh7gWGcdxPp3NVcR
         4/3MdYmJc8oRS5gukMyLGbATO6B32fkRev/CLoBooPjQytkJTa81uEPxlzML3QsVksU/
         uUanGx8DTpJnB0Ta6wtblCvVj7JwmfVPjH2O6lhmZ6KA6kR1OQd3jwuCSGO08g3TSaHH
         Uggg==
X-Gm-Message-State: AOJu0YwkKETuUJj/2LcOhta2SbEScrq8IRm5XykBTbDJoAiTTeQdEWNX
	qfu6xK+zdyPI5I+Ltp/CCnLysPSsV46Bg/yqpB6FFO5NSeVn4EKOgGk=
X-Gm-Gg: AeBDietQFojU32vOK9397bj6bpUHjmEXYTooWGu/lm4JxW3MU5S7pzKD5wE5ZM2YkfM
	o0MlJbQRPBpXKCG2yLGf1FWnlIk6l0Y2F+mScdmtDo3OInT1sIKpZ3b0iekGvlE5ui8eO7l8S6H
	tAimEBvHgZ2mWVlbQ2OMCtur2XJLigpNTaCYbRbtZyzc9AMqqh9MzdxMrdV+5R8m7MMF235wu7L
	Gq3H5d39FqW/dpXVM9K0lS/A+/mNnEdaF6OFcG8neBCqeF4Un1xm+Zy9gEF1YC9zjhTIAKTip3x
	rSVPO4gcT0X+peLvqMx+asI8wXOQPG9xYusaht1GCaHgG8nNIrO5HbZIFMnSnHUTzRJHBmarFST
	ZLQeZm3heWS3iAmAZZuhwMOz7Y23J4pmAWidkZhRxy2Sx9DjARQ93kqLLx9CI5wE+yTbiK2T1HN
	LJfN4RgIClf/sJmMsDPD77Z4N8tva38DS9jkM5DVf1K76f9cR6N31CAIMJZAThrU2T9lZ+0pgHv
	3U=
X-Received: by 2002:a05:600c:a311:b0:483:7903:c3b1 with SMTP id 5b1f17b1804b1-488d68607fbmr198294105e9.20.1776209683835;
        Tue, 14 Apr 2026 16:34:43 -0700 (PDT)
Received: from [192.168.1.3] (p5b05757c.dip0.t-ipconnect.de. [91.5.117.124])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488ede1e050sm145522895e9.5.2026.04.14.16.34.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2026 16:34:43 -0700 (PDT)
Message-ID: <0065c1f2-d670-44fe-b9dc-9770adae54c9@googlemail.com>
Date: Wed, 15 Apr 2026 01:34:42 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.19 00/86] 6.19.13-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260413155731.568515178@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260413155731.568515178@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 13.04.2026 um 17:59 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.19.13 release.
> There are 86 patches in this series, all will be posted as a response
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
