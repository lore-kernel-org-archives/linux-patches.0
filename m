Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5268D7E1
	for <patches@lists.linux.dev>; Wed, 31 May 2023 09:08:02 +0000 (UTC)
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-95847b4b4e7so574810066b.3
        for <patches@lists.linux.dev>; Wed, 31 May 2023 02:08:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685524080; x=1688116080;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=h4XB69pI7oS1KTwJ1Q82+CkziVn4Zul+krCxNc20lxY=;
        b=hF5rhGXPOOd8eZdQQ3DNkBzapxJtKf68EiAo1a9IPWpXaz7OSTkyCGpwOoBmhtq444
         Edz0OVUOK2gCHE/qi5uSIDR+CfACSpofs3x7IPacH+5ka1Re4i5bYKMFCatM9wFkNQCR
         Kynv+nF73kgFpbzeZIT0fCY5WE7tXNEeMjTCQ2/oMNfLncKxNwr3tD+Rozz0gncc5H81
         L5MJaSrp0rJcoKjbIO4eQ5ZASfjN/sj5umJekwonfsGtrcZ+B7OpWx53w20tpFUp2C9L
         aWsG1eCu1roXKzUnkjDzPDLMcmI4nnBA7iBxTXLQ/oHhQvaExejAwggwLNG5S0tLKbJT
         o0xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685524080; x=1688116080;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h4XB69pI7oS1KTwJ1Q82+CkziVn4Zul+krCxNc20lxY=;
        b=i9SFaKaRU0uLY11WXAlMf9FGmg0ObHFxHhQ/VdehCL65xyuIWQBK+QtYAuBH6Nljb0
         0KbA97k7foQ+gav9DXfYShyoN0I3PuVSVvAXSlvR+qslfHoTnLZ+Pmie/l08hPdsOY67
         +GROnIhkvPxxi6BvfqcWpkfKQqWlCZATFjVqSHSfG+H4xVJovbrwN2sFRY28YmwZ0xWQ
         L+/X4+9bwew3UJW8QR97HX9sJpNzw2zOcRz7cf6nmHvEA0PZyMk8C/yRpUSwkfxMz0m0
         3UXjf3nPwgJ3yhcu+aZSfA4Qc9FNZxu963YUhIkGrSYgVT4yEfHES0jlVOl0tTLsj9sa
         M5OQ==
X-Gm-Message-State: AC+VfDwtWPpK4EtNmqVLdYnR5SoN1v2cf+3Bl5aTispD5qpwxlNQtYMu
	f1FNcoxbE8Ce/sIjfX9jZdy0+pJuBWT1LvY=
X-Google-Smtp-Source: ACHHUZ4jHWsOMdaL8fTbPxhKkMfcS5HXhNuYYha/28gUrN+9T6dw86HDPz24GnWXSS15B+jt4XcRCMsHnSQQxsk=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a17:907:75c6:b0:96f:4226:56d with SMTP
 id jl6-20020a17090775c600b0096f4226056dmr1253514ejc.6.1685524080625; Wed, 31
 May 2023 02:08:00 -0700 (PDT)
Date: Wed, 31 May 2023 09:07:58 +0000
In-Reply-To: <ZWC2OS5uiRNgHMBBzQqt4FZXnOBeHw5IK5D7CAqfNC-z6nfYVLS9jXgvP2cMFvIMtVG22OGlmRGR9RkUJ53lip-SPiEkTHEiBoxMoL-K_38=@proton.me>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <ZWC2OS5uiRNgHMBBzQqt4FZXnOBeHw5IK5D7CAqfNC-z6nfYVLS9jXgvP2cMFvIMtVG22OGlmRGR9RkUJ53lip-SPiEkTHEiBoxMoL-K_38=@proton.me>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230531090758.3668499-1-aliceryhl@google.com>
Subject: Re: [PATCH v1 6/7] rust: workqueue: add safe API to workqueue
From: Alice Ryhl <aliceryhl@google.com>
To: benno.lossin@proton.me
Cc: alex.gaynor@gmail.com, aliceryhl@google.com, bjorn3_gh@protonmail.com, 
	boqun.feng@gmail.com, gary@garyguo.net, jiangshanlai@gmail.com, 
	linux-kernel@vger.kernel.org, ojeda@kernel.org, patches@lists.linux.dev, 
	rust-for-linux@vger.kernel.org, tj@kernel.org, wedsonaf@gmail.com
Content-Type: text/plain; charset="UTF-8"

Benno Lossin <benno.lossin@proton.me> writes:
> On Wednesday, May 17th, 2023 at 22:31, Alice Ryhl <aliceryhl@google.com> wrote:
>> +macro_rules! define_work_adapter_newtype {
>> +    (
>> +        $(#[$outer:meta])*
>> +        $pub:vis struct $name:ident(
>> +            $(#[$innermeta:meta])*
>> +            $fpub:vis Arc<$inner:ty> $(,)?
>> +        );
>> +        $($rest:tt)*
>> +    ) => {
>> +        $(#[$outer])*
>> +        $pub struct $name($(#[$innermeta])* $fpub $crate::sync::Arc<$inner>);
> 
> I am a bit confused as to why these types *contain* a pointer. Shouldn't
> these be exactly the same `Work<$inner>`, except they allow multiple `run`
> functions? So IMO they should embed a `Work<$inner>` and the
> manually defined `run` function would take a `$inner`.

No, that's not how this particular patch was designed. With the design I
used, the way you tell `enqueue` which `work_struct` field you want to
use is by using a different pointer type for each `work_struct` field.
This macro defines those pointer types.

So, for example, if you have only one `work_struct` field, then you just
use `Arc<MyStruct>` as your pointer type, and the field has type
`Work<Arc<MyStruct>>`.

On the other hand, if you have two `work_struct` fields, then you
instead use the macro to define `MyPointerType1` and `MyPoinerType2`
that both wrap an `Arc<MyStruct>`, and the fields then have types
`Work<MyPointerType1>` and `Work<MyPointerType2>`.

Alice
