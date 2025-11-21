Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A5AC2E0B77
	for <patches@lists.linux.dev>; Fri, 21 Nov 2025 18:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763751539; cv=none; b=VdmhthshVq9pNcw4ITf7ZNt5lysW3rnTaoOxGPk/qh+ImsczJK8xQuiKXeeFhH8aO1sM3zx212jScZF1LIgv5gSWyRE8JAEdigroXiMAlmZleOxr0kNUd6Zu+iSgO+77hZJH/55k5Q0CcM2YJ9LDNWWdGGcTX6n8ObxXXTnWPUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763751539; c=relaxed/simple;
	bh=OD2BPBJ+WpYdSJqGl29PTyCpt5wg8lF186uyL6ulPYo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ny5FmaJJdkVIClzJm2NNzLicdTz1cCQhDwMEb9gKve2OoMnY1BUaiMK4U8jZvVBZe+TNyF5UrvNeZixCPiXJAOrOLcIoIlW92ay2HEwBil6EBm8FT7A2RXWQjBu9d2zcGWYxLa5JqFP6GEsXp0k1L7LNuZLL4ostG1AtKVAHgGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=kFxLsKiy; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="kFxLsKiy"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b71397df721so435664866b.1
        for <patches@lists.linux.dev>; Fri, 21 Nov 2025 10:58:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1763751535; x=1764356335; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fFzITl85/n2wxKTQjOLP5oK8q+GJ7Cr55qPMQ6tPpzE=;
        b=kFxLsKiy/31tgDRulTrBzgBQlGzsbBaO6NUA6V6FsFvqHX7B/TMGK8fL1wfJTMmiW8
         byz5zBBAArNopb02Q55G8huJzmFe+TFIwnzog8G0a0+Qw/Jq5l/GlQ+kcywZe1jZIO/O
         gR6dVeffBDgZBNdZh4qqY1kblUzyijrCGDD+5EVBVLPOgnHCUB5b8zyWv7YGYyLTA1qI
         QU3un9XLRB/qIwwrN07wr0fFujvgdAqv5WudrNj8OBMAPG/Y3nTiCI7VCqlJfegfD+eq
         hqn2fQkJpsZIksk22RvHBncy7uR/hu3hrwAFbEUJQZAnfo30rVIUPbLHHfuNmOKOuvLw
         TAvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763751535; x=1764356335;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fFzITl85/n2wxKTQjOLP5oK8q+GJ7Cr55qPMQ6tPpzE=;
        b=jt9EYlmW46lbYWiOOlGxVJ20jd7Mq9+MY7bMtEwb/XnSWYjOIdE16zM1VlP1+cOkoO
         fk4DnKkVgrh2TMJlz8/V/iKNAyNXg4MXFR6cvc2fHxOHfmTjs/5LnDhpwASDIE76A96F
         Wo9uHdTY8eVf0Ewmpw9bDAVZ9ZAiSaU1ot+Gwtj9mcfhc6n0BF3GJ/nvS4oJXMaCiBsF
         AKciayoWdYdPMA3k9ZTsZc86SA5Zzs96M4nSJ+MtDmbD8JKI6sXGKwY+9BdODoilW3t8
         cLi7uevRl5k3UJIEfgMOskPImhvb+H9UNx/cTTYpa+g/NeUWqZeg5PNzdhwEzIF9+ZbO
         Qkyg==
X-Forwarded-Encrypted: i=1; AJvYcCVC28U1dOHfujmPbI1WWA+UwcrY++j0D1gUv2LaVXdyBIKao0QeTOaibWpaXTHkSLH2nEmnNyM2@lists.linux.dev
X-Gm-Message-State: AOJu0Yzjfej9Z9CJXH0De3hoLCXpnHsaFsymM45NGAC6vsWXkJl/skna
	0svzA3lqs7nHw4GONER6DX2jOMJo52PGjl/gUrwzYegMfUEjjIhd0A6v4Ba+2qINPSaPIuRCZF2
	V2iog34jKvI6T7sS0U735RaqRdBEEAfa5sSHqs7yYqQ==
X-Gm-Gg: ASbGncvtWwB89BgRGjUeTbGZUSnZFhrIRr+8WdeD/Zh7YUXBlLqaVrXDTh5hotkOshb
	US/HkCwevb4e55NN7EXe+VcAuQ3ejJXoH5tIiaAYl3AD8FBA/+Um/+2CF1ecNYV/vKYV73QgDeN
	J7Z3vm9/KOpmOmmMhfaaYwyKPOBuND470DRhvhttVGtATaF90JRfjDFDE5NC+6n5jE0on9SouKv
	ZT/C6I2wuTLZ4dHwPEKAmXwbp8No6J958ZFvyzkNGSIVzVNiRVvr8/3ntkaxXPTVLOY0VhLTmis
	Vj73mg==
X-Google-Smtp-Source: AGHT+IG76ktUz04yjmfFAFe+FBW8iYZfGik4rFERzzHnYuCkGxcwG0i1C2FkLzqA9pN8F/lFTANRSliwzFOY1jzUYsQ=
X-Received: by 2002:a17:906:c14a:b0:b6d:3a00:983a with SMTP id
 a640c23a62f3a-b7671709c17mr368806266b.38.1763751535510; Fri, 21 Nov 2025
 10:58:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251121160640.254872094@linuxfoundation.org>
In-Reply-To: <20251121160640.254872094@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Sat, 22 Nov 2025 00:28:18 +0530
X-Gm-Features: AWmQ_bmv5hZsmWYOBkRJLiSLXVbu9rpn7KMv-kwMFVHeSRgi59ua3hkQmuXQ4_o
Message-ID: <CAG=yYwkt+GD=FHtSq+7w=-Q3jEQS-qnaG+-KS87qkVebUa+ozw@mail.gmail.com>
Subject: Re: [PATCH 6.17 000/244] 6.17.9-rc2 review
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

Compiled and booted  6.17.9-rc2+

// sudo dmesg -l err shows error

// [   21.490792] ee1004 3-0051: probe with driver ee1004 failed with error -5

The error above got fixed NOW.
THANKS

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
