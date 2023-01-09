Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33DC85221
	for <patches@lists.linux.dev>; Mon,  9 Jan 2023 21:20:34 +0000 (UTC)
Received: by mail-qv1-f51.google.com with SMTP id l14so3327356qvw.12
        for <patches@lists.linux.dev>; Mon, 09 Jan 2023 13:20:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LJEqa+Tto0uZChApOqUQ2j2+Od/K35yIfKV8/pb19Cg=;
        b=kU8C+PjPb/OlrFnQtciboURZCvGxqFiuYXXLOgzYDYrLrfVe3KBYM4TI/sCXZSk3wt
         np6YnhMybvx06KIuBtei/ZE4RpwRlYekyJJLz+Q0UEw0AmHbvWqFhHU5DnDLz4rlZbgy
         nTwUJNdc4nmcsYvifsTng+C+Wntn9Tl1KrcZ4lVQdt1sgyAc3Ki5aKwDD1vWhGM95zgE
         ldpMxcuFo0L9nj+gLYEeyAvbbJ7WGRMsyVzg/wB9Taq9WDYDVNFZwr1K4YbXPSTJi4HS
         RMHm2DBeXTCcIP/nroyVaD8SBA+fi8WxxcxB/UmzK8uH9nSoqoeMjpDtkJddtBSIyaW0
         3C+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LJEqa+Tto0uZChApOqUQ2j2+Od/K35yIfKV8/pb19Cg=;
        b=PgEzlqIDpWZ4bGpTmGiDeZF0/OXofBjKHeGg/VHEb4ZAl7yW+7BO7wL1HunZ5FWFoC
         zZQJBDT5bkLueDk4FpXfI0sdKeQRYSPL/c/vnuDURVqjRODM8x8SFoQpzt0J0IhL/Wo8
         gauKxDKjBsHEqSdUqA4njpEVdG//+ZtVezmsVnu+05N9TxcvHmh6nJ98+ZOojnJNAXh3
         XdvYu0QwzUMhvt1/yRiGrwWVmkYuic+vWc+kzN1NiM3LITmu4QvoONA9AkSZ6BBGJJuu
         AJgRnJClBKysVHjOH3j5vpGgXaw2J2OzjbwgEMzKM3Um3uMRbwEWV30YuA9jN2yirKr3
         tMWg==
X-Gm-Message-State: AFqh2kqF4cHmo4H4CAv6tgedUP2zk1NO2r9QzKRQxPMjUN+vMmXJ2+Ud
	oSQkRlkAn+Jqctdf2ZfuTso=
X-Google-Smtp-Source: AMrXdXsoGAtbX1x6PQupFaB5OZUfIqyN8s8i8d7r91SylZ3iP39IbvEcjkT1oyukw0l03wP3b3ROeg==
X-Received: by 2002:a05:6214:5f8a:b0:4c7:1d2c:bd93 with SMTP id ls10-20020a0562145f8a00b004c71d2cbd93mr52052916qvb.47.1673299232973;
        Mon, 09 Jan 2023 13:20:32 -0800 (PST)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id t11-20020a05620a034b00b006fa31bf2f3dsm5940430qkm.47.2023.01.09.13.20.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 13:20:32 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
	by mailauth.nyi.internal (Postfix) with ESMTP id 14F1427C005A;
	Mon,  9 Jan 2023 16:20:31 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 09 Jan 2023 16:20:32 -0500
X-ME-Sender: <xms:H4W8Y6jQsuyf0tgC_J2VVvZ1JGl0PbiD-j7G7HPNIAkUxS6CSouz9Q>
    <xme:H4W8Y7Djb8I--r2BWIiJw5uQGJcBOV4vsWcIdUTwboOcaR60XvtrFfd4tRe6XeiZV
    XD7Akh100_46EWngg>
X-ME-Received: <xmr:H4W8YyFq1M3OBkQZ68GBrMMzXMGIh3sCs0PgAQEw9XKrBKZNNzWtBfM5RXs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrkeeigddugeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehoqhhu
    nhcuhfgvnhhguceosghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmqeenucggtffrrg
    htthgvrhhnpefftdeihfeigedtvdeuueffieetvedtgeejuefhhffgudfgfeeggfeftdei
    geehvdenucffohhmrghinhepghhithhhuhgsrdgtohhmnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomhepsghoqhhunhdomhgvshhmthhprghuthhh
    phgvrhhsohhnrghlihhthidqieelvdeghedtieegqddujeejkeehheehvddqsghoqhhunh
    drfhgvnhhgpeepghhmrghilhdrtghomhesfhhigihmvgdrnhgrmhgv
X-ME-Proxy: <xmx:H4W8YzRCGjQ8gvwPO0-vxJFdHNkChVe9ecJevEAQy38uBVGqhmjDBg>
    <xmx:H4W8Y3ys3CJlO_54rH_uNgmMYLCUG0XA6qdqRgcTLdALfeOnzWF7DQ>
    <xmx:H4W8Yx51IyZcJ5k2q7RWvLi2Nh5c-EPZTGPf2kdjBsMLuFqb3Sdd-A>
    <xmx:H4W8Y-kcZpqgp5J8QaFzCL0lggJKMGbVtBKJJrUVr12kzT9cMSr8tg>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 9 Jan 2023 16:20:30 -0500 (EST)
Date: Mon, 9 Jan 2023 13:19:14 -0800
From: Boqun Feng <boqun.feng@gmail.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Domen Puncer Kugler <domen.puncerkugler@nccgroup.com>
Subject: Re: [PATCH] rust: print: avoid evaluating arguments in `pr_*` macros
 in `unsafe` blocks
Message-ID: <Y7yE0pWJeWRbok3V@boqun-archlinux>
References: <20230109204912.539790-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230109204912.539790-1-ojeda@kernel.org>

On Mon, Jan 09, 2023 at 09:49:12PM +0100, Miguel Ojeda wrote:
> At the moment it is possible to perform unsafe operations in
> the arguments of `pr_*` macros since they are evaluated inside
> an `unsafe` block:
> 
>     let x = &10u32 as *const u32;
>     pr_info!("{}", *x);
> 
> In other words, this is a soundness issue.
> 
> Fix it so that it requires an explicit `unsafe` block.
> 
> Reported-by: Wedson Almeida Filho <wedsonaf@gmail.com>
> Reported-by: Domen Puncer Kugler <domen.puncerkugler@nccgroup.com>
> Link: https://github.com/Rust-for-Linux/linux/issues/479
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Boqun Feng <boqun.feng@gmail.com>

> ---
>  rust/kernel/print.rs | 29 ++++++++++++++++++-----------
>  1 file changed, 18 insertions(+), 11 deletions(-)
> 
> diff --git a/rust/kernel/print.rs b/rust/kernel/print.rs
> index 29bf9c2e8aee..30103325696d 100644
> --- a/rust/kernel/print.rs
> +++ b/rust/kernel/print.rs
> @@ -142,17 +142,24 @@ pub fn call_printk_cont(args: fmt::Arguments<'_>) {
>  macro_rules! print_macro (
>      // The non-continuation cases (most of them, e.g. `INFO`).
>      ($format_string:path, false, $($arg:tt)+) => (
> -        // SAFETY: This hidden macro should only be called by the documented
> -        // printing macros which ensure the format string is one of the fixed
> -        // ones. All `__LOG_PREFIX`s are null-terminated as they are generated
> -        // by the `module!` proc macro or fixed values defined in a kernel
> -        // crate.
> -        unsafe {
> -            $crate::print::call_printk(
> -                &$format_string,
> -                crate::__LOG_PREFIX,
> -                format_args!($($arg)+),
> -            );
> +        // To remain sound, `arg`s must be expanded outside the `unsafe` block.
> +        // Typically one would use a `let` binding for that; however, `format_args!`
> +        // takes borrows on the arguments, but does not extend the scope of temporaries.
> +        // Therefore, a `match` expression is used to keep them around, since
> +        // the scrutinee is kept until the end of the `match`.
> +        match format_args!($($arg)+) {
> +            // SAFETY: This hidden macro should only be called by the documented
> +            // printing macros which ensure the format string is one of the fixed
> +            // ones. All `__LOG_PREFIX`s are null-terminated as they are generated
> +            // by the `module!` proc macro or fixed values defined in a kernel
> +            // crate.
> +            args => unsafe {
> +                $crate::print::call_printk(
> +                    &$format_string,
> +                    crate::__LOG_PREFIX,
> +                    args,
> +                );
> +            }
>          }
>      );
>  
> 
> base-commit: b7bfaa761d760e72a969d116517eaa12e404c262
> -- 
> 2.39.0
> 
