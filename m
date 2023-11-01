Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52DC51429C
	for <patches@lists.linux.dev>; Wed,  1 Nov 2023 18:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KVhsJyq+"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6b3c2607d9bso162305b3a.1
        for <patches@lists.linux.dev>; Wed, 01 Nov 2023 11:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698864826; x=1699469626; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=h3K1rBvCe1RDjJE7QSAQp/UtOiWZhcJnODORAKt3iL8=;
        b=KVhsJyq+Wmx7f61TBskDaTvj9s9DZUN8VBguZ2+Tb9K9fcCOxG7j6M0xyYOEkEe6mF
         ssLmHj2QQhhYeBkQ83hmcBJFGq3suSMsGTABWB7tysssn3uU0sYdGSOKgmNdfiofkZjK
         STtjB5V8LPSphjFwR77BR7V2ELkgqzKmZI2ns5umZ6FW46TiZOYejgkhNRl8wbel0WS4
         ImRdmisWJE4YCdX9iXorfLuFIOr2VAjPLihcG9N55pRSoz2ak9OqBTWTu5EFQ6Y6b8bV
         5b/4u78KAbFGhyTen+pzods2zPKh00BNVFOPjdqdc9nkRNNI7KNuDnWM3FaTMH0mU7Ec
         nExQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698864826; x=1699469626;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h3K1rBvCe1RDjJE7QSAQp/UtOiWZhcJnODORAKt3iL8=;
        b=t/SoJ+feJatqL47pd5j5Lpw8jNrSkLaQ4qqh+H55jobq+Je8yZfZosaCEmkQwiXok5
         abF9kpBHsX+MKKr3ShxpJCQm43gEkJuw1GWkmUNPOZV83h/CrWrQvCi50H3Ap/lVYGxC
         2AvG919nwUeA7SCPGmdu03ERrAMw1KH14BvUPanExiW0WVYELwXk3JsiNWdE5H5eBVzj
         DE2mvX9tmx7c0Mw1e9d8k+F9xk78Lcer7owtXyvISIIewKf51UQxUeQAmuZR8ZBDKZhs
         FbFeruJmjpOKrThZRj2WWAvJNL0Y662YIKSaO/vVhz/Y+/eHODsPn+Qk9HHucByhp5Gj
         A6MQ==
X-Gm-Message-State: AOJu0YyTz6AwqY8sD+8pX1Zbs1NL2OGEJYcIUhjKTgGFJ35YlCGet2US
	7oebBssmgvx3Bi/NfHJp1qCG6AebPyOyVfD7eIo=
X-Google-Smtp-Source: AGHT+IHUb/xh2GakawJLmcH1FQCQwst2XSWLVPekwlsf3O9cPOVcMHjrCcKRQ7Ul9uFnldF5hAiQJfpdD3pZRnWSuMQ=
X-Received: by 2002:a05:6a20:7f9e:b0:15e:bf2b:e6d3 with SMTP id
 d30-20020a056a207f9e00b0015ebf2be6d3mr17998491pzj.46.1698864826641; Wed, 01
 Nov 2023 11:53:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231031165918.608547597@linuxfoundation.org>
In-Reply-To: <20231031165918.608547597@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Wed, 1 Nov 2023 11:53:35 -0700
Message-ID: <CAJq+SaDrnwRQ7gFMchjx+8eQ3AbNH7EgszPOPmSrm5XaFg=05g@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/86] 6.1.61-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.1.61 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 02 Nov 2023 16:59:03 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.61-rc1.gz
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
