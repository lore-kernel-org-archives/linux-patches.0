Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40F3282F4
	for <patches@lists.linux.dev>; Sat, 17 Aug 2024 16:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723911887; cv=none; b=WEzYj3OobrFjYlR6PKBdOz7ZFyngzyaGxtrW6eTYNwmDkiHVGBfhzk3Lnfb4qERDRnTi0+SlpZI/OoA+ykVJMgYsePEQ2PHKC599mZ9Iz834roJE8p1dYnenPGjZGF67b8RwTNdcQ4e5xZm+2lPDL54mDQ8Jd+UBmRFHfVMxqXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723911887; c=relaxed/simple;
	bh=Zyy9deutAUi693FcRc0OvVYLdpY3l3WzCKhvyhNdZ2s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=myiNAhKufn5Ps2PWXZct7VkvW6fFonXHOuvNK0oPAOPOLx40I7f1nGdRgSabJAVPwAfxXVyEhVZQgve+JMeKSqTUC4pvwPFCJ1l0ye2yuPQFYjprtzCRUHlLsh6N3QvaPF5oVpXwTMc333E/Cl0NwzA5ezoEPjtvXj0d+QurT6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LhJ+bM6C; arc=none smtp.client-ip=209.85.221.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LhJ+bM6C"
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-4f6be9d13cdso1010203e0c.3
        for <patches@lists.linux.dev>; Sat, 17 Aug 2024 09:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723911884; x=1724516684; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MPgaOuVAOD59RJaGVw9YG5oS9tkxJ6USqmcmqvXCjag=;
        b=LhJ+bM6CLIuaUYnMmfJygCilr2lwxpIQ9kU4mg9jHPOfVQW0aGcnVGTSP2FwvgVCiK
         GgLYL2Y7Ei7jbEiV8ubfF/i46aJXGcrD89rnQ85lJLuzUeFpuQF6x482VbzQCzASU2i6
         EHi1YPSoxbMSVdtxouwsYJV3my0bIC8CI/XUUf0nzqw37kNXcAaqtE3n2IMh2+gYQpo1
         baB72Mwse3jzkqDDhVbTvra3YTbkB3OIaCxMPmHxY9HJH1G5DD8NZMFCwvgcGb5W0sQj
         8Ab2Ef6aYASm0MZ2lUOALiHRpQG3h/WULsF1r9RiomD+rBsOTebXp5pged94ylCNaEWa
         mUuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723911884; x=1724516684;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MPgaOuVAOD59RJaGVw9YG5oS9tkxJ6USqmcmqvXCjag=;
        b=PZG6DQmAqItaRVPHvx+qWsuuIvM4l3/ZyElg8yJC/1v9pV/j71lcTDjUjqm5cW31SX
         u4YcqEan9l2BaUf3EjU0G40TpgQMOHVP8pMRnOVdzFZohPP3Z1AhJ3PAOkHyn+54ViSr
         /Y6KSrqgtVBnKVuI6PapArAs9d6/w9z0U99VB0Y14/PK/ptJqXjQBmz1Ac648pcLr7i4
         tn+olGr+yLqI+WZTN/br+I6DMl9RcY2lsGxUlAIX2NtPDjxP/Nbgl5eXZRmGcMydWNDw
         14z2Wo50I6tVc/wv3ygDGo2oT9R9t57bwD9VvHSlMYGiU8jT1nfsLO+GMUjVt9m0pCKm
         b9kw==
X-Forwarded-Encrypted: i=1; AJvYcCW20NhDdqWYErs6Aw92omT/IMPv8mVMs9rGegmGLwhOkXjdAfL35e+O9fvtoWZHANxsUGZaFktFuM0lhW1tP+wghEPe5zTEeg==
X-Gm-Message-State: AOJu0Yz2Wq8cqHzJ7zUvFh6aHi9j3WKR2OBF/1yIvXMy/K9/4hI9VUPP
	ZSuJrLjXc99kPrtIyey+A39Ir5/woLHtMnyzuqPDlDJATDUK7Jge87ghbf0Rks+CiHg/Rs52Cye
	tr4gmkR+J+T8i8m/jtes9rYiI2QQ=
X-Google-Smtp-Source: AGHT+IEZMsH9C7KHaMNbRAnt2nOEGnrNERfk+CVoemEb4jOhqbS2pD1sG6Ubo59e8/Ph4IoHgwV6XJnRbTlhS9Xcafw=
X-Received: by 2002:a05:6122:4123:b0:4ec:f6f2:f1cd with SMTP id
 71dfb90a1353d-4fc6c9d70aamr5190196e0c.9.1723911883814; Sat, 17 Aug 2024
 09:24:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240816085226.888902473@linuxfoundation.org>
In-Reply-To: <20240816085226.888902473@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Sat, 17 Aug 2024 09:24:32 -0700
Message-ID: <CAOMdWSLwqWtcNF=ZnryAEyg+RDT5_bU-B=q=Z_PUo_t3O1m1nQ@mail.gmail.com>
Subject: Re: [PATCH 6.10 00/25] 6.10.6-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.10.6 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 18 Aug 2024 08:52:13 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.6-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
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
