Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DCC020180
	for <patches@lists.linux.dev>; Tue, 22 Aug 2023 19:52:10 +0000 (UTC)
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-523d2ef19e4so6227688a12.2
        for <patches@lists.linux.dev>; Tue, 22 Aug 2023 12:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaspace-dk.20221208.gappssmtp.com; s=20221208; t=1692733929; x=1693338729;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=8rgEdoTOAdm60cwf4SttnTE5XQ2a7mDmyn58eCgJqMM=;
        b=AL2vd6ZYVb+rHSzEIpdrY9JUYph0K6Y9attv4GTebIus4ywA1Azleve9/Pnw3KK1sy
         zT5z6NtZbKwMa0g0cazMAvsDvkbNq11pn7rTYj+RrzyhgUamA0pS8sbZzw5Sde6rBUZb
         gUc9cMUqSOcSKEveiYiM2GNIlxIAGDTyJ79VlfAjsg3hZuO02kStGu4D5SWI7r9Q3u7B
         /8vRBxHwY8Ubo4RilruQUtIzWq+KtoiuFjfMqVAAnVFn2C5Bw0DGB66knnVeuqv3sR9J
         pjJBpC1h0Yw8lqP1V/wgtc08pImAbASzZ8+UWACc24oK0GYRva2/Wr+TSi34ouaHtAfa
         Zi6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692733929; x=1693338729;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8rgEdoTOAdm60cwf4SttnTE5XQ2a7mDmyn58eCgJqMM=;
        b=EKCbDbDvAbxmhGrj3NfZjuUI143nRAwFGYCNzxpsV4sD1eCsq+sCd9wDg3nzBlfv6A
         doo+utFn3L7H69+1P3xK04exdILGXLwd36/IgDmiEH8ieunE+aj0W2mWycFoHTY8c4tN
         KTQrH2titrRIx11D9vBQPm8P2J+gYiAeBBmsJS8wuYC5vQW4B14smQyuknTkKT7iZx1L
         IbKQKYe/Fwl1OCDa1vMNm25EPSqvhr41dY2rAiC1+kN2eHHlgsuxZyMVBKnc/aiB8jCF
         5nWxMz5WeumoBattPf2wGiEyUUxbYzJNL2qrfa6V3i9+cOuqy4EfA3bU2cBCvvttXUVp
         wTgA==
X-Gm-Message-State: AOJu0YzeuJJVjoCQI03bj45KZQuiiE9+Ufkm7j9sTtWmckimdtKDC7rQ
	S2xTtnxdp1EULyVruJ2HQSS09w==
X-Google-Smtp-Source: AGHT+IE4wVIW18x3q1rp0TBbYP4cS1KkB0SFLU6Vc/NWR4Tkowt2qZGoQovU3XtLmgcLq2hSbP3e2w==
X-Received: by 2002:a17:907:2c59:b0:993:d7fe:7f1d with SMTP id hf25-20020a1709072c5900b00993d7fe7f1dmr8355338ejc.28.1692733928951;
        Tue, 22 Aug 2023 12:52:08 -0700 (PDT)
Received: from localhost ([79.142.230.34])
        by smtp.gmail.com with ESMTPSA id k12-20020a1709061c0c00b009a1a653770bsm2699886ejg.87.2023.08.22.12.52.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Aug 2023 12:52:08 -0700 (PDT)
References: <20230711093303.1433770-1-aliceryhl@google.com>
 <20230711093303.1433770-7-aliceryhl@google.com>
 <vyrVN334oIXneb9VWievGpPTOCy0irxvoG-mDR0sQX5-xN-TL2Hngl0cl_XrVUwjDB3rXkXfR9Mdjy_no6fzhe4yIf_c7xpKa5OURt43k9c=@proton.me>
User-agent: mu4e 1.10.5; emacs 28.2.50
From: "Andreas Hindborg (Samsung)" <nmi@metaspace.dk>
To: Benno Lossin <benno.lossin@proton.me>
Cc: Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, Tejun
 Heo <tj@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, Lai Jiangshan
 <jiangshanlai@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, Alex
 Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary
 Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v3 6/9] rust: workqueue: add helper for defining
 work_struct fields
Date: Tue, 22 Aug 2023 20:24:04 +0200
In-reply-to: <vyrVN334oIXneb9VWievGpPTOCy0irxvoG-mDR0sQX5-xN-TL2Hngl0cl_XrVUwjDB3rXkXfR9Mdjy_no6fzhe4yIf_c7xpKa5OURt43k9c=@proton.me>
Message-ID: <87msyisvmi.fsf@metaspace.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


Hi Benno,

Benno Lossin <benno.lossin@proton.me> writes:

...

>> +/// Links for a work item.
>> +///
>> +/// This struct contains a function pointer to the `run` function from the [`WorkItemPointer`]
>> +/// trait, and defines the linked list pointers necessary to enqueue a work item in a workqueue.
>> +///
>> +/// Wraps the kernel's C `struct work_struct`.
>> +///
>> +/// This is a helper type used to associate a `work_struct` with the [`WorkItem`] that uses it.
>> +#[repr(transparent)]
>> +pub struct Work<T: ?Sized, const ID: u64 = 0> {
>> +    work: Opaque<bindings::work_struct>,
>> +    _inner: PhantomData<T>,
>
> Should this really be `PhantomData<T>`? Are you dropping `T`s in the 
> destructor of `Work<T>`? I do not think so `PhantomData<fn() -> Box<T>>`
> should do the trick.
>

Could you elaborate what is the issue in having `PhantomData<T>`?

BR Andreas

