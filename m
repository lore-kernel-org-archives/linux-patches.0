Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com [209.85.222.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1B41C6B5
	for <patches@lists.linux.dev>; Sat, 28 Sep 2024 15:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727536001; cv=none; b=OJ0LWdi0V/ZlQL1Pun3WesQkAnt8yeFD2qTnPN6oBlFTYObtu7Uo1G8/LvYOyF9zfGZ+ZaRG23lf/TV2eFIlabImvgN7035I6K5kJqoM1tQ+MKA/A1lil+XzKfhqIeD8KsQEqLjcaHbQpVYNE7fhknOD2G7NTm7bJndlBcwHUgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727536001; c=relaxed/simple;
	bh=X7PdJX4K9/BBDN8TWCr9zBTBGVYJeM+Oicw1FAwRG7Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UzTdf4o6bm0tdWyUHXm1tIFo7QmTkC+DR610row8Sz6GGJickfz9MfV24gQoU/RbDUiBDdz8Pe3Qr7WjIjKHxygwGyTHXnxCrMU2r+ExlAmV+PffThBPDwuWFIFpcadIAU2XRPGnqnPL3fvI93JUBk/6/Ii/LeCgE8/3Il4FbqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K94etKqm; arc=none smtp.client-ip=209.85.222.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K94etKqm"
Received: by mail-ua1-f43.google.com with SMTP id a1e0cc1a2514c-84ea1516673so838755241.3
        for <patches@lists.linux.dev>; Sat, 28 Sep 2024 08:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727535999; x=1728140799; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5/+JOHh40L6mwhVe3jkLJF3MLF+SyUORnDZxN+djnuA=;
        b=K94etKqmwCpylaOrwKPs2/PBx9i49s6z23MHR6XyUbbQZKMelx6utqIgfToY34DDvX
         t4cRPEgKWeeuk/rFQFJGh75ZknqB/GkijQ1fTSVc4sTiiVSyS5lhFwdYn6Kr9ihZNOV7
         +MibucxQf1Jor/utaj49D2Fh2WRzgvsZksq8RztEEZ/TVtxWQqR4Kyp+6ecOTLDcaIhi
         kontEWSToO20YkqKR5vyyPDEkZ9FWwGnK1gCau8oGQNOkAJR9XaMn6cWMixbqtpsZr1d
         pUc2E74IS6A61pNq8yAoaPu0k84L/W3Dceq5b+T/WXUbrl5LIkOJv9/jwAFveh17wLB1
         InjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727535999; x=1728140799;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5/+JOHh40L6mwhVe3jkLJF3MLF+SyUORnDZxN+djnuA=;
        b=QsmLmqrH8sTa27UxuXmtAQRgUdgjUBpvMzFfJ5iJskwu3dhR4gY+qH8eeY/UK68TEe
         mhpKoJ2HyFDpVcrJTChfhC9ZIoWjZS6XsYlhfxbdKQUVtKEnVJKKFdxcPCSkmiCPfDIG
         E2XKqJEaC+5NivhYVUbanx53mAFUipsbYeCSUxxYGZaCTBGtrXMItIpBbOwxFBiH4LWC
         Q4onoTPtBcDQsbnrlYNenEd3uOPhR9SdSxRddHG/le87Ss7HOfbPd+jpPI/FdukzmQdN
         B9gRLP8gtf4phUn8AHu738E40grH/4fMgHUzf4pIm+jKUncOQNl8zmHSlE0Ws6O9niYX
         f6KA==
X-Forwarded-Encrypted: i=1; AJvYcCUtQxeknjsqDBkaOc4Lit9NqNrbXa6J//gunSGPpA/LWcev75uYCM50wFqaQLk+9TbTv8pfMBtP@lists.linux.dev
X-Gm-Message-State: AOJu0YwKLxmkZemsJ/mPSHFLyCFSq36NsLb9DVKf6PPGOeIB4XMGzUG7
	ZHW89JkF0khEfHzd55JAdKlS0HvxbUS54Do0JLbEQKmIz6cxP0MCHEPwUCaDta6S3S/PcVJjAAG
	dXx3ZHFgovumHvTv2wjg+tn/FwEo=
X-Google-Smtp-Source: AGHT+IFfb21udVadVrbmwymV6FPQ4mDbiMTYap6Nno/n7Y+0HI9+sf8i1iBohwFWyGux5tc4HiyFIj5OnmKIzKP/bps=
X-Received: by 2002:a05:6122:4597:b0:4f5:c90:2556 with SMTP id
 71dfb90a1353d-507816e69edmr5229848e0c.4.1727535998813; Sat, 28 Sep 2024
 08:06:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240927121715.213013166@linuxfoundation.org>
In-Reply-To: <20240927121715.213013166@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Sat, 28 Sep 2024 08:06:27 -0700
Message-ID: <CAOMdWSKcdV_SviFS6GVU6Q5CPWe-2AiG4FsmYh1c7qEm__T_9A@mail.gmail.com>
Subject: Re: [PATCH 6.11 00/12] 6.11.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.11.1 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 29 Sep 2024 12:17:00 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.1-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems.
No errors or regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
