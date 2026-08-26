Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A447424D59
	for <patches@lists.linux.dev>; Wed, 26 Aug 2026 14:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787753655; cv=none; b=DMP1WPZ6K2w1E7+H8t2EBaJwH9XlLBdca6z2MVYZp4f4+j4+bp5WUnI4t9gHQkTDFCoHKUtu9mDe3iPwx5ZZKvY78oFc785TTp4HmAzqAHwkiP/HIkx9w+knlHUDNgZnE7Y8S5KpFgrRGpeEVfLaCaLt2ORcFtJ4bL5ENTuL/t0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787753655; c=relaxed/simple;
	bh=7VaVSmbAIKeSdzFb/kmFo/elSfqVEZgtkpl5F28SgLo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YT5O0lQfp7xOV09wlcldsUUW2Blss4fyPWjgRvQ9cX21/64e3VXZ7ITsEO8UFT7eH8vLMWpOY2r8AOLtAGek+AAVaJ6x/slJpEAFNz1hvyOWWD+XFM1VbBF7qgHQU/D6kUv4iton/Abf5dsKV3VZRM0VFpwJbhf56t38rE63VU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=TYctzeJM; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="TYctzeJM"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c25344a8c6cso4234066b.0
        for <patches@lists.linux.dev>; Wed, 26 Aug 2026 07:14:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1787753652; x=1788358452; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xYjyxtMvSao8mYDot9PzKrn7HcKiXU+v6QRh0L40jjw=;
        b=TYctzeJM+SrZ704jlsqmtVW9NfRTt0syvKUgqykjPakWlbesHIquUXpfNC8yfwUa9x
         6PUQBnH/S+95iUZVG8ZyZdkJy3ztzmQgLUc3BgLL9HfjW9cjeiLX22heIdQHrj6GW5cJ
         NRxJvS24zoda2dC9FD1c6NcXC81DtpMIrUWn6Qd9DklNZpFsEe9QX1J7/FqzbOy9zprr
         iftnfMD1AOs/GJd0aVmUNU2ScI2QXoqRDKd4HhLyhjufCthYXevLdpUvtx7kUsPRMVEL
         cLVZXzF6zEHRoWiWmM4ZkGZiTr4QpC+V5VdoXaMi15zKvGSPFiGpMO7BGqoPRS+mrU/q
         q1PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787753652; x=1788358452;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xYjyxtMvSao8mYDot9PzKrn7HcKiXU+v6QRh0L40jjw=;
        b=G6iXC1f/PjjZOz/GzS+rGnaWq4Gdo8hyhkComZEETOmJYMhV7VHECGV8rszSaI/+51
         OvWqYwn5HawOpN4MMrYWN6Fb3R53kuFwQ4hDWJ7KbyqRHiAQ/rdwpxOwKLLotz2Z/oLm
         yxW8yHrwFQ33oXGC4gGJyc17ksevpGQyZA+fT8zcGU01JmpbyOsxlYpiuMvGNRCFFu9g
         7209FqKmiDCrS/xxdh368TNC2Xr3XMrF6KQMiquQ5UwFZsm0jtApE1pE6P5ZT36GzJkX
         WOOikOMSptuCQUKNfvKpIPhVG6O9K8g3cln13Kh7tQ1atpI0fZzC9kKYddiyYaxFL8gX
         ArmQ==
X-Gm-Message-State: AFuF++mYdF9aJPbXTtMRbuQCL5X9tz0ACaT9zLtZWN2lktILsKqh87HD
	TcJXHk0dNbLSbHIm2fqZxriPuh9sDY1EsvrfjzVO5PaKdE5Day28ZIY=
X-Gm-Gg: AR+sD13BG1SgZHkQrZgBkHLHxEvskTde3nC2FN85pn/EfhphdZlBNN7t+2Rombi82T8
	YuA3KAMerJFb+/3lkqr0EAw823OeTwTZPsxWPCg9Op5+gzescJBWCWBkdGevB2rGBNsx6GToZl7
	bmCQ/+RektJg2rIA1PALGWLiFjB1LQKI/m7JCl9uIjbzn+AcVCsYA7FrP0FH+kEWz9dSYxVlSHc
	hjSmbSWqlO/aF4FPP9IKMadCiQXfM+t019kR3+GPiXbwZHeBcKkkvLJIbTzHnZULZppKbiE96+p
	YWjQq8/Q+OCqHoZHfszPr4jEnYA18P6AMhRluMGK5o4b5Wj1F0VCBhXlfR+PwC+VJEF8JML5T12
	PorOCyVYzZOJ3/7PX3w3EU52fLd5eDYFTGW3qiV6hvJxaq8eexwj/zf7FoEsNSPelMLBV++r2g7
	zIwCHFm/sLCrKB900SjQ9ZvgTnwmGPHq35NwcPd+c8G3rbkdUyLMHBIVEC8k0IkTx6nTVa7K+/V
	hXCvZ1LJdqPYPpXq+nLQ+zzblPYCipMkUyDQdY=
X-Received: by 2002:a17:907:1888:b0:c20:23fb:bb05 with SMTP id a640c23a62f3a-c250c3089dbmr1012549966b.15.1787753651849;
        Wed, 26 Aug 2026 07:14:11 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ace5e.dip0.t-ipconnect.de. [91.42.206.94])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c250a9b28basm377102566b.46.2026.08.26.07.14.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2026 07:14:11 -0700 (PDT)
Message-ID: <be9cfaf6-7188-480b-950e-22f124bf90a2@googlemail.com>
Date: Wed, 26 Aug 2026 16:14:10 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 00/94] 6.18.47-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260825132541.887883084@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260825132541.887883084@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 25.08.2026 um 15:24 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.47 release.
> There are 94 patches in this series, all will be posted as a response
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
