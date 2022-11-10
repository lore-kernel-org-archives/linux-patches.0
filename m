Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1201A612
	for <patches@lists.linux.dev>; Thu, 10 Nov 2022 18:06:01 +0000 (UTC)
Received: by mail-qk1-f175.google.com with SMTP id k2so1583987qkk.7
        for <patches@lists.linux.dev>; Thu, 10 Nov 2022 10:06:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9kpITgtzcbJv0S4BDMGMha2mb2UADEkBMLljR4KrXhE=;
        b=JI6YIXtaQsQTu4zkmXob1uhD/AxjtEUxDtq4QkvUChkoDwjL3PGr7JZ/FUZEvMCnzd
         Q/+sNyTYbre5PWofpt1TPHCzPIizEsJ4qOvkpnhHF+QYCdgWsdOKHjGNI51FhKfR0hLU
         ZoYNzNzdJKMc06psxjQG+rASoG66Yj6qAgBFnXREDIQQXV8LP4+qw/qHju4Bc3LS/7ZR
         Zb11Q7vcyvKUxvEgqNbRjsoD8vcFUe1Co5AVfHcZY5wR5XrbLTARlkqCG166ewnh1QTr
         rppjONQwur4r6XC5u1IIYHC3mym1QNU7EEa+/7AY8IFGNIUm/rog4sLkRqSBaSuRLEQd
         Ad4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9kpITgtzcbJv0S4BDMGMha2mb2UADEkBMLljR4KrXhE=;
        b=l1iJsP0wt1WJg8B10ChncAbWvCnbXd/ct4nRFLYA1dhlhXnOG+IO/fR1YO3LYFNQkf
         0Rr+IhIYNO4oUj7V+4NoDsObZ99+F5C4jZvhPhJe4+WREJ69ASqduJ75NUlIduGI/BUb
         6XC1uEMxFcwVWKrJIH67nl/X940qSDgVlftdT+bzXLj4Z3Uq6jmZYj5WBB6wb8C7Dqqm
         VUNzW4Dh7llszz+WCBxVgGG1EfJAwTdcSWtq9njedtE3a+whiUmPiTcyAtpnffS3IUaG
         1uSHrcjwe9c0Opk0ao0xtmQJLuJ/GznToXl1gI7CcnvSiJ4F58Wza2NjyP/CjwuFF275
         ZHEA==
X-Gm-Message-State: ACrzQf27BOZKc3bEud5JGxiOlhj4cgnhQ0ZeW8yokkfKw/2oZCXNC+Iv
	1UxCmT7WwdgMouONYs6Tq/s=
X-Google-Smtp-Source: AMsMyM6AMXawkWYHKDXpDq2cj5mNaNO+FK67QR/QjOByGCW5d4vl+8RfPLYmQQ/eo1fo63+MePmMIA==
X-Received: by 2002:a05:620a:d5e:b0:6f9:2690:d33f with SMTP id o30-20020a05620a0d5e00b006f92690d33fmr48087596qkl.524.1668103560303;
        Thu, 10 Nov 2022 10:06:00 -0800 (PST)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id v11-20020a05622a188b00b0039a55f78792sm11728699qtc.89.2022.11.10.10.05.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 10:05:59 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
	by mailauth.nyi.internal (Postfix) with ESMTP id 4D92A27C005B;
	Thu, 10 Nov 2022 13:05:59 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Thu, 10 Nov 2022 13:05:59 -0500
X-ME-Sender: <xms:hj1tY1qnfDmEszRxtGf7tRcLkcafT3ZABJg82w1wOsY6EUCXBqDQHQ>
    <xme:hj1tY3o5XBOc7s2UDgS7u3AD_AyTw7pYzNvYsqTZSlLHT0nhd-qbV844bG3Vd6TtL
    eL8Hmy5CugBEzRA7Q>
X-ME-Received: <xmr:hj1tYyNtwNmjufnLZq7S2O_5T2litUFLkdZB5jrVBsFXSciwu2Wra9easnAj>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrfeeggdduuddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehoqhhu
    nhcuhfgvnhhguceosghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmqeenucggtffrrg
    htthgvrhhnpeehudfgudffffetuedtvdehueevledvhfelleeivedtgeeuhfegueeviedu
    ffeivdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    gsohhquhhnodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdeiledvgeehtdei
    gedqudejjeekheehhedvqdgsohhquhhnrdhfvghngheppehgmhgrihhlrdgtohhmsehfih
    igmhgvrdhnrghmvg
X-ME-Proxy: <xmx:hj1tYw5WI9SpFYLoQVzfZPDlPH_obhAtJpDpGE8Iwxrf2iEHXg9FcA>
    <xmx:hj1tY078h8edzXE-iiA7l-ABYg8w-bCHwfibrIx1JO5KmUeMFhwWVg>
    <xmx:hj1tY4gdY96X7Sp5m7FM-6uCBobu3xqdIm4yDSveRMbR_ZDDOenTtg>
    <xmx:hz1tYzYWj2AQwFQKbAu8lsJf0As13mlK7avC0VS5TLkyVN8wyAtMZQ>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 10 Nov 2022 13:05:58 -0500 (EST)
Date: Thu, 10 Nov 2022 10:05:57 -0800
From: Boqun Feng <boqun.feng@gmail.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v1 01/28] rust: prelude: split re-exports into groups
Message-ID: <Y209hbMmb4V3eBh6@Boquns-Mac-mini.local>
References: <20221110164152.26136-1-ojeda@kernel.org>
 <20221110164152.26136-2-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221110164152.26136-2-ojeda@kernel.org>

On Thu, Nov 10, 2022 at 05:41:13PM +0100, Miguel Ojeda wrote:
> Split the prelude re-exports into groups: first the ones coming
> from the `core` crate, then `alloc`, then our own crates and
> finally the ones from modules from `kernel` itself (i.e. `super`).
> 
> We are doing this manually for the moment, but ideally, long-term,
> this could be automated via `rustfmt` with options such as
> `group_imports` and `imports_granularity` (both currently unstable).
> 
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Boqun Feng <boqun.feng@gmail.com>

Regards,
Boqun

> ---
>  rust/kernel/prelude.rs | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/rust/kernel/prelude.rs b/rust/kernel/prelude.rs
> index 495e22250726..f8219285d8c0 100644
> --- a/rust/kernel/prelude.rs
> +++ b/rust/kernel/prelude.rs
> @@ -11,10 +11,14 @@
>  //! use kernel::prelude::*;
>  //! ```
>  
> -pub use super::{
> -    error::{Error, Result},
> -    pr_emerg, pr_info, ThisModule,
> -};
> -pub use alloc::{boxed::Box, vec::Vec};
>  pub use core::pin::Pin;
> +
> +pub use alloc::{boxed::Box, vec::Vec};
> +
>  pub use macros::module;
> +
> +pub use super::{pr_emerg, pr_info};
> +
> +pub use super::error::{Error, Result};
> +
> +pub use super::ThisModule;
> -- 
> 2.38.1
> 
