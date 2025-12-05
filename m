Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B95C732FA04
	for <patches@lists.linux.dev>; Fri,  5 Dec 2025 12:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764936719; cv=none; b=eEywU4fHb31ouSRVoxKzJDGQ4dPPzr1+13BYIfWDGG4LK7FCy+mTA2NfiH/XKN98aZRI/C6546mn5sCN7o3bgaKjxmJQUueqrCNLal4382QHbJlQtvhe2KtsSdNmcX5NBWyrlAygr4oeidmE0yk2nW7nVH14UWX9309Gihr6Spk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764936719; c=relaxed/simple;
	bh=qhWS2Ov2yo+WOfX517AcSfEUE/SzcRZure6/nh2XuAM=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=FadIAdkME8WnjyTl+nfsXs+Ofqja7CVBvG2Yw7Oycy5uLNidBF1DDC0p9I7gxvXJWV+S7tXpl7hIi3N8j7PrYIp2OSPOlh4QkNHY0yqebXIzGkzMM1OEM0F7kK9v9eFnAUQXFh9PDU2Jmzfw0mY3x+ix0qg0BNK0A1Zf5NG15Rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com; spf=pass smtp.mailfrom=sladewatkins.com; dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b=QLyL3tMM; arc=none smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b="QLyL3tMM"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-787d5555274so20134727b3.1
        for <patches@lists.linux.dev>; Fri, 05 Dec 2025 04:11:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.com; s=google; t=1764936712; x=1765541512; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+DffUo3SJ7992WJ7Sey4PawC2I2N5kwS1rfUFe0ilrU=;
        b=QLyL3tMM0FWlGsRW02owEldFaSHjNzKu7UUMxyqDpRMDQgD5NnVEKCHL9CIJXFLkC9
         8Mv2QsWoJqYdOcWu0KhKIB2k5T7On67tvpO4iDuZ48Q8Zvzou4Rq6A4HBcCTyBmbU7/3
         1GW1LCNkRc/bdR7aOtCZ7/FRTRQl8zmjt7cTkXzHWi4s0Aj4OIMpp0GQ5kvVV4TL90gO
         wGb2/92zmfi0XYQhUdNjTq5RnARGZg7SApoFccuMPVyO36t/HzISuyxNwsLnLAnrIup+
         XSFkpudfd7e9qSCkr/Q1zR67pNkn2NdhSsYUe+WzjYQH09BnyvLK9apBP/KwW2kY9JL1
         idYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764936712; x=1765541512;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+DffUo3SJ7992WJ7Sey4PawC2I2N5kwS1rfUFe0ilrU=;
        b=NEM1OEL7O0svZBZkfDN6bocnfR5sm2foCtV0+QOBnkcwIIRiKj7YEYwHtP1xmjwRmB
         W4skCQoVnBOkQlYdHbbtwlk9EAvSEzJIYQQoCO9PjVQ4muo5tbC5mh7RWZ5/I6n/f9qI
         JdoHpGIWSA4fn5c+08rL1C9tKnlCeriGBa0LchcivRtV8ushgZh6/zE2mdxSA68wqnFV
         XDI8tz0pltIvjEznQ+DqYkcFjNcLtRfsiRY/tyvo7oGPMtPD/qdAtbIH7UNhZr0wszno
         jHqXMIwlLAOMYY2wiJBBXU9o3pLE9ygeSi9hQQFUXeWQ2XBN/Uy2lggpAFpRMiOGsvDJ
         Nz4g==
X-Forwarded-Encrypted: i=1; AJvYcCXuOolRmaHG8S4cnXYgbZAuxcQnmcFbJKf0MeJF5oHSlWk61n5dBJSLdq9XhuI+AQgG+FcJ6gBX@lists.linux.dev
X-Gm-Message-State: AOJu0Yz5PVZk91+Pkw1S9qae+BwdXCKAuhMgRI7QDc/Tzht7gSlXU3xo
	eNyyaBVnNuq/YR8WE2EkuaRuYNrG2Csa9BlDHHcITVXuv6Nr7/BDQoB5b+LdP5+VxFqv9dJb1Vo
	8POSP4fMAdNcyI2m3ugSiJUv+y0qM+/zA/ZNgyV9FaW38JQ6mC1WdtQ==
X-Gm-Gg: ASbGncvVe6WUhflOPInS8Hu2OG3O1hHdHnlMQriRK+td8dP68WuyTqrSxwHOYo2KAjL
	gcBUVI+vKVmFf+VNvU1qo8AAQRpCRF4Hf4ujC+IZkHvL/oLeKLQPha6qnfYWIcQujh9uoCTefCf
	T2t6bl0sycX0iVVsGYQrahKnpgyTslb9OjvtxwLD6XlGFWEA7r1SJvQ1d9fsZZqd3D4iDSFNTyx
	E5qFnWuM91dMet+C6l7W34AX6sxRXcFCAz8LpMd8reo9P0CikJgY0VwK3AnNombh8ceH0TZI0qP
	o1wZhWzT6Bc49pPyX9LXJdDirN5U75iDGBwkOkHMcZKv75gUkkGODg1NguTKsIijCuiGMr1NxUA
	gWb2MiJj0Cb3+Jprl+WA9V7wAd0eyFIW9Tqx5TCnA8UEW4OmAjxrCPjdj3IoZd5ei5Wb2/lEHKE
	CTikNkjAFdhi24aXdL0A==
X-Google-Smtp-Source: AGHT+IHYVc36cpPq5ngmR0YZqgbwnuoCOebtHGfs0UTc3oJvrCemjRMVEE959gySqAQH3Vitb8v5hw==
X-Received: by 2002:a05:690c:368f:b0:786:bce9:b0f with SMTP id 00721157ae682-78c1880c433mr56494017b3.14.1764936712395;
        Fri, 05 Dec 2025 04:11:52 -0800 (PST)
Received: from ehlo.thunderbird.net ([174.97.1.113])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78c1b78e8b5sm15998697b3.43.2025.12.05.04.11.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Dec 2025 04:11:51 -0800 (PST)
Date: Fri, 05 Dec 2025 07:11:49 -0500
From: Slade Watkins <sr@sladewatkins.com>
To: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: stable@vger.kernel.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net,
 shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org,
 pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org
Subject: Re: [PATCH 6.17 000/146] 6.17.11-rc1 review
User-Agent: Thunderbird for Android
In-Reply-To: <CAG=yYwkbpW8KG8ks9QGfOroV44sishtjFwvhnxBpD9O2en+7Ng@mail.gmail.com>
References: <20251203152346.456176474@linuxfoundation.org> <CAG=yYw=7i7O7nLLDQ5hdP03wHFSQ04QEXtP8dX-2ytBmiJWsaw@mail.gmail.com> <2025120413-impotence-cornfield-16aa@gregkh> <CAG=yYwkbpW8KG8ks9QGfOroV44sishtjFwvhnxBpD9O2en+7Ng@mail.gmail.com>
Message-ID: <F776C81D-B1E8-403D-848D-1C6A189E6740@sladewatkins.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SW-RGPM-AntispamServ: glowwhale.rogueportmedia.com
X-SW-RGPM-AntispamVer: Reporting (SpamAssassin 4.0.1-sladew)



On December 5, 2025 6:51:36 AM EST, Jeffrin Thalakkottoor <jeffrin@rajagir=
itech=2Eedu=2Ein> wrote:
>On Thu, Dec 4, 2025 at 9:46=E2=80=AFPM Greg Kroah-Hartman
><gregkh@linuxfoundation=2Eorg> wrote:
>>
>> On Thu, Dec 04, 2025 at 02:38:10PM +0530, Jeffrin Thalakkottoor wrote:
>> >  hello
>> >
>> > Compiled and booted  6=2E17=2E11-rc1+
>> >
>> > dmesg shows err and warn
>>
>> Are these new from 6=2E17=2E10?  if so, can you bisect to find the offe=
nding
>> commit?
>>
>> thanks,
>>
>> greg k-h
>
>hello
>
>6=2E17=2E10 has the same dmesg err  and  warn =2E
>

Hey Jeffrin,

Can you please bisect and find the offending commit? We'd love to figure t=
his out, but can't do much of anything with no information from you=2E

Reading your previous emails on this, it seems like you're using a differe=
nt machine=2E Have you run this on your usual machine to see if it builds?

Thanks,
Slade

Sent from my Pixel 10 Pro XL
