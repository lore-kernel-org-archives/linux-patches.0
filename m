Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com [209.85.222.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60DE4EB43
	for <patches@lists.linux.dev>; Tue, 27 Feb 2024 19:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709060561; cv=none; b=jtBbQ6tlc57tGo+GYFtB4llInuwYdebKSEZCVCV+t3uQtZpwrMWTzo3+oKac+FseiEsAgF1xJcER4DfeseT5Zv2fv7SEckj+IgSe6qQORXtZSjtTBp+UB/yIP1GU5ZwZk/qAQYcwrToAGjHnXYvaX7Dwj/jj2RqQAkq7Jtuxk8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709060561; c=relaxed/simple;
	bh=F/T40Ot5q/4XKxuYQ0xwCxn/cFwkxpslhyuDwFRXW6E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XpNcvd2QmD6KUQLTfZtdXN+gdtUHJrfn6JlcEL0mfL3DTZXWRlXh8/QA9VSeh/+HJNiF2EfHvpGFCS+zv3c3q9a2rLDy99MisMysMrCKFqUbQhhfzrLefVzLsuoKHpME+8xwrhw4S5vczcLNUV9zK2BfqN8IDSesQNQqTtZnpmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XHom2THD; arc=none smtp.client-ip=209.85.222.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XHom2THD"
Received: by mail-ua1-f43.google.com with SMTP id a1e0cc1a2514c-7dad2d1c9edso221869241.1
        for <patches@lists.linux.dev>; Tue, 27 Feb 2024 11:02:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709060559; x=1709665359; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MaLEEqvT4bweFBtcBLt+DOaN7p030y7OECbpB6T2QUc=;
        b=XHom2THD3eah8HKsDAUybP5iRBkFr8hH0J3V55nzJm89nhhdDbTGP/Sg7dV0UcvL9I
         B2ndlZ9ILnhrUMVo9qAeJQKtgcBr/5YO1HgnmRx+spm47KIOSuz/kADD7InUCLxL+wac
         G2mR7lRO6bXtGvMTe4zGS6X2n5e9pob++VyzvJGl3zGCEtYxU9ZNjMXdMbeWmDDtUmfR
         7OItqpZ5mflRRcsdEAQNua3Cb2+rGE2blajnDCi+ud4xRE9snOc3g7ClPo2PK+TFNscV
         TEQEmMSd2MNjPgFPAsSoQz8iZWKWrbLX962cFCyyxb5qEygS23ihe7F/TczH54HqiusL
         49AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709060559; x=1709665359;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MaLEEqvT4bweFBtcBLt+DOaN7p030y7OECbpB6T2QUc=;
        b=c/8lt7ChJPnFOh7r5+ERon9N6CRzdFfv+zZVOlDZCT27C9Hr/xPcXNEH1oBLHKHmKH
         kt7BQs2O3lWHuGo/kaoppD8e721kKh1FwFOvzuSrZtZgIun7Z3ZYS9U5Unz7rY7krNdX
         i6sjbm3iDs4DWs/oWNLfUZdNt5qBS++/W220hSlvTyqNuD4AB/J7S2ll6r7NnTWtuFpI
         r2fXtiucKvqkicSan3GPP06rkRwSZ0qkl0i4UX+0c7Zd6PktPg8KlkKXnhqSozhsSxh0
         xipgS+wnOus6nFVwKsqDvdMzAmxjEpNZLbn6M7BhYGOcARCfXh1EXyXTaKmDNNI4uVld
         DaWw==
X-Forwarded-Encrypted: i=1; AJvYcCUe73vT4dogKilQXgmn47fGLQE0O1r8J1PZbWHYKiWkZ26UL8UdgrNdXv/xAE/V0BYL3tED170A6ZRpZlJW0XKmz1qETtSoEQ==
X-Gm-Message-State: AOJu0YzTgaALMtWfYWLIBnLVKx8gQMAxJ31qBJXoq6dbcrq7FHQ6h50e
	c1ubSpogsg5bm2GWgPt3srpPY/v85Aj5jYUm2It9UEgUIodAGUfRemOmTpLG7S0ERBLpVIkHcqU
	StdJk4Rn4OspRRDm7hTa3+1XQ3LE=
X-Google-Smtp-Source: AGHT+IHqgmnLOg0iJqUIsUvNKmzcN/yeqRl09FQa9RsiGWXCbHnEn4YP8yfAQJ6ppywyo6I295VvGNcPJCrvcdq6ejM=
X-Received: by 2002:a1f:49c6:0:b0:4bd:29f7:53c4 with SMTP id
 w189-20020a1f49c6000000b004bd29f753c4mr6706174vka.1.1709060558828; Tue, 27
 Feb 2024 11:02:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240227131610.391465389@linuxfoundation.org>
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Tue, 27 Feb 2024 11:02:27 -0800
Message-ID: <CAOMdWSJcinmuru4=dYQYDcw9viVRrhJYh4e5kHEPOTagnG7=Mg@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/195] 6.1.80-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.1.80 release.
> There are 195 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 29 Feb 2024 13:15:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.80-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
