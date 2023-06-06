Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7648A7E4
	for <patches@lists.linux.dev>; Tue,  6 Jun 2023 23:37:58 +0000 (UTC)
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-75d5469c856so304366885a.2
        for <patches@lists.linux.dev>; Tue, 06 Jun 2023 16:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686094677; x=1688686677;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HFhBhTIzREHG9mACtwO9tRyPWU+4u6gN6/PkdzEJpag=;
        b=d77x79NsgBLTq06/VgrnLBA18mMJknfbUXrr8BhhI2XbWKK0dzqJBz6jeI7vB0upeP
         sKwQNSh6Ps6CqjjxsGRgsfbkakooZs+V8GFZeNf+gQZoXksuHxbOAMllHpf3iHEl2IO/
         v8CqEY99D46jjyyS/1VWxIVoy6EW71uRClKKED/q7v/oQW6RYgbvP5hSfO+QbCqKArzU
         z0T7B4ArSaaqShjjCTPYTH/MNa07lYUkmSqhytjrsm1nCkwcuyH/u5Wd09149+JvnF94
         iRrkB4GTqzmhX4P1k8KifMiD2Cg8sGLoaL3sUdX97vzG/IgtSCwGB0ZNa/MklTZaLICg
         EbKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686094677; x=1688686677;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HFhBhTIzREHG9mACtwO9tRyPWU+4u6gN6/PkdzEJpag=;
        b=F0NXkVu9JeiA+kR6am1jwsb5SAQ0bIH5GE/txPKVj5muzaQyh1R8kMG9GZ3dKKKEfh
         mAfPStTAOuI18NpAazYLXstA01rSB1SjdQBcnhhVA0qzTgqKn1e4DO+nJZOgScZ0qUM+
         YMlrh+530sHsq84g6/8qenXKXv/9Jw8sAkTlvKkswoiMjYIACxBP7xXsEIUBfVX8+O+D
         zVIJVCQPLBDLYX/ABbRmrPXpDFGZ9Dh6/PK/4LM5cx9knJKooflY5thmvn5IMkXOGnWw
         1JFyQSCd/NyVxwC+aMtfrKpGmXe2H+MzxETod25CTncnuhLRB3YEQU6qsjh04UK2GLCD
         jo4g==
X-Gm-Message-State: AC+VfDx377qnWfaAtQXeMIm3In3yvx3fKGih90So58kyJJBGP4799tC8
	k88TkZVUg9/wXHt2XLPKEmk=
X-Google-Smtp-Source: ACHHUZ4+Dpgv5vgO099EF2l/tWaCHrZtfxBMs8Ph0KvZ2JA0RvuUAModS84I6+1h0Uk6bj4bZOxRHA==
X-Received: by 2002:a05:620a:2221:b0:75b:23a1:367f with SMTP id n1-20020a05620a222100b0075b23a1367fmr137834qkh.64.1686094677149;
        Tue, 06 Jun 2023 16:37:57 -0700 (PDT)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id m10-20020ae9f20a000000b0075772c756e0sm5237129qkg.101.2023.06.06.16.37.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 16:37:56 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailauth.nyi.internal (Postfix) with ESMTP id 1970A27C0054;
	Tue,  6 Jun 2023 19:37:55 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 06 Jun 2023 19:37:56 -0400
X-ME-Sender: <xms:UsN_ZOcGJeHlqVPcJvE7x1Nfow7WPPDeV70cAPzLSJVggrWyCqNiQw>
    <xme:UsN_ZIOW4RetvFzgJmrpv6MUBSuQb81jbuQDRftBmsSZ-Ixv8xmJwOheHizp_aCOY
    Df6PaxGdTDpCox5MA>
X-ME-Received: <xmr:UsN_ZPgfayrHRKXbEeFo3F_nHGlmrc1sg6w-Cq0CnoVfePCX48CM2h18i-Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgedtvddgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehoqhhu
    nhcuhfgvnhhguceosghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmqeenucggtffrrg
    htthgvrhhnpeehudfgudffffetuedtvdehueevledvhfelleeivedtgeeuhfegueeviedu
    ffeivdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    gsohhquhhnodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdeiledvgeehtdei
    gedqudejjeekheehhedvqdgsohhquhhnrdhfvghngheppehgmhgrihhlrdgtohhmsehfih
    igmhgvrdhnrghmvg
X-ME-Proxy: <xmx:U8N_ZL_Y2Bu1QhknI37Sc89lkMnsHJDg6FOT76JiExlmhVXbwLK6Lg>
    <xmx:U8N_ZKunZ1wEKQWhC3mFMoj0og0QMPI8OPKMXQAtDEmcZ1BtTFunLA>
    <xmx:U8N_ZCGiUNXTHW5t_sLxfosfgwnO4sarjcrSrQj_AP-_Dr6v1tGP6Q>
    <xmx:U8N_ZCF_R-BE9s0l0uTdkE3kMErg8abKaM9wpC6fB4X27XiBFvPbMA>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 6 Jun 2023 19:37:54 -0400 (EDT)
Date: Tue, 6 Jun 2023 16:36:30 -0700
From: Boqun Feng <boqun.feng@gmail.com>
To: Alice Ryhl <aliceryhl@google.com>
Cc: rust-for-linux@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v2 1/8] rust: workqueue: add low-level workqueue bindings
Message-ID: <ZH/C/lKeYxM7tbYA@boqun-archlinux>
References: <20230601134946.3887870-1-aliceryhl@google.com>
 <20230601134946.3887870-2-aliceryhl@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230601134946.3887870-2-aliceryhl@google.com>

On Thu, Jun 01, 2023 at 01:49:39PM +0000, Alice Ryhl wrote:
[...]
> +/// A raw work item.
> +///
> +/// This is the low-level trait that is designed for being as general as possible.
> +///
> +/// The `ID` parameter to this trait exists so that a single type can provide multiple
> +/// implementations of this trait. For example, if a struct has multiple `work_struct` fields, then
> +/// you will implement this trait once for each field, using a different id for each field. The
> +/// actual value of the id is not important as long as you use different ids for different fields
> +/// of the same struct. (Fields of different structs need not use different ids.)
> +///
> +/// Note that the id is used only to select the right method to call during compilation. It wont be
> +/// part of the final executable.
> +///
> +/// # Safety
> +///
> +/// Implementers must ensure that any pointers passed to a `queue_work_on` closure by `__enqueue`
> +/// remain valid for the duration specified in the documentation for `__enqueue`.

^ better to say "the #Guarantees section in the documentation for
`__enqueue`"?

Regards,
Boqun

> +pub unsafe trait RawWorkItem<const ID: u64> {
> +    /// The return type of [`Queue::enqueue`].
> +    type EnqueueOutput;
> +
> +    /// Enqueues this work item on a queue using the provided `queue_work_on` method.
> +    ///
> +    /// # Guarantees
> +    ///
> +    /// If this method calls the provided closure, then the raw pointer is guaranteed to point at a
> +    /// valid `work_struct` for the duration of the call to the closure. If the closure returns
> +    /// true, then it is further guaranteed that the pointer remains valid until someone calls the
> +    /// function pointer stored in the `work_struct`.
> +    ///
> +    /// # Safety
> +    ///
> +    /// The provided closure may only return `false` if the `work_struct` is already in a workqueue.
> +    ///
> +    /// If the work item type is annotated with any lifetimes, then you must not call the function
> +    /// pointer after any such lifetime expires. (Never calling the function pointer is okay.)
> +    ///
> +    /// If the work item type is not [`Send`], then the function pointer must be called on the same
> +    /// thread as the call to `__enqueue`.
> +    unsafe fn __enqueue<F>(self, queue_work_on: F) -> Self::EnqueueOutput
> +    where
> +        F: FnOnce(*mut bindings::work_struct) -> bool;
> +}
> -- 
> 2.41.0.rc0.172.g3f132b7071-goog
> 
