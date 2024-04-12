Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C770454FB5
	for <patches@lists.linux.dev>; Fri, 12 Apr 2024 11:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712922659; cv=none; b=qR6TpKn6xrH7j7VfnPkrc27x+WO5EtL2tkyHEvTAG6R38bhs8niBvH1oG8AZx4KfvhGtcN83jE4dNjQPqOK6pWuHsLV5us7C+SUeBYY/N960bSkLzOqD7IDzdZp3kNnOcs1tKm4jULkUdkayeKWNwKAG67rWd6Irbi3OvI0eeZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712922659; c=relaxed/simple;
	bh=6z1NM+xFuUNh+JCkp6BiT4e7bjolhUgniKMAOQP3vq0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Mmd9cL86za9G+4O43TT/RA/EBB/Y3RH2hN3yJJ2qDNcaw3Y3NDU+Taj/56UYsuy7my7ji2sMK6kHCMGuN5HaHYHr6WVCUyRyChSJwAixH/1X7BQeAnN/TB18DBzUgabn98+etfOIvo2Fist8MzUVef8k+IamcZYJVVaVGF4B4/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=hwwhShjz; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="hwwhShjz"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-5e4613f2b56so618595a12.1
        for <patches@lists.linux.dev>; Fri, 12 Apr 2024 04:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1712922657; x=1713527457; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fISH+O8RMH1Vim1fhD1kwnl/iMlNkK4IQpBqECYAtN4=;
        b=hwwhShjzQdWW7yd/OABElwh89MF69iz/ob0qyQDcWqHbgR8EofD3VCPlSrw76T0Tyf
         FHImGh054uMfMwBQsmnwCi8ph+C5Ph7cajf26N8PB2sRzcqX1s57VKJ4wsumuVOj5uqP
         kJQJM3o7iUPKFD/YuBr0nEUG38IqFB8+DILa7XX8A9abMiJc8l1KBlN1kHPxYwI+rwCa
         0oRKyrvoLuZOKkEmu9lgrOxtydoEjs8y7e4EMZ0BpTmPCNhrcEfjtr9wJTzlptWmp00w
         6UXWRGv+XMESN4M/OMz/E5P+yP0f7CTq1BYlby72UokkbtYUgkXJ8L2PF1OJhz6/x2XX
         7jZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712922657; x=1713527457;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fISH+O8RMH1Vim1fhD1kwnl/iMlNkK4IQpBqECYAtN4=;
        b=Q6RWs+W3pyfgTwG6GRSly4sdnxakl8FL7m++Bwdjsh0af9CW6AsOFljH8JXcZmhTsj
         SQbJEPayLG9o7oAO/vmL22KINC/Fz4LvrCrNSSSnoIR5KH6+ebpPJ+1g2W25KJgE+mxf
         qPD29WTtTKga4YU/7V5fbWQv+yB6s0VcfaARawv4QG97pFpWE5mi0oHDECvoDJWSxU30
         l3wr1Ilyrj866QUAkx1O9yIe6FySljNFXEz0WQDGOy5yCdxiIrL9p2/wOIVo8jhSsdNJ
         pxH9Q8W6sajI0Y34/p73IfSyj8eNd3DMf+alTUrfp0utIMuPn+Rv01411UU/lQr0KY+b
         k9TQ==
X-Forwarded-Encrypted: i=1; AJvYcCUu+3xIXH7K7GFqY2/Ub7ru6qi2k9AbeVHW2Nqxv0DoDWnnbn7woc85RlfH8cuO4Rkeo/xK9Z/nRnqwFQh9a2gGDqq6hKmicw==
X-Gm-Message-State: AOJu0YwcraN+w1sjgclDXWyJ4pvKhl8h3EHy5Eb+NQxA4/3M1wt5CTuU
	BDrUOCV14QpuuOWHucmYxgrA8/1WE7+5flEV8cbPNKjKr1YewNQD4UskBgLMuFEtOxmPhUSbL84
	QrSTfKwu3O3o/msUcsw+mgYGTcM15CZf9QC9qLg==
X-Google-Smtp-Source: AGHT+IHaFtm91nTnlsAoPlDzCvBuH9jkOA41r/Q2yzSRO8GdMNfDBlujSAYpXUO3pUimW9Z99G8gVa1f7Mlje8Hn9xE=
X-Received: by 2002:a05:6a20:9791:b0:1a7:7358:f108 with SMTP id
 hx17-20020a056a20979100b001a77358f108mr2373491pzc.24.1712922657034; Fri, 12
 Apr 2024 04:50:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240411095416.853744210@linuxfoundation.org>
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Fri, 12 Apr 2024 20:50:46 +0900
Message-ID: <CAKL4bV6up8KqinyhFqBPPvc+fyabtBkwy-7tVyNVzABx9QY3fg@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/114] 6.6.27-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Thu, Apr 11, 2024 at 7:25=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.27 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 13 Apr 2024 09:53:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.27-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.6.27-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.27-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 13.2.1 20230801, GNU ld (GNU
Binutils) 2.42.0) #1 SMP PREEMPT_DYNAMIC Fri Apr 12 19:42:31 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
