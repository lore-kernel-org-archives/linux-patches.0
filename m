Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B4B2C08C8
	for <patches@lists.linux.dev>; Tue, 15 Jul 2025 21:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752614849; cv=none; b=JNeeTfVJcP3/NjrlKkgm9QloC4ppvE7t6ZuOCBnle/pILUPVU5VcQH5pwmXYwOqqBOOxxMVlVQYxBcasBGNin9HEF+cu1HRC2zUTGl5afRZcuXbg/GSVtkvkLeRUzKhIdhQbzXTEBInGvsiKDsR9YqRJe77Cx+4+FrHi3KjGzLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752614849; c=relaxed/simple;
	bh=D9HEnKpqxTaHq5dlDfw7mwWkvcUfEgMavo2bCfMr8us=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sRoatp6Ff0eFPyG43TRp4dFKffN9Ib0afwUeMC8jzOM1Vrxr1YvtAg2WRxMIR2KeWT9PfS9DsRDCdz0ABFJlaStScE2dXrcFYSqRgOOs7H1XvdIpAiyoMu9s4zkBnN1B0DSUfYgvWv0bHDLEeTU2oOsyU5XoqyN5Clcff2qWc5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=pt0SD14x; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="pt0SD14x"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3137c2021a0so4791019a91.3
        for <patches@lists.linux.dev>; Tue, 15 Jul 2025 14:27:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1752614847; x=1753219647; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SOELzqJhc/ryZF/a1QLEL+CHjG5U4uGeHFM65aS5DO4=;
        b=pt0SD14xgQKl6UqQrJYQ6LlM0VmEnv9RcluLWFGnY/cTvgBnFoMDet9tBS9yRFcUfn
         NGZgo7YNwimhRPipM+k+ltJV9ns+POt5gXrtuI0BCB+ovWyj50G8LjiCVvTpyB1Jq1LT
         FQ45rczwFtHEpMQ/s9HUcaPWOZX9zM5/b1F1MRF3vBsCbQU262zfdixIqPIlWQ1YL9tE
         d7siZGbNhu6j8lKuWY7KXY2hdQLpKy7aBSpAIEpQwAWzoKc7LHmlzax0XJpgO3wVOySb
         hZ50aZpfsMBjM+/r4RwQ6nUGnflgEkuSnlQJlsdGXGi/6+7erByucPQivylHBqvnDWH7
         nBcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752614847; x=1753219647;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SOELzqJhc/ryZF/a1QLEL+CHjG5U4uGeHFM65aS5DO4=;
        b=qeMKf+GChR/PZxCNEsxRoWXb9slmun7vmiD5/sGrwUARfkr1zjUEppN4j1P72xKuwM
         HmY3E/uwGH5eAYg1YOz27IOEFFG1SCbD0KzcWHFfgyjQG+p2Q0rB4uSjaCBxVEY+lEpu
         A/YZ5jP9OYkD8tj9kVd61zhMZ1s+n0U/Lwq/qc2kIuDLL+f288yg4cHT9INd74NiRIbL
         hmiVsMdrNgVtuOE9jpnkzqZ9BBR5f28AyRVTAvj039wsH5vYEMLiGE2kcsidkOY/Zz42
         8d4AQxoNpFy7VyVMqxCO3jGgguwFOO7jX98CuCjpFWQEtYPbXPbDPYk2mTsMxLHoxUbe
         kJoA==
X-Forwarded-Encrypted: i=1; AJvYcCVgwZFzDSRqbYvZfOyDQD6xM1kC4Bc83fDJXysVpurzlKg5lk6NzNSKZEDMM+c4OeMpP30mLBMK@lists.linux.dev
X-Gm-Message-State: AOJu0YzmHNsly6p30L0z/lnPdSg1klNy+O9IczjTAfjaDO93H8jPVak+
	eEvqB4/uMatgEq09m+ifo6hoISbO+3mFAo+9t7UDYgalMwjrLki7tiQ4yaTnbzrhnY+44VW7wn1
	iGUVRR0WWcAVdwjyqoDhSHEcj7qZfRqYJQzH9RJijzQ==
X-Gm-Gg: ASbGncsnB7mA61otdu8aAqANbQ6t0qmFK0Rnr/DuEWDnQqiYGV4nO+T83HL54Tl5ZpM
	d9yLFLlN75rRCmf/3t90wYkqlYkvg5NLwe8OcOTV3e+3dLoJ0U4XI52WMrrguTgrym85yEbShnm
	dM2dHBHK1rhFc7OvlPOI98tXRQEuyPbZ7iRNiPna3AEj8DL56MpdeIx8fCvL+2I4pxRZoz3dT35
	7k//U2Xuubn580pnw==
X-Google-Smtp-Source: AGHT+IHIMG5AOIEO7NWtr7b7qQXOwUwyu++a7MBGcUjFW29Fo09J23bRD+O0k/Yj4fz9s6Q9Ys+GEoOzZBuXDt2FQCs=
X-Received: by 2002:a17:90b:4fcc:b0:312:e1ec:de44 with SMTP id
 98e67ed59e1d1-31c9e77050fmr1014801a91.27.1752614846758; Tue, 15 Jul 2025
 14:27:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250715130814.854109770@linuxfoundation.org>
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 16 Jul 2025 06:27:08 +0900
X-Gm-Features: Ac12FXw_zO_5hI65OrUKo80Jj8hMmAumQxAUZ4aSIH3foYyd6ktRTVpXkyDcl4k
Message-ID: <CAKL4bV5npxPDCt6dsmJLSjVxTTnDn7GyJ05AgPF3Qh2M3NDY_A@mail.gmail.com>
Subject: Re: [PATCH 6.15 000/192] 6.15.7-rc1 review
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

On Tue, Jul 15, 2025 at 10:50=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.15.7 release.
> There are 192 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 17 Jul 2025 13:07:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.15.7-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.15.7-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.15.7-rc1rv-ge6001d5f7944
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.1.1 20250425, GNU ld (GNU
Binutils) 2.44.0) #1 SMP PREEMPT_DYNAMIC Wed Jul 16 05:56:57 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
