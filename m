Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 096251A612
	for <patches@lists.linux.dev>; Thu, 10 Nov 2022 18:12:26 +0000 (UTC)
Received: by mail-qv1-f45.google.com with SMTP id i12so1950990qvs.2
        for <patches@lists.linux.dev>; Thu, 10 Nov 2022 10:12:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QjhrCoZQO78aH1Eq+NZaqmtVo4jyNmaRL9pB6MFNrko=;
        b=dnw0bXKFNPNx7KYtv9J8mc7BNylOSoCT51+8cGLEs3/wfBuCYMroRZdfmembhmFYRu
         Ftwqcsw52BRG8H3AZ0SkHBwiPjvm8YOXrPPJ625R7TbcO8hLkN7JiCZc2oSv4pbA1ydj
         zUdcYhiFrbEBuGE4w90UTJ1jPNPgu1O7rXVa/z7ykJpIIk52ngH71q+qpyqkosuf1a47
         lJSjaFEiIokN2Drndlv21/sKRAIYvbcXoQ0LWQ2pAxAi6tqJibUA4HQPjfW3L/QUGzfU
         gha9ddCSr1Y8WlN6+ig0aMk/RP4an2H215sqazYi9PVw6U7nqEqW7+M4YBNfj/q2/9+K
         pqGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QjhrCoZQO78aH1Eq+NZaqmtVo4jyNmaRL9pB6MFNrko=;
        b=Oy6MvbIkNEtpkC5RW9KNd471dipy7WXphV5Li01Vz3Fqr1pFBwu2c33MzFDIfVT4Xz
         LoRkSvOoqFn3FrkBKyw/b8+iVYdilvesrUxmUafG5PPWa4n4/ctK0vh71rzvLivPW/k5
         zm+uQUeVAO4s2CSEAf44v7kbNTp5GlNDXbP6I1Ca5fhuwi+BAD7kNFcNaWlMT80sAzqX
         1p5fgYFEHviYe5c0nQbdyoEZSrqMKxQWmjPUbkxjQD8044oj+SRhwZ/3U8ucwoaO/XEk
         NUNmnuejbCRVdVQFHBgTXFHpkZ/CMdlvW5FBGNYWJoDFRpzQKt+ax8F3yP3Kymx3VaPQ
         Jfyg==
X-Gm-Message-State: ACrzQf0F+jqkajAsXWYTPtEziQZC1Vjx//2nGU5hd0J5hGp5XRqz0Qdm
	q4Qmxp7bxephxVtqrXoVkJw=
X-Google-Smtp-Source: AMsMyM6PN9MhQ1V4GLQW/FFO2wTh0LDfhrT7sMmy0AcGKAFTmWANj0HolLsCbbRYoCG8ti+krOS/Gg==
X-Received: by 2002:a05:6214:4005:b0:4bb:9c0f:bcaa with SMTP id kd5-20020a056214400500b004bb9c0fbcaamr61963356qvb.42.1668103945670;
        Thu, 10 Nov 2022 10:12:25 -0800 (PST)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id j67-20020a378746000000b006fa5815b88dsm13005395qkd.88.2022.11.10.10.12.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 10:12:25 -0800 (PST)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
	by mailauth.nyi.internal (Postfix) with ESMTP id DB08827C005B;
	Thu, 10 Nov 2022 13:12:24 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 10 Nov 2022 13:12:24 -0500
X-ME-Sender: <xms:CD9tY7Gr8GRDNtH2lqfS2lECGcRMbpKh8rhpCxVYzzdMP0Eqfk51BQ>
    <xme:CD9tY4U83EHX6r8eKEsOEbdeRWQEuLY9KoUJ_w87COJw7mxH3NG_10H7-fu_sOy4h
    NzZw0-cO5w063_1uw>
X-ME-Received: <xmr:CD9tY9KaIQEcsD-9pJCq5vwwikvdhvJTFSs_SMjnvYWzyRy831KVmR0fmEw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrfeeggdduudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehoqhhu
    nhcuhfgvnhhguceosghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmqeenucggtffrrg
    htthgvrhhnpeekheefledtgfekleelueekudeiudekffevlefhkeelueeitefhgeeigfef
    jeekgfenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdhruhhsthdqlhgrnhhgrdhorh
    hgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsgho
    qhhunhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqieelvdeghedtieegqd
    dujeejkeehheehvddqsghoqhhunhdrfhgvnhhgpeepghhmrghilhdrtghomhesfhhigihm
    vgdrnhgrmhgv
X-ME-Proxy: <xmx:CD9tY5ED48YJnaU9QKRg5D_FWbCZSMDJ4m3vZKsdCBYxabRnMWrgrA>
    <xmx:CD9tYxWPzOf02SaYj4IuMvi0UMuuXCk6UQ6N0ZbYLuyhUW996kMD-A>
    <xmx:CD9tY0Nm6BilmPSobIJMBbjQiF_PMnIAz0HQDrBhRvEuFm20If7pCQ>
    <xmx:CD9tY9rblKvEaOHIht9REC3W3Su_0BCPnGMGGdZRWyk2iT1hbccj0g>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 10 Nov 2022 13:12:24 -0500 (EST)
Date: Thu, 10 Nov 2022 10:12:23 -0800
From: Boqun Feng <boqun.feng@gmail.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, Adam Bratschi-Kaye <ark.email@gmail.com>
Subject: Re: [PATCH v1 02/28] rust: print: add more `pr_*!` levels
Message-ID: <Y20/B80+eU4kYW3S@Boquns-Mac-mini.local>
References: <20221110164152.26136-1-ojeda@kernel.org>
 <20221110164152.26136-3-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221110164152.26136-3-ojeda@kernel.org>

On Thu, Nov 10, 2022 at 05:41:14PM +0100, Miguel Ojeda wrote:
> Currently, only `pr_info!` (for the minimal sample) and
> `pr_emerg!` (for the panic handler) are there.
> 
> Add the other levels as new macros, i.e. `pr_alert!`, `pr_crit!`,
> `pr_err!`, `pr_warn!`, `pr_notice!` and `pr_debug!`.
> 
> Co-developed-by: Adam Bratschi-Kaye <ark.email@gmail.com>
> Signed-off-by: Adam Bratschi-Kaye <ark.email@gmail.com>
> Co-developed-by: Wedson Almeida Filho <wedsonaf@gmail.com>
> Signed-off-by: Wedson Almeida Filho <wedsonaf@gmail.com>
> Co-developed-by: Gary Guo <gary@garyguo.net>
> Signed-off-by: Gary Guo <gary@garyguo.net>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Boqun Feng <boqun.feng@gmail.com>

Regards,
Boqun

> ---
>  rust/kernel/prelude.rs |   2 +-
>  rust/kernel/print.rs   | 154 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 155 insertions(+), 1 deletion(-)
> 
> diff --git a/rust/kernel/prelude.rs b/rust/kernel/prelude.rs
> index f8219285d8c0..6a1c6b38327f 100644
> --- a/rust/kernel/prelude.rs
> +++ b/rust/kernel/prelude.rs
> @@ -17,7 +17,7 @@ pub use alloc::{boxed::Box, vec::Vec};
>  
>  pub use macros::module;
>  
> -pub use super::{pr_emerg, pr_info};
> +pub use super::{pr_alert, pr_crit, pr_debug, pr_emerg, pr_err, pr_info, pr_notice, pr_warn};
>  
>  pub use super::error::{Error, Result};
>  
> diff --git a/rust/kernel/print.rs b/rust/kernel/print.rs
> index 55db5a1ba752..694f51c6da5c 100644
> --- a/rust/kernel/print.rs
> +++ b/rust/kernel/print.rs
> @@ -74,7 +74,13 @@ pub mod format_strings {
>      // Furthermore, `static` instead of `const` is used to share the strings
>      // for all the kernel.
>      pub static EMERG: [u8; LENGTH] = generate(false, bindings::KERN_EMERG);
> +    pub static ALERT: [u8; LENGTH] = generate(false, bindings::KERN_ALERT);
> +    pub static CRIT: [u8; LENGTH] = generate(false, bindings::KERN_CRIT);
> +    pub static ERR: [u8; LENGTH] = generate(false, bindings::KERN_ERR);
> +    pub static WARNING: [u8; LENGTH] = generate(false, bindings::KERN_WARNING);
> +    pub static NOTICE: [u8; LENGTH] = generate(false, bindings::KERN_NOTICE);
>      pub static INFO: [u8; LENGTH] = generate(false, bindings::KERN_INFO);
> +    pub static DEBUG: [u8; LENGTH] = generate(false, bindings::KERN_DEBUG);
>  }
>  
>  /// Prints a message via the kernel's [`_printk`].
> @@ -172,6 +178,126 @@ macro_rules! pr_emerg (
>      )
>  );
>  
> +/// Prints an alert-level message (level 1).
> +///
> +/// Use this level if action must be taken immediately.
> +///
> +/// Equivalent to the kernel's [`pr_alert`] macro.
> +///
> +/// Mimics the interface of [`std::print!`]. See [`core::fmt`] and
> +/// `alloc::format!` for information about the formatting syntax.
> +///
> +/// [`pr_alert`]: https://www.kernel.org/doc/html/latest/core-api/printk-basics.html#c.pr_alert
> +/// [`std::print!`]: https://doc.rust-lang.org/std/macro.print.html
> +///
> +/// # Examples
> +///
> +/// ```
> +/// pr_alert!("hello {}\n", "there");
> +/// ```
> +#[macro_export]
> +macro_rules! pr_alert (
> +    ($($arg:tt)*) => (
> +        $crate::print_macro!($crate::print::format_strings::ALERT, $($arg)*)
> +    )
> +);
> +
> +/// Prints a critical-level message (level 2).
> +///
> +/// Use this level for critical conditions.
> +///
> +/// Equivalent to the kernel's [`pr_crit`] macro.
> +///
> +/// Mimics the interface of [`std::print!`]. See [`core::fmt`] and
> +/// `alloc::format!` for information about the formatting syntax.
> +///
> +/// [`pr_crit`]: https://www.kernel.org/doc/html/latest/core-api/printk-basics.html#c.pr_crit
> +/// [`std::print!`]: https://doc.rust-lang.org/std/macro.print.html
> +///
> +/// # Examples
> +///
> +/// ```
> +/// pr_crit!("hello {}\n", "there");
> +/// ```
> +#[macro_export]
> +macro_rules! pr_crit (
> +    ($($arg:tt)*) => (
> +        $crate::print_macro!($crate::print::format_strings::CRIT, $($arg)*)
> +    )
> +);
> +
> +/// Prints an error-level message (level 3).
> +///
> +/// Use this level for error conditions.
> +///
> +/// Equivalent to the kernel's [`pr_err`] macro.
> +///
> +/// Mimics the interface of [`std::print!`]. See [`core::fmt`] and
> +/// `alloc::format!` for information about the formatting syntax.
> +///
> +/// [`pr_err`]: https://www.kernel.org/doc/html/latest/core-api/printk-basics.html#c.pr_err
> +/// [`std::print!`]: https://doc.rust-lang.org/std/macro.print.html
> +///
> +/// # Examples
> +///
> +/// ```
> +/// pr_err!("hello {}\n", "there");
> +/// ```
> +#[macro_export]
> +macro_rules! pr_err (
> +    ($($arg:tt)*) => (
> +        $crate::print_macro!($crate::print::format_strings::ERR, $($arg)*)
> +    )
> +);
> +
> +/// Prints a warning-level message (level 4).
> +///
> +/// Use this level for warning conditions.
> +///
> +/// Equivalent to the kernel's [`pr_warn`] macro.
> +///
> +/// Mimics the interface of [`std::print!`]. See [`core::fmt`] and
> +/// `alloc::format!` for information about the formatting syntax.
> +///
> +/// [`pr_warn`]: https://www.kernel.org/doc/html/latest/core-api/printk-basics.html#c.pr_warn
> +/// [`std::print!`]: https://doc.rust-lang.org/std/macro.print.html
> +///
> +/// # Examples
> +///
> +/// ```
> +/// pr_warn!("hello {}\n", "there");
> +/// ```
> +#[macro_export]
> +macro_rules! pr_warn (
> +    ($($arg:tt)*) => (
> +        $crate::print_macro!($crate::print::format_strings::WARNING, $($arg)*)
> +    )
> +);
> +
> +/// Prints a notice-level message (level 5).
> +///
> +/// Use this level for normal but significant conditions.
> +///
> +/// Equivalent to the kernel's [`pr_notice`] macro.
> +///
> +/// Mimics the interface of [`std::print!`]. See [`core::fmt`] and
> +/// `alloc::format!` for information about the formatting syntax.
> +///
> +/// [`pr_notice`]: https://www.kernel.org/doc/html/latest/core-api/printk-basics.html#c.pr_notice
> +/// [`std::print!`]: https://doc.rust-lang.org/std/macro.print.html
> +///
> +/// # Examples
> +///
> +/// ```
> +/// pr_notice!("hello {}\n", "there");
> +/// ```
> +#[macro_export]
> +macro_rules! pr_notice (
> +    ($($arg:tt)*) => (
> +        $crate::print_macro!($crate::print::format_strings::NOTICE, $($arg)*)
> +    )
> +);
> +
>  /// Prints an info-level message (level 6).
>  ///
>  /// Use this level for informational messages.
> @@ -196,3 +322,31 @@ macro_rules! pr_info (
>          $crate::print_macro!($crate::print::format_strings::INFO, $($arg)*)
>      )
>  );
> +
> +/// Prints a debug-level message (level 7).
> +///
> +/// Use this level for debug messages.
> +///
> +/// Equivalent to the kernel's [`pr_debug`] macro, except that it doesn't support dynamic debug
> +/// yet.
> +///
> +/// Mimics the interface of [`std::print!`]. See [`core::fmt`] and
> +/// `alloc::format!` for information about the formatting syntax.
> +///
> +/// [`pr_debug`]: https://www.kernel.org/doc/html/latest/core-api/printk-basics.html#c.pr_debug
> +/// [`std::print!`]: https://doc.rust-lang.org/std/macro.print.html
> +///
> +/// # Examples
> +///
> +/// ```
> +/// pr_debug!("hello {}\n", "there");
> +/// ```
> +#[macro_export]
> +#[doc(alias = "print")]
> +macro_rules! pr_debug (
> +    ($($arg:tt)*) => (
> +        if cfg!(debug_assertions) {
> +            $crate::print_macro!($crate::print::format_strings::DEBUG, $($arg)*)
> +        }
> +    )
> +);
> -- 
> 2.38.1
> 
