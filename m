Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636082DA77D
	for <patches@lists.linux.dev>; Wed, 10 Dec 2025 11:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765365765; cv=none; b=SejdUjFiabEwIpe3WWfH+XX5O2TuCyV8a5SKHTpASN79/kKJFWC4Nz9pEdnGncU57/urXjvIju6SdbXW7vBbpLgSRz5tDm2z+iRVHSc6s8+saOFzNwyM4IbZmzqTNh2TvNCKCnjjp7Fvz861rhN8HpYbO5nuORAUxzCOAgS1+eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765365765; c=relaxed/simple;
	bh=RwJqEKrjOHmef3MWEP1ZSzKUDTRwliaRL3I4knFEl/g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RHrn9L3R+gubrjK4rRv8Ni/IQ7t06vvvSQ1/A+pRX77aIzBpC5k4P90Ug2tg1AKRDaqhb1iy7Y9eGe7pKloptArdY+NeFtu3zJvm34bO7R4ffZIfTsvvpSwWkXVxT955zpIoLUBELT6sBeCYDqCmqlscM/dtJvw9nHCY/YI+o4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=CC+ouIy2; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="CC+ouIy2"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b725ead5800so891050766b.1
        for <patches@lists.linux.dev>; Wed, 10 Dec 2025 03:22:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1765365763; x=1765970563; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=y3fR6ViPsGqU8MfdXZ3Af4k0ImLkw2v66K7RQbWl7oE=;
        b=CC+ouIy2S+rR6Z3JDKLc3tQZDTfLaNJxcWsyqhBblc8p/Y4CMfuitQsYGA9XvPjnRp
         ny1B32sSKVjv8jyarZNvUJnMx4UbNb9clrTdEFk/st7OpCTMWXBrvv+M9swKtU5XtRPd
         aVdfHkTnb0oyijF3T/q0czSVtG0D+yyd3GqVQRYj2JJrcZlC88opEUK425m+h5G4duYF
         /XfL36EurXoJjX5jppvySmdpMVZZi3ChFn53LoFYkOUW1kYJz/Lw800bedviyFStGDCn
         VHSBubWOM6cas230KCV9mokiyeZ4rTxXiO+G7+XhacoSI1A0SDC0pi76l8jWv19wMUrj
         pIUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765365763; x=1765970563;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y3fR6ViPsGqU8MfdXZ3Af4k0ImLkw2v66K7RQbWl7oE=;
        b=drTb9E4s+f9FR6Rs7ARKsHP868dLKHDhZTCGeyg9kDXx6Ia1yK+yM6YIcDUsCqVp1+
         pRlV+e2Hs5KbOIFY3Ix8a18X0EwBnkVDV6RfDLqy513s7coM+tCO0rQeuogk4zXXINId
         owo67tyOwfv8ehVh1pujPnVU0d25ND/BtuwLgKiM/4fEvz27OJDu3cEQpy304JICzTiT
         tjOkAUeXheCPyz9N34BaFKTAuOG52AgrOMTsTm1908icds8WGGkmmRTRJbK0Keql3Kge
         XRobibF3eIOHgZ7DdPIFVehfU+O5dUh2ZqQ8BWo5VB4KjqxkL6CKgR7upGwxqhGDczb7
         fjuw==
X-Forwarded-Encrypted: i=1; AJvYcCX3m819ZUQ18t5i6ATSqMB9M5hVoeVNRiUbR+c8rwXeMZ8wnZR34eFGNzIA6bc6o3pc+8X1SyEJ@lists.linux.dev
X-Gm-Message-State: AOJu0YwelH/ZUiNWQR4Jmk2fW+MDgp6uWNJl/VRr86VNNgWvIUDaeot0
	KYQaI9QbM//hUDvEDp0Rk0qs9diyTho8EiPkJpFJL7tzA9bkHHsYMf1YHdk4Fad+671quRZzbIZ
	ekzgB3bRFJoPTk8XlFG9jCg+IDOK/1qm6dn0ZTvVp9w==
X-Gm-Gg: ASbGnctTzfcFJsowI/g+zLIkVC16AmFcIMVR0YghXPcx6s4st8f5aNrmm1rRgfFOu32
	wMP0foPpBldkrmiiucUAqU2pMixFPeWiOdmbQR+0QNaj3CtlfYVhshgI2Rez8/TAb0JDZ50wqMl
	ScNCty2KAFm5WjzeS9Q7UqPfDQitINRUJ26E8YrL0LtlbhiVqrpVzRMkOBaE8S6afL9t9m09Eas
	ZLyLoRFa2DEEPVdwnXegYaWKGeOBH1r3N5Z3ugHDnBw9KrVIRGD2lw2Ag0LxcU3Xzqc7hvTy21a
	MLQXJA==
X-Google-Smtp-Source: AGHT+IGpkdTQkei/z+CfKPvwYo4nremFkFGY5G/hzKyLEiR07JwWYOd21PmvfRI5FQr2rguFgg0RpN/HWyzj145KWPo=
X-Received: by 2002:a17:906:c103:b0:b73:4b22:19c5 with SMTP id
 a640c23a62f3a-b7ce851c42emr213067466b.44.1765365762765; Wed, 10 Dec 2025
 03:22:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251210072948.125620687@linuxfoundation.org>
In-Reply-To: <20251210072948.125620687@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Wed, 10 Dec 2025 16:52:05 +0530
X-Gm-Features: AQt7F2qBf88HbQYd-YGXwdQSek9eban_IwWQ9i4SEquMn5zl2qXNvQTqRH1acrk
Message-ID: <CAG=yYwnRwG+uD0mS17X0cvzruY=nRUyK_HvQhtxJQCCmi1YF=A@mail.gmail.com>
Subject: Re: [PATCH 6.12 00/49] 6.12.62-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"

 compiled and booted  6.12.62-rc1+
Version: AMD Ryzen 3 3250U with Radeon Graphics

dmesg related  no  typical   regressions

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>

--
software engineer
rajagiri school of engineering and technology
