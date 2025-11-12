Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76E32D97AF
	for <patches@lists.linux.dev>; Wed, 12 Nov 2025 17:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762969715; cv=none; b=khrFp1fcLCFmG7YsAQDOx+0Eim6pVtUHQAEun1EICIyX/Vhw5VJUKaRfV3CuiUBtG8c3sGs5lkFDf9RoJImh1+3zuiz7mkuLVzoSNpUE8yjyxrcsfJ0VHlSIMvOkkD0dCRQRflIEzQduVqOMrTSkI/oAhnAjsR3xdEUZXpwmT8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762969715; c=relaxed/simple;
	bh=alg3GZVbOGWLPqlw23mtYgLHmyaW7rHaNGquInyV+is=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WadeQv+ntzzacayOwvYRxp0iDXGclPB9DW5t5IoKLB3UTBlYSJJVWXo/bzo1qTnapQLAkLHUUGhxjXPtO3FNdFfc4bxeqYRk4QPFDHm+xaOXk3Vsop4AR7p4HmC80dOVt4AcWXHklxhW8aIyh5uX4o1Iu6/D9+HOypxTdOTtd1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ea9bMovU; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ea9bMovU"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-378e8d10494so16808961fa.2
        for <patches@lists.linux.dev>; Wed, 12 Nov 2025 09:48:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762969712; x=1763574512; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7RtNiaEUI+oSnsJyG/c+SNYFc+FQ7s2DIR24yvY/faE=;
        b=Ea9bMovUztp0dtSbKwPR8NC/UVzVlMCNt3h8kMzHQC+gXDKs+nuoDzpaTlpMQmKqXC
         5WSYbFbpF08vCxCD98Lq3xLbIvDVcDJJF4tZ8GjpztPLX+PdIxiOFn9AVzYINAsKd+o9
         7S77+FsyiGIIs3zYaXwsBAW5ZrW0yzIyLOGe04s//dKGCIm75Sm+a7GQ4M5ODiPinETf
         yFE/6lEuxaKWzz1SEyWGbi8jkAg8GG2URQ4qD4lKnWF1trXDgFdNMY73pxwnldKbitYc
         DNc610Vv556QbMeLlWy8HtEAUSw7ctK9jyYACH+ha+pVGcwAjrVJq+7iIW8XxaQiLJ6l
         H30g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762969712; x=1763574512;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7RtNiaEUI+oSnsJyG/c+SNYFc+FQ7s2DIR24yvY/faE=;
        b=FiuSxYl/HUI8+uNpBTt5xBtIo11g/3e8UYHZlqwNRjORmsm0Y44tPGdW82H+slyn+8
         cemyW4DXWOx71jLGvhvWlU8OCs1rPwBBfMqRO9ftIl9K7eCA/zDDvSoksTlis7jRKsjW
         TKdBK/ZtAlSkq72l6FcNvwLJMSNPdp3yjvjujZCK5fv+in5a7Kvd7AKdCxMuiX/zFw93
         V8JOKP8NaMAvI22B47EGq6T+f9FnAC2IclWzWlE8WVDcX9RYVj67NcSR+XPCyMzZk9fH
         U7WSrciuP+8sTkuxrQzjcna+2QHisu+sBou5AUNQkHnG41sptrvj4CKt7zLUnhdlsOI8
         UYTg==
X-Forwarded-Encrypted: i=1; AJvYcCVMmha3H3jfRgwrh5jtfXMG+ZyMKjVPk/Y+AjyxJbaSVi/UTkrwl6j5W5D1/5kgvBu9mX6wH8O6@lists.linux.dev
X-Gm-Message-State: AOJu0YzR+ggCw5D5vuaz8/CYMikMyhlip2IC7Ix3frPF3hgRLxUJFFrc
	R3GjHkM7re79bsU0GlZtoj6lq2mgke2ek6wyFvEKJViymNtrX5+7aY8tEyp0Qof1212IhVfJ5+T
	AqhhIbWyf4TzTbNosYV+GhSM0Lq0xugE=
X-Gm-Gg: ASbGnctX1xBl/uErOdrk5irx4BMkZJxl5adhbK3z4l06ET6ZLDtJX2ElDATEC2HT36/
	powIu351X/B28Btzs3lKUEeo/du8S7tIeTRZqhHgu3WmOykuT8DXN1GKcViRM1pJl+54r6djuyt
	ruBpXByn8ZBZrlOTTEVqiWU6QTJU1VgDZZS1mdigMMpSFMoTKyXzdqKbfUwnsPPSSY/8rjxxIMb
	NVxSjn19IsUm2/dRbALmWTrmUrwAR65nDzNnc5Gw1j2WLB3qLu0he44tlhSQzcD6Ql6YjE=
X-Google-Smtp-Source: AGHT+IFUSyjuKhia9bnSd3m+2XKy8hJzcQ9DOE86De5ut0/zfw/syHIlc0LrALyxrMp9Xpe7aEiZMUHElmGsUj1/cvA=
X-Received: by 2002:a05:6512:12c8:b0:592:fa8a:810d with SMTP id
 2adb3069b0e04-59576e0c293mr1351088e87.16.1762969711505; Wed, 12 Nov 2025
 09:48:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251111004536.460310036@linuxfoundation.org>
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Wed, 12 Nov 2025 23:18:19 +0530
X-Gm-Features: AWmQ_bnluPVMUosVyxKqvHFL5eHej5lPP_cCQ5Wjldeq2Z-RlGs2I1Xcdqu8o74
Message-ID: <CAC-m1roJfjSk8iTSGNSE=fELNaUORwFmMS6YpwL6B=Ub=DWHnQ@mail.gmail.com>
Subject: Re: [PATCH 6.17 000/849] 6.17.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hiii greg,

On Tue, Nov 11, 2025 at 6:18=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.17.8 release.
> There are 849 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 13 Nov 2025 00:43:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.17.8-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k
>

Build and Boot Report for 6.17.8

The kernel version 6.17.8-rc1 was built and boot-tested using qemu-x86_64
and qemu-arm64 with the default configuration (defconfig). The build and bo=
ot
processes completed successfully, and the kernel operated as expected
in the virtualized environments without any issues.

Build Details :
Builds : arm64, x86_64
Kernel Version: 6.17.8-rc1
Configuration : defconfig
Source: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git
Commit : a0476dc10cb160082a35b307f8dbfe4a066d41ec

Tested-by: Dileep Malepu <dileep.debian@gmail.com>

Best regards,
Dileep Malepu
