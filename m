Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4430C182A2
	for <patches@lists.linux.dev>; Wed, 24 May 2023 12:26:43 +0000 (UTC)
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-513f8141094so941817a12.1
        for <patches@lists.linux.dev>; Wed, 24 May 2023 05:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684931201; x=1687523201;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tIkJCVY+tMqNuU9Hdw7jNNdVzKzit4T0GD2WdhoZSXQ=;
        b=Rf0miXKtnbI4iEIXnusCA82/4rOsQIVvu9oayiSk1I7Dqc9En3wSLFxnjUErf0qLVa
         5KAMme6jheRdEI8gnBPwkCmhQVED/QGDHTgZLbzMB5ZR4iUnlN/djzTMiy0JZO/TF2s1
         nJzbPCf3eo3CYZdvYUnOuLyl/r03i2DjvnXQ3lunbiMziTZ6KXC93Jrz6kEUbg3r+eY3
         6Qb0Mzv2vDX1y4Ut2U5vyMmQcwLtKMbzG874bgg1SOn6cwo7hhWFWsaWl+Cc97/FrTN6
         ZYndWmGkM+enrawaHU4L38v9HejkFTTP3gjfqq9l7YY9WhVBau7Kt4lMFE49Rt6tgjGu
         v2NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684931201; x=1687523201;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tIkJCVY+tMqNuU9Hdw7jNNdVzKzit4T0GD2WdhoZSXQ=;
        b=CxRluF2XyuH483nfyJI3ct+UzmVVzFh+F1je6E6NRu3vh4FekwfPWGv5/O6j5fHOQ6
         by6ARf43g/u/d/d2YFJvH4xcU+iHE5B0LcE3BXMZ7cHPcpwwSxM/G/y2hrWltHCKj3cT
         zvogwKilfEMNn+UOGgh6bry5cSl00WdkX7wAXc8ZfPs8KwgUImOahb91vzYAG4lyGnyu
         D6osSkd8BiDKFzuQxWrfK/3ULfhVQCCWb6hkBmpj0g/MQR4m4z7U1iYlbTDod7Thh6kv
         tsRitmuJsAtVt+HVqQqwLwZP5Yd/3LCvFjThuqcOo8YY0kj9iYbG/EBr7sA0vNCuKCMN
         ZueQ==
X-Gm-Message-State: AC+VfDyWo/kgXszIaO57aADsLjQHl+8MY0Jiu+XuQ/zckuhE0QyMSndH
	MI5QETn53g0dszm0B3N5BrOkAOVRgE7aH6Q=
X-Google-Smtp-Source: ACHHUZ6lrbZQBWSWqXTum+8RwDWhnUR59VF9KPwRaF43x13cn/85dwpHjlzTnW6IWF9TZhfFxQQ3n0FHhXp7TVc=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a50:bb64:0:b0:50c:d8e:5f4b with SMTP id
 y91-20020a50bb64000000b0050c0d8e5f4bmr820708ede.8.1684931201472; Wed, 24 May
 2023 05:26:41 -0700 (PDT)
Date: Wed, 24 May 2023 12:26:39 +0000
In-Reply-To: <20230523164818.0a44fec8.gary@garyguo.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230523164818.0a44fec8.gary@garyguo.net>
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
Message-ID: <20230524122639.2500848-1-aliceryhl@google.com>
Subject: Re: [PATCH v1 2/7] rust: add offset_of! macro
From: Alice Ryhl <aliceryhl@google.com>
To: gary@garyguo.net
Cc: alex.gaynor@gmail.com, aliceryhl@google.com, benno.lossin@proton.me, 
	bjorn3_gh@protonmail.com, boqun.feng@gmail.com, jiangshanlai@gmail.com, 
	linux-kernel@vger.kernel.org, ojeda@kernel.org, patches@lists.linux.dev, 
	rust-for-linux@vger.kernel.org, tj@kernel.org, wedsonaf@gmail.com
Content-Type: text/plain; charset="UTF-8"

Gary Guo <gary@garyguo.net> writes:
> On Wed, 17 May 2023 20:31:14 +0000
> Alice Ryhl <aliceryhl@google.com> wrote:
>> +#[macro_export]
>> +macro_rules! offset_of {
>> +    ($type:ty, $field:ident) => {{
>> +        let tmp = ::core::mem::MaybeUninit::<$type>::uninit();
>> +        let outer = tmp.as_ptr();
>> +        // To avoid warnings when nesting `unsafe` blocks.
>> +        #[allow(unused_unsafe)]
>> +        // SAFETY: The pointer is valid and aligned, just not initialised; `addr_of` ensures that
>> +        // we don't actually read from `outer` (which would be UB) nor create an intermediate
>> +        // reference.
>> +        let inner = unsafe { ::core::ptr::addr_of!((*outer).$field) } as *const u8;
>> +        // To avoid warnings when nesting `unsafe` blocks.
>> +        #[allow(unused_unsafe)]
>> +        // SAFETY: The two pointers are within the same allocation block.
>> +        unsafe {
>> +            inner.offset_from(outer as *const u8) as usize
>> +        }
> 
> This has no protection against using `Deref`. The memoffset crate has a 
> 
> let $type { $field: _, .. };
> 
> line to ensure that the field is a direct member of type and deref is
> not happening.

Added. I had to change `$type:ty` to `$type:path` to get that to
compile, since otherwise you can't use the token in a pattern. However,
I think it's fine - this is temporary anyway until the standard library
gets the macro.
 
>> +    }};
>> +}
>> diff --git a/scripts/Makefile.build b/scripts/Makefile.build
>> index 9f94fc83f086..ec583d13dde2 100644
>> --- a/scripts/Makefile.build
>> +++ b/scripts/Makefile.build
>> @@ -277,7 +277,7 @@ $(obj)/%.lst: $(src)/%.c FORCE
>>  # Compile Rust sources (.rs)
>>  # ---------------------------------------------------------------------------
>>  
>> -rust_allowed_features := core_ffi_c,explicit_generic_args_with_impl_trait,new_uninit,pin_macro
>> +rust_allowed_features := const_ptr_offset_from,const_refs_to_cell,core_ffi_c,explicit_generic_args_with_impl_trait,new_uninit,pin_macro
> 
> Side note: once we bump our compiler to 1.71, we should switch to the
> built-in `offset_of!` macro and get rid of these unstable features.

Agreed. I mentioned that in the commit message.

Alice
