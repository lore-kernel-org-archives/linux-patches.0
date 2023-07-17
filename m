Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39FE7BA24
	for <patches@lists.linux.dev>; Mon, 17 Jul 2023 13:47:43 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-57704aa6c69so40266367b3.0
        for <patches@lists.linux.dev>; Mon, 17 Jul 2023 06:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689601663; x=1690206463;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=j3SxyETf8ddszKx/ZhEs13N7fJ1p21U4RjlqamH3wRM=;
        b=Ps+rAGyMV9qWxjfyp3bnC4WvVcq8X5T25dqQ025faVPUbZWlN2fAoDNDfXAcv0qXQO
         2rVh/F+CEbd9tCHAujfRsQGuKMmSyiBZjs2eOW67e3+9f8kDZtdM0UP/nRbGDOfC8bXs
         17XAdkMOpYNQtBfbzsnCgX9mGrtMoO6Ou2sMGzQtb3EsgH06Xpaq6QVx4+eIMb+N/843
         gPnkEHOnUVw6yoiaH8h0F3c8OwlT5WkmTQDkb9f7s3mPN7IWIFg75VFKueOM6dFG5j+J
         gv/odE6hDve5rsonG898yH44kzvxYYypt00MA0hqgIFkexFHlypO+5r2oufxg9SMk6+U
         ydMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689601663; x=1690206463;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j3SxyETf8ddszKx/ZhEs13N7fJ1p21U4RjlqamH3wRM=;
        b=IZRVLd5C60cpdUtMf/VkVTmzlAQZS/W56gGGNooUJzHk3wV0YJqWfKlfQbG0+PU8R+
         IIeuIbsNyZD1G6eVxbfC0ikWZHEZoLOZerTngdXrJO3f++8IBhq5Ltpo0OUyi4hlFeps
         HgdC73VecKv63TYIG0azGeMoMlr25bLImDKS2ztgiT5Hp0F03ut7gaIiwwalt6dMTfqV
         QjFgZBRu9sJqasboSFEN/g5MNk8VhBelLEV+rIQKx13oJMQUAc1/UlBNm19DHiF80Wjz
         D3UmEgAFX7ECA/boPH3+j0IvnUFmCZJQe9uJ+iujK7aXaIUrHouCAP7wAoXxVuIaymNS
         DNQg==
X-Gm-Message-State: ABy/qLaihBKCFfcO+5BuStvGAohz6vz4y8othv0KHm8zkTpBO07MufIz
	VkIlj/mILQrn+V19PxyhdpQAamU3bMENdkc=
X-Google-Smtp-Source: APBJJlEwhdE5N/SzORH8cVNDBC2/w2CMWD9t0WmrCmMaq52fjxnqtqHEqHMehOn8c5v5sI2WIAd0lhlO7YkmMnA=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a81:bc14:0:b0:565:9e73:f937 with SMTP id
 a20-20020a81bc14000000b005659e73f937mr153880ywi.4.1689601662979; Mon, 17 Jul
 2023 06:47:42 -0700 (PDT)
Date: Mon, 17 Jul 2023 13:47:40 +0000
In-Reply-To: <CUqkSCKfZbSOwonbc1HECGB3ah_8k404uGJFaebLi2oD8GScDzqRxZ350YdmljslxqUC4mqdvqpbBhD1wFSmCvpA4MhklUGnN6RB0Y8YlFo=@proton.me>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <CUqkSCKfZbSOwonbc1HECGB3ah_8k404uGJFaebLi2oD8GScDzqRxZ350YdmljslxqUC4mqdvqpbBhD1wFSmCvpA4MhklUGnN6RB0Y8YlFo=@proton.me>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230717134740.1840206-1-aliceryhl@google.com>
Subject: Re: [PATCH v3 2/9] rust: sync: add `Arc::{from_raw, into_raw}`
From: Alice Ryhl <aliceryhl@google.com>
To: benno.lossin@proton.me
Cc: alex.gaynor@gmail.com, aliceryhl@google.com, bjorn3_gh@protonmail.com, 
	boqun.feng@gmail.com, gary@garyguo.net, jiangshanlai@gmail.com, 
	linux-kernel@vger.kernel.org, ojeda@kernel.org, patches@lists.linux.dev, 
	rust-for-linux@vger.kernel.org, tj@kernel.org, walmeida@microsoft.com, 
	wedsonaf@gmail.com
Content-Type: text/plain; charset="UTF-8"

Benno Lossin <benno.lossin@proton.me> writes:
>> +    /// This code relies on the `repr(C)` layout of structs as described in
>> +    /// <https://doc.rust-lang.org/reference/type-layout.html#reprc-structs>.
> 
> Why is this in the documentation? I feel like it should be a normal code
> comment at the very start of the function.

In fact, I think we can drop this comment entirely. The motivation
behind using `Layout::extend` for computing `val_offset` is that its
correctness does not rely on how the repr(C) layout algorithm works.

(As opposed to how the previous implementation's correctness *does*
depend on knowing the repr(C) layout algorithm:
    Layout::new::<ArcInner<()>>().align_to(align).unwrap().pad_to_align().size()
)

>> +    ///
>> +    /// # Safety
>> +    ///
>> +    /// `ptr` must have been returned by a previous call to [`Arc::into_raw`]. Additionally, it
>> +    /// can only be called once for each previous call to [`Arc::into_raw`].
> 
> "it can only" -> "it must only"

Sounds good. I'll change it to use "must" in the next version.

Alice

