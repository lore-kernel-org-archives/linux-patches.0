Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A1333F8A6
	for <patches@lists.linux.dev>; Wed, 17 Dec 2025 09:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765962309; cv=none; b=JYnGzhsfALeZL6xMFw1Z1Rs4XUC2b5v4kTvqq/DIrJg4ihH0v4qACp0N2j/Nx/5cT5DPGQsFIYng/dY3Uw/cDBXrMnXyTwULF4wqpLd6z4pgq1y6GUAlpcZkYy5nXZKF0djO4oiDUD0q/r3+UNJfM5P3KB8EHrTbukThV7IM+p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765962309; c=relaxed/simple;
	bh=OM4FzyVYJXN7141I+sRVlCwJk02pcxDkeltYzT5wrfs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GW4C8V1njnP/78nGeh9P2YO85vdcHtmLE5YSq7MVqYNANc0WWVvM7G1WA3OlWcRzqn0/26cLTrXkcCJpBaFzBfJyQBCdL1GH8Iy22oSN/pKkh+/EiQUIqb7KpiJUBTJWfndcG43iCzz8qjWKHeLmOR6jvLS0vi6qTMlkvXRS8fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=C+75nc/v; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="C+75nc/v"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b713c7096f9so916293966b.3
        for <patches@lists.linux.dev>; Wed, 17 Dec 2025 01:05:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1765962305; x=1766567105; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zMkVwpIOsWUZvQIJ22N4k/LfmJnYwu2A7xQiSxZ5o6c=;
        b=C+75nc/v9kcw3j/11YL4YANJYJNkeEUUpyA35LmzzKmN6Vh+ttn6yMuSdTrjSLlyG5
         +duo3Kp7d81yTiX/rztDydbfyXEr92ASfaL1aYaF3QfWHFSViFNIQp56Qme0dGtS9so0
         Ivc0ph8Qsc4veSCxDUQowVI3/vgdXVbZaduJ28vP0cOcpdwuvJXTujNhkc5se4pgO87w
         5E6dH4AMKPlBtMc5b6P7tcYc844vnz8mh3Sd5oVnyKBxcxUGzgyojSdUf5PmwW7acvJt
         1GwNMXP9EnA71ZL1+suIpsOqSjHgZsruH8iGDVV0gRY9WxrP6tBVHwaDfKb1cppsoC1+
         D+ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765962305; x=1766567105;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zMkVwpIOsWUZvQIJ22N4k/LfmJnYwu2A7xQiSxZ5o6c=;
        b=W17lecHlpzEBqLi70c4Scs++X7fd7lDhoZAH8gohiQeKb6MgjiMB75O9hnWBr8tEGe
         YttgmA3Mfp1FgovqtJUm31Y1ESQnP1UOsCgLy6XA38H2EI4iR7/Fb/xadhxs608IAZf2
         NagovcShBN2AOcMdHpJ+9jdKe1JxhDdcr5i2Sq3P+eJ0bPY1wTzA+KCm2GnkBhMsq1zA
         52BqRHjjDcZWREv2IllsJwM/2j1mxvljoXs/hNSu5e/N69YG2ZzbTWk3psz5t1/7t8hA
         KLM4O6KRjUUkwwcTXfXsfj/YKYj3xtcamjPSkWACyuQB1LGd6G254XjVOaelpHOnoL0R
         feGg==
X-Forwarded-Encrypted: i=1; AJvYcCXVI2fuGG+ByiKFvAJcvMfViWmzTEPGlNltFznqTuSs3H0hFAIaUN6y2sgJfx17WRV2qya2txqO@lists.linux.dev
X-Gm-Message-State: AOJu0YwxV2SZzeiaUHOGEOjQbkcwfrq9hG/wzFovCp7difzYJQKAXWw9
	AYCLRVJMBaK3/bCnMiRB7KRXE3l2a8wgkAw6bWxbdYsTzcfQlQ+qU/6B/7Bs/l42psaP4gFsya8
	uyxds3EfjXIDFIEjTcNcRHVwYa7BQfbjeX/Q1D59GMg==
X-Gm-Gg: AY/fxX5xRn+GPUCNY86gX81eVtbZ7mezCmW3dci5Y41W+1MgKd0pVaa0cRUiFMcQCTa
	zDuLfx5pjoKPP2B7jsdCO4ut2yFgYeQc+rKTqujdCOoUDwQ90oNfd1n07Xks4nuwlQqEOpxbxON
	iY7+2h3l7q7A5zbOBRvLAxK6wph2Uzl/BJEK4/icqBjQmHqBivtrSM3ZoERi5IuPJMc2MviGE7U
	IMpZ12uxHEXgopQN/cwY4GCuzAIJJ69i6YCUSAl3dSAy1pbvm4wjANNpF/UpNB+EvptbaY=
X-Google-Smtp-Source: AGHT+IHtMkc38VLU8hjjpSM7ejcsH5D0kgVDjWS6P1V7a+lKrYAhAMrBiY21QennLuHiErrmDl/2K9v41bemwj5tthk=
X-Received: by 2002:a17:907:3d93:b0:b79:f753:68fb with SMTP id
 a640c23a62f3a-b7d235c7f02mr1960617066b.4.1765962305265; Wed, 17 Dec 2025
 01:05:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251216111320.896758933@linuxfoundation.org>
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Wed, 17 Dec 2025 14:34:28 +0530
X-Gm-Features: AQt7F2p2uIrAAXFtmq52ONtkGaO7LLartmy4enH8lnaPNuRu7W1luKiciP3JYJc
Message-ID: <CAG=yYwm4Q_q3ZzAUg639Tb5Ruuyo97Byq8iw+by02Bms_jUAUQ@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/354] 6.12.63-rc1 review
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

Compiled and booted  6.12.63-rc1+

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
