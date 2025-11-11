Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1EE528468C
	for <patches@lists.linux.dev>; Tue, 11 Nov 2025 18:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762884935; cv=none; b=CxJzL5HFaeLbSh0FvAJ7yLjE8xg39M4HhzFm5J+OvGv7JNl5roI/nc4wEO5yJvq2ybAynFV565TUUe8Cbd/RVth9tUhEpa+AwvUBxZlb8N9TbBBGpvkXveHvY+L4T01x9mAxzu2DaYkc6OTshFu4Edi43kEeAxNCsCZMfUg04qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762884935; c=relaxed/simple;
	bh=WY0tvD3JrT6UDkw/8hTycx0qbVjC0GxEVNXJGB/A9dc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z6D9ab9/Y1oPifBZ0r1tjIsZQLQDVpvUkzid5Ip5nPVPYE+vFaN0JsDjrYzmlFzqsltpFTrn4gZVBe1Dzw12JszYC5+6JNl/RDDFIspi0OBz8qtddOjSEqMUJRT1B97XYS9VIxwGo3mJXt++PapuRrXgxr9K8Eo6X93e/uXKoEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=UgWPfdbZ; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="UgWPfdbZ"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-47777000dadso237915e9.1
        for <patches@lists.linux.dev>; Tue, 11 Nov 2025 10:15:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1762884930; x=1763489730; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wYuH1i5ZoIizzTTIcboUh84PgIhPsB1tWiXRAjKgYIM=;
        b=UgWPfdbZMvzRAkOg9xe92P/MglZd6Dj0H4dLX1NsHA+4RxCEiuTf4FL98Iba6Rzk5P
         5kW72v6BjovHNLWfl1oT4nlg+Shfvd7ifz4JMCFShOjCRZxdh4n6gy3x1tTexDw30gq8
         1xOIvNEfYeDuJZovFYascEy/nJA3wSd4IHotSbewUR6+5Al3AMtEHeUQzrmGPv3xEVE6
         9UliBRhj2KKD2nstmbzsCgvaa0GyfD2oT2vBPwGkbiSIH+WWK7/OMBKtDFWlngUTlJac
         j+bt7G6+MyIBQPemUB6abCAtVQb4ewEKnSk6jIxGhcB48mvK5pE6lGbOiberea4TXfXA
         5HtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762884930; x=1763489730;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wYuH1i5ZoIizzTTIcboUh84PgIhPsB1tWiXRAjKgYIM=;
        b=vMkhNDg4HcZh2ql6MdjxauS/AGyUW82vAN2X8LfqF12Y3bnU5orrAnhT+pOhwCglCJ
         ay3CHiytD6cZgy3xFxcgpLvvSR7jsdygu7Jq+4ZAb7UoHctTTMVOLk9Lk1KgpXp5nqqP
         rG5+pJ12222mxySE4tzKRYl2EgW8fepoquRSxJV4eZ5giOQVZHa8PhNea3uraUMVW+CD
         56PT5kKlphw0ZJ5s+j+lQ3nizNT4Y8gI0sc+LvYHjjKGZ2uE4zj5KZ2YbVMIUgoa7a19
         MbxcSxP7Cw22oXL7q9ZbYKKhO4YeJJzgzGv1AutjWuJ6pkATLgaMaetGD5urPsZ7/Njo
         OrYg==
X-Gm-Message-State: AOJu0YwTje0H0GzGsTV35r1/S11O++NDcYHYFfbAqVDJZocDfkDcrQti
	DsdkWtfJka+bh6C7fz4+Hl0Y4Vc4Da7J6XOh56GiBoe5IojH94Reh7g=
X-Gm-Gg: ASbGnctXAihrZwzVMc9wknp5VNul0hWRU2lvlBSfVYRffN7+/uGNWBVu+2wLuhcoFBB
	DCB3jzbnba3F2DG0UuCTgbDiI9R4j5K0rrvM5jP7ye2t2fsvKLtbYbumu54+kJCa0/c8kl7ijSM
	yz+986sDiPK1FCnVM3SoK6+AOArhlR+AgBqLu23CAKO42q/1i6D8Y4tHL+AmTEDLcwJl0OpfKfA
	8sqsDMx35DROAx3kPNc7SLjkY473VYWf2531STHXTjpLCE24h+haulrJaca9zgWQ26fItEheJfb
	o1QusJb68V97XeCwsXKYwXcZELnOIKeRT1J7G1Y8k7pVXat2uKmYJlO2ydOEBHR5WO3Z9tCJVja
	qdzcBqs4wUc67PrnVMbEuIY56KjHWvmfokeNQMwNZYD6ad2sIjVsWPwTAvfheHDEqmVqkl3wuFv
	Jx8YOD27Amsm7GZ0JCmXBKW7Dm2mNESJ/5c3jZD0FPAREo7kehJW4AvxmTExMuuZs=
X-Google-Smtp-Source: AGHT+IHIoHZOFXMv7iwBPA10zJJM1peaNTeyWqz8HkDkOlb0lFxAYESnE/oaas1auLh1AqL4deR9OQ==
X-Received: by 2002:a05:600c:45d4:b0:46e:396b:f5ae with SMTP id 5b1f17b1804b1-47787046a95mr3297515e9.16.1762884930128;
        Tue, 11 Nov 2025 10:15:30 -0800 (PST)
Received: from [192.168.1.3] (p5b2b46e7.dip0.t-ipconnect.de. [91.43.70.231])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477815faadesm25345635e9.0.2025.11.11.10.15.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Nov 2025 10:15:29 -0800 (PST)
Message-ID: <870f0a18-8a5e-44c9-9270-8d3a70ce2eb7@googlemail.com>
Date: Tue, 11 Nov 2025 19:15:29 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/562] 6.12.58-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20251111012348.571643096@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20251111012348.571643096@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 11.11.2025 um 02:24 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.58 release.
> There are 562 patches in this series, all will be posted as a response
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
