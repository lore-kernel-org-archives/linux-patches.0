Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7262D8391
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 12:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784724060; cv=pass; b=sLliHeT4pQU66cDSIAjngeC7Q5ksuobpy1x1SS7q58HLds/cC0Qq7EqI8Pozl4lUfE2dltuVFvMc6tR779R6Va4UGj1q8klzko7Y+YVRFaW1PeIgjm04w3Dk9jIVc8ZI7c2cXdrxUyvh5CIKgyFp6txmBkWFvVP/WkunlWIXOaI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784724060; c=relaxed/simple;
	bh=pZ1WDIDZlnd78tAWM6ujRUwRrnJmwqrdqQUCDuW1oZE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Yy/joivCDlr6aL25ab2fKwOkWbQY/MO93lqsNqb5P0ez/HVwQTQK4m9vGnLGNpa9aP+VCbx8c9mjCmSOsEX9XgSh7zPiXDjCFfJOfCLaYxd3793P1thK9tcLkaoqX1aVZ1JuBxwnSdyMz86ouGzmPs2Yjmelc/ADVmrLMFTMmY0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=v2ujiNrN; arc=pass smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="v2ujiNrN"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-38e42560ebcso5700776a91.1
        for <patches@lists.linux.dev>; Wed, 22 Jul 2026 05:40:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784724059; cv=none;
        d=google.com; s=arc-20260327;
        b=VdIjCwQLU16tIJf1sU594YtINXGmtoNzzDipWnLYE7NBUleCyENKDDAu5JUUndn/4o
         H9Z8x2VFJrbO/L9coEanBvwO638a0y0hKTHSnmKjOSZklXhijF/IV1nw/w6x1G5XxLX5
         ls7pI4xkoFV8RV2ClTNaTXjs3nSJAP1KAr545mz9loikVTCLoQKjYIm3FmJV7WLuKgT0
         f5j6whxqEMYla5hUxO/tZc7N9MEBijcQ7Rfs1DkfzO6uWQGYMowKNi2wzFHBxK95edRs
         uZMuqT9tsF1hyW6lKBlv0MHymBLdvwJ/0owQ/gD9k51nrtSUdC44eVXZLoFeu42OQG9v
         7lXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Kj0y7vGSTuWcIMCDEdm/LDUzje6wFVBCY0Bt2MWRjlU=;
        fh=8+om21no4QkQ+aFJEPmZlWJR5GsLsmx7Oio59t1r2EY=;
        b=BV39u6x5pU+VOUVYFPenzpGxYEnFFC1LdfL/qadKm+I5zgPp84mhT2cTwsSmHDwIC2
         viCMOobSdSU9YNsypjKBZvXJnga8Ae1eu8AFB5pGsdahud3whlDLIN1EGnoU9e8HdOsl
         2Ekc0w1yp2i/JOH0BLbrwmpUicietQT5VY4G5NH3qnr4G/Z661kFZCZ3D51o7tzSM2vt
         rppEWpb2c4br0xGxoOiQHsdwhwXn2dz5c7O+UQ7tUDfdHnGfng+xOJobdXGvNrpQy6BW
         romzZ3fqPeUE3a4l+KgKtxLmhWPTidHvCSsNo8SGSrB/1PRiOiK7ELnHHZCl+UE9rCr8
         Q3Jg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1784724059; x=1785328859; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Kj0y7vGSTuWcIMCDEdm/LDUzje6wFVBCY0Bt2MWRjlU=;
        b=v2ujiNrNt5mtfcEkW5i8G6uHT8qTo8N1s8Z9QNCBT7b06qjjTmqraMV0wWt+ZgYEkH
         JLEZr+d2qZFJGdnt5bWOLPAnqa4+uKW74IGvMRZgrX7UqLb0cuvRyJUly8OeHHKoCDIZ
         dzLWWkYRx3TGzq+4NsCDUHyQ4SwxjHyGdRC6p+RR17sJuWohB9ggH8HWWQxUoaFW7eka
         wPoFrHgmD/XVLJKxDmhbJC5Dk+mHP3z0Byq1h/iwonUUOC2qOifqPe/kZLnbycCglSl/
         maES/sncTE6+ifg1LCRlXVdNCG4wGoZcbg09ywO9jp6BB0BYFs6cQFLg1flN3WSBRpry
         Rd+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784724059; x=1785328859;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Kj0y7vGSTuWcIMCDEdm/LDUzje6wFVBCY0Bt2MWRjlU=;
        b=oOP4D89sDFWaBf0a1ZXthXXw4nVD2n061IqO7NWqi5FGZ8TZcHZ50EqHDtlGxYQTLW
         0oXl6iuA9BiIPs94hXqtnmQwbNiIaQOCD8UYtSuoL6LEJx2C9u6j5nIgcxv5ThSfdxbm
         7C49riPCCQTjDqEu7oXgIncYLzwqocr3tUkhOzhHfGDpyI4VyziQteEmfJ9wh3bZAj9h
         16UrP6oxyCtzONbGn+qQ3omx+6r18QZ+YIkhwqIzNkId6+Vnxq8fC0aS3jTnMFHpf+AH
         BuJiete7nvvFJ9ayR40g6p5ADlymIAMx2523Lp4BoIFjS0z55BzVL2Y0NbusxA8RwF/I
         uOoA==
X-Forwarded-Encrypted: i=1; AHgh+RrvpxIpWIHF+kkOc9J3fwLVNOby9TVB3hCw39/DMbHewyYUHD7iQHfkOd1pAqu030Y7Om/wc570@lists.linux.dev
X-Gm-Message-State: AOJu0YxGdcgZA0j2qh6FNZ7724z+KMzciNBy0HhTR+zcdWPe/5L7d+gA
	9/VZPDB+cobcKF9CPynywvYTKYkqmgBX6MoFTSyZcBKUaaghv5ly9GVt1yPYJ+txb79RnurpBX2
	ORzuIsOR/HuPlx16XUS10qxgJ+ucES+mgaIo5IP+4ew==
X-Gm-Gg: AR+sD11dPMM5ECeJ631C2avUH0LLImQhg+x5ofWTmYGk3iDhiHltcJTIOajM8Aw25Vd
	ZRLG69tGhB9A6E5TcM+ItGyzmIdGL0fbJK37LLkgA+ad32NVaZsIr5kCZ2KqlllR9cBsXbK8z2p
	N+hbwzV8hpJYdw0EcO88Ean0DJrop35KjRE3maQziw3ZbP3pdGT8kxaEdB0HC33mydJRqMgy65Q
	nuAy2y9ZrhPvqcB94r4YlglfHc+A+DLj8yVnZcQMlWJv88PN6Er3qTPcd37ZsA=
X-Received: by 2002:a17:90b:5583:b0:38e:9279:468c with SMTP id
 98e67ed59e1d1-38e92794f00mr7560875a91.25.1784724058833; Wed, 22 Jul 2026
 05:40:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260721152552.646164743@linuxfoundation.org>
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 22 Jul 2026 21:40:42 +0900
X-Gm-Features: AUfX_mzcdC9Ws3AbYBQOMw16woTbrgc2td07tn2v7gcAQhw0UDcwjcOFa7D-zSo
Message-ID: <CAKL4bV6dCGx_KK=8i7MqXVDPvyjRN6c-rhi2Axum0bOQ-GXLWg@mail.gmail.com>
Subject: Re: [PATCH 7.1 0000/2077] 7.1.5-rc1 review
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

On Wed, Jul 22, 2026 at 12:32=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.1.5 release.
> There are 2077 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 23 Jul 2026 15:23:00 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.1.5-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Linux version 7.1.5-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 7.1.5-rc1rv-g06ed1e6c413d
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 16.1.1 20260625, GNU ld (GNU
Binutils) 2.46.1) #1 SMP PREEMPT_DYNAMIC Wed Jul 22 21:13:10 JST 2026

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
