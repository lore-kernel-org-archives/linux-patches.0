Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF386FC5
	for <patches@lists.linux.dev>; Mon,  6 Mar 2023 19:33:54 +0000 (UTC)
Received: by mail-pf1-f182.google.com with SMTP id cp12so6583361pfb.5
        for <patches@lists.linux.dev>; Mon, 06 Mar 2023 11:33:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678131233;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C7AQFc3LtW9Lbl6pASToCJCN49VYg0IVzRV+aopA7R0=;
        b=lX6Kq32L7kysvwkv0O9qBGe6oFp8KQFy0gzkEf+oQYiD01LHgCbmfukA7qQu0tVB14
         UkRa9CruMi6ymFEZfM3NNHInKaDjLlDsKJa4k6wMiQapb77Ggzcw+E8fVSuOwdwJuWJ7
         GNPalzre1ndxLDK69qy04r+LBtTLh+hVQSfTvfm0x511eHiLx8Mh3U5PvRAzGzK0atb1
         YTxEpfyJ9N2uqXwiPHXbKMc9WZ3n7LZrO90tpj9kxXvxyPYHj/fTKIJR9vhWyDTHdSha
         kdwI6Qsnsz31WSLOZuVhI34BgYFB8UGg9X2K44hh+QJVzko+z/Csqj/8Abost5NH9zuT
         8iZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678131233;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C7AQFc3LtW9Lbl6pASToCJCN49VYg0IVzRV+aopA7R0=;
        b=Bvq8fs6ks+QeQsv5ubOkN/APTkeuismGZf46T0ZCfouTsTytl8cygF7LfepIjXpuwZ
         UYcDi5Dqp3yVMyyc8sQwkMi00oPKI0enwjd7vMiPljIKnaqjtt4A93g2IcE0RO9DIhXQ
         1wxF/HD93F63/yKT6o8edBIO1rytHuYKO7SQ7j9Kja90GgEgj94osCBWhUcrZIRuCb0O
         6yMFiw9fRb5wcEY+VZjShZ2rb9YS4iPViEUv1zSK7Nt2e/HiTUp4z/b19TTbMysFwNrC
         2AnEyRaBcN9kizjPZPO1flZl5coIC27wyTRAEnPp7RaXf23Lv/k9ark127b7qNTCWGEK
         +5CA==
X-Gm-Message-State: AO0yUKXCF1K7C+0EQVxzVTc19b99VebQDIYJtKeHP7K/nqvY0Uo+qvym
	M5idyEQGuRX7HhktewZKf54Rkx1FE9SXbBgn2GRgtw==
X-Google-Smtp-Source: AK7set8eWmi5aPInvKjDHJn3kJ57Ju1XKRFVH+BoMz9PzaJk6QQag0QUL9fV8tGcvfeJb3jpLQa8164OFUla1hBZPhw=
X-Received: by 2002:a63:5904:0:b0:4fc:7e60:d0c with SMTP id
 n4-20020a635904000000b004fc7e600d0cmr4033113pgb.11.1678131232887; Mon, 06 Mar
 2023 11:33:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230306191712.230658-1-ojeda@kernel.org>
In-Reply-To: <20230306191712.230658-1-ojeda@kernel.org>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Mon, 6 Mar 2023 11:33:41 -0800
Message-ID: <CAKwvOdn2dwMheFdzmvVdEdMUxw5Kz6OxXp-CW1Z84OJ=ME2Z7A@mail.gmail.com>
Subject: Re: [PATCH 1/2] docs: programming-language: remove mention of the
 Intel compiler
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 6, 2023 at 11:17=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> The Intel compiler support has been removed in commit 95207db8166a
> ("Remove Intel compiler support").
>
> Thus remove its mention in the Documentation too.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Thanks for the patch!
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>  Documentation/process/programming-language.rst | 5 -----
>  1 file changed, 5 deletions(-)
>
> diff --git a/Documentation/process/programming-language.rst b/Documentati=
on/process/programming-language.rst
> index 5fc9160ca1fa..10dc772671d8 100644
> --- a/Documentation/process/programming-language.rst
> +++ b/Documentation/process/programming-language.rst
> @@ -12,10 +12,6 @@ under ``-std=3Dgnu11`` [gcc-c-dialect-options]_: the G=
NU dialect of ISO C11.
>  This dialect contains many extensions to the language [gnu-extensions]_,
>  and many of them are used within the kernel as a matter of course.
>
> -There is some support for compiling the kernel with ``icc`` [icc]_ for s=
everal
> -of the architectures, although at the time of writing it is not complete=
d,
> -requiring third-party patches.
> -
>  Attributes
>  ----------
>
> @@ -38,7 +34,6 @@ Please refer to ``include/linux/compiler_attributes.h``=
 for more information.
>  .. [c-language] http://www.open-std.org/jtc1/sc22/wg14/www/standards
>  .. [gcc] https://gcc.gnu.org
>  .. [clang] https://clang.llvm.org
> -.. [icc] https://software.intel.com/en-us/c-compilers
>  .. [gcc-c-dialect-options] https://gcc.gnu.org/onlinedocs/gcc/C-Dialect-=
Options.html
>  .. [gnu-extensions] https://gcc.gnu.org/onlinedocs/gcc/C-Extensions.html
>  .. [gcc-attribute-syntax] https://gcc.gnu.org/onlinedocs/gcc/Attribute-S=
yntax.html
>
> base-commit: fe15c26ee26efa11741a7b632e9f23b01aca4cc6
> --
> 2.39.2
>


--=20
Thanks,
~Nick Desaulniers
