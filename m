Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA9F1FBA
	for <patches@lists.linux.dev>; Wed, 31 May 2023 09:00:36 +0000 (UTC)
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-96f9aa23593so466855866b.1
        for <patches@lists.linux.dev>; Wed, 31 May 2023 02:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685523635; x=1688115635;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PEW73TP0tUGYUfeakPneuxLod08yUyWlknx492xsU6I=;
        b=gYPrGvgJZ60XP/b1C8CGziAC6W7bJnxHJ7ittHw6F1f1N/eMr+WR5Ljn5jcPp9fYT1
         VTTggqdWq+M/qyWLAcHEy0y/c/8XGkXkT1+RMQGIf0+z8EZFVJMp7876YvnuYGa0BIHB
         HQO/5frgPLpxUsm/SqfeaqysjOI6I4dapjDMzJWh1btGSexT6s3PmQda0byDSMZyt3la
         X8bC9Rub6mAifjO/3+GlobSObhzbxuFPqV04JA/EZYaJNvQHia0s6B+xumKQjOQh7OCf
         f4nC4BGFTCTj008Xk1yJiyOhqcBihabUQ9/RbZUG10CACpxHDIfGb4chhIVn9oLCgmHx
         nQxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685523635; x=1688115635;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PEW73TP0tUGYUfeakPneuxLod08yUyWlknx492xsU6I=;
        b=i0jRXtQ6B+F9W9B6V4U+LgEMgINzUjQBHmKzICaqoLFw4JDoylsa4oaPS19k82PQ1o
         yik9c5omHY3PwHL0qUsNrzLEqJPYeM6hKi70hosbRA+qkKob+mnT5Dh0mvJ1HB9dEd3f
         GdlG0RoPCdPj/nTO/Sn5SXGCitXUq7u0RH78Wy2YGCN6wfJiLxZhIyhUrJhio7NsZ55T
         UBkg/ElEES8mQMKJb8qNM7Wq+sLBbuR3kpfpv2ox4JOvn2uY29GBmscAwq3VQ9PKRgQW
         ccpiBG1n+6vmZkv6P0TkZHkI5W62VNXXX54KSEbkzWYbObX1sYPbtaXwuf4ZCXhKqS/J
         3xoQ==
X-Gm-Message-State: AC+VfDyo8mmP9JAUqGgdMRROMUynC+eAmaLzVY0wskzpUkFlOEizViRa
	MH1obsGU6zLIPBTRjD/Ry0fd5XkXvebczIo=
X-Google-Smtp-Source: ACHHUZ65hkl1uia6H6MximaB38OQnF+T/FPInRsNjxXobMlEoXQ5hscWUZ3mcBy5BHny1EYvzHMob7R5wWwcszc=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a17:906:9bc4:b0:973:8412:2f78 with SMTP
 id de4-20020a1709069bc400b0097384122f78mr1812269ejc.2.1685523634903; Wed, 31
 May 2023 02:00:34 -0700 (PDT)
Date: Wed, 31 May 2023 09:00:32 +0000
In-Reply-To: <87leh69par.fsf@metaspace.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <87leh69par.fsf@metaspace.dk>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230531090032.3667467-1-aliceryhl@google.com>
Subject: Re: [PATCH v1 5/7] rust: workqueue: add helper for defining
 work_struct fields
From: Alice Ryhl <aliceryhl@google.com>
To: nmi@metaspace.dk
Cc: alex.gaynor@gmail.com, aliceryhl@google.com, benno.lossin@proton.me, 
	bjorn3_gh@protonmail.com, boqun.feng@gmail.com, gary@garyguo.net, 
	jiangshanlai@gmail.com, linux-kernel@vger.kernel.org, ojeda@kernel.org, 
	patches@lists.linux.dev, rust-for-linux@vger.kernel.org, tj@kernel.org, 
	wedsonaf@gmail.com
Content-Type: text/plain; charset="UTF-8"

Andreas Hindborg <nmi@metaspace.dk> writes:
> Alice Ryhl <aliceryhl@google.com> writes:
>> +/// Used to safely implement the [`HasWork<T>`] trait.
>> +///
>> +/// # Examples
>> +///
>> +/// ```
>> +/// use kernel::sync::Arc;
>> +///
>> +/// struct MyStruct {
>> +///     work_field: Work<Arc<MyStruct>>,
>> +/// }
>> +///
>> +/// impl_has_work! {
>> +///     impl HasWork<Arc<MyStruct>> for MyStruct { self.work_field }
>> +/// }
>> +/// ```
>> +///
>> +/// [`HasWork<T>`]: HasWork
>> +#[macro_export]
>> +macro_rules! impl_has_work {
>> +    ($(impl$(<$($implarg:ident),*>)?
>> +       HasWork<$work_type:ty>
>> +       for $self:ident $(<$($selfarg:ident),*>)?
>> +       { self.$field:ident }
>> +    )*) => {$(
>> +        // SAFETY: The implementation of `raw_get_work` only compiles if the field has the right
>> +        // type.
>> +        unsafe impl$(<$($implarg),*>)? $crate::workqueue::HasWork<$work_type> for $self $(<$($selfarg),*>)? {
>> +            const OFFSET: usize = $crate::offset_of!(Self, $field) as usize;
>> +
>> +            #[inline]
>> +            unsafe fn raw_get_work(ptr: *mut Self) -> *mut $crate::workqueue::Work<$work_type> {
>> +                // SAFETY: The caller promises that the pointer is not dangling.
>> +                unsafe {
>> +                    ::core::ptr::addr_of_mut!((*ptr).$field)
>> +                }
>> +            }
> 
> What is the reason for overriding the default implementation of `raw_get_work()`?
> 
> BR Andreas

That's how the macro checks that the field actually has the type you
claim it has. If you lie about the type, then `raw_get_work` will not
compile. (See the safety comment on the impl block.)

Alice
