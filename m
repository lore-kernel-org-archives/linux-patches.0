Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1FC322B89
	for <patches@lists.linux.dev>; Sun, 11 Jan 2026 13:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768138436; cv=none; b=PEBe4e98VKhjhkGrr4e9bDA58DCM3Sbly+iAy9buTo43m/h9yVC8JMhFufPGMVNJovE176be4cEZHrP/vLly5DOYUjenRowjQWZJpK+aeLnwAYb4hRcjgFFiwXxMDAgWrgVSAc3luOG3+lNtOLUx+gpJQIOLEkeC5VNYCtHnZvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768138436; c=relaxed/simple;
	bh=Wzvtf1QIRWhfF9BNnhKptdI8gkJPgnhFK0K96o9KUig=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GK5zbqe3PhcSC7AwUagDqSWVYfMytb900/ZXPIBbUqDBOxe/GMTt4rS+7eFjNOaPL53CUN36Eou7j98P7a8QDuAnsiuSzV/UJsDhHfdm5338o15Y+qEOS2IDYPFBaAnC9nqRv6ZHCJ12Mz3dwiksp161058AmldqKCwCx0jQJ8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=pm+FPtbK; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="pm+FPtbK"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-64b5ed53d0aso8236123a12.3
        for <patches@lists.linux.dev>; Sun, 11 Jan 2026 05:33:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1768138433; x=1768743233; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=f2J4zv6B0sWCplg3AhmRAoRaHMt7uMnutkNab3hdAsU=;
        b=pm+FPtbKQZ3xVs5Knr43aC1PyQgS1ci/IpGaayKFPYQ+oF1aUHK6SUADVMSknSrWW9
         PEga/thGYWn98TfDLWkWIKdxs3oto+07snDDYV5L+aAQ7GGSFCTmOl0Z6S5kgfjBQIHm
         rZamb1JgDa6cRzSy3PBEVqCNzyCYugZpX0zKAetQXV/Gwx9/9E7v8bkvHlzUbGtn86AY
         x8rQayFkgyfvRh97LFHmu94+EDLEeB71hRgRKeTj2RBXKIdd2yJEMWWKufZJACxjHY7B
         dVp/jLO4IsBqDiEBgyB4HAHBnV+kCSwfYzVMp3CY6sXcVIJODVZyfp0lPoqKg6UALwPK
         5iSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768138433; x=1768743233;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f2J4zv6B0sWCplg3AhmRAoRaHMt7uMnutkNab3hdAsU=;
        b=MjaxlDu0zA1y33mqAcbs1dci2kWZsSP2QHvq7mGSB6N1YPmSWF/2LXHEIDXLTvXFpP
         TgvGZj6ZFlnzbk4e1AkPpgZuhBvhgO3FmGlCY94GUHNQ131zotvYn9ZbwRx0bvEMuB+J
         kcb1WBVoO55iX0VQ+geH6L/vah4FinFqSf8pSmEBcHObQ5QEaRL9jWE9rMZscH1zrv8s
         fgqlVoYPCjl2weuduyw4lsvOMHbGoov7JbN8M32wsWf5SlL9GYbDtpVFEOIyRTy3H9zD
         gK624ik9vXUZq/AWbFOJodqE9NmqJs9U+EvFJSU7wQc8/yuPK97sj7GO4c/cnEqUaz6T
         2CCQ==
X-Forwarded-Encrypted: i=1; AJvYcCVNuBPuiy7od/LiYkvnzsI5bsFlbBVlxEilyCU86M/ylb+29vTEcFMwtl9BqXjlLE1VQqzbrTsj@lists.linux.dev
X-Gm-Message-State: AOJu0YyZ5N4cgd12G9RTmQztNtVbKFnvMfpTz7LhTJwhb3KClmyrWLix
	YIiSGX/mpdO4OrAfTkTc3VuwE+YFB0whEC6haYkHPx5Kbymp4cA+jNqgTt7Kt+4wUW7lh3V0xsd
	DNLqUwGqRyu7watgt1Bh7Ql84Dai2Hiifusij4QGTYQ==
X-Gm-Gg: AY/fxX4E+32FfMeRBbeOr3EoraLfqA+pTwJtMSNq0hr7HLc5S1TKnBQZT9X4noLwOdE
	F/Fxh+zNYwJWOkesXsYPqjpfL6FGJtmYlSOuKdrQRzWh9I0/WfAkMBgHgsWOBAzrUKcQzDn9jvV
	WRA2l7TNuWyPs4A+yXgrvuUZ62MxKyQB9sx3cln01ieZyXGujJuxdier8F6fUr3fjeyjEdajtcO
	UQBeD7lJrX4n/TKVz6unxo7npB2FxwKjymk5Qxq87Wg0x5PmoKifS+eLWTJQ1ZrRR8o7h4F
X-Google-Smtp-Source: AGHT+IFIyEV5GZ9LvzKs1Fn8qJm8k3Yl/9+E34x7MwrIBE/uxpqJdywpg2jp+1UpsvVTwV95NwxPwTrXn0S17pRWm3E=
X-Received: by 2002:a17:907:6d1a:b0:b7a:6c39:8e73 with SMTP id
 a640c23a62f3a-b8444cced16mr1443786466b.23.1768138432293; Sun, 11 Jan 2026
 05:33:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260110135319.581406700@linuxfoundation.org>
In-Reply-To: <20260110135319.581406700@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Sun, 11 Jan 2026 19:03:16 +0530
X-Gm-Features: AZwV_QhkGV9F_PPBfvZcVv0UkUfx6ZL5ME9FEBCMlS1TdDX6na1L-wwPkJH4TYs
Message-ID: <CAG=yYwn3BNTMt68xEocXDGDW+LRiSHDAD6XNPKfVN2xKN+t3Cw@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/633] 6.1.160-rc2 review
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

Compiled and booted  6.1.160-rc2+

No  typical new regressions   from dmesg.

As per the dmidecode command.
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
