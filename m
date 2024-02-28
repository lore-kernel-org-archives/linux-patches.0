Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0B373534
	for <patches@lists.linux.dev>; Wed, 28 Feb 2024 12:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709121864; cv=none; b=AkuHMjrM08v9wuhx0FSvWRwQdYacyHMtGcuZMlMHza+3IL6jiAVtkIuJLID3OU1DnYW41WAqtfJRbJW024A+QjDsOlEhvqKlI7DHjmLdgyoQk3udfVeK8L2nLWVTsXuuO/Kv5bwK2TLGiHKtVgCDaT9wq1v/JMuEMU17YlaFB2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709121864; c=relaxed/simple;
	bh=Mnm19xaAQ5kCIohrvHCI7K09SSPAvZEzrSgRiBgDsiI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VwDQd8sjibfy5jE9Ske0zkX2L4ijsfK4b59bUT9oHsAerVExJi0NTlnL3k0wvjhCCGrqOW0BAwp9BfBTEI/WR9+NcJ+8nalXK3I3L1p8gR49eHkCm4o2RnpH3uSnV/A2xvceCCzizsBHt6DDf2GmobRh2YhxtIjk4CcoQ1UqOJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=ZCDGB5wm; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="ZCDGB5wm"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-33dd2f0a0c4so2342771f8f.0
        for <patches@lists.linux.dev>; Wed, 28 Feb 2024 04:04:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1709121861; x=1709726661; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xHFmDVf9X2LvHVAYveT1OfX2Grk6oRfK60r+9cQf5wo=;
        b=ZCDGB5wmHXZ8duFCIvm+IuWQLi3I79YLSnRi0dkXNtFF3VzhDQi1Z/zUNBDOHXtv3/
         qRXHqdT0eIbziP7EQ6j70PV7Lx3yEwaOTdVyIyvhKn6JPNC643Rq+RbiwGKG42DFfEPn
         k0DKfW4QsHOhg2Zr5o97k9q3M9f17HG5m5oUwWgFBR4ryJEHYr5riLZxtSwjp2qRsvin
         WJpo5SRuXMXPLVf6o657/uVMSqEYAo5vO0B3ggFRQ69Pk1RT9BcoV7wUEvSwI+FA3hUw
         xOxl2PQZZgYCnXKmud/aTMwBWVK7yisQtZpsp5lGu+3Eq8Gz2D/+4jBxiCkQTh46oWGX
         lrDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709121861; x=1709726661;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xHFmDVf9X2LvHVAYveT1OfX2Grk6oRfK60r+9cQf5wo=;
        b=akIhTc6R2SGu/p94+x9uZlO24c0IK56tfviGN08p9vUe1tIzdWhok0skdgbm/LwhAa
         Xko/TIOA0ZjliiJ/gfYbhpUneImPl4ellVTXvgAtWQn4lvOYK9nOIZJsW5dAN0OkvO3l
         SzbR709Qd34DTuPmFIcjawFMpsYaJ1MO9q+lj2pq4MIr+o5Gcm9iH/XVanfeNpjcn3Fq
         CtIJuq/z8YDQQFj8k2I0HbzJ65CEItBSISk0yjtJ12NihkjuE7HA9lqIVF1U1XRRnXTF
         BhFCykkvV3CPKX0WiPy0PmtiP9dsWl04z92vTN6peMaXP1LEIirX4lp3xecBuu/JjTXh
         ZfCg==
X-Forwarded-Encrypted: i=1; AJvYcCVGxyzEXBKqFPieXCjbr4r5GSrheoXU8FjkF65DObOPOeIt7SI4Nx4AnxO3GsQ3SoU89HWI7gWIsOulVHg8r78ZoCpX6cGakQ==
X-Gm-Message-State: AOJu0YzMm/OhL2Fkv1J2J8raDpge5MoW6g2sDcgZ816v39kLNQVeP3gY
	MyvcX3/8uSspaqtIIFLKeSNYc0eM02/IXHIoF9kwlrmFH6OUL8vxKHkX0EQ+cogiaDYITyLEWk+
	YfvlTLgwzR4F0zEDmoU2ak8XBZReYc4/zbkgEcA==
X-Google-Smtp-Source: AGHT+IEKUemO53QKCZd3tRoOdZknznfHKFG5vUI9UV3SBjGBuFo5hqu0XZiHYJ7iAivhB0gd63HXegceEP2Br4EYKOs=
X-Received: by 2002:a5d:5692:0:b0:33d:2071:9b85 with SMTP id
 f18-20020a5d5692000000b0033d20719b85mr7813274wrv.19.1709121860313; Wed, 28
 Feb 2024 04:04:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240227131625.847743063@linuxfoundation.org>
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 28 Feb 2024 21:04:09 +0900
Message-ID: <CAKL4bV4OKYiBS3Op-Eny2PpMgsg1R8sK+BN0so8mjVOk4ixChg@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/299] 6.6.19-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Tue, Feb 27, 2024 at 10:50=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.19 release.
> There are 299 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 29 Feb 2024 13:15:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.19-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.6.19-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.19-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 13.2.1 20230801, GNU ld (GNU
Binutils) 2.42.0) #1 SMP PREEMPT_DYNAMIC Wed Feb 28 20:10:55 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
