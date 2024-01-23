Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6207FBDC
	for <patches@lists.linux.dev>; Tue, 23 Jan 2024 17:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706030733; cv=none; b=snMJtk4nfsGNpqK9vX2PwQyRKqbNdujqNpO4hkFjpVwz54LNgk84fmzqHaD0zmp4oGVA5ICMQfwBTydd7CivKUuOn+82jFZXOL7BjQKpIGEdcc1Y6BuF4e841Y65IaXg2Pfmy6i1pSUYDhWhNb+ce3S7g2X1akzD7U2aArTIHKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706030733; c=relaxed/simple;
	bh=DN4WENUc4MsSSYl06gk8TP+YIxrGOlef2AHZVAyLDnU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ozXEsJ5M/Iw3EZYCI3Rpl1W1pcRYFoB9e0okYs5JAU+IgW+CAv17lEYU6rA8rZCizH8ZKr1sITatl/unOIihndwFJYCA9y/4F3N8JcfMRqmDO48EtLlgw4qxSNj1wyEl004J6NEDMXWPsNNrNS/kHZLXvGZWkiEj3Faa9A/gpj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y+yIz8nP; arc=none smtp.client-ip=209.85.222.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y+yIz8nP"
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-7d2defd7df5so593587241.3
        for <patches@lists.linux.dev>; Tue, 23 Jan 2024 09:25:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706030730; x=1706635530; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=U/HCJ5AzaWgbdtZfIl+oZilfRmZKIIXAk9H/FfZ0fUY=;
        b=Y+yIz8nPujtQa6xtzGYAVRmnKE1cqa8bY0MZu77tp+aY6mlKiyqIHGGDvDH8dw5NBp
         0MlRfnG/ljpxUlKKNlVNDtt8IUSpYxKnpWgfnsad7KcoBiQ6kovzjts6P+HS3Si15sjA
         X6Qe+OJxevxvjKO9AzJ45AFv564JADdMY15uGgasQqePfD9bJTcDP8QsZoro4HnsEhQl
         5/4PJ60alu4/Io+wHW0a+ZKiWv5I5/trI+cBqIdac4aVKLlFflj4I7b7oMoZBhFLwfjW
         AUVSxQA8gi8jYtAmwnIhIpWV7INh76vag1JFA8lsK4TCu33kGYwXWRloqovTYsxHez+c
         MFuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706030730; x=1706635530;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U/HCJ5AzaWgbdtZfIl+oZilfRmZKIIXAk9H/FfZ0fUY=;
        b=AGSyL499ahgMLLzWi9QF/7SGol3OfAhhS+6KnVtwVuCs3Bu71pjogdo/aysWVtS5vA
         zkbockzR3tX9CW8dej/JZATdcjdR/YJd5nSOO/v+zMO4s9/bWjEcomj1sHdg54aTLeHs
         med2ygAnYkOzRvfIg8ISdsD3I8A5/+2vMj/VPIILxWXYfqfrkyHXF3Iho96mImBTyXv9
         UmbsyZm3NvdNIjsUGjaAjVqDLq7twk3yTWkQs/MuaV6J1JvrL3MWGepb+Ye2ppcBzrqt
         amXYKbx+JZZTYZqKCF2hogNUJiABYos2RkAS7qP6TZn89fBy62e6Lw0+aLVeEmN9gkCq
         OAJA==
X-Gm-Message-State: AOJu0Yzpxt8WXCeoyj1FWnsYYxseZ0GKQE77iH5r3YO/S23XtSd5/jUh
	S03/SY5KBjKefHK0zhOf+8Ko8DgaLUC8MT1O3chzAXpbN9F1W57lnVI0mGumCdqsmLY6661V5zo
	qa2ixPhoNCamTXlsQnTVf/6qRc0w=
X-Google-Smtp-Source: AGHT+IGH0ByYIyMyTwM+KJ/xVrRcWkiXemQa0A3WurIOXLLE10kZajdVmAftNg4oXG1iwLNr64w0B7acqvvmNdaFBqc=
X-Received: by 2002:ac5:c939:0:b0:4b7:4136:f0d2 with SMTP id
 u25-20020ac5c939000000b004b74136f0d2mr2664009vkl.29.1706030730508; Tue, 23
 Jan 2024 09:25:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240122235818.091081209@linuxfoundation.org>
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Tue, 23 Jan 2024 09:25:19 -0800
Message-ID: <CAOMdWSLnk9YmdsPX69jL7XrWOsbx+Ua75Z8P8E2x8+Pxsgte3Q@mail.gmail.com>
Subject: Re: [PATCH 6.7 000/641] 6.7.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.7.2 release.
> There are 641 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 24 Jan 2024 23:56:49 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.7.2-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.7.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
