Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40092241665
	for <patches@lists.linux.dev>; Mon, 19 Jan 2026 10:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768818998; cv=none; b=gJMYKiVlrBmiujHwILT92Oyekh9HMpR7ynCrLNsi4Z2Ik48Zj70U1sv6I+CSlNeT5P77+0PZH3RRX3E0ribtaEEljbUShL7ivN/sTJT6iQLUaCMKl5mq8tqCAHkPBe/bDrWy2wNFJCcw70HQ6qDT0euxLSRCJc69bX3rcyoYDZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768818998; c=relaxed/simple;
	bh=fdSZnItbnWe4YOr23M55N7Lb5w6z1z0b/nMMiJqGKVY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Znv3gmx/bY06asvNvLEDP5HNnwG11VEqpATrJiHFAgF7OLX7LlmXUg/lxNxR1aiGjT3t2P4nNFFTbTRS6TC5jS5Bcf9dAbSvFJiH3C/Ehx5hH14OqRS4BZCSQN8fXT/sW3itmWR6YssYe5zoeJ7pyQhXHioADQnlahzViBsazOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=0n/MvWZG; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="0n/MvWZG"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b7ffbf4284dso539931566b.3
        for <patches@lists.linux.dev>; Mon, 19 Jan 2026 02:36:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1768818996; x=1769423796; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pExUEOHaA9xNhuJIw+adBh5OVY66pOfgQ5oeHIFkeeY=;
        b=0n/MvWZGX3AheOORLnTrkVSSc90Mt4QlpIRsoksmdhevnkUf4jWShdZv68ViaMiMRz
         YPgGoQrMGtqFO18E6bJvFIXNXQPZPAsABg8wKy56++OAeoMYxghN5ozasbgQsFGQGjyw
         g+Nm1ELNdkl1FXpKQ7wZoR7OXy8L33ilHndGHnCPFrFT4xeSszd6xgRddKME9sLRKuaw
         8LzV2tnT+Xs1O++a0hdiwJn5zxn4kzQl6ipC+BrWjkC2rRV3RaA3NWDolReyGdlMPIZR
         39xyGq/CMfGArQR9qwclUYOQWTXwxjje/43dgKGjNzkJAys2AZLxaT/WaJ41jamDhPVt
         +CNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768818996; x=1769423796;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pExUEOHaA9xNhuJIw+adBh5OVY66pOfgQ5oeHIFkeeY=;
        b=kkuIR3/EIeujMbB4YMkZP0B8Hn4Jyud2C+LwVx1wohqObQ0xoMJospY+bWPf3Ws1Dg
         MuwR2hwCyxAXNcZpUqaUW2TgcFJqI1SB72a7R+y84KGNXtzv6GgzMp89Aq5mGhPLq3Hg
         a1iblQrXX6Nap61dVFJal3FX3Uz939j1/fbh2f/FIzdZYkzwqFBkz5mJgv4Nt9pSuhnH
         jTlAS/9wAYoRJBzVze2kXWpWr2Iuact10y0GtXQgqWGBdRjKtqRHd7b2+R2XvqBiHz9+
         vVcSCreU3l0tSrtcaHtOxLozHq2ZvlC1Da8bako5Qq1gV4+8XQzCr0T78EZ/IcvKxN+k
         VezA==
X-Forwarded-Encrypted: i=1; AJvYcCWT87nTn6ygqIhXLCSxpJdH03dnIANC/5lpMzSHZ0cA27VDnMZmGw2mShKWbzSJlKlhfbTI2iMq@lists.linux.dev
X-Gm-Message-State: AOJu0YzCfypsxcijZ9qc4bytVUD95exHWFK3ANjwm1NnlZ1Z2Fhm1XXu
	LazTRe/5Do0g9/ZvHD/vhHi3zN1JvTEtClo/sRiRjILPLdAiWJEBYCMZ1ZycIVaWHUnVhQvgAe+
	0DXdsX/RG1mGNuboGUWrhf+rE+m+yOmHLaMs3W/9QpQ==
X-Gm-Gg: AY/fxX4FA8V2dhxYdEUMQx5J7fTVJjspjyYwEw0gmUkCbgXmEalhqFIL5KlFaDH0h8F
	hIy5yIoTNGZFZ4kc9D+//ZsMmMF8SihvmTW7iFUCeC+F1CQy0dC7MHmsQZBiFgpb0MT6NBQgx/D
	gqt2cjXNzTT9Vhbgr/5VoIcd/VDZGPmXyBcJWWD1G7e/y5tCjQKOZ2ranYt8a6jRD2RkSlEQDk4
	l10FRoW05p8AnWJDEcMN8RBvYEqOYFgKNY48kesIYP/OvbiVM3PIWTfOzQkLruGlhztIism20KY
	4QeIKJCy
X-Received: by 2002:a17:907:3e83:b0:b87:7e8:e268 with SMTP id
 a640c23a62f3a-b879300cc4bmr943539766b.37.1768818995635; Mon, 19 Jan 2026
 02:36:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260115164146.312481509@linuxfoundation.org>
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Mon, 19 Jan 2026 16:05:58 +0530
X-Gm-Features: AZwV_Qhgw4EwW6jhkOQm3Hg9TmTF_g35hNsXAKMoQ9WqkvY_qlsieTpoQ8-Z5Ms
Message-ID: <CAG=yYwkgtiSbzSAPK+G8DgkPLsByUX7QBE+LiafT5WScBzqRuA@mail.gmail.com>
Subject: Re: [PATCH 6.6 00/88] 6.6.121-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"

hello

Compiled and booted   6.6.121-rc1+

No  typical  error from dmesg -l err.

As per dmidecode command.
Version: AMD Ryzen 3 3250U with Radeon Graphics

Processor Information
        Socket Designation: FP5
        Type: Central Processor
        Family: Zen
        Manufacturer: Advanced Micro Devices, Inc.
        ID: 81 0F 81 00 FF FB 8B 17
        Signature: Family 23, Model 24, Stepping 1

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>

--
software engineer
rajagiri school of engineering and technology
