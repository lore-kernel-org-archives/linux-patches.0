Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B6185C74
	for <patches@lists.linux.dev>; Tue,  9 Apr 2024 11:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712661581; cv=none; b=BazQOKnBCIgf+ZEtxYkmNFvYoHHE2WAwtkLHwNLe2W+k0Ks6ezzUGAGduX+YGHcQQal2WuXFej63DpRGEBfMC99YnjsDYP/O3tdz/+WcBO2yJQCVtLcxxR2Qg1rx5Z/dxY0XbzwgJXCUcAAp2E8luoJWqHrshI3XTs/ZYoNVOPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712661581; c=relaxed/simple;
	bh=T2ZN1fcFBKzVjK4bQW41mMKN3tCyZQojwExRN2pmPi0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VKFsU8jV3q48VD9nLCiH+9vIERIlxEzHI+u0kGtQJkAb9kqXInlCU8fre5CLWElSMXJe5HqwoaXTu3lsSpR59rmz+dCfTbYNcq66IPmaEub6lO4jOi+g4EHnBnFiyV+jfvHNmat4xcaLYidP3QL3T3BuAb32oVBy84FX8IME9GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=kmVDqHUJ; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="kmVDqHUJ"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6ed0938cd1dso3368136b3a.2
        for <patches@lists.linux.dev>; Tue, 09 Apr 2024 04:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1712661578; x=1713266378; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oKGPr03TnWQbKb2+d6UQO6L19uRixEs4WkWvOdztkEU=;
        b=kmVDqHUJmJ/f+ntQpPwXlHf6Z8bo8WuMw3AXY4B8FdCqeWI1Gm2G2vw6Ly7PPjTDza
         GbcgMTwu8YTSAKrabrL2zLJGY1gzvQ4ZjUYwiloC3TqjogifUKiyPDNFBNsEfoIUkOgs
         RGXSDmi2sYieiW2jNIslmbDuyX0Q9HiTS2sm9ISWqjE6+3OXoG9CwB35MW3qgY3xrTqI
         uBHfp/kfwMlrUcjycgYD5h0gG5cxGQsjUOdCYogHUaga9xaLBCKSfrz9U13moyhbJAsC
         pRUD/crYfZSRGpJu3/32YMBa1R9BwS3kaZOaKayQ/zonMcPJ0HXnPzNMLLauZ2g8Qzrc
         U0ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712661578; x=1713266378;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oKGPr03TnWQbKb2+d6UQO6L19uRixEs4WkWvOdztkEU=;
        b=FWqxwntndiXOm2moyDEc1zrhb71i7Uk69/wwhT5tPANbJO9ER+NZq6fkg/JeopLACF
         C3tiH7HxrjHrli+T8p/jCaQg28gBqsi46p3KnBBv8OC/ODDBVT9LdIU0Y/n2FKccH8zH
         BrJ3In+jF7fz6AvgYlmBB0HPC8oFSfVpEmQA+6IVPWAuo/bNcxOXa2Ujfk7NjZGCnWJa
         bZCt1bimf7F8ywN43xOaBFuPV0HdLsqrv4qrFiVjyrSL+tsbm11SBEHuKevuGZAsuWmK
         axl4xHc/u0PpuplPZxRqeenPu+dPmlyjSWn9VeqG0oKda6Bz8qjCHyJdyAclCSLrduAU
         GHKg==
X-Forwarded-Encrypted: i=1; AJvYcCUiAshVdDIKalVd1E+N9xL5OpGrpn0eZvyseZiuWYnvYHx69rSHKY9oChQYJqQEgHWgeXMynPh9MSz6yxh/BLBthoGrnYAUrw==
X-Gm-Message-State: AOJu0YyUy1I8FVTTCdL78EvP7mOJG132m2QB8m6Id8ZBpfEHKQvW7kU3
	UA3LgEhLZyv/VT5k1suDDPgZGxm2751MwwYT15jdyZXUmdduzy09ziX1ERb7wwoW4+2PgsoDYwd
	3PapevfE+qIAYmxJ6E8QSv7AUBmFIT+U9d/U1ow==
X-Google-Smtp-Source: AGHT+IFYVza6STxF9UXGu/0jGiQJfaimoc1s/2/nhDZ7qqm817g4DPhfwqBgbtR8wIeNhe4Qttdd+G+PzX658TMBJUo=
X-Received: by 2002:a05:6a20:da95:b0:1a7:a86a:113a with SMTP id
 iy21-20020a056a20da9500b001a7a86a113amr1813290pzb.6.1712661577550; Tue, 09
 Apr 2024 04:19:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240408125306.643546457@linuxfoundation.org>
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 9 Apr 2024 20:19:26 +0900
Message-ID: <CAKL4bV6ANTv+DwtQAjQYFW+9d4Ur_yk_xdm_PQ2HQiZW+vbjdg@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/252] 6.6.26-rc1 review
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

On Mon, Apr 8, 2024 at 10:00=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.26 release.
> There are 252 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 10 Apr 2024 12:52:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.26-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.6.26-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.26-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 13.2.1 20230801, GNU ld (GNU
Binutils) 2.42.0) #1 SMP PREEMPT_DYNAMIC Tue Apr  9 18:54:11 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
