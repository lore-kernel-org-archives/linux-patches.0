Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E849E42077
	for <patches@lists.linux.dev>; Sat, 28 Sep 2024 15:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727537951; cv=none; b=Sb0bQLicz+KUgw9P7JgEDH24S2Uu8vaXR4zNf8133V1jT76HETshcuIaSj0rUPjxn2QwL2Z6BU6o1kHzyz1dNJVApa7xsmCKUIyr/93SXdfPcTGA5YIjkJTDbTvU61ExnKwI8Hfr4Ze4u7BdJfNLY0tacugyNlRI9tb0587ppmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727537951; c=relaxed/simple;
	bh=Jcwgqmrk7hrevC2k2xJQkkfVs640nD7arnhpY4rl8lE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aJD+L8Q0dFmoPtB9Jb8AkdtTuBevtrZzpcbOyqtNCdr31H5aKJJ1L3Yntc+Ed6oglGNBj6v0HoaTNcsfR1VlmY5utheEjl3y2Kc79uP3iPV7m9wFLx1fEgImPIiRkt92/yUmIXCXuOLkbS2+MqRo0S+FUKqUzxhHSZB7u0KRUkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=D5bnkDVh; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="D5bnkDVh"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-37cd6ece97cso1136932f8f.1
        for <patches@lists.linux.dev>; Sat, 28 Sep 2024 08:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1727537948; x=1728142748; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H7aENbVHrbvubesI/cqKrU4sOUEl+g1GzFRVwX3oKYw=;
        b=D5bnkDVhHyMH7ZbeiqIDZsGD98nFKk5xOmLgblfDeZAk+UQC7LltxjDusmFEAMFWhg
         zj8opTku35Dt/qKllwY9iqtpljH4PGm+Sl2AKqEj/I4f6qeGOL+AePBONTMmKABCqEuk
         vAsn+KdUnucVQJEU5DKTZ3z0gZaz21m0aWLCsLvQADRKaReV1/mhiEqfbUHfjiPiziBs
         CiDrhFAHN/oJ2aibICwe6EfG80wGymLkbw2SB/saMc20LLHEhE7rTTIALL+ueZfkbNAx
         mrTgmOC74qkolVL0kMYA4zi0zFR1vdAo3cZ/LrulaL6t2xfSAVe19VT5hoqj6OerFjTo
         p5yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727537948; x=1728142748;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H7aENbVHrbvubesI/cqKrU4sOUEl+g1GzFRVwX3oKYw=;
        b=B7fk+h+e3Zj/ucsHQa9gXS3GXItUiEtaon796rVLL5ckEg0m+z4aRBknQVsxpHyuSP
         HcGr+9rzgUh9Vww4L45hE3O3qu3OoCMMG2BiLyzQPDnQG3g4p1xrYsAwPwck2QiGCDLJ
         5k6WEjsiBdoyNkh9GGA3xiEt4vBxNo07jnCO23NHalvPBi6Q4IVs9B9YeMit2uhUwOD8
         6V5lrA6L9AGv4pkAj2j022kUWWta+O2IfffIkjdm8Y/ncHSYA8QMfMBTvVXVVPlzFs+I
         hgZGwNumJHpSpq+x88zXHuJlVeIp2U6O/NOqUO6+/Ryi106/+AECB/K0Gc/vDovXON2Q
         sXlw==
X-Forwarded-Encrypted: i=1; AJvYcCUce6JkpHHnYy2HVx7Xdzx8x4Ltx8bNrmgaDUdrVIApTqttD5yYfThb2GalLVMXmn/+L2xa9Js8@lists.linux.dev
X-Gm-Message-State: AOJu0YwvSPUdudMPC2tQt85npGAx1aco3B6SPZuCzyL9Y9/1Sx0xEor5
	rhS+Za6wJQUtRbURW1SXYTz9yO7EgPoXvQUiOLcDUhItyaIPtnbpabmDYWQtU+glW/2LpMd7PiU
	LkLh4P8VKzZ+eRi7Zza9zKEyPnId4+WFozgIgBg==
X-Google-Smtp-Source: AGHT+IENz0+ya7bPS4gQ8rnB5EDXaQ9xmNq2ebP8DILfBv1Tj1+FcWPvQW6UPkGkD9Bi3+cHYW6jTXQv0SY+blo+hDQ=
X-Received: by 2002:a5d:6741:0:b0:378:e8a9:98c5 with SMTP id
 ffacd0b85a97d-37cd5aaa6d4mr4083932f8f.34.1727537948113; Sat, 28 Sep 2024
 08:39:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240927121719.714627278@linuxfoundation.org>
In-Reply-To: <20240927121719.714627278@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Sun, 29 Sep 2024 00:38:57 +0900
Message-ID: <CAKL4bV6czyU05L2eUMmaE+s_fY_hX8nN6Tim7m4Fgvs2oDXZqQ@mail.gmail.com>
Subject: Re: [PATCH 6.6 00/54] 6.6.53-rc1 review
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

On Fri, Sep 27, 2024 at 9:24=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.53 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 29 Sep 2024 12:17:00 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.53-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.6.53-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.53-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.2.1 20240910, GNU ld (GNU
Binutils) 2.43.0) #1 SMP PREEMPT_DYNAMIC Sat Sep 28 23:37:43 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
