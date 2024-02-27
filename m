Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com [209.85.217.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF42851C36
	for <patches@lists.linux.dev>; Tue, 27 Feb 2024 19:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709060424; cv=none; b=eXeBwAxlye/Lj6yCl6Nto1djcXiRAOCD7vShAlv8B1ow+1h3KWWVWX8Ill7Y8iF9EmPbNbzuLi7wRf61hzBJ3wfO01pGswEEzH/dmDEeFkFTPGFAjRWu7hVzg13ZisiVFwdnSwWZDsfG2aBU7yRRiQIfch4MBzTnPat4L2deaKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709060424; c=relaxed/simple;
	bh=yb4ZJgAhsQwDK7J4UE4iqKXCKtDiJ2GpqwQ8bXVuM1o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J9ogKcvqfAeDZqxPIvHJRdDl8iaAgfMkuOup/E3r5KXDX4LYG2dgYCGtZHEZdBvdDlonMSuQ9OY0OVsYh01AWe5+j27ebT5vN9nBNWZj8ZlVnNU/5h8QnioUgLQ/qw/JwRu90FWwknRsqgyzzAJdygu123+/aDEOlh7Gh0iOCQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lSvaBMSM; arc=none smtp.client-ip=209.85.217.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lSvaBMSM"
Received: by mail-vs1-f49.google.com with SMTP id ada2fe7eead31-47265631782so64556137.0
        for <patches@lists.linux.dev>; Tue, 27 Feb 2024 11:00:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709060422; x=1709665222; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9A/eIYvA6ALZ+iaMWd4UbzjIULitUS+U5SvdopkaaK0=;
        b=lSvaBMSMwO7Qjz7CSn3a7f6qENHi0mjqEOUHfs2HxUDLNnu+ixo9PRBa096UKKA+hs
         xjXMdfk4yTDwqEtM5Llv2kZBeZF71MxWURmO2p/htjWgHgu9IfX8c/PArglcCynn41La
         +0+8ubhUJuqz525fgonpHi+3uY6d8+7E2f02p4SChk06PbpGaDgwWCChZGSTTJ2AruEZ
         ViLDpwAkhoT8DMEOeNmqQvqOfDHKQCOZdAKl+gksEZYJJYKTy6ZHa7BfllkGwHZ5XhqO
         ZuIeCgR7WQraRM+9VGCIp6PoWy/pYkKYaZXQVoTIb4yZ+oyrX0r7F9Wk5oPQN2POxUZL
         6NvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709060422; x=1709665222;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9A/eIYvA6ALZ+iaMWd4UbzjIULitUS+U5SvdopkaaK0=;
        b=Qd/kRy9qh/C1P2ndv4Ib7ABT92acu+BPt4QmOmcGwG3jQWz5ERLsA69logASbVH/ot
         CNeUI4Ig+O0vdMF6wUOtgJxJojX8opnRGYfwBrqzPg21RBc2QhLVkLLcKSovhK3k/c4h
         dT+gwckeHupNzgbVZcXhQ/dgz6j1LVsjBJ1mJiZ8/yItW+2cqfYss3TSPr/VJ3qswHSR
         bAW6xOaspYntzQuAnTjtHILEwHCFOG7a6U+GArQq7n0kJ0Itreg2DfkUbEXMA9svU26U
         skZlkoSGtsgfMDAInBDXJrhKy5FCUlHkGrwRwDV48JlGDkriayLayyisWwUX5uvmwgVn
         TrxQ==
X-Forwarded-Encrypted: i=1; AJvYcCVOpmgKvD6CIEbNJQorHF5e3M5BCgzZvTRozkPIvYaoehnU+zdcuwXUInuyQa2bWHhcXVcDs8o7hG763qfzuZu4G9QzuuNhkA==
X-Gm-Message-State: AOJu0Yxr6IrBqENXAOl+Bu4uMuPo5mgnxHI+fnWbAShG++/i0p4Qu7Q8
	Y45ytARK4vMlpCIv42R2rZ1vN4yTHRJJTXao/8Ww9VND0iytjrWUZoDunSVPbAPiu/S6xZq352u
	TUUDnO/MjKnQ2OBIO3ySbLC6GGaw=
X-Google-Smtp-Source: AGHT+IGYSAayHL4gQrXObG+dSg5xn81WzKhGIvJblI4551mBSqwvO66HfBdFsC9Ewqm9vM3xi+YcwPSJk4AGpT0kcTE=
X-Received: by 2002:a05:6102:3911:b0:471:f1a2:13c5 with SMTP id
 e17-20020a056102391100b00471f1a213c5mr7498683vsu.7.1709060421134; Tue, 27 Feb
 2024 11:00:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240227131625.847743063@linuxfoundation.org>
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Tue, 27 Feb 2024 11:00:09 -0800
Message-ID: <CAOMdWS+MHqpiVGCZDOU14SjdagLZoxxcbgg0tf8UtnSvCj5Qwg@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/299] 6.6.19-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.6.19 release.
> There are 299 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 29 Feb 2024 13:15:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.19-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
