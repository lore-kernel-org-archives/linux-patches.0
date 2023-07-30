Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB91C1FA6
	for <patches@lists.linux.dev>; Sun, 30 Jul 2023 15:04:32 +0000 (UTC)
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-3a5a7ebdd9fso2764132b6e.0
        for <patches@lists.linux.dev>; Sun, 30 Jul 2023 08:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690729472; x=1691334272;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=E2zpBBpZBXYPQAISvn06iBuDvpcDOCSrd4IGlSeVlOg=;
        b=YUzPt880xMjeQMJp5vo5iaibSUf3gcr6CPb1B8soLp58TSPeVkarzlCyMd81nrJ8hA
         XcjkyevonHaNc50OmIQ2JfCwWlksvyrzIRtB5cstfosrnQ3iJdFx7saTOQNd2izUmhIk
         wr9n6jy5k6N0cohFrApyduylbhEWAg54PtxHHdIwA/EDZqANE5vhZl30983Rn19Yqph1
         /3l/EgcQ1nZI556xGK3dIGYAadCpidwzHpHL9c7D/ghXy7SZoFnlr2Q64p5Ayp8W4bFA
         bYBir4s4tV1Uykyh9KZ/7Zy82hs+DHBLwg5zXZesjGbvQUQ1bEsuha1Xc70vlmtZa0Yw
         HOKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690729472; x=1691334272;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E2zpBBpZBXYPQAISvn06iBuDvpcDOCSrd4IGlSeVlOg=;
        b=X8c40lcsucaM3GK5mA7lo6+Z276qXabXlEtn/ZQqG6xTr5ZCvbBIyoSNdCOyBA4PC5
         5Bi7sRxIatr7homdhDg5+QFueceDTIXzrO941XNnaM/5VmJqTdEN/5SbpsLbE+RoLTOR
         PzIGdxHjGzO8p6Rpv9TGxwLTl4aK82/fq3yOZnsykWrlvWYgiZ09Yq/k0qWe51VItSUf
         C69RQnM/+3VkyLgw4f47zYe6dMVsOeDUhkmoSeI4whdpWoOaSYHJtHu0vKk8vfMD3ysj
         WnHyQy+wDdEAb5BJwed9EDyFGLSnjSAAWmkBE6vtvroMcFFu3nFaCV4lbk1sFFZkKcso
         hMAw==
X-Gm-Message-State: ABy/qLbZzqwVO4md/5xe7Pk/3Gn5B+b675xE2OXl+y9ImJ96QnljX0V7
	0FvxpvmmeVAF+8HRehmL5QE=
X-Google-Smtp-Source: APBJJlFRpM/b6XQ3u3jjqZBlP4x6bfJrNDWH5Riaw34JWKXMNqMmY3dYXLFkNVdVOiKpxGb/0T+CkA==
X-Received: by 2002:a05:6808:434b:b0:3a4:350e:b226 with SMTP id dx11-20020a056808434b00b003a4350eb226mr6627498oib.33.1690729471583;
        Sun, 30 Jul 2023 08:04:31 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id j19-20020aca1713000000b003a40b3fce01sm3359309oii.10.2023.07.30.08.04.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 30 Jul 2023 08:04:31 -0700 (PDT)
Message-ID: <808c7eb4-abc6-21c9-f929-7070c0da1d05@gmail.com>
Date: Sun, 30 Jul 2023 12:04:26 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] rust: upgrade to Rust 1.71.0
Content-Language: en-US
To: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho
 <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>, Alice Ryhl <aliceryhl@google.com>,
 Andreas Hindborg <a.hindborg@samsung.com>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20230729220317.416771-1-ojeda@kernel.org>
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20230729220317.416771-1-ojeda@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/29/23 19:03, Miguel Ojeda wrote:
> This is the second upgrade to the Rust toolchain, from 1.68.2 to 1.71.0
> (i.e. the latest).
> 
> See the upgrade policy [1] and the comments on the first upgrade in
> commit 3ed03f4da06e ("rust: upgrade to Rust 1.68.2").
> 
> # Unstable features
> 
> No unstable features (that we use) were stabilized.
> 
> Therefore, the only unstable feature allowed to be used outside
> the `kernel` crate is still `new_uninit`, though other code to be
> upstreamed may increase the list.
> 
> Please see [2] for details.
> 
> # Required changes
> 
> For the upgrade, this patch requires the following changes:
> 
>    - Removal of the `__rust_*` allocator functions, together with
>      the addition of the `__rust_no_alloc_shim_is_unstable` static.
>      See [3] for details.
> 
>    - Some more compiler builtins added due to `<f{32,64}>::midpoint()`
>      that got added in Rust 1.71 [4].
> 
> # `alloc` upgrade and reviewing
> 
> The vast majority of changes are due to our `alloc` fork being upgraded
> at once.
> 
> There are two kinds of changes to be aware of: the ones coming from
> upstream, which we should follow as closely as possible, and the updates
> needed in our added fallible APIs to keep them matching the newer
> infallible APIs coming from upstream.
> 
> Instead of taking a look at the diff of this patch, an alternative
> approach is reviewing a diff of the changes between upstream `alloc` and
> the kernel's. This allows to easily inspect the kernel additions only,
> especially to check if the fallible methods we already have still match
> the infallible ones in the new version coming from upstream.
> 
> Another approach is reviewing the changes introduced in the additions in
> the kernel fork between the two versions. This is useful to spot
> potentially unintended changes to our additions.
> 
> To apply these approaches, one may follow steps similar to the following
> to generate a pair of patches that show the differences between upstream
> Rust and the kernel (for the subset of `alloc` we use) before and after
> applying this patch:
> 
>      # Get the difference with respect to the old version.
>      git -C rust checkout $(linux/scripts/min-tool-version.sh rustc)
>      git -C linux ls-tree -r --name-only HEAD -- rust/alloc |
>          cut -d/ -f3- |
>          grep -Fv README.md |
>          xargs -IPATH cp rust/library/alloc/src/PATH linux/rust/alloc/PATH
>      git -C linux diff --patch-with-stat --summary -R > old.patch
>      git -C linux restore rust/alloc
> 
>      # Apply this patch.
>      git -C linux am rust-upgrade.patch
> 
>      # Get the difference with respect to the new version.
>      git -C rust checkout $(linux/scripts/min-tool-version.sh rustc)
>      git -C linux ls-tree -r --name-only HEAD -- rust/alloc |
>          cut -d/ -f3- |
>          grep -Fv README.md |
>          xargs -IPATH cp rust/library/alloc/src/PATH linux/rust/alloc/PATH
>      git -C linux diff --patch-with-stat --summary -R > new.patch
>      git -C linux restore rust/alloc
> 
> Now one may check the `new.patch` to take a look at the additions (first
> approach) or at the difference between those two patches (second
> approach). For the latter, a side-by-side tool is recommended.
> 
> Link: https://rust-for-linux.com/rust-version-policy [1]
> Link: https://github.com/Rust-for-Linux/linux/issues/2 [2]
> Link: https://github.com/rust-lang/rust/pull/86844 [3]
> Link: https://github.com/rust-lang/rust/pull/92048 [4]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
> Based on top of `rust-next`, since we want to be on top of commit
> 7c74839b2acc ("rust: alloc: Add realloc and alloc_zeroed to the
> GlobalAlloc impl"), in order to be able to simply remove the `__rust_*`
> functions here.
> 
> [...]
Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
