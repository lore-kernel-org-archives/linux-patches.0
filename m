Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A1C381CA
	for <patches@lists.linux.dev>; Tue,  9 Jan 2024 11:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="v2bIvD1X"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6d9bec20980so1322855b3a.2
        for <patches@lists.linux.dev>; Tue, 09 Jan 2024 03:44:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1704800685; x=1705405485; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MmMVd1TV42cNBbNsQpvbQcAK09XwSn0dXhlKzPYJ5go=;
        b=v2bIvD1XHCMLTeKKBRmaQYb9xmfMqo3Tz9ehzkFrKTz3n6Vpk8Bx836yEJSx115Xru
         WYjTTYr7nLipkgaKnhjxwIqzVi1tHTLr6hp5ZVujgddnkVvxZHHy2iMrQjWVRhDtjYAL
         2zpoEOB+8/OSIg5O1HS2XA5/R8hvQlTd6sSosqDSqnijiHBJ5bt26ag2yo5SG20Dr5Vi
         C0TWDK6QBBJlfZyHDFIjMA1sTwhZA+JWcE1MC1hK21rOYl3wKK4MSplFzKGUe5O7vnNN
         BiQgTVagnp7QCEcZeRh3/dxYWbQpfhPyL7sx2/hdHnNIYjhifTWBAh+mWyCp3cia6fUM
         AB8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704800685; x=1705405485;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MmMVd1TV42cNBbNsQpvbQcAK09XwSn0dXhlKzPYJ5go=;
        b=QAjEuHslFJ8K43bEsawkiEDh5U7pStM9Y4FZ6U4DT5YBgkjISbOhjTD/l/3f2Jx/I3
         rZdbbpnAxbEAEDyjRj1WV1HpYwPl1c1mRaUJQIleuytmZM6EuAzw56550GJmkyCI5FqU
         ZftIDlFsXDsV9+HESV24xe4BgKHENNKo2Wpbzq365hyYXGAe5ki+T/4yo0fluL02gM6I
         dLVLgtRGxhW1Ic8tOpMp7Cwn5g1to7U1ln4+cscf2ebA/E1D0AK+6HTvVlD1UiwtWYcT
         tZFAq0yLCSMc4+UX92RkiOQSyDV+RBjmCRlrteorE4ueU99D97ukM55nDSgbmoHS/wkb
         pyLA==
X-Gm-Message-State: AOJu0YxCjgVdP+twj+dsBQYom9cGjqBbLMruQP07wF6k+FGLsys6u6vv
	cxvASZWX5AH6RqdqMQ3QEqhFuU4wgdanPdY80LtX8bB1vd+JOg==
X-Google-Smtp-Source: AGHT+IEffszrpF2En1bJ6gOLICjjdZv5fF0QiPLTJXtNn64pKENunyOV3TEqn3cbA7su8Hb83EZyT4bnQY0XDAkpuNA=
X-Received: by 2002:a05:6a21:18c:b0:199:b7a0:ffa9 with SMTP id
 le12-20020a056a21018c00b00199b7a0ffa9mr1974546pzb.24.1704800685554; Tue, 09
 Jan 2024 03:44:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240108150602.976232871@linuxfoundation.org>
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 9 Jan 2024 20:44:34 +0900
Message-ID: <CAKL4bV4Ks5210x8WvbiE=o1FzJSMGJ8eNPA_StkMAMm4dy4XeA@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/124] 6.6.11-rc1 review
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

On Tue, Jan 9, 2024 at 12:10=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.11 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 10 Jan 2024 15:05:35 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.11-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.6.11-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.11-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 13.2.1 20230801, GNU ld (GNU
Binutils) 2.41.0) #1 SMP PREEMPT_DYNAMIC Tue Jan  9 18:32:00 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
