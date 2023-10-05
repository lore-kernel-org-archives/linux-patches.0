Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA9828DD7
	for <patches@lists.linux.dev>; Thu,  5 Oct 2023 21:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G9N8Or6R"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1c723f1c80fso11169845ad.1
        for <patches@lists.linux.dev>; Thu, 05 Oct 2023 14:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696541437; x=1697146237; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6YH0gaIOtHibpvM+5oJJ8JDGFf9bKbLj2NBXdO+Yxm8=;
        b=G9N8Or6RTw2oJ1AuvBgNNjAkf49bmbuqsBkJFwEw+yE9lPMT/F4L11Dghf1H2Jiz9y
         JxV7X/9oMnSXo6AO1fRFfskVEKlUZ8jmimOFV7ah/wH3o48tBMW7sDLQwjQp8KY3rAme
         TXvjegA2vafpf7roPMG3Jp2Ep8ncVMWamR/Cfy8QYSK3m9Gg75N+Ifcwoj607N38YObQ
         8ed4Gt0lfzzCx49PVpqnBP/ePonSpX3pd4AFYLNJr37vM++s5zJV6KSjvnhrIsbBpR77
         zd9Cidi0ZebNinIk4O5TYNXUuKVdoV4YKBcD0CpMZXFf32DXdz6D4D3AqTNripu8+4PG
         a5tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696541437; x=1697146237;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6YH0gaIOtHibpvM+5oJJ8JDGFf9bKbLj2NBXdO+Yxm8=;
        b=vU8GoKS5rmCZBkTYfHH8dkcOXf0ALwBxQv39RIC2yKVLPXkjiyiDO0UKaWtymWl4g/
         jCsnPPnGGePOfgrWgvKj//aiz/tjpiCQyuFpT5/HuFodFU8uw1X0MTK5/d+VpK/InScA
         6ReSnPU2FdKvSATienPZaS7sO6MTuTCZf3dVLLlPmirrcsAgI89vcVZ1LsrqyJjRphPH
         J7N4QYj0DmewP7l0wd0/87ADJsz8sD2xMEdXnTTmUUW2ZFfwMiTlJA9gX3vflnwnH23P
         r52BA9RLfxDQHXQYiKGyw9q6dgwSD011uueBFxspv9dTmYkf+gU4Vj8mANXAMPnJ1oDd
         PEhg==
X-Gm-Message-State: AOJu0Yy3vsOFkMyloKjLyw6valfYHOdXoRAWd5OrjG9iJZ+uwkUmqmvk
	7RggUaNjxnaKCXONvY4DhJ0=
X-Google-Smtp-Source: AGHT+IHd9JBD1dZEVvgDQ1Vau9CJPSSHCHZsMtMrRMDiC7RY1bW3RbpsdPaDHNni5FOFkVpatfFiGw==
X-Received: by 2002:a17:902:a504:b0:1c3:308b:ecb9 with SMTP id s4-20020a170902a50400b001c3308becb9mr5877146plq.11.1696541437229;
        Thu, 05 Oct 2023 14:30:37 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id l7-20020a170903244700b001b8a00d4f7asm2230148pls.9.2023.10.05.14.30.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Oct 2023 14:30:36 -0700 (PDT)
Message-ID: <fc946540-bb9d-4db2-b5c8-00f7783e3082@gmail.com>
Date: Thu, 5 Oct 2023 18:29:46 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] rust: task: remove redundant explicit link
Content-Language: en-US
To: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho
 <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>,
 Andreas Hindborg <a.hindborg@samsung.com>, Alice Ryhl
 <aliceryhl@google.com>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20231005210556.466856-1-ojeda@kernel.org>
 <20231005210556.466856-2-ojeda@kernel.org>
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20231005210556.466856-2-ojeda@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/5/23 18:05, Miguel Ojeda wrote:
> Starting with Rust 1.73.0, `rustdoc` detects redundant explicit
> links with its new lint `redundant_explicit_links` [1]:
> 
>      error: redundant explicit link target
>        --> rust/kernel/task.rs:85:21
>         |
>      85 |     /// [`current`](crate::current) macro because it is safe.
>         |          ---------  ^^^^^^^^^^^^^^ explicit target is redundant
>         |          |
>         |          because label contains path that resolves to same destination
>         |
>         = note: when a link's destination is not specified,
>                 the label is used to resolve intra-doc links
>         = note: `-D rustdoc::redundant-explicit-links` implied by `-D warnings`
>      help: remove explicit link target
>         |
>      85 |     /// [`current`] macro because it is safe.
> 
> In order to avoid the warning in the compiler upgrade commit,
> make it an intra-doc link as the tool suggests.
> 
> Link: https://github.com/rust-lang/rust/pull/113167 [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
> [...]
Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
