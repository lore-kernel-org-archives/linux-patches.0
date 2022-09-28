Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3962103
	for <patches@lists.linux.dev>; Wed, 28 Sep 2022 14:23:38 +0000 (UTC)
Received: by mail-wr1-f44.google.com with SMTP id m4so5720449wrr.5
        for <patches@lists.linux.dev>; Wed, 28 Sep 2022 07:23:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=mFcQzaNt7lB5NgLGuk0y5Jq2O1gMF6tf08IwQo9puOM=;
        b=areuvEJmBg9/XuG1QCzysFXijo4P+1o2i6EIa5DcJUMXJNUy1OLLdQRmOy6ixW/fVX
         C5rwtQsA59WYcpYXVLSpNb07wlkvglTENoivi1ZuNuvO8ydJEJnpsT/77w/uSmnjhoO8
         RekivAti3wHueUaYvtxdDSrI0I36clwKVNDd+9vmXkH2VCCeJME7fqRLxPgmx2JQri0o
         74Cnl69sepORpvsWvR6MccnBn4s/L9C6eZ539rM2AcZ7FBkgbL1H8XKR/bqvKXaeqPvq
         hh6rXzwZ1nBUlTukBmMdjGyCAvn5RxdasueyvR/Qjm1krZCz3ITeh9N6bSaATEZ2Ye5O
         HVbQ==
X-Gm-Message-State: ACrzQf11iLEewotdrQi84Rd3qOE+gvr15HCgMupm+mzs+3mgExTsOn6M
	weel/s+A94fWsnfmRK4xbfA=
X-Google-Smtp-Source: AMsMyM4A35IvCHXOo7o0KiszcrKYBNlUbkmxsEcP8E5OgZYnXdM2PTBm8J0+c9svSjderpHlnmzrGA==
X-Received: by 2002:a5d:6e92:0:b0:22c:c09c:8f23 with SMTP id k18-20020a5d6e92000000b0022cc09c8f23mr5707080wrz.389.1664375016787;
        Wed, 28 Sep 2022 07:23:36 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id fc10-20020a05600c524a00b003b435c41103sm2900459wmb.0.2022.09.28.07.23.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 07:23:36 -0700 (PDT)
Date: Wed, 28 Sep 2022 14:23:34 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Alex Gaynor <alex.gaynor@gmail.com>, Finn Behrens <me@kloenk.de>,
	Wedson Almeida Filho <wedsonaf@google.com>,
	Milan Landaverde <milan@mdaverde.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Wei Liu <wei.liu@kernel.org>
Subject: Re: [PATCH v10 26/27] samples: add first Rust examples
Message-ID: <YzRY5ioq36gVFGCl@liuwe-devbox-debian-v2>
References: <20220927131518.30000-1-ojeda@kernel.org>
 <20220927131518.30000-27-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927131518.30000-27-ojeda@kernel.org>

On Tue, Sep 27, 2022 at 03:14:57PM +0200, Miguel Ojeda wrote:
> The beginning of a set of Rust modules that showcase how Rust
> modules look like and how to use the abstracted kernel features.
> 
> It also includes an example of a Rust host program with
> several modules.
> 
> These samples also double as tests in the CI.
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Co-developed-by: Alex Gaynor <alex.gaynor@gmail.com>
> Signed-off-by: Alex Gaynor <alex.gaynor@gmail.com>
> Co-developed-by: Finn Behrens <me@kloenk.de>
> Signed-off-by: Finn Behrens <me@kloenk.de>
> Co-developed-by: Wedson Almeida Filho <wedsonaf@google.com>
> Signed-off-by: Wedson Almeida Filho <wedsonaf@google.com>
> Co-developed-by: Milan Landaverde <milan@mdaverde.com>
> Signed-off-by: Milan Landaverde <milan@mdaverde.com>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Wei Liu <wei.liu@kernel.org>
