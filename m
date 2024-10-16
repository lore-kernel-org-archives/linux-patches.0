Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C3D1A3AB9
	for <patches@lists.linux.dev>; Wed, 16 Oct 2024 08:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729068903; cv=none; b=EB9UaKF3MjycRv2ur7yhk/8GG6IiG66hjX/kmMfzPmO9rwRl72vvKobt4kzC8/TADAcHod910j30pkx+6/lCWX/cSjHjtuLHGL121t5+WUXEV8fx2DdaTRs6WldaDkYMlwUd93miCK1kaEOWDb7KqUZigbzUWqMmrINvSicw53I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729068903; c=relaxed/simple;
	bh=0ooDMGKzrk1LRoPou2txp9yefFiEl/aBC0G6Fiy+HUE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rKKox+/B5O8GMUmWQOwrgBbT2aTDLP9FjEfMOL2mYNRluRXp2PxWEDdjnsZ/zoUZ2fyfOf4EwMXDouCnA6bPXf2DPJj65ssyFs/Td28fHs/vx5H7DSXXVXeEPlAWDQ7zo9fXW8eIPVFf3vV41f2M7hoJQHxfPCo1mFU+klM1t48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=l6t4BExz; arc=none smtp.client-ip=209.85.221.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="l6t4BExz"
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-50d4dbc316bso1068671e0c.3
        for <patches@lists.linux.dev>; Wed, 16 Oct 2024 01:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729068901; x=1729673701; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aM1j+CmDA5rs0zqyd0QFs7mI1QpTz4ZuLqOJ8HwBQeg=;
        b=l6t4BExzvxyKs4pcci0RLqMHdMwZZ0H9BUlCt9wL6D6cOxT8iIHuhja8Rueox4FLGv
         MeMM1LXz+eKVYnANJ5oc3UQmMTjV+83udl4AGY81zAigDXBnLofM/SRGsE5IHP/itIZi
         biXzVTT2MTPemhude4+aaFnWNBiA72dUgEuuL4Fcm0LFLomTZxL/Oal3XNQIXlS05GFz
         i0n3zGzUisjB+MNxiVa90wR9XIbrVha5yV7upT1RzexBVG71lKngvgJnTNrVw5jIC4vD
         18MjHH4I84KaYiDBpu504ktP5TwW280/SNQFcadkypdJNGvgVWLzyxrdojuOK+QMUL0Z
         wd1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729068901; x=1729673701;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aM1j+CmDA5rs0zqyd0QFs7mI1QpTz4ZuLqOJ8HwBQeg=;
        b=pjQTSKl4jy/ZxqzMaYFWiNOKJ18K/NQwiD9nAI+VB7f0uNNLICmBW9/Jct1zLBXx+q
         pdxWYaeps8rz5Nn9XBXxD0SobB3+Rbx5EHH5BrTA4vnJBt4dWZAIVKqI/zEllGmQ1kmj
         1yJaqm+mS41lquXYKDcocN+A8SPu2GC6+G5oQB68EjBMOfjxBq4MTZn6mxGszUlAzYXE
         BkFMFTq6FL/AExDBoWn9Dr9U1VE/JMWwVQ+S2cgERV89Sa9dndgcOH2xgURpk5AJl8H0
         3Ycnt9SG79A874Yj3ehVaGJrcZpVZWVNrEeqU++fAKX1wY7oAF8qpOlk1RoE1yIeGt56
         SFMQ==
X-Forwarded-Encrypted: i=1; AJvYcCVtaTG9LK45GLJSZmAtixwL/ylwKQZa30K6LVxc9/4oluO4eUHd6AeGj/bA4YvtzRf0E58sn6Uq@lists.linux.dev
X-Gm-Message-State: AOJu0YwXUFNX3uIy2EMU4N+xy9K0L1goUwxMG6WwETZw1oM35LCXuiT5
	wmlB2lrzC5G3hLqMDSRRPyPB5xq9d+QMc6sekkeVd5BIeJrlXyhCp/XnRrpKImkKmv8tUs/Ezus
	eno/USR5byKanr2FjLIkAh0ejkeiLOPB73OgqqQ==
X-Google-Smtp-Source: AGHT+IFj1BIMhN2y2ujDgAuHcdv2pSDskTuzb3rgrptZ7N5fVnXHbsRKomX3FKehRMuLXTjo6jvoeqyRgKvU0F7lrlI=
X-Received: by 2002:a05:6122:29ca:b0:50d:354a:19ae with SMTP id
 71dfb90a1353d-50d354a1d7dmr11686940e0c.10.1729068900898; Wed, 16 Oct 2024
 01:55:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241015112440.309539031@linuxfoundation.org>
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 16 Oct 2024 14:24:49 +0530
Message-ID: <CA+G9fYtTO8QbKEhggzOk-n+pBk5pEHenCfgs2RdQd=Ztsi+hnA@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/691] 5.15.168-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, LTP List <ltp@lists.linux.it>, Jan Stancek <jstancek@redhat.com>, 
	Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 15 Oct 2024 at 17:04, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.168 release.
> There are 691 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 17 Oct 2024 11:22:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.168-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

From last week's regressions reports,
The LTP syscalls fanotify22 test failed (broken).
This regression is noticed on linux.6.10.y [1], linux.6.11.y, linux.6.6.y and
the Linus mainline and next master branch.

Now this has started failing on two additional branches linux.5.15.y and
linux.6.1.y.

 ltp-syscalls
  - fanotify22

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Anders bisected to patch
  b1a855f8a4fd ("ext4: don't set SB_RDONLY after filesystem errors")
    [ Upstream commit d3476f3dad4ad68ae5f6b008ea6591d1520da5d8 ]

There is a fix discussed and posted in these upstream links,
  - https://lore.kernel.org/linux-ext4/20241004221556.19222-1-jack@suse.cz/
  - https://lists.linux.it/pipermail/ltp/2024-October/040433.html

The stable-rc 5.15.y (5.15.168-rc1)
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.167-692-g63cec7aeaef7/testrun/25456713/suite/ltp-syscalls/test/fanotify22/history/
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.167-692-g63cec7aeaef7/testrun/25456713/suite/ltp-syscalls/test/fanotify22/log
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.167-692-g63cec7aeaef7/testrun/25456713/suite/ltp-syscalls/test/fanotify22/details/

[1] https://lore.kernel.org/stable/CADYN=9KBXFJA1oU6KVJU66vcEej5p+6NcVYO0=SUrWW1nqJ8jQ@mail.gmail.com/

--
Linaro LKFT
https://lkft.linaro.org
