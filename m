Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88AC513C3F2
	for <patches@lists.linux.dev>; Sat, 22 Nov 2025 10:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763808896; cv=none; b=SGJLdv5r31OtdAh+i/IvY2yRZXMgKu/1MIFuj6j/1D1//R8YwXr1WDyV2LreM9ylkjw3RCX1i++/noyjOPH5HWr70Htru/d+orTQAwSh9toBbC5L5Y39fp2OKf7AzW2ZY2IfliMm2U45isSdb8hbp77Tf5UjfMuxlbv1M9NkuNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763808896; c=relaxed/simple;
	bh=jSJpFIcNf5X/MbxjUak3Rvl4RnkPgFKjeLSJpVlanLM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uhdVgU4ysCal7fLKdYdJVWMiUMd5U4xvx+ZXuxnt4DJ/7O71Kx3naN3ld4LxkLP6lSnbw2gVnw7VJVjDPhZKdljXbT2qASGlxzx9jgwRG/elrf/MaL4v1IIoLE/sMeMrXDI8t8Sbfd16HFWM1eYg43qymgW05tuqNz3s/1D8TME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=3ZCBiPkU; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="3ZCBiPkU"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b73a9592fb8so11866166b.1
        for <patches@lists.linux.dev>; Sat, 22 Nov 2025 02:54:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1763808893; x=1764413693; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2w0S/MOvnI2vXjST3F/flJWz3cP9paOtxU+i24HDDD8=;
        b=3ZCBiPkUlZgLt5y3+jzyzBrqUC+0qnVc6tO7nVq1SMycxGGsoW9b27x4igU+KuxeQU
         9MRg2HRNj62EkSXaUfAZzqkJx98OxUzX7t+YwLTeNw84lVyDLSNHM4xbJ2tikpSnBO/B
         xfWr8INs6fwX0gp0PoFO7EEcqyHm1V8M3zmIaI0g/5xy8ANFRVy2/Yp3XJREbGXE18VH
         i6eAk6zNi2ee3oG3z5Scr+4y5jpAdLcxpd7daoMivjq7rZYhFgbe2AH5E5+5HUIBTwO4
         wr/xyMOoanajXTwjUyvJr3Djq96RQIsuv1w0ePUa8opTTsr5MuiVmQoQedtT3ddKc6gu
         qMAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763808893; x=1764413693;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2w0S/MOvnI2vXjST3F/flJWz3cP9paOtxU+i24HDDD8=;
        b=F7YEHgKYHsPrv7c+X4sYR/6zbjVL7S2cCnE9dlTzwxUFkD4SKPRTclds3mvYrRYS9s
         qxllCzsbNnIhwPAlSCBkkKa3cjq72NT5l29vwDunhRrp9zkDPWEHv6iT3HiPoVK88L0w
         oLwto1jUfXzLc/1N7lQDHW3ZR3/qZTL/nrmsl+5gxziEtDkL6DqGd33Zt6U0C7qcErLe
         F12xWnje99yneOzunCIwu+fIRPmC3vO8dqVxf5RaYTQQ6ik2jJg4q7ojkf1BBqLwwhmC
         nY4sR+NhWJgDf9M0VlPwRrM6xUw07Xr1DgYwnMGOvEzQw1HadFHDljicFF5FzFllAS6G
         CnLQ==
X-Forwarded-Encrypted: i=1; AJvYcCWs1yBQK89UhPCnsTbIHSEkmyWDEwGuRFZGO9M3RRc3Ru5/VhFV6LzZf9D4Dg9wjMwk/8QgKVik@lists.linux.dev
X-Gm-Message-State: AOJu0YyEwAsT/+ob0C0dAY5rQq0PwOIVFSlGlm/Q+Us42cWwDMAXNawb
	Dv9wHBUiheEkc8Gz9RTMVPO7kyrttdDFCSfmaF2gYm0whDgKBV5O/m7ItJ8rnkKJf063IHnw7X8
	j+dEsoc8yNzE60ZMPOSuAmmVRmbyGabtHk5UuLHssLw==
X-Gm-Gg: ASbGncvmlVcihKThnNnLTb3xLbLHkE8gAE/6xlIuTTbZc2nczriUkJ+0zCNDnNsLA46
	ssXt5UE6V/a3KYAnkDEU7Lr3+Tte4lzZOq1E0x8ny8ILiJB2VICIYWyxPLSon4RQSk+wqxPHvql
	vS9/JJw2zUQPNhEZctPjZiSDDHWJmb0tKt3tt4jaIsYLxrX1h4iIxS0nn6o7gY31IZGy5ZPvbo2
	yxEI68y4y0bs5O892c8sO9G9d8cX4iktoz3POajTS6WJXz2jSOoZOSGoeCEWBCyVWIO+i+o
X-Google-Smtp-Source: AGHT+IHm6iIMqioUj0kqFlWY2aiwSYZq1A96eq18m1j8ysRo9Qxmk/g7XMdsctYFAUYOsEToSaPEpw8IHANRDuuY5Ms=
X-Received: by 2002:a17:906:6a1a:b0:b76:4082:c60f with SMTP id
 a640c23a62f3a-b766ed82cd5mr744694266b.6.1763808892811; Sat, 22 Nov 2025
 02:54:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251121130143.857798067@linuxfoundation.org>
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Sat, 22 Nov 2025 16:24:15 +0530
X-Gm-Features: AWmQ_bm6vE4prTrmyAzCnYc90PBxpTlMvUPLkBbW2TNuOADdTmiQIPkEUgt63ow
Message-ID: <CAG=yYw=P4-cWVfQBBdRCK+u7r6KUOz3ZmwrZmSn2vakZXT_hsw@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/185] 6.12.59-rc1 review
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

Compiled and booted  6.12.59-rc1+

No new regressions   from dmesg.

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
