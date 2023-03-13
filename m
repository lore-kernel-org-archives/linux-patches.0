Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED46228F2
	for <patches@lists.linux.dev>; Mon, 13 Mar 2023 15:30:10 +0000 (UTC)
Received: by mail-qv1-f49.google.com with SMTP id f1so8400617qvx.13
        for <patches@lists.linux.dev>; Mon, 13 Mar 2023 08:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678721410;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jd1uhDexD1fTeVUTZwzyBv6R36OtMUMQh14tizhOt7E=;
        b=TbZj5H4Naew3PShQ5wyJz66N3q4s3E1MumhRPvQO36Eu8hjLCPe1xE41HAezbyWA4j
         y1AfUxQ4uW4PhYSI9e7Ay8BJV7VmDH5jc8FXFXr85IUldk6HS+3GUDRT7QaouBFlj+Rd
         btPL+uYRGb7PbwOWH1oLjW+qoQC+TQv9wn3F+k0NON6denSpjMhqKjiOYmERxN70xU1m
         kQ+4W5taIXIh8PVd6PtPf2JNhyDA1jGujYAZnNrdScXo8D67xLp4OtCJv5t3w7wGxjP0
         h90w4U+rqYqoWr+z6EbubvkchhhbMYnnI572JhU+Of95xG/Yn2rZO6UutvNcQblTx+nT
         alyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678721410;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jd1uhDexD1fTeVUTZwzyBv6R36OtMUMQh14tizhOt7E=;
        b=t1B5YXPQS7Lr9phnC0O3GFp6lodisJbndE7MDcQKjTBFR+xQqqbyzlU0KVxaPNSJfH
         7hyBGPdlFv3hqLsir+TQy/0RrttBtfezcTbQ0Ldqj8K/qT6jHYNN8GUSkuz6Qtr1HKJd
         7zc6J2tj1L2pBSqcXnQXfUcj+JIoT/87jFHVvaoJzAF2QSegBLwSFS3Xw2vaWQo3kOiK
         wULM9hdbeBuqLAsfAYawZjVwMHqaKP/0Yzhu0Pwt5Jwtl37bt2DPvJZrZcKo13J6Tiib
         PZj+udNIxxvKpYN0JN7V5PF6ug2ipsE5QjE7PANO8elebn5BYRb52wyUcp9stC/D7Bpt
         yR6A==
X-Gm-Message-State: AO0yUKVwLjLRcWO4KsIhEgjPtb4ytQ6EjAs2//j91js6xQTkhe6udlHD
	W84lfG59jr2OOLcBz1ChwXY=
X-Google-Smtp-Source: AK7set/9bTJ3eytY6vZKlLwE9CigHsMKhM0Z707By1RQYxGcHEQj6dEWWrHycuixBMgFEi8BtC4jRQ==
X-Received: by 2002:ad4:5aee:0:b0:57e:56f5:5410 with SMTP id c14-20020ad45aee000000b0057e56f55410mr14631652qvh.39.1678721409382;
        Mon, 13 Mar 2023 08:30:09 -0700 (PDT)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id i127-20020a37b885000000b00742a23cada8sm2994956qkf.131.2023.03.13.08.30.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 08:30:08 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
	by mailauth.nyi.internal (Postfix) with ESMTP id 1ADCE27C0054;
	Mon, 13 Mar 2023 11:30:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 13 Mar 2023 11:30:08 -0400
X-ME-Sender: <xms:f0EPZGG8JjoiBJFwsJCirAsg282aecwzlf9GiJ_4GM2rh49f-gWCZg>
    <xme:f0EPZHV3H58oU6zFdx_DvRceRxQpHzoldHekdsQ5UPljOM_a_ANrxGwYNqgnBu7jy
    VITgIssb5sglhJk4A>
X-ME-Received: <xmr:f0EPZAJT9ZK_n0q6oU9fBNKXePN4IG5341Yw_Q8uPJexskcKst0V00c_rSAvSJrd86On-Deh4afW3o8Z7Fbv4tSxGXfTeMV9Q-o>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvddvgedgjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehoqhhu
    nhcuhfgvnhhguceosghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmqeenucggtffrrg
    htthgvrhhnpeehudfgudffffetuedtvdehueevledvhfelleeivedtgeeuhfegueeviedu
    ffeivdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    gsohhquhhnodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdeiledvgeehtdei
    gedqudejjeekheehhedvqdgsohhquhhnrdhfvghngheppehgmhgrihhlrdgtohhmsehfih
    igmhgvrdhnrghmvg
X-ME-Proxy: <xmx:f0EPZAGQw4Fs-kHZQsuejUIRXMlciJNw5GiLp-Sz1na4b7SUesDvvw>
    <xmx:f0EPZMX61M6cC5qbgAsqmRvbKx5eJqyLtRUovs_9On-7tdCXEtinhw>
    <xmx:f0EPZDNgfu5Uc9lprm4izgn7SuIpBPqPz_yKkvxl4bPoQMdwmNeNkA>
    <xmx:f0EPZAoAh8-_hOv0z6O8Y8U_y1gcRUjq5rmjLH9Q-4jQOmnqyNChFg>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 13 Mar 2023 11:30:06 -0400 (EDT)
Date: Mon, 13 Mar 2023 08:30:05 -0700
From: Boqun Feng <boqun.feng@gmail.com>
To: y86-dev <y86-dev@protonmail.com>
Cc: "ojeda@kernel.org" <ojeda@kernel.org>,
	"alex.gaynor@gmail.com" <alex.gaynor@gmail.com>,
	"wedsonaf@gmail.com" <wedsonaf@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	"bjorn3_gh@protonmail.com" <bjorn3_gh@protonmail.com>,
	"rust-for-linux@vger.kernel.org" <rust-for-linux@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH v1 1/3] rust: macros: add `quote!` macro
Message-ID: <ZA9BfSEjAQ9xnZD7@Boquns-Mac-mini.local>
References: <u9FrnEbtGtyUPp-CmzAQIv--8hmKwHdIIPiq-3IHJPcHdaJi_VXuDdVR2Js2GzvtWgCNrBLp4PhQs3tTlWNVDBZfIStCHiS9SoMtsDgc4oM=@protonmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <u9FrnEbtGtyUPp-CmzAQIv--8hmKwHdIIPiq-3IHJPcHdaJi_VXuDdVR2Js2GzvtWgCNrBLp4PhQs3tTlWNVDBZfIStCHiS9SoMtsDgc4oM=@protonmail.com>

On Mon, Mar 13, 2023 at 01:23:18AM +0000, y86-dev wrote:
> From: Gary Guo <gary@garyguo.net>
> 
> Add the `quote!` macro for creating `TokenStream`s directly via the
> given Rust tokens. It also supports repetitions using iterators.
> 
> It will be used by the pin-init API proc-macros to generate code.
> 
> Signed-off-by: Gary Guo <gary@garyguo.net>
> Signed-off-by: Benno Lossin <y86-dev@protonmail.com>

Not sure whether I missed any sutble details, but the macros look
straight-forward. One thing could be improved is having a doc describing
what `quote!` does, a link to the quote crate will do the trick.

Anyway, the code looks good to me.

Acked-by: Boqun Feng <boqun.feng@gmail.com>

Regards,
Boqun

> ---
>  rust/macros/lib.rs   |   2 +
>  rust/macros/quote.rs | 125 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 127 insertions(+)
>  create mode 100644 rust/macros/quote.rs
> 
> diff --git a/rust/macros/lib.rs b/rust/macros/lib.rs
> index c1d385e345b9..82b520f024dd 100644
> --- a/rust/macros/lib.rs
> +++ b/rust/macros/lib.rs
> @@ -2,6 +2,8 @@
>  
>  //! Crate for all kernel procedural macros.
>  
> +#[macro_use]
> +mod quote;
>  mod concat_idents;
>  mod helpers;
>  mod module;
> diff --git a/rust/macros/quote.rs b/rust/macros/quote.rs
> new file mode 100644
> index 000000000000..55b663d665ec
> --- /dev/null
> +++ b/rust/macros/quote.rs
> @@ -0,0 +1,125 @@
> +use proc_macro::{TokenStream, TokenTree};
> +
> +pub(crate) trait ToTokens {
> +    fn to_tokens(&self, tokens: &mut TokenStream);
> +}
> +
> +impl<T: ToTokens> ToTokens for Option<T> {
> +    fn to_tokens(&self, tokens: &mut TokenStream) {
> +        if let Some(v) = self {
> +            v.to_tokens(tokens);
> +        }
> +    }
> +}
> +
> +impl ToTokens for proc_macro::Group {
> +    fn to_tokens(&self, tokens: &mut TokenStream) {
> +        tokens.extend([TokenTree::from(self.clone())]);
> +    }
> +}
> +
> +impl ToTokens for TokenTree {
> +    fn to_tokens(&self, tokens: &mut TokenStream) {
> +        tokens.extend([self.clone()]);
> +    }
> +}
> +
> +impl ToTokens for TokenStream {
> +    fn to_tokens(&self, tokens: &mut TokenStream) {
> +        tokens.extend(self.clone());
> +    }
> +}
> +
> +macro_rules! quote_spanned {
> +    ($span:expr => $($tt:tt)*) => {{
> +        let mut tokens = Vec::new();
> +        let span = $span;
> +        quote_spanned!(@proc tokens span $($tt)*);
> +        proc_macro::TokenStream::from_iter(tokens)
> +    }};
> +    (@proc $v:ident $span:ident) => {};
> +    (@proc $v:ident $span:ident #$id:ident $($tt:tt)*) => {
> +        let mut ts = proc_macro::TokenStream::new();
> +        crate::quote::ToTokens::to_tokens(&$id, &mut ts);
> +        $v.extend(ts.into_iter());
> +        quote_spanned!(@proc $v $span $($tt)*);
> +    };
> +    (@proc $v:ident $span:ident #(#$id:ident)* $($tt:tt)*) => {
> +        for token in $id {
> +            let mut ts = proc_macro::TokenStream::new();
> +            crate::quote::ToTokens::to_tokens(&token, &mut ts);
> +            $v.extend(ts.into_iter());
> +        }
> +        quote_spanned!(@proc $v $span $($tt)*);
> +    };
> +    (@proc $v:ident $span:ident ( $($inner:tt)* ) $($tt:tt)*) => {
> +        let mut tokens = Vec::new();
> +        quote_spanned!(@proc tokens $span $($inner)*);
> +        $v.push(proc_macro::TokenTree::Group(proc_macro::Group::new(
> +            proc_macro::Delimiter::Parenthesis,
> +            proc_macro::TokenStream::from_iter(tokens)
> +        )));
> +        quote_spanned!(@proc $v $span $($tt)*);
> +    };
> +    (@proc $v:ident $span:ident [ $($inner:tt)* ] $($tt:tt)*) => {
> +        let mut tokens = Vec::new();
> +        quote_spanned!(@proc tokens $span $($inner)*);
> +        $v.push(proc_macro::TokenTree::Group(proc_macro::Group::new(
> +            proc_macro::Delimiter::Bracket,
> +            proc_macro::TokenStream::from_iter(tokens)
> +        )));
> +        quote_spanned!(@proc $v $span $($tt)*);
> +    };
> +    (@proc $v:ident $span:ident { $($inner:tt)* } $($tt:tt)*) => {
> +        let mut tokens = Vec::new();
> +        quote_spanned!(@proc tokens $span $($inner)*);
> +        $v.push(proc_macro::TokenTree::Group(proc_macro::Group::new(
> +            proc_macro::Delimiter::Brace,
> +            proc_macro::TokenStream::from_iter(tokens)
> +        )));
> +        quote_spanned!(@proc $v $span $($tt)*);
> +    };
> +    (@proc $v:ident $span:ident :: $($tt:tt)*) => {
> +        $v.push(
> +            proc_macro::TokenTree::Punct(proc_macro::Punct::new(':', proc_macro::Spacing::Joint))
> +        );
> +        $v.push(
> +            proc_macro::TokenTree::Punct(proc_macro::Punct::new(':', proc_macro::Spacing::Alone))
> +        );
> +        quote_spanned!(@proc $v $span $($tt)*);
> +    };
> +    (@proc $v:ident $span:ident : $($tt:tt)*) => {
> +        $v.push(
> +            proc_macro::TokenTree::Punct(proc_macro::Punct::new(':', proc_macro::Spacing::Alone))
> +        );
> +        quote_spanned!(@proc $v $span $($tt)*);
> +    };
> +    (@proc $v:ident $span:ident , $($tt:tt)*) => {
> +        $v.push(
> +            proc_macro::TokenTree::Punct(proc_macro::Punct::new(',', proc_macro::Spacing::Alone))
> +        );
> +        quote_spanned!(@proc $v $span $($tt)*);
> +    };
> +    (@proc $v:ident $span:ident @ $($tt:tt)*) => {
> +        $v.push(
> +            proc_macro::TokenTree::Punct(proc_macro::Punct::new('@', proc_macro::Spacing::Alone))
> +        );
> +        quote_spanned!(@proc $v $span $($tt)*);
> +    };
> +    (@proc $v:ident $span:ident ! $($tt:tt)*) => {
> +        $v.push(
> +            proc_macro::TokenTree::Punct(proc_macro::Punct::new('!', proc_macro::Spacing::Alone))
> +        );
> +        quote_spanned!(@proc $v $span $($tt)*);
> +    };
> +    (@proc $v:ident $span:ident $id:ident $($tt:tt)*) => {
> +        $v.push(proc_macro::TokenTree::Ident(proc_macro::Ident::new(stringify!($id), $span)));
> +        quote_spanned!(@proc $v $span $($tt)*);
> +    };
> +}
> +
> +macro_rules! quote {
> +    ($($tt:tt)*) => {
> +        quote_spanned!(proc_macro::Span::mixed_site() => $($tt)*)
> +    }
> +}
> -- 
> 2.39.2
