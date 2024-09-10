Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C4418C928
	for <patches@lists.linux.dev>; Tue, 10 Sep 2024 14:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725978942; cv=none; b=IfmDCwtF8OWi1W7/QblRCmUNKDGnqfFXnVX56kPTrIs29GfEILwn1R4D7v8w1e8cia73V1v3Qxqr/CmzZPR/y+bg068k8cf5c509hCwAtHHPfUjM5RqtsCR1NvKmT2g/GipXCA6fUd2ForBis7qn/09nnIwPeNE5oGxxHW3C2wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725978942; c=relaxed/simple;
	bh=7RCDHK+BTLtJJc3M9GwORWj8tI6RSH+IGiIxcm0cxME=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PyLzG2LsWEuyffab+ZR9Ch+3vMYsi/INDRZDJyN+h1qYN4HfgXK4TAWA01jUDfnXLLOUGVlpru3o1j5gkgPFT9wo4FFBhG1pzrWYX1RvCzP5lPElS1qk0n/XzJz34RaJUvF/pU9ZsbCwDdQbYtgkEUx2hOCac/qZQdcfn3jBWUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BSAhE568; arc=none smtp.client-ip=209.85.217.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BSAhE568"
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-49bbed1dad5so229729137.3
        for <patches@lists.linux.dev>; Tue, 10 Sep 2024 07:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1725978939; x=1726583739; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WifKBD4WaotF8X+UtX2lfxD1eqAgMkavmDZNd0guNfs=;
        b=BSAhE568Qs28F/UI63Ox8whBLTg5E6DECChm/RT6bbxCH+cW0vSOHT40aivH/p20je
         JGRiuyWE+N5S9urSY6MzaThXuh8KTbkCqk4eEKop3JY7V2pewbVqXkVgPN5QWvoSX1w3
         tPIt4pU01hvT0qqVNtIoJbr9r0s6LFJ31LdwDEZVji+qPcani2h6dlKr/Z4UBgh+3VRe
         kqazOPnEB1DTDxCBd1UD+kFmgubwUz/fF5koHlj0oNHbdWbA799kRwpnvJcBlaAZiZUS
         tSuTJ1J0uVLqz0Fj9xhCznct1udSa4YGj/0higm97gO2mA98Z4bge9PLZnTGknFV7u0e
         WxuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725978939; x=1726583739;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WifKBD4WaotF8X+UtX2lfxD1eqAgMkavmDZNd0guNfs=;
        b=iDK2+d3aTBGa0r1CER+iYib0qxvHG+OcZc7/MapHNjKo3Dxt0Q9/r8ePaSeNGLTPev
         OV1qRvxrXm/l5K6O86o1fXaHSmRkdnWbu2WBMOBvU9TGkg4Op+I4CrAzISqgQnDCp1J1
         H2OdLcwjGPkAhl2f2CQvHA0Zg3xcP+hXZjLouEd4+c1a3wHI9xzrGLH+Yzrxf4A5jbiy
         uSYlEb8gfkTCqXPZhnS3K3NgEcDjYgLLSSfvKpkxEdY83hBQSTE3NP4HoYMWir38fnZi
         qvciEMkPafzJyeT3j+1rlAcj7Jbf9Rn4GdepW1cV/lks4mhnBxdyrJ9IXjLNWvzKXf1k
         zyrQ==
X-Forwarded-Encrypted: i=1; AJvYcCVfj96prtB5ZZGMjbTVXHxQN6Ebdal5unrsUj4nR1qgEUxKX3kkW2OokTV5Y00loEbph++RwzA5@lists.linux.dev
X-Gm-Message-State: AOJu0YwmeDUJG7Ax5XBNXgHbdEF0f6kxhS8IEYg2J/+Sp0hxgv1jw439
	EdyL8YKXPEHJXciQQO+u8QjhtiIyyYJ0dzWJKViOZff4yO9DTNKKbIp2WnEnZ05KpGpTjh5u3jC
	JuIY11YVvHeeXjYCPYNrqlPZd9XVUOkhKRHz07w==
X-Google-Smtp-Source: AGHT+IG56IxeJxMzo//8/ECLyeSetMnxmdoCauE97u7O2Z/LJKU+8CVElNiOE3Mdlcu/xMKPnyg4APMxgLv49j/w4BI=
X-Received: by 2002:a05:6122:791:b0:4f5:3048:ee20 with SMTP id
 71dfb90a1353d-502be8cecb7mr8674939e0c.5.1725978938569; Tue, 10 Sep 2024
 07:35:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240910092557.876094467@linuxfoundation.org> <CA+G9fYufdd0MGMO1NbXgJwN1+wPHB24_Nrok9TMX=fYKXaxXLA@mail.gmail.com>
In-Reply-To: <CA+G9fYufdd0MGMO1NbXgJwN1+wPHB24_Nrok9TMX=fYKXaxXLA@mail.gmail.com>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 10 Sep 2024 20:05:27 +0530
Message-ID: <CA+G9fYv1yHoL9r7PkunHPNyPznLxfB9spSFbWvoFBBSwOYrT3g@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/192] 6.1.110-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, Linux-sh list <linux-sh@vger.kernel.org>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Yoshinori Sato <ysato@users.sourceforge.jp>, 
	Peter Zijlstra <peterz@infradead.org>, Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 10 Sept 2024 at 18:24, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> On Tue, 10 Sept 2024 at 15:36, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.1.110 release.
> > There are 192 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 12 Sep 2024 09:25:22 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.110-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
>
> The SuperH defconfig builds failed due to following build warnings / errors
> on the stable-rc linux-6.1.y.
>
> * SuperH, build
>   - gcc-8-defconfig
>   - gcc-11-shx3_defconfig
>   - gcc-11-defconfig
>   - gcc-8-shx3_defconfig
>
> Build log:
> --------
> In file included from  include/linux/mm.h:29,
>                  from  arch/sh/kernel/asm-offsets.c:14:
>  include/linux/pgtable.h: In function 'pmdp_get_lockless':
>  include/linux/pgtable.h:379:20: error: 'pmd_t' has no member named 'pmd_low'
>   379 |                 pmd.pmd_low = pmdp->pmd_low;
>       |                    ^
>  include/linux/pgtable.h:379:35: error: 'pmd_t' has no member named 'pmd_low'
>   379 |                 pmd.pmd_low = pmdp->pmd_low;
>       |                                   ^~
>

Anders bisected this down to,
# first bad commit:
  [4f5373c50a1177e2a195f0ef6a6e5b7f64bf8b6c]
  mm: Fix pmd_read_atomic()
    [ Upstream commit 024d232ae4fcd7a7ce8ea239607d6c1246d7adc8 ]

  AFAICT there's no reason to do anything different than what we do for
  PTEs. Make it so (also affects SH)

--
Linaro LKFT
https://lkft.linaro.org
