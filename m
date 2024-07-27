Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34AE7358A7;
	Sat, 27 Jul 2024 20:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722112995; cv=none; b=o3GAfFZFTK99xf2Qrm0omN03CLJ3maekBejTR6x3/h7r9rl3FXcvsJa9rLqEn0OouE+7X60HRsrcQmIgDWPZEMjIsIaa0usdY3Nt+AlNTBYd6TYB0vf8UqLGILFOiQH7s3VpKyAiduEBILmm05vsNJtIoAg2TILr7akbO9wvaEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722112995; c=relaxed/simple;
	bh=pCLrAC0c7kI1WPvw+F3AOPdqNfHw/TdcPzhDI1T0wGU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=abDA6NZgDlYS9MxRQsi+biQw/t9ygowrXGW0Nkm1RH674U7gxUjLN14OgbSk/aHCrv3nNj2eVRDIONqXSiTj+m7mFQGhuiBgNd+ENEyw5r/ayhebeMTcHEIMU9+PNac/L6klxIuY6n1lxjAphcZmhr4BwgRcMqg0tgfwSsrCxk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eAeOyj9g; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eAeOyj9g"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-52efef496ccso2291465e87.1;
        Sat, 27 Jul 2024 13:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722112992; x=1722717792; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bv4ok3GIewx2d9Yx1/BgjuhSzkHnMJiT1FqXF1qlCKw=;
        b=eAeOyj9gLOn8cXcmzt3MA7Zip1vn37/JELYZGhXP1vLOOXqkA3ZlgTSk5Q7tKcP4+r
         ByKCzhdzQP/8avT2wzjw4k5UulHLFwsSeFx4DjSUhF8vle0wVSo2StdDJ5XbFU8/U4yr
         1psVph6jpVu/1/5Yhh9viTAurh+AxipmpW61ulzxkcvuDzUAvDasoJNUpnWKTTFfSfrZ
         DP2be0+yfUAW/ZIvu4Yg0u+8amA0M+TlIQZc7BCPX+I75NdlpaQXGQ41OcuNHweNsNSc
         kqlp2GLlO0X8g1aXMkISw+57Qzuom049qWfZX1PHeVLJ8WSI2Hx03flinHWUoKLnEtxm
         NCmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722112992; x=1722717792;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bv4ok3GIewx2d9Yx1/BgjuhSzkHnMJiT1FqXF1qlCKw=;
        b=EwGqViliMKFt8UHBYBH96+D1D+RK1CVJP8aJtSOB+OoXiZjVve4RulaB6B9gWYyYDA
         z2+aXRtW6v0Y4N/MnEfTaYpJo5mTjvv1WpRw42mdmJefU0FBD9r41VmBC3SFEG5Jcul1
         pq5XtDW7YuZilC9xaPKgrPjSSOn9H796ZW1AIT55atAMr1IUb/jvf6qm54UzXX99tgET
         NxYUjomNxaN2+l9nft65+R8oIdHLD1QK10uKpaj9D6eHz4cmPC1XkZ9QPIyogUSv7IW8
         oIwr9fcP+wQAKly77nyfzDE/WcA3BtwKistf4Guow2VLo9UnouXR73ywGm+eA34cntTM
         Fjwg==
X-Forwarded-Encrypted: i=1; AJvYcCVXd1KcQbtvWgYnC1jf5bWkHJ4SRoY62uFVcGhH7gnOviJT5nDYTg1JsQBn3jv187OrQHnUG+x63VHwHQ1Cxg89SnGVJ4J/tnhot1x0yxSgG/FK0/KpoWQckJJ2eMo=
X-Gm-Message-State: AOJu0YwJcCiap/pWA/ar6XIaWomWQxvyOM9ie2ckpEXl/6IGy8oY7w1f
	YguQ66iFJZQPSxMwZ4rtcKY9az4qpV2ThRUnIM0hbd/BAHpT8pAZFPITQUKNGFaiP9lYea5BtMV
	qr296RFV+a9bd4Fu5XVPDakh/jw==
X-Google-Smtp-Source: AGHT+IGP71xKWMKOJHw+6eAC+0bfS2GCggw5OubOUU2ooeGmpjLgTwO9dToD28ptkFTPF8afYXAbZ5d0nh1LLHWoUjg=
X-Received: by 2002:a05:6512:3ca9:b0:52e:8161:4ce6 with SMTP id
 2adb3069b0e04-5309b718bebmr1011788e87.25.1722112991729; Sat, 27 Jul 2024
 13:43:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240726-fix-x86-stack-protector-tests-v1-1-a30fe80e8925@kernel.org>
In-Reply-To: <20240726-fix-x86-stack-protector-tests-v1-1-a30fe80e8925@kernel.org>
From: Brian Gerst <brgerst@gmail.com>
Date: Sat, 27 Jul 2024 16:43:00 -0400
Message-ID: <CAMzpN2hRVzWOF5YDvE8pPKfogdcuou8REsY+uXzkdORnFn=buQ@mail.gmail.com>
Subject: Re: [PATCH] kbuild: Fix '-S -c' in x86 stack protector scripts
To: Nathan Chancellor <nathan@kernel.org>
Cc: masahiroy@kernel.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, nicolas@fjasle.eu, 
	maskray@google.com, morbo@google.com, justinstitt@google.com, kees@kernel.org, 
	linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	llvm@lists.linux.dev, patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 26, 2024 at 2:05=E2=80=AFPM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> After a recent change in clang to stop consuming all instances of '-S'
> and '-c' [1], the stack protector scripts break due to the kernel's use
> of -Werror=3Dunused-command-line-argument to catch cases where flags are
> not being properly consumed by the compiler driver:
>
>   $ echo | clang -o - -x c - -S -c -Werror=3Dunused-command-line-argument
>   clang: error: argument unused during compilation: '-c' [-Werror,-Wunuse=
d-command-line-argument]
>
> This results in CONFIG_STACKPROTECTOR getting disabled because
> CONFIG_CC_HAS_SANE_STACKPROTECTOR is no longer set.
>
> '-c' and '-S' both instruct the compiler to stop at different stages of
> the pipeline ('-S' after compiling, '-c' after assembling), so having
> them present together in the same command makes little sense. In this
> case, the test wants to stop before assembling because it is looking at
> the textual assembly output of the compiler for either '%fs' or '%gs',
> so remove '-c' from the list of arguments to resolve the error.
>
> All versions of GCC continue to work after this change, along with
> versions of clang that do or do not contain the change mentioned above.
>
> Cc: stable@vger.kernel.org
> Fixes: 4f7fd4d7a791 ("[PATCH] Add the -fstack-protector option to the CFL=
AGS")
> Fixes: 60a5317ff0f4 ("x86: implement x86_32 stack protector")
> Link: https://github.com/llvm/llvm-project/commit/6461e537815f7fa68cef068=
42505353cf5600e9c [1]
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> I think this could go via either -tip or Kbuild?
>
> Perhaps this is an issue in the clang commit mentioned in the message
> above since it deviates from GCC (Fangrui is on CC here) but I think the
> combination of these options is a little dubious to begin with, hence
> this change.

As part of my stack protector cleanup series, I found that these
scripts can simply be removed.  I can repost those patches as a
standalone cleanup.

https://lore.kernel.org/lkml/20240322165233.71698-1-brgerst@gmail.com/

Brian Gerst
