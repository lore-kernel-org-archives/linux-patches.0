Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com [209.85.222.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0A51DA3D
	for <patches@lists.linux.dev>; Wed, 17 Jul 2024 16:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721235431; cv=none; b=k7tr7Tbdy5gFZYnjT9QEXblegWi7Ga8kkjfCA3kBwQT4rFzckAV8pwwYZKHo3N/pjBSMJMplxJ08LKb19Uk4PKu923D7gmLsdg5XN/16UXhUoQLMiAgwzm2OUSWRmBR8PgmISdwKLNdMFI+dch2Lgi7LpP+Cex05xHc5BGPBXVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721235431; c=relaxed/simple;
	bh=WQoupIds/WAgDwHlqyBKda1KmQUZ6GZLIpDvamuo/EE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z0U5pomkSdsTXF2e1S21nq+K5R60d7oIE/nPkrMPR4km3jNWh0TTNCbmJ+FqA/p1qIP7QPloA/wRXQGIxw9pcWBeuAgEPddIJ2oF9PqU8lWwNdFrSY0IobO77ytOM2n/5LGg2E2dyib4kIPn/y3ITQOV/K9vraeAsItZYqgW1Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jbFJ1uUL; arc=none smtp.client-ip=209.85.222.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jbFJ1uUL"
Received: by mail-ua1-f49.google.com with SMTP id a1e0cc1a2514c-81177a1089fso399562241.2
        for <patches@lists.linux.dev>; Wed, 17 Jul 2024 09:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721235428; x=1721840228; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mOOdvHJILnLqKxW0K5N5eQ51awOco8Au7VrX8zS/IhM=;
        b=jbFJ1uUL1e9K+5OHnYgZkoevkc8v/09OSAqhK77ORyi+7X7ug+OYVJfZ84i5nQRnih
         +75MNIjySEFf5MoyGFT9Ifrw/SGeKOblNqP3IbM6bjukdi+uXLdFtaaF88tpx9M4+eVi
         /guoKJHa0m2TdVJIvW11+/TMox1c6rlFoPvVIre/CZQ+HaYGGTkAEznjXAxLgDO40Zn5
         OzVSGN04JvDLzm1DwBtr7ScNP1ndZfTMaSt815A4hP3nlMYiCBIZUeQFPlfmad5Lmuts
         +FvoUc/zrbdkiSguUlRmzqtnx8ctKdgrKstqMwinA3/k5f4Dp11fyjcmz7Je2uTAwWSw
         MImg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721235428; x=1721840228;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mOOdvHJILnLqKxW0K5N5eQ51awOco8Au7VrX8zS/IhM=;
        b=VtXGU/GEJQOMBl3XQ7426Lg09nE/l2rrzBN03fxnrZcy4Ihqj51aOW6As473HbwimN
         o3v94DAODPQgt7KLP+OlP3xhGNPg06WqQdcbPeZg4rY1+OnFEuGmDRbCK6QQcjaXsq+u
         abzXfJR59CyXj6KtyaPCS4ZREMKBhBHDqDofqjjyGHNZxQf0nZkHi9QckPQPSkmNWH/0
         MAEyavv09NeNEUUZBnIa1yFQmqdTtqAdMc5lm1sPlEtU3t4riMNGHsuWNyVj+FyVHpiE
         wHLYoSZIa8LDs/mQfsoWVC+mG8C3AzTO7v5dXA2ylbcGFiHyiXsh0H2MAqktlEnUajVN
         4luw==
X-Forwarded-Encrypted: i=1; AJvYcCVt7i9MXBo2q4dw5TuOm5iIs06buTSH9wMyyR7CuKQw+O9JSSE1wFOu1e6Jj7mIVmBH0b3KVMMMw1Lx2eNcmNRvMOCGi4+U2g==
X-Gm-Message-State: AOJu0YyXuRg3t+awesfRelzO+WBBg0PnQIATaCgRY096wVh45H6TyepA
	IrQao7ZYXKznE8SzYV15Si77xDxKtuVNRwDysKNNuJX3bwcwY3tT/0qS+CViD2gfxdTKM92VsWg
	STVFlckefqlBctGMOOW6Ik94LgVA=
X-Google-Smtp-Source: AGHT+IEZL6tvedU0NKmu8UAgB1HnO4jxYBM4LHwmkTyVVnItZrjDVOUl6cM9k4vRqtb8aLxZA0f0LakU/5KW540q+74=
X-Received: by 2002:a05:6102:3348:b0:48f:39df:2d8e with SMTP id
 ada2fe7eead31-491599acbe9mr2869265137.19.1721235428516; Wed, 17 Jul 2024
 09:57:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240716152752.524497140@linuxfoundation.org>
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Wed, 17 Jul 2024 09:56:57 -0700
Message-ID: <CAOMdWSLkJrm2cOx-Ugk9QUCXWB3r+N4tw7Y1ZjLsfTm_ND_juw@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/144] 5.15.163-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.15.163 release.
> There are 144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 18 Jul 2024 15:27:21 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.163-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
