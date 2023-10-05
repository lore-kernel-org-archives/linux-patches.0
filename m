Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C9942BE2
	for <patches@lists.linux.dev>; Thu,  5 Oct 2023 21:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eaSRve0M"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1c364fb8a4cso12182385ad.1
        for <patches@lists.linux.dev>; Thu, 05 Oct 2023 14:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696541447; x=1697146247; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eEZ6HGHY7M39jHS8HQsMgoR34dJ/9xEfGiox94C3KTE=;
        b=eaSRve0Mst6D76JRuQ+Jb28QwpXRTZqpMlhP/TFGB9jcbyjw58LgY2H2X5QADEzsV7
         imi+REmSN5f1Fkgxj5uaGi7ixJAZZfJ+Zwm+h+poZVu73jrrzCa6nlNTBABBNiUllvO+
         5fhb60jQDrPkZiHknXIYuclFvUC+LiVo+HSBPQu+oN7+7CLLl+JqkxfAeTWm96AlMIYo
         EwGxHVy+wn4wfgYxuFu6epj8EjqsXwtuPoA2gVzIcXW4Gb+ihqLBRC/KyftWeJ+LgG7y
         xQhkljKpzuEM+vceXcHh3/tti+QJNub2Vs8V6RlMMnEllMY1goCfCGV7YJZT7rj0QihZ
         weMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696541447; x=1697146247;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eEZ6HGHY7M39jHS8HQsMgoR34dJ/9xEfGiox94C3KTE=;
        b=YvLdydTEPjICFXh6+UzoT687YOxrXnWrG1E4HsrNlcmAwqyUTvQNLokFgbwU8ophWe
         iVfFjeoann75LyFmgwDSclunn+xEOdo+6lXNM1W5N8IJzj6/r7G1861ql6mJumhsm3db
         l14i+VUVcaAYJFTWdOrmj7Tz8kFgS9hqtxH19Z317jXNmlyJc6AYMb06NWV98aZzmZox
         A/YvZuqjuAjN4kZgi7OXvCvWjF9eJHw6XSIdJFvYM6vaEu28NGhqh2OCgpOqd/sPuY0u
         obxXyRbLBkoK8DYRdqkFkVKIN6ebnkntOmwV/DN4GfAdfjHZch0MBF0P4K6O9WcOvnyC
         A0TA==
X-Gm-Message-State: AOJu0YxxBihFH5q7rAVQ/Ku8DV2N5sDNQmTJCxeWIbCyvLJXaisP3oPV
	X79+49eTIAmUg+MwienjL5w=
X-Google-Smtp-Source: AGHT+IEAAKJOemdFQh6i8JbzDMBhV0u3VP1X20yG7F/HYr2B1uqkkb3aY/7Qb20W548P94yx10rOFQ==
X-Received: by 2002:a17:902:e84a:b0:1c2:218c:3754 with SMTP id t10-20020a170902e84a00b001c2218c3754mr7419410plg.53.1696541447132;
        Thu, 05 Oct 2023 14:30:47 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id l7-20020a170903244700b001b8a00d4f7asm2230148pls.9.2023.10.05.14.30.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Oct 2023 14:30:46 -0700 (PDT)
Message-ID: <7a98dc62-924c-4b6a-844d-d6db2b9e5a3b@gmail.com>
Date: Thu, 5 Oct 2023 18:30:21 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] rust: upgrade to Rust 1.73.0
Content-Language: en-US
To: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho
 <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>,
 Andreas Hindborg <a.hindborg@samsung.com>, Alice Ryhl
 <aliceryhl@google.com>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 Jonathan Corbet <corbet@lwn.net>, workflows@vger.kernel.org,
 linux-doc@vger.kernel.org
References: <20231005210556.466856-1-ojeda@kernel.org>
 <20231005210556.466856-4-ojeda@kernel.org>
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20231005210556.466856-4-ojeda@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/5/23 18:05, Miguel Ojeda wrote:
> This is the next upgrade to the Rust toolchain, from 1.72.1 to 1.73.0
> (i.e. the latest) [1].
> 
> See the upgrade policy [2] and the comments on the first upgrade in
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
> Please see [3] for details.
> 
> # Required changes
> 
> For the upgrade, the following changes are required:
> 
>    - Allow `internal_features` for `feature(compiler_builtins)` since
>      now Rust warns about using internal compiler and standard library
>      features (similar to how it also warns about incomplete ones) [4].
> 
>    - A cleanup for a documentation link thanks to a new `rustdoc` lint.
>      See previous commits for details.
> 
>    - A need to make an intra-doc link to a macro explicit, due to a
>      change in behavior in `rustdoc`. See previous commits for details.
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
> Link: https://github.com/rust-lang/rust/blob/stable/RELEASES.md#version-1730-2023-10-05 [1]
> Link: https://rust-for-linux.com/rust-version-policy [2]
> Link: https://github.com/Rust-for-Linux/linux/issues/2 [3]
> Link: https://github.com/rust-lang/compiler-team/issues/596 [4]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
> [...]
Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
