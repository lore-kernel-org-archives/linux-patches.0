Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C357E0
	for <patches@lists.linux.dev>; Fri, 31 Mar 2023 22:43:48 +0000 (UTC)
Received: by mail-qv1-f52.google.com with SMTP id oe8so17411211qvb.6
        for <patches@lists.linux.dev>; Fri, 31 Mar 2023 15:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680302627;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z68cLSzY8qouNicndmDzpyE4iZo9ng0T1yzVNfPtg5I=;
        b=dqK52i7UNhFDVCklDxEMxq8p268JsxkUx161UP6CF0yTS/OWTpj/yZxkbolZhUPpgR
         9H8rwNwI+mdfxLtb+mijruSzZfVW6zTjMfEXLKBVBYSHgxWSjUJcR07KurFLOkqqhn/m
         TL8tlCVm3vOF4unJSWv/GWlYa5b75kJj02ELP5DfeAZDDkn2nQ256q8wxhx2zRtcDpYp
         wFYg+ImU76EaZVHvI7j6K43fnnnvdRppXVdwojiL0DOteMngFmZfbSr6u+bMa1Hd+nZh
         D3b2fTGPVJyBXCbGHVEgwwrgYcggIqNLndoHfglQZLGXO91y5FefDjCvCeRe58ArgZ8z
         g90w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680302627;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z68cLSzY8qouNicndmDzpyE4iZo9ng0T1yzVNfPtg5I=;
        b=0LRc9mlIKPc+4V3trARVgSHgPVltuYKf8FCPoD8UHTqtn5GgxtAcgQ/MbPP586NYHC
         XIloyof4Mf6lvtRb1tCoSqaRgL/lOS1jf/UYcNJWkAT6pNBN1HTcbIK616bsYeRGypG/
         0d+opSKMG4CIA2rurIbhOOmg45mcxNWGBLP6ts8dHRXV2KNsgiUqBWiYKp8dFp22CBAO
         /5IA2m9d+aosqRxxXQYhox8QcY0ruLg2DWzI6ZoHRCvIvlxrpDpgGfdFQb5pPzKiDZqr
         e6vT/5Bl66ASg83kHWVQvEHJDKtQOpXkAIr1ApuREi/R1MFK79GJGQnfi4E6c5x2JUaH
         /9yQ==
X-Gm-Message-State: AAQBX9el5N82ENFdm2xiUs6Jn00MXW8QiObPHT9QPTNDjc1834dUYJNY
	RLjQ6AwoZmIoH+9Hs74dN+hOmFqUUBI=
X-Google-Smtp-Source: AKy350ZXwe++el+DV4pQSmxn25w6+phmBkTE7V5Eye6newalJw9YXmQ/3GvSBet5sVBfzyyRLgWWHg==
X-Received: by 2002:a05:6214:518b:b0:5bb:eefc:1623 with SMTP id kl11-20020a056214518b00b005bbeefc1623mr41302505qvb.42.1680302627280;
        Fri, 31 Mar 2023 15:43:47 -0700 (PDT)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id lf8-20020a0562142cc800b005dd8b9345c2sm901979qvb.90.2023.03.31.15.43.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 15:43:46 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
	by mailauth.nyi.internal (Postfix) with ESMTP id 67E7C27C0054;
	Fri, 31 Mar 2023 18:43:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Fri, 31 Mar 2023 18:43:46 -0400
X-ME-Sender: <xms:IWInZEkQ-da63e7Rxc00_PZTxfHHkx_fcb0rb23rS97rezxyDj07xw>
    <xme:IWInZD2h7-XVzu01iz_rfYRHwIciVoBfhbo8yKcXMorc4jHOiXlVeOu2e54ZXBY86
    uyY2VzEW-kiNv-aWg>
X-ME-Received: <xmr:IWInZCrNgLMoLQmiL54HXmP28qI_KToslueRA6RkGlINlsztDLpBK6PxvlSz8w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdeivddgudegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehoqhhu
    nhcuhfgvnhhguceosghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmqeenucggtffrrg
    htthgvrhhnpeehudfgudffffetuedtvdehueevledvhfelleeivedtgeeuhfegueeviedu
    ffeivdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    gsohhquhhnodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdeiledvgeehtdei
    gedqudejjeekheehhedvqdgsohhquhhnrdhfvghngheppehgmhgrihhlrdgtohhmsehfih
    igmhgvrdhnrghmvg
X-ME-Proxy: <xmx:IWInZAmDxvlMvGtFT8MOR3jPbbxuJ--RRxPN7DdFc_PLFlnEi8RL1A>
    <xmx:IWInZC2lz4mzNVzWg39QTHd-rjXe8VOMnGLEx6GFj4Lvv99w0ahqzQ>
    <xmx:IWInZHteMgjklFbCHBvBmM28GQgioElnzFTZ8WRNjTVBID7ldOGK7w>
    <xmx:ImInZPsF2aenqlWCYnThHrQSBDneBZOIWRo9sfC8yfRwcnVlZZmCvg>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 31 Mar 2023 18:43:45 -0400 (EDT)
Date: Fri, 31 Mar 2023 15:42:57 -0700
From: Boqun Feng <boqun.feng@gmail.com>
To: y86-dev@protonmail.com
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Alice Ryhl <alice@ryhl.io>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>
Subject: Re: [PATCH v4 08/15] rust: init/sync: add `InPlaceInit` trait to
 pin-initialize smart pointers
Message-ID: <ZCdh8fwSGTjDW6vE@boqun-archlinux>
References: <20230331215053.585759-9-y86-dev@protonmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230331215053.585759-9-y86-dev@protonmail.com>

On Fri, Mar 31, 2023 at 09:53:25PM +0000, y86-dev@protonmail.com wrote:
[...]
> diff --git a/rust/kernel/sync/arc.rs b/rust/kernel/sync/arc.rs
> index eee7008e5e3e..24dc96603090 100644
> --- a/rust/kernel/sync/arc.rs
> +++ b/rust/kernel/sync/arc.rs
> @@ -17,6 +17,7 @@
> 
>  use crate::{
>      bindings,
> +    init::{InPlaceInit, Init, PinInit},
>      types::{ForeignOwnable, Opaque},
>  };
>  use alloc::boxed::Box;
> @@ -163,6 +164,28 @@ impl<T> Arc<T> {
>          // `Arc` object.
>          Ok(unsafe { Self::from_inner(Box::leak(inner).into()) })
>      }
> +
> +    /// Use the given initializer to in-place initialize a `T`.
> +    ///
> +    /// If `T: !Unpin` it will not be able to move afterwards.
> +    #[inline]
> +    pub fn pin_init<E>(init: impl PinInit<T, E>) -> Result<Self>

`Result` became `core::result::Result` after patch #3, so you will need
to refer to `crate::error::Result` here. Alternatively you can change
patch #3 to use the full path i.e. `core::result::Result`. 

> +    where
> +        Error: From<E>,

In my env, looks like the compiler doesn't know which `Error` it
is after removing use of `crate::error::Result` in patch #3, you
probably need to deal with this as well.

Regards,
Boqun

> +    {
> +        UniqueArc::pin_init(init).map(|u| u.into())
> +    }
> +
> +    /// Use the given initializer to in-place initialize a `T`.
> +    ///
> +    /// This is equivalent to [`pin_init`], since an [`Arc`] is always pinned.
> +    #[inline]
> +    pub fn init<E>(init: impl Init<T, E>) -> Result<Self>
> +    where
> +        Error: From<E>,
> +    {
> +        UniqueArc::init(init).map(|u| u.into())
> +    }
>  }
> 
>  impl<T: ?Sized> Arc<T> {
> --
> 2.39.2
> 
> 
