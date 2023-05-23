Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397081F933
	for <patches@lists.linux.dev>; Tue, 23 May 2023 16:42:12 +0000 (UTC)
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-19a0f5db948so5533984fac.2
        for <patches@lists.linux.dev>; Tue, 23 May 2023 09:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684860131; x=1687452131;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7IhlLUomDZt1o19VFYJsKL4i2eF/CFk4flQyr7NsxSo=;
        b=MMf0iQkrx/+n6tsEc26eBYnhu3NARXoUERX1UnQwbIQ/brBtPGyRi14+Ww7ncmk56v
         D+4FY7rGBb7ICVjyt83Qw8g+HrBxu3/U19CA/sXBbwd1naCtU3ksx5DNOVt8jGCDNFOp
         vOhQy3NH+1TLUNTiQsrsfq99uNFOkqlzTAEnbcGLsaqAe3Ww/GvRZMZVRfoDL2qjGngD
         8T0p9vzjiP9VRUcB4LCk77GU8FJo/KfrXHGid3fzNHxXbRfbIHjzzaTe3SnLigrau3Qz
         wP3S2hMDNPkJOKaox2IA8hBv7pw096sMawMVP3wXCYSM65tD3qgiqM67dTqitpM4yoh9
         YE8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684860131; x=1687452131;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7IhlLUomDZt1o19VFYJsKL4i2eF/CFk4flQyr7NsxSo=;
        b=VCaAnEZO6vrnMkSzOVrKllmUfcds7hnZiPc45OraAiK9BEV2dNeZu4PGHErBQHFnjD
         YhctLYZ1Rh9DpmcIld8DXCWugFXf5JtchQZRZgXkb7qQBRRYAm3N7zuGO5cJyeu+4Muh
         ry/UhoOXEX/8bGbjYeTD/HlJdrvMXMIhnUYKjrtVtvaqbszITFtbj4OE5WL11VZrDIx+
         z6ZAmIicfql4UQJ/zaoa34u+XVJucUmaHNHyZyE8hPUcqj9oC8WGF3wZwjkw1qCyLuU8
         U2xksu2ysw690cFRmcrjO26Mxvl6CHbzJefyI3Ep/ZixmDHff1fsaBtM6eje2g1c/gfy
         jhJg==
X-Gm-Message-State: AC+VfDy8zz8LXcBH66e1l2XWBDhirzxiN5z8GttgJyZpGTOROjnscvbR
	5P+joV1RwCgA6/dfms62zDI=
X-Google-Smtp-Source: ACHHUZ54MIOmyW2xqymcK594+bszkCG9ijALhXQ1lqcxnkM1JXf9gC7QoEgV307dnZnEl+ggpJw/wg==
X-Received: by 2002:a05:6871:585:b0:192:b3f7:9325 with SMTP id u5-20020a056871058500b00192b3f79325mr7074664oan.47.1684860131171;
        Tue, 23 May 2023 09:42:11 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id y4-20020a056870a34400b0018b22156e84sm446680oak.38.2023.05.23.09.42.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 May 2023 09:42:10 -0700 (PDT)
Message-ID: <0b52529c-5570-bfe8-eb53-f51ae00c2e05@gmail.com>
Date: Tue, 23 May 2023 13:31:12 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2 3/4] rust: specify when `ARef` is thread safe
Content-Language: en-US
To: Alice Ryhl <aliceryhl@google.com>, Miguel Ojeda <ojeda@kernel.org>,
 Wedson Almeida Filho <wedsonaf@gmail.com>,
 Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=c3=b6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 Andreas Hindborg <a.hindborg@samsung.com>
References: <20230523144418.1250547-1-aliceryhl@google.com>
 <20230523144418.1250547-4-aliceryhl@google.com>
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20230523144418.1250547-4-aliceryhl@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/23/23 11:44, Alice Ryhl wrote:
> An `ARef` behaves just like the `Arc` when it comes to thread safety, so
> we can reuse the thread safety comments from `Arc` here.
> 
> This is necessary because without this change, the Rust compiler will
> assume that things are not thread safe even though they are.
> 
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> Reviewed-by: Andreas Hindborg <a.hindborg@samsung.com>
> Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
> ---
> [...]
>   
> +// SAFETY: It is safe to send `ARef<T>` to another thread when the underlying `T` is `Sync` because
> +// it effectively means sharing `&T` (which is safe because `T` is `Sync`); additionally, it needs
> +// `T` to be `Send` because any thread that has an `ARef<T>` may ultimately access `T` using a
> +// mutable reference, for example, when the reference count reaches zero and `T` is dropped.
> +unsafe impl<T: AlwaysRefCounted + Sync + Send> Send for ARef<T> {}
> +
> +// SAFETY: It is safe to send `&ARef<T>` to another thread when the underlying `T` is `Sync`
> +// because it effectively means sharing `&T` (which is safe because `T` is `Sync`); additionally,
> +// it needs `T` to be `Send` because any thread that has a `&ARef<T>` may clone it and get an
> +// `ARef<T>` on that thread, so the thread may ultimately access `T` using a mutable reference, for
> +// example, when the reference count reaches zero and `T` is dropped.
> +unsafe impl<T: AlwaysRefCounted + Sync + Send> Sync for ARef<T> {}
> +
>   impl<T: AlwaysRefCounted> ARef<T> {
>       /// Creates a new instance of [`ARef`].
>       ///

Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
