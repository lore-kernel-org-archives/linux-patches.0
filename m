Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702A31FB1
	for <patches@lists.linux.dev>; Wed, 24 May 2023 11:19:17 +0000 (UTC)
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-96f9aa23593so75079766b.1
        for <patches@lists.linux.dev>; Wed, 24 May 2023 04:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684927155; x=1687519155;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aSqeOEBaEovgqBOkQYpmiRbcLkCrvNP3WDOQXeuFBws=;
        b=YoTFNVu3BuXhD7O32uXMB2r5DmhBVaFcVMJtr/toOkSxoubHnULS6xAfeW2LnVMAlA
         AYEz2fGtxM3pIYSUnBK97NJj/BDHWhtjg5xXo1E0oD7tUbhsEX3CXPVlILQkcaRPv0ZD
         yjgEMiuiRLnKN6CsU3p9hbhjzB/iYU4uM2KkitkPUbglYVCC8SJ0awVM+Jd6nWLQuc/G
         ndgHixe0rgEmKz+2d++PnHjmKN8G+3JZbxp5NfqtrsOioY71sLNZHgs1D1AtBEUVenMn
         e3E2RvzhRBeZ9qYmqs3ZsfOY5VINcozwl6tDQaiEl1bE2crSn7TsrUNBfRLuLVdhuSpT
         1BoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684927155; x=1687519155;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aSqeOEBaEovgqBOkQYpmiRbcLkCrvNP3WDOQXeuFBws=;
        b=VysZNbLGZfKRtwBDlk5SwAmUd93hMvUrlrd8z4oOx2LTXIk3Kmw2mcekWj3Lk+7RKi
         i6BM+pWNSSWOIgCul40eGtNssDjS6IDYLm5Tbx4mJIUoR1RuaVzL/4OxRu/MZih4ysCN
         mZxgK7WD9y8jvzAMH+339Nv6F8I+5nXd83xLgt5bTU4F6Zxe+z8PmFKRLUNGVjuDb5jr
         fIm5MrDQwabg13JgF4yjJku/u6Vs34SFtEJxfbJbtsgknSEUasulVnr/90ZEkwLzezQo
         v+NjssLQAPZpDXdNouA/LpBM3UfRjLkCg2msTZrVc6ZWhdhX/k3ji0nG2wJ9z/TiPMkC
         tneg==
X-Gm-Message-State: AC+VfDygs+F5kOETLh/dx+2FBGf8RfZmQsD0V5J5HuDvCkrfTdsUxfXh
	PWndFKTMPvg/8hr/RFX6cWVZrfA1QpDyheQ=
X-Google-Smtp-Source: ACHHUZ6hBDSsE8W54k3/04J7zLascPTlRf9I3nXEziDRNwk18BCOFdKa7mvtqXoJNKmy27weSOFwZUV7ytfiAEg=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a17:906:5a67:b0:96f:5864:eb6c with SMTP
 id my39-20020a1709065a6700b0096f5864eb6cmr6435514ejc.6.1684927155703; Wed, 24
 May 2023 04:19:15 -0700 (PDT)
Date: Wed, 24 May 2023 11:19:13 +0000
In-Reply-To: <20230523164333.2c4b0d85.gary@garyguo.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230523164333.2c4b0d85.gary@garyguo.net>
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
Message-ID: <20230524111913.2492665-1-aliceryhl@google.com>
Subject: Re: [PATCH v1 3/7] rust: sync: add `Arc::{from_raw, into_raw}`
From: Alice Ryhl <aliceryhl@google.com>
To: gary@garyguo.net
Cc: alex.gaynor@gmail.com, aliceryhl@google.com, benno.lossin@proton.me, 
	bjorn3_gh@protonmail.com, boqun.feng@gmail.com, jiangshanlai@gmail.com, 
	linux-kernel@vger.kernel.org, ojeda@kernel.org, patches@lists.linux.dev, 
	rust-for-linux@vger.kernel.org, tj@kernel.org, wedsonaf@gmail.com
Content-Type: text/plain; charset="UTF-8"

Gary Guo <gary@garyguo.net> writes:
> On Wed, 17 May 2023 20:31:15 +0000
> Alice Ryhl <aliceryhl@google.com> wrote:
>> +    /// Recreates an [`Arc`] instance previously deconstructed via [`Arc::into_raw`].
>> +    ///
>> +    /// This code relies on the `repr(C)` layout of structs as described in
>> +    /// <https://doc.rust-lang.org/reference/type-layout.html#reprc-structs>.
>> +    ///
>> +    /// # Safety
>> +    ///
>> +    /// `ptr` must have been returned by a previous call to [`Arc::into_raw`]. Additionally, it
>> +    /// can only be called once for each previous call to [`Arc::into_raw`].
>> +    pub unsafe fn from_raw(ptr: *const T) -> Self {
>> +        // SAFETY: The safety requirement ensures that the pointer is valid.
>> +        let val_align = core::mem::align_of_val(unsafe { &*ptr });
>> +        let refcount_size = core::mem::size_of::<Opaque<bindings::refcount_t>>();
>> +
>> +        // Use the `repr(C)` algorithm to compute the offset of `data` in `ArcInner`.
>> +        //
>> +        // Pseudo-code for the `#[repr(C)]` algorithm can be found here:
>> +        // <https://doc.rust-lang.org/reference/type-layout.html#reprc-structs>
>> +        let mut val_offset = refcount_size;
>> +        let val_misalign = val_offset % val_align;
>> +        if val_misalign > 0 {
>> +            val_offset += val_align - val_misalign;
>> +        }
> 
> Given the layout of the whole ArcInner can be calculated as
> 
> 	Layout::new::<bindings::refcount_t>().extend(Layout::for_value(&*ptr)).unwrap_unchecked().0.pad_to_align()
> 
> The offset of `data` could be more intuitively calculated by
> 
> 	Layout::new::<bindings::refcount_t>().extend(Layout::for_value(&*ptr)).unwrap_unchecked().1
> 
> or
> 
> 	Layout::new::<bindings::refcount_t>().align_to(val_align).unwrap_unchecked().pad_to_align().size()

I'm not a big fan of the `pad_to_align` version (which is also what
the rust branch uses), but I like the version you posted with
`extend`, and I agree that it is clear and intuitive. I will use that
in the next version of the patchset. Thanks for the suggestion.

Alice
