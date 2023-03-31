Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279D98F54
	for <patches@lists.linux.dev>; Fri, 31 Mar 2023 21:53:09 +0000 (UTC)
Received: by mail-qv1-f46.google.com with SMTP id jl13so17307544qvb.10
        for <patches@lists.linux.dev>; Fri, 31 Mar 2023 14:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680299588;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t7Ebxk8AphIDmwnXn1+IjoPN5NSZTsfBvhDF5oJh7jY=;
        b=O2vDYkYf5AsS15gx5pSGjZzR6Axng0uCxYsCxypYqA8N355Ct3GQEHLuomCfkdNgGf
         O1AOHCQfDybxI37EoT/og7LwSDTNkJptBb51ywn9oT2hX2rTiAbIdGTJGDsPUhmu5e1o
         zN5ce0TVqX57WIMf6WoSSxSOVHx3KMNo4v8AthMjHAWxxxmpEJq5Wy3ELITEpps2kxYa
         w9hj/vCFktaYQ4prjPtwQBladnPz4T1oNYFz+yiCnnT/b5OHh6NfPXU7rtW4pmBiSG/F
         Y0WdIZafYKh4lDu9URVZuJ3Z05YdQ/cnm3NlxDxG37fQfoTF38v8Pq2arpjTSfbggUiu
         7M5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680299588;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t7Ebxk8AphIDmwnXn1+IjoPN5NSZTsfBvhDF5oJh7jY=;
        b=LTps+JYmFWMU80ug68XaHgl50/nQsuugJRv7+8wbi0oW4ffyVotr20rB9KBATWGXsf
         4hG71kaXu+lYMB0BKaA+12Zzlh64E7538xhMCcY8pk1t7EBOZi0ShCAqJJB9uBcwbupE
         8Bki3sqPItS1FkU8bYETpFZ0CD7FDVq6/QD4YJmoSuREB+S7OokCLt7lxHuZ5ubBhTht
         +tNLCV0r3CqQ04pXT4rs9wPtgvgTxHhV0VYCcZR4KOndqPDoQk0kkFGbUKGZh+NmPCPw
         VJJJj+HARJ07K0l/yiPsFXm/t0m/k3pUYwVNFPAjyhALew/VxqaeFMiZjYmqo4ZmJAue
         M2Vg==
X-Gm-Message-State: AAQBX9dN+hyNifL1Ij2Pm3VCnQi+FYHqMdO8NeSDz9EzDq6v5NwgnWth
	UOHV1vXyiYQ70LXk2AXPJsk=
X-Google-Smtp-Source: AKy350ZF34ugc9xi1UXbPvmjKXVkZFGlTZq1tjdSY5rb+ySld+VRh+Rw7COi3L1WQX3fT4llp9DseQ==
X-Received: by 2002:ad4:5c6e:0:b0:5ac:239a:9200 with SMTP id i14-20020ad45c6e000000b005ac239a9200mr55249755qvh.9.1680299588087;
        Fri, 31 Mar 2023 14:53:08 -0700 (PDT)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id t18-20020ac87612000000b003e4d96eae60sm893950qtq.4.2023.03.31.14.53.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 14:53:07 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
	by mailauth.nyi.internal (Postfix) with ESMTP id 0B6B827C0054;
	Fri, 31 Mar 2023 17:53:06 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 31 Mar 2023 17:53:07 -0400
X-ME-Sender: <xms:QlYnZCAj5lCMnCKbWwduSoSjONQIWMoyvQQpCluwqZWjZ89U-Yfd8Q>
    <xme:QlYnZMjQAZ9s-G75ZXjNL3Db1hG6jU3I4Sqx8Vl66kkFw3d1sKfSOkwDDTc2hVORu
    thzLr5tLV8boy57SA>
X-ME-Received: <xmr:QlYnZFntGTUuNhfDg4aVu5f5MyFNi1tm8VJr_Ji5mRq88eHFigTkXDw7ZB2-pQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdeivddgtdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehoqhhu
    nhcuhfgvnhhguceosghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmqeenucggtffrrg
    htthgvrhhnpeehudfgudffffetuedtvdehueevledvhfelleeivedtgeeuhfegueeviedu
    ffeivdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    gsohhquhhnodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdeiledvgeehtdei
    gedqudejjeekheehhedvqdgsohhquhhnrdhfvghngheppehgmhgrihhlrdgtohhmsehfih
    igmhgvrdhnrghmvg
X-ME-Proxy: <xmx:QlYnZAxxNyiMy0yc7RSsoNcPgygYljcNVYg9GOCZoMPeGh82OM6UIQ>
    <xmx:QlYnZHSuf8puKaesFqJZ6SM40DAHoub15-AWJq-BS061wyUk10r7nw>
    <xmx:QlYnZLYb8Nr6E0MmfiBeV5XNgiobGBVyBuzwjNg1KcfiBhbtGMmMEA>
    <xmx:QlYnZPaHPISlit1XU3mXDuuWeTGwg6BKMMEvPsSTW5KDOziiyoUilA>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 31 Mar 2023 17:53:05 -0400 (EDT)
Date: Fri, 31 Mar 2023 14:52:18 -0700
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
Subject: Re: [PATCH v4 01/15] rust: enable the `pin_macro` feature
Message-ID: <ZCdWErZLBFl205UP@boqun-archlinux>
References: <20230331215053.585759-1-y86-dev@protonmail.com>
 <20230331215053.585759-2-y86-dev@protonmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230331215053.585759-2-y86-dev@protonmail.com>

On Fri, Mar 31, 2023 at 09:51:35PM +0000, y86-dev@protonmail.com wrote:
> From: Benno Lossin <y86-dev@protonmail.com>
> 
> This feature enables the use of the `pin!` macro for the `stack_pin_init!`
> macro. This feature is already stabilized in Rust version 1.68.
> 
> Signed-off-by: Benno Lossin <y86-dev@protonmail.com>
> Cc: Gary Guo <gary@garyguo.net>
> Cc: Andreas Hindborg <a.hindborg@samsung.com>
> Cc: Alice Ryhl <aliceryhl@google.com>

Acked-by: Boqun Feng <boqun.feng@gmail.com>

Regards,
Boqun

> ---
>  rust/kernel/lib.rs | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
> index 223564f9f0cc..4317b6d5f50b 100644
> --- a/rust/kernel/lib.rs
> +++ b/rust/kernel/lib.rs
> @@ -17,6 +17,7 @@
>  #![feature(core_ffi_c)]
>  #![feature(dispatch_from_dyn)]
>  #![feature(generic_associated_types)]
> +#![feature(pin_macro)]
>  #![feature(receiver_trait)]
>  #![feature(unsize)]
> 
> --
> 2.39.2
> 
> 
