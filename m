Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B432833D1
	for <patches@lists.linux.dev>; Thu, 17 Aug 2023 17:01:34 +0000 (UTC)
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-99df431d4bfso238009366b.1
        for <patches@lists.linux.dev>; Thu, 17 Aug 2023 10:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692291693; x=1692896493;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VaHh0ulwheswbARWm1tEyG4cJAfa0lzVWQw6k9lt+UQ=;
        b=G5A4eczuuJaCLlwyfk2ercrAkTTmOoQ22PKc9tfWW+5n8rFV8vjx3hgCgeHt8ZLilo
         3feHA1h34c1Xy0eOEvdoWD9FiGTT4SzL6PkFQd3Pz+QwjhfN80WDWQKJGfuShjhs/Qhg
         GYA921oI0rBYWi1gda4ofhiQKYtFA4Oq9GdXzfH4IyvX8+P3XKqPKkvofjszr1+ZCHzQ
         ogBnpTbk8RtChUvz7LFoW2EbG6sFfYMI+qFpNwT/ff8lUuoveISAsczc07QR8X16Bl0s
         ARPQrOmwBxcJDp8g3y0iWNelUv1pQH6PqjoPEcbfqjBJJNBVSRpjFsX9zrs6Dcuz/llh
         oZKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692291693; x=1692896493;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VaHh0ulwheswbARWm1tEyG4cJAfa0lzVWQw6k9lt+UQ=;
        b=PzP0jY6XHu7vIxF1RLMwMBCb+W0gkLKkKZtqUodduL0ohZA+XsOiRHM/VAbiyb9w4Y
         6lKPRJWjXOYZBJKn329iEjE6DBG7aOJRbDGUwJwceoBj6JVi4Olq/5mJGox6E4FuJ00D
         JyhocbcbpAdxT3W+uBa4T3bl8HkupOqkd3mMJpMhjfNAGkuWqxxsW5bmNqxxVNvzrcQv
         Lsg66KC14eZ7cdn04StXWJPap7NcGBYEfs8HV/7Q01rSfeR8AhIspJE/EgzP8twUi3Wq
         heN6mCxCJpSO71lds8+nZUbPJVY/8GkGUWsJzRUlj+R58V+Ky9RvJEvdc8W+MYWwEJvn
         RHmg==
X-Gm-Message-State: AOJu0Yw+DnxYKdIe7RxU5VA3baFmUHbeimoVYILffbKw/WQI3nC4px5j
	V4tODZq2l1ZstfMiap5Xffo=
X-Google-Smtp-Source: AGHT+IFiKHw6lhrq6f+ZeYw4iUYrokBM+4MnOVeMKS53g+WhThdJEPOsd8FOG52L5d5rFTuD8uJK0w==
X-Received: by 2002:a17:906:73c4:b0:99d:f560:5d3c with SMTP id n4-20020a17090673c400b0099df5605d3cmr33822ejl.23.1692291692487;
        Thu, 17 Aug 2023 10:01:32 -0700 (PDT)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id jo5-20020a170906f6c500b009786c8249d6sm10457304ejb.175.2023.08.17.10.01.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Aug 2023 10:01:30 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by mailauth.nyi.internal (Postfix) with ESMTP id 4FE5327C0054;
	Thu, 17 Aug 2023 13:01:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 17 Aug 2023 13:01:26 -0400
X-ME-Sender: <xms:ZFLeZGiRmhMy3zDWxLrKXBLSuGkJb-sre_gYF91gSpWpkBZfAdKFZQ>
    <xme:ZFLeZHB1SbuQyQ0dAp9zwbqQk0-nsZtG8KbQzVRH3jz8ICVt8Ng8A9Q0QuD6HX0y5
    _3p8-Btpwc3uf4cqA>
X-ME-Received: <xmr:ZFLeZOH4aRjWC0Nrla8gCOIhBtUNzt-rha-Dqg0BnjFzYY4lEHGG_DNf7l9KJg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedviedrudduuddguddtkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhq
    uhhnucfhvghnghcuoegsohhquhhnrdhfvghnghesghhmrghilhdrtghomheqnecuggftrf
    grthhtvghrnhephfetvdfgtdeukedvkeeiteeiteejieehvdetheduudejvdektdekfeeg
    vddvhedtnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhquhhnodhmvghsmhhtphgruhht
    hhhpvghrshhonhgrlhhithihqdeiledvgeehtdeigedqudejjeekheehhedvqdgsohhquh
    hnrdhfvghngheppehgmhgrihhlrdgtohhmsehfihigmhgvrdhnrghmvg
X-ME-Proxy: <xmx:ZFLeZPSJCG1B3Jo-WMZ4VyMaTRg197vuGwg_zOwyjt1CLOLZTVkeGw>
    <xmx:ZFLeZDy5xxn3Qfwla1VZjbGOEJB9YwjIBDGdXBC8GUnHUKxqWRM1Og>
    <xmx:ZFLeZN5irLYyrhFvXfYqe-pG8AMQnz5x5fw-jXP3yi68KDaWQLpiEA>
    <xmx:ZVLeZEoL3OOtGGOndwGjxB-V7F2fX_Oya6erBit1Wq2vqJ84Y8A4fA>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 17 Aug 2023 13:01:23 -0400 (EDT)
Date: Thu, 17 Aug 2023 10:01:08 -0700
From: Boqun Feng <boqun.feng@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Michele Dalle Rive <dallerivemichele@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>, Greg KH <gregkh@linuxfoundation.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Alice Ryhl <aliceryhl@google.com>,
	Davide Rovelli <davide.rovelli@usi.ch>,
	rust-for-linux@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [RFC PATCH 0/7] Rust Socket abstractions
Message-ID: <ZN5SVJafETEan6uo@boqun-archlinux>
References: <20230814092302.1903203-1-dallerivemichele@gmail.com>
 <2023081411-apache-tubeless-7bb3@gregkh>
 <0e91e3be-abbb-4bf7-be05-ba75c7522736@lunn.ch>
 <CACETy0=V9B8UOCi+BKfyrX06ca=WvC0Gvo_ouR=DjX=_-jhAwg@mail.gmail.com>
 <e3b4164a-5392-4209-99e5-560bf96df1df@lunn.ch>
 <CACETy0n0217=JOnHUWvxM_npDrdg4U=nzGYKqYbGFsvspjP6gg@mail.gmail.com>
 <20230817084848.4871fc23@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230817084848.4871fc23@kernel.org>

On Thu, Aug 17, 2023 at 08:48:48AM -0700, Jakub Kicinski wrote:
> On Thu, 17 Aug 2023 16:53:03 +0200 Michele Dalle Rive wrote:
> > in the last few days, I had the opportunity to discuss with some people from
> > the RustForLinux community.
> > 
> > I apologize for not being clear: the goal of these APIs was to give some
> > network support to, in particular, out-of-tree modules; they were not meant to
> > be used by a specific module that was planned to get upstreamed as well.
> > The idea behind this patch is that, as of now, Rust is not a viable option for
> > any OOT module that requires even the highest-level network support.
> > 
> > I am wondering whether the `net` subsystem is interested in reviewing, giving
> > feedback and eventually accepting code that is currently OOT-only.
> 
> This is a bit concerning. You can white out Rust in that and plonk in
> some corporate backed project people tried to cram into the kernel
> without understanding the community aspects. I'm not saying it's 
> the same but the tone reads the same.
> 
> "The `net` subsystem" have given "the RustForLinux community" clear
> guidance on what a good integration starting point is. And now someone
> else from Rust comes in and talk about supporting OOT modules.
> 
> I thought the Rust was just shaking up the languages we use, not the
> fundamentals on how this project operates :|

I want to make it clear that Rust is not a way to get anyone a special
pass for OOT support. That's never the intention of people in RUST
maintainer entries.

Here Michele did a good job on honestly sharing the context of the work. 

After the patchset sent, there was a discusion in Rust-for-Linux zulip
about why a in-tree user is needed for review (and merge), and how
people who are interested in networking could work with netdev on
finding useful in-tree users and correct abstraction/bindings. I
personally didn't sense anyone trying to undermining the Linux kernel
development.

Please understand that "the RustForLinux community" cannot control
everyone's mind to make them aware of Linux kernel's contribution
policy, but surely there is no execuse not reading:

	https://docs.kernel.org/process/development-process.html	

before contribution.

Regards,
Boqun
