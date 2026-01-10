Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2562024EF8C
	for <patches@lists.linux.dev>; Sat, 10 Jan 2026 10:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768041933; cv=none; b=EPBKahUn88e4PNS4byhJkUhqvO/CGA2cgcZRVKzyT+C+Y0ANQkugLfV6ZRKqiRofLtRo5X5B5Ra/MLFhAMzr/jigoJ0gIQw9nxyJ3k9uGQqbIOjnFHOJrrtVGyTxYkOI3sYgiSybV3cp4Rth0u6HuLkLamdT7MBJvjgDhxaOsZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768041933; c=relaxed/simple;
	bh=RFZldikQMkCTqEZH8vKg7TSQIx5FlJQ4I/ZwY9mN/Os=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N+jX2r5Y2g3gjuDhNwp5GW24tfMl/AWo3s0jry5YVITdeLOwCeo7yOwQsrJGpzT24VydwuVcrJcN5SsCpiepGa0FKXQz0n69zMaHWe9tkojzSomTkn+2P2R/0zLfh315eFHVnuNOFWEvr4BpmpL7yWxDPpPPdfl73Hl6OiffsRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=KPdZKm5/; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="KPdZKm5/"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b86f81d8051so43420066b.1
        for <patches@lists.linux.dev>; Sat, 10 Jan 2026 02:45:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1768041930; x=1768646730; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mDD4gInLjVnOwXV5aynlTcIEFIM8N7gEUkgZcKzfgZY=;
        b=KPdZKm5/L3q6Lsb84P22niUs1ijc18j2suCGUOq0gRq8Hq0D9OItzgPm2nivfOa8nF
         yFPKWEPvdzWxEAuDh478mDmlfL13pxsdJQw5GXMM2uxWM0QGfastX/XppPyZ9MeQnnBu
         Tf1OkMVCyHy/nJs4Yi+j1USRQb3/Fc50M4VQLO/Tu2Lhaw2KeTDyp/FbW4UTIn07/6Qc
         RVTpw3PVY6VgyHgTVOdMF4RdreDoTqj0wIHk33KXU+wFvO9fahOzWzhAd1Yc7GOHhI0B
         NNzYwv42+583l3K0DmMlshdAQrytxdfaWczjFgjzGTnKAJdNUE9NEYrPeMcsSLL5N9Hd
         W3kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768041930; x=1768646730;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mDD4gInLjVnOwXV5aynlTcIEFIM8N7gEUkgZcKzfgZY=;
        b=E9Ak1rNIxNUaMcc8lFHyz0My3/AZzKuiY6/D0dfzBZ2CfrYq/RlkeoG2tkE6A0Ni6N
         8gsyWjmoqr/rqMo5KKdq7FUmauq8lL/zyCSWakDy9DLKuqU76emFpTb60sBd1k3fRudW
         Lj+Aheqp/pmBPPQf5lURlRfuHtIk/ytuTqLuBWYAZHwxpWZUhugs6XydIbm0VQM0ZAEL
         49PyxxNUBR660dhv6JKwvJF7HW+vV0CneTBfah6jaYE88Gba+Jz9PgwL5RMuiP1aOKh/
         6Zci6iagfyIC0THiWH5u8eusVU9Qy9TAnDlwa/slTSt5e4z6+C5UyEmF5c+SdVfHflls
         0O0Q==
X-Forwarded-Encrypted: i=1; AJvYcCVfk0ScvAI15hTLacRtBuVT2P107/diy4lZylPce13AV3Q/UnAoOJKBXjfibErAGBLdJmdPAOMo@lists.linux.dev
X-Gm-Message-State: AOJu0Yw5mBF/I9uke9iPYYUxFy//APE6lb1q2VamAWB8QtiyrozbSPTe
	W7biagAhBQtFuMb6Zx4qcOCM+6JdcvPb/X80JildgTnVZbx0V0pBH7lwy1hVAZQxsmE2pnwNhxK
	3sjwuowMqaz41ZdmtUVbNdu7CdCagfxDXqOj3f0lAoEHkjOMqGhTQOO7UcvAx
X-Gm-Gg: AY/fxX70PI9atU0o0rbnMpO8hdHPo9q9VU6MT0Q4lSnWDRGe+3v9ThEXL9JSP3IFLmL
	ODXiA/a7zXREOhFsC7qWA1HVCtYGwXotUC7b3FHR9cippYqbP7dS6YBqr9J1tZCk17faq8bdKh6
	KIFwQAT885bU82CUPyCei2YUq/fhB0TecyHBMjlQIKT3ycDo4hLUJFKuiO2zACawiRiXn6xABzX
	YdLzsOzRMwCmV/UFE2KtgSCwN/0WCzWv+1vywE7hgo36EA9zCXKPBHaQFV1EnyEtVg2IPQy
X-Google-Smtp-Source: AGHT+IGgoZhDVkixtpshz7HlFqMh1nze3xpKd/rBpJcn+L28SpykEQ1pjsm1fGxrjnpSL/PpcoFuRMP3p1Aw/CRQAA0=
X-Received: by 2002:a17:906:aa43:b0:b73:6695:cae6 with SMTP id
 a640c23a62f3a-b84298aad06mr1171129066b.10.1768041930516; Sat, 10 Jan 2026
 02:45:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260109112133.973195406@linuxfoundation.org>
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Sat, 10 Jan 2026 16:14:53 +0530
X-Gm-Features: AZwV_QhPeLVHL3GJoCDdXgIj-NTxjYMequNQwxjnr36FlDT43eApc9fXJptXTiM
Message-ID: <CAG=yYwm0bXD7pCnNTuKJvBvWN88CqrftHykWD_-0_XY+sT+GUw@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/737] 6.6.120-rc1 review
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

Compiled and booted  6.6.120-rc1+

No  typical new regressions   from dmesg.

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
