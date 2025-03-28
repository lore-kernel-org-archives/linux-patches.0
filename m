Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 987EF8F5B
	for <patches@lists.linux.dev>; Fri, 28 Mar 2025 12:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743165478; cv=none; b=iHAuOod+VDHS3V7LJbrXJ/fG+M4lzR6xTRduYxrkW9WIl1kYoMKjgYRLDh8pU7nVB3LnbqKhan5Hyk3kLUMK/QH/aNcmfpw4F1Tyq1uavLcZRHt1ceDCytLCkAsGZkvrstQ98mWHwLYWKcRuAHjCWtubX2EyS7rGcniz9r7QGwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743165478; c=relaxed/simple;
	bh=gXZMM9dIJk+UayztFAHwSYgFE4erlyKrm08RE2SIk7U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sBsbSn5iQvmW2r3lislDh8ofH9w8YEQWBjUGBpLCq5nL6WkblxD0paihZupd5YaBAtaCRsHVMGAixqQbf3iwWa/4clHorGUjqVjlaMa4OZJiRnBRZ+Mon6gn5LTtp4OHjqA8n8qwPts564dS7U96WS2BrQ7uhuqB6ZWNVmuSGAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=InmEH9lB; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="InmEH9lB"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-43d2d952eb1so14488635e9.1
        for <patches@lists.linux.dev>; Fri, 28 Mar 2025 05:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1743165475; x=1743770275; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xQTCb13dlcBwF4DMmiRnbU7+UrXrX4JGlrCk5UoyzXc=;
        b=InmEH9lBBD5CJncKeFbS5VAJx1UmTqECQ/SWFDOVkCjzcNUxLhpePNjKn1pkd026TM
         UkCrRKPOmr/sfBhyDUA6e+jJusGV9W7el+tx37kAyR6C/J/ZWdX0Gvg0xNOTT36oaUcT
         g65v3MZJlueYsJaP2S+CAHb6vCsSyIe4nc1p+2bCTukQZk6oQXyNE1DuepRLGKahczYF
         17nHPrqAU0w8GHxXxkhUvk6+mu5XuKR1+vmtqguIdWAlS61NNzeDq8Y/WfuJ0dJh4oIM
         ndS7W/VeMbZnd5wzAyGo8GOk6ctSy0omMj+ARjW61ksKWasGxAxgmgRGTwwPmO8e0/Nc
         IfLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743165475; x=1743770275;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xQTCb13dlcBwF4DMmiRnbU7+UrXrX4JGlrCk5UoyzXc=;
        b=vmXZvYgoR4WaL45T8NN1bbzfypKPZ2LxlMw9l5gMEOm4dMFn5Wdh1o3WFJW6wrEoXk
         geLao8tVxg4QyL0HVOON7TsukJpNvNNWcMlJr5RFnanGzUqVUuUUhm/NeFByWc3yJoy7
         wFJnBJnS9mBLuFiRifKS8/q9B7NFMn88KEFF4RX6Nq386U5sjJoy9RpLas0s+WVtg1Gp
         vJIEhZjb1nGdBDvhXpV5uYo0v0qw4aKeR6dB4HwJ9mlh+07Ecx265QAyh4N+GqiWW02r
         a4NIANqlf4bdHYcAzIGz41iYEOMtN2jCdMvOLVga92vPuGVaZ+hh/jUNnemvTkqzZaXe
         ZNHg==
X-Gm-Message-State: AOJu0Yz+mTRw2xN2WOZGSFGcnoVyodWT+n3779Zy6W1fi5fMU3LxkYmH
	eSzudok/Cd6489/QNaJsb0QaRR3HLcgXRrnuJUCYjxMLMs6qheY=
X-Gm-Gg: ASbGncuzzXZfF0/Az4BKcjcGX+zwKHsa8n2hyeKHDj4QlOdrwtffVNiskKKiNLhVPtw
	KmeV8OBScLUnH8Bdej6epiQygkYmtfq+t8b9cKyLUCYCIDe63hC0GtDr0o0bGZGaEb6MV2P6rsc
	+nLApn8kPHdNkgGqQHfiseRe23M6NkLzJOOb4ludIREO9P5+T+BLSFxbmzsSE6LvLglVLHaYQpL
	vgiMEsoFgJ4qlPREz8DuvLmgMQcQ9Hem6f2QLFxPZLhJkE44JiurGHnEGJDYaAIYWk+Cx+Ni5LX
	lRTsanrkQBgxXrD4qFQu1dHhuRv2GDKUF0c7kF2Kzd63Jc7A/M4/5bItRpf+hK0uI3GbUa+COR2
	isBvyjJwuJ0ftYcKh3TJp2QI=
X-Google-Smtp-Source: AGHT+IETWTz0/f50w8S5qemUwIFlMsEwzmPuImlQZlXznfvbz7J2nktJXxQNH6s//faEpXnd3Av+FA==
X-Received: by 2002:a05:600c:4f89:b0:43c:f5e4:895e with SMTP id 5b1f17b1804b1-43d84f5b4d4mr68120615e9.1.1743165474637;
        Fri, 28 Mar 2025 05:37:54 -0700 (PDT)
Received: from [192.168.1.3] (p5b2acddf.dip0.t-ipconnect.de. [91.42.205.223])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d82e834a5sm71937665e9.13.2025.03.28.05.37.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Mar 2025 05:37:53 -0700 (PDT)
Message-ID: <689412eb-8c45-452b-9364-c6edbcd655aa@googlemail.com>
Date: Fri, 28 Mar 2025 13:37:52 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/197] 6.1.132-rc3 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250328074420.301061796@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250328074420.301061796@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 28.03.2025 um 08:47 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.132 release.
> There are 197 patches in this series, all will be posted as a response
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
