Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74EBD4406
	for <patches@lists.linux.dev>; Wed, 28 Sep 2022 15:29:47 +0000 (UTC)
Received: by mail-wr1-f44.google.com with SMTP id cc5so20375762wrb.6
        for <patches@lists.linux.dev>; Wed, 28 Sep 2022 08:29:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=U4dfxCOtpXm2iIv192KdpqzJp/F1yD6Pk1tXFLgpuUI=;
        b=uIeerOjgiXyY5pNZ7ngdn0mGMWzF34yt8psuJlHrEya4C1PXHc8/92WNt4VjZujveI
         FYutx0PEba847RUBM2MyNroTcMHFh308QN6gpSd+XRLPtOyR/YGecxSlpav1ojlBBU8j
         qLBo9tsEs8nb1NfvbD2dm1/U/jbzM5fQ7bFMnT88XB89IQTNaEE8ph+TaBedXGbJ41aU
         agsjUwQzd80ODkaZmUFOt0BD9y5jreMNYc1sxARrW0J7RZsjhlVoSDTFs0QpAEcApD0K
         Ouwai/GnvXjP/a1O/SIxnpHQ2f3QlncYFwUmejiIVUsncJUMuIUCQKrAddaIBS990Dmm
         DCRA==
X-Gm-Message-State: ACrzQf1lSyhbMmUpYj4yFEP16i+agPdCUXDKrKp2xHsWZWTYc2DLWoL8
	AS/DsRNbxyGjE50R3JxsMaw=
X-Google-Smtp-Source: AMsMyM5OTNW6IKVdBtKnKaByGNB9jKdBhPhqyWANjliIhwqeqFJZczom9Bz3OlzRDDx7ON7PTYOFEQ==
X-Received: by 2002:adf:f7c7:0:b0:22c:be66:dd6f with SMTP id a7-20020adff7c7000000b0022cbe66dd6fmr6155609wrq.144.1664378985754;
        Wed, 28 Sep 2022 08:29:45 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id j19-20020a05600c1c1300b003a5ca627333sm2391110wms.8.2022.09.28.08.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 08:29:45 -0700 (PDT)
Date: Wed, 28 Sep 2022 15:29:43 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>, Finn Behrens <me@kloenk.de>,
	Adam Bratschi-Kaye <ark.email@gmail.com>,
	Wedson Almeida Filho <wedsonaf@google.com>,
	Sumera Priyadarsini <sylphrenadin@gmail.com>,
	Gary Guo <gary@garyguo.net>, Matthew Bakhtiari <dev@mtbk.me>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Wei Liu <wei.liu@kernel.org>
Subject: Re: [PATCH v10 10/27] rust: add `macros` crate
Message-ID: <YzRoZwhxE4182cm2@liuwe-devbox-debian-v2>
References: <20220927131518.30000-1-ojeda@kernel.org>
 <20220927131518.30000-11-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927131518.30000-11-ojeda@kernel.org>

On Tue, Sep 27, 2022 at 03:14:41PM +0200, Miguel Ojeda wrote:
> This crate contains all the procedural macros ("proc macros")
> shared by all the kernel.
> 
> Procedural macros allow to create syntax extensions. They run at
> compile-time and can consume as well as produce Rust syntax.
> 
> For instance, the `module!` macro that is used by Rust modules
> is implemented here. It allows to easily declare the equivalent
> information to the `MODULE_*` macros in C modules, e.g.:
> 
>     module! {
>         type: RustMinimal,
>         name: b"rust_minimal",
>         author: b"Rust for Linux Contributors",
>         description: b"Rust minimal sample",
>         license: b"GPL",
>     }

I don't use / know much of procedural macros, so I don't feel like I'm
qualified to review this patch.

Just a general question: what is the house rule for adding new proc
macros? They are powerful tools. I can see their value in `module!`
because writing all that boilerplate by hand is just painful. Yet they
are not straightforward to understand. It is difficult, just by looking
at the macro, to fully grasp what the final code looks like (though the
rsi target will help). Is there a concern that proc macro gets abused?

Thanks,
Wei.
