Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9706472769
	for <patches@lists.linux.dev>; Wed, 14 Oct 2026 19:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792006476; cv=none; b=ABkDDjcmTnsFyTtvQuus8SeMZ/BUYE81v9eOW3KtnIuH25Qdz4Xe9HX4Ho+zuPsk+fdk5Lry41SRr0scxwtblzWKZt5Lm7X/Rxx1pNAtuyrZSB3Bsi72ivBQ3LoAmjxkttqcjrAzAPrVhl01wmkP3yZub3uWoOgYixRlJC4VFZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792006476; c=relaxed/simple;
	bh=MOW6D0kMBn3vCsCufgeAMRP4i0amK/GMfVl/UCveKu4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MWyJUbsXla9Gv3s+ra+yie2n+EccEEl33UVJmj68yOaQIRi7RTeK7NRc31BCwEMsBMgRediEduCDrzX2tg85eCAyFrxNKoSWW8y5nUNLtTSrmhlh1atN7AlDEIRcVRjM4c0EAw4XLdsuYQ3qKW/aYKCmYoWqJxBMXy9boPBShHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=YSrxdubH; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="YSrxdubH"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a01933b584so39377575e9.0
        for <patches@lists.linux.dev>; Wed, 14 Oct 2026 12:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1792006473; x=1792611273; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NU8LV9dpKx/X09ybSNY/HI7ZWl3/GON7UI3V5fKSxxQ=;
        b=YSrxdubHqiIxbBNCD8sc5ZzryJDvqBa5gQlc4joBANGkDPLT4q/ue7Amh5P2WxOAoY
         7cMKlKKUqoIRkV7Np270JbKSv40U8TuR0rFLM0dLQuM9CjzSpmf74AcZC/A5cYgz1Cwb
         9B52uVxNij9sEjklIulVTghq8b4fw39RK2XlL1fvfYskJxpPC+7bCdUvtu/y66KXNdpc
         C+lOGGHHwtds0lMS96b5PpBnkR4QuD9p1n/lw60lk2pFle7WAZsCpASLjlxfOeioYxER
         oGvEQg9Mp/u8v5C/MIDXs/c97amtVu8WmgNjTALOFbYceix3e625rSkdTxRDVstMVj2C
         3WDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792006473; x=1792611273;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NU8LV9dpKx/X09ybSNY/HI7ZWl3/GON7UI3V5fKSxxQ=;
        b=ZqgcclNk+JuGvryUlUwGTPHvZjHQJS81fldYQrRMrXiuNvMdVAt927yPq/XCSN9Hiw
         ORyLwF58JAFVboi7/AGYzs0x0KvNVdpdIz0A64Pv1UGFdFFLmx00IehLnD+UTpv6YxQh
         X80GX2LRze22odcolLuQJD5Q8WVDnmJGqbXlTb6Lgkuv+BAucF0Wv+9u31G6Ge0whRT3
         nHQ1aVobPcwrUvCUACNamiFJzkJaqwOHEqnZzGt4xIsitQXDeCqPR7RNtzOpcPnebrCr
         dyOar1jOpWcvWn0cUt/ahRZ0LHadejIa/iNOUueeKzyG1uqe4rUaPEk4iNJ8pbdq0tvY
         2ynw==
X-Gm-Message-State: AFq9FYKqgGFV6ycu6sDP//9z7Wrp7qd/6A56iYOZUG+miw0DlEC0vse9
	ZE6ZnWDj4lyD9QA6mg8LqQLseSkEp7ZnnPFVHIReVqtNGH0aPYjs9rQ=
X-Gm-Gg: AYBFou2xGLUAZSZDENBn7xo2DSpKbA1lu3gvi1Q5mtPaxaKkOe5wwv4n6/ItsBkXufW
	cCvA6Cvi3lWBGlbpvkMvRAwQZTWdGMA6fdQNTdY8RVfP35YQftl5p+RjQvq+fSc4zL953MTVnqt
	LPHUG8wDWvs+2aJDfcnKsrUqcV5nHCmBnUa5BJTlSgJ+Cj98JdR6KZSsTaTWjz2yR6z0XeBSgW5
	sJ7muL/MetuhB3U+DR49pnxEmyttODNu0GrCozfUpCakuFD7HijA1md2+bfCyrRQ+AbwYrR4i/M
	LTqIX+QT47nFTJ41s8P2a60wI1iWv/FRZIyxdO1YPOHR2t33QrruFQTKpqfOpcgmXG0y4SueY8E
	tsStDxTLte9WIm+9QIwu+UJfPPMGhTDKagdfEevE+fQM0ovnsrLVpKHgByO/GZ66s2weQOpXYJV
	jHwWFwUxQZ1js+l53AGt7J43oXMj71E8VZXMI2ojOA408RaBNlRYHI4r5F615k2GpCgI6dOHNzb
	eyu/923o5rfniP15CN9qUE7+oEZ4vNnCBa7347FK96ttI89rac=
X-Received: by 2002:a05:600c:6208:b0:4a1:698d:3042 with SMTP id 5b1f17b1804b1-4a18e493143mr311724465e9.6.1792006472931;
        Wed, 14 Oct 2026 12:34:32 -0700 (PDT)
Received: from [192.168.1.3] (p5b2acf7e.dip0.t-ipconnect.de. [91.42.207.126])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1bd66c5e6sm9984825e9.2.2026.10.14.12.34.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Oct 2026 12:34:32 -0700 (PDT)
Message-ID: <628066be-fc84-492c-8b03-1aedaefad4ca@googlemail.com>
Date: Wed, 14 Oct 2026 21:34:32 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 000/632] 6.18.57-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
References: <20261014123820.008483134@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20261014123820.008483134@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Greg,

Am 14.10.2026 um 14:50 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.57 release.
> There are 632 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697v2 server.

However, I do see the same warning message again that we already had in
6.18.52-rc1, and where you finally dropped the patch causing it.

[   83.881266] Driver 'ses' needs updating - please use bus_type methods

That patch was "scsi: core: sysfs: Make use of bus callbacks", and it is now in here again?! Was this intended?
Please see https://lore.kernel.org/stable/2026091451-gauging-grumbly-41dc@gregkh/

I guess it is not a big deal though...

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
