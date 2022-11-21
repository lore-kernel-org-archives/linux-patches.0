Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBCB133EC
	for <patches@lists.linux.dev>; Mon, 21 Nov 2022 22:52:07 +0000 (UTC)
Received: by mail-ej1-f53.google.com with SMTP id n12so31795132eja.11
        for <patches@lists.linux.dev>; Mon, 21 Nov 2022 14:52:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NGPJoGgEf7UilkDf7rSI+x9NQwnpZsCCeFTrbXEasDc=;
        b=OwNcrxDRAmcQHMo9wTgynMmwAIRBuCsrD3KspfMDRMphTsKqByctGClHVT+KoyeXGA
         y78uoy9R3NCzMwSDIgQIP6He3AFAaGEH76DCk1EuGIMmyth5vV7QglQl/LCRm0jqas5P
         w3a/xkkRcbQqsEhyI3fTvKMx0p65zHOJfC72Nc2a1X7Lz+5rpWlwzCLqiHOhV933mB/h
         kAyGYEeK2IfJnQqOtOrs+EX95fQ5o7+OZQby75E17scPZ68/Owxeei5k64EE5IcT7o5S
         sulDKG4Eh5/SNFJs4BgyQZn37fc/knirDuMEa0BhfNsfHUJDx8djGTvk9qRRhkvkeNc+
         WY+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NGPJoGgEf7UilkDf7rSI+x9NQwnpZsCCeFTrbXEasDc=;
        b=KCAwWFkzpkBw8FE3Z8s2PtxIspWS1GYzOTYihzoVPULU4PKdX3JmNUt1M/OU9SqXdR
         CeOVlhDs/efyQarlW9wIR36g53CyWvvTkMmi7iesnrbjgmNu7JRFC0+u/908DcNH/6f3
         tNJFXVEqqm3wcML2ARnqiEGRoEWKc+usYJ/ERpc3dhC4pHStysmhv7WvBigPKdGIkq5V
         zra35rChDtMW0Nhexvl/pIknQnelBoOzqzRF9ExCntLnksT8D/uuwLHte0/xq3RXAXVz
         F5bSmhUHGm4ZT7CkuZ1An3fLgFgZhQKoIuFa4dKvqhLUyrVzeJyzAHOlEXFRmezFtvP/
         7UvA==
X-Gm-Message-State: ANoB5pkquQnaYuvhXo8EiQ+arqoUh3KEyLG2vs4XZeo/2BCLmyGRR4Yt
	XhM1PTChSmoBvtRGzWR7mP9UDdlebvs73dL6kJk=
X-Google-Smtp-Source: AA0mqf6n9ijZrSMSuLDDEU2b+4Sc2H56X4iXT7tpuHy2HAO64Z8INcpLQs6KxHhnRFvg9RE0e2nOlbkOHWhmfRGD+Y4=
X-Received: by 2002:a17:907:208d:b0:7ad:d662:f568 with SMTP id
 pv13-20020a170907208d00b007add662f568mr16734609ejb.616.1669071126105; Mon, 21
 Nov 2022 14:52:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221110164152.26136-1-ojeda@kernel.org> <20221110164152.26136-5-ojeda@kernel.org>
In-Reply-To: <20221110164152.26136-5-ojeda@kernel.org>
From: =?UTF-8?Q?Sergio_Gonz=C3=A1lez_Collado?= <sergio.collado@gmail.com>
Date: Mon, 21 Nov 2022 23:51:29 +0100
Message-ID: <CAA76j93O=a32EOT0vkxf6SGb9qypNpOjDC-dUMOuUPuujPkzOQ@mail.gmail.com>
Subject: Re: [PATCH v1 04/28] rust: samples: add `rust_print` example
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 10 Nov 2022 at 17:43, Miguel Ojeda <ojeda@kernel.org> wrote:
>
> Add example to exercise the printing macros (`pr_*!`) introduced
> in the previous patches.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>  samples/rust/Kconfig       | 10 +++++++
>  samples/rust/Makefile      |  1 +
>  samples/rust/rust_print.rs | 54 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 65 insertions(+)
>  create mode 100644 samples/rust/rust_print.rs
>
> diff --git a/samples/rust/Kconfig b/samples/rust/Kconfig
> index 841e0906e943..b0f74a81c8f9 100644
> --- a/samples/rust/Kconfig
> +++ b/samples/rust/Kconfig
> @@ -20,6 +20,16 @@ config SAMPLE_RUST_MINIMAL
>
>           If unsure, say N.
>
> +config SAMPLE_RUST_PRINT
> +       tristate "Printing macros"
> +       help
> +         This option builds the Rust printing macros sample.
> +
> +         To compile this as a module, choose M here:
> +         the module will be called rust_print.
> +
> +         If unsure, say N.
> +
>  config SAMPLE_RUST_HOSTPROGS
>         bool "Host programs"
>         help
> diff --git a/samples/rust/Makefile b/samples/rust/Makefile
> index 1daba5f8658a..03086dabbea4 100644
> --- a/samples/rust/Makefile
> +++ b/samples/rust/Makefile
> @@ -1,5 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0
>
>  obj-$(CONFIG_SAMPLE_RUST_MINIMAL)              +=3D rust_minimal.o
> +obj-$(CONFIG_SAMPLE_RUST_PRINT)                        +=3D rust_print.o
>
>  subdir-$(CONFIG_SAMPLE_RUST_HOSTPROGS)         +=3D hostprogs
> diff --git a/samples/rust/rust_print.rs b/samples/rust/rust_print.rs
> new file mode 100644
> index 000000000000..09f737790f3f
> --- /dev/null
> +++ b/samples/rust/rust_print.rs
> @@ -0,0 +1,54 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +//! Rust printing macros sample.
> +
> +use kernel::pr_cont;
> +use kernel::prelude::*;
> +
> +module! {
> +    type: RustPrint,
> +    name: b"rust_print",
> +    author: b"Rust for Linux Contributors",
> +    description: b"Rust printing macros sample",
> +    license: b"GPL",
> +}
> +
> +struct RustPrint;
> +
> +impl kernel::Module for RustPrint {
> +    fn init(_module: &'static ThisModule) -> Result<Self> {
> +        pr_info!("Rust printing macros sample (init)\n");
> +
> +        pr_emerg!("Emergency message (level 0) without args\n");
> +        pr_alert!("Alert message (level 1) without args\n");
> +        pr_crit!("Critical message (level 2) without args\n");
> +        pr_err!("Error message (level 3) without args\n");
> +        pr_warn!("Warning message (level 4) without args\n");
> +        pr_notice!("Notice message (level 5) without args\n");
> +        pr_info!("Info message (level 6) without args\n");
> +
> +        pr_info!("A line that");
> +        pr_cont!(" is continued");
> +        pr_cont!(" without args\n");
> +
> +        pr_emerg!("{} message (level {}) with args\n", "Emergency", 0);
> +        pr_alert!("{} message (level {}) with args\n", "Alert", 1);
> +        pr_crit!("{} message (level {}) with args\n", "Critical", 2);
> +        pr_err!("{} message (level {}) with args\n", "Error", 3);
> +        pr_warn!("{} message (level {}) with args\n", "Warning", 4);
> +        pr_notice!("{} message (level {}) with args\n", "Notice", 5);
> +        pr_info!("{} message (level {}) with args\n", "Info", 6);
> +
> +        pr_info!("A {} that", "line");
> +        pr_cont!(" is {}", "continued");
> +        pr_cont!(" with {}\n", "args");
> +
> +        Ok(RustPrint)
> +    }
> +}
> +
> +impl Drop for RustPrint {
> +    fn drop(&mut self) {
> +        pr_info!("Rust printing macros sample (exit)\n");
> +    }
> +}
> --
> 2.38.1
>

Tested-by: Sergio Gonz=C3=A1lez Collado <sergio.collado@gmail.com>
