Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D559F1C11
	for <patches@lists.linux.dev>; Wed, 31 May 2023 10:40:57 +0000 (UTC)
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-96fa4a6a79bso811846166b.3
        for <patches@lists.linux.dev>; Wed, 31 May 2023 03:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaspace-dk.20221208.gappssmtp.com; s=20221208; t=1685529655; x=1688121655;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
         :subject:cc:to:from:user-agent:references:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D9wK23t2sGNzjDkReOB3GT1QVBAdm3GmQJMkozq40P0=;
        b=AIu+b8G09ha8tBpJpcXJQCPeq0ed4+ggJKcW4dwZrO08fXZdQ2tw23V6SU1enf/pLe
         xz7/xU4WnxBkRiTFOQY9UCLBHxkOl1HE1FQp14w8Cb7OqtWtkqHxU47p2MWZTfI2rljF
         +mWsRulFmiOLUXs3IAEPomaoUPhs2XbihXDKeq1AlPIa3OBboQjHMM190lvIxiLU+Mur
         8q0igSTFZcpB+JYr1Jbrn+mKnOrrESw+GQZI21hx5lIF3gAFAk3QitJ81ceVFc+szrCF
         iR6Sqn5FZHQDvrZJEEMh4BDAEHMTi3Sen5rp4moPXJwgg0MXry5YG4eBhHEnI2SFicW7
         yCqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685529655; x=1688121655;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
         :subject:cc:to:from:user-agent:references:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=D9wK23t2sGNzjDkReOB3GT1QVBAdm3GmQJMkozq40P0=;
        b=N2+OgFAxlz/ZdNINfCU+/vJZ9xzIEGElcNF8yInuqduze94XB5FnyxyzTplQSpwYZP
         2qcxVzgGbRSIBc9fRcorZ04QvMWbqVKIKqmBlgmYHEwc9XFtwLmTXyGD8X6gGmxVxiVy
         aZtn8I+UYple9cp8WJG1jCBOiMHjjrOSi0eSdv3GAO+9EX/gbOOhaNbH+53Vsrr3/r/q
         iM3ELoE243BO7LVY6JVDFcVvCOiN/V67aFmesuTCbqZtMISDINjZAyBD4RPRt80A9u9K
         oNNGBgnBVwTjnV9enikcvTxQzLezbZ5PnX2Bng8uciohDljRaHq7C5YXMhtc0UZh+dwD
         SkNA==
X-Gm-Message-State: AC+VfDxCmvq+tQMi29UmcNyntFvObANlNeG5QfCTgKrCP4N6Pna05U68
	m52i3Cpgollo3KWBnW4aFa24Jw==
X-Google-Smtp-Source: ACHHUZ7gkn3xn/E4i2JfCKzoMtUX7uPofz9OD1IYCOir3fHI3gRcIYfxWM4KiKVknbBOQRkWmqzCmA==
X-Received: by 2002:a17:907:ea1:b0:957:48c8:b081 with SMTP id ho33-20020a1709070ea100b0095748c8b081mr4688011ejc.24.1685529655648;
        Wed, 31 May 2023 03:40:55 -0700 (PDT)
Received: from localhost ([79.142.230.34])
        by smtp.gmail.com with ESMTPSA id lh27-20020a170906f8db00b0096f03770be2sm8697953ejb.52.2023.05.31.03.40.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 03:40:55 -0700 (PDT)
References: <87leh69par.fsf@metaspace.dk>
 <20230531090032.3667467-1-aliceryhl@google.com>
User-agent: mu4e 1.10.3; emacs 28.2.50
From: Andreas Hindborg <nmi@metaspace.dk>
To: Alice Ryhl <aliceryhl@google.com>
Cc: alex.gaynor@gmail.com, benno.lossin@proton.me, bjorn3_gh@protonmail.com,
 boqun.feng@gmail.com, gary@garyguo.net, jiangshanlai@gmail.com,
 linux-kernel@vger.kernel.org, ojeda@kernel.org, patches@lists.linux.dev,
 rust-for-linux@vger.kernel.org, tj@kernel.org, wedsonaf@gmail.com
Subject: Re: [PATCH v1 5/7] rust: workqueue: add helper for defining
 work_struct fields
Date: Wed, 31 May 2023 12:18:47 +0200
In-reply-to: <20230531090032.3667467-1-aliceryhl@google.com>
Message-ID: <87zg5k3hs9.fsf@metaspace.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


Alice Ryhl <aliceryhl@google.com> writes:

> Andreas Hindborg <nmi@metaspace.dk> writes:
>> Alice Ryhl <aliceryhl@google.com> writes:
>>> +/// Used to safely implement the [`HasWork<T>`] trait.
>>> +///
>>> +/// # Examples
>>> +///
>>> +/// ```
>>> +/// use kernel::sync::Arc;
>>> +///
>>> +/// struct MyStruct {
>>> +///     work_field: Work<Arc<MyStruct>>,
>>> +/// }
>>> +///
>>> +/// impl_has_work! {
>>> +///     impl HasWork<Arc<MyStruct>> for MyStruct { self.work_field }
>>> +/// }
>>> +/// ```
>>> +///
>>> +/// [`HasWork<T>`]: HasWork
>>> +#[macro_export]
>>> +macro_rules! impl_has_work {
>>> +    ($(impl$(<$($implarg:ident),*>)?
>>> +       HasWork<$work_type:ty>
>>> +       for $self:ident $(<$($selfarg:ident),*>)?
>>> +       { self.$field:ident }
>>> +    )*) =3D> {$(
>>> +        // SAFETY: The implementation of `raw_get_work` only compiles =
if the field has the right
>>> +        // type.
>>> +        unsafe impl$(<$($implarg),*>)? $crate::workqueue::HasWork<$wor=
k_type> for $self $(<$($selfarg),*>)? {
>>> +            const OFFSET: usize =3D $crate::offset_of!(Self, $field) a=
s usize;
>>> +
>>> +            #[inline]
>>> +            unsafe fn raw_get_work(ptr: *mut Self) -> *mut $crate::wor=
kqueue::Work<$work_type> {
>>> +                // SAFETY: The caller promises that the pointer is not=
 dangling.
>>> +                unsafe {
>>> +                    ::core::ptr::addr_of_mut!((*ptr).$field)
>>> +                }
>>> +            }
>>=20
>> What is the reason for overriding the default implementation of `raw_get=
_work()`?
>>=20
>> BR Andreas
>
> That's how the macro checks that the field actually has the type you
> claim it has. If you lie about the type, then `raw_get_work` will not
> compile. (See the safety comment on the impl block.)

Got it =F0=9F=91=8D

I was thinking we could do the type check without redefining the method,
but that blows up complexity wise fast, since we need a trait to do it
to support `Self` in `$work_type`. It strikes me as a bit of a hack to
overwrite an otherwise fine implementation, but I guess it is the least
complex way.

Also I am a bit annoyed that we need to state the `$work_type` type at
all, since it is available in `work_field`. But I can see no way around
that.

BR Andreas
