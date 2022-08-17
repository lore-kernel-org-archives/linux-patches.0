Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4C27460
	for <patches@lists.linux.dev>; Wed, 17 Aug 2022 20:12:01 +0000 (UTC)
Received: by mail-pj1-f54.google.com with SMTP id x63-20020a17090a6c4500b001fabbf8debfso2077244pjj.4
        for <patches@lists.linux.dev>; Wed, 17 Aug 2022 13:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=HfC3dMpEngb7r9gnYszZZUkGHTRJbCSwAF6hsjZawl8=;
        b=VgN2NI+Ezj1YnwZA75qkUzO3odm7nQ/YsFK2soo32JnPYdtR6gEuOdUGqLBg8c5ktf
         fCo70wM3ALHe+y+fUNIROShP5H6+3xzGZPkl98pJmQZYK+HzHeTl7B8BF44BfwOOv+ir
         h+sT7VUYnSBUCMIx81qQvnB+TETrbRV0froDc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=HfC3dMpEngb7r9gnYszZZUkGHTRJbCSwAF6hsjZawl8=;
        b=iCD8PMbs5KR8BuSdRr9/sVVXTMIZf/eCgyt1K4CFMDfTIMEzHa1vZJFaCUxkeMubEK
         Fe5OFoiRcBYs3L43309Sl00tU+o9sVhD/hMPD4+Jwy1PRFrmvV3sKosfGAumbMy1xncD
         jl+S9vLz9iOQfyeYg6ewlph8QfSB+ZliPqU5TeNHmmDw7YqtasJnJEf33koQj2rFHR6z
         L+bJAjIrOaWDv6sSzL6db6C2JsgMrir6jQHUxIJVNb3UbhCKWPwjYeCj5n6M4l5nUq7a
         NE17Xzv0o6O1kHRvEijXSCI6aTzvKQ64WzbIY5RoMaAAtJbOGF0zHaFX6jdepE2z3S8r
         wftQ==
X-Gm-Message-State: ACgBeo0z47uZz9t8DH1UeBT3/K5Sq2737T79mjVPZILTHt7Yx/5VCWPE
	8YQSrsUk+da1j97sijuvF8xihg==
X-Google-Smtp-Source: AA6agR5O8XGj1uDOVttCpuLlRr7eJO5srWmKa+1LSIBXqFLAGYz3aii6rcP0HxPmAHhk8CX5FB3voQ==
X-Received: by 2002:a17:903:1246:b0:171:5033:85c with SMTP id u6-20020a170903124600b001715033085cmr27932780plh.146.1660767120719;
        Wed, 17 Aug 2022 13:12:00 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id j15-20020a170903024f00b0015e8d4eb1d7sm346970plh.33.2022.08.17.13.11.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 13:11:59 -0700 (PDT)
Date: Wed, 17 Aug 2022 13:11:58 -0700
From: Kees Cook <keescook@chromium.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@google.com>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>
Subject: Re: [PATCH v9 13/27] rust: export generated symbols
Message-ID: <202208171311.73A2CAAA6@keescook>
References: <20220805154231.31257-1-ojeda@kernel.org>
 <20220805154231.31257-14-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220805154231.31257-14-ojeda@kernel.org>

On Fri, Aug 05, 2022 at 05:41:58PM +0200, Miguel Ojeda wrote:
> All symbols are reexported reusing the `EXPORT_SYMBOL_GPL` macro
> from C. The lists of symbols are generated on the fly.
> 
> There are three main sets of symbols to distinguish:
> 
>   - The ones from the `core` and `alloc` crates (from the Rust
>     standard library). The code is licensed as Apache/MIT.
> 
>   - The ones from our abstractions in the `kernel` crate.
> 
>   - The helpers (already exported since they are not generated).
> 
> We export everything as GPL. This ensures we do not mistakenly
> expose GPL kernel symbols/features as non-GPL, even indirectly.
> 
> Co-developed-by: Alex Gaynor <alex.gaynor@gmail.com>
> Signed-off-by: Alex Gaynor <alex.gaynor@gmail.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
