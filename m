Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E3F1B142D
	for <patches@lists.linux.dev>; Sat,  1 Nov 2025 05:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761973848; cv=none; b=d8aoefTBfxVPSZJx+p7BscBerjotMJLDLrS0yXrewiwtCitPMab4TNNEltpXrhV4+fhSKr21P6DugQScI5A1TDO1kwc05MpVVLPhYHQc+A3IoTq41Xm/Aca6nsiUAhTTEowpQSuaGg+0dI+J6/qK+HgEdjHVU3ccDTFwOlxa8uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761973848; c=relaxed/simple;
	bh=eOlM1uFeuGo4OskzqCGnrLnEeqaOGDwuYrRt8MXSqLM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gJe0dXwMImF2rp4UZAI5HTZrWFqOt5mzoyeB11+vubuQxa2dY/1CUadiuZw80W2hILu92TDNpPJazHCmEnDl+PKFEa7jK0YoDU3PV+uof/dNAG92k5x6lq8UXq0nz1UGsBupaZogOauux7Q3T2+wnuf9ceBHYTvaGkeAY1JUVo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Brh52bxZ; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Brh52bxZ"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-378ccb8f84aso32454111fa.3
        for <patches@lists.linux.dev>; Fri, 31 Oct 2025 22:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761973845; x=1762578645; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cDBf0EPKFSh2QRdvgUh08qctzAfCvCuzR3NbXNNUNTg=;
        b=Brh52bxZsHO4262ZmI5gcwv8n51PdEms7CAFr1hN6XfBahv//5AtfRcB2524N3tMaM
         NVI6+DGVHbR/TyDlLOV5/Mt+drJsBkNiGaEeI++Pr3PPqqNm6nm/8UZvGriIA83HMeF0
         5ToC+3u5FMAvcZhY7JZj7DgaLnViJwUzedJ3d45BAKk45OIrgfJR6nw5GE3HqSWo83eF
         q4jOwGxezEEF0OrxY5Wbqq2j3dH7mMPAJOro42qNeBecYYv3qTCsFYmoq/4Nv2RvyD3y
         3GP+KuDT80pM2hM/Qjh74yTJNxSjXh273fcVhzkcahPuGwRUSsdx0tjIVsS0WUtF7DVR
         uW8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761973845; x=1762578645;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cDBf0EPKFSh2QRdvgUh08qctzAfCvCuzR3NbXNNUNTg=;
        b=KiF70FsXdrV8V7xxwadoOgnWqU2lvEphJUA+O0Fp2HABhf1CDpIQgSqF71YRN2755E
         XNX1FNSXTRycYPFSrt2fJ5P+0VPY0BsaJuhXU+ScmihpXwl47IS0Ts/SwBAB916yXcFi
         +z2++bRAw6EBOfV0kTalUiukm0TNM9mOmm1CHH4c6chsz5m+0gKuKqat0n32OGtAA2rn
         pwsaV6yJf30k7chz9f/62H2qvNwYLPs4lwFczoB8uy1AWl7U8baDc5fpt+iy040jGJ6Y
         FOIyqpSXLfTW0eBVFPECrfyTo0LUSV0MO4zsp53iDWd1tUuQa8IG9HjjN6ReurTQf6Zn
         EqlQ==
X-Gm-Message-State: AOJu0Yw4vaud61xfbQOzVCwIHsJKq/mBmwiddWKM5+CVIGO3uoXilsr1
	abLzdZ4Cc4i6oku5qIcIkNuv7UvvId/zZNESvUvxthJBPKmVCJiONSrCBg8x0UDrFpJfGCfFlM8
	wTvxyXHkYziz8LFAHEQA3VVw5E3/g3kw=
X-Gm-Gg: ASbGncuZuKX+Xg07LTFCZ/IstvfNKQR5vxa1yMTJOYNucqrfjB4emcXE8O7t9MmmjDe
	Ti2Ru4BxSUqXQnZm+UKXoJVQoP0lM/plUImPvzRLk90rishJ2uOR/8FLNqhdB0lk6Jhq8OOOgQO
	NDa8oBYH2nFnmHcHZ8hONHdeDCikMcIYu86rZoLGT5SU3fBiDK5RFDvGJvqqiorJ0nrAes73a8a
	f7kjOJ+XLrVOwhLcNah9EHbnRUttEMqpKGX3ZS9o9rrjV93kIPp5+PbFn5p9Qw4IaG6Hq+I60O8
	un7K5zAK5qp8ADm/LA==
X-Google-Smtp-Source: AGHT+IEgcVh16NBSlAcq0VebB5Gm+0g5P4XcZHFf7Hd8YhrkSByvbyzY03uBh9X6qmIXljQ+9mmdAKbfTpWuA4Lurqw=
X-Received: by 2002:a05:651c:2049:b0:376:4320:e33b with SMTP id
 38308e7fff4ca-37a18dee5f8mr15061341fa.47.1761973844866; Fri, 31 Oct 2025
 22:10:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251031140043.939381518@linuxfoundation.org> <19689e2c-5dd1-4c3f-a243-84b69a552f91@googlemail.com>
In-Reply-To: <19689e2c-5dd1-4c3f-a243-84b69a552f91@googlemail.com>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Sat, 1 Nov 2025 10:40:32 +0530
X-Gm-Features: AWmQ_bl-6-f_3Ztgk64RenjMy1dM7NuNxp6tpcUL91fjp2wWmf8Gqa3cmQnHIAQ
Message-ID: <CAC-m1rqVAbQ4HUQibgheOZ6HJf57wmC-MAApAyuuQ63oeDGRHw@mail.gmail.com>
Subject: Re: [PATCH 6.12 00/40] 6.12.57-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org, 
	sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 31, 2025 at 10:04=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.57 release.
> There are 40 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 02 Nov 2025 14:00:34 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.57-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Build and Boot Report for 6.12.57-rc1

The kernel version 6.12.57-rc1 was built and boot-tested using qemu-x86_64
and qemu-arm64 with the default configuration (defconfig). The build and bo=
ot
processes completed successfully, and the kernel operated as expected
in the virtualized environments without any issues.

Build Details :
Builds : arm64, x86_64
Kernel Version: 6.12.57-rc1
Configuration : defconfig
Source: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git
Commit : c3010c2f692bb27dc44fd2318888446944f5846e

Tested-by: Dileep Malepu <dileep.debian@gmail.com>

Best regards,
Dileep Malepu
