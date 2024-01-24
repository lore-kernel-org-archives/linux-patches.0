Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B8E60BBE
	for <patches@lists.linux.dev>; Wed, 24 Jan 2024 11:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706097520; cv=none; b=GIQwIul1Cob7rlvX+cUv1RFn8JzE4TgcFpEsKEMRvh1fZ44jwYZL6QmMlFp8PGYoaqVK2SfPWnLf0LjD0RfOW5tkJw4Z3jUlyrO78tSJuGN4k3XVPM9F6sUFrCkjY1eCkoAMe0aNB+q+TURPtDZVDIpVCZQGr0cWP/v6YC3Dx2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706097520; c=relaxed/simple;
	bh=2OMwQYIyKYq2QrymAVBBUuMzBZrJ/QI+2BLpsSS/wEc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kkpXRYkRQMolDaZ7eQUCvLiaVRB1OHUxhDI/cmZex/Iv75e5mNpd2dz8P2ByEsq32c7JSjmeMCv7i/TJdH/aV1uKUjloD4fFCAGm0hjdhe6772jNE3uuuMYXbeBFPnZspaHOmgBiqsgOLBuqoO4xypqB1kqquGYkJFcyEHEA0Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=KJ3wrfoX; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="KJ3wrfoX"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1d71b62fa87so30448025ad.0
        for <patches@lists.linux.dev>; Wed, 24 Jan 2024 03:58:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1706097518; x=1706702318; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6NSIi9kYH4kmkxlVRt8YH0clIrcU+K+qQZf81qv0t48=;
        b=KJ3wrfoX7PaZYBCeEZ358sRrWVN6p8ydAn7AvRV4YkN8JpuDo7skPDA6XwtWh1Q+g8
         8SstI+NaB+mDAEDFYF3P+LVb3c1oQLZBK4PX6cXG8ELh2mT0vlammP+I75wK5g8fdAsh
         IS7A89WMKemDDLEn4IpBDPvLFFieFatTZAQiKA1zF9Ax6zvnUtirFbZsOpU4qCTjt9cz
         yzKBirAgw/BF+GSU7twhEdOoQ0uF1UabXG8iHP1+UTCTZ9WQbIV4PHLXyiDDshl5sB59
         +T7VxtYHywkWN+5OrZ4OfxYwpAgicETMUGpGc5WDD3EGA7puBWG8J6cuDod5K6veH1+w
         PJWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706097518; x=1706702318;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6NSIi9kYH4kmkxlVRt8YH0clIrcU+K+qQZf81qv0t48=;
        b=SD0/iDM1sNuqm3oHtX/86YAr0Y6KfszNl7G9wQmHY53/YKExI8+1q05b7FxPEnL/To
         CpKZvi9t90V9UpzUn5l60G96+Z+60dnXQsXiw2xxEgNGnBh68HYBURaDPD3F3Nc9/w8h
         7Mjy6IoB10T/X/fyjYp05lzyzbHuhv70/QRlGqiFp4JFMNiT921EG/rDaqcGN8pbagp8
         hwc+uAMtM0i4MlpwEP1xm467Zj+nII2V2u29SNC0W5+tV+Rh01gdF7I8Ai6KzAI7zGHF
         bq71/8XFyWHczQmueylfTFs7D5pxISwd7Q+2HLOW+D08kqwEwD4g9C+9/DGDPngAkXbB
         PXnA==
X-Gm-Message-State: AOJu0YxmXeJ90KXpvPp6eVE8X4/j+WIqcquMA7j5MhLUFX9xKfagmZ4+
	o7hip/PICd/CXj1Rv4cpFfROJMkTsCoyV8h+aF/ciHbFzjdRraE8GxtLnQSq612F0fspDT5sX57
	pebVPy3O3CSIeSmnVPU9lKB7RAED+cGUWojkH+g==
X-Google-Smtp-Source: AGHT+IHtGgZ55t56cQPQMUGbeBxtNl46eMANJ70ZzKQDIlpS1pOQaJViGbCIAFKqVyUH2zZvzMGT36QM/s/9q3Aii6U=
X-Received: by 2002:a17:90a:7101:b0:28e:84d4:6ca0 with SMTP id
 h1-20020a17090a710100b0028e84d46ca0mr1491924pjk.20.1706097517811; Wed, 24 Jan
 2024 03:58:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240123174533.427864181@linuxfoundation.org>
In-Reply-To: <20240123174533.427864181@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 24 Jan 2024 20:58:26 +0900
Message-ID: <CAKL4bV5AXGh4DD8fBjYF1gCuFcKTSYcXxdg1wh_1OsorV-TqZg@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/580] 6.6.14-rc2 review
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

On Wed, Jan 24, 2024 at 2:47=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.14 release.
> There are 580 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 25 Jan 2024 17:44:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.14-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.6.14-rc2 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.14-rc2rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 13.2.1 20230801, GNU ld (GNU
Binutils) 2.41.0) #1 SMP PREEMPT_DYNAMIC Wed Jan 24 20:06:42 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
