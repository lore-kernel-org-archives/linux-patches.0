Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795041052;
	b=3vJn3/xLVUowCEUW1m1TLenbMhid0dBt1C/S4WaKFXUoxyi/07tx/jtqLMlU7hrLy7iO
	 Tqd5CvyM4vSckY270cynO2MVAFUGLngyEiligi3fSvBXTvHCAG+4dEoAGu9u5cp/S6UTT
	 LtpwdXNxkXu4jgqvqAQsPijdkFAt/NGlGiKibBAM273ABZxIXlb9WdEdKkHcn3rV/AAWb
	 WR7bRRbNExIEyoeFy9nuBr1i/ZcGhrxRHmybaot21dBG1PekqjVNnUI0xBBSGy/dp6WrM
	 UJCFrSbUVJhcCE8irNYiW9+kIvtaZO4hfeojAuXNbJEpLKUeI+pTA0t3I5EpvEwD8rA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041052;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=yqnC38uWfwKQrsdALtzn7RtsAAUyiJIP1ETaKtJsGh4=;
	b=28xOeoST75kyla0LP29aeF7B2YKrdOk3Uc5i0xAeKQUe1yDCQDnp/naq8P0NIq7GPZhL
	 kRxkWy7iDa1p1Uce4ujJmIOQ5zOh6v7e2PV1ID/qQOv5zj6WcmlOLfrG+CsXI4uqVoImF
	 DzFbbjr/mY2aAIundIaDVL9O1OO/Ux+trhqvRrEUHCURjZhgQNfxZ3knEoSMasbiiUV0g
	 7cjqQ4PAUPeLLoCN7ehwX61+qP8/F/1alM8JnoXzwNI4O1KdAo6ZZGit+HevdmLka7ybW
	 M1JXZ1XejYCA5u6joi7YwBhFx8brfHEtfcJ85D4S9o2+zKRBoMgsTrTHoSmXMHYirag==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=futuring-girl.com;
	spf=pass smtp.mailfrom=futuring-girl.com;
	dkim=pass header.d=futuring-girl.com header.i=@futuring-girl.com header.a=rsa-sha256 header.s=google header.b=r9eERMMW;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.48
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786C8606A32F
	for <patches@lists.linux.dev>; Wed, 18 Nov 2026 22:30:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 786C8606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.a=rsa-sha256 header.s=google header.b=r9eERMMW
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c50cc8e0f84so233758066b.1
        for <patches@lists.linux.dev>; Wed, 18 Nov 2026 14:30:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795041050; cv=none;
        d=google.com; s=arc-20260327;
        b=bEjny5InXiKUSJX4bE6iHp6mLq3TzJ97viFi8blCqSz47Fc1Y1tMh7kkkijH231juE
         OHvc5K6sC0h4x9VEce018j0j3SJTLePC5iMSzpYA61ZJSoPYGR9KsSmAn1JiwG47m/8y
         fR6LNiXPqmLrPtte7XEerw/fNZfgTsY08U3H+6dhfhv4OrVxbV5X6T8mpbNuuFongJ1m
         NhpynpZ5Mxf5T0oj/XcLDLTi0X5CZA3Rrp7Og3w4pPIskOWgK6vd9ILBwH9K6zjU6tLF
         PbWOWRlw2+lpn7z7pvNhf/nXrAU+2uuSgdHsxt47RfCCbDWqZsZw1iq6KPmGe6Q92Rq+
         XN1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yqnC38uWfwKQrsdALtzn7RtsAAUyiJIP1ETaKtJsGh4=;
        fh=5cOtKN7Nyui3XOhfN22sJY+jZUS+oxb9fJsg2jQvoRM=;
        b=rskSyOP0ZwaQjQqLy0syFEPbVgD8D3FAB79jMc7CfF/FB5eaq1O13NXwqtVM5w5gKh
         yaxx3nu0hBAHX4tIluEZZphWWYQxs5sWN51s4X1iCZot+K7w9fvOxFnk5ga7oZPoYyiQ
         GdCIL9Usfgklwnt9FiZXAGHZMQ1vXxIjlRD8X0ZYiIaBhVePy90uzqjUFq5z7Ho1SX0H
         dADLzTfU4WdAwUcOKQoOqGgmRKvtR+Z+J1dfe87wwfoQso5E4sIz4VT9B3c+HpPwvoPM
         pkrHo1jrUJSzcQ/8uQ7gG83JlWvHHIwQTI6F9j4X14k04isC4Io6LLBxWrwO6+PHZZOB
         /+Pw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1795041050; x=1795645850; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yqnC38uWfwKQrsdALtzn7RtsAAUyiJIP1ETaKtJsGh4=;
        b=r9eERMMW/Ihe6Q4mc4oOSwmXyVLFibIa6HICRx5cAc8XfPBoo5Z36kYi4XDTi5ETj9
         rAOtPsnd08qSCZ0+BlknHdA5aBKQBvtOk/Hv3zYRIFHlWwfd3NJ7Ry30DjWYnqfjJUmB
         oiKhkTQOWJ4mKrJmu+57/ssB2Qc6tZI/7WZj4UD4l3sTiocUN57ouL9LDnQlYNsZatkc
         QRGphTZf9fHdWB2C5wbBDosTIsqXkzzgtpNStuFBmGjWJ/k93unmr7rvcaAE49WKZj3G
         h+J1cqgMpJC5OtihRMmMVnJISs+dZQh4Yha8hLForhF3TMcGQs3OB9VGFkBEQDNxO+qJ
         QI2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795041050; x=1795645850;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yqnC38uWfwKQrsdALtzn7RtsAAUyiJIP1ETaKtJsGh4=;
        b=P4GdknW0JLuyXsAtWsUlTXo2bZRHiP0KzkTCYm3wakKqZ2vxB2x3opIPY/HmmcbreT
         p7kdRcmvAFK19DYs/cenFBb6qJ/Fz0Gk79WnG/70qc9QFruJTTLknMr79kxdsSDvyKGT
         ntRLs3I3p/pfSBG2rm9UlOPGlSYaijrtXYucPmGuAGzIVcO5lPuR2UWbL6pgQYPaGFRJ
         3pSSz8z+2+dpjwHGJrgPog0bbFw9ILPlbAuq9ivWBeXqdNdUiASuAmNDjJTm49bM+vQF
         Fe54MnSzcEKYUSsE/Ye+Gpx/DuWLSU5r7lfLK91yW62b9VbKvnK/j2bsW+YNIDPvyuva
         Q1nQ==
X-Forwarded-Encrypted: i=1; AL+hErH6igVsYiN719IcpZqjj4DGeMV3dqsojeePviwxOH6K10yB11h/JDEkrzbRrnsLWoUr0/AhtBsw@lists.linux.dev
X-Gm-Message-State: APuU4Z/qCdeTgE9hr0AWtx2R7v+xqagHKSL5xFcMs/nB/DTE58y/fjb3
	7U40kT7vz0d0ugTJUx4f54x0TLZYT/N3Evv7+qexZy1XAVOTAJSdzzkAKz33x0CDxRVqmjG4gpj
	RqdfGPKrpx14NrtCys2UdTNBSXOU76VaqXssy8Xs2CQ==
X-Gm-Gg: AYBFou2Pxh5BLOmBdvDbwRla41fUfw6svjsHv4AXlb17Lr8fCHZdb6GjXsDIDgMPuTR
	4ARK3ZtWDi6MRj5sejT7173Afa+U+2bz8pjyyDpGsd9PKaYSTF7f2p4vPlEP/cvj1qA1TTGSV55
	gi0j37rZBhEJK6ozX+WzysIC/+GZMf7MFQCdydY0AjVqA6j5tki8K0rTaOaivgPbRbayeBC4sxD
	D8eaAmWi/0/rmzinuxKeoSeZt5srdwoPVNNd85dJcGDlFeksBfjAxnCbvNNHvDBbdEzUecXB7Jl
	647bE0WXpmme3IovaZT/KJWqu48pp3brO0qcoOC8keUNBMQ0GCAUJnhTYl0we4JfA2oZPIZzvMJ
	yG6evny/dYHBPIhrH9gYKLsS0waLgFd2P8Rnl3FXg1RyUmfRMn3bvhXisQg==
X-Received: by 2002:a17:907:3da5:b0:c41:26b8:c49c with SMTP id
 a640c23a62f3a-c510e169389mr367702866b.10.1795041049337; Wed, 18 Nov 2026
 14:30:49 -0800 (PST)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261118150247.972732815@linuxfoundation.org>
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Thu, 19 Nov 2026 07:30:30 +0900
X-Gm-Features: AclHuK-6KSFdeiMC8z3chBPKy6DS0Q8xZ1fgA_xjvJB7kCL4tYoOxjNdA9E-2fQ
Message-ID: <CAKL4bV78Ze=q5THC2pbgfczSEH37KbaYKBerS3eXwadJGpx+hw@mail.gmail.com>
Subject: Re: [PATCH 7.3 0000/2651] 7.3.6-rc1 review
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

On Thu, Nov 19, 2026 at 12:08=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.3.6 release.
> There are 2651 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 20 Nov 2026 14:55:47 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.3.6-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.3.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Linux version 7.3.6-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 7.3.6-rc1rv-g62eba995b019
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 16.2.1 20260810, GNU ld (GNU
Binutils) 2.47) #1 SMP PREEMPT_DYNAMIC Thu Nov 19 06:29:24 JST 2026

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
