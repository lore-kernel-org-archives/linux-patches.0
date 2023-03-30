Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C081C1FC4
	for <patches@lists.linux.dev>; Thu, 30 Mar 2023 12:49:51 +0000 (UTC)
Received: by mail-wm1-f54.google.com with SMTP id u11-20020a05600c19cb00b003edcc414997so11680648wmq.3
        for <patches@lists.linux.dev>; Thu, 30 Mar 2023 05:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaspace-dk.20210112.gappssmtp.com; s=20210112; t=1680180589;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=9+K5/0WWDeVeEe+OTVzrXk5PiHrboI0Tjgq0g0AOhqY=;
        b=LkAtv5oslcUMu1ahCRkvL4bj6CO/s2xK7gDrkZliP+k14ycQCTxe4y1p4uqMny88/k
         Q69dmgwDRN9rJa+CkFIQ0e2ZDjcdI5sly3atK+TanUI/hlDoVAWQdky+oubsbKeq6uhm
         ZioWh/6lnwhMIjzwcIVlN4NVgwp9jIBrBOeR+Hed/gwGo3+uFIdTqBqVHq/gJsbC0lsJ
         HZCGmra7G7xYsn3EURw7Hm17EbfM0XHZKUPJLwa/2b9afH03sXUbkDwahtF/rCzaAKbv
         /WaFxGdkES/Z60jQiNaSqDgKAUinYLs1wUXmCBEFu2kgRquPXxq3qcilQ5fYt5ib28Ad
         59pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680180590;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9+K5/0WWDeVeEe+OTVzrXk5PiHrboI0Tjgq0g0AOhqY=;
        b=4iXCJNLdFO1FEzocrLyv+F1rnDf/rxnrB+gn4WDzpWQc/pJVAI4Hr64iK/qnN8mxum
         p/7XM1QhpXCOQGATjjPOrNnHdSCB4wcbxQreJn9gQADdkaEFeA8mMZwLMzUaUy1I3jLw
         J999BPa8XgO4JpRz8MzL8+IWINT4DfLS2jLOqac54TXoB8gjRlkvuxMoBJrd/UDicTXM
         mM92E8u9AOtkswG23QWaCduNkQ3ad5b3ocDuF/eSR5WdBI4+hrb0FMhulk+BE0W9CqYk
         96JDGQwLclRV9HrQfLawiH1arhXVgBykvONCSnh47ke9JTQQerIkuJZ1TNe/JxOjK8QM
         Mf9w==
X-Gm-Message-State: AAQBX9fDgdtytyqVVtAPM7gY0wOpLYtF2NyFd1BB75vw/4LzB3NZY0nC
	JPExaGQLvEfK5tstRvj+fiRDAA==
X-Google-Smtp-Source: AKy350YVrGbxE3Bd4v1m+F3ok9Nrusg2V+E0fusX9dtc6+f5OdSxphjAN8y5r7KCDqNoGUKoYKHcGw==
X-Received: by 2002:a1c:f20e:0:b0:3ef:6ae7:89bd with SMTP id s14-20020a1cf20e000000b003ef6ae789bdmr11318687wmc.6.1680180589697;
        Thu, 30 Mar 2023 05:49:49 -0700 (PDT)
Received: from localhost ([194.62.217.4])
        by smtp.gmail.com with ESMTPSA id h16-20020a05600c315000b003eda46d6792sm6175846wmo.32.2023.03.30.05.49.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 05:49:49 -0700 (PDT)
References: <20230329223239.138757-1-y86-dev@protonmail.com>
 <20230329223239.138757-4-y86-dev@protonmail.com>
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
Subject: Re: [PATCH v3 03/13] rust: types: add `Opaque::raw_get`
Date: Thu, 30 Mar 2023 14:32:19 +0200
In-reply-to: <20230329223239.138757-4-y86-dev@protonmail.com>
Message-ID: <87leje4d5f.fsf@metaspace.dk>
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
> This function mirrors `UnsafeCell::raw_get`. It avoids creating a
> reference and allows solely using raw pointers.
> The `pin-init` API will be using this, since uninitialized memory
> requires raw pointers.
>
> Signed-off-by: Benno Lossin <y86-dev@protonmail.com>
> ---

Reviewed-by: Andreas Hindborg <a.hindborg@samsung.com>

>  rust/kernel/types.rs | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/rust/kernel/types.rs b/rust/kernel/types.rs
> index 9d0fdbc55843..ff2b2fac951d 100644
> --- a/rust/kernel/types.rs
> +++ b/rust/kernel/types.rs
> @@ -238,6 +238,14 @@ impl<T> Opaque<T> {
>      pub fn get(&self) -> *mut T {
>          UnsafeCell::raw_get(self.0.as_ptr())
>      }
> +
> +    /// Gets the value behind `this`.
> +    ///
> +    /// This function is useful to get access to the value without creating intermediate
> +    /// references.
> +    pub const fn raw_get(this: *const Self) -> *mut T {
> +        UnsafeCell::raw_get(this.cast::<UnsafeCell<T>>())
> +    }
>  }
>
>  /// A sum type that always holds either a value of type `L` or `R`.

