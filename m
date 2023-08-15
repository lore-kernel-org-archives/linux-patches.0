Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F415215CC
	for <patches@lists.linux.dev>; Tue, 15 Aug 2023 01:04:07 +0000 (UTC)
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-6bd0afbd616so4473087a34.0
        for <patches@lists.linux.dev>; Mon, 14 Aug 2023 18:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692061447; x=1692666247;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9HOC4ki6E5bzT2JuiqqGPDcSiKjjcSrTtPrdwQPQGz8=;
        b=jbYOJKt2HrwiG9nGKVPbLLAqsekGwWN9YHjlnysZeAn2YmLpkr8tMF9tD1JZvAKYGJ
         vbEmimNdaUYAI0wPBlwg4EMnrLuofS4DS0D8o7hf+znUu75sSQ5XpvQCmRgxPeRg6EUg
         dTb2llVelhI+k/aUayXYMyyMaxMMhaqDXsllbybpIoP8Z2kOQM1pnG0EFkNljIo0AlvG
         zT9IbYZ1FsCTBa5gCuIXOnY1PEn61nTlmxGp0N9IrTsg1i0xQvHmdjYKYv8whU2MBhrc
         NWQa7kVLuzZviA4ZV6Ywt4xsfC1yruywlS26IRrZDXBKph1PuY4RTBY/DkL9Ir8Rtqq4
         GqTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692061447; x=1692666247;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9HOC4ki6E5bzT2JuiqqGPDcSiKjjcSrTtPrdwQPQGz8=;
        b=bfxbZ012mlbxiy6Lp8hVW5Gv+P2FFQXX9YJMflrf+adDkI6hqYEGeuBSiNQWDkvInE
         ZVYEnLhMWkMSItV7i1RrsWk5apoKG+vsDUl62uebX+xn5IVnOaG/Dt8aeOut81Kbd190
         iZSIImdbmZYt/QDjg8ALaxBU3RZc5aTAUg7iDUgvp71yaPkchTarO69D9J0v+yxDQWGF
         A0o8qr965UFXzTmJ+VEjpuiodwi7IHUmg1DRoq4DJQ8/2y/8852Yi5u24kY0Ka7DzDV+
         qrmUpfr+44Reu4FAzAf4RB4MROEOsarvjB51dg/8CG1gWQ9uAjYHgygpX7Mzqh6P6++9
         o7KA==
X-Gm-Message-State: AOJu0YxpVFwol4XdSm8R4S9MyHIF9Ita5QLmjISxwyln6C7lC4Nc3gns
	4NbZoVgjW1jNunZi6u6q8PU=
X-Google-Smtp-Source: AGHT+IFjL4ZIFRI3nxNAgw+fCZpcg4FoDRRJtnLZcUwYFTqwnD757hfZPvlq7Ph81yECYktr9ladPA==
X-Received: by 2002:a9d:6c5a:0:b0:6b9:2e88:79cc with SMTP id g26-20020a9d6c5a000000b006b92e8879ccmr9978004otq.19.1692061446767;
        Mon, 14 Aug 2023 18:04:06 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id v10-20020a9d7d0a000000b006b87f593877sm4781985otn.37.2023.08.14.18.04.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Aug 2023 18:04:06 -0700 (PDT)
Message-ID: <ff20038d-8b42-471d-b625-8cf0e343a915@gmail.com>
Date: Mon, 14 Aug 2023 22:04:01 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 03/13] rust: add derive macro for `Zeroable`
To: Benno Lossin <benno.lossin@proton.me>, Miguel Ojeda <ojeda@kernel.org>,
 Wedson Almeida Filho <wedsonaf@gmail.com>,
 Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Alice Ryhl <aliceryhl@google.com>, Andreas Hindborg <nmi@metaspace.dk>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev, Asahi Lina <lina@asahilina.net>
References: <20230814084602.25699-1-benno.lossin@proton.me>
 <20230814084602.25699-4-benno.lossin@proton.me>
Content-Language: en-US
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20230814084602.25699-4-benno.lossin@proton.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/14/23 05:46, Benno Lossin wrote:
> Add a derive proc-macro for the `Zeroable` trait. The macro supports
> structs where every field implements the `Zeroable` trait. This way
> `unsafe` implementations can be avoided.
> 
> The macro is split into two parts:
> - a proc-macro to parse generics into impl and ty generics,
> - a declarative macro that expands to the impl block.
> 
> Suggested-by: Asahi Lina <lina@asahilina.net>
> Signed-off-by: Benno Lossin <benno.lossin@proton.me>
> ---
> v3 -> v4:
> - add support for `+` in `quote!`.
> 
> v2 -> v3:
> - change derive behavior, instead of adding `Zeroable` bounds for every
>    field, add them only for generic type parameters,
> - still check that every field implements `Zeroable`,
> - removed Reviewed-by's due to changes.
> 
> v1 -> v2:
> - fix Zeroable path,
> - add Reviewed-by from Gary and Björn.
> 
> [...]
Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
