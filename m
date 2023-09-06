Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF46E1C3A
	for <patches@lists.linux.dev>; Wed,  6 Sep 2023 09:57:02 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-59263889eacso36971257b3.3
        for <patches@lists.linux.dev>; Wed, 06 Sep 2023 02:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693994221; x=1694599021; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=S6U/bZx3CCZkDt+9hB5fA1eaCfzNi7bkJC7f529EWkw=;
        b=SOIlaQNJe2Yl3BbK5Kw0BCPZFupruW+yExUTCQr944Qoan/Nh0A75HLm0cS5T6v3hL
         +tpN0Uzdi3pC7cI/2I2h8UG5R0m++pKS5N7FkeCQgbzvO1opiMnZH3O9/LEBcYMsjO6p
         Ito3BuFfB6kfwFyS+4QUQUVIXbWDohLfqTMz8SOW8oMXPd1gWWQOC/4GY5VBSeVBG4Gz
         z0nOoj6RAt875PErQG6cp8YfAEp7jGkHa97ur9mE0M10ITF34vROT6CQMoEpSBCoXw3P
         FSS89A8lYAYGxYwHDhpo+LLPfVQWFgJ0htVoIC4l1VikcWSWZQKZ53a/QQWM5iteno9O
         lxhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693994221; x=1694599021;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S6U/bZx3CCZkDt+9hB5fA1eaCfzNi7bkJC7f529EWkw=;
        b=enhuYgwU+wi48eULUvaqDthPFItSjSIPuk4GITcP44R7E2KKOVDjXBP0C83m7yn8fb
         7hPzhABl8hY3IORGadLprmXt2ktrao9zaw4OaydGE8qTNNJgPRADQ+nBVaDoae7XT+un
         zJTUModczBrhrOueVAuTyxKFRjjaRtetnh40+BK76eklr+uqSZuj1Uy9VoJtUg8Ym7ws
         oWLUtIQAsvv6f9A/FIjXXcn8yJAKp/kAeHP/o5g/jYq3COrcA0QuCmBAocDd1PKDqMa+
         2VkhJntumV66tXPh9ewKNiU5IcDQmuRxZUSI+Vek9icGQnbORcR5Y7QgBm5ZdW+xRqzu
         VaDQ==
X-Gm-Message-State: AOJu0YzrxFa9fQPj+Wf/tgeKOWb5xW6DBY98FrQHtqP2l1ZaGICGRFrf
	EwTM+LMzKfk1D50Mowbu44BgwRTHsdI1/Qg=
X-Google-Smtp-Source: AGHT+IGtrKPNRYI3AhoixLmlwImfM2X/hdnQadWPxqOqcdFIZ2UCfmxKsJFXaNdIbjrF+J7e1IOSJ4uKQ9IdQe4=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a81:ca51:0:b0:58c:b5a4:8e1f with SMTP id
 y17-20020a81ca51000000b0058cb5a48e1fmr421736ywk.3.1693994221613; Wed, 06 Sep
 2023 02:57:01 -0700 (PDT)
Date: Wed,  6 Sep 2023 09:56:59 +0000
In-Reply-To: <ESFnxZLcZD-JbNp5PHtrjAdophrPm9gOJR1C5kwsvw6errySiqsG7zbs-0bKWKGrq3Phz7-of0M1znwoTNYAZATTHBhUaFehe5bHP1YksCw=@proton.me>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <ESFnxZLcZD-JbNp5PHtrjAdophrPm9gOJR1C5kwsvw6errySiqsG7zbs-0bKWKGrq3Phz7-of0M1znwoTNYAZATTHBhUaFehe5bHP1YksCw=@proton.me>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230906095659.906257-1-aliceryhl@google.com>
Subject: Re: [PATCH v4 4/7] rust: workqueue: add helper for defining
 work_struct fields
From: Alice Ryhl <aliceryhl@google.com>
To: benno.lossin@proton.me
Cc: alex.gaynor@gmail.com, aliceryhl@google.com, bjorn3_gh@protonmail.com, 
	boqun.feng@gmail.com, gary@garyguo.net, jiangshanlai@gmail.com, 
	linux-kernel@vger.kernel.org, ojeda@kernel.org, patches@lists.linux.dev, 
	rust-for-linux@vger.kernel.org, tj@kernel.org, wedsonaf@gmail.com
Content-Type: text/plain; charset="utf-8"

Benno Lossin <benno.lossin@proton.me> writes:
>> +impl<T: ?Sized, const ID: u64> Work<T, ID> {
>> +    /// Creates a new instance of [`Work`].
>> +    #[inline]
>> +    #[allow(clippy::new_ret_no_self)]
>> +    pub fn new(name: &'static CStr, key: &'static LockClassKey) -> impl PinInit<Self>
>> +    where
>> +        T: WorkItem<ID>,
>> +    {
>> +        // SAFETY: The `WorkItemPointer` implementation promises that `run` can be used as the work
>> +        // item function.
>> +        unsafe {
>> +            kernel::init::pin_init_from_closure(move |slot| {
>> +                let slot = Self::raw_get(slot);
>> +                bindings::init_work_with_key(
>> +                    slot,
>> +                    Some(T::Pointer::run),
>> +                    false,
>> +                    name.as_char_ptr(),
>> +                    key.as_ptr(),
>> +                );
>> +                Ok(())
>> +            })
>> +        }
> 
> I would suggest this instead:
> ```
>         pin_init!(Self {
>             // SAFETY: The `WorkItemPointer` implementation promises that `run` can be used as the
>             // work item function.
>             work <- Opaque::ffi_init(|slot| unsafe {
>                 bindings::init_work_with_key(
>                     slot,
>                     Some(T::Pointer::run),
>                     false,
>                     name.as_char_ptr(),
>                     key.as_ptr(),
>                 )
>             }),
>             _inner: PhantomData,
>         })
> ```

I thought that I changed this in this patchset ...

Anyway, I don't think it's a big deal. If I need to send a v5 for some
other reason, then I will fix this there. Otherwise, I don't think it's
necessary to send a v5 just for this.

Alice
