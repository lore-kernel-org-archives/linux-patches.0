Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9DC7F
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 02:29:01 +0000 (UTC)
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1bbc87ded50so42881495ad.1
        for <patches@lists.linux.dev>; Wed, 23 Aug 2023 19:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692844141; x=1693448941;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XDQS30M7Y7Tyo2pe+n4jKlSGcRSVTd/gkvdTtBx9Zfw=;
        b=ksJNIsWG8fG2iyJPZzD+heSEqhlTvX3/tdktjJDPKRHgA6X9KHJQYf4OxLYEl4G/pA
         e1W3d4I9Xe9/5NWNFinyOJ/3DsLvTu9VmLY/av6JRU+T4M+Xa1epWEO8ZAWEE7jaVtba
         F3keQhBFmsLMM2HxacGLhLh8JzER2nUOhBTQxJ+UzWt0kYy/7htIgcKBAY5pce4KJGVq
         jF5oNZbHJEtVn7VGdntqa0TxroQmEdizrHoh95qRz4riaUbg9GLFKHOWlV69erWGBRyF
         XO9pjue2JTOuvWlU7RbH6mh519iqPyZbSEPSWr1vv75Lf9iEv3CwspiijEvk/ChuQFhR
         TVgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692844141; x=1693448941;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XDQS30M7Y7Tyo2pe+n4jKlSGcRSVTd/gkvdTtBx9Zfw=;
        b=c16sJtpiDneG6L+EyDcY9XGb9cLyf/smv+xRT8D0kLqpRzj1vDrQf64hvwaAoYTCaS
         v56OIlc+SMsWRF3n6c6ckBRWwbpxKMkR46bv6qlbvwAafH2FIYOk2iggdjQbycf3GYWo
         diKCgJu8YNEfC2g/6nr5qLj5H8v3Xgi7jCMlutyyBlXJB2ty+M7iJgV3WPfqAiRAkIfK
         71gHusQN+a2cwMzqWGgTDcWSKr821+o53dSpVoto8oHZmu4DE9CAZ4wkmE0UEAZ5nHfW
         OWvJ2N933dNW8CNAASLDRKSQBXxSB3OV8eDRiEVOhGjHLzuYyIoDpi5L9b8RYzNKy1i2
         8nRQ==
X-Gm-Message-State: AOJu0YxElon9cv4IRKrhXFst9/u9reQ/jDoL0eaDNXlKK+hNcn8xeAMd
	BjPuwmNKu3QSObW1bbGEx4owxqJm4VA=
X-Google-Smtp-Source: AGHT+IHm9K4WZ4vReOf7jrx9CIZ06oUbkKidIOV0WoEkiSubFFAl52wPdsNYfelKatGviFZulU+UYw==
X-Received: by 2002:a17:902:ec8d:b0:1bc:69d0:a024 with SMTP id x13-20020a170902ec8d00b001bc69d0a024mr14620807plg.33.1692844141013;
        Wed, 23 Aug 2023 19:29:01 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id kx14-20020a170902f94e00b001b567bbe82dsm11568484plb.150.2023.08.23.19.28.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Aug 2023 19:29:00 -0700 (PDT)
Message-ID: <da4cb2c1-8f76-44d1-b997-7565efe57701@gmail.com>
Date: Wed, 23 Aug 2023 23:28:12 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] rust: arc: add explicit `drop()` around
 `Box::from_raw()`
To: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho
 <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>,
 Andreas Hindborg <a.hindborg@samsung.com>, Alice Ryhl
 <aliceryhl@google.com>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20230823160244.188033-1-ojeda@kernel.org>
 <20230823160244.188033-2-ojeda@kernel.org>
Content-Language: en-US
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20230823160244.188033-2-ojeda@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/23/23 13:02, Miguel Ojeda wrote:
> `Box::from_raw()` is `#[must_use]`, which means the result cannot
> go unused.
> 
> In Rust 1.71.0, this was not detected because the block expression
> swallows the diagnostic [1]:
> 
>      unsafe { Box::from_raw(self.ptr.as_ptr()) };
> 
> It would have been detected, however, if the line had been instead:
> 
>      unsafe { Box::from_raw(self.ptr.as_ptr()); }
> 
> i.e. the semicolon being inside the `unsafe` block, rather than
> outside.
> 
> In Rust 1.72.0, the compiler started warning about this [2], so
> without this patch we will get:
> 
>          error: unused return value of `alloc::boxed::Box::<T>::from_raw` that must be used
>          --> rust/kernel/sync/arc.rs:302:22
>          |
>      302 |             unsafe { Box::from_raw(self.ptr.as_ptr()) };
>          |                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>          |
>          = note: call `drop(Box::from_raw(ptr))` if you intend to drop the `Box`
>          = note: `-D unused-must-use` implied by `-D warnings`
>      help: use `let _ = ...` to ignore the resulting value
>          |
>      302 |             unsafe { let _ = Box::from_raw(self.ptr.as_ptr()); };
>          |                      +++++++                                 +
> 
> Thus add an add an explicit `drop()` as the `#[must_use]`'s
> annotation suggests (instead of the more general help line).
> 
> Link: https://github.com/rust-lang/rust/issues/104253 [1]
> Link: https://github.com/rust-lang/rust/pull/112529 [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
> [...]
Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
