Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D628BE8
	for <patches@lists.linux.dev>; Sat, 17 Aug 2024 16:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723911813; cv=none; b=mYcfXydYGNEJTIQHTFOV+1WTLsXg5Xe3v5zWMQHx1lniA4pmxSRRE+OBCXJzUNQusdagayc5lPpv2UjPw7IJ+15R3Hrs4W8/maDCd9Al+sSwVWhSsPQyJcdaSOFywMuvkOUeay3f+MXOr1/n+gafE/onJ370KINs8xSQbXTAQbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723911813; c=relaxed/simple;
	bh=3mSY7NA4/PUj/9LLz2fLy7yTUnk+qaTQ3gAEF1ahkyo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KZxSw4i5CzmaN/OOlNksyAIiBj9kuHGlOTT3NqyWuMzc45f4bnwRhSG0irOA09AHBZ0rGzwFZfab9L/uL6iFAenIvM+10sO89WHGQDHgT+SW3P9fMFvnq90FOYZTubZb3p3VfeUIMN2dU3a9kZd5EDt5RsSwU9GKipdxuCKSWuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GYC3UZa6; arc=none smtp.client-ip=209.85.222.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GYC3UZa6"
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-843016bfb48so711490241.3
        for <patches@lists.linux.dev>; Sat, 17 Aug 2024 09:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723911810; x=1724516610; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7xyaYPCiE8ubv3Fg2jG1lMbnf5Wxv9+LvazrJSM5u9s=;
        b=GYC3UZa6/Pz9HgzvHULavvNih2RmRxvWy+KScA/E/61uJLvhAHL5oBgivHCpCiwLAp
         taHpaIR/LOo77epDhQvBHo8W8ekLs5T9vNtdRQoWPO9yhozyKP/PHZ+LMHcW+QjkiPB3
         9KEhGLVcXJowBaKPuEIzEW7DQVxYetnhZmKUH0gYa0nIc5IZWGirKS8zvpmcJEW4NBlN
         QM9ySW9qFEq/Awwey8bg/3AAEOQOn2he+FsYkxb5I1EuBBu9dMSn6mi2dmtoG+p+ro/P
         kcottoaAZcG2qB54HPr9QaY4GBh06h/bZZzLCNJaj/ivbdfYj9tKfKhIwocQgByc0Aaj
         no3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723911810; x=1724516610;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7xyaYPCiE8ubv3Fg2jG1lMbnf5Wxv9+LvazrJSM5u9s=;
        b=KpNyZ6Rsa0WR3zw/XxqKCNZP1ky/KU8xk8Ucti9+IC++Pl9rqRMcPi2gv3Waa5NDp+
         DxXV1AbnNTW+5murcqTUQ6TxFADvNMwkhRBCSS2NFJTbfD+CLQn5JbMOZ6dBeNhplNLI
         I9q2w6pW0NsbfqKpxHy+4iuq2psofpntcVB4I5Qcw46PCFkKYqvi7ec3mVcOWJGqErTd
         +1EW+a6x8UC3CXou/SvAYyGgoGj9PYLiCizquNfakc3+GRvQPtbIbNoq4Oa13z3QCEhi
         SvnsC5FMIAP0Bz2ICXbFKJGyvBRydg2o8eJwy3CTJzOO3P/qaSFLkffU4ZeW1z6t1zza
         s0jQ==
X-Forwarded-Encrypted: i=1; AJvYcCU6XGPcSEaQZlsdk9MvrDF5lOXhe9qN2Skii0McRkeU4NnBw8eOvdoq6B/8Wwo+8dWXlQ2yiIJstdC4T1tRjegYk+fxiS8F0g==
X-Gm-Message-State: AOJu0Yz5BHypgck9fof8HKAuF1l81WgLHykD124uxWntDOLcSJy0ZMur
	0g5pPsDSydg4dCRfs7ZOj4OXPeF82fk8WbP1ykN6qn6mLSPYdZBExd34REM5NbxpN0fTxv/TcmT
	oWTp1BnfLM780jHJlcg+OjeL/v1k=
X-Google-Smtp-Source: AGHT+IEJIMGHi094EmzjbYpNVP7impLgba/aIK8W3VVjhE5Y96IHkNPKFgucWQwk6qFrDgFgFzrf/lC54fMRwNmXcsc=
X-Received: by 2002:a05:6102:6cd:b0:494:10af:2bc8 with SMTP id
 ada2fe7eead31-497799e6397mr8734377137.24.1723911810306; Sat, 17 Aug 2024
 09:23:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240813061957.925312455@linuxfoundation.org>
In-Reply-To: <20240813061957.925312455@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Sat, 17 Aug 2024 09:23:19 -0700
Message-ID: <CAOMdWSJqAqTk0+RxzGrPvSAR492U9KdWpq8NGYB56BbS=2dWKQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/149] 6.1.105-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.1.105 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 15 Aug 2024 06:19:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.105-rc2.gz
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
