Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BED86D19
	for <patches@lists.linux.dev>; Wed, 17 Aug 2022 20:07:22 +0000 (UTC)
Received: by mail-pg1-f169.google.com with SMTP id q16so12867122pgq.6
        for <patches@lists.linux.dev>; Wed, 17 Aug 2022 13:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=L1J+Db0VnmbiI3Iaaum15jtXnTuosKmaYb/Lkdrr5jE=;
        b=U+gyR2Mo78uIYzbWklKeKt4ZYdel9+/phgy56njeKiM+XlSgX/waUrlrw5+SfCLNVY
         xSEVXltiRRK6gqaK7QEC7WqHfljzsXVLHRQNE7H8NH0JwmVqwyV0Ejps/JAgMjbD423b
         y183iG/Lv20mPJotIXHLSPFvBKTfSLLi7FqM4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=L1J+Db0VnmbiI3Iaaum15jtXnTuosKmaYb/Lkdrr5jE=;
        b=UYT2x8Ovhs75jeMwZnrvDDPGUoaEcyRcZn1x6U07Tgl6ylNPUeUguKguHs/gXBXh6V
         CxyuZGonwY5ToX7e0tUjYBUqjb9lichBSu7OvS79lzM+8I/sUrCF5iP17AVLXJV3IgLh
         TUruCGJMgFr6oQGNi4TG/Vrn0FzwMXhrJ08SIc6/dtBmfgwdRFsGi4mPtBkcfFyk6hRy
         sI7+u9jMrmz5rqESMmU81JEqMXyUgHi5uQMx2adhDPI9vGqH8iD9P81c/HgnUC0SlWPo
         c2wviycL7DzaCRkZ5LVEJOK0WF9i7BLkM9b1fJ5FZh3WL2uYZ0BLb6fLS8j3MYl7ZkRP
         2Szw==
X-Gm-Message-State: ACgBeo1d5M5879JVtrv2DMeMHkOGFm1RNXO24VhoiNMYtZvuY7mL7pme
	2K3GryMzpapl1qjk9+GRPR1C+g==
X-Google-Smtp-Source: AA6agR56B2zJ+PZNRuW9rvybbFIh2ikn6WdkK9CVsOAMnbryGSeDrgue8aGoJ4yGi3x0wgdFS9gvGA==
X-Received: by 2002:a05:6a00:b8c:b0:52e:d6b4:d5a2 with SMTP id g12-20020a056a000b8c00b0052ed6b4d5a2mr26589037pfj.72.1660766841593;
        Wed, 17 Aug 2022 13:07:21 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id w1-20020a170902904100b0016be6a554b5sm302013plz.233.2022.08.17.13.07.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 13:07:20 -0700 (PDT)
Date: Wed, 17 Aug 2022 13:07:19 -0700
From: Kees Cook <keescook@chromium.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@google.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>
Subject: Re: [PATCH v9 07/27] rust: import upstream `alloc` crate
Message-ID: <202208171257.E256DAA@keescook>
References: <20220805154231.31257-1-ojeda@kernel.org>
 <20220805154231.31257-8-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220805154231.31257-8-ojeda@kernel.org>

On Fri, Aug 05, 2022 at 05:41:52PM +0200, Miguel Ojeda wrote:
> This is a subset of the Rust standard library `alloc` crate,
> version 1.62.0, licensed under "Apache-2.0 OR MIT", from:
> 
>     https://github.com/rust-lang/rust/tree/1.62.0/library/alloc/src
> 
> The files are copied as-is, with no modifications whatsoever
> (not even adding the SPDX identifiers).
> 
> For copyright details, please see:
> 
>     https://github.com/rust-lang/rust/blob/1.62.0/COPYRIGHT
> 
> The next patch modifies these files as needed for use within
> the kernel. This patch split allows reviewers to double-check
> the import and to clearly see the differences introduced.

Can you include an easy script (in the commit log) for this kind of
verification?

For this, I have done:

$ git am 0001-rust-import-upstream-alloc-crate.patch
$ for i in $(diffstat -lp3 0001-rust-import-upstream-alloc-crate.patch); do
	wget --quiet -O check.rs \
	 https://github.com/rust-lang/rust/raw/1.62.0/library/alloc/src/$i
	diff -up rust/alloc/$i check.rs && echo $i: ok
	rm -f check.rs
done

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
