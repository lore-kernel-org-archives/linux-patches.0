Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C2D2C6A9;
	Sat, 16 Dec 2023 13:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kckc8Fnl"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6ce72730548so1523728b3a.1;
        Sat, 16 Dec 2023 05:48:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702734517; x=1703339317; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cMdekASZxZHVFfSc7wnHzY7Tv4MkxPQPmvOEgSf0s3A=;
        b=kckc8FnlYCir9TO/BgDDayTNe+5/9vt4rkvbPlbZpBnLbU3vOiyB6ZequJqENYjreK
         s5rOnRwNBsZ0b1v+7qJIktjHWPZIdU27DLAlRFxGz5b39ySN/z7/9GU6GjBOWHy9b14K
         qHYLekTtYMKGAC7qS2yDLxTT+E+rOuMceypCej2CI10lpSl+ZF43IUTyPkTufZGSD/Qt
         VCfuG++ePanajxUw+ZJAaYpiDUlb1Bb70Ai2peJP7Yyk9aoCxlZbpcvp8ZWJhoyIFpHv
         pfAbBNTLkfKmpM3lk+MQ2o6ZnS5BYECHWH4LjbNaNdpiopk2iog14N2hYzP9LVonwEYG
         AhbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702734517; x=1703339317;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cMdekASZxZHVFfSc7wnHzY7Tv4MkxPQPmvOEgSf0s3A=;
        b=iv63y32h5bbih5LxBbGFZ+9M1E0DiIGWl4/Aif0TN1SQ8o+FsMDolFFlqSRK/KQ+Wo
         +u197Kfo72vGDhOClehQtOQcAGlBUKKF8uew64VJwm9tmz5RAsV9/GhALdOKvpCewdFY
         6ejkB2TNzmA49chHtPB2BFKRIH+6CASNfF8EEmEM5oEHbv3vzhxRfDKTUm7/57XE7DDX
         20QwSrBSo9NqcL934LTwIrqiK3oRRx9YR9nMecvpcKgSkujKaZfuvo1d+rj6BIyoSXZs
         U3Fa45HU73l6MPtsdJQjB+F5RLMQN2xw/TECr079xd5O2g9g84Cn6I2Yv0vNouPKBwX9
         GUoA==
X-Gm-Message-State: AOJu0Yz7WwSwIgGGhXSixl/9L7X5eeFyYav7z2JNi3SMy6lWxBwSTkV4
	/IVWzd7O0kY3/vVkYnVOE1g=
X-Google-Smtp-Source: AGHT+IGMRI0tGh2WrcuWUWqrhXsQO6lqjkNVpRGJgVO1U3NtRTPQ1rpt6nhXUonl7sYzoRdwErziMQ==
X-Received: by 2002:a05:6a20:54a9:b0:190:1c0:1c25 with SMTP id i41-20020a056a2054a900b0019001c01c25mr17316135pzk.91.1702734516764;
        Sat, 16 Dec 2023 05:48:36 -0800 (PST)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id u17-20020aa78491000000b006cb98a269f1sm15142081pfn.125.2023.12.16.05.48.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Dec 2023 05:48:36 -0800 (PST)
Message-ID: <2f92ca77-703b-403d-9dc9-b45d2d8d86a1@gmail.com>
Date: Fri, 15 Dec 2023 13:34:35 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs: rust: remove `CC=clang` mentions
To: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho
 <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>,
 Andreas Hindborg <a.hindborg@samsung.com>, Alice Ryhl
 <aliceryhl@google.com>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 Jonathan Corbet <corbet@lwn.net>, Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling
 <morbo@google.com>, Justin Stitt <justinstitt@google.com>,
 linux-doc@vger.kernel.org, llvm@lists.linux.dev
References: <20231215124751.175191-1-ojeda@kernel.org>
Content-Language: en-US
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20231215124751.175191-1-ojeda@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/15/23 09:47, Miguel Ojeda wrote:
> Nowadays all architectures except s390 recommend using `LLVM=1` instead of
> `CC=clang`, and since commit a3c6bfba4429 ("Documentation/llvm: refresh
> docs") the Kbuild LLVM documentation makes `LLVM=1` the way to go:
> 
>      We want to encourage the use of ``LLVM=1`` rather than just
>      ``CC=clang``. Make that suggestion "above the fold" and "front and
>      center" in our docs.
> 
> In particular, that commit removes the examples with `CC=clang`.
> 
> Thus do the same in the Rust Quick Start guide, i.e. remove the `CC=clang`
> mentions, especially since the architectures that have had their Rust
> support upstreamed (or soon to be upstreamed) are all `LLVM=1` ones
> anyway. And perhaps by the time Rust is supported for s390 (or new
> architectures), it may have moved to `LLVM=1` anyway. Otherwise,
> this can be added back if needed (or perhaps an extra link to
> Documentation/kbuild/llvm.rst).
> 
> This should also help avoiding potential confusion around `CC=clang` [1].
> 
> Link: https://lore.kernel.org/rust-for-linux/6df6e8e5-8d5b-4d3d-91b5-bc0e90c424ea@nvidia.com/ [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
> [...]
Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
