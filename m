Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8855644E
	for <patches@lists.linux.dev>; Mon,  1 Apr 2024 22:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712010455; cv=none; b=ABQi7uyWodL4BiqIXatJPN+5amD0g5VWooVj87ZaFKOMbrdwgHNZ254pT9Qn+EgIRczXbwaPn0Lfrslin1HXUrJdLA3C/w2GTkSjqhdRmU2GOcVmAjQZ4HKfmXJaC8Y2C54f4U+rRW1jDNfrdtx0oeZhUmpXSXn8MOM6CC2iSOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712010455; c=relaxed/simple;
	bh=qd7DeB+UKGgiHHgmFI7NeiZR0UBVUqW1EUS3QsOSWAw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O7QraFwgqa3dAdL3G4M9E4odaQU+mOztY/WqhJtme0E6Gtuj2wEl4CBZJvc08AjZn8t9H9z+A1ke1DQjg8qk2c9hVomoTo5Em3Pd68IoXOj2RcRrMpsGVTh44hHMZmeRtPNLDqO6qx59bdNDyuzlCY0omgP4yRsMHow9IZvqQWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NQjJ9H/+; arc=none smtp.client-ip=209.85.219.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NQjJ9H/+"
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-dc236729a2bso4189421276.0
        for <patches@lists.linux.dev>; Mon, 01 Apr 2024 15:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712010452; x=1712615252; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fun6t9xjAHzzOFt7K8uuNDThfEvVvoMsgmIVU5DYRmw=;
        b=NQjJ9H/+I0Ngt/Sd6NO1azMhermQWEI7YiiWTwF0tvks12I7vRMvrHrDktpRsNngWo
         t8iX5yfweFNH4N15q7ikWa0eBNh0xS9j/c41niYvrL2t61yGdGYtTv62WsfDSGjuu99p
         o+SfWgQJRfb80WqBiUDW4/o/o6qoj95mjiDrL+UBVY0J7nz1e9GVHvCLlfq37O1mFLjk
         /kYs+974grHU/CAFAL6t8FQZ4w6zW5HInO+s/Hedkc934Vxg1QPcHMqJqnZpN3f5vYYo
         pqUW86O5QLqZivwYf9HltGUhsoEUWUMcQkEgh1qVMiJWX5g6CnfBZvjB/sC2LAoqSn5+
         Z+Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712010452; x=1712615252;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fun6t9xjAHzzOFt7K8uuNDThfEvVvoMsgmIVU5DYRmw=;
        b=bX5qrQMUa5MIsFukiDt7IHL+wBbW7mr1GWBwS+6C0n1juQPTGb5WyY23HSa+sk9iwX
         wOISeK2mkpGoG6HLm0558sswVqzxvp16uytxEBWyF231sY74y68WTeSQ7P2rLK/FaVP1
         wplqSB4rZ7Lc746lx9aZMv9vl1FL2i4stnRdxU/EjDubdwvyIWgvPHY9/KdqEE6YB4Vq
         m99qeSZPyRnoLSYqsYuMNpSP6r9Ve/U0Pt+iV8zGauEyPhl39ttrLzRdePh2BHYriX6O
         60Z3Ul0uW9hQ96T7cDP3JBa5GrphTNa1xNO3AGm7ANV/zMRxTqRY1gQ/RHw3DFXG6JXx
         rsyg==
X-Forwarded-Encrypted: i=1; AJvYcCUqsK4ieVMPqA8Oak0euQRztmzGL8t91Egiuel365V6klp7roHGkLGeDgp3glL1JfhmxfYSEyLeaGIXM3kRZeyMQVeGyhuyBA==
X-Gm-Message-State: AOJu0YxYatnCsys8wijvKOQUG70z+D3LMBboBOwbs7bP4qQJM2+aiB+R
	lxLRz3yDHdi0t/JFU+2Yyp30cgicg5G/X+FuXke6GEyylkNLdKeq
X-Google-Smtp-Source: AGHT+IFxhtbrdEbRKIE5EhZin4tZI9VxuRYFo+PIISiS0eV20MlXsziELGLLI9eqZum2nn0VYt1ibg==
X-Received: by 2002:a25:fb05:0:b0:dc6:ff32:aaea with SMTP id j5-20020a25fb05000000b00dc6ff32aaeamr8588124ybe.24.1712010451861;
        Mon, 01 Apr 2024 15:27:31 -0700 (PDT)
Received: from fauth1-smtp.messagingengine.com (fauth1-smtp.messagingengine.com. [103.168.172.200])
        by smtp.gmail.com with ESMTPSA id jz9-20020a0562140e6900b00698f825b08csm3118580qvb.70.2024.04.01.15.27.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Apr 2024 15:27:31 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
	by mailfauth.nyi.internal (Postfix) with ESMTP id 75EFF1200066;
	Mon,  1 Apr 2024 18:27:30 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 01 Apr 2024 18:27:30 -0400
X-ME-Sender: <xms:0TQLZtL3ljYYEwGc0VpQY45AUnmJGMsx2NoDA5NA1muPJ9K47421Zw>
    <xme:0TQLZpJMfLopoSVxPvFUsDfORZSVoXTtz-JW8jzuQOomNci-wCgOxEIKOEpS5lGYT
    Yo3inYBobMD26dJvg>
X-ME-Received: <xmr:0TQLZlsesD1Dgb5AxvxqxrG-2cKiuQ1CG856xJW7pcymS9OyWcl-_6eEHGM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrudefuddgtdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehoqhhu
    nhcuhfgvnhhguceosghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmqeenucggtffrrg
    htthgvrhhnpefftdeihfeigedtvdeuueffieetvedtgeejuefhhffgudfgfeeggfeftdei
    geehvdenucffohhmrghinhepghhithhhuhgsrdgtohhmnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomhepsghoqhhunhdomhgvshhmthhprghuthhh
    phgvrhhsohhnrghlihhthidqieelvdeghedtieegqddujeejkeehheehvddqsghoqhhunh
    drfhgvnhhgpeepghhmrghilhdrtghomhesfhhigihmvgdrnhgrmhgv
X-ME-Proxy: <xmx:0TQLZuYaCqphaMkLywE96DjK7MReH3qMO1bfIYoaXp3R5jLG7u6G8Q>
    <xmx:0TQLZkbcw_a0xXUgheqQAxv0LhqSsSDbrbfs8wj5JRXFZWoVR_tNEw>
    <xmx:0TQLZiBKuk4r-z8sxXlfp1ULorCIm8rIbfKso9BrpUHIaNmR4cV46g>
    <xmx:0TQLZibhB2xuYgi-qX_-FfceUzCGdKBaEOzOxLAKDbhi5DPS53_ogw>
    <xmx:0jQLZgR3pml68a9uI2sUt5oDOy07nUflcOmFcUuPWF6uHm_ZWoziGlBObXM>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 1 Apr 2024 18:27:29 -0400 (EDT)
Date: Mon, 1 Apr 2024 15:26:37 -0700
From: Boqun Feng <boqun.feng@gmail.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 1/3] rust: sync: implement `Default` for `LockClassKey`
Message-ID: <Zgs0nRjuLz9BaJQb@boqun-archlinux>
References: <20240401212303.537355-1-ojeda@kernel.org>
 <20240401212303.537355-2-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240401212303.537355-2-ojeda@kernel.org>

On Mon, Apr 01, 2024 at 11:23:01PM +0200, Miguel Ojeda wrote:
> In the upcoming Rust 1.78.0, Clippy suggests to implement `Default` even
> when `new()` is `const`, since `Default::default()` may call `const`
> functions even if it is not `const` itself [1]:
> 
>     error: you should consider adding a `Default` implementation for `LockClassKey`
>       --> rust/kernel/sync.rs:31:5
>        |
>     31 | /     pub const fn new() -> Self {
>     32 | |         Self(Opaque::uninit())
>     33 | |     }
>        | |_____^
> 
> Thus implement it.
> 
> Link: https://github.com/rust-lang/rust-clippy/pull/10903 [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Boqun Feng <boqun.feng@gmail.com>

Regards,
Boqun

> ---
>  rust/kernel/sync.rs | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/rust/kernel/sync.rs b/rust/kernel/sync.rs
> index c983f63fd56e..0ab20975a3b5 100644
> --- a/rust/kernel/sync.rs
> +++ b/rust/kernel/sync.rs
> @@ -37,6 +37,12 @@ pub(crate) fn as_ptr(&self) -> *mut bindings::lock_class_key {
>      }
>  }
>  
> +impl Default for LockClassKey {
> +    fn default() -> Self {
> +        Self::new()
> +    }
> +}
> +
>  /// Defines a new static lock class and returns a pointer to it.
>  #[doc(hidden)]
>  #[macro_export]
> -- 
> 2.44.0
> 
