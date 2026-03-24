Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B083E9F90
	for <patches@lists.linux.dev>; Tue, 24 Mar 2026 11:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774350306; cv=pass; b=dYCBb8upydv6M6bSR4aSd+erNTe7DbdqceBbgNEEZ6G8OVxyyIVZKrJG39JgjUICCX8HPInLXb5XmNDPuybbJSIUMLGMAGUkR0IzTpwNie5qMpkPYW3YDwTTQlF9NXAeS6dEmqGqF6KbhMArS9FinMqg7o6ED1O1qG+wUAHp9lY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774350306; c=relaxed/simple;
	bh=DmlJkHAT3FaEHvQNFxzSJKU8eAly0RnenTEM62bTSVo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i/1rbNTN+8bnf4rW22laBZM6MXecr4bJzs5M7FKAhYSOY7Q02wNECJSnkQ7BBTlQcpLoB5A/XQzXFg2BxFU0UX3DP2d7oVwv+g6Z/C3uYufVBqHdxw6hhkuC7BsHW8UY9xuB27VQq10bP9GVte1lNI31OCc5l/82i3LYA/f9mKs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=g/0ezNsw; arc=pass smtp.client-ip=74.125.82.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="g/0ezNsw"
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-2c0c955a481so5164420eec.1
        for <patches@lists.linux.dev>; Tue, 24 Mar 2026 04:05:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774350303; cv=none;
        d=google.com; s=arc-20240605;
        b=Qas+VnrLGm/O5ZJbJWtAcEWogl5EUXbh7hVGHNxxGi555ojnBKdLba0I8eDT4qnkl2
         jYbYsGFwlH/C5YEvfcGaMFsfCU+gowSm7FDlFihu2/yV8R1XwY6ukoJBz2z0mv5uB/KE
         rP1gCJc0B3h3Lm5FtZWZ46sZs+9913afFuqi041DjhFW5bQCdDRZqeGhgmtvnJ2a+9eK
         L+A4ieOzbb8bgY+hviVQAf8A0thMceFa8coOoANieEkYRHC0bveWPIqAkNhEhQoHlEWa
         Q378KRcIb77pePPCHspozM4w7L1i5+n6kwbSfDP0E+4tPFdorLkcws9o+mppeaKa7Llc
         M++w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Jxq/aet/8lEOzabqR4jPUvMy9ol0c4adzGEzqsQ7nhE=;
        fh=LFLRH0A5KyyLmMut9xIIHOy/7yuV2JXNbYiuf5JAtdU=;
        b=anA3rtlseXbAkxHKVtxtJB1z21Q6MFMabE7T21KlR9R9wFQLpurWyL66nKswcqx0L6
         k5HTMgTkSyN5FqZWHUTr53RpxfhCwRTXR5+kpz3fr3bcdaSrxz3U450HBW1bm0KI+h7I
         JEcMIZXGrnCKX730Cc0ZFYPPdaJkWNEYDbXlpIx+L5/uq6FK2AK547wDMpfPuCGYkgZd
         wx7PG1ZSfi5GipZ35D1Mf1PX66gcIY1mp7kzAITK0w4MD2XsZpwKfMV8+4O5WJ096OxK
         PlaXH7rNDhLdn2QFlvTxZYh2sXXcaK/LX0b2qZyMXDCfiovHTfER8tGyTXhz9PSEGgzG
         WFZg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1774350303; x=1774955103; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jxq/aet/8lEOzabqR4jPUvMy9ol0c4adzGEzqsQ7nhE=;
        b=g/0ezNswj4r8WQUVtP1UgRReTw8+nOGwmbLDmCMpv1ZJOaRpQJjJ9xpSKbX5ZQZcLS
         Wd2SaaIxuD4p3T3ZcRlOMAZDNS37fju29sM2IeIOmeNfZ14Bs5Q+NQKv5hASrCfnse7G
         6r9Ql59807t9RluFOqMSsaEcZaeq40xfKobxXpHN25XjSwvapsWx6iDaIMOznHYp6yTU
         TfcmMIPJWB6gaWlc9AfHKOfQYSmSQt7WBbpUAw+g125MqLRPYBPvF/R8vBLj4sL3Kcdg
         HyI9uNTkTz2e1uyBn2nillgPmB/03Rbp+StbhmAQWYUUIyNT72NsEtgdTQrghsD6udrH
         DYlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774350303; x=1774955103;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Jxq/aet/8lEOzabqR4jPUvMy9ol0c4adzGEzqsQ7nhE=;
        b=sI4ASYDc6ddkGr7aj77GHZLTZ81jWhtKdWhS/Tn2hezE2gjqAJKnqjnKusZuh2Ixu3
         o+PCXWhcTPzXZIkjdGPX9Fz0U31fDmq161tQsnjABN8y/aGMCqguNTkduuWzqiyP/RAr
         9S8m3nPESYWELEDiyoYMJTpwgD6c2WkwtKQ7XeIfh0Zsp4yQkSHblHBV6xgIqWExcVn3
         Kf4TpgZIdXmBNg0zL99ZGfKzeh4/bio+NkUOOpqEsPw3PmDKFIWDYbMm2TAccnNeR3fi
         LHFn178JNtKwEiTwI4VmRTna7vEQm5pNIx+MfyXRTRB95/d4TYQXWef80Np93HP3UiOK
         CuPQ==
X-Forwarded-Encrypted: i=1; AJvYcCVnlKq6vwY1DgNR8sFxuoRWjQayA7gMqZ293a/VigEF3Urp2P4kOYmvTmOy8Jd+pZOtnfxEdyaL@lists.linux.dev
X-Gm-Message-State: AOJu0YygwJUIi6fUdSUlIMuB9GYADKBqXvsiyIjiI3vkD9mXEJlRBunA
	XOg6+fRN6bmRX72tJJ2XNaw3IKXGBHBZGiJwaUSHpjMansNdJ7B4TM6SLZiK/xNkDJrG4pzkmUW
	Ko1SNmh0tESjZ1qd70U1FV/dv6GK/hRPDRTWY9f3zFQ==
X-Gm-Gg: ATEYQzxVo2joKvPUN3XAcwycdyHICb1kEScKSX0aqYkggluz9FLySu2mN5upea4rrRD
	ulmms7iKu8CfRrEXEqHd2IG94MOsykg4hZGHYwEYTwT6Wawj8iMinpFMbot1TL1TwMNEyZ8s+7m
	HeV8mrDMUo1fvu6xNhorHCj38Yro6+XoKQyTjd8bhsmycSBnY3cJqfX+D7SJt8J8KVHa/E0dDFn
	FLUQaVuzD52cWuuhGuvn4SK76ZVPSpyYClnzb7jzFQBF9+/3Y09yPhbcuCFaZhQgYl65H2Nrrz1
	CemkVBlj
X-Received: by 2002:a05:7022:31a:b0:127:33e0:ea44 with SMTP id
 a92af1059eb24-12a726cfa13mr7698243c88.29.1774350302261; Tue, 24 Mar 2026
 04:05:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260323134504.575022936@linuxfoundation.org>
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 24 Mar 2026 20:04:46 +0900
X-Gm-Features: AaiRm53QC1bDu7jJYOzMw-m1ql3o8Nj7l5BNcjGmDunSCA26e1BRNDCkTqFzcQY
Message-ID: <CAKL4bV42XtCM+xj+wWQhEPNirVPQ-GPfA_TsVfjhqrZqP9-hTg@mail.gmail.com>
Subject: Re: [PATCH 6.19 000/220] 6.19.10-rc1 review
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

On Mon, Mar 23, 2026 at 10:59=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.19.10 release.
> There are 220 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.19.10-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.19.10-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.19.10-rc1rv-g5cf3b8242cca
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.2.1 20260209, GNU ld (GNU
Binutils) 2.46) #1 SMP PREEMPT_DYNAMIC Tue Mar 24 19:05:43 JST 2026

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
