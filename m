Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385723168EE
	for <patches@lists.linux.dev>; Sat, 17 Oct 2026 21:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792272345; cv=none; b=sSmMvnE3UdtIZ33SB2oJldiY8luPtLcMnChCIxnMV+jNLCIW9rym6CNURG35xDkk2bNHfO36JFxjGXpvyBji3WfSITYD2EIJ0+//ERmxQsWvpwUEoQu/v1o1Ykq+sP/XIuBRD39ed/gtmPIs99yjyws7k1SnvtCwX86gYfN/RGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792272345; c=relaxed/simple;
	bh=56ptqQlyHesFnGpk+PtWo4QmVljOTxhSInTCjUT+VZg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s84wjJsfZ82DJO+o7Zi0RZrW25WBxONlpRIoW3kKSQatg6+y0wold76qYpF0s5bc4AvUuXyYVvceOpDvDx0UtTMBo7/zBRFr3u/X863q0aZ9ROH5K9AZeNHf1Db5SRZYvjYLOkHpEin7AMuvdIU+xhGCNR34WvHpp/5BFEnFflg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=M1Rd/RVI; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="M1Rd/RVI"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a1d75f2f11so6630955e9.3
        for <patches@lists.linux.dev>; Sat, 17 Oct 2026 14:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1792272342; x=1792877142; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tPqZTZxjS+0hRnBnz4z6hzvbgGGkcWgYGELhxyf+/ns=;
        b=M1Rd/RVIVAzK4FeO9siuVEcrYonxzinaaC21juiY61UD9ceFxAzyTQZJYFNNPYn8wK
         o6vgkXKpMegMiKH2fbvNU3e0hLVtF+iGauyonaJsOcllZj0dZLnZ2dUDkrtJTHEGBl+u
         hv9EH63co/W62oBHUFZezfsv+sh7ok3ceMK8SODW3PZrZAt/IUzGeLf0lJ1hHIxdHagC
         BblVTYLyti830gBhuNjKo39Pkp/bMsotGAqd0XknLZGa6OE5ue0hifAU1w3wG7QkOgEx
         wYPcnjWqw3WlGcGe0jAEu4DWUVm8iIPqiWMd6SF3J9Z9rIBty4QvlYNnFRyFQJtSL4xB
         Ojbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792272342; x=1792877142;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tPqZTZxjS+0hRnBnz4z6hzvbgGGkcWgYGELhxyf+/ns=;
        b=xoEjaGIMiISyjGyo+q1+RHilMuDv3qYivJYzcGhMUR9ttbGgE4dOS+e7X7FwAD51LR
         pCKz9mfj5fvPiJ5qhXQ2RRfrqmt+oVVDGlsWvAobWkBDPfFtTmDSjYP3knPfW8Wry6mP
         SPI2L8h3GNEAUa+j1KklTgSuwdPcDmTqw7SAoyIZJ4EoO7ZcBVMZG3Om5b2h13sVH3xP
         JaTuzQb1UvEpS+NnSy6J5IN7ddduH+dHxyy2fMuIZY216O+R4O2qWB2xbm3MGAkcCSfk
         6ebM0usX2ZGgsDd6QJAoH/LbdCmmrdo8JmcOpBqaPbtG2zg00J1qbn9uPSMje9DdXg3B
         X4jw==
X-Gm-Message-State: AFq9FYI91B3iE6AtexOLdkY69veSitXr99Ooc17i6rPX8HY9zWJRYvqp
	EXRoKrmc3u4ULfKso1mjGmuDSjmR9FfcYDAKMhF/wEHLx3WE7/fvWic=
X-Gm-Gg: AYBFou0CM6BYT1+ZnZUOwWHckeqaiArmGxKqUFoyjPzNsCjzfEEx4b8scQNhActPnxT
	ll9kPw4YZjEJYqgeJOaSuV92/R8BaMSIpxyJBVKUFAMUlcNeV2s5m2/Z7v4KXHR6TOXcgboMui8
	m0geA5CNWtv89z8Cdv8ouQ+O2nyDDIB1RcaVvOEeGDz8P3aLDTqYEJg6ru7nGLdkd/SdnZeAJLV
	AAIR/8g00moln0cgF2UvS+ovpAz7lCK0iUhQY5p7lcXtApI4JyYEBT17sNhx9OWU/MQw03h27rD
	45PGSAVxqoM3lsLcuOeyQol/McM/q1oaFJGPV12N+EetEUayu+KRyNiCn/E6nrZdgdU9I0tsiuw
	jNUBc/lwquGehzkVRKRkZiuT2ao/o1OhHUwa41yGPWq6ahTU90YGHn+PgGTA/GjHwAf8zxPMp25
	jBiX6szyzdKib1nPgkNTDpv9ouNzyNXNe/T4JgEgb7iCFcDeZyO3E6WG3uKrHR9Kc8ZkQRPrmuV
	tRAWQOK4YJQbKeSc4up/v0ifKhkiq+qouh4/BfwpGRJ4Ja0Dx2aUGXHeFA=
X-Received: by 2002:a05:600c:870b:b0:4a1:d487:2dc8 with SMTP id 5b1f17b1804b1-4a1d760518amr73953995e9.18.1792272342267;
        Sat, 17 Oct 2026 14:25:42 -0700 (PDT)
Received: from [192.168.1.3] (p5b057d26.dip0.t-ipconnect.de. [91.5.125.38])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1cca31234sm103050165e9.4.2026.10.17.14.25.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Oct 2026 14:25:41 -0700 (PDT)
Message-ID: <f91512f3-34dc-4dd0-bc7c-611b521f1217@googlemail.com>
Date: Sat, 17 Oct 2026 23:25:40 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 7.2 00/10] 7.2.12-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261017155059.698368299@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20261017155059.698368299@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 17.10.2026 um 17:54 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 7.2.12 release.
> There are 10 patches in this series, all will be posted as a response
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
