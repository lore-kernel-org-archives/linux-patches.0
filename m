Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com [209.85.222.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEBA454BE3
	for <patches@lists.linux.dev>; Mon,  8 Jan 2024 18:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E+fYsqEK"
Received: by mail-ua1-f48.google.com with SMTP id a1e0cc1a2514c-7ce6bffb9easo114777241.1
        for <patches@lists.linux.dev>; Mon, 08 Jan 2024 10:48:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704739702; x=1705344502; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UbuPhN1SnrANKO2lmnbl2HWuJmSKTIERpsPhzWFyRj4=;
        b=E+fYsqEKtDdMDc0H/7opw5j9nZISPkoSgenFgySJKF1IEiDdCJ9V1BWg5aAr3A/RQY
         wKOn5tGT0R6iZmnKi9dGWhpDfFC7QJVMRy822Xgj6X4OFkHVKBnW/MP1nZidfgNOpb6c
         SBcQNJqzQmlUYWg3YgRP9gP6q+RCRIUNFnsouOzEevft+NGy/ht+PFuv533KQ0UYNRDV
         5YolPLScgSuG73W9Cil4FL/CGDLX0Syjwr3iLVQlQJCvCdv1+JduoA1YAO7eQYwuAvVv
         rO2QniN47T0psSw5nVS1YZGrC14A91dyQ3azZDCL73AsVWLkod/+BVnUUVP90NcdNWu0
         GgWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704739702; x=1705344502;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UbuPhN1SnrANKO2lmnbl2HWuJmSKTIERpsPhzWFyRj4=;
        b=VtYu8P89FybO3BWvJ5h68ZsIoL/ex5YhZKREHEnlNXTQe6W8Ceik4TKSms2Zv5obk1
         r9bSyn02zb9aPdEyFsbgv71C8TO+XJeV/7dNVNaxOEyQtrUmOUun0pKh8UDZzmyPZLTA
         9QSEzro9xZ6lOt4sKcZ9WsGBh0F03o2poZvUB5lw68Fc8M12DktAb5d9Mi8aMV0Vk/xD
         cAsysuL0k3+pApBWQ4UUMiwrtUMAmUKWiLUVtZkyDA/C6edmuhNw3gK5a6H0Onb5IrC0
         iYDUERMOAl00/Biym8BxQO8m64EfJU2jEZfOhi8F6pprmtQm2thWjIyQQSGmqc7M5qXL
         g1iw==
X-Gm-Message-State: AOJu0YyE91av85hP7EMwnBCWAgHcPg17WzvU94orW4KAFGMNqARu3A8/
	2GrkrSxAgrNTVvYjaQLwbyXwPwWiUePNEiP+TBo=
X-Google-Smtp-Source: AGHT+IF/UEBYXN/CrOF0snFaWdYAlGMmBbT8ZRKqH7CDnECRvIVm8aqXQMMzbB5DPamT9R6ELlSTQ8oCLGtGJ/v2vy8=
X-Received: by 2002:a05:6122:3191:b0:4b6:d63c:ca8f with SMTP id
 ch17-20020a056122319100b004b6d63cca8fmr1227144vkb.16.1704739701037; Mon, 08
 Jan 2024 10:48:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240108153511.214254205@linuxfoundation.org>
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Mon, 8 Jan 2024 10:48:09 -0800
Message-ID: <CAOMdWSKFANBi0TY-1ECPLZyU-K2xTYcBEstuBUaekB_qD35rAA@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/150] 6.1.72-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.1.72 release.
> There are 150 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 10 Jan 2024 15:34:37 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.72-rc1.gz
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
