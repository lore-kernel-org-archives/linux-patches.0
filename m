Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3665F1B4F1F
	for <patches@lists.linux.dev>; Wed, 16 Jul 2025 11:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752666560; cv=none; b=lYC3fzd8nM0otA5FbOxOM7efx3TSzU/827X7fZWvmykyighbrHUDNgU6hyav1wvwXTsLF+U8DZ7y71EXwIXtMvIR5w5cnBJb35nPk7gkqLtLKH4olkt+Eu/mPgEmEpuWg8jMOIUWcf9xtxK8aaDEoLs4pqB2qPMr8GORevr2zyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752666560; c=relaxed/simple;
	bh=EfIZ3AaNhUTMuhQh3gY9/eRnLi3OVX5M6gZKgoUL7yw=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=dk8HsJz6j85Wf/FyiAfy5WeAyYxjtQWH6JbEGMnq6npxmfiaIaTOu+ObtlSWs5de3cbReKDMmyQPRuTJhaPEkmzTVub2mNNJ/Jtl1S9ZbxLs1jwta/P+JM/lcR/slgDFPPGVq/j686ISYvT2aeulxTpLJ3ne3DnOVh/WjHNonlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VHHs2Cn9; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VHHs2Cn9"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-45619d70c72so7287555e9.0
        for <patches@lists.linux.dev>; Wed, 16 Jul 2025 04:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752666557; x=1753271357; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4mHwEr8aXM8Rm2WbnaOlMv2XTUB4hN6RMG5Qw6s+9Wk=;
        b=VHHs2Cn9IYXX1k6brDPMMq9wOqfbm6Bt2Z9ODjrVvgGbyCKvIs8XTBTDNacAoomcJL
         1hCnzR1dnSbRG0VX4lFray0OsVuK62CLl0645C1q/Qd2nW5XJJpp3igGnhilT9U2SIFo
         3KXG26jBFod0J3/4OF1V02WjDmNO1IrfBMOOj/a1NXfN+QcSBO+6wUJ2nQn0rfvqWB5k
         EYT0m7ivXxxffkBkET/vtLsmv9D0VUJDO5Hmb9Ptj4edBVUTvT9AyH+da5I8HPCWlRCD
         EpyDZ2g43+WE0V7EMY+wsVCAqNBy4LRktWTPKGootuy8o+ey99ItU4MlPiUBPIclBZ2M
         ssKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752666557; x=1753271357;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4mHwEr8aXM8Rm2WbnaOlMv2XTUB4hN6RMG5Qw6s+9Wk=;
        b=Sz1dXdK01EPjh0xV05YUpRWTOCB+oFZvXT2Xp2rX6KaCHVUmhq1b9BBtkr8LPBuMzm
         +o+5DQixxM6wzmlE2aEatGPDDOsmLbr3UCIQABKzrZyi+g14UfaTzvT/3V5J68tKiTNJ
         Jc1Fw7s/EJApme7rx3xnAC1MszaDfkaX+kAaKBz9HxbikAt5bV3vZ0pXD8uYxfe/K+f5
         czWx9ZDM6j8vizHevyIqtosoNluE5Cjdcc7JymkC0/ubi6iZWvHtAZ/DMlcFoR/ky1dd
         ZINTwwIaxDssDGq8KUXPtxMmqBTRJITIhQtCXgBTywxKSHmK1JoARjiWeHjQ475Rft4a
         rLhA==
X-Forwarded-Encrypted: i=1; AJvYcCVcXM/SUcsDPTE41Zf+apGT+nVdeth1HsgZKtRAWQpt3/oQWz/fFgsokO3gxZ2e79NPh+/POq9l@lists.linux.dev
X-Gm-Message-State: AOJu0Yzv8tKYR9X0gJkXfWwuuXMHm/uhza3GARKMC/MZd4UUaLm+wKdb
	Zx3wnaCs1ZDBvg/jeM5TzB0jkPAUwRZRdZswWiHHqqGzvfYiQTNOMrWFRLwHOjjprCYKpNjB57E
	fZD/oV562WDEB+/kJTprWc0f2hBWY0Qk=
X-Gm-Gg: ASbGncs/KK+NQtAsn5o9N0sy09vAOVGv4FAYwDV7AHkKSkc0HFTqstKlTeIqIjPyVKg
	vGQypW65P7bDvFwlLJN6qDKY2/nvJB8Ee4icQBgzUxTAXki7xwl5VUvqd0rQ1fiMWTpZ1zQaYp/
	11RHoOEejanLFeV+x3jjPQqEAtkz7EH4oZUIZIPUgyYlp/kyhC9wgUudMcA+LtXAZK/FIgvisbK
	gBjV8wLKTw2zwYSpxvVhHhpOoBlNIJli5YF
X-Google-Smtp-Source: AGHT+IHd1O90KF1+jH53EPUgdhgA0S+qM0ugf/xNYrgnYVrSa5To++qM+eBy8Mx+ZQrXxsG40EAjBGOx/NExfNplCY8=
X-Received: by 2002:a05:600c:1d03:b0:456:1ab0:d566 with SMTP id
 5b1f17b1804b1-4562f825a5amr17037445e9.16.1752666556454; Wed, 16 Jul 2025
 04:49:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Dileep malepu <dileep.debian@gmail.com>
Date: Wed, 16 Jul 2025 17:19:05 +0530
X-Gm-Features: Ac12FXzQIz-iQkdUtftKGgdOsL1jWnJIYTwWISRGw9PwtFZI6pam8h1KvOjDnwk
Message-ID: <CAC-m1rots=Rz+_VRWQetOM25MGLnEnQ89EO6DQm7ZykP5TjsdA@mail.gmail.com>
Subject: Re: [PATCH 6.15 000/192] 6.15.7-rc1 review
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org, broonie@kernel.org, conor@kernel.org, 
	f.fainelli@gmail.com, hargar@microsoft.com, jonathanh@nvidia.com, 
	linux-kernel@vger.kernel.org, linux@roeck-us.net, 
	lkft-triage@lists.linaro.org, patches@kernelci.org, patches@lists.linux.dev, 
	pavel@denx.de, rwarsow@gmx.de, shuah@kernel.org, srw@sladewatkins.net, 
	stable@vger.kernel.org, sudipm.mukherjee@gmail.com, 
	torvalds@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.15.7 release.
> There are 192 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 17 Jul 2025 13:07:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.7-rc1.gz
> or in the git tree and branch at:
> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Tested Linux kernel 6.15.7-rc1 on Fedora 37 (x86_64) with Intel i7-11800H.
All major tests including boot, Wi-Fi, Bluetooth, audio, video, and USB
mass storage detection passed successfully.

Kernel Version    : 6.15.7-rc1
Fedora Version    : 37 (Thirty Seven)
Processor         : 11th Gen Intel(R) Core(TM) i7-11800H @ 2.30GHz
Build Architecture: x86_64

Test Results:
- Boot Test                      : PASS
- Wi-Fi Test                     : PASS
- Bluetooth Test               : PASS
- Audio Test                     : PASS
- Video Test                     : PASS
- USB Mass Storage Drive Detect : PASS

Tested-by: Dileep Malepu <dileep.debian@gmail.com>
