Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C970FF9E8
	for <patches@lists.linux.dev>; Fri, 13 Feb 2026 16:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771000016; cv=none; b=glAFNCJj8w3ZZxvefgMmPIj698ERILrALJWYIyjf2/e/LgdUAcsw2nZGkTL9jLN00ZfnTs/f+UkaSLip2znnUOx3rWZDdSAHrdexJVMStZp5OPLDPNpAXLI6wAjGh5tJN4fBg+dRAzisYFWoVzHZztR267+nxWo1eva+P0/yVB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771000016; c=relaxed/simple;
	bh=9YmZh/uq8bir5RxWKfixDxTifj6YnOZOxkqroeS+roY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A5RrY0Sq0v7zqREdoUiOywTIDHUN1VWX2CbtrIOnRhpx0eOtxfLxem9r8sw3QvYfNjSR2xqTzOKfNJvb9N97gw5a9wp1O/pgD6VUu0ZBpEH1mkeqkusMhQDYg+KgBklAF/sJlHhsC7L2aAKqk9nw+BPEWNKixQWHgrlv9Ebtprk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=N900Co54; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="N900Co54"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4836f363d0dso9240005e9.3
        for <patches@lists.linux.dev>; Fri, 13 Feb 2026 08:26:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1771000013; x=1771604813; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=btjRa7SAXxAwy3tcL6MhGx9Z8DwTnzSLSGZM38a16QA=;
        b=N900Co541li9b34Hx7WWnrL461RrVtsqA250Nokyf5i3+NypH4+VBZJz6fPqJ3Ke4H
         MWq93cqRTudwGKhZcUgIFqCYBWA8KBcSFoiF36ciUOJst/yKmvAy+hoJZEFR5fCAdf7x
         eQ21OeHM0ZmpQUH39VW3ILiVsmyMzWRinsesjRcEIzRzQ3ZgJ0oeKO611wc9IQh+r2PG
         +oXLdjjKqkgH+qRpB1qRGtgCxJvaMh4YKf+YJlTDYHcG/rc0W6CTVzcudFL+iA/DW3H/
         2oqgOCETCEXKfRI2XgfAUZtJl9P0WgO7ire1AicKA3RdL9NksPauC02lm5A+cKuqbZMw
         l5sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771000013; x=1771604813;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=btjRa7SAXxAwy3tcL6MhGx9Z8DwTnzSLSGZM38a16QA=;
        b=gZi5sIxf3QNZxGYcNuouLABQN16eKrh+1L/YdYeO0zvhktlfpolk0XsPNi/Huf6f68
         b5fhrUKlsykRlgzVDKoZtGn+c6uGCwE0Y+YowFcUNex9MoNEGE0HeN/3Xjd6x0PXMzCj
         WLJKUTaP9XejWwHAWLHogLjbVH0QwY4O9dn4PkT6XHNB2NQE//O0XiRtCpXi8icmJADA
         Dy9YTCfvLQkcQ4DtarR4eobMctMYxxrqGycEwDiXMUTuTYDljQyTxZrO9BOt5JlRwg/0
         3dpZ19lR454JNy/DSjgRFoU04shNdLaj9SRrG7enMO2KAfOW83uOS+MMfB0toc/irQKy
         Wcjg==
X-Forwarded-Encrypted: i=1; AJvYcCWrPB5Di0vh/jkuYftDGMd3LB7xTTntQ6r6Mj2K6NY1MiXUKTMyrHZRWpYecLTLp2jGNsFR5W9J@lists.linux.dev
X-Gm-Message-State: AOJu0YxPRfT2Mpqoy42H8KHJl5rNJA7SnmloZFPl6fFmHCXxR0hBmOAF
	WOZDxTWWWmjjzK/0e9zJVc4k0QAE2sIK3I+pGmS2uhXNybGZjpimMDA=
X-Gm-Gg: AZuq6aKI9dDN804D74HH/zRcjjFNtwZoEB2NE7ATAVSAz4DHxhMFxGe/UTuwBTaSbdP
	Rg1biRTfwtC6oZ+1lq8CcRN6zK1vVBZOqttFu7LjtAJAHuQ+mz/nPJ1oKIOrGQZb7TIGn+RCEe7
	3IkRLvPz/HNK00meDIT4HAuWVcHC8rqcrj9iH16C8d6M5Dpanl5OVACTwrSw2jEVqqs37IoyMqY
	68A7270gqipNGkVxavl/ajpA4v9jSUGv501yYlIDzVNns8nvBdQHEuHBjIqQl7A5qQ0C9O34nG9
	7B/RD4pLxEryoLs10LFY65ELTcF8UwAdqSFOdKun8rVYunDwPuVorbixbPWVM/PT0JRLsoJUoIH
	JmR2wzjzgAz0Ygf9pDUcygQPpO+tPdbhQq2n4ScMF3WcPki0Ft7Pjz/knr9tlAo3HHv4V2wruDt
	unF3ztZqfmp9yx+VBwrtzYGG69F65go+zo5lVAsnr8r+ysT8TO4JpvIxUyy1wUes81++p2joaEH
	FUG
X-Received: by 2002:a05:600c:524d:b0:46e:1a5e:211 with SMTP id 5b1f17b1804b1-48373a69e13mr46917485e9.21.1771000012919;
        Fri, 13 Feb 2026 08:26:52 -0800 (PST)
Received: from [192.168.1.3] (p5b2ac4a9.dip0.t-ipconnect.de. [91.42.196.169])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4836cd7af87sm110015355e9.1.2026.02.13.08.26.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Feb 2026 08:26:52 -0800 (PST)
Message-ID: <a856f911-c493-4c48-ade8-467d9da1f628@googlemail.com>
Date: Fri, 13 Feb 2026 17:26:51 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.19 00/49] 6.19.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Achill Gilgenast <achill@achill.org>, helpdesk@kernel.org,
 Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 sr@sladewatkins.com
References: <20260213134708.713126210@linuxfoundation.org>
 <DGDX0HGRJJ3N.1F1EWJEDMYZND@achill.org>
 <2026021312-magma-dormitory-53af@gregkh>
 <2026021325-repacking-crumpet-5861@gregkh>
 <2026021353-perfume-drum-3776@gregkh>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <2026021353-perfume-drum-3776@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 13.02.2026 um 16:57 schrieb Greg Kroah-Hartman:
> On Fri, Feb 13, 2026 at 04:36:39PM +0100, Greg Kroah-Hartman wrote:
>> On Fri, Feb 13, 2026 at 04:35:27PM +0100, Greg Kroah-Hartman wrote:
>>> On Fri, Feb 13, 2026 at 03:48:19PM +0100, Achill Gilgenast wrote:
>>>> On Fri Feb 13, 2026 at 2:47 PM CET, Greg Kroah-Hartman wrote:
>>>>> This is the start of the stable review cycle for the 6.19.1 release.
>>>>> There are 49 patches in this series, all will be posted as a response
>>>>> to this one.  If anyone has any issues with these being applied, please
>>>>> let me know.
>>>>>
>>>>> Responses should be made by Sun, 15 Feb 2026 13:46:52 +0000.
>>>>> Anything received after that time might be too late.
>>>>>
>>>>> The whole patch series can be found in one patch at:
>>>>> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.1-rc1.gz
>>>>
>>>> Hey, the link to this patch (and all other stable-review patches from
>>>> today) seem to be not uploaded yet. Is this expected?
>>>
>>> Nope, not at all. let me see if something went wrong on my side...
>>
>> Ok, pushed again from my side, let's see if it propagates properly
>> now...
>>
> 
> It's a kernel.org mirror issue, it's being worked on right now...

It seems only the tarballs are affected?! I could git pull this RC just fine some 10 minutes ago and build it. Adding 
Helpdesk and Konstantin in...

The 404 is funny though, kudos to whoever made this :-))

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
