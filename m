Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D1630DEA9
	for <patches@lists.linux.dev>; Thu,  4 Dec 2025 08:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764838300; cv=none; b=gfOEejs0CdU1xD34lXZtz2Acb4ut7rjN7iDa0fidshq8jxd1hc/04DC1O/zIS7srPeEoOKmDz+xZVtlBR9WBFneH35HYZVULwYmIa4SeUhlofxX1OeTrehsiKKmpvVCxs6INd2quh71oe8DG6wBR68WHn1zastA8N+n8ml6kXak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764838300; c=relaxed/simple;
	bh=/TxZinxeGe8FZqkSnGDqKyD9UNHHXo3bMabEh96HC4g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JKBlPKmXUIKuDxko65FwyEH8rb7HyyM+/klZuopTH3c3h3qONtIqcx9VKCGmwtsnjozoTdkwy4ihekpIt8Tw1TEjBLGZuwSvoJQ+cMfabN9QSyD0qs6L4ea4TVZSlRKDU9FJSz94sF5AqFP9sZrSH87I3Cgw3P8n58EYtfJI1ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=zoir9E+1; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="zoir9E+1"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b7355f6ef12so121737266b.3
        for <patches@lists.linux.dev>; Thu, 04 Dec 2025 00:51:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1764838297; x=1765443097; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Trh/W13e+8lZIhANIojCqFW0J0vURtDn5XxDF++7gII=;
        b=zoir9E+1wvsSnmpbSWOT7ilQ/fa9a99SuBNtLU4+eswQXEJbVLuWpkHJyRGqY4idni
         VSex20XyUs81uHEfePaH+RletWDDW+Zh6Cnl9LHU8/CNmUuEZ/R6jK+nMuuYS9zAUiTJ
         ASAmiqQ44ZsAYDxcFObQvRurLOUMcRoyTX7++MvFrsdX1nt6mnRs39Ge4y6LXs9Q/8Ve
         Cit4+YvWIBhr5pKXBc8/Pgbh1uW4iS8XvkOgmgE/AVkU182dreRicMuHAgrINZ7nSGhI
         e2lvvNrXOBKdO+fCmD223VtapNIXNAVWwDqiUx1lL+VKUMDgxDv3pXKEXjsZsUbc4ym3
         qVxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764838297; x=1765443097;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Trh/W13e+8lZIhANIojCqFW0J0vURtDn5XxDF++7gII=;
        b=KtsmI8NX5CYaEo99/UtCKkKBkP2erGELQclbJKUuIaZ5r5yhkKE58BZYlLhU5Mr3xu
         M9TxkTXYoULnAzhkXrsTWCDsa0tuGAxvH+JikOXeKeNmkgB2MM4MnXw+FrAi262aNmbX
         zRZ1ZppI9OL0mvyzVE1nbKpknm1oqPUQ5QkBNCsd/++N22yOS0gpYudNfPbei+gfFonG
         CjfY+dhQ/6KCZKuiy9gTPuAfpAgL3VFT+jxmETs3A/5+Sll7Hx8nS6C8kZKoKV9MtBHK
         qIlY9tJZY0TeYX8eSx2uC9SC2GpD8JRzZVHhwBiHQ199XKwJH9jIEzSG6badDAgbMdG/
         XLug==
X-Forwarded-Encrypted: i=1; AJvYcCW0KdTDXK4wxLXD+usPt+m50SQXLJg4a3/OeZXHqTOoqLU1op8UTuOyMgRP/gYz0z2rb3713tQI@lists.linux.dev
X-Gm-Message-State: AOJu0YzRHkSsaawxtkemO1HGRxTF6s/YPGJxenadF0n5L1HkneW5N8Vt
	dK8atulevjub4PWXOXIf3CUxv6cIfvSEaim8i+fdJlk3NKqBEp2SLlfAbTSb2JTPYA0quyx1P/U
	bv4Phr84EkNjNmNGTHMwMTG28gCU0yplb2PTCEVXv9A==
X-Gm-Gg: ASbGncvul8JQXqJpTsFTaEgvSmIDTrySSJPFNh1wzBrDt5MalKWkj9/isaAxVdTwp4E
	H/tlQ6Dp3tnL2qlZUvhjNQgD1VFFB4cZLZYZSchxdJAh1/hKhl6ffKUOPQDPi8v8Y1Z4lRQlRAm
	IYM/EAcyuA2UM9qUyWySG3zfaLFjnR0zFLgdo9dYaQxkMoFTz7XdfILBL0CWFilRNvxwa7WTcsb
	cpgU7wPiufiLMaajC8tTvIr/ePuTObUulCbvlwqEa9MGUHkR5FXN5Q+UB9A4Yy8mQSs7bpESid7
	i7IRjJ4=
X-Google-Smtp-Source: AGHT+IFe8Rga/oYQgzdhd6L3ShdQdE5SrtoHRIXzQA5MsSpxY+g+j202sxOBUYItr6XYoCZHorI7UkAZwQax5m/pSoI=
X-Received: by 2002:a17:907:86aa:b0:b79:bd38:4dce with SMTP id
 a640c23a62f3a-b79dc73a0damr533070466b.37.1764838296923; Thu, 04 Dec 2025
 00:51:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251203152343.285859633@linuxfoundation.org>
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Thu, 4 Dec 2025 14:20:57 +0530
X-Gm-Features: AWmQ_blyCTrZy8L2aD8RqSEtpAYOxd_cD8HHC16wXXwOuM9mODtNvrlLoDo3ZsM
Message-ID: <CAG=yYwnx56mKkOOdtsk1TnFVgNOPN29qF+cDQKFNViy0DJ3E7w@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/132] 6.12.61-rc1 review
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

Compiled and booted  6.12.61-rc1+

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

________________________________
