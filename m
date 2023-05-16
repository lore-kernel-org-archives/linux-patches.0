Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29820182D0
	for <patches@lists.linux.dev>; Tue, 16 May 2023 11:12:07 +0000 (UTC)
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-30479b764f9so5044987f8f.0
        for <patches@lists.linux.dev>; Tue, 16 May 2023 04:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684235525; x=1686827525;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sEUQpMHb6dJRirsjs02VRZsGdmT007slrG/7m3ecq4A=;
        b=jTh2sQy0h/wnTK3qlXXk0iLSLxxkkq3JJYemyleO0akNJycR3xdqBSpFNtuP78sZPH
         q1z/GaeVqh9f2wSvYHQqSuSK7Bnt7Fu3exPaDiHHDDRttWsjp+vLnZlEPiweSaqgYXGs
         w8cnMdF+arz1/vqXlDr6fqPt/uNxzKSj4h15+wWoA70j/0yrHfTLjW5ETXWnsjsuk/Gx
         dkH36a5oiSpgOQuj1kffDVVXxBdYnIH+/IrQ//0LrMqG6OGLj3rCv13LncGf0/iaSpk6
         tgSXGNexxLB2X+dNoIuTwdn2UNfplnB30pKsU61QfAH4pzhHPPxixiGt4jrRPoGXosGM
         L5zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684235525; x=1686827525;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sEUQpMHb6dJRirsjs02VRZsGdmT007slrG/7m3ecq4A=;
        b=EOof0P+pRkFc2MLXHjDmfkCrbbtamOYYEYvBAZVGpsAJGHG62atKFA/VU08NWstqFM
         edyxiUI/sM6vRAFxIk7aJEb8NZv9W49hY9Dyrc2z9PgsCtlrgnN9UcMqMSKvBojdmd/z
         KcGMBHZAUvOHI4fOioG9koEHp076xjwAfbM9K3DflXGKtc+11EcI3rYnoKFrGABbuIFS
         D/QXZTwLbJu2edlz19sHksU7TcVmbH8IuddzsAyZ0uMktFq17aeXjRyCATcABp5AM/4I
         OBffRGoTvbu01HHG8v/mmb+f6P9JFvz3i4jOaOYPOVzL4pQ24UhipMboGbHctQ253fBM
         IFiA==
X-Gm-Message-State: AC+VfDxKXBuYB59UwLXTx2tDmbjRjNBJFwrdv3eM+iPH2pivLZGDGnUc
	aMHEQf5hLdFrj5DMzL15Iqf2A0TwOjR23eI=
X-Google-Smtp-Source: ACHHUZ7bk6OwKBPWjNuvpRxLseI+VezMQERmUNQzW8hSrKxmZjJnVMCvYNXDCOS7pg3d6PBqqkO+3Thap10VUM8=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a5d:4ac4:0:b0:307:cea0:ee9a with SMTP id
 y4-20020a5d4ac4000000b00307cea0ee9amr2239352wrs.7.1684235525305; Tue, 16 May
 2023 04:12:05 -0700 (PDT)
Date: Tue, 16 May 2023 11:12:02 +0000
In-Reply-To: <871qjhe9xh.fsf@metaspace.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <871qjhe9xh.fsf@metaspace.dk>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230516111202.2455529-1-aliceryhl@google.com>
Subject: Re: [PATCH v2] rust: str: add conversion from `CStr` to `CString`
From: Alice Ryhl <aliceryhl@google.com>
To: nmi@metaspace.dk
Cc: alex.gaynor@gmail.com, alice@ryhl.io, benno.lossin@proton.me, 
	bjorn3_gh@protonmail.com, boqun.feng@gmail.com, gary@garyguo.net, 
	linux-kernel@vger.kernel.org, ojeda@kernel.org, patches@lists.linux.dev, 
	rust-for-linux@vger.kernel.org, wedsonaf@gmail.com, yakoyoku@gmail.com
Content-Type: text/plain; charset="UTF-8"

Andreas Hindborg <nmi@metaspace.dk> writes:
> Alice Ryhl <alice@ryhl.io> writes:
>> On 5/8/23 13:41, Gary Guo wrote:
>>> On Wed,  3 May 2023 14:10:16 +0000
>>> Alice Ryhl <aliceryhl@google.com> wrote:
>>>> These methods can be used to copy the data in a temporary c string into
>>>> a separate allocation, so that it can be accessed later even if the
>>>> original is deallocated.
>>>>
>>>> The API in this change mirrors the standard library API for the `&str`
>>>> and `String` types. The `ToOwned` trait is not implemented because it
>>>> assumes that allocations are infallible.
>>> How about add a `TryToOwned` trait to the kernel crate and implement
>>> that trait for `CStr` instead?
>>
>> Eh, I don't think it's worth it. It doesn't give anything new to the CStr api,
>> and I think it's rather unlikely that someone will actually need to be generic
>> over such a trait any time soon.
> 
> It is just as valid as having `From<&str>` and `ToOwned<&str>`. While it
> does not add anything in terms of function, it carries intention. I
> think we should consider adding it at some point.
> 
> BR Andreas

Sure, I think its quite reasonable to add new traits, I just don't think
it should be part of this patch. Adding new traits makes it a
significantly bigger change IMO, and my changes have an actual user down
the road.

Alice
