Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8CFD39C
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 04:34:45 +0000 (UTC)
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-6bc9d16c317so5149783a34.1
        for <patches@lists.linux.dev>; Tue, 08 Aug 2023 21:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691555684; x=1692160484;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2qfg0WIadQaxwkKNJkFn8ap8YFqlO2fSpQ74DKXH6rI=;
        b=jYl84TsyuM77kswO9vDzgMlUr1RJU00GQ0HoGpndLPQco8KJGeXmKZQhC4pN7Qcuny
         1MfWOJqB4jIiWwtu+aLobCWnEGcemKmjeJeUm0o9/pzgqf4GcgdiSx8l4wQ5BQbJ/XvJ
         KMU6ESHDfqoT2+DCRXp/hiaDiLWtHwwGIuG0fioc1SzXj4UHaa/+VVTxaHGzK6K7gHE1
         5DLk0F1m2SMVasfij4TXX0k1toWpGLVbYGZ7G7haNzw6NPdRtEGgCw6gnIucfZAdar2m
         sWxNZiSmk6Qr3msEoJNKictDNLU1hnQjsRIv7LLLPKrGdC+GBnFO2aEa7rD/Z6WZEqHR
         CscA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691555684; x=1692160484;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2qfg0WIadQaxwkKNJkFn8ap8YFqlO2fSpQ74DKXH6rI=;
        b=fn01x4+exH9Pnu8InBwneL38bCZx7pE2Uj+7T2HCRt65kriYVXgqHRme3uPIFQWmkI
         toAmTJL7xt2I2Fz5s22VCEOr4Fnn9aQLamZp5qQhXO9I+WwcvzedZ7k9sWsWqXHBztLL
         4xxQaelswaXUO3L/namHyn/stXY5NsITxw0c7LcC8d8mIpde7jhp1Vhf7IwKl744Hm9O
         S3RrCxHsQe0Toh2ZxhhK6DAZZ0iXVsyIhiEK2OE+36xsReaVtpvxAIZEActqyWzCH+4m
         4r5hd49SaCI9oRu1x+v10tEXBF0B7b6diV91ULRV48tfiV5LapYcJCq2R/4u3v/W54Zc
         R/VQ==
X-Gm-Message-State: AOJu0YyJPacuZFBea6v88NsCdD40YGVBkYb6N055Ps89qMplA0nHEMYE
	mZfmR7wzPktQoMqAn6z1WhY=
X-Google-Smtp-Source: AGHT+IH//L5g3jbAjte61tfU8iZCVBXpJcuPCxzhAHTs9tJYQVS6D0cWjx5UAmUGEin7rY3I0cy29g==
X-Received: by 2002:a9d:7f16:0:b0:6b9:304a:e778 with SMTP id j22-20020a9d7f16000000b006b9304ae778mr1628062otq.34.1691555684468;
        Tue, 08 Aug 2023 21:34:44 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id n26-20020a9d741a000000b006b87f593877sm6552031otk.37.2023.08.08.21.34.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Aug 2023 21:34:44 -0700 (PDT)
Message-ID: <94a50510-c539-49d5-bc36-241f1f003172@gmail.com>
Date: Tue, 8 Aug 2023 23:59:04 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Subject: Re: [RFC PATCH v1 1/5] rust: file: add bindings for `struct file`
To: Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>,
 Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 Wedson Almeida Filho <walmeida@microsoft.com>, Daniel Xu <dxu@dxuuu.xyz>
References: <20230720152820.3566078-1-aliceryhl@google.com>
 <20230720152820.3566078-2-aliceryhl@google.com>
Content-Language: en-US
In-Reply-To: <20230720152820.3566078-2-aliceryhl@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/20/23 12:28, Alice Ryhl wrote:
> From: Wedson Almeida Filho <walmeida@microsoft.com>
> 
> Using these bindings it becomes possible to access files from drivers
> written in Rust. This patch only adds support for accessing the flags,
> and for managing the refcount of the file.
> 
> Signed-off-by: Wedson Almeida Filho <walmeida@microsoft.com>
> Co-Developed-by: Daniel Xu <dxu@dxuuu.xyz>
> Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
> Co-Developed-by: Alice Ryhl <aliceryhl@google.com>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
> In this patch, I am defining an error type called `BadFdError`. I'd like
> your thoughts on doing it this way vs just using the normal `Error`
> type.
> 
> Pros:
>   * The type system makes it clear that the function can only fail with
>     EBADF, and that no other errors are possible.
>   * Since the compiler knows that `ARef<Self>` cannot be null and that
>     `BadFdError` has only one possible value, the return type of
>     `File::from_fd` is represented as a pointer with null being an error.
> 
> Cons:
>   * Defining additional error types involves boilerplate.
>   * The return type becomes a tagged union, making it larger than a
>     pointer.

These two are kinda passable, as a `impl_null_ptr_err` macro can be opted
to implement error types from nulls. Also if we consider that
`File::from_fd` isn't going to be called a gorillion times a second or a
recursive call is done, then I'd say that the tagged union won't bring
any other problems, except that a compiler optim is skipped.

>   * The question mark operator will only utilize the `From` trait once,
>     which prevents you from using the question mark operator on
>     `BadFdError` in methods that return some third error type that the
>     kernel `Error` is convertible into.

Although, I want this to be mentioned in the doc of `BadFdError` as this
cannot be overlooked when said usage of `?` is done.

> 
>   rust/bindings/bindings_helper.h |   2 +
>   rust/helpers.c                  |   7 ++
>   rust/kernel/file.rs             | 176 ++++++++++++++++++++++++++++++++
>   rust/kernel/lib.rs              |   1 +
>   4 files changed, 186 insertions(+)
>   create mode 100644 rust/kernel/file.rs
> 
> [...]
> diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
> [...]
> diff --git a/rust/helpers.c b/rust/helpers.c
> [...]

This one is making my head spin, shouldn't they go first?
