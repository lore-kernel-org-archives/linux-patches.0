Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1520E4A840
	for <patches@lists.linux.dev>; Tue, 23 May 2023 11:59:59 +0000 (UTC)
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-510d1972d5aso1237077a12.0
        for <patches@lists.linux.dev>; Tue, 23 May 2023 04:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaspace-dk.20221208.gappssmtp.com; s=20221208; t=1684843198; x=1687435198;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=BtyIsC3fOFjgjr9w9nc1ft0SzM61Czn4H/P3GjzNfK0=;
        b=bdm9uKxSj9wOh8IC4/CRZXk1vTYZPuOEBSXUGk5gfmyUqA04txmm/wMX2tbxYblfo/
         VgGFH28rswMT6qcXru0NTDMd968EfXKd0RfJdqHc/niQ8AwLwed+fZaXNUznLagqZbwg
         7tkhI27bpz4eiIwUfdiHFO7uQifd5MbaSz6e0ibXSTApTSa8NBTDHQJHgCUk2DVTyQI/
         Bhwvb2prpfZ4YmRqKJmCGC0JRIo/MNzR+lj4ezo0xkoA8HG7md65l3yse6l799w04aVm
         h2fzstPqo2J+mX+CjAoPnNAa3iTwdk9btrQ7CiKMUKWCHnTiA+7U7+ALOmn5KW3ty3Y2
         3ZuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684843198; x=1687435198;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BtyIsC3fOFjgjr9w9nc1ft0SzM61Czn4H/P3GjzNfK0=;
        b=MJsmS7McjhNZqXZ0Z8sxXVOQk+a0cLD0/ZgW5/lJDpTmHcuWG8WeD9Re/il1jN5IPy
         U6M9TMZXTcLdz5uye4Te+j0ZNSTvx4HmFSPDeYS9yoNsc3sQ6GVd7pFkOq66RP7i+xHY
         21TMZ4VG7AleM07XAHxT66ueqDHr5umYa5s9DmuREQZKhM2VDgYEt4VdRwPPbJljRl1y
         TEBKuRhXoXWWFMivPr3OUfZx7DvDEB3QNPG2m/XHH6x8vLwVa65+wJClBR+0QQKZmLXa
         +bZOt+w0q2aro6/+ViXmTFLDaFsT0eapNRhUbgaQCmecY52K6kiot6nIuL9vjZQsowxB
         paSg==
X-Gm-Message-State: AC+VfDz9nMz8lg2h/q7GZAABf1b6+nmn2iyDQR9HaYmt+DXExJ64K3W6
	FitaNGCpT3GB5b5Dnt83CGBcIw==
X-Google-Smtp-Source: ACHHUZ78ha/V35x6+xkN2GHd8k3K5a4kK220qp3eEHQVCjxYr6dtznddiQJKp5S0VuxPspRGsy9W9A==
X-Received: by 2002:a17:907:91cd:b0:96a:937c:5608 with SMTP id h13-20020a17090791cd00b0096a937c5608mr9052699ejz.53.1684843198168;
        Tue, 23 May 2023 04:59:58 -0700 (PDT)
Received: from localhost ([79.142.230.34])
        by smtp.gmail.com with ESMTPSA id h26-20020a17090634da00b0096f7e7d1566sm4318582ejb.224.2023.05.23.04.59.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 04:59:57 -0700 (PDT)
References: <20230517200814.3157916-1-aliceryhl@google.com>
User-agent: mu4e 1.10.3; emacs 28.2.50
From: Andreas Hindborg <nmi@metaspace.dk>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho
 <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng
 <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?=
 Roy Baron
 <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, Will
 Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Mark
 Rutland <mark.rutland@arm.com>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev, Wedson Almeida
 Filho <walmeida@microsoft.com>
Subject: Re: [PATCH v1 1/2] rust: sync: add `Arc::ptr_eq`
Date: Tue, 23 May 2023 13:54:19 +0200
In-reply-to: <20230517200814.3157916-1-aliceryhl@google.com>
Message-ID: <87353nfebm.fsf@metaspace.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


Alice Ryhl <aliceryhl@google.com> writes:

> Add a method for comparing whether two `Arc` pointers reference the same
> underlying object.
>
> This comparison can already be done by getting a reference to the inner
> values and comparing whether the references have the same address.
> However, writing `Arc::ptr_eq(a, b)` is generally less error-prone than
> doing the same check on the references, since you might otherwise
> accidentally compare the two `&Arc<T>` references instead, which wont
> work because those are pointers to pointers to the inner value, when you
> just want to compare the pointers to the inner value.
>
> Also, this method might optimize better because getting a reference to
> the inner value involves offsetting the pointer, which this method does
> not need to do.
>
> Co-developed-by: Wedson Almeida Filho <walmeida@microsoft.com>
> Signed-off-by: Wedson Almeida Filho <walmeida@microsoft.com>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>

Reviewed-by: Andreas Hindborg <a.hindborg@samsung.com>

> ---
>  rust/kernel/sync/arc.rs | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/rust/kernel/sync/arc.rs b/rust/kernel/sync/arc.rs
> index e6d206242465..274febe3bb06 100644
> --- a/rust/kernel/sync/arc.rs
> +++ b/rust/kernel/sync/arc.rs
> @@ -221,6 +221,11 @@ impl<T: ?Sized> Arc<T> {
>          // reference can be created.
>          unsafe { ArcBorrow::new(self.ptr) }
>      }
> +
> +    /// Compare whether two [`Arc`] pointers reference the same underlying object.
> +    pub fn ptr_eq(this: &Self, other: &Self) -> bool {
> +        core::ptr::eq(this.ptr.as_ptr(), other.ptr.as_ptr())
> +    }
>  }
>  
>  impl<T: 'static> ForeignOwnable for Arc<T> {
>
> base-commit: ac9a78681b921877518763ba0e89202254349d1b

