Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46DF52F8BDF
	for <patches@lists.linux.dev>; Sat, 10 Jan 2026 10:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768039506; cv=none; b=u+MUIf1gGct1+ePrcVraURch3amyo9xF/j3QF8ow6gW4DFpX7waySjZjo5FEulwCLP0yF9G03zDKjCGBYWMNn0q3qpT8juIstpwQbmqFbSDJQHUussxm/r548nrQCvG+qrxxCsjAh00hkkSiWnMa42Vhg+/ek3ASn9YhDVbCWtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768039506; c=relaxed/simple;
	bh=porvaBAkKdZCiyHP002qAS6ujzfbEMWqze1LBTMYLhI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bF8HtpEuvvDEpTWzvLk5k010niY0jD62bsfb2DjBDYn3A8sutd2KmLYmOrCIhE4x/a0i5eFo93wamBgXHvGvez07lK1EazbTsiKhPLwVRKtzvQuxl5tkvtfFUt05oqOnV17o6mHFRNMxYoZMMpO3X6gsCgyke2oK69AwRr74EFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=FUyKG7os; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="FUyKG7os"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6505cac9879so8470024a12.1
        for <patches@lists.linux.dev>; Sat, 10 Jan 2026 02:05:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1768039504; x=1768644304; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Y//RHTw1emsVl3ktprI7wdvq0ZBKRoCim6D9KJfCwiQ=;
        b=FUyKG7osvTbHSUkNGbEaHupj2IVIJLM21J/aZ+CaR+GcyNvT7u70kqyoFNurmfsIHr
         LBG88JHh5PofIMTf9QOYuNuWL7fWawYkc6h2km0T3A+W4B2LhJEeOjP2zc76ZBeaM09v
         +1AUKqP5uyGLxj8bwz81MT3ByNkIjp5geHtgH1lzr/VZdjUlBhLTlrcS00qdqtobR1bf
         +AChsck7BvwMq6hLFM6d7cjfPBSGWkxmT3/nxis91yegSPuwKH4IcIVpWBoG7616mrsW
         syUOlk2u4EutwMguRkl4PyfzJ/zIOoYI3c3PBVrsw15+/uyyVgwv8en4Q7PG9NxhoM21
         7xBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768039504; x=1768644304;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y//RHTw1emsVl3ktprI7wdvq0ZBKRoCim6D9KJfCwiQ=;
        b=TrBG8y1a5r8JOt7b6UysdoTcc7C1yDKtIcPniG+Diy6G8Zn9vyVXpvDyHmGTj6RqcP
         qcLw4KEiBXuxFBBfdZMcUKFA0/q/OewGeC4PBzVEa22XqVPzM/i77YquYcMSujZjk6SR
         zoU/B0+k7j7lg5y2kYo6XQL+iZO2GJm4jbyNHQsB2Cti1pRJZ3TUYW4yxAGiSVgu/6Wt
         Ygeb+PzUBzcibIpnwCcOZRsmPn/CfNuRfI3/9gl5RVm5Gby+97EciSBFndqDFxShPKyJ
         rQqxWh/lDriUhkQOV4TQVakoM7ZvJriSpSNX14ZBzKjhej6w88A3SmHBXfmkPgWjMQAK
         I5Bw==
X-Forwarded-Encrypted: i=1; AJvYcCUSB9V+DPGUp/EAPCXPmNuKLErf1zOpmiVAaw8QpFkb1KzYoBBmdmxOABlX4XxIGWOlgMA3Xusj@lists.linux.dev
X-Gm-Message-State: AOJu0YydIn36pWZM2U5vmgNRln3S4smb9HyxanIgEoY3K3v2/NhsT81V
	Ur+DwQblOnfKdVAHCZbrQcIBu+F4lhnnXtKmFEo03bowrITI9T0kKwFbjuv46MG6d759AcaSi87
	WiYpJvSFp8Ru3hRNw3138BBu7o2VWR1GToyfaYPi7pQ==
X-Gm-Gg: AY/fxX5U3Sr7gaVeNTNTwOAYkGmGtv/v5zj/xsZE7Ev5QxQGFZUbEcgDpU+QfuY6RIy
	cBRAJt31yfLwc+QGfi41vcIzjT2L+HiGgVy0j0qJCm2XjoN5tAO+fPSm6xPqUDa3SrCgxd4jWlh
	qcqK7S9UsUO21dnSRH4T2qXff/mgsdvrQ0QvzesmhdUD0U+R/bScqXxtZXir3zvnwfuXGMhIbht
	pZ1bRKyW3A0lxnzoWSGNu7s/qBXcy0w9oVHd9MT30F3Oi7t2JXnyhT3Yxbm2pTVXT1FHZ7O
X-Google-Smtp-Source: AGHT+IF1RWdN6N56ML8fXmycusf+Bq3NDRkRpW+951bAOolZtq5MIecumLOhj5YHrMsS4882UGtfpG3VIajABXJ51u8=
X-Received: by 2002:a17:907:3d0b:b0:b83:1349:3a7 with SMTP id
 a640c23a62f3a-b8444c4d0e0mr1179195266b.10.1768039503669; Sat, 10 Jan 2026
 02:05:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260109111951.415522519@linuxfoundation.org>
In-Reply-To: <20260109111951.415522519@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Sat, 10 Jan 2026 15:34:27 +0530
X-Gm-Features: AQt7F2otbVrWs9f-y8Zw1pDGca-fJHwhoppdt6Moya48H1a4SKOVBDK7n5-emS8
Message-ID: <CAG=yYwmnh83acEUbUNT4f=G7n6ZeQzUkfmWMAPc1FioHwLwwZQ@mail.gmail.com>
Subject: Re: [PATCH 6.12 00/16] 6.12.65-rc1 review
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

Compiled and booted  6.12.65-rc1+

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
