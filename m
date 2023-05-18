Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35EB77C
	for <patches@lists.linux.dev>; Fri, 19 May 2023 00:28:41 +0000 (UTC)
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-6ab13810da6so1113042a34.2
        for <patches@lists.linux.dev>; Thu, 18 May 2023 17:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684456120; x=1687048120;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xfintrOM/1fpOEzvoo+azEZAHiiUhCkQ94XfBy4YSIw=;
        b=QVGac+UY98q0Icyx2cFtitW+fHYVtcUadgrt5aegq52aXKojnveL/fVfx2un2sgvR4
         +MOfF5XMqH/9tVdVxWSWaCph9k28l9gQC3Qn8K+p/oBoAVzPLVNfJWRxbsUuVq73H+Fo
         oIT8Ig4A58FDkvJWwTNRWLdSEM0YAeJdYDKi3DroIwOASst2jSwV8ZifXCQxTyGTyimH
         0tKPhfpLLq+YS8/CTH/QW9na1K3C7XZaYNbDl6sFKCMuBAaFpkaZ/QlgA5Q1Oym/IAm7
         63pKXQzdnzttP25rtScDKFdB7BcFOeVolFWZKJNuWul84SaUkB6V0Er2wqTvLVFLdu9A
         YkcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684456120; x=1687048120;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xfintrOM/1fpOEzvoo+azEZAHiiUhCkQ94XfBy4YSIw=;
        b=i7vbvsDLd/U9UmhqRRHhc1DvnyDHPxsJYGQnqaKWeKOJNYTSzmyxd2MrfbLI4ub04M
         +WDAoRNhBQvCh3YJ61kHJp4GBgR1iSlpMy5H/xoAan1hlCxXnRuxnjYRlnbBiEFVZPbB
         3k7+VR6j48zdsujKyD8ZzLWDMBKzLmJYnLvgKcqsS8GXWuNJkXE+Fwj9+VgSP/a3wyjc
         G813TTQhGRF3ohYsowz91PgE+sRf5pMCZak4l6VoWY892jZOqkAjN5J7bQPeVGw4JicR
         2t5i2/2kDKjLtK8rzb2n9dnSZ4AW5VeE3P2MBQxLHX0sv6K5TADpgXXMf36MBk2lobc4
         /pSw==
X-Gm-Message-State: AC+VfDwj2+PnK9HVUFAV2mXcu/ejsxVINX5x+KdYIckL5P0akGXsale4
	W2jgFpyTpWB4QKjP06xgrCw=
X-Google-Smtp-Source: ACHHUZ6cbUF6iirrzUPMVN6p7d9wmles1zdmr588mUVTivZeLy+yaI7bLU71vnyTekkSxXNRSGB76w==
X-Received: by 2002:a9d:7a91:0:b0:6ac:8557:b0e7 with SMTP id l17-20020a9d7a91000000b006ac8557b0e7mr145266otn.32.1684456120073;
        Thu, 18 May 2023 17:28:40 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id j9-20020a9d7389000000b006adc8d27bdfsm1191921otk.7.2023.05.18.17.28.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 May 2023 17:28:39 -0700 (PDT)
Message-ID: <8e42aad3-d94e-3cb4-ee59-90ded31cea9e@gmail.com>
Date: Thu, 18 May 2023 11:51:17 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Subject: Re: [PATCH v1 1/7] rust: workqueue: add low-level workqueue bindings
To: Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho
 <wedsonaf@gmail.com>, Tejun Heo <tj@kernel.org>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=c3=b6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <20230517203119.3160435-1-aliceryhl@google.com>
 <20230517203119.3160435-2-aliceryhl@google.com>
Content-Language: en-US
In-Reply-To: <20230517203119.3160435-2-aliceryhl@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/17/23 17:31, Alice Ryhl wrote:
> Define basic low-level bindings to a kernel workqueue. The API defined
> here can only be used unsafely. Later commits will provide safe
> wrappers.
> 
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
> [...]
> +
> +impl Queue {
> +    /// Use the provided `struct workqueue_struct` with Rust.
> +    ///
> +    /// # Safety
> +    ///
> +    /// The caller must ensure that the provided raw pointer is not dangling, that it points at a
> +    /// valid workqueue, and that it remains valid until the end of 'a.
> +    pub unsafe fn from_raw<'a>(ptr: *const bindings::workqueue_struct) -> &'a Queue {
> +        // SAFETY: The `Queue` type is `#[repr(transparent)]`, so the pointer cast is valid. The
> +        // caller promises that the pointer is not dangling.
> +        unsafe { &*(ptr as *const Queue) }
> +    }
> +
> +    /// Enqueues a work item.
> +    ///
> +    /// This may fail if the work item is already enqueued in a workqueue.

Wouldn't be worth to mention that, if not implied, the item it's going
to be worked on an unbound CPU?

> +    pub fn enqueue<T: WorkItem + Send + 'static>(&self, w: T) -> T::EnqueueOutput {
> +        let queue_ptr = self.0.get();
> [...]

Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
