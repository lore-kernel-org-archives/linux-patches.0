Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651B4EAF9
	for <patches@lists.linux.dev>; Mon,  2 Jun 2025 17:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748883845; cv=none; b=hbSw066hfq8UXSs78EKzxkou8TYaxSIeSB8+7+vPkEDLaYSfqIj5PA2LvV3GyyWs4NgBgOokNX7aH+1T5Y0yn40tTi7/YdR5nZAaqgiZ2TvSpwriCZFGyC8qUCssu69qy4rZX/aTCgMkdiKG8JHv8Z6+tykuj2P9oEVar2i1xtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748883845; c=relaxed/simple;
	bh=hUM1rSueXNPG2z4TbKpz+yyrCnJRj9xQ1ucUnrafPqc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=STTETMPGxhqZ0CSrnWlAHNrXW38xcdtrZLuYSCch9/wjlRu/CowGEhfyTIbDb47VQPbb7E96bH9jpz5lx66BZDbXGqR0WGkY5mJjNmxj6Yy5lT6OTqQcr+L8w9phT+zlfqY5eObYBzVhO/vYWUjAEKnK4yqSLqTONOjQa8N2UVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=D2AbrdLJ; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="D2AbrdLJ"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-441d437cfaaso31933295e9.1
        for <patches@lists.linux.dev>; Mon, 02 Jun 2025 10:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1748883842; x=1749488642; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uBzKhGymnueQy+IcY/pv2XM4m2UQRAALtJoAmfofrhA=;
        b=D2AbrdLJRYB8MsAYWJiK+RpGxH8PgqoP/RViMBPV3AUlXvZMEATHqtUGiHRIYiqVF1
         cR+ylKwmPhSOrMDaVzfcCIGqYjg534oKKLYPrA8gj9JCX9WjR+wrB0cP8PVGWrHQ1Db+
         8Gn53FbjYfhThS6wp2gXNcquZGH93xb6ZoayeREmtbs5EOti2n4Ig3ZZFcbA1NPKSKjd
         h7uhYplZTIzJwbqj9y8STqh2C4aQqz2Xao+B60vpOO5VpKJhLHH1vZyMQNvNiAAUwYIu
         jSIRzcm+0BrS+jJ/Z82QRJ/w60S15jm1aUC5caaRPzJbfxvy4x4D0hBDyTEqzeXjHKrf
         PDww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748883842; x=1749488642;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uBzKhGymnueQy+IcY/pv2XM4m2UQRAALtJoAmfofrhA=;
        b=cJOmD1NjdBD4GAMvTRMR3ZVELREQudhTSEiUbPn9v4UB4jhCq4xd7/iRJ/zupT0Qx5
         YR9Qzd+OLSMKae/xOn6cvwmpruHaOGQJAI8RA2ZdEe/noA5cyFHBXAnB7r3ZEeWlZdgN
         b7zusynosADal2gO80YQTTFBX/NIJmw1Cg6c7H9Vqi6dvIVjUriAAMM2xjMm/V+H1ZtM
         SFtVxVBrt03t5c95rQk0IAGsMy6sc01l496hM4IEuMoFsExyAzGXu5lqDvRV63XKTvpb
         3vNjl4tb0vsr5f0rCrPZfWaYGkOgOsPMgGiAFxeg2zsZ5F3wPw/0gmdABLlq0QUQonDo
         4DFA==
X-Gm-Message-State: AOJu0Yx/CiYBVWKG89Z0B49QVJqBoNEPnw+4GyrhXPI3Lv3Awm8eyCdD
	BH7lO6WQeC9KV6gzETyiWgzq7UuP+9Txouzsg61OIbL5Vf2vDbMMmPI=
X-Gm-Gg: ASbGnctzZ5vqgjd5k+jkHSD3Y495a9E7Jl9QOz8PzM98/6a4eXEFDs8dwfrzgz2p77R
	takQYglKpnIyj4j7XXBTTnliZRH2xIZO9Hn/EvOEOJJGosOc2DGxsdQeaP0BmGBGsyCf3/BPjBl
	AiHtfivKHVnMZ4SGqw37m9akRw2hEs2h74sH0A2vOLHDSCg6HSEswGORevWidxQfwXjF53x1X9t
	V7E3AtcyvaLy43m4b5UCE2eFYEv66yRZpfyXkB82x7W0ZBvPtyPwq1CkoVvTBY2J/z0GYW7jzg2
	FW8rhfZG+w/uaUqWZ3OkAokegcLju5vu6KKDu9KzbLb7Nb2EKhCJv85A1AYpC95VYrzQIhNu18w
	zhvgaBdcVuXfcpPca5Cu7Obl+UOY=
X-Google-Smtp-Source: AGHT+IH7SmdQdTke/iNV9OEY4o5/+ktSmtUZjFNUZxLLAQyiwAywABlWq3JZnjJ1zKSFEC4KOQi4Sw==
X-Received: by 2002:a05:600c:35ce:b0:43d:9d5:474d with SMTP id 5b1f17b1804b1-450d876ccccmr143184155e9.0.1748883841515;
        Mon, 02 Jun 2025 10:04:01 -0700 (PDT)
Received: from [192.168.1.3] (p5b057d53.dip0.t-ipconnect.de. [91.5.125.83])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-450d8000d1fsm129253745e9.20.2025.06.02.10.04.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Jun 2025 10:04:00 -0700 (PDT)
Message-ID: <2cb76b77-2052-43ec-96c6-31cbc93cd2b0@googlemail.com>
Date: Mon, 2 Jun 2025 19:03:59 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/325] 6.1.141-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250602134319.723650984@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 02.06.2025 um 15:44 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.141 release.
> There are 325 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

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
