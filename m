Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44CD81F171
	for <patches@lists.linux.dev>; Tue, 23 May 2023 14:15:30 +0000 (UTC)
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-510b7b6ef59so1830253a12.3
        for <patches@lists.linux.dev>; Tue, 23 May 2023 07:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaspace-dk.20221208.gappssmtp.com; s=20221208; t=1684851328; x=1687443328;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=FebP/qFHl0Dl67q5FeEHc91aNblS1R2LhUrg1U/Isbo=;
        b=uVErkesMioUpkrd/1Qe0cl8yRr3/q5pXG3LizEb+fAw1xGGKvxRlfAXannm+NYXVIv
         tj5m5qgvO4xMFgQmlvarz48n3H+HNZpVVp3iJd6Flp4RLCXyiNKWnFC8UNR3eBPgfVaU
         X+hBw0yPUQ9Vux563zSj23KxmXRQxlE1Khw2/qD3MPe534UOPkK1cP7n2Wq7z5tOpy5F
         uBZ4WazFgOesOU2prwsUu3k495ea5HpCLD78qjF8Lzxdwtd2OXuCV/cKcnkdXpoohSLS
         b662HLi87+xdh6nOpVc83zJjOkgO08TnlbUFy6tAR5YztkQGc3vPa1cvs+O6X15eBSpm
         Pohg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684851328; x=1687443328;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FebP/qFHl0Dl67q5FeEHc91aNblS1R2LhUrg1U/Isbo=;
        b=I5+SlpCaQWIK5QmqzS/lohuQOGaOWLDavOZ1H2jQHEjIKEkakP+GtkZ7KEzKhpR6lr
         DAML0tANfGYQgm4/c+7vHuVK2eWe5M1ktwcKtZsZqSqTEe96UND0tvtyQEKRuYEa1eU+
         Jf82p5OO7534uyWWn14G0d6RaeKm/FRi7eosmWNpazs7xTZmLDKXEGWpYBdhjIYQST17
         mEG9rDUwvqFN2YhzS6WkVKaORD8cl4c4nKXJln1TgymSqEV6bicBlwVnYz9ijGWGAOsY
         i7jC/Vz60AWfwDA1dtJj7lH7xDTdH8KoROPtQg9W02nabIJjOI09y5N8RZGl9KxYoxe4
         XRQQ==
X-Gm-Message-State: AC+VfDzBg0DOqqRCrrRNv9yk0yjMubUsDn7aDmfJNd7DvAZr6ziWtjJw
	JqV1CCj+NnJgaTuJPtCSCM2WoQ==
X-Google-Smtp-Source: ACHHUZ5qSPAcH861872AUO19Y6nXlt6YPQsMjbAHd3u7oOXwHcRCFReFB4UWevnWEwD06EKyPazqcQ==
X-Received: by 2002:a17:907:1c8b:b0:94e:48ac:9a51 with SMTP id nb11-20020a1709071c8b00b0094e48ac9a51mr16656005ejc.4.1684851328355;
        Tue, 23 May 2023 07:15:28 -0700 (PDT)
Received: from localhost ([79.142.230.34])
        by smtp.gmail.com with ESMTPSA id xa12-20020a170907b9cc00b0096637a19dccsm4510453ejc.210.2023.05.23.07.15.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 07:15:27 -0700 (PDT)
References: <20230517203119.3160435-1-aliceryhl@google.com>
User-agent: mu4e 1.10.3; emacs 28.2.50
From: Andreas Hindborg <nmi@metaspace.dk>
To: Alice Ryhl <aliceryhl@google.com>
Cc: rust-for-linux@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>, Wedson
 Almeida Filho <wedsonaf@gmail.com>, Tejun Heo <tj@kernel.org>, Lai
 Jiangshan <jiangshanlai@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn?= Roy
 Baron <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v1 0/7] Bindings for the workqueue
Date: Tue, 23 May 2023 16:14:37 +0200
In-reply-to: <20230517203119.3160435-1-aliceryhl@google.com>
Message-ID: <87ilcjdthc.fsf@metaspace.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


Alice Ryhl <aliceryhl@google.com> writes:

> This patchset contains bindings for the kernel workqueue.
>
> One of the primary goals behind the design used in this patch is that we
> must support embedding the `work_struct` as a field in user-provided
> types, because this allows you to submit things to the workqueue without
> having to allocate, making the submission infallible. If we didn't have
> to support this, then the patch would be much simpler. One of the main
> things that make it complicated is that we must ensure that the function
> pointer in the `work_struct` is compatible with the struct it is
> contained within.
>
> This patch could be significantly simplified if we already had the field
> projection bindings. However, we have decided to upstream the current
> version that does not depend on field projection first - the PR that
> introduces field projections will then include a commit that simplifies
> the workqueue implementation. (In particular, it would simplify the 5th
> patch in this series.)
>
> The first version of the workqueue bindings was written by Wedson, but
> I have rewritten much of it so that it uses the pin-init infrastructure
> and can be used with containers other than `Arc`.
>
> Alice Ryhl (4):
>   rust: workqueue: add low-level workqueue bindings
>   rust: workqueue: add helper for defining work_struct fields
>   rust: workqueue: add safe API to workqueue
>   rust: workqueue: add `try_spawn` helper method
>
> Wedson Almeida Filho (3):
>   rust: add offset_of! macro
>   rust: sync: add `Arc::{from_raw, into_raw}`
>   rust: workqueue: define built-in queues
>
>  rust/helpers.c           |   8 +
>  rust/kernel/lib.rs       |  37 ++
>  rust/kernel/sync/arc.rs  |  44 +++
>  rust/kernel/workqueue.rs | 715 +++++++++++++++++++++++++++++++++++++++
>  scripts/Makefile.build   |   2 +-
>  5 files changed, 805 insertions(+), 1 deletion(-)
>  create mode 100644 rust/kernel/workqueue.rs
>
>
> base-commit: ac9a78681b921877518763ba0e89202254349d1b

This does not compile for me. Could you link dependencies to be applied
first?

Best regards,
Andreas
