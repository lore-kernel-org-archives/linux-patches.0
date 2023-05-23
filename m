Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B83F4A85A
	for <patches@lists.linux.dev>; Tue, 23 May 2023 13:49:59 +0000 (UTC)
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-96fd3a658eeso404308666b.1
        for <patches@lists.linux.dev>; Tue, 23 May 2023 06:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaspace-dk.20221208.gappssmtp.com; s=20221208; t=1684849798; x=1687441798;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=QKx8n//1tKFimftiMxA1MUqaSGZNSHWdUYwS7d1fEr8=;
        b=ohL+xM5uW5h/Kc38R+R3Q+NWedDCe1F74+5M0k6VNn5qAFRaGimRlA5C3rQVITiDXI
         4RbpmnHalgZc3TFGQU4mWfVn7JY4u1vrQCgHdgqY1hyFl2nPDZyIxyV+dQDTwK2w82z9
         ucMZQjQQpXuC4TB6+M/UYs5k8iq5ds+Drr9PotqurYTdvgvBD6lAsfjVFMTOEghlXuTP
         DF+iMuai1YlCNS/LU0qNKxbyGjj61PxCjTFpidHGEB1S/1irs5mEqFASaDS6xuRxpA2G
         FSzkI3hz5BKIWWhRggtb+bQKVeA7jyKiUiFnayMKTCAO+g4l885rbauGfvxJC5br+LpS
         DqAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684849798; x=1687441798;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QKx8n//1tKFimftiMxA1MUqaSGZNSHWdUYwS7d1fEr8=;
        b=b+lTUtMwYGShBKWtp66TD4XVmOpCkLW9leDX+XKchjePjhh7M326Cacb9Pj2OPUR6u
         2dZE399NR0brQNoqSIZTzZl4DVZ2AFvN7uVLx0wcLZM8cE8crQzEINniGz3J+JIYDCQz
         sq3VtZ9aHjRL3fmQ0Dr/0lLsODudtIwCU9N9vUf6U8Z0n+A0il3gMaLRvONFjdRR7qva
         B4OZPWizk1BUUkwVwPeCdapTHLKPnFDAyrNnBsCcOoQ9cCIdVBTIaq6bu1OVf2xxI6ID
         nHpy6iF962k9iVvGnlAl4gd1/FCgANJb121TJ5UsPSMeUcPJl9t2wRFs8SGFNfVfKQDm
         fshg==
X-Gm-Message-State: AC+VfDz+MjV+XyVR9QoI8/TJIBq9fnN1tgs7qqFyzdrnou0iboNY9hgv
	CrehlU1F0w3kNrgCj371snqo8Q==
X-Google-Smtp-Source: ACHHUZ4iTNVTiX44mpW3K9dwzTRFp9mKM7RDFCxUm+4ZyyNdGA2kxXD/jMrQDq4vaqPQJGc1k9lHhQ==
X-Received: by 2002:a17:907:7212:b0:96f:de0b:847a with SMTP id dr18-20020a170907721200b0096fde0b847amr6927791ejc.37.1684849797878;
        Tue, 23 May 2023 06:49:57 -0700 (PDT)
Received: from localhost ([79.142.230.34])
        by smtp.gmail.com with ESMTPSA id z27-20020a17090674db00b0096efa536229sm4587344ejl.149.2023.05.23.06.49.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 06:49:57 -0700 (PDT)
References: <20230517095905.3548100-1-aliceryhl@google.com>
 <20230517095905.3548100-2-aliceryhl@google.com>
User-agent: mu4e 1.10.3; emacs 28.2.50
From: Andreas Hindborg <nmi@metaspace.dk>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho
 <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng
 <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?=
 Roy Baron
 <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, Ingo
 Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Will
 Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
Subject: Re: [PATCH v1 2/2] rust: task: add `Send` marker to `Task`
Date: Tue, 23 May 2023 15:27:14 +0200
In-reply-to: <20230517095905.3548100-2-aliceryhl@google.com>
Message-ID: <87r0r7dunu.fsf@metaspace.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


Alice Ryhl <aliceryhl@google.com> writes:

> When a type also implements `Sync`, the meaning of `Send` is just "this
> type may be accessed mutably from threads other than the one it is
> created on". That's ok for this type.
>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
>  rust/kernel/task.rs | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/rust/kernel/task.rs b/rust/kernel/task.rs
> index 526d29a0ae27..4f1fe9aa9f6e 100644
> --- a/rust/kernel/task.rs
> +++ b/rust/kernel/task.rs
> @@ -64,6 +64,11 @@ macro_rules! current {
>  #[repr(transparent)]
>  pub struct Task(pub(crate) Opaque<bindings::task_struct>);
>  
> +// SAFETY: The only situation in which this can be accessed mutably is when the refcount drops to
> +// zero and the destructor runs. It is safe for that to happen on any thread, so it is ok for this
> +// type to be `Send`.
> +unsafe impl Send for Task {}

To enhance clarity, could you elaborate _why_ `Task` can never be
accessed mutably by Rust? Perhaps "By design, `Task` can only be
accessed thorough `&Task` and `Task` can never be owned by the Rust
side. Therefore the only situation ...".

> +
>  // SAFETY: It's OK to access `Task` through references from other threads because we're either
>  // accessing properties that don't change (e.g., `pid`, `group_leader`) or that are properly
>  // synchronised by C code (e.g., `signal_pending`).

