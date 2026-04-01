Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E2227A10F
	for <patches@lists.linux.dev>; Wed,  1 Apr 2026 01:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775007168; cv=none; b=NZ1Ck/xrnYuHNO3e63ElEDnBrlxrs4crcDG3a1sxbuGXFRhxcAthZMY+NCPbgF5Dp/wELLUZJGiOy1YYNV7Wu8r5lN9Y7XSa+3PLgPKOIrcvSjKs3hkxKlId8THaIWhybnu6UOnWnp4L09yLl56DUiVN/5mjEhh13GmwGDFWa3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775007168; c=relaxed/simple;
	bh=FvPnJOtchaOMZT4wCLNb0Hf3tgFeuUiZAfTnfIfz6Hk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A/Ll+lOr4LyMY57Am7XYL1WCjKDvgta/AtpOH4X9dJlM6P4tMeO/4rgiC28HFzVdvF3cqv9CeWe+ZHHFuNL12n1GFKMiMZ5JT9lTtBFMkZmXPzN7vrNIrG4hYvY6YCvTvVsGe/rhIvHgqFfk5aXXDJcz/7BXmK0loAqxujpQvjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=ozPpAV+8; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="ozPpAV+8"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-486ff3a0fc1so57423365e9.2
        for <patches@lists.linux.dev>; Tue, 31 Mar 2026 18:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1775007165; x=1775611965; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2T/XLQ7RKXHebgKd5i5a4vHwH0UE4XVg7tpmJKpdoaY=;
        b=ozPpAV+80TalgS6SuavkQg/BnRBzMiT29/GMzJR4tAJrZXkdA6leW7210RaIr4z3Qj
         3ql55eCb1aNs1vz9/3c/HP7oJXXxHcMpCW+8PQ6gjwHVeUX8L2gwHxasu00VF6Fg+5Ui
         Jha5PF523CM06GTLph99YN+aVq/y0f8J3IUCpVwa0KcadY6PgBTPN6N9UCzikrM3UcEf
         eizFyFtX2R6RqWRWHb1vS5Fh2Qvueos/DmPUtV+ayyl2NOaT5+pggPG4A09VpgHQXwVd
         cycp5Or7FAjOKbge8CuAjcCrEyx07Na4pqtR7Dwc052l/PHAkR2/sT4Oe/e2NxxRLRG0
         hbdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775007165; x=1775611965;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2T/XLQ7RKXHebgKd5i5a4vHwH0UE4XVg7tpmJKpdoaY=;
        b=lOg0KlhWoxyj8cUJ2XXpY/HC5TYUHuKp1vB0U62fxe23i4bhRGOQuMjfcDlu9nXo4v
         KNeI0il1BrD9v4H56NMNF63GDhFNVaJMcsRmd1Aeyh6LHtvZALuQqB6WTXspaEUPnZna
         2hPZjz4cIiMnRqzuer7bG8N00fzfNY+u6pTXL53MNMIFmq73tCfXrDOY+ZXpK+VEDWlP
         4CYomtL6PQ7t9KnM3+P1YImx3GCYqJlHtySmpSH2z8crueAzJp1B/5H0cS9Q8b/b/+iU
         rcYqfLFliYKiOre4eNMWsMcR4DO20TgEfgfO2P9S20NQLSca14HIahLiUyv2pQU7iLz8
         fCuQ==
X-Gm-Message-State: AOJu0YzeSiG/9gLYjnAVg4+Jbiw6macYrM3jNWUdSIdrQoPU4niBe6r4
	UOo3LpH51/u4n1j3aqB3mjJVPeSQnD8AtIMEdjSn6o0NHyywzaqwrec=
X-Gm-Gg: ATEYQzzgU/T0uQGCuhQ4ZYGlYqaOnCfLlafp8VVePtxXgBowd5VHjFIQRBowaHGMTyf
	wf/bXa23imtT3RwWfxlDpeveWgvnV+QJlXMjbvRGu7VJDe0spLKYRJhurNty+me//9Sb7Xhg3tf
	5o1ctRK26sflRtHIkyZxPiQDeb107DlEM7lodhviGvx0jApzEhzc9+Thf/m4VJMKSUiPY9pDgVi
	xlRvRY7nLUZnTCAA4DkSGyZ2GSEsrxPFQA+K2AhWwjvTQMwVXX+YWeHKFrf+jiizWif25oGjlcf
	c6O2KQqR/tE2RkcHd5JA/XZqUJi2xp2I9Yz8LaepaalYat7FYHT26uQlVX5l/bNAEQXYIQOlxQK
	lfOKRQAPMCUI4IoNmVxDmjI1jLxiQDlF7XrEfYB04CaXRwFU4WtFEmuFeWCMb5WacGAc6ZUHhAx
	QRHJncKngp0gss4Ig9HNxUCpwJSC2+yXLdvrWj4i0KsgA2cRNXaVLvGfN2rM1bIXn9TDVmuR+fj
	w==
X-Received: by 2002:a05:600c:354a:b0:485:49c5:8eb7 with SMTP id 5b1f17b1804b1-4888359205dmr22716615e9.22.1775007164828;
        Tue, 31 Mar 2026 18:32:44 -0700 (PDT)
Received: from [192.168.1.3] (p5b057048.dip0.t-ipconnect.de. [91.5.112.72])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4887c8a546esm42072455e9.5.2026.03.31.18.32.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2026 18:32:44 -0700 (PDT)
Message-ID: <1d66295f-e699-4dd2-9269-aa5ef08c4e03@googlemail.com>
Date: Wed, 1 Apr 2026 03:32:43 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/175] 6.6.131-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260331161729.779738837@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 31.03.2026 um 18:19 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.131 release.
> There are 175 patches in this series, all will be posted as a response
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
