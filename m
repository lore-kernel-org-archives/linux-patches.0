Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F692F8E94
	for <patches@lists.linux.dev>; Thu, 25 Jun 2026 18:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782411595; cv=none; b=GX35LUFYy6wZMQN5J+YiIsjMXcxZd3BKUZe483CeMpyRBTCOqnYKHg16svU2mNG7/0o/GN4yCh4gVquGF3jdAmR8x8yyNef2bT0yPSeddBHuAjfJYkf9huZipbR6mViGWfv/QtmV0ZZwH6EKF+Uigtj9kTuC5ZDffr7IsRHmN5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782411595; c=relaxed/simple;
	bh=s+oI2GXQ0eVO+G6/VG+wj/0ChWx0Fb1vfvC8e9SCw70=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HmuvkItuAReijYapCKC8e3XJE1qFvDa1iXtrCWZg+8PfNiBzKy03lgcCq97ApcNZltjekHrJXUdS5S9EuXe4BYNHrGa1qoXrdJYupcK/LnWYgD/y/Tj7+D+BNuoLY3+SOqFoG4jOCylYEW6MsIYa/yrCMAcTmerpzh33NVSdHBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=XgUXOKvr; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="XgUXOKvr"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-46dd46901dbso45534f8f.0
        for <patches@lists.linux.dev>; Thu, 25 Jun 2026 11:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1782411593; x=1783016393; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G0EWw2t+XHB23CXT8lj21i27NquOnXh7rc/g7nLatCc=;
        b=XgUXOKvr/LYquBU8CF5hqggd2bXrV+IKNqaZ5fiqXfTFPxiKXInj4U0ZvprEl4VbYW
         Y1eI4Rez4MnbRgRg0HVZNObn2KrNfiT3/tbNNsLGnNhvxjHjXuzxCA1DtcT989Kj61Lp
         7ASS4+6h3JRziQmVyf30YjeAp090+7pVl/zCrx+6gVSLU8MZ2N9k3YLIePmJpfXHZlJT
         ffVcEiyftWVDF8KKnNh1ttQ4xHisTyGWVLZssb9PfOQqHEzl+X+YBre65PClEcJ240L3
         Gr3vrbz8YowLfBAHKVjCb2ntO7RC8fLfXNmsHQ4NfmvMNpqMuQQeMbiAq4/lT0qLcG9b
         DKDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782411593; x=1783016393;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G0EWw2t+XHB23CXT8lj21i27NquOnXh7rc/g7nLatCc=;
        b=JyQlAPSAXwez5g/eVk4Bpho1wmUzMbEcpC8dqtr7in+I0L78XP88MvnTvJrHgK3UZJ
         ac2ug9ZxPBrP9RNOSzLVot55zeZS8TYt+qZk8u++M6QydLwg96aM9vZjZH6SolihLsGn
         QqVC1pJbN2GyHU3G/ky/odL6XxhCxp1FJ0s0GrTdR05ZQqS2EwE2EZPozlq9heUb4p6S
         4g+ldcWBYIIGa3oO4yVayHLXdFHKwka7KFg6yNDUyNNkgKB7eHn9YpfQiZVyTB6DPkuS
         FaNqDmyocHLG6ywu7vsD05L8gTNStC9v7BHTixfACRGY2siRfqtHWDhd2blgTY3wIcFZ
         sP+w==
X-Gm-Message-State: AOJu0YyFfyv8B1KN6FsJZpHSNcDXx78WLvpHXY2+Z1YFVJDHd/dVXcv7
	1xsjq46YWrYr6Q0bHvNpg+No+vyi+pecXL7XC+gRs6Mud22RjOkVVCY=
X-Gm-Gg: AfdE7clnJpzS1IVbIVINXGq0k/TwTDdEiXetWLlgFlv/HhHCGBUnYEPBTIrp0hJiaCl
	CqdaOPGtFnfQghxuWNgfxHk5iMV/QOmS0lHdJlO/XMzACV4UKdjbhwUwAfKg8gED0GtRizFEW1X
	4e0ZUnAu99uua4gWofMZGNUiUWPoYriALX7TgBz+eALNhkKvGmDa4EevDKi/zN5WnPoaLEZhIPw
	lChVTRoskYfdXH0OnB/XYGsD5bayjqQceT4iL7paVZVlzB0rghdWB8Unt8jkON7hr3ouxDCd14k
	Hl686NLz0BlauOL0MiWZJ2KmegwaR+t/EjCViJn7TfFyl2IW7DFgmTZ4FP6qQUHH3VPgWXZAUW/
	AJykaDB9+aBJLDyjmSu+ld6wZ8WMfPvIAoxTEW3E5wAsH4qW7Hega9Ge7BNs1x6UIgGWvea5Vof
	hOHbzrCDAeD0PosGWYboGH0zsaNIptPzRDDBReObWFTzghEdw/W8Wyirs5lyrLEWCg
X-Received: by 2002:a05:600c:1910:b0:492:3dce:f6ef with SMTP id 5b1f17b1804b1-492668932f7mr52131135e9.28.1782411592837;
        Thu, 25 Jun 2026 11:19:52 -0700 (PDT)
Received: from [192.168.1.3] (p5b0572d8.dip0.t-ipconnect.de. [91.5.114.216])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-492697a22f2sm5125575e9.0.2026.06.25.11.19.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 11:19:52 -0700 (PDT)
Message-ID: <fbf86bb8-e85e-4f95-8e11-ae731b52d19f@googlemail.com>
Date: Thu, 25 Jun 2026 20:19:51 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 7.1 00/21] 7.1.2-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260625125613.243729608@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260625125613.243729608@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 25.06.2026 um 15:03 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 7.1.2 release.
> There are 21 patches in this series, all will be posted as a response
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
