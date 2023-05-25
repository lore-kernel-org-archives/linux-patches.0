Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31BABE50
	for <patches@lists.linux.dev>; Thu, 25 May 2023 07:49:32 +0000 (UTC)
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-4f4b2bc1565so2021601e87.2
        for <patches@lists.linux.dev>; Thu, 25 May 2023 00:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaspace-dk.20221208.gappssmtp.com; s=20221208; t=1685000970; x=1687592970;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=V1XvSVODDEA3TsNr4/6rD8fONkRZXOKHxfaQzrvBuWE=;
        b=Rb//MjVriA87cNvKfaQfy3k9aTXfLTkqIAAMtLnZJCSLwvy103u/pNn02HRykZaUUX
         1vsVPWhDqU+OqtlMaTmprHYMgDKPpfCWb49z0qLWfQH45DLgWjAORZw3oExhyKG1IHSI
         J4fXuhJ8dMvB8XOb1vj/I6nA1/TKUznn+jJgljKwgqIUQLmIgBOCFrrgRiCVQwJ4digD
         b7vxocdF8bhn3v9RlkTFXzfH0YUs2UwotoGSt/gWnNoblBQfExdUtRP6J2BqCTLKf9+Z
         B5zPjKK+Mpt7ur40CI3YTFTWHXU9rIDR9C+hGWSfoUJKIjtUIV9NT7yndiav3lObKCV5
         xEtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685000970; x=1687592970;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V1XvSVODDEA3TsNr4/6rD8fONkRZXOKHxfaQzrvBuWE=;
        b=PotJ8nocA7ndCHkMdVl9yLTi2if7dfutbdgXY+OHZx/UYbvkNmRNtIuYIrHyHBE9lj
         G7Qs0JV1vQ2AQOmIq8D963IrTKaAoIZHyHBnJiR2PGQYyNR1Ly+/O7hS3veBcU2ABcmj
         3zlKi0IUn8C6mw+pzgh2TQw0rObne1mQ3Ivk1D6TNebhmGDiDy5zrbcJCPOclHkTcsnJ
         v0m+pO/8GHNZMh7ZcMel4f1uNK5Yn/fLT8MIkZARFpb2l6jq9cEvjjPm7sNBWViwvuP8
         MOeA1c4VkB0S60wK0SocuVuhpnQZ8RNKyeMehwH5qj1YkZi8sfuvWGdtQ6kslWhPl/Xa
         oUAw==
X-Gm-Message-State: AC+VfDy/XZyxti1bLFEkW8QMDDHBv3caVKMwS/fupTkUspt1XwMkLTtM
	eWfE5FAv8Pzlxke6hHFPNwb6qw==
X-Google-Smtp-Source: ACHHUZ4kdZAHbddsr82/JU+BYvNmlUQoxgJp+jPn0fQ2cDA6MucbPgKmHAJbM5tZHMio1jw9kM0xoQ==
X-Received: by 2002:a05:6512:21a6:b0:4ef:f3bf:93a6 with SMTP id c6-20020a05651221a600b004eff3bf93a6mr6505557lft.51.1685000970268;
        Thu, 25 May 2023 00:49:30 -0700 (PDT)
Received: from localhost (77.241.128.147.mobile.3.dk. [77.241.128.147])
        by smtp.gmail.com with ESMTPSA id t17-20020ac25491000000b004f3b6e71eb1sm108281lfk.291.2023.05.25.00.49.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 00:49:29 -0700 (PDT)
References: <87edn6do1b.fsf@metaspace.dk>
 <20230524111127.2491643-1-aliceryhl@google.com>
User-agent: mu4e 1.10.3; emacs 28.2.50
From: Andreas Hindborg <nmi@metaspace.dk>
To: Alice Ryhl <aliceryhl@google.com>
Cc: alex.gaynor@gmail.com, benno.lossin@proton.me, bjorn3_gh@protonmail.com,
 boqun.feng@gmail.com, gary@garyguo.net, jiangshanlai@gmail.com,
 linux-kernel@vger.kernel.org, ojeda@kernel.org, patches@lists.linux.dev,
 rust-for-linux@vger.kernel.org, tj@kernel.org, wedsonaf@gmail.com
Subject: Re: [PATCH v1 3/7] rust: sync: add `Arc::{from_raw, into_raw}`
Date: Thu, 25 May 2023 09:45:29 +0200
In-reply-to: <20230524111127.2491643-1-aliceryhl@google.com>
Message-ID: <87a5xsetq5.fsf@metaspace.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


Alice Ryhl <aliceryhl@google.com> writes:

> Andreas Hindborg <nmi@metaspace.dk> writes:
>> Alice Ryhl <aliceryhl@google.com> writes:
>>> +        // This preserves the metadata in the pointer, if any.
>>> +        let metadata = core::ptr::metadata(ptr as *const ArcInner<T>);
>> 
>> I can't follow this. How does this work? `ptr` was for field
>> `inner.data: T`, but we are casting to `ArcInner<T>`.
>> 
>>> +        let ptr = (ptr as *mut u8).wrapping_sub(val_offset) as *mut ();
>>> +        let ptr = core::ptr::from_raw_parts_mut(ptr, metadata);
>> 
>> Metadata was obtained from a pointer pointing to `inner.data`, we then
>> move it back to beginning of `ArcInner<T>` and then reconstruct the
>> potentially fat pointer with metadata from the pointer to `T`? How can
>> this be right?
>
> The metadata of a struct is always the metadata of its last field, so
> both `*mut T` and `*mut ArcInner<T>` have the same metadata. Because of
> that, moving the metadata over from one type to the other is ok.
>
> The reason that I cast to an `ArcInner<T>` pointer before calling
> `metadata` is because I get a type mismatch otherwise for the metadata,
> since the compiler doesn't unify the metadata types when the type is
> generic.

OK, cool. In that case, since this is common knowledge (is it?),
could you maybe include a link to the relevant documentation, or a
comment indicating why this is OK?

BR Andreas
