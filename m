Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B293B264637
	for <patches@lists.linux.dev>; Thu,  1 May 2025 23:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746142127; cv=none; b=jiv6lalNx4Hmv+C1Fd0W7v3xfziHvJ62qwQx9wZqgqJkgyXLI5eP/f48OLzgBOqvb0cD2fEHpTd8rDVV4tVWYjfmjOIsBzOGQAtXrQrPAYURgVJx3WGg9uWn/Ts2CSuyp9aiWuqA0QAkZ6t1dwS6zPk1I9Bj9mA4r/hROP+7lZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746142127; c=relaxed/simple;
	bh=TVZv1wE6IMiopn+lPutQ2XmVSkz9PSPheYWfp32DhNE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a01FHDZZo7CcxEkCByYwjR4Mk4ovsxRwhgNXwzrGtIL1g1MfUH7nbNcUlXjIgATAgrGnaqwyX/QmEL1234xuui7d3zdG6zefwmxme1e9ZLrQ+65yazv34OAJFglCuRnzrcSXyvxLGWCuZXGTZPkAgIgTZJeFVAOqhKvnXy9BaMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XYwjX7Qa; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XYwjX7Qa"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-ace94273f0dso309082366b.3
        for <patches@lists.linux.dev>; Thu, 01 May 2025 16:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1746142123; x=1746746923; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xLQxE0ZAajilS9LJlCgVNxjKesNL8CM31Y1I/hwFDe0=;
        b=XYwjX7Qa9e1s5S69qE5p9qcCpt7nTg/zOUtkaSyNKNpx34EFr80F7uMoeyuiWOg8nt
         byD0ZeeFxZsDUtst6pJGRgfrb4mJ4XBFXlvg+VUs4X+7R/uKnOvoxDlm+rRs3aCBpCZZ
         0aghnCBPHb82uu+nTJea24XCeducVqwwONZkc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746142123; x=1746746923;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xLQxE0ZAajilS9LJlCgVNxjKesNL8CM31Y1I/hwFDe0=;
        b=FHWtQ+S60i18vY7S1zqnk3FGvIR5TbPuO0n7ovRcibD6PQ1qcPh0XA0HV8SfgqOScr
         CYZT9o8D0QMyho16zJ7xW7pR69KDMep6y4GRTUhKWzoJ4wp1RL7aG22H52WEK5B+lr+0
         XDEaew2eTiFwGJAgNZehdubqWnbrUS6VUC7iiKqZi058LQbzjS0yivSOVxMqQuuIypPk
         NkBKlIT39xoQjWJXv3IJvqLkCeibqcr/d8niAOEpTU+PekIaEFALoJ00Rbv8VN02+Q4A
         sCoz0NM/STwtwfqTxZxKzSa3qGsIrPJEmqJ+vS7IaZuFMrSxw988qQIcUfkba5NF7a4V
         761g==
X-Forwarded-Encrypted: i=1; AJvYcCWKDRpG0uI/8f5Ic7XicXyohNADtit2lMzgIWvTfvIom1JIXyUyWJmmjcBGoCx5sJdtbb2ntwo9@lists.linux.dev
X-Gm-Message-State: AOJu0Yw9WeJfb9GqhEzjQ7wAp4xW6S+2emsou105A55VZCIKG0+QitOw
	8hyc5IBL9K5bBF7vVlNIVzoR/ruUwr/E57t5KDslnaShMOqlrIbLCcYBersJ4a5bZfPefoSsq9V
	FjGM=
X-Gm-Gg: ASbGncteS5OojiwMOt3ApUOa8gytnw7oWyvA5jZKHRHtttOV1Y3UxwCUzC6VveNJKCz
	4gz5cf2Tw8bfC0LoWN22MmlULIF0blav99/Dk5AolYRnPDnAs85TBCe3ul0y9eJwXXzdKH3BrRY
	z6RyXGKIbKqhZxXDJrG6qWrqglGfsTS1AriZq8KZdVvKMRV1XRInLKNtEuWWBFodIKjc7WmYJ0d
	gVNft666CdbbrPcKXr6MXejgCTG2KsdB02ZoKOwlc2cZf+PJcy2gZRWAXIyXfNNnCFnKt2FfKDU
	rf/skrbpXdPEMY/06yWKvSjIwzQTf/CblXiJaMzcTKQ6cIdVtwbypnkXgFpuicJ5iGJAPcwq4W5
	tM9VdqHQJAVx9Vkg=
X-Google-Smtp-Source: AGHT+IEhxhFgW2sWjJ77hvgpP0/jJwSKNhGLDscgjPaGNajLJtvaUZ677cjb7xYY4g2ddsCEytsW6Q==
X-Received: by 2002:a17:907:3e0d:b0:ace:dac2:880d with SMTP id a640c23a62f3a-ad17adae595mr81034966b.26.1746142122834;
        Thu, 01 May 2025 16:28:42 -0700 (PDT)
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com. [209.85.218.44])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad0da57f11csm108905266b.184.2025.05.01.16.28.41
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 May 2025 16:28:41 -0700 (PDT)
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-ace94273f0dso309079166b.3
        for <patches@lists.linux.dev>; Thu, 01 May 2025 16:28:41 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVT66d70USEREjctmPu3lumDm0EHDQuJ9/OEvi6UsvpBBFUK6uEVlOMo00UmIHZo0ImmGWff2s8@lists.linux.dev
X-Received: by 2002:a17:907:86ab:b0:ac1:df32:ac27 with SMTP id
 a640c23a62f3a-ad17afb8ab0mr88710966b.53.1746142121345; Thu, 01 May 2025
 16:28:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250501-default-const-init-clang-v1-0-3d2c6c185dbb@kernel.org> <20250501-default-const-init-clang-v1-2-3d2c6c185dbb@kernel.org>
In-Reply-To: <20250501-default-const-init-clang-v1-2-3d2c6c185dbb@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 1 May 2025 16:28:25 -0700
X-Gmail-Original-Message-ID: <CAHk-=whL8rmneKbrXpccouEN1LYDtEX3L6xTr20rkn7O_XT4uw@mail.gmail.com>
X-Gm-Features: ATxdqUGTUyHgnV_iTiKt6DDkeUKklvk9V4X7Te2h_qX7brrmy-_kNjuWcrlAGLY
Message-ID: <CAHk-=whL8rmneKbrXpccouEN1LYDtEX3L6xTr20rkn7O_XT4uw@mail.gmail.com>
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

On Thu, 1 May 2025 at 16:00, Nathan Chancellor <nathan@kernel.org> wrote:
>
> +({     type __dummy = {}; \
> +       typeof(x) __dummy2 = {}; \

I'm actually surprised that this doesn't cause warnings in itself.

The types in question are not necessarily compound types, and can be
simple types like 'int'.

The fact that you can write

       int x = {};

without the compiler screaming bloody murder about that insanity blows
my mind, but it does seem to be valid C (*).

How long has that been valid? Because this is certainly new to the
kernel, and sparse does complain about this initializer.

So honestly, this will just cause endless sparse warnings instead. I
think disabling this warning for now is likely the right thing to do.

                Linus

(*) Yes, the empty initializer is new in C23, but we've used that in
the kernel for non-scalar objects for a long time.
