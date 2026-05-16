Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAAEE20D4FC
	for <patches@lists.linux.dev>; Sat, 16 May 2026 00:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778891196; cv=pass; b=cZFOKBxkRpoeuUjRcIvTINExW218QQ7nl9LmuWtNjmfUlbkerBJrye9Kfiz8qXDy3oXUjpLHwUjYyg1DXv+jd359zt0GeCmACm4mv8l7DfffreWtEzhlMMC1rI9pmej7lwlEtJRlALppiOScLzO1tj1giz1B06S3df9Z8SP0xP8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778891196; c=relaxed/simple;
	bh=dIIWfQgF6NrKg6ETYNLmA+FpnZ0vFs3JjzDdfduZHW4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JciV64/cPaLNj5lP1Obd/S9eO4yIXOzTXDPUISsK5BQOID+Dw/uaqNkeOKJdGLFk/W6YbMggCa4IOTGMOtkg+8ipGPPGyXpaGTSb/gy2Dv+IzQusA9KFF1cISHUim/5W1irE+WH+dr4jYJhQYSsired99Sn/mEHCz0Dt9nWE8O0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=XUX8CHMT; arc=pass smtp.client-ip=74.125.82.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="XUX8CHMT"
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-1309f4ee97fso384589c88.1
        for <patches@lists.linux.dev>; Fri, 15 May 2026 17:26:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778891194; cv=none;
        d=google.com; s=arc-20240605;
        b=Qsf3lUOgtATGjgYL6oWwMUBoNCj3HvhJQnhTsbIaHBIzfrtKgiFQUu8+d69NdS/L0X
         5EWHHcToDq1yDV1PZYcHDms5NxB6eD6ulvEp57dJ8o5hw+jH4DxGvzMMMkoIoeObQbJg
         2OQ6wRTWGSKxQU2SouBQrkQfS3BksnkzC/6s3hN8i6UTCZuYilizvfngXq1lzHprX2Js
         D8zwFWX9YCHoZ/u7Kq7bNwCcGaBG3/PYq+bdgca09z03qS2uc+vR4XCE0I2IKQNRGtuQ
         Xy7bRzSPRVa8447foPP/GSTvDznkaSYuIOOPMchVyTTr2qYDhNJajkBqMPuKs+NVqq9o
         qZXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BW1wsF1uVfc2+mTG/Ou2FeS75ZWI/1aML6hfMxBHNJE=;
        fh=qbPQU9qqy5yLCimVqHn+uq64SI9BItFhMyFUPlMimb8=;
        b=SaTdvAUl9dA0EpOEkwKQHzrht5rigJj1uA3tc1GZbJgYqrf+A24unU+Atn05yacKlO
         6zk2BSm8hoQsUUAaLgFkTbYFLPty+3uJfuECASZ5S0dzscO4wCyWEKZce2jUS/feHwii
         vB9+LKvzCs3OfrsDeon32+UGNUw8frrMLkj1q+Zp9qkdKAisKIyhRPtoBjSTnxBuuNh1
         c+sXJp6HjVmPyxlpoOKDzGPIKMoVa402/C36UYK2x6SYvzzcBkNdF4DKMUG7H6zg2a3Z
         xSmDGPZgNJtnmqRxkWZHUs57Rkycz9PaRcRR0YZsKerdQK1b6L6/Q+SnFw+lnghOgvWT
         hSyA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1778891194; x=1779495994; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BW1wsF1uVfc2+mTG/Ou2FeS75ZWI/1aML6hfMxBHNJE=;
        b=XUX8CHMT0oUx20d/A4Kndnl3PZ5YMfJQWYh8vpdECU4fiYJDeO3b0e229x7ws54LyX
         I/PV9oT8IIelUlWPfrVW/zWypZrgwKn+jau6e9fxE4TVZrvlUsgBjisAxArR1dUnRctV
         +5mDHRuZ9jKB6sCtpXPBgkVngXhxvPIPWe2QsiDCAfgL2+fT2SiOJiMMSdXF3UvZ/0Ja
         ZLJXyFPGKG9XRBddDD9js8/pXm8Xb8a44cOCzzvLooZaRL6tdGyA/MkCuuVTb28rr2v4
         s+gT6Kk7RftvIFH5JexStsDUtIHTojcs2C95MXMLQl1g3GeiVJHgyOJyezVpqj0T+1Lt
         SA0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778891194; x=1779495994;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BW1wsF1uVfc2+mTG/Ou2FeS75ZWI/1aML6hfMxBHNJE=;
        b=VPbsqGYu9fqAz4C+Tin9U9GAntFhk8OtZPwFHLab406/leo0CQKXnneQvn/4r68CSq
         Za6h7TIii1jhVHgyF7SBUXRbvj7g10wwOJcLLPpDsk1gelxnHf169oyqoLpipEnOx09Q
         iG4Q+kYYbx95nLa0riwIMaSaeXAZQTepU3O29DyW8qkAff51pDFX2jaZbRjT728BtmqY
         +MwswKvsTanudaw3pk02X/1kbSB7nDV1SIA2jfgJFOK2hgrvTvRXBDaPhS9E2FzEGinT
         e2GabafQyduVJbfDw5bJjs3ulpN3zYSNU6M8VuOQqGy+PkGTv7B/2tPz3oy/I68EDaCi
         O7cA==
X-Forwarded-Encrypted: i=1; AFNElJ85p0VY8zJRHUYurwM/R0ln5UcGvCaafUBGRtFWovYEKYCW7ZP+ZeISOEG6mD7+wBsArqbyFL6E@lists.linux.dev
X-Gm-Message-State: AOJu0YwTvrdonmSW5g2JeE/xp0IzuAKpi+bVG24UFYnse2RBtsyuVshr
	B04qyBwHUWfwUMx9I8SfpOQR2rtyNGunnXJL9RMuNC/J/9T6zjyE7eNRuqDMcGCm9stT54fdQKx
	pQsMsGjE5SwAWnbFO6u7lEErhGNgPgwy56U8st/8rXQ==
X-Gm-Gg: Acq92OF/3lgQwAkaYWohPIG8tqHqNdwGKkGbKEJInTlkB7+/PwW8ECYJvOPqXWvNDVs
	k/NkEiGZ+WqZF3LVgqEDlfKfY+bgWCi2/iS5LYm3bB6oo3msTwDGyAms2edzOAnbYNQWMgRx4u1
	lOHAExq0ivX9C1yWCDji/FHCb64AvKIkQFHb1b/zgV0veedGivpwb0bz1x5c+5PNvr1nuqM6HeO
	IYIPpFVdeMPZCm+W1Aw5f/zWik74grN6UrvbwBavHsa9h4Z0+rsq4KAmrYVdB/hsaW/K64zn9hP
	BjlqijgE
X-Received: by 2002:a05:7022:2586:b0:132:5d31:dcb9 with SMTP id
 a92af1059eb24-135047406dcmr2737099c88.22.1778891193923; Fri, 15 May 2026
 17:26:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260515154658.538039039@linuxfoundation.org>
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Sat, 16 May 2026 09:26:18 +0900
X-Gm-Features: AVHnY4LhZDZzxHCqHEtKvxJ7hgkJLOfAs--ulGb4qfLSXmqlJ2peGUyYPW59Fz8
Message-ID: <CAKL4bV4+e3UsQx7rv+k3J0XYGPJkFuxMUGN9Z76rDcUjrLdEFQ@mail.gmail.com>
Subject: Re: [PATCH 7.0 000/201] 7.0.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Sat, May 16, 2026 at 2:05=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.0.9 release.
> There are 201 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 17 May 2026 15:46:37 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.0.9-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Linux version 7.0.9-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 7.0.9-rc1rv-g64bd48307320
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 16.1.1 20260430, GNU ld (GNU
Binutils) 2.46.0) #1 SMP PREEMPT_DYNAMIC Sat May 16 08:46:38 JST 2026

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
