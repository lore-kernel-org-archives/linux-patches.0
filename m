Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB2211189
	for <patches@lists.linux.dev>; Tue, 30 May 2023 07:26:33 +0000 (UTC)
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-97000a039b2so750275266b.2
        for <patches@lists.linux.dev>; Tue, 30 May 2023 00:26:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaspace-dk.20221208.gappssmtp.com; s=20221208; t=1685431591; x=1688023591;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=WP79/Ln5yTFs7inOQKZSTC+cgVXli+9NjL23Cwry9FE=;
        b=BiAhhIEROaDo7RQZWuLc/wNonbzBfBGVyciRN/h/uqr9D3rjBRMS/rMRsgZhD5VFp4
         ZWW/X7S7OwREjg5ht4wfWyGFd7MsmLnwj8LgyO6OS2mGc1FVxq9Mw9wR+B05PPM6QjG+
         nuR8AFD4oblz3JdWkixodRzzZU1+Ah1x27eDMkz26n9G0g8VsOuX0MaqR1Suck29T2jy
         /fjOWghqZlyroAj4TEuDn61Q3qIyjBN0+tkRhmfqM/fO9SqEDfYE3JbMYCoP9Uh2Btnw
         ADTaykKSOYz1Lmg7VMZNv2h/N3VkdTxoO+2gTDvm7wRKsd7TfBScPkKvYNW243+G9Ssp
         zCLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685431591; x=1688023591;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WP79/Ln5yTFs7inOQKZSTC+cgVXli+9NjL23Cwry9FE=;
        b=S+vzTCwF0NydQtVHHZpN25S3I08hKCA8Z6LuvXthtNPU2f87ZE8rIPTworu26i99Wa
         U136nAb7u2ibk6PnBGpHMcAPMaurjwPGT24g5RsGnW8QyzKT7HnVvpV9swVxr9vSYUCb
         LamMozK82lhrxSyODBkr1SAbbmKuHib5KDLJu1TXaB0JUx/+B5JhaIQmj+RUjdNaGt5j
         bjEFw/PpkdXb1eqUizRHRQrETKPx6NMS/TJ8/7H+ud1lkG07DK0nJ5DAZ7JKnYy3piOQ
         dW2DnVuKRVQu97i7ZdeI52U8piA/wn+XlVZD6DTK1DzSQ6tqL//ia7eUzWEuwyJV/xd8
         yIMw==
X-Gm-Message-State: AC+VfDwGAePb1sTM8jkCtDvPTr9j9MeURYP2roNOEtCHstaj0p2urcOX
	qGDpNVXScmS8Kvtbz4bleTQcpg==
X-Google-Smtp-Source: ACHHUZ6NcwA8CAs3S2huYij/sYZkiEO73JR5xPnnHI69maLTBKV2UYJH8i+DIu92ycyj1JD3LkWptQ==
X-Received: by 2002:a17:907:98e:b0:965:9602:1f07 with SMTP id bf14-20020a170907098e00b0096596021f07mr1603562ejc.39.1685431591424;
        Tue, 30 May 2023 00:26:31 -0700 (PDT)
Received: from localhost ([194.62.217.2])
        by smtp.gmail.com with ESMTPSA id gg26-20020a170906e29a00b00973a9d66f56sm6816400ejb.206.2023.05.30.00.26.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 00:26:30 -0700 (PDT)
References: <87edn6do1b.fsf@metaspace.dk>
 <20230524111127.2491643-1-aliceryhl@google.com>
 <87a5xsetq5.fsf@metaspace.dk> <20230525173217.6eccda7b.gary@garyguo.net>
User-agent: mu4e 1.10.3; emacs 28.2.50
From: Andreas Hindborg <nmi@metaspace.dk>
To: Gary Guo <gary@garyguo.net>
Cc: Alice Ryhl <aliceryhl@google.com>, alex.gaynor@gmail.com,
 benno.lossin@proton.me, bjorn3_gh@protonmail.com, boqun.feng@gmail.com,
 jiangshanlai@gmail.com, linux-kernel@vger.kernel.org, ojeda@kernel.org,
 patches@lists.linux.dev, rust-for-linux@vger.kernel.org, tj@kernel.org,
 wedsonaf@gmail.com
Subject: Re: [PATCH v1 3/7] rust: sync: add `Arc::{from_raw, into_raw}`
Date: Tue, 30 May 2023 09:23:29 +0200
In-reply-to: <20230525173217.6eccda7b.gary@garyguo.net>
Message-ID: <87y1l69t5l.fsf@metaspace.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


Gary Guo <gary@garyguo.net> writes:

> On Thu, 25 May 2023 09:45:29 +0200
> Andreas Hindborg <nmi@metaspace.dk> wrote:
>
>> Alice Ryhl <aliceryhl@google.com> writes:
>> 
>> > Andreas Hindborg <nmi@metaspace.dk> writes:  
>> >> Alice Ryhl <aliceryhl@google.com> writes:  
>> >>> +        // This preserves the metadata in the pointer, if any.
>> >>> +        let metadata = core::ptr::metadata(ptr as *const ArcInner<T>);  
>> >> 
>> >> I can't follow this. How does this work? `ptr` was for field
>> >> `inner.data: T`, but we are casting to `ArcInner<T>`.
>> >>   
>> >>> +        let ptr = (ptr as *mut u8).wrapping_sub(val_offset) as *mut ();
>> >>> +        let ptr = core::ptr::from_raw_parts_mut(ptr, metadata);  
>> >> 
>> >> Metadata was obtained from a pointer pointing to `inner.data`, we then
>> >> move it back to beginning of `ArcInner<T>` and then reconstruct the
>> >> potentially fat pointer with metadata from the pointer to `T`? How can
>> >> this be right?  
>> >
>> > The metadata of a struct is always the metadata of its last field, so
>> > both `*mut T` and `*mut ArcInner<T>` have the same metadata. Because of
>> > that, moving the metadata over from one type to the other is ok.
>> >
>> > The reason that I cast to an `ArcInner<T>` pointer before calling
>> > `metadata` is because I get a type mismatch otherwise for the metadata,
>> > since the compiler doesn't unify the metadata types when the type is
>> > generic.  
>> 
>> OK, cool. In that case, since this is common knowledge (is it?),
>> could you maybe include a link to the relevant documentation, or a
>> comment indicating why this is OK?
>> 
>> BR Andreas
>
> This is documented in the doc of Pointee trait:
>
> https://doc.rust-lang.org/std/ptr/trait.Pointee.html

Nice. I think I forgot a _not_ in my last message. I think it would be
nice to add a comment with a link to this documentation and perhaps a
note as to why this works.

BR Andreas

