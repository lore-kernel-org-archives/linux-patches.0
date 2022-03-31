Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25ACE7E2
	for <patches@lists.linux.dev>; Thu, 31 Mar 2022 04:57:45 +0000 (UTC)
Received: by mail-pl1-f180.google.com with SMTP id j8so12192266pll.11
        for <patches@lists.linux.dev>; Wed, 30 Mar 2022 21:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RdZk9i6x3JUMXUMZExcnmZQSoLNlGLPED3J5A3uwvzA=;
        b=AouGX65RPyNIzjTOwJsTyIqO0ld7tKqu63LKiO4H4YaTnus5DJqytPEigiB578vhkK
         XmFHTMTc4O9rBt+kTr1fnDN3YuObyEDhKu+m884aWlNIJHX+XMjLiREYCay8fAkw6Kv8
         tqah5zQ70EEIBChOv3Ivtq/GLvXlS9MpjIYt8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RdZk9i6x3JUMXUMZExcnmZQSoLNlGLPED3J5A3uwvzA=;
        b=25wuoEP15UiPAzx9JcYfFqTlnVOl0HUP25b0k9/wY3UZw9ujxb4NWK1y+G7Mxkufez
         bNo4kG+iJdLWMQsV+Uena65cznA2q6ZdNXZqmb2wC59L51EWQLBSyV7LiqaIQn4xr87d
         01oYUmrJg/DfDjUVAk7SZpeS2iEAAGKU8fYXYkutP3PeN6R/ixBglsaOf52E5HpAgqn0
         dkq2IB41HSW9VFHidbAhpw8kC/4i9Q+6XTbePpfuYVZD1WWw1vQ41SoP57QRLLOkGX5t
         PxUvsF3ppNSooFepX17/BALNo/Bih6Xmm4rdU5e5JQf9rxTt+g76okInooPBvte7FBTE
         Dm0g==
X-Gm-Message-State: AOAM531M9HOg+pDDwiZFAEVAK5BQuayw1lvQkKoeR9xJWE0Tp7F8E7Rb
	6xz82eG5TpNcrswWBt0kQCf7YQ==
X-Google-Smtp-Source: ABdhPJzfIRpnfEt5n0GvvQSkKx3DziOK9JbR3UnlvHqsQcFI/ZcBzRB0/k/lBwMSJdHfPCI5q3+6wg==
X-Received: by 2002:a17:902:be14:b0:14f:ce67:d0a1 with SMTP id r20-20020a170902be1400b0014fce67d0a1mr3162210pls.29.1648702664441;
        Wed, 30 Mar 2022 21:57:44 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id z9-20020a63b909000000b003823389e47csm20850546pge.9.2022.03.30.21.57.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 21:57:44 -0700 (PDT)
Date: Wed, 30 Mar 2022 21:57:43 -0700
From: Kees Cook <keescook@chromium.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-um@lists.infradead.org, llvm@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH 1/2] kbuild: Remove '-mno-global-merge'
Message-ID: <202203302156.87918948B8@keescook>
References: <20220330234528.1426991-1-nathan@kernel.org>
 <20220330234528.1426991-2-nathan@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220330234528.1426991-2-nathan@kernel.org>

On Wed, Mar 30, 2022 at 04:45:27PM -0700, Nathan Chancellor wrote:
> This flag is specific to clang, where it is only used by the 32-bit and
> 64-bit ARM backends. In certain situations, the presence of this flag
> will cause a warning, as shown by commit 6580c5c18fb3 ("um: clang: Strip
> out -mno-global-merge from USER_CFLAGS").
> 
> Since commit 61163efae020 ("kbuild: LLVMLinux: Add Kbuild support for
> building kernel with Clang") that added this flag back in 2014, there
> have been quite a few changes to the GlobalMerge pass in LLVM. Building
> several different ARCH=arm and ARCH=arm64 configurations with LLVM 11
> (minimum) and 15 (current main version) with this flag removed (i.e.,
> with the default of '-mglobal-merge') reveals no modpost warnings, so it
> is likely that the issue noted in the comment is no longer relevant due
> to changes in LLVM or modpost, meaning this flag can be removed.
> 
> If any new warnings show up that are a result of the removal of this
> flag, it can be added back under arch/arm{,64}/Makefile to avoid
> warnings on other architectures.
> 
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Yeah, this looks right -- the history of this option seems to show it
is no longer needed.

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
