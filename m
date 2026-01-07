Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FEC71096F
	for <patches@lists.linux.dev>; Wed,  7 Jan 2026 00:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767744535; cv=none; b=CGaO6p2aEY/iE9uTFKumj+3CBonh1HPnDoFbBffZC9ES3jHPiH8Uuk4BSJ11ESPamtEFyRP8mZvDqrBU5J679p1pzH3H/M1JNjNW7GyfxU5n/xHI3pTabvIqk+xkadKKZS3UQOzEBBNPazxDBgrcIhYmoOoQVYw3sltGKgBGltk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767744535; c=relaxed/simple;
	bh=H3MbywnQYhF0q6ImBRYUa3nHk8f7OIc5U1hW6sgdWB0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BXnqd7HNkeEJQ606+kxktrbmh3KzkjJG6HzoWeJhwNIO02LdwCHvOMtmPj89TRhaTZj5OTlj5l16QIBxaDoC+tFmOfffz4kxYOqaEcz+O4qZyNk8GrEE+dwtZOQElCSKg4eFd33qtMr7LSWy00WFIpLh6CK7bKo18+ptXk3GX2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=km8BbrHo; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="km8BbrHo"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-477ba2c1ca2so15565555e9.2
        for <patches@lists.linux.dev>; Tue, 06 Jan 2026 16:08:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1767744532; x=1768349332; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pr1oJOK8kea7KVLXItQEa17CoUJ7+nYGQ16AB9nPTIg=;
        b=km8BbrHojOHxTOpXWdNWUXJ7Mn6PwODzHYR9OgXFu88EEcVY0oWAAJ0ote9exuSRHw
         lbJxW6J97JZMORTrKN/b3DA4Z2EueP9kaTo9Htc1Pfo4Yo9ZISa4yduuheWLmMPZVVf1
         xZEKmQMwltZsc4d6qSmDV2UEaJmrz5K/wcqSRJ09FlCVB9eoofk6OYoE9cVoL/QlvWyF
         Db/Zby87IKcX4ECvkYIYRTpPzfuzvzwXh1R89rpwl+0gHgnRXiAbSkj/q7ARVw4OwKc3
         HVjej0PV9rL1dirc6M06xox5OM2HFFfLSTJS1jb081ha1f7KU8T89skrXTTk5WBeUute
         SSWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767744532; x=1768349332;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pr1oJOK8kea7KVLXItQEa17CoUJ7+nYGQ16AB9nPTIg=;
        b=aVH/MB/pYFMS09Hobgr+8qYPQieOcDcCeDnQ5FIz9ZMd4XQm2+3x50bIyPMKOJYtol
         TNFY2yvCpiY6tgXlizdw80DAlxqGEX5itFhDZmUbWXXBYzY/91g+PEN8zqn3BqXBz+lE
         QrhAnCAkqTjSZcwawtbwcPmrKLiIhyFlJb6OlsMgUj6fIYvU9Emzs3sw45Mhc+vnBzPi
         BiTeqcIlCP2586Eg/c+5/TjLI7DwKTZO2etau82+5ux7d2IcIPg9Vlv8j+i8PzgCLHiM
         jXy0wr9uwEho4Ts5lujXJaBx/VbskyjqetrWedQb+AHigCBs8vmN4ic9W/CIiRGIRSwc
         B05A==
X-Gm-Message-State: AOJu0Yw6gxVwK1ZZqKGv+Sq5MLYMUzlTa8DsMtuQ+XjvIyDwg2JO7MV5
	fsXnDOsmza5m5RiGCLW+yUtKcLaoTnKlTmYHoPinUerb5eIjMR9ZHtk=
X-Gm-Gg: AY/fxX7vXWfQAYBEh05cnDkxgpWkStHP1VLT4BJFMZDKpsQwBkG4Mp1S+tOBcr9jjEz
	Vu2OGWOnAbrjegIHVhptPvf+6DmbA331grK83nNahgSpaGSSPCw9IEiSAU9nTHwd7bWab6TVlTZ
	PHDmO8LPWwU/03l3HJ2m2C8KGwtCQSH71Yv72n26+RJvODhcv2LficsOwxWI/k1dHo3S3AoD1H6
	5tHrInakfo4mZLMh/kqX59vYdQovUZamoJYWSPoJPKCn/qXX8uKn4+qTadtWjVtGK7WTKGrJARL
	2TRVJwcuOMnH5qVeua4gkUiZQ0xIMOR0X8lmhe0ba2bL3x1XiwQPYaJDnOP1f9G+RynMe4ay+B9
	x0/5l6wPP97ADzgvt1xmMmUxcC87+rr+AHnWQukNCSptutkEalnt3eMfpPKpKrsAopK+s2eg++M
	JUMEIKtRixSfq0HNeY5TrFU1/MSb6lfln6Gf5AasXUiY67/yN7a04VV40ItZgsfw==
X-Google-Smtp-Source: AGHT+IFodAh3c1ldVuGJj2GQ5Lm+26co3P0nLxGONfOCg661GssmZiIcn7t24GF4KU3m0/mXJ/ukFw==
X-Received: by 2002:a05:600c:a102:b0:477:7a53:f493 with SMTP id 5b1f17b1804b1-47d84b32793mr4673325e9.23.1767744532330;
        Tue, 06 Jan 2026 16:08:52 -0800 (PST)
Received: from [192.168.1.3] (p5b05725e.dip0.t-ipconnect.de. [91.5.114.94])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7f668e03sm70321465e9.14.2026.01.06.16.08.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jan 2026 16:08:52 -0800 (PST)
Message-ID: <43e64d0c-6b4f-4aa8-811d-4dc108344b43@googlemail.com>
Date: Wed, 7 Jan 2026 01:08:51 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/567] 6.12.64-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260106170451.332875001@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 06.01.2026 um 17:56 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.64 release.
> There are 567 patches in this series, all will be posted as a response
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
