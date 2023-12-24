Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2029D528
	for <patches@lists.linux.dev>; Sun, 24 Dec 2023 19:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BU7aeQCs"
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-35ffb15244dso4881555ab.1
        for <patches@lists.linux.dev>; Sun, 24 Dec 2023 11:49:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703447380; x=1704052180; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1a9E1LViCf6D+7FBiOySiyQNCFNcTHBrGbKDaNup/O8=;
        b=BU7aeQCsYwUFUb3lS3tIs4cILpW7puO7YISeQl2lc5oMx5Y7WgnAISSCwjLLi22Bo6
         /5GXAMOLS8dlRo/KuRNSn0UFhvc1vGLlVCKseu+2rBst0TWH+VAKFVzusCB5UtUQNz3D
         ntmR9+V6g5aGke4yMCav022+Ah5YnaZOZeU/YCbfLgeQ4kglAKfc+f21ObP4FGpVN5tT
         552Y83xZCWC3GTuB3z4Ju5fTzwQROPeseThlNpTtNG314WfgDM/wss4FSFJfcWnn77NW
         6fXKD9KN26U1eQBQvSba6zX/gWoGFtvnxyX2Kqm0J/IHi+kZERr8hGIZphMJYjK7qgf7
         6mdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703447380; x=1704052180;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1a9E1LViCf6D+7FBiOySiyQNCFNcTHBrGbKDaNup/O8=;
        b=HK/PqIijWjK8sdvsM91Z8EkOATXBRAx/5JzqxemK9UFyodUUCjJqFYyNA4q3uNLA6G
         srrj7A5/ZMARfviGsZBK3za3U/TKO1EN3hJb3mtjAv4T6RTlMbz2lx0pqQzVAsp4p5cc
         BN1oy1AdTeisloIALY/mcHTXkh3X8Er9T5NUP7FlKGp65aZdn/z+zUMsxfDUT1HhYPC0
         RQSnmSxonJ0MOXdq6LLx5YVEYaiYS2mDdz8TjklidHW8RaLmbKjj68GTUByDawzSR6Zw
         cJDKNmB0JMJaf8wqlCrLJZhzXXOMWhBt+YIkXQ6fPHJK/RcV7ec2S4JuDYjHYUnhBN58
         mlFQ==
X-Gm-Message-State: AOJu0YxAFBtvbw5RFISD5Goxr3fPhp3v9TA6THQJZo3AXh1q1uuLGice
	w8uGYVoH0jdhxv5DSeJTGco=
X-Google-Smtp-Source: AGHT+IGAv75SOEMOaoQf6DNB5iKcUoA67G9VSjxhXvVSr6nViVbqMGDPacmo4DLtXXfQQYdGpQyzSw==
X-Received: by 2002:a05:6e02:1b8e:b0:35f:f1a9:8149 with SMTP id h14-20020a056e021b8e00b0035ff1a98149mr4253511ili.30.1703447379776;
        Sun, 24 Dec 2023 11:49:39 -0800 (PST)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id m25-20020aa78a19000000b006d9b38f2e75sm1310557pfa.32.2023.12.24.11.49.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Dec 2023 11:49:39 -0800 (PST)
Message-ID: <4e5ea975-c423-4878-b368-ad033875fe1a@gmail.com>
Date: Sun, 24 Dec 2023 16:49:34 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] rust: upgrade to Rust 1.75.0
To: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho
 <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>,
 Andreas Hindborg <a.hindborg@samsung.com>, Alice Ryhl
 <aliceryhl@google.com>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20231224172128.271447-1-ojeda@kernel.org>
Content-Language: en-US
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20231224172128.271447-1-ojeda@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/24/23 14:21, Miguel Ojeda wrote:
> This is the next upgrade to the Rust toolchain, from 1.74.1 to 1.75.0
> (i.e. the latest) [1].
> 
> See the upgrade policy [2] and the comments on the first upgrade in
> commit 3ed03f4da06e ("rust: upgrade to Rust 1.68.2").
> 
> # Unstable features
> 
> The `const_maybe_uninit_zeroed` unstable feature [3] was stabilized in
> Rust 1.75.0, which we were using in the PHYLIB abstractions.
> 
> The only unstable features allowed to be used outside the `kernel` crate
> are still `new_uninit,offset_of`, though other code to be upstreamed
> may increase the list.
> 
> Please see [4] for details.
> 
> # Other improvements
> 
> Rust 1.75.0 stabilized `pointer_byte_offsets` [5] which we could
> potentially use as an alternative for `ptr_metadata` in the future.
> 
> # Required changes
> 
> For this upgrade, no changes were required (i.e. on our side).
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
> Link: https://github.com/rust-lang/rust/blob/stable/RELEASES.md#version-1750-2023-12-28 [1]
> Link: https://rust-for-linux.com/rust-version-policy [2]
> Link: https://github.com/rust-lang/rust/issues/91850 [3]
> Link: https://github.com/Rust-for-Linux/linux/issues/2 [4]
> Link: https://github.com/rust-lang/rust/issues/96283 [5]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
> [...]

Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
