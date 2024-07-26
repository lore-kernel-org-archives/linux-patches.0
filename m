Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808BC225D4
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 12:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721997147; cv=none; b=EmWpdgjBYtwTBKyUJTsbwmIv1V8gOtYxNmC9kXX/e91qjsEIN0tAAmWdVkGJLhtgtWvLK1wKKvKODeIaIHsKlxtd79oOcHGeyfHAbHI3/GFtPzM3pQ6JAtCa7thMvRi0tp08O1NaJfMwrNn3miEZNAz2FmIvsUFyuCg1ns1ZR0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721997147; c=relaxed/simple;
	bh=Ow0lF4PR1W4zPn5dnOxQWbvpWyIhvhfyYRUku7Phcrs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H/QFdojBNhHRSLcyYUnXgjJZGNjtcwr0eXjoi7gTa1b7jgUZGbPqjbmK8HW+u5B74GLo0oBOvgHNybigTc5iy52pcCi+SYEj4UH8+7ue2ZLqZ+LDcKqJQpqWvHCeyX5nu2BYbe1r6RhgONWxcV4t8eHBfOxiNSPsMn51fPvhqqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=ODvVX5v7; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="ODvVX5v7"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-7a1d48e0a5fso618089a12.3
        for <patches@lists.linux.dev>; Fri, 26 Jul 2024 05:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1721997145; x=1722601945; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l2CXarSgTnQy4ZvMHuo03qNRpFcxWzwsegdi47MF0qg=;
        b=ODvVX5v7vxnFLYUY6wxPVBUHz91tc7CDunZKH1ZVE7KrIc30yQ0k2QHWhwi9DdjL9H
         WUmmfiIydM3QyXAtZ/dtf53vOYmlJm4m0JL2nEhOYmZPVo2sKiLA3IwsjjnEaUYr0u6n
         yoZiZt70XtrpmkPP+eWPgJsCPIk5eRANPF4DIG4rct/0XGf3GqtZrDaE9hqLCZ19T+Qf
         CLakAa/ZxRCE4lGc67FRJ+2zqkFT+qivTACpX3uJJpRZVcQH3DVkr6HEWgRvwMcm6yZv
         5nWEprKVJZix4nijgt/+W5/slr6mBZW9MRxya8UcmNBO6ZYXlAnoiTmoQKJMEPN8tJbq
         Iwcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721997145; x=1722601945;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l2CXarSgTnQy4ZvMHuo03qNRpFcxWzwsegdi47MF0qg=;
        b=K0wzIgepExvHk95gDzVmzjCqs+z0yKwLll6yFK5zLBCZ68dptEhvniZNe2YudWdr+O
         Y6qDycb/n58q5bN75nDuzVoloN1GsFGKQV2AuxTsLyTHlyE8rwfD4+qSRQgsyBnwMiMZ
         fQNGphd0C6Xyhr/LFj6lpQvBXCMeVATNi+lfxTn0sjXv5LAv2NN75en/GdRiyuD2WtCl
         qodfdlE0k3dEaqFJ+OL6D8+Y2WUUWvTrfgnFlIQv6dPXiiJ6HDRCI7//onKEb3cqQnjg
         Fu4VEfPszgG8xhOWS5D3UzSMTwL3P+xC0t0peDdsFCyhbUvCqJpMxqj9DyHWFCcF9ioh
         JTLA==
X-Forwarded-Encrypted: i=1; AJvYcCVgCLVmlIXbgdP+BoCT7NA/wILBUozHbwRpl+OcbbZ+1PTf+Sz0oD3qvwcf9hLxnGOEIHS6Nh7PJQ8PdVbSaEzTSvYH0YLWaw==
X-Gm-Message-State: AOJu0Yx3rziKEgX/BfFyzfN/F0rCH39fnvpy+E+bfTcxA0u4v2Cns5xh
	cYGN+xl6JWJcQIrD/RV9CdF0FqNkim8A6Sekyc4vJL1g1Swd/IpWlOGEPv+1SCRNAD59D8xlmXI
	3jjzpz9pUTEbvmAnHvA//SUj8tZ1WyurmcpBDNg==
X-Google-Smtp-Source: AGHT+IECb8woF2lIKmHKOjmufAD4JhhxypYA+icIANC3xTm1uDphLcOwr+ij+DGnOuZ/K/cor76RApG76j1tmrVHkmQ=
X-Received: by 2002:a17:90b:164d:b0:2c8:f3b4:a3df with SMTP id
 98e67ed59e1d1-2cf2395832dmr6365849a91.42.1721997144677; Fri, 26 Jul 2024
 05:32:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240725142728.905379352@linuxfoundation.org>
In-Reply-To: <20240725142728.905379352@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Fri, 26 Jul 2024 21:32:13 +0900
Message-ID: <CAKL4bV46vNSzkJQXBH8xOOSY70Q2PCoKoyJpmFBHPQzs4cdL0Q@mail.gmail.com>
Subject: Re: [PATCH 6.6 00/16] 6.6.43-rc1 review
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

On Thu, Jul 25, 2024 at 11:45=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.43 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 27 Jul 2024 14:27:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.43-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.6.43-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.43-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.1.1 20240720, GNU ld (GNU
Binutils) 2.42.0) #1 SMP PREEMPT_DYNAMIC Fri Jul 26 20:55:25 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
