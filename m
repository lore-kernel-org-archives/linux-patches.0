Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA3420FAB0
	for <patches@lists.linux.dev>; Thu,  1 May 2025 23:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746142698; cv=none; b=VT4iDTpomx/CrrSSW+wyeL92XtmLxXWOvzWt09aQ1e8lzIXKWpi5hWEf0v64Wz64IzXOkumlGmLg9nDJbf7mXeLM1d9xPh7RqAQKQEyV5I3ZRCzhnDF+2E+EevSqEGIHYfQVZ50+5QFjE12CwZpRUz+1BLH/qJLq+zXJYtQXooA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746142698; c=relaxed/simple;
	bh=0bE9+sg8qqZlZPymEWPsuaZnLc6tICoEgjFXMIsxwYc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AqcQqRneWXW5ljMQeVp2wWiurcH0llF7yOZyw0fCa9Yi0e2QbaE/04BDjQMERP6KT/f2KUZVIX+TIIPmqN5adQq55Wr/2NdKecIWLRKa1Q1zzaJtV6aq7wntOmS+ipEOKXt77uNcZRkL7x89k8m2SX0T0f32eeKipANnzYCGlDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JTx27Bku; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JTx27Bku"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-ace94273f0dso310338966b.3
        for <patches@lists.linux.dev>; Thu, 01 May 2025 16:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1746142694; x=1746747494; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gOH+RLxLUbard4BV8J+6a/3tBBv1bO45LVfQDoB6LRw=;
        b=JTx27Bku0pR8PqgNFo9DBe+C9xa9IiWM0URMf4Sf/VK5UKZrGwk7CdeKjbm/Q8gkRz
         4aEfRkLepgqCzFeZD9q4oD75Yqcx418xd793HzGz2BJZuEZzAA+WHNhyZYi/UZgpaMgd
         Qp1ABg2euUB+2tdmWSM3A7+pdJ5uxFYDvmNks=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746142694; x=1746747494;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gOH+RLxLUbard4BV8J+6a/3tBBv1bO45LVfQDoB6LRw=;
        b=Jv4f0WZcj5L41ZcAMtTOGXcJrIxB1H4xf9ryIiuTu6R8+feP0jCF8gX9Fdl+HYO2Mp
         uepXCf89rZYxIS5Ms8qHTcZmluOlFEH77HqwvFoTOrNRn8QkLreUR1yRZzOcPxAsME26
         Y1koA9/zFTkjq4Q6szRSGbfUlbqGrEgjx7zoPMKofhMlgaDl9YiO1bO6zsVyGziC7ITO
         41O1HSXRDvVTGX06gDsVL4Iqg5wueteX2pOQFn3j8RdvSNC+HOsrKO75OblSgT+90DKn
         FnN8Tnz/qLpn+eP684oYza8TZlXedNHpVZJ/ApwlzX5Vw6vchEnd8UOdvV8ZSNZOxU9f
         Ye2Q==
X-Forwarded-Encrypted: i=1; AJvYcCXbZiiK/goGWpxB4qCBdIx9rCL6zWJw90SLBEk2qFNKctPtagISq4nwhqOdN7xA/ZRm5E4UijRR@lists.linux.dev
X-Gm-Message-State: AOJu0YwB7iY6ZpS855wQ9N/OotP8q0Vb2PJY9S4rlkXi05HuPmr5Hvv4
	uHuOfRO63j7VkNymFJzIvS7kM5sbDpilhcQ+gMJw4/xjvU/uDXAN7HJNb5y0rE+wuNL2SmpmY2t
	6ZPc=
X-Gm-Gg: ASbGncvtA+v3moXtYdGWRIwF9NfkFAAr+nsGUzXr2rOpMjaxc1z52ROsUAHtey6r0Bh
	tSNfHdlZ9Cc7Zz7i7Z7+Hcl64Ovqu/h/nm67/T5o4o20MFuH6T6EQw0t4p9Qu/jAgJSe42/FKHZ
	jZcDcrWAcbg+KHkWa2ekosSDIMh6fu4xDLC7gJH1fzCG8FTfk0hsIeJ8gWN1TRIu/au48AQFYoE
	ZQR2M+KOIyH2AZlH+OtT1hhYMvk/e+9UU0a3tEKvxAmZjtR+ut1M34PW/12MseYZQ7d6deFy+tA
	bzNpJ6zeMwKMgWTmla2s15IONl/IxqYH1CifPzJBiurni/dhc/+KYqcgB9D0pdTXNxDhnUf1aKL
	xpa/pvfzZXuXQvSE=
X-Google-Smtp-Source: AGHT+IE2X+nL/zZ3dJZ04rWdhSChXPrF92U3HSKOnTCCNk4e4Bb25CS0yRWXPmvzH/1J/aSwwNVdtA==
X-Received: by 2002:a17:907:3d4e:b0:ad1:7858:a775 with SMTP id a640c23a62f3a-ad17addc0e3mr81590366b.28.1746142694326;
        Thu, 01 May 2025 16:38:14 -0700 (PDT)
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com. [209.85.218.51])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5fa777c74acsm299156a12.23.2025.05.01.16.38.11
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 May 2025 16:38:13 -0700 (PDT)
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-ace94273f0dso310332566b.3
        for <patches@lists.linux.dev>; Thu, 01 May 2025 16:38:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXtAM5VSRwxg5Jf1ejngIo2QkYCqCXdDGBEeY/2I8ZX+ZQDOK5v/yc+MoXzdvXabv+xp2y6nmAP@lists.linux.dev
X-Received: by 2002:a17:907:3c92:b0:ace:c225:c723 with SMTP id
 a640c23a62f3a-ad17ad1a245mr90568166b.12.1746142690891; Thu, 01 May 2025
 16:38:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250501-default-const-init-clang-v1-0-3d2c6c185dbb@kernel.org>
 <20250501-default-const-init-clang-v1-2-3d2c6c185dbb@kernel.org> <CAHk-=whL8rmneKbrXpccouEN1LYDtEX3L6xTr20rkn7O_XT4uw@mail.gmail.com>
In-Reply-To: <CAHk-=whL8rmneKbrXpccouEN1LYDtEX3L6xTr20rkn7O_XT4uw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 1 May 2025 16:37:54 -0700
X-Gmail-Original-Message-ID: <CAHk-=wikfj_JLqDQCc+AsymUije3Sm8h30zQeT4yieqRicFOzg@mail.gmail.com>
X-Gm-Features: ATxdqUFyafpfCSgNRMdjOdlgLHXvb-kQiDBd8FWFkiq24cJvTKf1aNAAYT-juyY
Message-ID: <CAHk-=wikfj_JLqDQCc+AsymUije3Sm8h30zQeT4yieqRicFOzg@mail.gmail.com>
Subject: Re: [PATCH 2/2] include/linux/typecheck.h: Zero initialize dummy variables
To: Nathan Chancellor <nathan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada <masahiroy@kernel.org>, 
	Nicolas Schier <nicolas.schier@linux.dev>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev, 
	stable@vger.kernel.org, Linux Kernel Functional Testing <lkft@linaro.org>, 
	Marcus Seyfarth <m.seyfarth@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 1 May 2025 at 16:28, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> How long has that been valid? Because this is certainly new to the
> kernel, and sparse does complain about this initializer.

Sparse is clearly wrong.

I went back to my old K&R book, and the "perhaps in braces" languager
is there in that original (ok, so I only have the "newer" ANSI version
of K&R, so I'm not checking the _original_ original).

I guess we might as well ignore the sparse problem, since sparse ends
up having issues with so many other newer things we're doing, and we
don't have anybody maintaining it.

             Linus
