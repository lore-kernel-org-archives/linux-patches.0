Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE756110C
	for <patches@lists.linux.dev>; Fri,  2 Dec 2022 18:31:31 +0000 (UTC)
Received: by mail-wm1-f48.google.com with SMTP id h4-20020a1c2104000000b003d0760654d3so5683073wmh.4
        for <patches@lists.linux.dev>; Fri, 02 Dec 2022 10:31:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CeBhZUYHhg3CPbWZDIA1bo33xmoBi75eG+8d6a4d4JY=;
        b=HNoL/RBOV0wYZn3vKkXM0U3A40RdG2UzxIt0G02frOdo5D6IcjGJIGaVXLb06iZgng
         1ppIpT0QKM1mMYdMdUXbEsya0kPq6EfHeRTXraWE0kUXxHgp7OEDoLjejdrZ0++2uReu
         GvR5JAs0t9JgV48n2Max+FdK789vRcH/3dZE0oY5gj1tIFJyuSzRYI9Vw3XguoOGEerc
         b0TAdBrlZnnCqW2fMmfCgBrmrtgjWNYp89shoOOEDA6c+gqn7Vq+b8TNZr0vzAH8UVae
         ssP4C19BY9t6B4Qxioa/EQBaF10TISgValfjDpqsWea6ekuflL135KjknmAG5+HqMsdC
         LFzA==
X-Gm-Message-State: ANoB5pmZfwVWYQ2BiwJ/+sRs5UYqVV4Ri8WuB1Rcg54R0dEqOV591UdY
	4eRySPEC64DFIH/XB55s6zw7IvJoekc=
X-Google-Smtp-Source: AA0mqf7YWKGvbFv+NOe0n2Yc1e6eeWilHkTtWIurM/uPaNtOOJy7RvYMSBoV4Ge/JPFs2Cz6gtSnAg==
X-Received: by 2002:a05:600c:1e89:b0:3d0:7d89:225a with SMTP id be9-20020a05600c1e8900b003d07d89225amr6390068wmb.167.1670005890235;
        Fri, 02 Dec 2022 10:31:30 -0800 (PST)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id i1-20020adfaac1000000b002238ea5750csm9459625wrc.72.2022.12.02.10.31.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 10:31:29 -0800 (PST)
Date: Fri, 2 Dec 2022 18:31:27 +0000
From: Wei Liu <wei.liu@kernel.org>
To: ojeda@kernel.org
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, Wei Liu <wei.liu@kernel.org>
Subject: Re: [PATCH v2 25/28] rust: add `build_error` crate
Message-ID: <Y4pEf731ylXUkzhF@liuwe-devbox-debian-v2>
References: <20221202161502.385525-1-ojeda@kernel.org>
 <20221202161502.385525-26-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202161502.385525-26-ojeda@kernel.org>

On Fri, Dec 02, 2022 at 05:14:56PM +0100, ojeda@kernel.org wrote:
> From: Gary Guo <gary@garyguo.net>
> 
> The `build_error` crate provides a function `build_error` which
> will panic at compile-time if executed in const context and,
> by default, will cause a build error if not executed at compile
> time and the optimizer does not optimise away the call.
> 
> The `CONFIG_RUST_BUILD_ASSERT_ALLOW` kernel option allows to
> relax the default build failure and convert it to a runtime
> check. If the runtime check fails, `panic!` will be called.
> 
> Its functionality will be exposed to users as a couple macros in
> the `kernel` crate in the following patch, thus some documentation
> here refers to them for simplicity.
> 
> Signed-off-by: Gary Guo <gary@garyguo.net>
> [Reworded, adapted for upstream and applied latest changes]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Wei Liu <wei.liu@kernel.org>
