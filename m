Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813BC19B3F7
	for <patches@lists.linux.dev>; Fri,  7 Jun 2024 18:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717783289; cv=none; b=Ne5M50w/CGrjDQy8Ac6FUYzTXWFZ8u1nQtCytb1IVjz6EwXp1XmnSPVwrZ/Uke59Gyu9+eog8sEr3OP4q2b5x+YMVvbcN7745O4iGaEW7GxzNETOQ5J+zZ+M2lp1NP3KeEvzpOdeierrvWK+dupSsHNPcgaFuUSMvh8Np122JrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717783289; c=relaxed/simple;
	bh=Y6ZGPlPk4FkOhLXv3Zk2jZLvzmkHxo2CEA9fnJyhh8Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L49qv+rpkoDA9ZjNMWEQfY6xXaUd7Vu8EjCxueYhV0xaeWvD/KvBnkgx/KOaHwOQaHxT4UUYK4O5xoeopXCHHoquTxlp0ld5LtBmVdcq9kUqq9iPewMOvnXZrqHX4TP5MqLOsB3bymCe4LDDJ5w6ZUMxc79/J0LqesaGxi1I9hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GPPNIwwf; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GPPNIwwf"
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-3c9c36db8eeso1338225b6e.0
        for <patches@lists.linux.dev>; Fri, 07 Jun 2024 11:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717783287; x=1718388087; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pS0ds05HCCXOM+EbDOyp7PVbh5OG5LcLHQllkmtfZTU=;
        b=GPPNIwwf1ov3FpejORbTS/vPJu35o+6tk7Cv4jth/HQTcgXh+Z57PkYxyLqAXhQh11
         TlaNOSlCpedDZl5yZi6vOV9CbmWDtCL/HvSHoKKU/hCoWXFDPQvLlpZAktYOZZisXNF0
         Pn5E27rNR04GREABOqb4Ako0ulKq1ZFN/tzUuQa7JykYPy6R/atx7EiUdU+oBgKj7y0d
         G/WMEA4CWhY9R90hVdnjXcKNvQ8SkwHxJhpTzWFMH0m+3mgAv4s+nCGHfO1kfWHzcxer
         vGjeGSDaIdV1ki0WlcGKujQW88xsHEHzYOT1XzOn+PfC5z8RKTItgciW3yBlanky/JXa
         umXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717783287; x=1718388087;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pS0ds05HCCXOM+EbDOyp7PVbh5OG5LcLHQllkmtfZTU=;
        b=BPhx6PmCJlVZ6hqzdAJRzBKjiJ0CCU52OA7rbXhK7SP6UYhgdaO7P9WFjuvirB6XTd
         lVUMz5pTEWIIucXn7a+/sufRBLWBzg158u0PjlB9Uh7PoUqcMYvi8HH2VtMZx8PSNxoJ
         Fcu6cMbAoki0f1KOOJ6gobi1NX5aOT5yFqbxnXhXr4pALlgMBfYxMQcKesXyuLislDE4
         3t2e+0DXkbeeGhSUbCH/yIAY4N2cu7J1Wl3/+XM4nXUCegsH28YVehAuWJBtGg8oZyNY
         yALMkuJcWg5OBGdRfbklGe0QimTiihOyDEi8OkpddLId1EFvkiZyQmBlUUGCGxoTQrg4
         AvPQ==
X-Forwarded-Encrypted: i=1; AJvYcCWjgBO2BGNgJIj+evZ79wwQPbUFhBOZdISSg8BX3Y/D9+BL9nOTYV2ImRySzWzKVcDZC3PXaq3NbQrahMIxR3m1oHaOKE2EdA==
X-Gm-Message-State: AOJu0Yz0PbGfDQ1S3Yu6J63c+9unKmK4ZL5jpA8JKcEz4f1RQYocEi8/
	+Ju0YFxZdMMPXvx1Fm1fCVGqYNOjmS3eRbpoaCW+EaRoNcNJ++3ORUhFAGBod4PhvJV6jka180q
	j9EkN+ZCCKPl9k6JZev6KAVy8aFY=
X-Google-Smtp-Source: AGHT+IHOuWJjlat2L7E458dgn7PdsQdmans6AbDIbXmnipcWq3CNPFhMFfo6LZu5ztdtr8ghESzUsWn/Ly5gfmovM5I=
X-Received: by 2002:a05:6808:489:b0:3d2:80a:644e with SMTP id
 5614622812f47-3d210d28aa4mr3298220b6e.4.1717783285863; Fri, 07 Jun 2024
 11:01:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240606131651.683718371@linuxfoundation.org>
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Fri, 7 Jun 2024 11:01:14 -0700
Message-ID: <CAOMdWS+Myg1+1oL7T2BuKG4=W4oNjBX1kW1_nDnmnO883h9Lqg@mail.gmail.com>
Subject: Re: [PATCH 6.9 000/374] 6.9.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.9.4 release.
> There are 374 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 08 Jun 2024 13:15:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.4-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
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
