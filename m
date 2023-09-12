Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1071621
	for <patches@lists.linux.dev>; Tue, 12 Sep 2023 16:38:31 +0000 (UTC)
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-5774750a6efso2241723a12.1
        for <patches@lists.linux.dev>; Tue, 12 Sep 2023 09:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694536711; x=1695141511; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VIjorw0mAfYvUocMlUp9ngShL4M6Rm9ZrInYkBC19Q8=;
        b=sbtS5ZNr4lKRd+NfL+LdrI/5g7V4I7JolO/mAP0S3Mq41DJUG5rnV0zZDNTmeDssjg
         O50AQH39O/Ms+HfVhQVxRZHR5h1zitz/Mn9yQGyTGegAZ462PMCogqeM5RNPCStF/PdD
         +dTbYUAIkJ8bEbTAHpVN4ZBoWTnSE2c/lmG+NfGvjee+4arDVoYNtKXD2AUQqTOsaF91
         XNwOsQl2kDI9eDVDXlTtsfBxtkCH2r11IHb/MpfyCMuIkUDGPM3BiCeOuLpL86/MmkqY
         B+/AZSZaW4BF7Y0IG2DhV6t/KkiwdvlBO8yyqyN4QH0m8GopDWoYYihxxW5AVV402YDk
         1w4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694536711; x=1695141511;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VIjorw0mAfYvUocMlUp9ngShL4M6Rm9ZrInYkBC19Q8=;
        b=IqR7VFWkwbnt0QURmbjUQuj+oItm737hxZYBs+zbJ9TnCAIKGp5RzyS/h7oIurB9fX
         lQ1Y84ZzAE2msgIl14kGKFx1cWYZu5RsKkOnTx1uuIIrPbDOQ1cFWZsGbg3Ox/QXoBSw
         yL0tiNzpJ/+1Th1j7+zfHPEYBJKxxDn7XnuO/nCAEEVTc+B/1km51jNfoH1elamOf/kz
         3HdnJDDF4N74nm8c9uzGmsxeTqx9XehvsyA+82BnISoiaRQKEG8Lzq2hrsEUNeBv2uG0
         QdrddeqZCtme5zJSbjdbqFzk1/Stz2n6rO/YoxIpy9ZWLKviqNDds13rEom3j7rMnRcF
         P0+g==
X-Gm-Message-State: AOJu0Yzr9s684RFturnc1v6lEqebVjs91GU3BP3UJOdkN9JcOYqmopZd
	cjw7riIwQeXLZ4CtnwMXJ+fDYXEsNQYVxeH21c+514iYCKA=
X-Google-Smtp-Source: AGHT+IGwZ8zVFarCqHn4qA49faOc/j0LC1UjXq/jaeq3LCN2xvhegJ2XX1lBFRsE+81ZHUaVYgCKUczj9YlvXjYCcgI=
X-Received: by 2002:a17:90a:fb52:b0:26d:3d3a:a198 with SMTP id
 iq18-20020a17090afb5200b0026d3d3aa198mr9804553pjb.42.1694536711006; Tue, 12
 Sep 2023 09:38:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230911134650.921299741@linuxfoundation.org> <CA+G9fYv7PymkiagSGFU-BXG43gHm2NYDd2CNJw26C52EGhjpig@mail.gmail.com>
In-Reply-To: <CA+G9fYv7PymkiagSGFU-BXG43gHm2NYDd2CNJw26C52EGhjpig@mail.gmail.com>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Tue, 12 Sep 2023 09:38:19 -0700
Message-ID: <CAJq+SaA8qPLxod62+an6ygwXE0Np-LM66WxG7oPg+4ZEpsyTQw@mail.gmail.com>
Subject: Re: [PATCH 6.5 000/739] 6.5.3-rc1 review
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> >
> > This is the start of the stable review cycle for the 6.5.3 release.
> > There are 739 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 13 Sep 2023 13:44:56 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.3-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h


Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
