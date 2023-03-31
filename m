Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A022F256F
	for <patches@lists.linux.dev>; Fri, 31 Mar 2023 12:02:19 +0000 (UTC)
Received: by mail-wr1-f51.google.com with SMTP id l12so22117303wrm.10
        for <patches@lists.linux.dev>; Fri, 31 Mar 2023 05:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaspace-dk.20210112.gappssmtp.com; s=20210112; t=1680264138;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=me6wuukqjm6+JgHKL/b7Cfg/XRIamYGaPs47EOLk4SA=;
        b=NtEMRH7lOht6iy9cvC9nfq7w6MPzHGqwFfvITBaIWiPIICbDdkmz5L3qKu16YujBLP
         rJapPCtzjxPECq39Es2y1wu50GTpiSXNHyVqN3YIBKq7VXjTjRm6NuFxKINK4VcA67kO
         u7EqxjhmWwl9c0TqtWNB+bs/Ph2/g5d48oFH7tq4WjjTn8Su2S/cV6XOl8ndff4boVuZ
         cU0ly+emc0ndyjSiTOAOwRKOw/yfxdA0UEpb7kct7f0QQzXPEtVPu4al3ldiv8gD95Q/
         2qaHmJR4la9wVKcs9PuyrSR19P6ijNL5/xSkEzYkkdDrd/nxyZ2iOttIzECWMFNh0vmh
         OkdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680264138;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=me6wuukqjm6+JgHKL/b7Cfg/XRIamYGaPs47EOLk4SA=;
        b=jL6pcI7CU3J5OriqAi78sF6lfKFdnVUMLv8R/FtlRdXKlBGVpMLps1qWhtpyQSbWYQ
         ZvIPCG3lzpuOur+Kh7LRtNto+q9FkPeJPxOqky7G7YJdJ8hOrsR869Zj6nHRtbxcYlPI
         01nRbNybvFOgOKl2A2cQV115jctCkufZkkScQHMhbi8dwT2Rs4sOc+hVyaIMSe5eSolC
         GJMSyC6s2pDfLz1GXCJYhHruovjpy6tk3Ljqv+Gm1IYXexxBpq7bFC4hoqL9ApLlciSo
         LFeAFNDK9DWCuUYg/FJZ1v7LQJvbO08uy4AjY8bgqrqjdfi9hIek2Ew/UYzMWJdk1ctD
         IP8Q==
X-Gm-Message-State: AAQBX9cd1WeuLv7vlEntTJLz0syfYQJW+tp1SLKLUTSWF1OY9Lk6KMIK
	NlgrMqU9uPw0y62xJtp88o8bcQ==
X-Google-Smtp-Source: AKy350aJxK4HdPucT44lt8HLnYYH/U3bSyRG2tAOfK7Gdna0jErfLf3jUp17vzmvhF9FC2LNVs+HVg==
X-Received: by 2002:adf:f6cc:0:b0:2cf:1c43:7056 with SMTP id y12-20020adff6cc000000b002cf1c437056mr19268160wrp.36.1680264137871;
        Fri, 31 Mar 2023 05:02:17 -0700 (PDT)
Received: from localhost ([147.161.155.91])
        by smtp.gmail.com with ESMTPSA id l5-20020a5d5265000000b002e55cc69169sm2064017wrc.38.2023.03.31.05.02.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 05:02:17 -0700 (PDT)
References: <20230329223239.138757-1-y86-dev@protonmail.com>
 <20230329223239.138757-5-y86-dev@protonmail.com>
User-agent: mu4e 1.9.18; emacs 28.2.50
From: Andreas Hindborg <nmi@metaspace.dk>
To: y86-dev@protonmail.com
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng
 <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?=
 Roy Baron
 <bjorn3_gh@protonmail.com>, Alice Ryhl <alice@ryhl.io>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev, Andreas Hindborg <a.hindborg@samsung.com>
Subject: Re: [PATCH v3 04/13] rust: add pin-init API core
Date: Fri, 31 Mar 2023 14:00:31 +0200
In-reply-to: <20230329223239.138757-5-y86-dev@protonmail.com>
Message-ID: <87sfdl2kon.fsf@metaspace.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


y86-dev@protonmail.com writes:

> From: Benno Lossin <y86-dev@protonmail.com>
>
> This API is used to facilitate safe pinned initialization of structs. It
> replaces cumbersome `unsafe` manual initialization with elegant safe macro
> invocations.
>
> Due to the size of this change it has been split into six commits:
> 1. This commit introducing the basic public interface: traits and
>    functions to represent and create initializers.
> 2. Adds the `#[pin_data]`, `pin_init!`, `try_pin_init!`, `init!` and
>    `try_init!` macros along with their internal types.
> 3. Adds the `InPlaceInit` trait that allows using an initializer to create
>    an object inside of a `Box<T>` and other smart pointers.
> 4. Adds the `PinnedDrop` trait and adds macro support for it in
>    the `#[pin_data]` macro.
> 5. Adds the `stack_pin_init!` macro allowing to pin-initialize a struct on
>    the stack.
> 6. Adds the `Zeroable` trait and `init::zeroed` function to initialize
>    types that have `0x00` in all bytes as a valid bit pattern.
>
> --

<snip>

> Co-developed-by: Gary Guo <gary@garyguo.net>
> Signed-off-by: Gary Guo <gary@garyguo.net>
> Signed-off-by: Benno Lossin <y86-dev@protonmail.com>
> ---

Reviewed-by: Andreas Hindborg <a.hindborg@samsung.com>
