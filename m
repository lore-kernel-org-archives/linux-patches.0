Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42DAC4A840
	for <patches@lists.linux.dev>; Tue, 23 May 2023 11:07:12 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-babb51cb4d4so6170148276.1
        for <patches@lists.linux.dev>; Tue, 23 May 2023 04:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684840031; x=1687432031;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2XgBvS7Dq5efKHkw7EY0MhJdVq0k/8wvd67gGiWjjGY=;
        b=I2NuidGBI/ZeU95AgQL5cjDLDKnFCRQhwK80Fgf6TjZTKTEC8DC+X9iSKW1+OGmbCQ
         tbEmvSculz37Vxh4nZ+cGSlHBgBO+BNMCsFePd5i1XJRDStdsKgK2UhycHnP+uIjq3W+
         BGyXzdow/jD99f7ks6jbRs3YPyEn9XKtXB5BCAq7dsIV69FSVOllw9B/Z6WxozOHMNKv
         t1K98BdYWNjYgpKjmlUphUPoSDarlKaAZqPfv1Cr5pG2PTQYcqrpkj/yspAUFjppThcr
         dyxC630dpbZ2K0/yAlqfREb9rNAl58QGE6cRxvMiBJbtqW6UqM/Prd0ERjsPmpm5adrD
         Queg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684840031; x=1687432031;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2XgBvS7Dq5efKHkw7EY0MhJdVq0k/8wvd67gGiWjjGY=;
        b=IJyIKVZWtQesr97edPl8v4zFpWhjX/xc/EVowh0JO4Wn6yh+zn43CVXeRUKzO8JNGh
         pk8YcpK0J3zkmN0KpRIb3cWHs7gg1VsOcKscz4XX4Ekuyw9cn+yT+i8tRSBKF7xhw0lC
         7QXvvak0j2jZ/mF6eCEvCNfejoV/VH6zpBgS2XYrW1bQlj3BBnM8E4+3HTC0L+DZHAsQ
         gvfH9JqfQ8gs58DSjAypu8ITCSGpNU4btBSf4d07yYKZ5wX4n8QAHPaNFC0qkJkOU6Qd
         AWAG4+sXmbfB8omuOE62SL3AHzieUaQ0Oy3CNd9XYbicTTOLdSZNmuqW71E35ZR2IjPJ
         8YJw==
X-Gm-Message-State: AC+VfDwKG2vZVXWaJZFbB5FC5bUzoZ9ooLFRh1TEnyW8yLt7cw+HQgAF
	FS55vLZDH20rLECzrAUFVAjqgA0n89xf59E=
X-Google-Smtp-Source: ACHHUZ5fQNzXetN18AMOrqlYgjbM0rPXw1HVQJvrLv1Yjb1M1/QRmptg+hoYr/BXIrxgTx0GNavoIajsv9nwQ0I=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a25:d48e:0:b0:ba8:9653:c948 with SMTP id
 m136-20020a25d48e000000b00ba89653c948mr5747400ybf.3.1684840031253; Tue, 23
 May 2023 04:07:11 -0700 (PDT)
Date: Tue, 23 May 2023 11:07:09 +0000
In-Reply-To: <b54801cd-1afb-2190-3b8a-4a095d04fdff@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <b54801cd-1afb-2190-3b8a-4a095d04fdff@gmail.com>
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
Message-ID: <20230523110709.4077557-1-aliceryhl@google.com>
Subject: Re: [PATCH v1 6/7] rust: workqueue: add safe API to workqueue
From: Alice Ryhl <aliceryhl@google.com>
To: yakoyoku@gmail.com
Cc: alex.gaynor@gmail.com, aliceryhl@google.com, benno.lossin@proton.me, 
	bjorn3_gh@protonmail.com, boqun.feng@gmail.com, gary@garyguo.net, 
	jiangshanlai@gmail.com, linux-kernel@vger.kernel.org, ojeda@kernel.org, 
	patches@lists.linux.dev, rust-for-linux@vger.kernel.org, tj@kernel.org, 
	wedsonaf@gmail.com
Content-Type: text/plain; charset="UTF-8"

On 5/18/23 21:17, Martin Rodriguez Reboredo wrote:
> On 5/17/23 17:31, Alice Ryhl wrote:
>> +unsafe impl<T> WorkItem for Arc<T>
>> +where
>> +    T: ArcWorkItem + HasWork<Self> + ?Sized,
>> +{
>> +    type EnqueueOutput = Result<(), Self>;
>> +
>> +    unsafe fn __enqueue<F>(self, queue_work_on: F) -> Self::EnqueueOutput
>> +    where
>> +        F: FnOnce(*mut bindings::work_struct) -> bool,
>> +    {
>> +        let ptr = Arc::into_raw(self);
>> +
>> +        // Using `get_work_offset` here for object-safety.
>> +        //
>> +        // SAFETY: The pointer is valid since we just got it from `into_raw`.
>> +        let off = unsafe { (&*ptr).get_work_offset() };
>> +
>> +        // SAFETY: The `HasWork` impl promises that this offset gives us a field of type
>> +        // `Work<Self>` in the same allocation.
>> +        let work_ptr = unsafe { (ptr as *const u8).add(off) as *const Work<Self> };
>> +        // SAFETY: The pointer is not dangling.
>> +        let work_ptr = unsafe { Work::raw_get(work_ptr) };
>> +
>> +        match (queue_work_on)(work_ptr) {
> 
> Match for boolean is not a good pattern in my eyes, if-else should be
> used instead.

I think this is a question of style. For a comparison:

match (queue_work_on)(work_ptr) {
    true => Ok(()),
    // SAFETY: The work queue has not taken ownership of the pointer.
    false => Err(unsafe { Arc::from_raw(ptr) }),
}

vs

if (queue_work_on)(work_ptr) {
    Ok(())
} else {
    // SAFETY: The work queue has not taken ownership of the pointer.
    Err(unsafe { Arc::from_raw(ptr) }),
}

I'm happy to change it if others disagree, but when the branches
evaluate to a short expression like they do here, I quite like the first
version.

> Also aren't the parens around the closure unnecessary?

Hmm, parenthesises are often required around closures, but it's possible
that it is only required for stuff like `self.closure(args)` to
disambiguate between a `closure` field (of pointer type) and a `closure`
method. I can check and remove them if they are not necessary.
