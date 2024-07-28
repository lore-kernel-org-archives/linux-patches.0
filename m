Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50CC2125C1;
	Sun, 28 Jul 2024 19:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722194044; cv=none; b=I4oYpXkSYHbc4s9DtCBinXYLgpr1IMKdoNO39qrJa8pa09LhDBwQZcS+A6oTqhww0REsrJ7pjRMKpenBOsHI3TVUYnOo+44+Kxi7XbmAJPGrI1x/POrNi+YgmFDiVCLqJNMwndKECqA2/BX4pcTlOlnJaONIOCfGvks+nh9mgsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722194044; c=relaxed/simple;
	bh=sMmbh7cUTqqovrR2AT6BBqOajFBHUkdjDZtKSwNRZH8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IVNL/4RUqJmXzfqLCGUxgyh6gO3A/MqoGsTbXWYxoJoZNpDFoRmpeVWukwIUte2aJ658TQSWR3TarXcXUqIz4CszGpEpfkO9/eN3FwLyejrjbydw3NqlA/z+5jaDEsEFF7Z8p82b/c98u94ZOs45LtajYNsbY/VLUDBQi3zmwUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R+rOGDyC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R+rOGDyC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEA25C4AF0A;
	Sun, 28 Jul 2024 19:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722194043;
	bh=sMmbh7cUTqqovrR2AT6BBqOajFBHUkdjDZtKSwNRZH8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=R+rOGDyCe/5nYkHqIkfoDxNCUuoXBD0w/ddqWWoF1jhS+B0Kyyuk2m3W5Q7WwKFWV
	 HbXJ3Kegb1sa2iHUflKafhsKDBBrSjNfcZOxQmrCmqsRXuDtLezhnPmzBaeYri/RA3
	 avGCIFWWgJX9vQri9/mHE74oVZ+ao9vDhuVVZsrPQeKzmHZ/pAd180RTlLCb2MYBXz
	 v1JbHi8QMBQ4b5WT/KcNvvgrF8gwEhmrr3sjnfEemv8lOFspEzRQNO5IldgpTGfQX7
	 k8aJDu0T5XZr7GDlnvV75DaOGAl+fpgBrzWXxtAqxH82LAVa4mWcwlgtcukGhKwyto
	 u0y1ulq4tUitg==
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-52fc4388a64so4604913e87.1;
        Sun, 28 Jul 2024 12:14:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUlWc3PqhNnSyui1C+G5Q3BIrxZ/1bBY9rSZYlsIBOk84TC1Yyy4emEVFJqNL8e1jxtxH/shgwc0I8snL+rpbYiv2+oR+eJSszZX6sv+kbgsEVpPgMTSvc7yzfebnA=
X-Gm-Message-State: AOJu0Yx6N7Q8rzecShDMEjMiFD2rTFxDcY4hQ6JJTwd5PsiJL1cS2kTC
	Vvy8Vo4ENjAuyboRm2eCiNwqbaO1XhAEgCuDAdtsVkfzdDtrLNWbuukh8cdBPa2A6G5F4U5DYnz
	TfS+KwvEtJbV+6eTanZlkPLS0gCw=
X-Google-Smtp-Source: AGHT+IEkz1TnHDlE9ler9A80e9defPOv4OL1EPJyuZN5JVOtMoef4fgodh9s71/x3g0iffQ+5rn3J1ZmWw+wvfxkaGI=
X-Received: by 2002:a05:6512:1289:b0:52e:f95c:8b with SMTP id
 2adb3069b0e04-5309b279f98mr4853691e87.16.1722194042594; Sun, 28 Jul 2024
 12:14:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240726-fix-x86-stack-protector-tests-v1-1-a30fe80e8925@kernel.org>
In-Reply-To: <20240726-fix-x86-stack-protector-tests-v1-1-a30fe80e8925@kernel.org>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Mon, 29 Jul 2024 04:13:26 +0900
X-Gmail-Original-Message-ID: <CAK7LNATWv-OJM0oW8qbMk-HL0GgRkYKcRt+yZadhHB3NGR22uQ@mail.gmail.com>
Message-ID: <CAK7LNATWv-OJM0oW8qbMk-HL0GgRkYKcRt+yZadhHB3NGR22uQ@mail.gmail.com>
Subject: Re: [PATCH] kbuild: Fix '-S -c' in x86 stack protector scripts
To: Nathan Chancellor <nathan@kernel.org>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, nicolas@fjasle.eu, 
	maskray@google.com, morbo@google.com, justinstitt@google.com, kees@kernel.org, 
	linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	llvm@lists.linux.dev, patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 27, 2024 at 3:05=E2=80=AFAM Nathan Chancellor <nathan@kernel.or=
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


Applied to linux-kbuild/fixes, and included in the pull request.
Thanks!



--=20
Best Regards
Masahiro Yamada
