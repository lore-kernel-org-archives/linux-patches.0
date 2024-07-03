Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB3C143C6B
	for <patches@lists.linux.dev>; Wed,  3 Jul 2024 12:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720010112; cv=none; b=lRoTxYg5b2MDyRevazwURLb0wsi2fAq7swyeEXn9Od7mlBr8crbV2H46ZiKdohfT2bg8HGCKjD/Ccrig8csic+cDMtLSTmYpe59Twxit42CWsjLCx8rTrKRBwK1lb7kmusUqiwHm/SN2FMNNv8kDZWDX1tTbjFRJoA5C+wr9AGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720010112; c=relaxed/simple;
	bh=cfGy4hd/MJDQaAlZyWKj8dMD+MgtojL710RreopYNk4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uaT+TNPYHP+1j3hQkwsRrV/bdwkEp02/5JZiWmrBgd/GGrPtoUlBbDCAq6nMchIAQ9Eg6FLYsCVDYePH+XTRFLRf4Hk2xo+ybHhnGmDirzi+iwfYY6ouPgUn63n2itzRSYdDVBO6G0/EeKFv9swz7SMOylVVailp5nVJDtnGWT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=k+UJQfFr; arc=none smtp.client-ip=209.85.221.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="k+UJQfFr"
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-4e7eadf3668so1949713e0c.0
        for <patches@lists.linux.dev>; Wed, 03 Jul 2024 05:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1720010110; x=1720614910; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Pj8SrAjLpSLjliuG99WdKny0d1AT/67yDFEWTU/8uKo=;
        b=k+UJQfFrrb7lwPTExGeHxU3pb4d9zh/AGQTlT6lh9AlgTQhzVNakihx3L/qVfG2xVy
         LiiRrPHFlcq868AVHmuwJXf4hO9cuA2v1IM049YbIvXEuntnXTP98gtQmCsftDcErx/y
         rkh5dErVjJcmp5XuODeqFJrd/UYA6ywiqFhw6cbI61qyecJaIXt8wzDcHA/vwAx4p8J3
         86uKZMYbMPl0GboGX8Q0FAstzd0GklkLpTLa/szRIo7Pg6B2TcpWE3uJsm5qFUpzlXUW
         F702b+6J/6raj4opdV0mHQQLMWFUXQwUl11m5v3+y2geAoW7m++vdHWEztOcU2h0BdVG
         UzRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720010110; x=1720614910;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Pj8SrAjLpSLjliuG99WdKny0d1AT/67yDFEWTU/8uKo=;
        b=wUGzw9dVin0Xllui+KA3ZAp+c+ppwRwOxv5RpPp8x1p1gH97YKtMDvA5TIj3nK1rwH
         sP45hvZ7z9hmbO8f1v0LR5EWq2yPhZCj/Bz/udRLlxQW9Lu66VsNTS+cbc8m1OpjSa8d
         3nNKn4CQkAiTXjKSX/kS2FNIuZGRgsZU/c4MkaAPwwLjWtcKo+nlPHP4Pf4krhknqc4S
         vmaVpM8UvBxMS/LN3rDmsFnPQY/09piGjEqgGYH5WT16IAeMQCUX7NNuKQwmDo6S2vtD
         48iG7+2erLfHYG6ptICQV0rFsyUqzy+tt4ChSsfngRsd7v7PCUdYmN/fcbRouClmphq2
         XTqA==
X-Forwarded-Encrypted: i=1; AJvYcCUlbGOqmsW3qzIHz0edOiKwG05X//juEgJ9Tg2lpOlnZofepuB8JakmbFadQJLo589Dxour6dQYvDkvlD8TmcU1hwGAwRRrYA==
X-Gm-Message-State: AOJu0YxfsiKqTEWOa0C+w2WmZVareITvaX+AghkY59eWUZZS/pMmERW+
	DmNVkaSlVbs2jit/9Li8D8Oq3JhGlWFmGR22QxKCB56+FgufA24ibQACn1e2O1fX+qJJ7UcRlpG
	8unuzO4Lqa7aeKCV/x9wwP1X29izVXOdrMVeYvw==
X-Google-Smtp-Source: AGHT+IFC2Ceua1RohvvkAIKkyjcpb3zdlon3mgykMv7og6AVgIzZvwsefW9dPMvY1y6HF6Y22NRmSxg3gPVSzvwQPTc=
X-Received: by 2002:a05:6122:4287:b0:4ef:58d4:70f8 with SMTP id
 71dfb90a1353d-4f2a572cb78mr13958132e0c.13.1720010109406; Wed, 03 Jul 2024
 05:35:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240702170233.048122282@linuxfoundation.org> <CA+G9fYs=KkeYFMS01s3VZmeSYd1zJphinPFCk1G2AJ7LZ=+8=A@mail.gmail.com>
In-Reply-To: <CA+G9fYs=KkeYFMS01s3VZmeSYd1zJphinPFCk1G2AJ7LZ=+8=A@mail.gmail.com>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 3 Jul 2024 18:04:57 +0530
Message-ID: <CA+G9fYvcbdKN8B9t-ukO2aZCOwkjNme8+XhLcL-=wcd+XXRP6g@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/163] 6.6.37-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, Christophe Leroy <christophe.leroy@csgroup.eu>, 
	Kees Cook <keescook@chromium.org>, Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 3 Jul 2024 at 14:27, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> On Tue, 2 Jul 2024 at 22:48, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.6.37 release.
> > There are 163 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 04 Jul 2024 17:01:55 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.37-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
> The following powerpc builds failed on stable-rc 6.6.
>
> powerpc:
>  - gcc-13-defconfig
>  - clang-18-defconfig
>
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> Build log:
> ---------
> arch/powerpc/net/bpf_jit_comp.c: In function 'bpf_int_jit_compile':
> arch/powerpc/net/bpf_jit_comp.c:208:17: error: ignoring return value
> of 'bpf_jit_binary_lock_ro' declared with attribute
> 'warn_unused_result' [-Werror=unused-result]
>   208 |                 bpf_jit_binary_lock_ro(bpf_hdr);
>       |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> cc1: all warnings being treated as errors
>

Anders bisected this down to,
first bad commit: [28ae2e78321b5ac25958b3fcae0dcc80116e0c50]
  bpf: Take return from set_memory_rox() into account with
bpf_jit_binary_lock_ro()

- Naresh
