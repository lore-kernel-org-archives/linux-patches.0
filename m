Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2214C141996
	for <patches@lists.linux.dev>; Wed, 14 Feb 2024 23:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707953345; cv=none; b=rSx2Qu3BzFFBE0OWIBT4E2RntA22Nak2vTzY2T7f6+7PLpyyoz6J8t9SNWPVJvIkc7AE9YbaO2kkuBnFout3wBRpvBxJBwZNKlm2NHb8DxyQTa55zRn6tdUMvdJkdy0FQSuFQ0j8xhhzIsdNuPBkxCRGyETOloJ2UV0Ojl1dNkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707953345; c=relaxed/simple;
	bh=BEBtdBAQ82qgro7oQ40alHsa4IgeFXi1oEys5wUUXWY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eEy/wDGMBHqFPop0N+E2rl/Hz6SwCdqUR2Nn5qvqTFnvY6ko4MmucUW0ScN3uvNPPMcMcDOZtWeWAcSYhBp8j6g0WSZbIAiHoGwaSZM0MwRnVaHdUuWuAf1ufCO/5ht9odCHO+Hoy1Y4K3zdFmQHNm2CE+z6duhh9ClDevq+GTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AUXY/0SR; arc=none smtp.client-ip=209.85.221.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AUXY/0SR"
Received: by mail-vk1-f181.google.com with SMTP id 71dfb90a1353d-4c069db671eso82284e0c.1
        for <patches@lists.linux.dev>; Wed, 14 Feb 2024 15:29:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707953343; x=1708558143; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=E83E1MDKa/f33TdondzwW5NbSuDEHrLaLNf31UAm4Rs=;
        b=AUXY/0SRB537LEtBNgAx3zyyNSEUzJQQr2RSlS2aFBd+/cR6votbXCtn964gaTlJKD
         6Y0r46CX5gZEo0PTlsRP5rpKfykvYOQTeP6pxuHIm9N9V+6+pP2iE/+N0XyQo/5jsWjb
         IfWcGcq5asQS2OMxfEb2LwJatpPJvcj40wU8tWsG3Sv1SjAOgvv7fYkwl6dVBH7ZcKiv
         ymzH7fCmr28BynH7JFllO28P+VjYhmvpOIhkT7zIO7qXc6Oofh+fYuCOTGoCBPdVRVFB
         /Ao+R15vI5K9ky6rSwyY7tRcD8ATxZuK8IbowSEbP1Gvs6e73frEluSWawjooPKfsH9t
         Ug1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707953343; x=1708558143;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E83E1MDKa/f33TdondzwW5NbSuDEHrLaLNf31UAm4Rs=;
        b=S8s27RIIVAlFdcAw2lmiMSvfxgxfjaHwk5Iutb/CSFSEj8mnZrrSRrzG1/RH007cdp
         Yue3oDl3RNDpaddIchnZjc/N0FSFgwyrYS9MpAw3Rp6I+m2Z/z3ahWf4lGlLZNQoPmVh
         AbbewTa5p4lbthVfIzE7PCpIaWrs+OMJJZSRzi6zZGGLg3ufeT3pXO3fZBiL/aijL4Ba
         DhL51zrkBzOOnvwWtgnMJtxCgYZGN8VY/nwOxLmnqz1t4YZzn6ekQy5fZqC8oizXHhCu
         KyP/3JD0ptxgIFvFfWp5PX+8Lm5BZPEBOeOPId+WEC+iXG+5eEz5OeS0H8bR1n9VKNBM
         HITQ==
X-Forwarded-Encrypted: i=1; AJvYcCU8/R8YS4zHQmCLC4SG4ya6S6Jk1f0VWAs4+DyhKlcrl6VYXDWJi1VZtWmusBqAREnKyWJTvu3CAefHPU+OD7K6/EDieT0JFw==
X-Gm-Message-State: AOJu0Yy2U0IWg5Cz5fDWOcaPzgtxch+JRw1qpBTV4wAgLj6Vb0TR6ph8
	39GzWeG1DxMw8IV08r6BR+dfh2dE7C28Ouoj3UlJPC2IoV/U42GkH/bbO17PeCAXn+S2a6HzAuT
	2qJs1vb+U6rUJT2IS4vrlo9ZacTo=
X-Google-Smtp-Source: AGHT+IHOq8H1GgxWOoqURhfY3+8v+bMEWaDhUgVAURIbQ63g3Y/IBAO/dIydTqstdJR3uqe0kAbNRcbuyd/FVBPIeXA=
X-Received: by 2002:a1f:c787:0:b0:4c0:292d:193d with SMTP id
 x129-20020a1fc787000000b004c0292d193dmr4350500vkf.12.1707953342994; Wed, 14
 Feb 2024 15:29:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240214142244.209814342@linuxfoundation.org>
In-Reply-To: <20240214142244.209814342@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Wed, 14 Feb 2024 15:28:51 -0800
Message-ID: <CAOMdWSKVpgCzitkFCr6NjfmWq=SAfyMhfAOKzRw3hyVbA+riqw@mail.gmail.com>
Subject: Re: [PATCH 6.7 000/127] 6.7.5-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.7.5 release.
> There are 127 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 16 Feb 2024 14:22:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.7.5-rc2.gz
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
