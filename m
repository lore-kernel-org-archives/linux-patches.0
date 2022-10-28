Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000B923A3
	for <patches@lists.linux.dev>; Fri, 28 Oct 2022 10:49:21 +0000 (UTC)
Received: by mail-wm1-f45.google.com with SMTP id r186-20020a1c44c3000000b003cf4d389c41so3572281wma.3
        for <patches@lists.linux.dev>; Fri, 28 Oct 2022 03:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RwtKvIgsWQUddFyHA+7csn8T24MsDcLDATdxH1tSNJ8=;
        b=qEtykyq7ZvlO93mFb2Ywy/JBkySHuWNDYocv706zVgePaaOa/XLO5TkBMmSNDRJyXu
         hLwAGZxfH9s28CufzHSxGiRXnABebBTWkg4ByhYf+lqWoYbVSxNa1m0LL+suHYle47Rd
         7hOE/mLHwhwIWMSqXZyrcX0IQy3kod6QXmAUGbwY7qsHIUy4hhdfWlBFbHfz36O/TKTz
         zVer0OJl8rrhGR4hMjUHNgPewBLRZ5z4O5w821xK1oN8luNl19C6K2jZkxUnGxxsKFYC
         hvQTuAvOUAwYq8e0uU9FaDYXVIUUO2BaoMD5itzzgzlOf9VlAjDl9NavHqhD2z+/4QvE
         7Ofg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RwtKvIgsWQUddFyHA+7csn8T24MsDcLDATdxH1tSNJ8=;
        b=hZ39/Zi596iN1i0En/eijq5cizFJkhBGWo+Z+BgHyVp2WUKF1fI+aUJtAJSM63QweK
         zFPmpUuuB+rw8tsQGxyv4AYTBhodWdkqJ0kkJweStHzet0d7Z95MKo3RmbW8EcGNKSGr
         xmyJ//UqygwL7QE+LxztXmSmfOv3fMAhNf3QZ3+jUwDXnqcKPqPaGeJzzX1krzUJl6Fu
         8f4l9J1hE3pcq1/gbPiVZ7fdXRud6dcEdsRVNkCVq4Xg3RWut0PfYGYWKJgmahxtER3s
         SGHOF2iJCsJwdotxeGWihZqskJ4Wed37Dz40I4sJ1mF8Ft23DX7z2ap5id4jP05LUkpo
         yYdA==
X-Gm-Message-State: ACrzQf1cMIK5Wp+U6xRPpypE/9cIgSZzql+9ZN5mINDsDHh/4Bz5XruQ
	wmQMwI2n+dzA4/7Csx3X68c=
X-Google-Smtp-Source: AMsMyM7jSlHdfzuiC68SehMUaVUkbXBv4TZCGrKBMpKl8QxJy4rJUWpA2XnSoh6mso4cH/fgDyQTng==
X-Received: by 2002:a05:600c:35cf:b0:3c6:e957:b403 with SMTP id r15-20020a05600c35cf00b003c6e957b403mr9488581wmq.162.1666954160237;
        Fri, 28 Oct 2022 03:49:20 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id m5-20020adffe45000000b002238ea5750csm4024602wrs.72.2022.10.28.03.49.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 03:49:19 -0700 (PDT)
Date: Fri, 28 Oct 2022 11:49:18 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 5.4 00/53] 5.4.221-rc1 review
Message-ID: <Y1uzrvWMM/lZBlBS@debian>
References: <20221027165049.817124510@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027165049.817124510@linuxfoundation.org>

Hi Greg,

On Thu, Oct 27, 2022 at 06:55:48PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.221 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Oct 2022 16:50:35 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20221016):
mips: 65 configs -> no failure
arm: 106 configs -> no failure
arm64: 2 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure


Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/2046


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
