Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com [209.85.222.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1B9200AE
	for <patches@lists.linux.dev>; Thu,  5 Oct 2023 14:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yZ3dp+bf"
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ua1-f54.google.com with SMTP id a1e0cc1a2514c-78f1210e27fso453837241.1
        for <patches@lists.linux.dev>; Thu, 05 Oct 2023 07:55:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696517714; x=1697122514; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4sb1q74MArJrmg1EnidKYrw9CtEuXNYc17Dl5pGnnhs=;
        b=yZ3dp+bfuN9hdjLd5Wc/xCIpeHzH3O6dODFH8eaS1Gm5g58h2ULR67yoA402DHuuPh
         BXTi+aLAT6rMnRNGuV35Li3r1709H87M164JsO0ZKGlvb5H9qVtCH0Kfj07osav8HIV9
         8Gm0IWlCXo59J65/f2UJ2dvanVXakfhIqsdvPnHxmBr2VfLw9HhucAie9Xg2HEuGDZy4
         /xEk/feZzLJ/76qwyKs6YWcgXbnPDiN/L397fTd2n30gJGnkUnkqDdjGL70jioBkNWSk
         4olFzcHi6qgCn04yCWjpKU2pfhJzZ//Pbss+lR5z4BqtTEOwi5IrPmx8SkIiED+kAy1/
         GAbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696517714; x=1697122514;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4sb1q74MArJrmg1EnidKYrw9CtEuXNYc17Dl5pGnnhs=;
        b=s4aMElDD3YHu0zOtZgzBbz5xihN43E7dflSXWb08beTAf6RBYMBuDL/HDv4gwVDWmx
         in/hx1vOXQlD71WH1OHgMlyIM5TBIA0HtIFsMVFAAHOfTEhjL3ilCVQJgXu26RscanxT
         wAt0T/rBg0Gj3IPZxFcnyPVXp/+fbe5lm/ftVdwLOfogAiQ+WohnTS/3gDWdmz3645Kk
         s5tWYJKjYr7sLOkKJidAcdhurQ/5LEAdCHYN+e9jqaXV1622xR1KHdZ09Zkz0lHoTuvz
         qcLWFhqW3s0kb8Aq5bV5u/D6xVEi9M8AQ5S4ZobI5+8LzTlAbKef0rleyNZKNGEK32eb
         10AQ==
X-Gm-Message-State: AOJu0YwX/xhpTkJWZMCE8ortiDBh579+KAlsTdXSTpfEBKrCm/JnYH0P
	kz2lUbokA5tXjqQKthuGytlOxEfJ/4+JsIuY1Kzw6A==
X-Google-Smtp-Source: AGHT+IEO+WrPrzg8wdQMFzOvFJCD6a5uz7Ox65W+J3MpViKFb5GfWKQNzse/Kl9U7x+Y2TA3B2fv/zljaBJT0SI57W8=
X-Received: by 2002:a1f:a9d0:0:b0:49d:92e0:9cd1 with SMTP id
 s199-20020a1fa9d0000000b0049d92e09cd1mr5188264vke.11.1696517713597; Thu, 05
 Oct 2023 07:55:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231004175229.211487444@linuxfoundation.org> <CA+G9fYuE9Pu3QCVDywA8Ss-41jVfiy2e2kpxjhpTe3CRgmZkBw@mail.gmail.com>
In-Reply-To: <CA+G9fYuE9Pu3QCVDywA8Ss-41jVfiy2e2kpxjhpTe3CRgmZkBw@mail.gmail.com>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 5 Oct 2023 20:25:02 +0530
Message-ID: <CA+G9fYvHPnba-0=uGS70EjcPgHht13j3s-_fmd2=srL0xyPjNg@mail.gmail.com>
Subject: Re: [PATCH 6.5 000/321] 6.5.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexei Starovoitov <ast@kernel.org>, 
	Hou Tao <houtao1@huawei.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	bpf <bpf@vger.kernel.org>, Anders Roxell <anders.roxell@linaro.org>, 
	=?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 5 Oct 2023 at 11:05, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> On Wed, 4 Oct 2023 at 23:53, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.5.6 release.
> > There are 321 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 06 Oct 2023 17:51:12 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.6-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
> The following kernel warning was noticed on qemu-armv7 while booting
> with kselftest merge configs enabled build on stable-rc 6.5.6-rc1.
>
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> > Hou Tao <houtao1@huawei.com>
> >     bpf: Ensure unit_size is matched with slab cache object size
>
>
> bpf: Ensure unit_size is matched with slab cache object size
> [ Upstream commit c930472552022bd09aab3cd946ba3f243070d5c7 ]
>
> [    2.525383] ------------[ cut here ]------------
> [    2.525743] WARNING: CPU: 0 PID: 1 at kernel/bpf/memalloc.c:385
> bpf_mem_alloc_init+0x3b0/0x3b4
> [    2.527241] bpf_mem_cache[0]: unexpected object size 128, expect 96


Anders investigated this report and picked up the following patches to
solve the reported problem.

d52b59315bf5e bpf: Adjust size_index according to the value of KMALLOC_MIN_SIZE
b1d53958b6931 bpf: Don't prefill for unused bpf_mem_cache
c930472552022 bpf: Ensure unit_size is matched with slab cache object size

- Naresh
