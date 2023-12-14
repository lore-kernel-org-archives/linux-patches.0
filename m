Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DABA4EB38
	for <patches@lists.linux.dev>; Thu, 14 Dec 2023 13:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cYXvf8fZ"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-28aeacb2dfdso1094708a91.0
        for <patches@lists.linux.dev>; Thu, 14 Dec 2023 05:49:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702561751; x=1703166551; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UTgQg5ey7t1gN8vRT5vRqf8veCr45WdokAmFaMYA3+E=;
        b=cYXvf8fZvjyxakJpefZYESnlJEEyzi3EtgHY2Qki9jmppJquEZsBVBndrr0FxgCgWK
         NK/E/oVHA58VuSJVHir5apNxs623xJuxp1GF5pps/7GgBi8nVnc4Rf5hy9sbeAVlTOVf
         0wUgdQXha/wbhqqaUoR4To9bRVF1YIXLA56M7YRupHLEpqvjQH3rFARAjh9zBkMEWrHw
         ukf4l2LtqI5RsSgS5fqBDy7KRal1P10SPD2HQy34vNnOlEeu4VRXMcpBQVju/GXeYfgk
         lrxFEWGkV6xXZmcT55PC41aFqHn8tJhDcgy6NDqG8Xsk9icJwZHLxABTYeVqCWnvz8ee
         NB4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702561751; x=1703166551;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UTgQg5ey7t1gN8vRT5vRqf8veCr45WdokAmFaMYA3+E=;
        b=RXJ+uYs9huUBzvQG4Je/B09XKpSAl9Md98NcImyRKIv6UEncLzhkbugV7rtUO/YcgP
         fgrbTFkYegXwUr0+K8NW4KjkQ+ryrMv4gyjxKyhPAACTjgGM4GeI4yQQ+tdzJJEAdpvR
         iB3kDb1235LZ4wFDtiMIQNN4J0dA3hIQn+GQIreqHDmyI6mlJf48StbEaThfrSqEypZY
         xwNbJZGG9hn6YMKTPXRiVIS/03LqJKwEsX0RcoXe1ooBN+ciToWqIgmSHXMwbHTiC+FE
         BySc/1k84eDVAq4uRGpKGrno0i4qZOFrS4aQ7x4xEZs9OqzagqgQc11VklgHK/wa8IUL
         s9pg==
X-Gm-Message-State: AOJu0YxSBlILZ+MWFgebyg9lx2YDOLI4gHq/VqLjJyE1Tqb/ZaT9e1J3
	g0cNYGs2xt+DfS/gdxJvq7U=
X-Google-Smtp-Source: AGHT+IEv3GGnQfkJxzqP9Db4Qf3Fpn/fdX4KnRYiGqn+0eH/2LWeqGdMECO7teg0UArVZGBkQXHQ3Q==
X-Received: by 2002:a17:90a:a10f:b0:28b:201f:c2be with SMTP id s15-20020a17090aa10f00b0028b201fc2bemr63542pjp.62.1702561750754;
        Thu, 14 Dec 2023 05:49:10 -0800 (PST)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id q2-20020a17090a430200b0028a4c85a55csm10995876pjg.27.2023.12.14.05.49.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Dec 2023 05:49:10 -0800 (PST)
Message-ID: <29100969-106a-47c1-bfe3-6e2ca38c8c54@gmail.com>
Date: Thu, 14 Dec 2023 10:49:05 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] rust: upgrade to Rust 1.74.1
To: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho
 <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>,
 Andreas Hindborg <a.hindborg@samsung.com>, Alice Ryhl
 <aliceryhl@google.com>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20231214092958.377061-1-ojeda@kernel.org>
Content-Language: en-US
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20231214092958.377061-1-ojeda@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/14/23 06:29, Miguel Ojeda wrote:
> This is the next upgrade to the Rust toolchain, from 1.73.0 to 1.74.1
> (i.e. the latest) [1].
> 
> See the upgrade policy [2] and the comments on the first upgrade in
> commit 3ed03f4da06e ("rust: upgrade to Rust 1.68.2").
> 
> # Unstable features
> 
> No unstable features (that we use) were stabilized.
> 
> Therefore, the only unstable features allowed to be used outside the
> `kernel` crate are still `new_uninit,offset_of`, though other code to
> be upstreamed may increase the list (e.g. `offset_of` was added recently).
> 
> Please see [3] for details.
> 
> # Other improvements
> 
> Rust 1.74.0 allows to use `#[repr(Rust)]` explicitly [4], which can be
> useful to be explicit about particular cases that would normally use
> e.g. the C representation, such as silencing lints like the upcoming
> additions we requested [5] to the `no_mangle_with_rust_abi` Clippy lint
> (which in turn triggered the `#[repr(Rust)]` addition).
> 
> Rust 1.74.0 includes a fix for one of the false negative cases we reported
> in Clippy's `disallowed_macros` lint [6] that we would like to use in
> the future.
> 
> Rust 1.74.1 fixes an ICE that the Apple AGX GPU driver was hitting [7].
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
> Link: https://github.com/rust-lang/rust/blob/stable/RELEASES.md#version-1741-2023-12-07 [1]
> Link: https://rust-for-linux.com/rust-version-policy [2]
> Link: https://github.com/Rust-for-Linux/linux/issues/2 [3]
> Link: https://github.com/rust-lang/rust/pull/114201 [4]
> Link: https://github.com/rust-lang/rust-clippy/issues/11219 [5]
> Link: https://github.com/rust-lang/rust-clippy/issues/11431 [6]
> Link: https://github.com/rust-lang/rust/issues/117976#issuecomment-1822225691 [7]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
> [...]
Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
