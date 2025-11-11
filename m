Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A020827EFEF
	for <patches@lists.linux.dev>; Tue, 11 Nov 2025 18:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762886033; cv=none; b=bKlJ6f1ndD1v+G1j75wUApqHewDCAnotTd80mzzWPGpIIBZ/50r4UYRK+LY3s2dFvtTc87/AbqOtoFDh/ycUZdmGkV2DFiogQszN7mtXasiNXIEIHOu9/gWpR/uumt3UudLrMNMsw/OlarEiAn8lywz3vm5A6Ou0q3HCG/1uvC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762886033; c=relaxed/simple;
	bh=pBVOS/SepbH40xJUmfX0ZVqtQ0pPFCREKy8C0yb+qsE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ew1v6FwFRahrMmE7rBaLTYHcBeq78aufsosqftFGEN8C4gUUICz+nfe0Ie5jQMxhSoOk8dIi+K5ULL32M/qts23B2gx4w7C7VRQZMRHFQZlXrpLRLpljvCbr3Ft/Vdbb0cxj9ymLBKbRuRL5bCTwxnt+dt7zElBPg/zsqi68lRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=gbyaM+g+; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="gbyaM+g+"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-afcb7ae6ed0so10333966b.3
        for <patches@lists.linux.dev>; Tue, 11 Nov 2025 10:33:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1762886030; x=1763490830; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AcER7olAeM4Hg35J9yaU4mQhqPClLIDJZWM1CqRDI7A=;
        b=gbyaM+g+1MTfVqH584RX295Yt+asmJdDod6mjskmV/GUx05TUQdVcIL+M3mWisIEak
         qTNd39OZuN0fg/CNt7kss6s6/9M1aIguZrAISTJUrhrvtJS4FL2Q2XSfx0FH3CIcgGJw
         hO8LHgsiAQIAU8cZvo5USSsILkeSE4uJFd9PD/3I6Zh/AELVmW/jlUM62E/u3x0lf3iz
         Z+Ht0aY17DrnvfdqqMYhTihamIOiCfPbetU7DbQ/3Rw7oiBmyawL1LodWqVAV8bcqmz4
         GSE6CRNLFUTLLSmD4bjsysoFkG4TtZMF1WEmBZxUPJBcaFE7IN01R/ZUQ1/Nx86xNUgW
         NJzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762886030; x=1763490830;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AcER7olAeM4Hg35J9yaU4mQhqPClLIDJZWM1CqRDI7A=;
        b=mVVldAZcyc/8bhJYtvg98Z/gfpN7AsW+RPAiTwUwnb7Jx4zpGHDhZE1Lm44P5gB3E2
         YL6HpQMCHGPFtc93EDWnqKCTe8EOlIeZm6q5nYnX23hJnMrzYGE9G31LKakeXu4G6uec
         jAwfdxSpZOoCInnDfQVSRjKrvGH9c2i2xwVFf8/Lc3y85T7o2A8NAtKMu184kNMeVLQW
         fcBBhtGp5abY4h/oyWyyHqelzC0Ig13jnbew+hYbzMCK0sRk/btX+o9L1O0QLVtI7V6A
         k4FpAavPRYJ14o8JF6p8VOuGd/88ORxaE1FZF5D1O7GRpji051saoOwLcIlYShvvWU2P
         veAQ==
X-Forwarded-Encrypted: i=1; AJvYcCUBnmh70UsBadhOubvlIyL3V7IZ7XJ2QRhiPvqLjro/H1f9rwD4Sx7vz//tYOtSdoeHqy8asuVM@lists.linux.dev
X-Gm-Message-State: AOJu0YzuyzQPeAYMN3bTd2crlEIIPX2+UXxEidaPHvV/Oo1/M/6xzz8V
	EO+nrGKXI9l2ruoo9j9S7mfBN5+xbNuj4pOg3+0mzQ3YBADoj/aEexSKo/BJT2GEomYIAZn5//I
	GKk7HQqyoltIV2oJHWmWOuFxC5Y0UBD5CLg+Gi0WJUQ==
X-Gm-Gg: ASbGncsURhZGTja3avZBoxYcRWvdK+coErr6u9yxa/XNuTr2aFP1CA/Rucw/aPNivmm
	xU/iH+5JLfcYCYCt+swuTPJFLrKLfjUjJY947DC9/guZoBz0gDik0UUIMZTtyy/WoBu7SmttoYT
	fyHyHbRPO2Cg5BC4KKzo3vlwb7Q1+QLx0EZt3WFwAXs1inH3cwgQbD3jtzyKBgrJxfYCMcXhbCk
	J+wWeGHJfGwyBJHaApL/jDQk+aWn/cJHB8caALfbK/oDw71uIs3trsmgRhT9h0S9rywyXpy3g==
X-Google-Smtp-Source: AGHT+IGW3rnwRPb8WEwNqTyz1wwfAn5KHqqYxBaDlV78zmJCWuayX9a8ksHIrQUncY5Ow5tnnTpTxNuBcC0v9xLmqNI=
X-Received: by 2002:a17:907:3e93:b0:b73:2299:b891 with SMTP id
 a640c23a62f3a-b7331a048ddmr11999466b.8.1762886030014; Tue, 11 Nov 2025
 10:33:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251111004536.460310036@linuxfoundation.org>
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Wed, 12 Nov 2025 00:03:13 +0530
X-Gm-Features: AWmQ_bmgKdP63t7tWapnOHZkHv4fUMORWDcztPTMRDI9ccR9qOGODxwLC1UKFvk
Message-ID: <CAG=yYwk7yJ3M+RhhQfUoPnCMBJyThff-8zGFq4Q7MmsB4hb8fA@mail.gmail.com>
Subject: Re: [PATCH 6.17 000/849] 6.17.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"

 Compiled and booted  6.17.8-rc1+

NO new regression and issue from dmesg

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
