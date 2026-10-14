Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67FB84908D1
	for <patches@lists.linux.dev>; Wed, 14 Oct 2026 20:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792008811; cv=none; b=E+z/aykiDKdgzhUx1Bo2KmgFxTsmSCvplqxywe9VpEzlMP5DQK78//gEbTeNIcMeGcVkfxnYak6ge9kRe8ZtzJeokNNRfscRugTrSO6xpxZ2PO2xS57nB3sB7yaGexczOb+oCIT2+1dXVplpcqs3bfl6rGGKtUVycNCTcmBn+2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792008811; c=relaxed/simple;
	bh=9GlBUMY9Tt4evjQ4ULoWffGbTfu8IfA43snp9BZJV8A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Kv6qJqpFR69Z/xC2klTqwdEgJ0mYFW6A+v86YWwUSGUE04tcSVNvnpVssMsdFqOw3K4D3jNTrHu/HAJ1NHSMoCfuH2Ey9DOLfEjlmnIvLiDKoI9/JNeRsj3LXUpGe3Em1wX/2hamMiooEP2vfRvCircJGTLCJNbIce0StWAZsHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=gSZyrC11; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="gSZyrC11"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-48b060ec084so2979623f8f.0
        for <patches@lists.linux.dev>; Wed, 14 Oct 2026 13:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1792008805; x=1792613605; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fMcFVSFe2pDmfUyudYthyboJo6z1+8bv8RHgL8W6a6U=;
        b=gSZyrC11GhHyOn6OEKEJkCBSABGdymR62VhdAQBMYc9UcaESdgKc9BelYnjfwjT1bw
         EQGotHAu96nrpEtodJ7EPN2Czon4b4upyu3yx1/mGjoU3kw1yocnOmPO/dGspOR67EBh
         BO7mEMa6imgWbBXNL6aHRjTUzpl0ql2B50wdMb/23ZYL29fcuIttSyyOiCcm64U+/ydr
         1/iMKcWkWvJn9oeTztHIfY7zfTnhQr/i/M8UbmbvdbnQVf3ix7+pIqnl6Lw3R4nDTKVM
         o0Ag/qF1SQunWsSYLP2pM2kO1FqM4Ft+w/+TqqAmYNdtiOCjp8GyHi3iPgmvUJ/0CYgM
         SWJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792008805; x=1792613605;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fMcFVSFe2pDmfUyudYthyboJo6z1+8bv8RHgL8W6a6U=;
        b=mUVviZA2NZo98tI36bTA4pAbefRws30iNmSHBSq5DFAmGA9wZ/KIO/v6ZZeM7JnI/J
         16i8OehE1dBM3qR4dWU4bxKxkUDv3n5dstaewpC1TVIUDEgCYKgT0eS2MS58iv2TNlfy
         d1DjirkYmR2TtcOcmD2D8d4DJ5Mil9SGXrrOcM0k8RYIJgIAa1jMr7K6whaWXaGNlvc4
         Slqu4NzEUt8RFvRgqF0YbYuDJwqYyK7i156C/B+2MegIK4c95SonWwDuO9+C2Rsz9tfR
         NTS5MCTQJuAxPqrR4Lme0E7u+05s2vQPWT2OmFtDnQ4UAWi0TCpd1I/Fz/E1LgaDzYY0
         2yBQ==
X-Gm-Message-State: AFq9FYKF5177v4yy4dcyZm2xcMz3X8FCr/ifw1kWJkLFfE35964EejV9
	PZheEhm8QOZJazT61kpk5wVREElQX5PjAMX/oi9JE1qbUJpKz02ShpE=
X-Gm-Gg: AYBFou3m88gwtgmarqX59qpt4u7vnZ2pXkQXI0h6/DldRvLWhwIv3z8y4Hzl83QRTIb
	JBJesHxQfUb+COH5d7YRZqh7I2VwACEd/LzaX30HvZwP3t2HXNHgk1+rq8z89RNNeMcniTWcGAj
	BsZ3swlaAtTOl2cDhy/gLFg6KuMCcgBiK2/2gUduwvabZOY1cfVx6kW6AqPFddcCrUMebkjF2lk
	vkqLsPMYdmvIWOfNFS4q8hTQ6rDxjBYeVvbi/wLQWF1QqbGaO/kBfw1pPUHp+Vthwn0HAd6E/fE
	ylgJGoBgG6zXuSu7q4ey+wMYSB+lOfb3UUdKQTQTZL7FX7PbJK+DO6dXCFQPJmcS9MY/5cN7ztc
	jmsYnr4RUY2fP0Hd6kG3k8PLyuvP6mM80OCMoTJT1Om8+Y3xYL2gPPRw7OpiccWAXqEKBzHBD0m
	1FBlVrvwmCwdcBe+OGxtTeUc12ZiOOqFcLnpXE6nRtvcAfaaMf8GK2/E9tvRxGEMcWuz01aBW/r
	3uW4En4wvxGUxz3eHUcJR4+Im3O4jPWWliBvzHNgb2H3Jww4qM=
X-Received: by 2002:a05:6000:2610:b0:48b:60a:760c with SMTP id ffacd0b85a97d-48dbacdbca4mr34058229f8f.31.1792008805303;
        Wed, 14 Oct 2026 13:13:25 -0700 (PDT)
Received: from [192.168.1.3] (p5b2acf7e.dip0.t-ipconnect.de. [91.42.207.126])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de0ab4e8csm13344281f8f.23.2026.10.14.13.13.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Oct 2026 13:13:24 -0700 (PDT)
Message-ID: <2ac348c8-1aa7-4d01-b189-9b7665cbfad8@googlemail.com>
Date: Wed, 14 Oct 2026 22:13:24 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 7.2 000/284] 7.2.11-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261014123758.782265692@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20261014123758.782265692@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 14.10.2026 um 14:50 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 7.2.11 release.
> There are 284 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697v2 server. No dmesg oddities or regressions found.

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
