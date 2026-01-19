Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF98268690
	for <patches@lists.linux.dev>; Mon, 19 Jan 2026 09:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768813358; cv=none; b=tAY37zlAb1CBvSNA6dWkfAeymvAaRd/VeqTZ3M67zLBHbzTnUC5y/l6SNRyYjAL1h4U81FoGLQ5TXch0WBJet+AL6DY4ZA+eZhzBHDdvL3ghgqOor9XH7XWUsBe0PGS600MjOcbxwdU3dn0eVhEsKEE9/WXFLzHRDzOVCku9MVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768813358; c=relaxed/simple;
	bh=D/qymOUiKrDRNHdcVSuc2YdoB3yDp9DNMPd5KyFHae4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qQfefkEmbTG2oEBCUHpeuHr2pg4OZpm59UHm4sE9aTU5JUtJMHD80pU6lI6abMqNkETWsVr94/4Q2pb1BdpoiY3yCkVjJr+Vw1DfRt1o0mNCpxOq7+KrjfgFUSsk0RT+F2We+bSZHJEB5+iKJ0SnpxFZeAk519kGhRdMNU8wH7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=KZTPYh7n; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="KZTPYh7n"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-64b608ffca7so6176481a12.3
        for <patches@lists.linux.dev>; Mon, 19 Jan 2026 01:02:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1768813356; x=1769418156; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7wetYJgFN/oe6JyYcEwXdk9ol2wsti2uzuGgOiTbKZU=;
        b=KZTPYh7nQYsp3YWrtsYOqz25ZYkzyd11YY2x5BqdG0m89Z/LLST+Ge6djkDMExyJKD
         TqDBnV6KcZawiTddPLKmnclRwmKZLEhQ5BFt2tRR4UHwh50S28EemHnifqWoTS1qVDml
         dgXEUQMFtY/FU2FEvwPF3FH+E9qt93g0a4+1GrgjFZtTNb7tk+m60+iilWCCrGNQTRO/
         GaLtXVCVG6ZBIr1RLANakfozFyATCF8GEsgF7wRoRCxyoRHIkiBxDbWuEUNey9KILMnr
         ySkr/pJVn0TwZPcPmZkH1loWCsHZ5wGEcSUeuAi1aWIzgjvTI3+kqcpk/tXUGAAEgGT0
         KPOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768813356; x=1769418156;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7wetYJgFN/oe6JyYcEwXdk9ol2wsti2uzuGgOiTbKZU=;
        b=ooqMLbZEyKp4AffiPEoGkSsJlHckMEfqmSaZWenbWmyUNkVTg/8gZlnJfaGabGQiaN
         ktPyE3cgfjfdSlxkCObBxM7PSfdiM64WzvjXueGgLyrttOIr7vbhUmyqtPN9tjinM9wm
         G/KKZNCH6rGD2KqLLLe1qVN1ZEjlfTeuINcDtVv1vHU7j/TcE26rBM9/S16yhw9sp69z
         3KbrmUvrwsDQQdqGJ9Eb5qiDYiQEZ49jwJdsBLEC3ybCYGRrqOFqiNY1Sf9HKt9XXjwg
         xFPCSF2ZUD1zyGJmsl6DJx6dRNhIasZ+vyte4AcqImo2t/InqXuSav00rIpI89rTS1IA
         ESRg==
X-Forwarded-Encrypted: i=1; AJvYcCV03awttOePFpqmbXhJQGdztehjRRCJubn645gG/NbF6JGusMpUtpediM5VE23sFEUeRgK8FAyj@lists.linux.dev
X-Gm-Message-State: AOJu0YzVnO9XURo3D9UOwJUXikK7WhMDtUL2j5628jM5yMPFbrOEL/p/
	zguncUG2CeYigPArykr/1nr228NPjxYFIJAd4SwFo9snYrkmJ3RPpOJjrQY2sKEPox3jufXaH9b
	MxY9VOC1RIgKL4V4zbVG74IVYU1kGQgEUOLhzweQXTA==
X-Gm-Gg: AY/fxX6UNBuIFJda8dN55Q6dHTmakPUt9osJhMONwOLrCKPxTE9+qCWstPYRMlS/4sS
	j9gg8mRqbt0II/r05uUJpEXGriMuFc8Ci3rZtWUHTNIxlNOCz/aBIXu/mFQg9iFFq29dJPwwCJb
	OZosdhGdrnY5PxsR/HAPQSboLMgwwZjGGomGK3PsH24XZ8cpIuZJ5OuohPV2LBwoPzfYCHqTmMm
	Vt2drZc34rWciaR86WlpdnrAgJnru4K/yESHtnoE2RsrXMJ/hqXF3Wr5PvYW2Gke724o5xLTw==
X-Received: by 2002:a17:907:3d16:b0:b87:2675:9e97 with SMTP id
 a640c23a62f3a-b8796afd684mr820214066b.35.1768813355548; Mon, 19 Jan 2026
 01:02:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260115164202.305475649@linuxfoundation.org>
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Mon, 19 Jan 2026 14:31:59 +0530
X-Gm-Features: AZwV_QicdP5-7gzgqt8EDbBW67zD4lwsJGeTHQGwZRUxy96WyDyOfzMqSVVGPqk
Message-ID: <CAG=yYwkFhDZaFibqHJ1MMnKSbJ8124ZuHUB9FXjVFVyeTJeR=w@mail.gmail.com>
Subject: Re: [PATCH 6.18 000/181] 6.18.6-rc1 review
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

Compiled and booted  6.18.6-rc1+

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
