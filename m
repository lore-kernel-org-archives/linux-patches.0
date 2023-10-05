Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09DB37F
	for <patches@lists.linux.dev>; Thu,  5 Oct 2023 06:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b="JqcXqGtZ"
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=umich.edu
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-5a4c073cc06so15471777b3.1
        for <patches@lists.linux.dev>; Wed, 04 Oct 2023 23:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umich.edu; s=google-2016-06-03; t=1696487561; x=1697092361; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pGyR1Zzvv154X8Dccwt7gC98O0K89BtDve6Z1+jKdN4=;
        b=JqcXqGtZqiE2AECl8SBCmZIu+zyzSrZqdqoC2eU1Ccvb74vrMj5dCnwEzLW4ZqTd1K
         j+IHCYTubxHiZ3kQu8GU+ablqtf5xdKDTl4fGINjNNSh3m6mBzMAVEbo08ipqvNbgMHl
         h5IBnjY6iYNNeoVu8tjMfkYcenZrW+PNoYaUg/T1vJqGGvGzTkvYyIf1cGJST46/Ob36
         GOzjgYchqZyni5er7I8D4+x7CeWR8UhJGAIdiLRvQ7qMhD3rJYZLGQaNhar1EwEHCqL9
         qgI3p2eguWphT/uj3DRm70m2hY+E6Hgs9mMiFekHBIhfJzNwDoRLJp/ZZnSRUCPHmgba
         KBkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696487561; x=1697092361;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pGyR1Zzvv154X8Dccwt7gC98O0K89BtDve6Z1+jKdN4=;
        b=vhjOF7Ytr7xV2trR1G1OwdAaIIRg4MFwZm3IBffd6R8XqGH5M0s+z2TSlsDQiqyeIU
         HcAspLyHhNvPDizQdsLfPoBwEqqFoG0Sempw3GTprHtB8VBQ8uztfoIBZdaDPXuLbJAE
         wfGgrLx9tmwCFJIGPXtYhKvlHm1DKZTJZOEf3DZbS4UYvT2h5NwyrVxmkHxz2K5HL2Ym
         Q2bfHeCtwL+ixlP/wGa8ExMv99Muy4xbMgpTnM9lAI/HsdQUmfBlCu1Ki5y14fhsPiZD
         +naEZkMYR1rpnxxqY5JeBSSOLZs/RZS45CmYrDKCRMjz9ZVK9C12kvMdPv/E8/0wtYVB
         vhKw==
X-Gm-Message-State: AOJu0YzeQnmcqcy7sspJoKgvfLdqZ0hfaD2vmetv5Iuxz9kltvhpOtld
	2cqPsxvLNBTU6ZiZsWbJcGwwPnkWr5oZWqZkwvIV4Q==
X-Google-Smtp-Source: AGHT+IHJAdiS+YNWfIdgWHzybEMmyvLq6s23YivEmEYidiPTA9ZiKm3Am2IIYO0pi7fIfuQ1zezOAfQglwsScJWCnr0=
X-Received: by 2002:a81:6086:0:b0:59f:6440:7eff with SMTP id
 u128-20020a816086000000b0059f64407effmr1449066ywb.15.1696487560949; Wed, 04
 Oct 2023 23:32:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CVZ2KU4KK5YH.2HVL1F6X93YLL@pogg> <20231003222947.374039-1-aliceryhl@google.com>
In-Reply-To: <20231003222947.374039-1-aliceryhl@google.com>
From: Trevor Gross <tmgross@umich.edu>
Date: Thu, 5 Oct 2023 02:32:29 -0400
Message-ID: <CALNs47s1=fjaXjymDM__G0-Qzv0mkftJ1hzOt4SZJt5Uy0WA1Q@mail.gmail.com>
Subject: Re: [PATCH v4 7/7] rust: workqueue: add examples
To: Alice Ryhl <aliceryhl@google.com>
Cc: k.shelekhin@ftml.net, alex.gaynor@gmail.com, benno.lossin@proton.me, 
	bjorn3_gh@protonmail.com, boqun.feng@gmail.com, gary@garyguo.net, 
	jiangshanlai@gmail.com, linux-kernel@vger.kernel.org, nmi@metaspace.dk, 
	ojeda@kernel.org, patches@lists.linux.dev, rust-for-linux@vger.kernel.org, 
	tj@kernel.org, wedsonaf@gmail.com, yakoyoku@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 3, 2023 at 6:30=E2=80=AFPM Alice Ryhl <aliceryhl@google.com> wr=
ote:
> On Tue, Oct 3, 2023 at 10:13PM Konstantin Shelekhin <k.shelekhin@ftml.net=
> wrote:
> > +//! #[pin_data]
> > +//! struct MyStruct {
> > +//!     value: i32,
> > +//!     #[pin]
> > +//!     work: Work<MyStruct>,
> > +//! }
> > +//!
> > +//! impl_has_work! {
> > +//!     impl HasWork<Self> for MyStruct { self.work }
> > +//! }
> > +//!
> > +//! impl MyStruct {
> > +//!     fn new(value: i32) -> Result<Arc<Self>> {
> > +//!         Arc::pin_init(pin_init!(MyStruct {
> > +//!             value,
> > +//!             work <- new_work!("MyStruct::work"),
> > +//!         }))
> > +//!     }
> > +//! }
> > +//!

For what it's worth, I think that using a binding for return items
usually looks ever so slightly more clear than passing a multiline
argument

    fn new(value: i32) -> Result<Arc<Self>> {
        let tmp =3D pin_init!(MyStruct {
            value,
            work <- new_work!("MyStruct::work")
        });
        Arc::pin_init(tmp)
    }
