Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794609130;
	b=DWgS5nxvUHbWnxdG2qVQ1F+Onyf8Pe6L5/kPlUV0zQh2Qu6/ILUS3fU7xferRU4B4T8s
	 Xzq4AIaP+DJnAVEHGiwrRPBq6xrwisBp4FrvHrKq9hinh9R5hRIvMWd+9euQZ+3tiOf2r
	 2ZjGgz4/TACHM7efGUQ58i2R5aQhiG6TMaSXDlGuxEsarlrj1oDoI73BKn5BWJBxjqYHr
	 ymd9awt2tjSMl4pnuQUqZj1YI9kqzMYOiRDl3zOgomTVDHQiPnkYKn8BQWC0ofo/qnmQ7
	 b1WYaxC12atKuA6YP7hDBP7i2uI2rtTJqP/dCzMFSm+JPng2FrXy1U4AzYCIp+xlswg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794609130;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=onj0EjD6Aez/x0pUU0g9Id70lDTi0FHuQrAvFaAFFFo=;
	b=UJJU+r3gePeIpYWm8DL6zdCtVqgPXCFMDNlBU6pvHUaBHGJOsn75YX31Lh5VKIhnRkrt
	 vl6pk9Gqt+OXoZ3pB7aL1mnBvFFhj1vYnIkPxs8Nu7Z0DZG9xrHfD7D1XMDcaObAzq+CX
	 BUx1SX2VhPZz/6AolmrBmwOd2/fwvRASNRGQsVzH+5Fjyug8S6gDSO+OrP6X+ODG70dHz
	 uk0NwVWcnBR7lTY9G7l8AOz5oHmxjSWOcb22jVgMTDb2YyyNaKEEzz0K46BIJTztsUtUe
	 HqewoUfNvCwMzMeGKgyAUsVl+FynDAhObVYEK6lUVL/EQ8X1JErphqsH0uzqiNkhiIw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=futuring-girl.com;
	spf=pass smtp.mailfrom=futuring-girl.com;
	dkim=pass header.d=futuring-girl.com header.i=@futuring-girl.com header.a=rsa-sha256 header.s=google header.b=xieA9VuP;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.41
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8171C606A890
	for <patches@lists.linux.dev>; Fri, 13 Nov 2026 22:32:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8171C606A890
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.a=rsa-sha256 header.s=google header.b=xieA9VuP
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c50933bdf4bso372213166b.1
        for <patches@lists.linux.dev>; Fri, 13 Nov 2026 14:32:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794609123; cv=none;
        d=google.com; s=arc-20260327;
        b=sbbQ9I7j40sy6camSctq9BV6tyozF/j3NsehljOYXAeQMo0Q2EIOeltRk58j70wLsl
         Oy960wLrl9Pe9hewQF+GQeRLpuEMgc3Hz6XuoQT1DIY/9r/w8UfoG/oTTS1ek9ChRa8v
         eYSsABvO2ZlHHxI51eRva83T3VO4pwHW2H9ZNLZl+RiyffKarMOGjns2+DdkPiKWg8Ea
         JkLZgCjuCa0mOri1WF2tdfY7x04wBGrZbIa+P3aoNssWoRdMAFEoYh/vlFBIA8tT2YQs
         lvaX3PH7sBYQkKt2PWchcCaz/KLwVc/RR1adqj/25qvJJ9nZuVeWu2YaJhjR5rAczjVZ
         4Eeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=onj0EjD6Aez/x0pUU0g9Id70lDTi0FHuQrAvFaAFFFo=;
        fh=m67ykIdSZW/zOHbx/MX3Hk9Nl0oG+mYrnF92T4bbcZY=;
        b=gXgIBdT1i5rOcnSmpTplIQrnSzOy/+KeArMAGNl+PH7Fm2xfz1dtA66RJ3gd7C6haG
         sqspWEt7GJAZvWPzVUuv5bUmwwy3eDUzWmmPYSTh6DbFgJ4Ve46iB7zLmu/pTHQvhhGu
         bawzpnOL5jOpSKNw6hQtK8GpNsrrX2mphZkDXRkwX9zhprQvFWpR6Ez/cI48RJxC8WJT
         RRLSvf+Ae2POmv26HLZvWBZT/bdbEJmD477JplYjmJApFw/5XAxyB4sM4MauRxTI+dKV
         caL+/sWRMKQiC4l5TAbV/GWvOSOzjHgn7zcD4f1meoW3Aw3I3OZSm1862L6Z4XaW60/Y
         lwgw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1794609123; x=1795213923; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=onj0EjD6Aez/x0pUU0g9Id70lDTi0FHuQrAvFaAFFFo=;
        b=xieA9VuP3SOzqHPP7VjHeMKirX+opLlQv06VILtqtaC1VQgFl2G4ebgbS24WPOP5vg
         IGbK8bmWK2yeyM6hh8pBRWT6vJs56yvZzWWPCrWk77WwKGc5CKEjSi89zC4QXPvndeG1
         CRdOJJAL1P4E/0L2FBBA2XWitRWd/APYi4VkvRLlvxaruP/+eMuIEGsv4y4CAz2bwf7b
         mvSLi4Xs57651kK8KTxuADkEfhZ23aJXM6NrOGCMUGaaWQj+sNDDOMHwIrN6NLucUzc7
         djy9VwK4A+axp5LQxW8i/nM8wUlvRS4AonnwuCxVVIg8jazc3PEUCGnIFCDNlM05zF4C
         x5hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794609123; x=1795213923;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=onj0EjD6Aez/x0pUU0g9Id70lDTi0FHuQrAvFaAFFFo=;
        b=HQX1J6YwY7bjwnemBDn5v8VxRn9j5TxaQihL2/fIQjACQSsnVKny87zzWX8zwxlTwC
         ndOnC3E3I6XcVFP/hRY4UjIgdrxZOmBRUOUiTsUhukZYQUD/nEjhK6nLsBT+O8qLNu02
         RdyaYxKoxF14Kn+8kyd/4DND4yVzrPkYutCI+cvPinV86U2GoR9Z3F1eaXtadlFca+Hj
         w4srpa6xquQgk3jtx8ekYpETvZ8GRc3n8NwYT0uIQ+cLyAS0Kdiikbd0cWeyILlD1Jtw
         8RXEw/1UvKLlLOospIFc5Vluq/XL3He2qDAJ+m/Xu6dqFUMOGmFIdmIPGV9DQKVJGMoX
         VfUA==
X-Forwarded-Encrypted: i=1; AL+hErFQ8QtOKsNw2TFxyJ2aR7YO6PZHW5PmtrEhAHYn9YfpPjSr96blCULcDxlfWhWO8O2EKG+ysHbq@lists.linux.dev
X-Gm-Message-State: APuU4Z+Xx5sJ/W6c1u4kd5CPSMAiaupU1RLhZNO0NHLNRKBOcV9+EPuJ
	RB246aCjKCoqRiMo6lt/KXxvZ3a7lI8EUcS+LnpK423fZk7ZXx8dAxSq4JsvEtoaG3lnJ0OSBAJ
	nu3SRsI6pKX/HYcm5pIpk+979DOjuYC3RO2SjAUtweQ==
X-Gm-Gg: AYBFou2s6bHrT5hlyAwNZ2s1dWxn7z1YIhrnRr+LeCuOnMZc/7M0HdZmYpaDDz4/t1m
	XM9Omh4S/Y5e+ciXtClaf0hU87E039nuD6HmIPxQnhOSNoMc9CXi9EcCbQ2CsIZV72tb0ZWqm2T
	WVncNWNNh3IZn9pffP5xBESibB2+vZdVKtpk21RGe/PVxksXtNwPktxJwTdXOFEHN/QhS+g2kmp
	MwV2d3ButlzWG508DqBA/PDOk1z/ucIquDpPkWMBfR0Rt4N8b01X8lxqmwY1uA2M0EuIU16gDoD
	XBBKzSP5NSBy9MaENAejYuqvaosq9RWZp+wZZf8StmWDveykpZq6F2wlCf9WboORyOgImaeQbIT
	64ILBruZozyiObd8ugH/joBNDxNk2q+RpaQYv
X-Received: by 2002:a17:907:6d20:b0:c3e:d0ca:d30a with SMTP id
 a640c23a62f3a-c50963163d1mr368073766b.4.1794609122655; Fri, 13 Nov 2026
 14:32:02 -0800 (PST)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261113153753.358973689@linuxfoundation.org>
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Sat, 14 Nov 2026 07:31:46 +0900
X-Gm-Features: AclHuK_KdfyMzEueRu1lFvcw1syUDZJwtEIuIcU0NsNDTyLYCMdVVceVeCzKY8I
Message-ID: <CAKL4bV6ENVk-ScbP=5MKkzvSUA2vkqa5aF38GG7XX5EC+zV5_w@mail.gmail.com>
Subject: Re: [PATCH 7.3 000/507] 7.3.5-rc1 review
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

On Sat, Nov 14, 2026 at 3:29=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.3.5 release.
> There are 507 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 15 Nov 2026 15:36:17 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.3.5-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.3.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Linux version 7.3.5-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 7.3.5-rc1rv-g2a640ccd9d0b
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 16.2.1 20260810, GNU ld (GNU
Binutils) 2.47) #1 SMP PREEMPT_DYNAMIC Sat Nov 14 06:49:53 JST 2026

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
