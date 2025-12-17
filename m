Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52ED8336ED1
	for <patches@lists.linux.dev>; Wed, 17 Dec 2025 08:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765958806; cv=none; b=DNFfcNpuGuzbnOGY55emo7rw+CfBeRAylDP9Socga4t14a+Mm2iN0UrtHsAKRAkoEEKYaDfGZOwbfUvUylT7nwcW3rx4JtNGvMZyEJkDNaZSPX5b8ioV+LeKIWJ6mvjw71fwY6SfWyR8FcyrG+LTZ6+wLHCrGyZkK1/FOkzvxZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765958806; c=relaxed/simple;
	bh=bq7BliE/NjEHPTcJ+hqfuLZ5dvCT2Zv4pztbvHrgXi4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bxyBCrYlfD98uap1iGIrNRqu0lKAHp2mpJ3gxV5YYY+q9RLkF+AlqBql7NoRSBHlpsQDIjgU48LYbNwNR4DzDvnd6mYzT7GwbN4nb4Hp/QXy9LaMO19762I6B45/v0SANtVvbiACaf+XhNZJbuUOFek8muyOlpGF87GoNKLDe5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FaJM3QQh; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FaJM3QQh"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-c06cb8004e8so4582171a12.0
        for <patches@lists.linux.dev>; Wed, 17 Dec 2025 00:06:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1765958803; x=1766563603; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bdB/aSgFib9yNMnSjtnjVwQzHDWZlq9a/a2iwdeEH6I=;
        b=FaJM3QQhzph3MolSMO7F54jBf2hIJfModjifQ3KsnYEliVEGGBbraxUvsHOrBEhzl/
         iU3sUyUDo61ZN1/3MjjIMZza/bJkyCDclU5kQXzhrBPB/XreOMkpwkR4QaZEedojYKpm
         Z/jQadJv2F8WZe5zfxA4v7Cy7xwkMNwk6FofiFZo4YHXi1UmEqLTrnhfmZwn0K+zKT3x
         /SagCQ0jAYkOwO4mnUY0CqsPB6398AKxt7Kf47vL7MM+PSw9UCpB5ZrJk9hon0pr+VLv
         GcNs+ZpdCnLw+gBFN+uC4aHV/Q1ZxcxwU1aBeNB0m2brN84LIQiSitbvht4EvhG8jlEg
         T8Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765958803; x=1766563603;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bdB/aSgFib9yNMnSjtnjVwQzHDWZlq9a/a2iwdeEH6I=;
        b=U7zE0AGUJkb7sX8nFT/JN0kFz/mv4kx80f4KG4nhnfkoZlt416TygS/jCDfErCeDST
         OzayyYfS+o4bIrQR28M6PJtPo8wvM3DajVcwusDJHeU2Jy4tzUtL3RpZEuxA0Q3wfAak
         11Jm+JnYMJ2ck3IbSYGvM1EgI02DV7JBdeJSlo1PIwo4xV6BZdmgNmZkpyjVe4oazrYU
         CowZhW94lyBBypDyZ2yA1CTRyAODvE4Pk+B7mGCxVOAsq2v2NTxO+nYHd52TwmR6QEfo
         2608xEMkT3li3xGfKGBDXw8Q0tllNVzOIFS/lr3KIGAZmdOFEEqOWIDSVLVjpTzpWz/b
         TYfw==
X-Forwarded-Encrypted: i=1; AJvYcCUQfKSWKq27ZBqjMDEYXFvttXp/VcWjNmPSq9J7bZQatMLgmvMaB5VlZLWEecBTe7okEdta3E+1@lists.linux.dev
X-Gm-Message-State: AOJu0YxKdyRXbG47G/RzLIak4THfhtX1k+35VtuUyeWQSIVUfjOiIxqH
	f/kxMzxSdbrnSAIGtbEjcIhJgkZlF6fphXFggVpUXiL72Hv85gZTWPujKeJCMveNU6cwPHUbTw+
	rcJryEzAcHfkleJa0T5BcZy7XdxngYP0xhj8aFUBpeA==
X-Gm-Gg: AY/fxX5Fl/Dr4+J0UFgV/Wf4NEKuxUk3EG0CpJ3WVRLhlqz/JPZRiizfe6J6md35M0H
	x2TZJtOoRf1x8RHkHWhs3w1Qy4ogNm34+4/cF7B8fPofYBRzizVvbtF6zBpYdF0JSV/vK21hw9Y
	aP3UC8pIPjIZzZSOF2prqWsLizRvvVDlb2Ps3U6J6WDUbeJ0Wv7NCWOJAjY7VedDG5U+fKBuFpg
	fmyXfRK7f7Z3Vbug25YSz4N+O88SNTg8CdZTBmzD5tqo9z2c86WBrv0pDG1GRYMUndAYiHD6zE7
	80j3IKX0wUmtIJNDOG4hZ9cgrtZN
X-Google-Smtp-Source: AGHT+IETkt/jVd6uk/R3QClwG8B5S2yNELg/JhUbEoBFWBg/UTAAcaP0rqWFCRLlCLTgvIDR/ubLYtPnNiiQ7GZIBHk=
X-Received: by 2002:a05:7300:d10f:b0:2ac:1bb1:68ed with SMTP id
 5a478bee46e88-2ac2f85e863mr12003914eec.9.1765958802517; Wed, 17 Dec 2025
 00:06:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251216111401.280873349@linuxfoundation.org> <20251216195255.172999-1-naresh.kamboju@linaro.org>
 <2025121719-degrading-drainpipe-fb2e@gregkh>
In-Reply-To: <2025121719-degrading-drainpipe-fb2e@gregkh>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 17 Dec 2025 13:36:31 +0530
X-Gm-Features: AQt7F2rN0pF4kAzdVPk6eazQcFQyu-jClKs6CdNRybqUHycKnrNF6TQT-vGyPj0
Message-ID: <CA+G9fYvc==Vz83Kka7J84XHA-hhig0CKGHixRVBAzGDv-1BA7A@mail.gmail.com>
Subject: Re: [PATCH 6.18 000/614] 6.18.2-rc1 review
To: Greg KH <gregkh@linuxfoundation.org>
Cc: achill@achill.org, akpm@linux-foundation.org, broonie@kernel.org, 
	conor@kernel.org, f.fainelli@gmail.com, hargar@microsoft.com, 
	jonathanh@nvidia.com, linux-kernel@vger.kernel.org, linux@roeck-us.net, 
	lkft-triage@lists.linaro.org, patches@kernelci.org, patches@lists.linux.dev, 
	pavel@denx.de, rwarsow@gmx.de, shuah@kernel.org, sr@sladewatkins.com, 
	stable@vger.kernel.org, sudipm.mukherjee@gmail.com, 
	torvalds@linux-foundation.org, dan.carpenter@linaro.org, nathan@kernel.org, 
	llvm@lists.linux.dev, perex@perex.cz, lgirdwood@gmail.com, 
	Linux Kernel Functional Testing <lkft@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 17 Dec 2025 at 12:00, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Dec 17, 2025 at 01:22:55AM +0530, Naresh Kamboju wrote:
> > I'm seeing the following allmodconfig and allyesconfig build
> > failures on arm, arm64, riscv and x86_64.
> >
> > ## Build error
> > sound/soc/codecs/nau8325.c:430:13: error: variable 'n2_max' is uninitialized when used here [-Werror,-Wuninitialized]
> >   430 |                 *n2_sel = n2_max;
> >       |                           ^~~~~~
> > sound/soc/codecs/nau8325.c:389:52: note: initialize the variable 'n2_max' to silence this warning
> >   389 |         int i, j, mclk, mclk_max, ratio, ratio_sel, n2_max;
> >       |                                                           ^
> >       |                                                            = 0
> > sound/soc/codecs/nau8325.c:431:11: error: variable 'ratio_sel' is uninitialized when used here [-Werror,-Wuninitialized]
> >   431 |                 ratio = ratio_sel;
> >       |                         ^~~~~~~~~
> > sound/soc/codecs/nau8325.c:389:44: note: initialize the variable 'ratio_sel' to silence this warning
> >   389 |         int i, j, mclk, mclk_max, ratio, ratio_sel, n2_max;
> >       |                                                   ^
> >       |                                                    = 0
> > 2 errors generated.
> > make[6]: *** [scripts/Makefile.build:287: sound/soc/codecs/nau8325.o] Error 1
> >
> > First seen on 6.18.2-rc1
> > Good: 6.18.1-rc1
> > Bad:  6.18.2-rc1
> >
> > And these build regressions also seen on 6.17.13-rc2.
>
> Thanks, I'll go queue up the fix for this.

This build regression is across the 6.18.2-rc1, 6.17.13-rc2 and 6.12.63-rc1.

>
> greg k-h

- Naresh
