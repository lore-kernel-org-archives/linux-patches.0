Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778C534545
	for <patches@lists.linux.dev>; Sat,  5 Jul 2025 09:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751706775; cv=none; b=Lj8vWNOmNh6Csphs8zZK4DSvk5wTqhuqIEsxwppOWZxKMm6+wADyQQdpziJiYwz2wOu6Y6zmjae+yuRXEjLzVdTlcLDMDUeJ42uHgeoZC9sljV1N+J37US1eq49Y9n+uzCXFKTiTHB6PhWIwMw7xxb8oIWWHSkLlcat0nVdyAeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751706775; c=relaxed/simple;
	bh=689kMGlfw/AXPQyRh4q1p7yztV4sChW1owy0XyzKNNE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rOjMTvVRpownpG+j6WSXlMTX3GNNsmUt5zeaWX0VkMz1LofAL6Z8Cw9+vRoPb2FB9MrgQrGv+KJmzLg5cN5jesXys5U0UBROxCOkA12Uz5Oeojji5/P7tYZi7QRO2C/Iy9BgDK6KlLOIOTWWYQE0H4ORZWF9yiM9keeF+XwX0S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T3nuN2ek; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T3nuN2ek"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b34ab678931so1090547a12.0
        for <patches@lists.linux.dev>; Sat, 05 Jul 2025 02:12:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751706774; x=1752311574; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NfCXkXHDaEjNnEyIkF2hEs+NlnYvPJOJtgT08NxFhD4=;
        b=T3nuN2ekl4jdHJq9nrhmYdvyGrMCzfXuwuBRwp7DsF8eICqRQ8og6x6Yl7Kbi3nWn3
         jMY2GORClRUYZ2LeMoga4A5CdrYXMtNek0KrhV6Jre5K9LSWnHHuE8VauBT9+mGxrE0e
         eEcCv0o6QrP5HejUH6UnO7rYkNBPF/zDz4v3jHSG7g68WnyYbTGa9bozmaV8pKRDUj4k
         pQ4yIgdQYg3eZYKlIaXJWN86YdLByvj/5rvN4zmkeqGZCtfEpLHrpu5wnvSTH1x/wTtM
         ei0D2NJgEJXC5TklPKw4SiNs70MxyolgxjoFBOmeWarb+uUxADzd7kHkA7ppDPIG1UCQ
         t5zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751706774; x=1752311574;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NfCXkXHDaEjNnEyIkF2hEs+NlnYvPJOJtgT08NxFhD4=;
        b=c60MPkl7Y5b5DpJBqqeiZ9en38ijrzsdA2txUq/zkVDlzngmpyyjz8coS5VzIqsaDm
         YohmtwgJoQAnoNIr4hkazMzNzdTcMFMhqnU+TopzaOjWWECFWFAybP428zHhXwwVv3WD
         dE1zyGMaYu2LxXGvcjV5fMDL9VbV2wSV8RCWtY1u4xcZwa8BbGMdAA8ZUnUdPYirUgVb
         pu5LIf1oABVtJFXf+s8RDn+cyPgKDnxXEOsAYmDXDQIJrGurgNE0Zf6gvoh3cSnrFIYo
         fcFHUZxNLZz80f7tjWQarc2nedwyNESrcLaJks+OIZCq6IsWPmhCkvqWjlQMrD6eWlB+
         Fj+A==
X-Forwarded-Encrypted: i=1; AJvYcCVrAINtKGiaE2ThETV/cz6suA2uL9D6arDt1emNXp85sB1LZRNXSAMieJctCk4PvJbgDvlwS+J1@lists.linux.dev
X-Gm-Message-State: AOJu0YzIBhB1PUQpZgQqMhPhZKI8cp7k/Y15FJnBhiTnvL/zz7ckKNHI
	rA1rfT+cq6NruAcrsa25th2Fv4RLX4vi4hNzeYM0QN4EiL8yMFtAGHFbKA1rGWaKrc5AocX1V0F
	yoKts+/9CnhrJ96jxp69U+tNhPvUegIbahLEguBAe4A==
X-Gm-Gg: ASbGncvWv7s6hopCDQ+j8W+Y/wFsYOtcjNw0buwvi/aUqkmgUAgjrmStYm7dMN7rPB5
	C/Cg+08x7rbzdafa4Nd0YNBa58K80I9VXYBlSQLMz5NPAMzOFpJrveNw9OUJVsLRWaUUN1dyctx
	KjKaWKBfr6MyxeiryTUjLmjO+DpLENGTlSeZLWLeH1NHyaVEoqe79X5wGGj248d3/a9X/L
X-Google-Smtp-Source: AGHT+IG/WtW0xjZh0wKEbz7+4/Sg6thCz7rb+9uIqEpg1KInw/zMM4qoCcIvo6ocYuGVF4Fhm4aZz9v3eod7uv50HTg=
X-Received: by 2002:a17:90b:5408:b0:311:fde5:c4c2 with SMTP id
 98e67ed59e1d1-31aba824c2cmr2361813a91.1.1751706773736; Sat, 05 Jul 2025
 02:12:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250704125604.759558342@linuxfoundation.org> <7cc923fe-ee44-4bdd-9b1e-1fc227f36bf6@sirena.org.uk>
In-Reply-To: <7cc923fe-ee44-4bdd-9b1e-1fc227f36bf6@sirena.org.uk>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Sat, 5 Jul 2025 11:12:41 +0200
X-Gm-Features: Ac12FXzx8W3c29yzVdoZqq3towFPGPGuutw5N4ckvtlhKb85jxxx06YsndN2rg0
Message-ID: <CADo9pHh7GcQj=eqQ314fp-R4O0Pf8h-Ku2UL-XoYeb9bbY3pgw@mail.gmail.com>
Subject: Re: [PATCH 6.15 000/263] 6.15.5-rc2 review
To: Mark Brown <broonie@kernel.org>, Luna Jernberg <droidbittin@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	conor@kernel.org, hargar@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Tested-by: Luna Jernberg <droidbittin@gmail.com>

AMD Ryzen 5 5600 6-Core Processor:
https://www.inet.se/produkt/5304697/amd-ryzen-5-5600-3-5-ghz-35mb on a
https://www.gigabyte.com/Motherboard/B550-AORUS-ELITE-V2-rev-12
https://www.inet.se/produkt/1903406/gigabyte-b550-aorus-elite-v2
motherboard :)

running Arch Linux with the testing repos enabled:
https://archlinux.org/ https://archboot.com/
https://wiki.archlinux.org/title/Arch_Testing_Team

Den l=C3=B6r 5 juli 2025 kl 09:58 skrev Mark Brown <broonie@kernel.org>:
>
> On Fri, Jul 04, 2025 at 04:44:42PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.15.5 release.
> > There are 263 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
>
> Tested-by: Mark Brown <broonie@kernel.org>
