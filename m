Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1FA23B3
	for <patches@lists.linux.dev>; Fri, 31 Mar 2023 08:18:39 +0000 (UTC)
Received: by mail-ed1-f49.google.com with SMTP id y4so86628493edo.2
        for <patches@lists.linux.dev>; Fri, 31 Mar 2023 01:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaspace-dk.20210112.gappssmtp.com; s=20210112; t=1680250717;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=uMJy1C9/3QR5jjuw5Xv2+S7pMfTZMnWAxKSE4c5qidM=;
        b=fmzfl9IOs735tXSv5WRpDWImpl7qScBJ0TpByEkzL0uKL4RNFRy8fFPjWqyMz5M76F
         zlBJtzL56YDZmviRE03XGtIWzaq/Z5rnScnRHJi4Qf8YeWnlRV52yVtAGlxWwGzBnGV/
         3x06jpXMum2HJ7t4VmxOiJYCAte4E3jW9sPhA9FjXT2zUJbx3TdzfCKY23+b4HDb5fxA
         jLyy9mQd04BST5ySdlp+y4TF0gG+wy36ROKjnHL7FJ5FEEzjxEwid5sWV4SdY7iv7oMW
         rXHUoo2PfyxJE+hbktrKRbWfZ4hne/HlDFy8GGPTc0QVxS4CsKAUokZEVsnoFVcYBSPu
         4kGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680250717;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uMJy1C9/3QR5jjuw5Xv2+S7pMfTZMnWAxKSE4c5qidM=;
        b=ODgNOlADODf6d5sB3PhMABxv6XT9recqscNgSO/tNdU/pbu4MtW53ceu/61FBGIxuG
         shr40fgqR8a2lsCzVMQJxfaLWjHjphHS+JmdZf4F6pAoMzVA6awDZ/dWjftxzMRj4x5b
         QM38MZx9u39Alm/jYhr8+dQQKnvTZZNtrD1402AAS847taL5YUtlIc8L7B9luOS770y8
         Wyfb8sJ7o//KekecHqsZurMZzRJw5U/yz0br8aJ7UQisELEd4C8J4Ql8zEev1Z4iLoNX
         ZSyokFH7UOeYLSJlhf2rQ5eXEcCY90hnfTrwUoUyhHy/GPWN6CC/FE5doF1glSuH9g6E
         kuHw==
X-Gm-Message-State: AAQBX9eyOLk+hU48uHcv9qCVMBOQ+IHHDH610I169oiAR3GdXRG1q+4o
	Yb6zfUgtFNgiq7IHt2F6jbfS0A==
X-Google-Smtp-Source: AKy350b3Wzo7SMpS0QCe0HFcHDRnX9Y5vwvxvTXiZ+KLr1OZAOTr3A0/ZUOsuDwzc/Tz3MJU6jY50A==
X-Received: by 2002:a17:906:5a94:b0:933:15c0:6e05 with SMTP id l20-20020a1709065a9400b0093315c06e05mr25588433ejq.7.1680250717477;
        Fri, 31 Mar 2023 01:18:37 -0700 (PDT)
Received: from localhost ([194.62.217.4])
        by smtp.gmail.com with ESMTPSA id h13-20020a1709066d8d00b009475bd8f441sm719038ejt.60.2023.03.31.01.18.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 01:18:36 -0700 (PDT)
References: <20230329223239.138757-1-y86-dev@protonmail.com>
 <20230329223239.138757-5-y86-dev@protonmail.com>
 <87h6u24bip.fsf@metaspace.dk>
 <6c3985d3-6b81-df0e-5c22-12a0d8044119@protonmail.com>
User-agent: mu4e 1.9.18; emacs 28.2.50
From: Andreas Hindborg <nmi@metaspace.dk>
To: Benno Lossin <y86-dev@protonmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng
 <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?=
 Roy Baron
 <bjorn3_gh@protonmail.com>, Alice Ryhl <alice@ryhl.io>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
Subject: Re: [PATCH v3 04/13] rust: add pin-init API core
Date: Fri, 31 Mar 2023 10:16:56 +0200
In-reply-to: <6c3985d3-6b81-df0e-5c22-12a0d8044119@protonmail.com>
Message-ID: <871ql549lv.fsf@metaspace.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


Benno Lossin <y86-dev@protonmail.com> writes:

> On 30.03.23 15:05, Andreas Hindborg wrote:
>>> +//! [`Arc<T>`]: crate::sync::Arc
>>> +//! [`impl PinInit<Foo>`]: PinInit
>>> +//! [`impl PinInit<T, E>`]: PinInit
>>> +//! [`impl Init<T, E>`]: Init
>>> +//! [`Opaque`]: kernel::types::Opaque
>>> +//! [`pin_data`]: ::macros::pin_data
>>> +//! [`UniqueArc<T>`]: kernel::sync::UniqueArc
>>> +//! [`Box<T>`]: alloc::boxed::Box
>>> +
>>> +use core::{convert::Infallible, marker::PhantomData, mem::MaybeUninit};
>>> +
>>> +/// A pinned initializer for `T`.
>>
>> "An initializer for a pinned `T`" instead?
>
> To me this does not really make sense, since the type `T` cannot be
> pinned, only an instance can be. But maybe I should use the term
> `pin-initializer` instead.

I see. Could be "An initializer for a pinned instance of `T`" then. Just
to clarify that the initializer itself is not the thing that is pinned.

