Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A022882D3
	for <patches@lists.linux.dev>; Tue, 30 Dec 2025 15:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767109151; cv=none; b=pAYfL8k9xr7fcfOFxGFfu4vfv2CvtlGoUaAs9Vibxih9qpu4fPoULmxh74lyvgl6/Uy1441DMUFVNoXpKuDBHOKKlnMN4aKruyIm14BAkhea8ACLVtcqDo2kwMvXtNBPPHXwsDd9Dkp/3lxF87P4zCUbWzRSkucgTGlApOqor/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767109151; c=relaxed/simple;
	bh=M+ghxDkyEnMAHLZK+xSgIQxY/DMIVo9Fki/cauWdV5o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R94Ufzw6pqLVRLNH6E1IKEneubTycxJelm+ns38TlmefHyWcDJ7Es4Alt/Az88xQf8zTiZOHMEHor4RPkijwINZeTPMnT+5bY//EOICkt4CV1PKHQsBZRWrmnj/J1vDAlmHY3OzCu8XrYGn+gx6Z8lUTVFQdftqT3T1ezR9aEDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=BM85NQBk; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="BM85NQBk"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-64b921d9e67so14489276a12.3
        for <patches@lists.linux.dev>; Tue, 30 Dec 2025 07:39:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1767109148; x=1767713948; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=S/iGKYPy7kScRKALvoiJl5pQO0SCaWoFIYCUOvfEdec=;
        b=BM85NQBk4KX9h/iahR8XuwAXL89X/DhvF/FK1Ezu6cKvN89rcr5izmuatGfQxfTwNE
         uehoKrVxxJVdiUFHaef0OsexYA/3+ucPKd4RnfTW3vNeEqaqbb38AQsB9p91+QA67dKb
         WddayR2sxucLhxWrCuMnkJKqhctoyweSfRb7gNk/bMtibhfIlJNoQU4ZhDXqYvGKXtET
         iknQ3k6lqBn1zNEsaKh2gD759Gl1urnd0/lcv7Ei2lJdHGkkbNNphSYk5aSL4O+o0UEg
         lTz/smLuSUmH0/p1hXL0zQgudpQCWS6/7hrIsNgIBG9+xrV2t9KkRH1OB4px602y2OV1
         2rZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767109148; x=1767713948;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S/iGKYPy7kScRKALvoiJl5pQO0SCaWoFIYCUOvfEdec=;
        b=akVDBsGwnGKMssAUCXaQTbFPLZONnSPngaPxF8heT9z2an6J/TLU4jINWeNpCl+tv1
         UNyQRwUcL3X7gHitHh9uXat4IQYRqnT5v8yvt9RWd436egXeeyqtqVkBrCFloAxsMb1t
         H6khSiAooY/2lqjboB2ZKkW1cNRGp5cITLfBO7BDF4BNus2ZlaTMFlrl+voakXsLEX9N
         vZyqnKXw8pKX9DaUZxH145H/zJCfHPFC1x5oKppDZoUlBduPPax7DvmzGxu7x7nr9NIy
         0//COIOvo7x9/GwzSGKiCxDaxRbUO7LRv0W08TN1KKz2s6jsOc04p51zfnRJ04DHrQAj
         SJYA==
X-Forwarded-Encrypted: i=1; AJvYcCW7CLWupfzU9zKgh/KT2RqtUymceK+cOA5j+/vXwsZA5XDlfIK20cHPF4yWTINOmGHUiNH1yfXA@lists.linux.dev
X-Gm-Message-State: AOJu0Yxi48l0gwMXuaaMQFQT0gVvMxEWa0KXdRH2wNTkHeZPOacXRd+V
	qloH+25vVinEccyGxKQzWJfrfZGI8d5NY/+GAwKv5rDEk3mHWTy7LMZO5t09kvf+30VIfLXgroU
	JF4OMSYST1/Ky2GxxqLx9ITxnljc415KiQGx+tg3WBg==
X-Gm-Gg: AY/fxX7TWldak2VG7D232k/ycG8CBkRy3Af1l4TTL3JfrCt60C1lowsSysOpmn6bNs1
	eo96atwqndmOdBwf3w4iMhn/ywNBq1IuSX4OOS+1ApAIpKjf4rZVQ+1m1KW1z8cjJGWS5njiYz7
	TReUa8gzeD4IStUHTG3M52rkd98vRGTwQsoYQ9xy/wF7l4kK5lNfu4/qoXBcORfg1tHl2LxbzcQ
	KuqxZLmtPIOZyDd+K5DEe0zYq0JTk33utf6noCtu9Gi/JF6C4tP4ovyh62v260ITivs8Rw=
X-Google-Smtp-Source: AGHT+IE0v+rA9dVO3MGjq7zMSf8k9fLsm2E/a0kpKY/MH2zvaTSMwm/I3yU75tbfYM+n/9OcaW714tZmTmzmtr97Y18=
X-Received: by 2002:a17:906:7312:b0:b7a:1bde:a01a with SMTP id
 a640c23a62f3a-b803721826bmr3737689966b.62.1767109148361; Tue, 30 Dec 2025
 07:39:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251229160724.139406961@linuxfoundation.org>
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Tue, 30 Dec 2025 21:08:31 +0530
X-Gm-Features: AQt7F2pjknXX3DkMcbVdm_x3fyQaQnJrAsSZCVdPg3JITMjxzgdTkMkzQAK5ov8
Message-ID: <CAG=yYwmqyTWtcoaosdkDpD79a1+gjyuKaZzRCokRkn1Y2VqxLQ@mail.gmail.com>
Subject: Re: [PATCH 6.18 000/430] 6.18.3-rc1 review
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

Compiled and booted  6.18.3-rc1+

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
