Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC2419AD90
	for <patches@lists.linux.dev>; Fri,  7 Jun 2024 18:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717783206; cv=none; b=nqdbfMxWyjsluK3g+5qcwi76sdMdBSfsUWeaFICX1jyfhY+MXp+UYGkm+Ujh8vagR6MIIIMBtMYGiOgm4f4ERDjuTf8yxl1NFjR752cbKl3BXlihBLjBNg//3Nvbg5+ulHHeGWMENsn3NQH1/z1yAepb+or/C4I8BZlMBLD/lsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717783206; c=relaxed/simple;
	bh=ORACpY/+WSqScKc7lPlj87lP6hmkqvGD8jTFglZratU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Qq6biTIqxDQsPcuo+9kmfm0t8JSA98FSHiVEXWlF7sYw0P+0ikXbDI5zKA5PRAD/sOw2omz0cWmbKNK0VZCffkr/ZkCgEnV1QgxaQChIY3yu2Mg3ZX5XM+4wD8yZnDbgODghDf8LON2Mce+KAHwyDjCuFbN1cc9WhnyaBVsLCNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jmwHxHIZ; arc=none smtp.client-ip=209.85.217.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jmwHxHIZ"
Received: by mail-vs1-f45.google.com with SMTP id ada2fe7eead31-48bd2a9fc5fso823364137.1
        for <patches@lists.linux.dev>; Fri, 07 Jun 2024 11:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717783204; x=1718388004; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7EhH6vaIBQdb1uBEieNVOyydAgoIsiXtNo78juieCB4=;
        b=jmwHxHIZyn+HJfMMqCGM3DPD/Yu4PgDoSR2khynYCMvX4Z0NPZuoqwyDL4FslxKfU5
         JkldpXpE3NTLAOF2Xdrh6lI2s0UdbFQkyCbPPj2mYLbe1NI7llGKfi3Jwlc/CJiMypKU
         Hi5nbKjz1DEMtpkM1s6AdvS7HTqxMDtdpmXXj953DnAQHWSCNSG6qgkkKzMh4wdkRJSh
         4kUUuqHz4SOqbM3iJnFmAOWRqya7Md3sZ+swNg8s+Uz+e2SFoPeBySF6dwHqEwXl2jAA
         Ui01dyNX1K5xSokAnIZjtT2j32M4njUkkX4msFd2oEoIsOSjMSSt15aDOa9zN2Jj17w+
         bI6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717783204; x=1718388004;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7EhH6vaIBQdb1uBEieNVOyydAgoIsiXtNo78juieCB4=;
        b=RckgwPOwIzJI0tPO3NDG2DyJBk44ZnL7PXPGV9RBgnVob1eu+7Axkwehsl1/p1ZLg7
         By3ftvLhAzJmVSO1XmxDVPe32ov8S4irsxe6Oy6fMTP9Vt1FGGjUuNZ+Z7JydBBnxuCe
         ZDH2Qjd9osz5kusbNd35HQYqdJPDELpQ/RIndtTeD6PGjKJGg/FyQ/4BkQezSWceRgtD
         liiDdmypOTM1OvEFSn+pdluNE5LayiaZAZJH3WkTPq37EtWwzEI0Ykxkj5c8UwRXORF7
         KjWs8o+F6xNjEhUfNkV+lRFGs5JC6S2Om9fV8Hnkn0Qus3NWWXnTD1kmWveA3REqXIjm
         /aaA==
X-Forwarded-Encrypted: i=1; AJvYcCUfoCFZS2H4MqjhLP6lU6GApBhqqBmbZtZBNu0ehQVp3rKbB3/V8V4ccEpf101O5fUSLx+a/j0lD4COTuOTYFhB78AjeByz8w==
X-Gm-Message-State: AOJu0Yx54GyMg+nrzzTuZguxHKDnX1RysKNCGiD8tWsrnhON8Kdb1Eg5
	cfdo26hCno/UVaWS/yJOln/O8kknJlssK/uv1ymynja6Ld4574BxDWmOQhopdjs73evwsTs0/Yv
	Iixzz5MIIHsU+SMxPbb28Wo4eklI=
X-Google-Smtp-Source: AGHT+IFzsGF2lOI5dkNOTbgZy3wS2GYlGMxr6RI9Dk3Ib3eUM9JzBK4G12uxWeICPfFuZsnSc6JqNCaMN+P4/LgMyf4=
X-Received: by 2002:a67:e351:0:b0:48c:1d7a:bdb6 with SMTP id
 ada2fe7eead31-48c275dde03mr2856429137.18.1717783204330; Fri, 07 Jun 2024
 11:00:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240606131659.786180261@linuxfoundation.org>
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Fri, 7 Jun 2024 10:59:53 -0700
Message-ID: <CAOMdWSJL+=cZnNKbpxbo9L51CXkmAp1MOynNpREv5CrB4OfUZQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/473] 6.1.93-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.1.93 release.
> There are 473 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 08 Jun 2024 13:15:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.93-rc1.gz
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
