Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12967460
	for <patches@lists.linux.dev>; Wed, 17 Aug 2022 20:14:34 +0000 (UTC)
Received: by mail-pf1-f173.google.com with SMTP id p125so12962555pfp.2
        for <patches@lists.linux.dev>; Wed, 17 Aug 2022 13:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=FbyLuHm2xhCUGL19AXt8ffDVo0+YYpSKzX1/TVHy8eM=;
        b=Lv35uPWK2dCxFc6yKVS0QrTwKJd+DyqJAJDYLYlMNmXnRdKNAscIzcoSbCxJgpBnQB
         wQyvuIuUxU1fialRwVmxITfAZuI+GS568dLSXNWfMr5o3ox+DM5xajm7FgElyHdDnT46
         zfV825m20a/8rKJz/wJGMOGiHSoVcZptheJsM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=FbyLuHm2xhCUGL19AXt8ffDVo0+YYpSKzX1/TVHy8eM=;
        b=rigEK9E/QE1u1aUMI//kX4h/6yuJYWeR8rXbq5sSIfyw93vXYbndF4uBJrf8UYN0nw
         CTskbtFMfJyG/wn9esl3yb9VeAZqkrA1N32qsO29U8B+PXyo6sr5CY34EMq8fX31fq2Q
         ZNR/6wFm8i0EW3Xdnxd1A3xM8dNUZcslzPal3/KgcMLPDLrt1Q0u0bYVWaavMOtQxp6f
         90Sob0DI4vjEai1UFPR1ltS1ibpqkfW2x7+GJT4JNWIEr+sSlgUSdlyKydBjdOrGYiMM
         BGRqucNs8RkCNoF0B2nS4Izj9STXpdyBXxWJjfU77PlHvoea8RoIbCd+QqsOfHRgwaf1
         nR3g==
X-Gm-Message-State: ACgBeo172RJCfkg8Ql+tEMtI+E0liXFTRF3lWbr5WZ7QQD1JD3g6eqCi
	MdW+tCZyhp2YK1Cmt3hRuOezbQ==
X-Google-Smtp-Source: AA6agR5BHQ+uwX7K+UI84QLWNJT1fb4lGGawfZJ9CNwTPRxCSbqxFPJWBKPpaXPBRf6W1dCupD0O8g==
X-Received: by 2002:a65:458c:0:b0:428:ee87:33a8 with SMTP id o12-20020a65458c000000b00428ee8733a8mr13953189pgq.272.1660767274298;
        Wed, 17 Aug 2022 13:14:34 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id e3-20020a056a0000c300b0052e7f103138sm10910092pfj.38.2022.08.17.13.14.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 13:14:33 -0700 (PDT)
Date: Wed, 17 Aug 2022 13:14:32 -0700
From: Kees Cook <keescook@chromium.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@google.com>,
	David Gow <davidgow@google.com>, Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>
Subject: Re: [PATCH v9 19/27] scripts: add `generate_rust_target.rs`
Message-ID: <202208171314.D38EF72778@keescook>
References: <20220805154231.31257-1-ojeda@kernel.org>
 <20220805154231.31257-20-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220805154231.31257-20-ojeda@kernel.org>

On Fri, Aug 05, 2022 at 05:42:04PM +0200, Miguel Ojeda wrote:
> This script takes care of generating the custom target specification
> file for `rustc`, based on the kernel configuration.
> 
> It also serves as an example of a Rust host program.
> 
> A dummy architecture is kept in this patch so that a later patch
> adds x86 support on top with as few changes as possible.
> 
> Co-developed-by: Alex Gaynor <alex.gaynor@gmail.com>
> Signed-off-by: Alex Gaynor <alex.gaynor@gmail.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
