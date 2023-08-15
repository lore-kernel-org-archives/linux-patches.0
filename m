Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93DE9134CE
	for <patches@lists.linux.dev>; Tue, 15 Aug 2023 17:08:33 +0000 (UTC)
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-6bc9d16c317so4503169a34.1
        for <patches@lists.linux.dev>; Tue, 15 Aug 2023 10:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692119312; x=1692724112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ho5kGogOP6DWyhDIzrq6p+Riu+RWi3TMu4byewlsQhs=;
        b=mdW/1e/W7XY4CfpHWvJxRbVGz7F3nmV+RJnS/6fY2LnpTN9XlaB4xlMjrOpsFZUA82
         2g1Z284AWx4Bq8+OzEpn/0yHdGdyeF9r9AUcaPQYss0DO8NNFeJIIYC6GjN0+fI7G/Qs
         P78tl5nLN8jgxjZuC4bE3qW+A/CuLGf36t6asVrHksf59ZkQKkUCGOstZLKfQ0WRWim9
         h0TatdokYMetmBGqLPi8h5EbaVvk811PCcI+PRo0MRLn3TTo7/NOw0d7rRxXrFRzUtFd
         6MhPzQInl7i0G8X1/MNwY2nin5vpVU/ty8soI8fQjo1WIl2WnDLaExIheTJtHDXLhi0k
         Vi2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692119312; x=1692724112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ho5kGogOP6DWyhDIzrq6p+Riu+RWi3TMu4byewlsQhs=;
        b=Qqu09/xXwDkYwlJefq/VQtxlrsneBC0mFG4+qS+QBvyj0aqgBwG2GnVC8FmHIc2Q3y
         oJpJgAIyQS+sazlQLt6UBaRzlWxcXzzP44xnIz45HyS3lHkOwGHODN8pr3FHU8fialgm
         tdceFQlKg7oR0U9sBlBNIb7PEKz+kViOFgIFVAV9iIA6IlnNmwDvQyq5WDV4CCBZ4j9Z
         Ah6g83ytSvy42Aqd32HURRH7evi6oMRgAqlQghZdJPmG7aAq0/authH/Mq9PM2iA+ANH
         cav6zWgWa4a3MBPlXHb1mBhK7je96LYg7tJbXz4ewnyuRTOGfXdmdynrCx3e3sKzA2pT
         IzIg==
X-Gm-Message-State: AOJu0YzCRSa9pwbL2fyJ4tcZnc/scOWGDqokuq+0moRN1C+JyCAsy3Ll
	UfN1+vqK57+MkJ7wN9y3MfVfPy/1zCqzItOMXPk=
X-Google-Smtp-Source: AGHT+IFVeZ8vXYWhnBGyfV/KgjVLfGU5Z7P0BGZng+wE/kkg2N1Gs8oYDpbR6kKYicc5T59IDvb2Q5tOhWhHEnEGf4k=
X-Received: by 2002:a05:6870:70a2:b0:1bf:4a66:d550 with SMTP id
 v34-20020a05687070a200b001bf4a66d550mr14156616oae.52.1692119312436; Tue, 15
 Aug 2023 10:08:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230813211724.969019629@linuxfoundation.org>
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Tue, 15 Aug 2023 10:08:21 -0700
Message-ID: <CAJq+SaBA5tYcz_--oDvR=vG6dM7n_KRDO3hEzhomJmSMAAbGMA@mail.gmail.com>
Subject: Re: [PATCH 6.4 000/206] 6.4.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.4.11 release.
> There are 206 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 15 Aug 2023 21:16:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.4.11-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.4.y
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
