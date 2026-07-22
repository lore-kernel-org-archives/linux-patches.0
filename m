Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C9D313540
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 02:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784687185; cv=none; b=KY6gCK+bDnRZfUVpZ6Jt2W6ODbB0MhNyeWA1V04jPfcNFKiRwWetkIy3fNcAESRcTWPhMwCNaUGV7sUp6mUcAC7RRu9pZ/CVi7meFfnzRptCcCLICAeRioinnoSEKZk6WGghEuDlip39rc+fFHVT315eJGQxC3lWIJMLBhWceyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784687185; c=relaxed/simple;
	bh=5l85ZaG3gSh7lkcuF4/Wkn/OxZFAptTtEKNq2yRA4xA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vw7LEmPLjemt1UoEcOrFyvQgpXpC/bcd2UTV46uxL24QKhQDIrLW8tT1QEC7GclhKLIjFQCG8T5o4HUZviTJHsdL/6833He3SMG8vFsFHS3wtxXrkCkJbaRtCe6O1fQkt7WdrOvII5MExkzvIsHdroLZ5alqxY2gyp0giwjkj9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=mMmW3K5D; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="mMmW3K5D"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4954a2e73a9so30770185e9.3
        for <patches@lists.linux.dev>; Tue, 21 Jul 2026 19:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1784687182; x=1785291982; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=HIRM78WOPCxeryq9jVbqu4g0ckz0IZtRVPHzU84Jm+M=;
        b=mMmW3K5D/NAGFn67jjyMiDjN+7YJ6o8TWkltyrDYl2sSI4xGo6e2Txy9cn2bdu3vhJ
         hML9DkgOqhmoPnWijP8He3f0FFN5H9DbqTuT/jYENhvzY08/SBJ59RnvMQbD/OppanxX
         s7romb65EODGmwd+4g1DQHI4CVdp7MqeVVSXmL3FhQl8eDqaCFXp7L/b0ZnV5v8LSsAw
         TEX2Irr+TKWQEmq49ByCw7TZWlKfp57FkOK8tcXx/2+PsYH5YZ5TA0l1mYt0sR8LEaL9
         duHdkK28BZep0xFd8fMudqWDCxqXApQdGUvHC08nLDR9pL6++e2GXnOJeKmzsXNdUz2E
         Xgpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784687182; x=1785291982;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HIRM78WOPCxeryq9jVbqu4g0ckz0IZtRVPHzU84Jm+M=;
        b=hrJ/Y0mmeObWMBVQjA6JItFvHvHaYywsw2kRA1oAjooQSgS9qbzScQGsYVW8l2WbuV
         craATXaAWrGTTLIVsc1ZLQoQ8uTFyUf6nhUa5p+dYHystatySEG1S7kAbg7j4FKaxCwz
         TclcKocPriBSZCTxFucdzzMWEbGmMWdTJJUXDuXVSANt0G65bHVLs6pMMm5JLpZK7rm3
         /kzeW7oKg+XDI+AACOGXNPFBQV1p+HvlVHEp6CAQh4Xp9e0Fr8eE/jMxxn9GBKpMDiqU
         kVfscUC3nBY2coBkCz+vfaLFek0CtvVscsbHjS4St2uNplc6icIaxfzW4xh7HHN0SPpA
         0Bug==
X-Gm-Message-State: AOJu0Yxxl3p18mrlmLgycsnqburM1iZFjuSWWBBxrAEEtcdYu23ECYrp
	VxquRcuSfN9qE6R8IpsDQT2vb4dTaGIoxlRTRlvwojWmKkzeApZm604=
X-Gm-Gg: AR+sD10vBGQuLF3/2Hcc2R2Ziuu9QsIOpxXNegp01hLuYi9ZsiLua9L0rFvBxMkFQsG
	AJ9tNRMA1O5kJJZcCG2dxGayx1npeq+q89SzU0DgmnNYD1w7WwN6vbLZtQ5zms3BHoubEb8hct5
	V3pZeNA2HlD5vI3FleqpOIzXrKN6jzd/3pZUudesRRvACSKUcVcc88mhxnATXDBgkPnliokxQ17
	ekxtS36h6Ob8c4tPVs82b/bzuPPHgNegmIPN8DE/UVPob+7E0NlIrnzUM5cmrswv0E4lydceeSY
	t+bjiZbz/3S9y9tuxbNJ+72V44uUvgCBBqYPL0cjZQgRGiwE/z5OiD5ygt30Zc49BuXMcKkfGPq
	IupvexzgxV1U9DcQ/L/XvOsXDTnqawyhIad7UbPJ3jQPgM33bxg0HbYPWqk0qGZXsuVijT6HGXK
	iPZ5br11y+XXw8AZDbzRMWC0tDy/ZDhFESVwg/1ZEmR2scsKW7il4TBw==
X-Received: by 2002:a7b:c7c6:0:b0:493:f6f6:bcb1 with SMTP id 5b1f17b1804b1-4954a405ed1mr153557035e9.25.1784687182174;
        Tue, 21 Jul 2026 19:26:22 -0700 (PDT)
Received: from [192.168.1.3] (p5b0575c3.dip0.t-ipconnect.de. [91.5.117.195])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85b9a6d7sm1634275f8f.2.2026.07.21.19.26.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jul 2026 19:26:21 -0700 (PDT)
Message-ID: <9df55db9-841c-4588-add5-ec1d29441cac@googlemail.com>
Date: Wed, 22 Jul 2026 04:26:21 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 0000/1266] 6.6.145-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260721152441.786066624@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 21.07.2026 um 17:07 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.145 release.
> There are 1266 patches in this series, all will be posted as a response
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
