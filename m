Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50DA11A262D
	for <patches@lists.linux.dev>; Sat, 15 Feb 2025 10:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739617130; cv=none; b=AFgGSukqy6TEHmNKPGKoXHjfM7xe5ImmNCVipbRUcbyoGQ9a4V/JwTxS9V65R5jHVHkq8E67Fq8ufdyQjbpwDFJYCPhuIDWRqLIqdDNfTqSi8Plw15JJ8KP7iTS3ufiKSHUzHpOwZL4zWr3I8ICUEIKbqMiwlA8BTIIkfKfROuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739617130; c=relaxed/simple;
	bh=WypY/zniCX/xErM/Fd3718ZwTFWc3QmqpFaCeoPBLIg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eu+Q4SF//y6f6Zk0igjfWUQbpcGDqHUd31SL/JCWhGnxvV3UQoBvw5kM8OvZRSHpQoPJ6ib1cLYKLaoqKwJ3rS7SViPAXZpu84jhVQB0jtXUBo1moeyzcD7k1u1XKB0TcR/+Jv7BFWOoWZcqJco6KGDh0HqFAp0AFgirU5ElrbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=fJ4/3GsI; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="fJ4/3GsI"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2fc3a14f6fbso1377660a91.3
        for <patches@lists.linux.dev>; Sat, 15 Feb 2025 02:58:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1739617128; x=1740221928; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WXfy0pOqgURw0sBNhPyNsYPIbvhDPU5LYX/WlO2f4Gk=;
        b=fJ4/3GsIIPCHSjZZBBeRvDb/BHjI/IAbOfNzvH08bP9UYl4mIQPPOp/Wa/y7JB7/E5
         IcpkvqIaZothjkw92ZOL90/j0/O8hkc7Kqt3V5QA1edJxF6BC5Wf5WzaF7m3dGhNhyE/
         sw+0bz6U38lhT16KoO2IF/Uj8IoCCKRhCJWS9GZhDSR8A2sN6FEyd+2iYZL+QBE4XrH2
         H7be15+GtCQMS2sQFEXtG3pnv6mpPKz3yztlFTg3652bsn90DflTErJgToIlml/MtfJZ
         NtqSsilqIVvzyKd8aPQMKNGdJaxXs59xHckCbgab78oMBly0GIpIbnbJa6Onz1GUjVZ4
         RPGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739617128; x=1740221928;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WXfy0pOqgURw0sBNhPyNsYPIbvhDPU5LYX/WlO2f4Gk=;
        b=KX4HWt9subDIwD2zdRbgz5N7u+TMrcK1EXBYFsvOu6VjCLeW9wQMucWInksSDg+94B
         wXAk58aBHQzjQZf3k236Qkr0bdX4rRUAZbAWP+WJCMu0Dtl+BklwDFMzt1bFHxITrJ0i
         bUHrH4DAsATJR6cynO6LvzxAD6T/tFt8BSHc/K6zDtwQrpa78i+WkqojkKiTdQabYPc/
         FFtdSoomN6AbGeN+6Pqt0muiOUYvCq2oit22Ljf+4WTymLkyQayOXoRu0XQVrYO4LqD4
         Lb0QkMdAjVFRwo9iYApDWo3etuC4/gMu+EtL5eUHpxdCOFmKJlhUvflqfPWISUQHZro1
         es1Q==
X-Forwarded-Encrypted: i=1; AJvYcCV4hqELxOwcQg0P/Kuxse0AjmaVONE1E9BExqLWE6VmM0TwB1Wtb/ncoslJPmpS4xVqn+SIX4dF@lists.linux.dev
X-Gm-Message-State: AOJu0Yy/1mWWUML0TKvG2NMcaF3qT6cCbnqwLduq6WqWuaA7KAVV/lHT
	o6CrcBw2KojJElx8TN1W3konP5XFuRi7zVZsjLN9hfCob7v+Wc/J7N3KR9jUbvKTmB3NWy/mOm+
	QL5OTVZ4r52/Q70Vr5wa92fdUvqrLjJ06aUVgeQ==
X-Gm-Gg: ASbGnct2UXEpNS/x9co0d/Xm825LBQ/Lv8nhX2LmYGh4x6UlUbpMrdUP1FnRBSq6BK9
	PEXbcdpVjTQE4VFUfbsfRgrhMIOQFu730WY+I7cVOg3KOEiCBn/6rSm0xRP8Rw8JgnAmFO1Q=
X-Google-Smtp-Source: AGHT+IGcm3YamL+djIkvINYQT1aOevF5/DZ5KAC3xRAWBFUGwATEBGcQ+6Hum4fw7ATKOI8oyHGs5dLlknn8TxpJt7c=
X-Received: by 2002:a17:90a:d44c:b0:2ee:f687:6ad5 with SMTP id
 98e67ed59e1d1-2fc40d131a6mr3847992a91.2.1739617128566; Sat, 15 Feb 2025
 02:58:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250215075925.888236411@linuxfoundation.org>
In-Reply-To: <20250215075925.888236411@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Sat, 15 Feb 2025 19:58:37 +0900
X-Gm-Features: AWEUYZnkoOlW1hyrGRrx9kFeBwSnP1ZO4zRWH6Z6cw3cQhiue6RMn3nyo77fQHU
Message-ID: <CAKL4bV6ibyowUOZfrfndLH+XawFRPObBNR6cJXTvoJ8RQK8SxA@mail.gmail.com>
Subject: Re: [PATCH 6.13 000/442] 6.13.3-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Sat, Feb 15, 2025 at 5:00=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.13.3 release.
> There are 442 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 17 Feb 2025 07:57:54 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.13.3-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.13.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.13.3-rc3 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.13.3-rc3rv-gf10c3f62c5fd
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.2.1 20250207, GNU ld (GNU
Binutils) 2.44) #1 SMP PREEMPT_DYNAMIC Sat Feb 15 19:21:18 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
