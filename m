Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE354682
	for <patches@lists.linux.dev>; Wed, 28 Sep 2022 14:49:22 +0000 (UTC)
Received: by mail-wm1-f51.google.com with SMTP id e10-20020a05600c4e4a00b003b4eff4ab2cso1406988wmq.4
        for <patches@lists.linux.dev>; Wed, 28 Sep 2022 07:49:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=b++TaSXpJUvwsLorqpvjYCrKiWF0sRAAlUL/l9wAjnM=;
        b=rR3f/DU+1HpaG7wo16sCy1DXxg5+PPTT424h+7yy5gSx0yFtWsovGIX8t1kZPv0ku9
         BQkh5amE0wbDd3KOa0CBPICQ3aJTZm4890AG9DZdnsHyAO8i1PkZb0Ha2m04teDr9+c/
         hbOwBzeeFi1Ce7J8X3mFUrFu8PHdFDBMJmCcpb5Zq/dVs8Riu5CLKrcVlZPzsSYPo05h
         0hlhBaJqaUrs0mqbCHGePw3pi+t6rUk/Z+UuMEanlBafDtmFZ5QmrXUUH3TMaTjoW7Wi
         uFWhk+6vUciNfK5UapSZS/nXKtXm8oIxhcQ3cjSIisPIowiD6kJVUVa0kHbKH4rqSM1/
         twcA==
X-Gm-Message-State: ACrzQf3RFycpC0jKuUUeNGIQ5uQ4BH1+E8cCRJ7cRgzCpMqPUNqiiMRU
	dDVLLKMKYI3EN3IUEsyo6B8=
X-Google-Smtp-Source: AMsMyM4BICEsTCiOwKDYNZM6kA80a/1z/SDCkkFsgQ5RHyVrv0H+SFEHVYvZEBLAVJfET0dprJibhw==
X-Received: by 2002:a1c:7315:0:b0:3b4:e1b8:47b2 with SMTP id d21-20020a1c7315000000b003b4e1b847b2mr7119813wmb.165.1664376561208;
        Wed, 28 Sep 2022 07:49:21 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id b8-20020a5d45c8000000b0022ca921dc67sm4325744wrs.88.2022.09.28.07.49.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 07:49:20 -0700 (PDT)
Date: Wed, 28 Sep 2022 14:49:16 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@google.com>,
	Finn Behrens <me@kloenk.de>, Miguel Cano <macanroj@gmail.com>,
	Tiago Lam <tiagolam@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Wei Liu <wei.liu@kernel.org>
Subject: Re: [PATCH v10 20/27] scripts: add `rust_is_available.sh`
Message-ID: <YzRe7NX4rRwor3QL@liuwe-devbox-debian-v2>
References: <20220927131518.30000-1-ojeda@kernel.org>
 <20220927131518.30000-21-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927131518.30000-21-ojeda@kernel.org>

On Tue, Sep 27, 2022 at 03:14:51PM +0200, Miguel Ojeda wrote:
> This script tests whether the Rust toolchain requirements are in place
> to enable Rust support. It uses `min-tool-version.sh` to fetch
> the version numbers.
> 
> The build system will call it to set `CONFIG_RUST_IS_AVAILABLE` in
> a later patch.
> 
> It also has an option (`-v`) to explain what is missing, which is
> useful to set up the development environment. This is used via
> the `make rustavailable` target added in a later patch.
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Co-developed-by: Alex Gaynor <alex.gaynor@gmail.com>
> Signed-off-by: Alex Gaynor <alex.gaynor@gmail.com>
> Co-developed-by: Wedson Almeida Filho <wedsonaf@google.com>
> Signed-off-by: Wedson Almeida Filho <wedsonaf@google.com>
> Co-developed-by: Finn Behrens <me@kloenk.de>
> Signed-off-by: Finn Behrens <me@kloenk.de>
> Co-developed-by: Miguel Cano <macanroj@gmail.com>
> Signed-off-by: Miguel Cano <macanroj@gmail.com>
> Co-developed-by: Tiago Lam <tiagolam@gmail.com>
> Signed-off-by: Tiago Lam <tiagolam@gmail.com>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Wei Liu <wei.liu@kernel.org>
