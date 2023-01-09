Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92435221
	for <patches@lists.linux.dev>; Mon,  9 Jan 2023 20:54:36 +0000 (UTC)
Received: by mail-pg1-f182.google.com with SMTP id f3so6764603pgc.2
        for <patches@lists.linux.dev>; Mon, 09 Jan 2023 12:54:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bCpbMmW0eLev9FdtuyFUocFIcOdmXfyBWebTqFK5CIA=;
        b=h4agD+4jNY3gjy2SULguao1y1SDRTBALR9O8Bjx0eLoYRsDA2ETD9q9AMY5zysnq+q
         6GujFw61YQklfxifLoM25/Qx27WxO+muJS7gQ2/y584ocSmZlbkb+YerHNikmmopMt8Q
         8rlV/PMlrHVvPBQwSUX45mQgkl/lnEsPItg7VmFwxpKVkQ0wxzMolPIiKpSrMm9vWf91
         BdnidegVeoi+AAnpJEtgYYuR8Hj6cvvQ4gLOYJJiMwV7jAU647pgrMmjixSWC4tlr/XH
         6G2iG/BNRvOLrlnG/a3jkymflXl2P3YV8Dio+cecoWhApoEiT0ZHCb/LmhkfF6l0Q1eF
         Zn0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bCpbMmW0eLev9FdtuyFUocFIcOdmXfyBWebTqFK5CIA=;
        b=0MLUQrrbQyh32idfGZs7Lk0c2dIZirTI9Exe7VEIrQhLaNy/sMAAxH3VGGeLoTwU2r
         V2RkBZNx5KatWHvcZhNTslYtuuHIWhkRv+ZXDMqnvfzhGbvU7uwoMkcNxVqs506t18rt
         LsmgUg4bTRl1SSM+nTKrRGNVhSQVOUdN8gNvb1BJTDie2XyxsEDYtungMlKJbEhMiU7L
         MotgJw9N04iZlcpuAgBLjPkutPl6dVp4/Bwg8vr2Y3Q913Gb/rOfd4BXX0IT2G1j0HO5
         VH3jtxWG7i5z6XZ81XCxfbDV9iv57DKfrNmrIpdMHmGTaOarGMJMsWsrDz36OSt/DFjw
         ZFoA==
X-Gm-Message-State: AFqh2kpN0DJzwU6/YtWKO/JuICclatdI2WiZrHPn+ZR2IsIDaM39haoT
	45WkFvabXYqBy270nbnKcQmDV9kVMfG/1Czvny6ZxQ==
X-Google-Smtp-Source: AMrXdXtJwhfbhqPtlK+wteYA6wJbhqZXNYUZFPHzEbZJNaISXYOe+1yfLa+PUkvrtxjs8n0M+KBV1ndODf+qq8fq670=
X-Received: by 2002:aa7:914e:0:b0:578:202d:a33a with SMTP id
 14-20020aa7914e000000b00578202da33amr3345635pfi.23.1673297676007; Mon, 09 Jan
 2023 12:54:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230109204520.539080-1-ojeda@kernel.org>
In-Reply-To: <20230109204520.539080-1-ojeda@kernel.org>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Mon, 9 Jan 2023 12:54:24 -0800
Message-ID: <CAKwvOdkr6mAdNOkZqGdkosAN6JABHRU3bHg=K8ujjbw2GxEsKQ@mail.gmail.com>
Subject: Re: [PATCH 1/6] docs: rust: add paragraph about finding a suitable `libclang`
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, linux-kbuild@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, Jan 9, 2023 at 12:45 PM Miguel Ojeda <ojeda@kernel.org> wrote:
>
> Sometimes users need to tweak the finding process of `libclang`
> for `bindgen` via the `clang-sys`-provided environment variables.
>
> Thus add a paragraph to the setting up guide, including a reference
> to `clang-sys`'s relevant documentation.
>
> Link: https://lore.kernel.org/rust-for-linux/CAKwvOdm5JT4wbdQQYuW+RT07rCi6whGBM2iUAyg8A1CmLXG6Nw@mail.gmail.com/
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

This is super helpful for me, since I build clang from source and
would like to use my libclang.so! Thanks for this documentation
Miguel!
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>  Documentation/rust/quick-start.rst | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>
> diff --git a/Documentation/rust/quick-start.rst b/Documentation/rust/quick-start.rst
> index 13b7744b1e27..cae21ea7de41 100644
> --- a/Documentation/rust/quick-start.rst
> +++ b/Documentation/rust/quick-start.rst
> @@ -100,6 +100,23 @@ Install it via (note that this will download and build the tool from source)::
>
>         cargo install --locked --version $(scripts/min-tool-version.sh bindgen) bindgen
>
> +``bindgen`` needs to find a suitable ``libclang`` in order to work. If it is
> +not found (or a different ``libclang`` than the one found should be used),
> +the process can be tweaked using the environment variables understood by
> +``clang-sys`` (the Rust bindings crate that ``bindgen`` uses to access
> +``libclang``):
> +
> +* ``LLVM_CONFIG_PATH`` can be pointed to an ``llvm-config`` executable.
> +
> +* Or ``LIBCLANG_PATH`` can be pointed to a ``libclang`` shared library
> +  or to the directoy containing it.
> +
> +* Or ``CLANG_PATH`` can be pointed to a ``clang`` executable.
> +
> +For details, please see ``clang-sys``'s documentation at:
> +
> +       https://github.com/KyleMayes/clang-sys#environment-variables
> +
>
>  Requirements: Developing
>  ------------------------
> --
> 2.39.0
>


-- 
Thanks,
~Nick Desaulniers
