Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F8579CC
	for <patches@lists.linux.dev>; Wed,  5 Apr 2023 20:48:02 +0000 (UTC)
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5027f1ed489so856578a12.2
        for <patches@lists.linux.dev>; Wed, 05 Apr 2023 13:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680727680;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gar2SeDIgd9oWPuJFUbMEAp6q8OZkPojCAqDAzQ9Ib8=;
        b=eD9znuZhuILxcgVJJecjtuePLidQ8BiBdA9QFon9SZpy/fGUFiBRz39EvdoB4bRYtD
         Ef3Lp0PnIV9u5HVChUC9BnCVD7BSr9K8brztFgIM+4m7o64rt8QXVgkLAysOeBNJxTGT
         7S4B7aB1uhpLVmH7+9k68YqumQMRiASrD3DXTLUjSFEsWRoh2oatilPzFmNX6fc7qv2z
         Hg841jEEV/8/I48Y6rzzNnqEeIJe391m/KlN92GYv7z2fX9eOF95eN6UOSWo74JuT6Iq
         JGFiILRN8+3K0C5oiC0NjYOiFdm9KXQOjvKKnGsL5W7qOwMPnAe6rBfwT2LREnsbIHGN
         Prxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680727680;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gar2SeDIgd9oWPuJFUbMEAp6q8OZkPojCAqDAzQ9Ib8=;
        b=IdHm6borH3ibrVcDXt5uV7zY4BzZh5O5t564FudhRK31GAHAeb0h1mWoCxjKtFwx3L
         OH2f2+OZNGiD7M6WxfXdmnRS669P/ieJzrUlo+BcFh58FkMXJuky3NipWeMxm8coHdgn
         ic+LzFEzUy4fzEOwq1yvVWGEZkd0c741FQPz3ZsAYDxv7SWOJ0KuYICoFT5d1WF/LEFf
         EN2rHtedvXRb/N7chpF72IDq/L8G585TFOhIrAwiS4qu5e+0+ccs9c/acOZJksIloCFm
         eEEBnEAlFTM4xjx6b3u1BcMsy17oY/EKSdF4OHw6LEnPObkGtVyhrjncsN4t5j7IT6Ma
         q5Mw==
X-Gm-Message-State: AAQBX9c9nXkOyhWKEfjT7rQS/A+gPOoZJnnF66mfUWcYVHAeotANClzT
	Xu5fK/Ok2+wkzhPTG+/LZhdk4I8dFaUkntnPJxZ2
X-Google-Smtp-Source: AKy350b/2tIT+e5QlFHEXhYsP01fC6fj0DfEQOEvWRjfflFPrhmacJNsGrlHJlO4vRKfn452es59o8bqrjpYSjzmRcE=
X-Received: by 2002:a50:9fc7:0:b0:4fa:123:3b32 with SMTP id
 c65-20020a509fc7000000b004fa01233b32mr1930469edf.7.1680727680545; Wed, 05 Apr
 2023 13:48:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230405-korg-llvm-tc-docs-v1-1-420849b2e025@kernel.org>
In-Reply-To: <20230405-korg-llvm-tc-docs-v1-1-420849b2e025@kernel.org>
From: Bill Wendling <morbo@google.com>
Date: Wed, 5 Apr 2023 13:47:44 -0700
Message-ID: <CAGG=3QX65iJEtvMiSD2Ju18f0KfHsi2zPXAQDSh0ScqbCLv=Cg@mail.gmail.com>
Subject: Re: [PATCH] Documentation/llvm: Add a note about prebuilt kernel.org toolchains
To: Nathan Chancellor <nathan@kernel.org>
Cc: ndesaulniers@google.com, masahiroy@kernel.org, corbet@lwn.net, 
	arnd@arndb.de, keescook@chromium.org, trix@redhat.com, nicolas@fjasle.eu, 
	llvm@lists.linux.dev, patches@lists.linux.dev, linux-kbuild@vger.kernel.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 5, 2023 at 1:44=E2=80=AFPM Nathan Chancellor <nathan@kernel.org=
> wrote:
>
> I recently started uploading prebuilt stable versions of LLVM to
> kernel.org, which should make building the kernel with LLVM more
> accessible to maintainers and developers. Link them in the LLVM
> documentation to make this more visible.
>
> Link: https://lore.kernel.org/20230319235619.GA18547@dev-arch.thelio-3990=
X/
> Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  Documentation/kbuild/llvm.rst | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/Documentation/kbuild/llvm.rst b/Documentation/kbuild/llvm.rs=
t
> index bfb51685073c..3e1f67b05ca6 100644
> --- a/Documentation/kbuild/llvm.rst
> +++ b/Documentation/kbuild/llvm.rst
> @@ -171,6 +171,10 @@ Getting Help
>  Getting LLVM
>  -------------
>
> +We provide prebuilt stable versions of LLVM on `kernel.org <https://kern=
el.org/pub/tools/llvm/>`_.
> +Below are links that may be useful for building LLVM from source or proc=
urring

s/procurring/procuring/

Otherwise:

Reviewed-by: Bill Wendling <morbo@google.com>

-bw

> +it through a distribution's package manager.
> +
>  - https://releases.llvm.org/download.html
>  - https://github.com/llvm/llvm-project
>  - https://llvm.org/docs/GettingStarted.html
>
> ---
> base-commit: 7e364e56293bb98cae1b55fd835f5991c4e96e7d
> change-id: 20230405-korg-llvm-tc-docs-84304e881bc5
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>
>
