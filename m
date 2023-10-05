Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4AD834CF8
	for <patches@lists.linux.dev>; Thu,  5 Oct 2023 21:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f4mguIWg"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1c752caeaa6so11617645ad.1
        for <patches@lists.linux.dev>; Thu, 05 Oct 2023 14:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696541442; x=1697146242; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dko4d8emUH4vRaPizUWo+kG/JH4ZKaIw1NqUJC51xOs=;
        b=f4mguIWgqWNd8X42h4BAduqEQut9/3lAMhGRyLfJpiZmmj9ZiS9nj8we4Ih5gM0tTx
         E9HA9aZwHBkF80aaPHuEstzlPJAdT5CNzOszKN+GXvp1fqD77wcd9+RP7uvff6HekQMA
         8OMoi4F2TuJ9amfR7Dx2weT1/msxAAsIkaY4lA/UaNkDf73EIc2uczAbe2KDg5IrLfKg
         elJJaRVnLo0+hFuZFiWl4e9bx6n1vXAXDpOSgWB2LBBDJCdfY7xUPSJgdWsdmNmNVYMI
         nvqS6YjMgoZ3grOYHuUOh+39fv7AqE87Ok4I4qgRulfRC3nHmwlsNjZ0RqNzJKiCPwqq
         GOHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696541442; x=1697146242;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dko4d8emUH4vRaPizUWo+kG/JH4ZKaIw1NqUJC51xOs=;
        b=C/BAcpPbMFKSX+t1Cur7T9T5nTBkkm+uo8Cosd4KlgUDia4XDxQMZE1pmUD72WDNvp
         mqW5snujEOAv/bwr0pFyZGiEoOPmAV+U0nN1TNU0W5sUCbZ0hBhyFKgy4ZNza/zO18M7
         yWax4NdtUnakmN9u2yOixpIhDQQ1K+GaPuvnCCcGYsKiLDU/3AyLZ8n8CkQukarGEE8s
         4K5/PwqRgeGH18HEtPfsvL5plpvag/d6ER4PpgZ79cg9D9R0kh1arpeWW+zUtvcSxL5A
         v3dboSrpRWcx3zJUlbcch7Ru7mIKkQ0LYk3neIR0zwkDsFW3o14dSC/lc9v2kKkT54E6
         inwQ==
X-Gm-Message-State: AOJu0Yx+kNoRwmucYgx8ExddhLVXm0FPe/a1JHafxaFJc8gKdMrnGVXG
	5HQGlO0qNP03duB3/mDr/Eo=
X-Google-Smtp-Source: AGHT+IGwyfLpNVx4M4ugeDbLU5LxF7PM7KBrWvaOgWQpvRxV/ra0KCajJfTza2QCsQ1Zj8Ltm6TG4A==
X-Received: by 2002:a17:903:246:b0:1c0:b84d:3f73 with SMTP id j6-20020a170903024600b001c0b84d3f73mr7327634plh.53.1696541441949;
        Thu, 05 Oct 2023 14:30:41 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id l7-20020a170903244700b001b8a00d4f7asm2230148pls.9.2023.10.05.14.30.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Oct 2023 14:30:41 -0700 (PDT)
Message-ID: <a6525c99-68c9-4816-88d0-ebf8670e766b@gmail.com>
Date: Thu, 5 Oct 2023 18:30:00 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] rust: print: use explicit link in documentation
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
 <20231005210556.466856-3-ojeda@kernel.org>
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20231005210556.466856-3-ojeda@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/5/23 18:05, Miguel Ojeda wrote:
> The future `rustdoc` in the Rust 1.73.0 upgrade requires an explicit
> link for `pr_info!`:
> 
>      error: unresolved link to `pr_info`
>         --> rust/kernel/print.rs:395:63
>          |
>      395 | /// Use only when continuing a previous `pr_*!` macro (e.g. [`pr_info!`]).
>          |                                                               ^^^^^^^^ no item named `pr_info` in scope
>          |
>          = note: `macro_rules` named `pr_info` exists in this crate, but it is not in scope at this link's location
>          = note: `-D rustdoc::broken-intra-doc-links` implied by `-D warnings`
> 
> Thus do so to avoid a broken link while upgrading.
> 
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
> [...]
Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
