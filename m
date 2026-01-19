Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B2530ACEB
	for <patches@lists.linux.dev>; Mon, 19 Jan 2026 10:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768818441; cv=pass; b=XhCcYuSjqImvCSFIP3HF3nWEmJErbYKbAwX3IYWhIyUlgfyy1UxJbMOKo9YoThEpOEBoGmZzWb0RwBnFeDank7n4lzayYQ0oeux0402ym2amtdW4CVtMBxXVb3Tm5gRJe/Ct8VAnBUdgFTNnlcG7y7/HW4cIhaV2hHUtkzpePHI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768818441; c=relaxed/simple;
	bh=xiRbN4XJdZjr8N7csDEom3Kp+k3jsiDRQhxQuX2DDGo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C1cs9tfybKyI+Tb/hv9JFOD/fElEto3QSnCGiSi7mJEomNCUnTxXzbY1OfMy6z5WiUFo8sbzitQn+lxhBQpkJC4rnnFqvTTXAN/vSafyrXmvWZpxgejJCyLPedwutNhbOo8VUaA3AlTrcIPv0PvYaFV1KZvqhXpEdomy6CwVL2U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=AjZVEJLg; arc=pass smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="AjZVEJLg"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b876c0d5318so559935466b.0
        for <patches@lists.linux.dev>; Mon, 19 Jan 2026 02:27:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768818439; cv=none;
        d=google.com; s=arc-20240605;
        b=Fe/jO6rMDw0Al7Wt/JQGCphXfjuekOiDFT+68M41Q55n/EDmbdSRYaeWgVvUaCCzH0
         AtQmRoIYxZFPTb+PJCJ5lAgHVnpwAwzZfgD72vqi/qBnFUFJl5ZDn8zJ38obqEOgiu+X
         EeKPKS7tshb6iQzLqYv2Wi+u+rij8or/XcigYroEwiEhNabWTlj+hVlprpfXvaBTneqv
         1WmICuTWPukNycxxHWs5Y7cQryhuOhZe/xrnALKSlFjZE8wDUnw9LGsIjQO8NWZ307fe
         /yd8VRDo+e4fYBaxaBgEd/YAQV8+wB5egtnkcylVSV2sdufcI2FpOB/493OH1mr2vubv
         yD7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=fHIxQ5m2OAAtYYdWwYLl4b3rixBPfViv1/3IQcB2Da4=;
        fh=98ZMpWMDv+4rJff3qHU9KA/EQT1XU4dDA9rkxuBNP14=;
        b=TvpOxOpgmuZ95JqbKhbWSEX0oLbR2Vl6tRHIaBRDYW7lYnSLv6rb8jXo3/569+y23g
         nDxtBId8qqmNSZkPfjNXp99eVhK9ixKZa8Xp2t9wXyHgEnI5Orc/ebDbuurSD0ZVrS9f
         cFjVe+i8YfFHWxwJQHSMQhi6RDznc5DTeUi31KyCLL8dy2rlfK3jH9RGDQfgtTViDD/9
         h8gJ8HpgQJTZ7cUsuGkJPqJnsP0Vo8uG47UakQTaoWdibfFiOq4D8gltp7Y1AcYNBmJn
         tCfIkmuBox5AQdEPfj8YvKafTi8Tesdqwjo07OKmSX1K0YxjLcLmU54ekPA38AO3xeji
         xQqw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1768818439; x=1769423239; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fHIxQ5m2OAAtYYdWwYLl4b3rixBPfViv1/3IQcB2Da4=;
        b=AjZVEJLg1eqiBnYsksQAbfSxT3Km/J8mSQsM866QiadQDwlMiVQT4N+7+8SSTOk2zA
         Py3O8fCXqQPLF9zQx9E/krjfIpb0gvUKk7ciU4HOlhHwcjs/umls/GAfkqK7BYfIlM5g
         01IKDSTQ262LlFbT7fR4BnxHUuJ4MGZJ6TzbBtcUHQ7zau7S0/zKikBhKaePF05joctq
         4L0DcQHFiiCbZK11FzAxYIkfdFFX0vZWN9T20ypjDTpcOvSGAorZwFaUbCPWKkHmKb+E
         SrXAAH5qR+3wJZhT3HUfpgQPpG19DunYFEswKs1djab9ZX0eV/kTiyfehPTtCzirIAyK
         vzCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768818439; x=1769423239;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fHIxQ5m2OAAtYYdWwYLl4b3rixBPfViv1/3IQcB2Da4=;
        b=jaszOdYEtoYm8aNUqgs+kcqLxUEqMJEdvWB7B9xJA/GfihmfPwogtXU3yt+jUYTzZy
         ysvQ1YE273MUOb+PP/5k7OsFk+ez54B1D5Jl5q4ttXJRIktG7ccCYNSv+uK2M5jtRHeD
         zh88X82s26SbAraa0xo0TEmJUgcVZXTILGFfVa70V1FlDvxgFB0560h+W0E/A0bjmjj0
         H9t0S0JOB+lHwd0XXHXlf8GmCfoNJn1bjAPMPjf2BPEh/WydKvswGOx+oNpIfE1jDlX6
         dO1HKkFaIFtAo3EpY7C9raoHoWKBnNq8+mHGftkFXSyBsweo1PucSfBuhdS4+/luyyDo
         DwOA==
X-Forwarded-Encrypted: i=1; AJvYcCXS/2Js0dQMs7MG1MtWEz61AJgYZMK1e1GeENw6A8XAe+tU+aEjtnDbuyh263YC2wLnaQWHQaS5@lists.linux.dev
X-Gm-Message-State: AOJu0YwzmuUvqaEU0pg4/KnE4C22EBOngqwKGu453gt63oMsXNFgBzkt
	5SnkdTIHznhimowfmwp2z7EXsgu55GPzhPV1qYZCHHrkR9h0lMNL+pvqUu2kz3WhVJFkbU2/rSx
	CuivOhLlcZ94d2sUQCmsxzX73o0vRZSEELTYKDzERCw==
X-Gm-Gg: AY/fxX5JKwVAREMH6KYq5mV/FstNQKFDuTX3qn3+FANi+5VieLtP68OYdSikda/itPW
	fIpT6d4QkYEZ3jgFwOOZUv53cIlghpvYxgszlrTrZZ2/pZIfqkdISb/wAblVvj4rB77iLXIANov
	yeowlJlFyPkhO3bi8LUcmalAJ40uhxSu68Aj/0Ud6fLafVyApITq1mHi1FgS+r/4H76FIX0yYSx
	pg4d6dnd1R0O7TfKrvw0AtrJACjGJDhlykXbajBdoQHpIfu3Ce6k9qzKvIJeRuLaiAnzRPfng==
X-Received: by 2002:a17:907:94ce:b0:b87:1b2b:3312 with SMTP id
 a640c23a62f3a-b8792d65770mr848372666b.16.1768818438873; Mon, 19 Jan 2026
 02:27:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260116111040.672107150@linuxfoundation.org>
In-Reply-To: <20260116111040.672107150@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Mon, 19 Jan 2026 15:56:42 +0530
X-Gm-Features: AZwV_QgiS6CcnD6jvwyY_oX1lqpGVNcOatdTgCgsfGlhOSR0HeBlLiglihVYdVY
Message-ID: <CAG=yYwkoQL7S0uJQS9Zvw=gzU9k67Z8EMRaQ3A1m2oN-LjS1FQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/551] 5.15.198-rc2 review
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

Compiled and booted   5.15.198-rc2+

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
