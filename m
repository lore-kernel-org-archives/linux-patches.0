Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com [209.85.222.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C2E17579
	for <patches@lists.linux.dev>; Wed, 31 Jul 2024 20:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722458424; cv=none; b=W404Y1KVyvfgTc+61lP+OYRb1w3UxeJzZnASznzHwAqNr0moLMQqjbuLg0l9L8YbnmSvfnPo067WGMULb/I8ZgLAcBWY3/nqY2a7MRsMyx70Pgge5Hl9RVGuVsdSv0k9m+bpaDI7WIxue6HnDbB9z5c5PR/quTu5i2/7zQUKtAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722458424; c=relaxed/simple;
	bh=dnTCwfwpR2fZ/U+rLRxcsXNlPsZKuO1GAVjcoVB/T5U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ShXzwFeh004CbGb0GV8etgERkq4DdFLiimscLPiQur1kk8Amn2Npc9RLyIxfUCVtugj4Jo7BV5dcp8DQOLXTOIpSTBQMH/PmzS2dmMxejikPNdPgNk6M8vc9UKXiuDsMcyp16jy44GbK3LI5fqug8Q/WQ0klTHRSBJOFZ7tfFM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HTD6jOSC; arc=none smtp.client-ip=209.85.222.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HTD6jOSC"
Received: by mail-ua1-f49.google.com with SMTP id a1e0cc1a2514c-822cf222888so1730798241.1
        for <patches@lists.linux.dev>; Wed, 31 Jul 2024 13:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722458422; x=1723063222; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KfFH5hFnCdWhgM8cvYhXX6WsvjJlUIb8zg/pRIkwRzM=;
        b=HTD6jOSCaefcavw2I5ak2LvGeMF2I2RGdL47RF47XZoXjE7lRDh0D7Vy+YFnsvgELN
         59eGtEJBsdy6j11Fc7U0kuccOchJwLBKy89fc8R5hFamKPC3Ml6WlITJW/XpGAsWZR5f
         0vjdBoBWs4wpbmjz9IKcmRbo8jpBvl5inQamF4x5CmNvVgNhsh1sPfzEn2c4sU1TWYqH
         p8QH636rL6y4NXaVROcXMFM3H2YIaOnfXo4cAiSP9/okTewyKN0K9J6FxDgmaz1KOig8
         yCWGkxGujShx3MWz8TKYdrH8UuV9OlQg80GTnZowFsOZogmHqWxTBLXGvLMzdiPgOZVx
         0t0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722458422; x=1723063222;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KfFH5hFnCdWhgM8cvYhXX6WsvjJlUIb8zg/pRIkwRzM=;
        b=Bkh48mlmNF9SgvA9Tf6cY+tOZJOUJ0F/CgQWYcHTDRNsb3bnYq2ISUIxwIOXDeb4e+
         IgQSK0RutcZvrEwYE+n5QByR6wTjK133qbScbSYRG0/ahq3ZCMTkkQiE1GVqk/kjrfZ+
         ul7hjD+DALOj5MROIl4ey817YLI11D4vTQy5bB3tqRkJSJznRKUy4XDh1NW51VsdaTOP
         VVYYp2HgW8xZ7Ee8f0M01ywJSY64Awbma7r5JGQx3b9DGi8IPaLvpycvtWpdKfFt1Zw5
         5SiBM2JRDT9hxv6wAuU9ULybAvchJf+85QdZpNLU6+DerQhsSQoNMohIlfyxc2ba2li+
         xOmg==
X-Forwarded-Encrypted: i=1; AJvYcCVsy29O29bDxSMv5CIEzp94lNYdFzEBHBPv1HTJ/6Ul9oRu+N0HJOXed4yGdFeTfuRjPTGfeDeN@lists.linux.dev
X-Gm-Message-State: AOJu0YxcD9a5lwoo/7XUoclQKRLlB0aaRNeZadS1/Kw3yNL3K8zoGvF/
	doeJV9AvfAXjbB9P3HAdUazG9xe6CckVc3iQrA7SBAYE/+TYJ+d2pyD9PfCOy8a6Du56P6RtHls
	FyTxLPQufTI+/mx92V/urMEeh5q0=
X-Google-Smtp-Source: AGHT+IGHSp0+BJUMLdY/YTJtjkTxtegSlcf/ZkjGU1NcHGdafybQ0qoB7lHBh2nPjzA5xooIpdoBAf7/fQXoZLQk+mo=
X-Received: by 2002:a05:6102:54a1:b0:493:e643:bed with SMTP id
 ada2fe7eead31-494506e171amr759434137.13.1722458422202; Wed, 31 Jul 2024
 13:40:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240730151639.792277039@linuxfoundation.org>
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Wed, 31 Jul 2024 13:40:11 -0700
Message-ID: <CAOMdWSJTaczJy6U0jC_8b+_M3Mqw8_wBrV_Ns_35OT9COZw-6A@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/568] 6.6.44-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.6.44 release.
> There are 568 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 01 Aug 2024 15:14:54 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.44-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
