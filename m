Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F6B314B84
	for <patches@lists.linux.dev>; Mon, 19 Jan 2026 11:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768822701; cv=none; b=QvVf/Pi2BjqrgF0ZPrFD0YO6/myuR+P6RpvzVSsKfCrtJGAeuOzOncymhn0xq9vLKP6uL3UBTJSYLdGB/YqAzr6Eu4ESzR/vvcxbYahFniiJyAs4e6WuoPAGqQA4FknC+v+e+Q/rISWeP5aetLIS0E112PDaP1RJVXYlgjRT910=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768822701; c=relaxed/simple;
	bh=Ps2KphrNYk9+A9Jf0Rcug5o0OSTW6xQX/ux0v/l9IO8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p39QS0OOPJ5TX0KoXF2TsLmvRL434VSNdV6Qt7Rpa1jqbtMf0z17y8s64aIBVDp5gLHyT1Vr2XQsni2wlH1xxHErwXF3kiZkb7c8cyFw3m56CQEhMZWTLVQew3ZtCoLv0JyBCc/t68BQ9qoZkPPv55JVIBuZhPXZP3+eB2DRexo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=XLRtSNC+; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="XLRtSNC+"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-64b58553449so7436056a12.1
        for <patches@lists.linux.dev>; Mon, 19 Jan 2026 03:38:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1768822698; x=1769427498; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YDsjal1GbbeJ/GHIkZdKBs/Za2CZbIezJM0l1CRzjuE=;
        b=XLRtSNC+WDFRT3BEKOOoPxgUuzdP5Xag1BzL6tKs/8V6pKMP9Ms2TcYo3LQ7jJ/0zx
         sAomihAKHkbNQ+tBBLF06xgEaLltH+vN3baYfw6dViEtTp64cwfrYBCswBLydhyKR9dZ
         EGJUvJIYlsTMZtChWHSJ/CO1tgkA0vl2S2V6T0ZZ+t4GGwtWBkNYzLniw9y9eTGp/sQg
         Gez7uO+W/WhmcODSBzFG5xwS5HtjeQPvjxHh76h+54VJqFHsgcVfsXsWOmrS6hf1YBji
         joR+pmOfdrZ/KIU+Q0DbtSsl2vGb13sfkTN+TH4eSCwjkI26+mNOzVgzX8k0iFz9VJGy
         qzuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768822698; x=1769427498;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YDsjal1GbbeJ/GHIkZdKBs/Za2CZbIezJM0l1CRzjuE=;
        b=qzgnIBxeVk9p7p4I2afhAVtx2t+Ee/B7ScJ/DekmIMzd+Z5gM9gJ0ODZHZLlx00yH8
         XPwaaEZRHjIoiV0r/JcMrQeQZwUz5nYPSnJRSZMbSgNZRc1YQBYeSi3YMsjk66voBeXi
         K7EcYuGvpsocukfjRhJkhwiv2Hl4/hXfH7wxHAhzUNpoSo7pL158vbT8rqQMHx/ai3QA
         hwZYl0fcibAhztiIzlawtpHgagirJHuYFrumxu7ZG4sqmvGT6Tl4p5vsujxIA0y8bE69
         8BBsfBGYWIsrv7TodPQCG6hhp02qGAiriZqIA/ivxPaO78SjEGZ4HdYJ7ZePDdbKeE4Z
         92Ig==
X-Forwarded-Encrypted: i=1; AJvYcCUcnEfG0HonryXbiJ0VTTJI+sgL3S0nbAkmBPxKeG1XizIffDoIAKTDhEeT/ecHSOM+FsY72+AJ@lists.linux.dev
X-Gm-Message-State: AOJu0YzpLpCTkGY3TxhWXUB0L+zrQ1trlpafqtSqQkwPHFzHm+rrWhMa
	qshKpU06TAA7BtMEeynZALjc7sJ4Tq9zzREsiAUR+/Z+prjLWgY5ykHOFW8K1qmuwUD2ISkHOtq
	YP/9Y5HhonWCj1Np7NONn2kQYxoZra/Tbm3DA5cwM/Q==
X-Gm-Gg: AY/fxX4uG4tfxZDPFoC2OGbvZ7iFD7tQmHGuX5v/oeZ4O4V9uNWZgh1V6164HbqfkSx
	XG5KOEzF7OdYHND9lRWP8L//PDUpL/gtlQaCoMAx5H4pJLklzzGI/fSztE7FBpaWfoom8+lxtPi
	7BcObVxbm69PoGAJ3u+WieN89QzWYPcgjEAyjvKO+/spMt++U2GQZlNIiEguM1ndDq79FSqsVCb
	3vQazj/VPLV1oX1PjEpgRxOcEufVCsnm3Rrrid31dSAuyjlizO0raN2xQEXHVodUbT74phZCQ==
X-Received: by 2002:a17:907:26c9:b0:b80:3fb7:f3a8 with SMTP id
 a640c23a62f3a-b87932eb1b6mr1012155066b.63.1768822698042; Mon, 19 Jan 2026
 03:38:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260115164230.864985076@linuxfoundation.org>
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Mon, 19 Jan 2026 17:07:41 +0530
X-Gm-Features: AZwV_QimJIeBfXB2Nyk88e2LVRiaArtEmEljGQEZ2MlIKUhFVpaSmDSUh5uHBwo
Message-ID: <CAG=yYwndSL66QOUV7cC_EAVjj3hW+d_KBiv9_xqVaLD5AKuAvw@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/451] 5.10.248-rc1 review
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

Compiled and booted   5.10.248-rc1+

dmesg -l err shows:
[   10.672706] snd_pci_acp3x 0000:04:00.5: Invalid ACP audio mode : 1

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
