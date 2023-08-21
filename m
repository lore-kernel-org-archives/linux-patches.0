Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66FD379D1
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 18:46:52 +0000 (UTC)
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-52164adea19so4635939a12.1
        for <patches@lists.linux.dev>; Mon, 21 Aug 2023 11:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaspace-dk.20221208.gappssmtp.com; s=20221208; t=1692643611; x=1693248411;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=J1bPOG4b+YloUifqT7Rk+dQEUBL9OO+h1q+JajXVUOs=;
        b=5TWDUsWI/zaQaIaDAmvVzWiK/x8T7cdBrMJzD/FJ/HX1eBzICfo2Exv71O0R4TRYFZ
         DIo4YFsutHBypXXBi8Mn6xn0XfbUR3jqS/AfpcWdi7MXP5P3KbdZBJoFeZy/ccRB2kO3
         QG6tuUDteEj7LJMDj0O7YVHl9jfOMaKIAb2Zs+90CXmoLxpHwYq2W70IEBFCuxK60fuh
         EbLcsiOB3yB0e2nHIVf8WjM7gUsaT7CK9B1aiYK7qMwDPYsd+ReG+kE/NxWXSt3+umvC
         oXXkYsPTrH2j+G9mXWZ9ewuIXLF4YIJjc2Y8jZ6GWP+uzH3aSfPOIfgMBOBaXZ0HnVNS
         QZWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692643611; x=1693248411;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J1bPOG4b+YloUifqT7Rk+dQEUBL9OO+h1q+JajXVUOs=;
        b=hdp2+UCFwBGNfHZWPgMwSxaMMSAbjNFN4nH0tHWKwRMpNc8LZknAx6dWxkSrPfwFBi
         lV3YB+yku18NwsYAOxvuGWcc5YC53o6FDS6FOWjbSMVWQgEZffGEJ9TAMr5fJEkll3cr
         vr7ptl8XmBxp3UfxIeIg5zHnnDsJEKJ1c0aX9CDI/Q8RhVfnl6QmAIozR69ln3kutCLa
         H0/7+nVWGRYL8ZyhhJBg39/lWh7s3CMT63BdMF9+fnKwbi1D674MDbE/Ojx+PpVKbPbg
         k3yCVb5e4P6CAwYK4iFj2o/7FE5odZMPngGFBZ2B1u0EiTDazkpBZ6gSu1I1P8X/UlyL
         R2vg==
X-Gm-Message-State: AOJu0YwsI5w/Q55PYGDhpx/fX7xZkehp4DLh8X4h8GkJGXsR5Sp/gWa7
	kYboCDsMc1CBBYEuurAy7CC6gQ==
X-Google-Smtp-Source: AGHT+IEthwuxN1Toa5Mr0lSr2fZ63x5sTSrzhhPevyvctTWOgtn884Tztzzip0ASVSL9Vn9A2tb2hg==
X-Received: by 2002:a05:6402:2025:b0:521:ae63:ee63 with SMTP id ay5-20020a056402202500b00521ae63ee63mr5925942edb.16.1692643611060;
        Mon, 21 Aug 2023 11:46:51 -0700 (PDT)
Received: from localhost ([79.142.230.34])
        by smtp.gmail.com with ESMTPSA id ca3-20020aa7cd63000000b00529fa63ef6fsm4815116edb.57.2023.08.21.11.46.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Aug 2023 11:46:50 -0700 (PDT)
References: <20230711093303.1433770-1-aliceryhl@google.com>
 <20230711093303.1433770-2-aliceryhl@google.com>
User-agent: mu4e 1.10.5; emacs 28.2.50
From: "Andreas Hindborg (Samsung)" <nmi@metaspace.dk>
To: Alice Ryhl <aliceryhl@google.com>
Cc: rust-for-linux@vger.kernel.org, Tejun Heo <tj@kernel.org>, Miguel Ojeda
 <ojeda@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, Wedson Almeida
 Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, Boqun
 Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj?=
 =?utf-8?Q?=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev, Wedson Almeida
 Filho <walmeida@microsoft.com>, Martin Rodriguez Reboredo
 <yakoyoku@gmail.com>
Subject: Re: [PATCH v3 1/9] rust: add offset_of! macro
Date: Mon, 21 Aug 2023 20:43:08 +0200
In-reply-to: <20230711093303.1433770-2-aliceryhl@google.com>
Message-ID: <874jksp71i.fsf@metaspace.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


Hi Alice,

Alice Ryhl <aliceryhl@google.com> writes:

> From: Wedson Almeida Filho <walmeida@microsoft.com>
>
> This macro is used to compute the offset of a field in a struct.
>
> This commit enables an unstable feature that is necessary for using
> the macro in a constant. However, this is not a problem as the macro
> will become available from the Rust standard library soon [1]. The
> unstable feature can be disabled again once that happens.
>
> The macro in this patch does not support sub-fields. That is, you cannot
> write `offset_of!(MyStruct, field.sub_field)` to get the offset of
> `sub_field` with `field`'s type being a struct with a field called
> `sub_field`. This is because `field` might be a `Box<SubStruct>`, which
> means that you would be trying to compute the offset to something in an
> entirely different allocation. There's no easy way to fix the current
> macro to support subfields, but the version being added to the standard
> library should support it, so the limitation is temporary and not a big
> deal.

I think `#![feature(offset_of)]` is available in 1.71.0, can we use that directly?

BR Andreas
