Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82904179
	for <patches@lists.linux.dev>; Thu, 23 Mar 2023 06:30:40 +0000 (UTC)
Received: by mail-qt1-f174.google.com with SMTP id x1so25486096qtr.7
        for <patches@lists.linux.dev>; Wed, 22 Mar 2023 23:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679553039;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UhAsUoztmuqWCk/RtYU7Y/jxMQ5MJV8LTqU+TgYM9HY=;
        b=hwDGhhlh6syM0F4yaWNb8x1cpO/Jc4yO+gXKVUvY6q3eRVhOeToTLDRFyTxLvYylWE
         6xNKez48OYQ3qfZxVu/hJ0XcPi/OYZNBEnsGUL1C6enfahBISDGHQLY++i5KxWR1/orN
         85e28RzplkD4xs2jZbmeN5M9FcH056ug8Ux6i/eaOkd71Kl/DruZynOoQPoal4QtVhtf
         rIyfhMZwt43j1yK7UyvflW+dm6jN1CCYbKAMeRsvCC8LdZ9ZZ3AUKlbjFpMXCFVnX2a/
         nFBAZHbF49e5M76jyK6R4fpFCSC8Q9puthy9E1jsYgtKB+bev0dxIM3Z9iuAMUO1laYP
         xPPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679553039;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UhAsUoztmuqWCk/RtYU7Y/jxMQ5MJV8LTqU+TgYM9HY=;
        b=tnOAgnBN8KCVkychZdqi0fN18+GaGHyU21fJS9s+n27P+kCs2+GeNGw2uYNHZ7/J0t
         YHmlJgQRzd8A+hMCrkVVxCRT0x/DYEoYs0Da2vW/c4/MEWIq65wZChUQgezb9YBs6cng
         Un4eZUbAYLBRToQcwSqzMhNgYzHBfTwt1NCaRa3nW5VcFqXYjJ9VlqtdXIwkXJ2jkedB
         gf6/IIsmiAEavUTmuTPbWTLSGoW/V4cE6cMp2ZuP2mFCl97irZ84z7XvzJVM4SloeIU0
         nCINnyeaMvtTUp5YdRop0MkXsTO7VQ03Gh3S9a0t7W4w5zAnJ3zGMO0hKPQfueB7J02U
         VXFg==
X-Gm-Message-State: AO0yUKVsEEQj0Z3rszzu7mBCEfRJMJfdwBiogNHXb7NIU5GUKE2QnqPJ
	+EQKi+HhN8quJgDzMWb3/Yo=
X-Google-Smtp-Source: AK7set+0KKR4/NmJEyqFywo22jUgVMyDBi0HZWSJWqGnddEUGYnPWIYZiLAjObxr23aJ7Gi4gO4F8A==
X-Received: by 2002:a05:622a:103:b0:3e1:5060:5c8f with SMTP id u3-20020a05622a010300b003e150605c8fmr10159361qtw.33.1679553039284;
        Wed, 22 Mar 2023 23:30:39 -0700 (PDT)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id p11-20020a05620a22ab00b0074583bda590sm12668492qkh.10.2023.03.22.23.30.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 23:30:38 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by mailauth.nyi.internal (Postfix) with ESMTP id 1F28A27C0054;
	Thu, 23 Mar 2023 02:30:37 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 23 Mar 2023 02:30:38 -0400
X-ME-Sender: <xms:DfIbZC9lYqPVL80QXhH3ktDG-LsjzmRrvw1AefDd-LGAl9F864bk2Q>
    <xme:DfIbZCtrF0nvn7Ongo8hKSvsLO-Mb9su-RoLEERyuF5WzooTpo9fbyKUOPnQuYvOx
    OTxsUm4x9zr93mc4A>
X-ME-Received: <xmr:DfIbZICbRTbmpjRkBsbGdpknEeB0G1djOTm76p9OmuprhsEzdnvfx4NYqWaOSwo6ucti6tjifyzakLzo9oMuOBipcVtFs9xnY2w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdegfedgleehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehoqhhu
    nhcuhfgvnhhguceosghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmqeenucggtffrrg
    htthgvrhhnpeehudfgudffffetuedtvdehueevledvhfelleeivedtgeeuhfegueeviedu
    ffeivdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    gsohhquhhnodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdeiledvgeehtdei
    gedqudejjeekheehhedvqdgsohhquhhnrdhfvghngheppehgmhgrihhlrdgtohhmsehfih
    igmhgvrdhnrghmvg
X-ME-Proxy: <xmx:DfIbZKehO0R-rQVDEW-n6rz0ktcrf2wWHI9ifT4SIV5cKMATyfhPSg>
    <xmx:DfIbZHOi17Q9_FlgceWWbdG_BQTZwaOA7weaaMbuNoYw__i2VU7Owg>
    <xmx:DfIbZEkZrrj2REwG5vTHYiXoa_oLrbw2hqTT7dSjy2mg77N89MHFSA>
    <xmx:DfIbZAhkkgDT5lI95X66r3BKKE415vZ6mr-ejrkoH8csde3oO2gOrA>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Mar 2023 02:30:37 -0400 (EDT)
Date: Wed, 22 Mar 2023 23:30:35 -0700
From: Boqun Feng <boqun.feng@gmail.com>
To: Benno Lossin <y86-dev@protonmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v2 3/5] rust: add pin-init API
Message-ID: <ZBvyCwPcpTnk2R7h@Boquns-Mac-mini.local>
References: <20230321194934.908891-1-y86-dev@protonmail.com>
 <20230321194934.908891-4-y86-dev@protonmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321194934.908891-4-y86-dev@protonmail.com>

On Tue, Mar 21, 2023 at 07:50:00PM +0000, Benno Lossin wrote:
[...]
> +/// # Syntax
> +///
> +/// As already mentioned in the examples above, inside of `pin_init!` a `struct` initializer with
> +/// the following modifications is expected:
> +/// - Fields that you want to initialize in-place have to use `<-` instead of `:`.
> +/// - In front of the initializer you can write `&this in` to have access to a [`NonNull<Self>`]
> +///   pointer named `this` inside of the initializer.
> +///
> +/// For instance:
> +///
> +/// ```rust
> +/// # use kernel::pin_init;
> +/// # use macros::pin_data;
> +/// # use core::{ptr::addr_of_mut, marker::PhantomPinned};
> +/// #[pin_data]
> +/// struct Buf {
> +///     ptr: *mut u8,
> +///     buf: [u8; 64],

Say we have an extra field,

           a: u8,

> +///     #[pin]
> +///     pin: PhantomPinned,
> +/// }
> +/// pin_init!(&this in Buf {
> +///     buf: [0; 64],
> +///     ptr: unsafe { addr_of_mut!((*this.as_ptr()).buf).cast() },

And I think we want to disallow:

           a: unsafe { (*addr_of!(*this.as_ptr().buf))[0] }

, right? Because we don't want `pin_init!` to provide any initialization
order guarantee? If so, maybe add one or two sentences to call it out.

If not sure, I think we can leave it as it is, until someone really uses
this pattern ;-)

Regards,
Boqun

> +///     pin: PhantomPinned,
> +/// });
> +/// ```
> +///
> +/// [`try_pin_init!`]: kernel::try_pin_init
> +/// [`NonNull<Self>`]: core::ptr::NonNull
> +#[macro_export]
> +macro_rules! pin_init {
> +    ($(&$this:ident in)? $t:ident $(::<$($generics:ty),* $(,)?>)? {
> +        $($fields:tt)*
> +    }) => {
> +        $crate::try_pin_init!(
> +            @this($($this)?),
> +            @type_name($t),
> +            @typ($t $(<$($generics),*>)?),
> +            @fields($($fields)*),
> +            @error(::core::convert::Infallible),
> +        )
> +    };
> +}
> +
[...]
