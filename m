Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1500F79CC
	for <patches@lists.linux.dev>; Wed,  5 Apr 2023 21:03:26 +0000 (UTC)
Received: by mail-qt1-f175.google.com with SMTP id y4so6251969qti.5
        for <patches@lists.linux.dev>; Wed, 05 Apr 2023 14:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680728606;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iC6S0Dd2wld+hFfeTW38jpjfvqTCQBMPpfTFPRnn/3Y=;
        b=eVWI8JOB0Had3eImwcXP0NoKKQ6I2s3MyEt3DNSFiUrTVYCm104vOLyhAjR/VAT7ad
         PPEF/QAko3n3Q/io0d/zmQJO9DWimzOr4tkqXrygIY4InIIaKRjflbIRTosoplEZpPi5
         VpeDsFVvfttkDAb8JN8PZnOj69ZTtXTSGxuQ+KQlxc69faA1Fz33khhfMIW6MrzwfXVk
         UdOn736Mh8vUSwjQgQghEr61biqcyq6Z0p1OPTO1XVOpl7dRqeIj59y8+fqQ9qa3fPXu
         a+4sc8QFjNWCHRjGJ1cPwTaD4+4rgOxx0GH1AmeovU1I8E9li58kn0ZUCzioSp8keiOz
         YJgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680728606;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iC6S0Dd2wld+hFfeTW38jpjfvqTCQBMPpfTFPRnn/3Y=;
        b=iYXhG0YSLG/0VOx3Y/B56zhQ31IVm+wa2eVBsf/o6wBCtUYfHdpesKrmXHm8fDBCg1
         +Yt/4AaJx7euumWKRxS2nWPg8Zd2VkprKxq8zcmE/J0FLAM+S2r+ZUOtW9pPk1y20GCF
         gePs6UtgKN3WHjkx/Ty1jmsSe4QLp1y/GYu5RceRIcUSFWeGP4byPl5G695lAztw6Gu9
         C6J553MoZzGi0aQ15qoLPquNz+NtMJlEP7Bgtux3rmcbFHZR8lFRrBYSPqpZNBiv5wzf
         f4mCTIse0Vbl3Fl9ylVik+hQ/K4PNmZoxi1H966/tfRymUHE4RMfE/3xKvjP2z5pMqOj
         R3DQ==
X-Gm-Message-State: AAQBX9eMHQs3ncrJNrrYcvIX3eUyMqFwp+jd16gSCuIZe09sHbYEXw0o
	SSDOK6qppYeT0ZxAGsbzvp8=
X-Google-Smtp-Source: AKy350aRL7IyXF1vZb82PW7LiWWRNpZCTqbPmjXNkeYpJSLW6nfQdG7gkP1VaMxaYraVyWiWYIVzzg==
X-Received: by 2002:ac8:5a84:0:b0:3d3:fe29:1caf with SMTP id c4-20020ac85a84000000b003d3fe291cafmr6902530qtc.0.1680728605725;
        Wed, 05 Apr 2023 14:03:25 -0700 (PDT)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id 15-20020a37080f000000b007485a383921sm4686543qki.116.2023.04.05.14.03.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 14:03:25 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
	by mailauth.nyi.internal (Postfix) with ESMTP id B2DCF27C0054;
	Wed,  5 Apr 2023 17:03:24 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 05 Apr 2023 17:03:24 -0400
X-ME-Sender: <xms:HOItZJx3fVNX-q2IeOqrKBXk2JG6hCxtnPdDBEUV7TLHwVlOCoxPEQ>
    <xme:HOItZJQxqBmoyZioJiw7SkqQWw41IRs7sgXxIOaEIEb6sL2pqq42fImUubknd_2Qw
    9DSzxr3ZhN2m4D7lg>
X-ME-Received: <xmr:HOItZDVs-AyUF5YGTsgSNUehQxxe4zF9XHAt7mSGv7Mmo3Kh_GyK3PXzdnlcDg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdejuddgudehkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhq
    uhhnucfhvghnghcuoegsohhquhhnrdhfvghnghesghhmrghilhdrtghomheqnecuggftrf
    grthhtvghrnhephedugfduffffteeutddvheeuveelvdfhleelieevtdeguefhgeeuveei
    udffiedvnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epsghoqhhunhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqieelvdeghedt
    ieegqddujeejkeehheehvddqsghoqhhunhdrfhgvnhhgpeepghhmrghilhdrtghomhesfh
    higihmvgdrnhgrmhgv
X-ME-Proxy: <xmx:HOItZLgcvbIXFoL62LJyL9wrDorZ9Clnzd0Z_hXLuxkTbNtdzzrVbg>
    <xmx:HOItZLBONkhNe_qEkICkn9z6uSoGClmEPjxa3PrgDUDuA-JREaHHCQ>
    <xmx:HOItZEI9-DTwcujZQ2D63OZvZOU3c2UL6JlHXwy6K5e9_6X0PKFTvA>
    <xmx:HOItZP7sjfqG4TDmELTOvSYi6SQ1aIdrGJNI1XKAPkrIRyIIuVHuiw>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 5 Apr 2023 17:03:23 -0400 (EDT)
Date: Wed, 5 Apr 2023 14:02:22 -0700
From: Boqun Feng <boqun.feng@gmail.com>
To: Benno Lossin <y86-dev@protonmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Alice Ryhl <alice@ryhl.io>, Andreas Hindborg <nmi@metaspace.dk>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v6 00/15] Rust pin-init API for pinned initialization of
 structs
Message-ID: <ZC3h3q+56gM8pKOX@boqun-archlinux>
References: <20230405193445.745024-1-y86-dev@protonmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405193445.745024-1-y86-dev@protonmail.com>

On Wed, Apr 05, 2023 at 07:35:30PM +0000, Benno Lossin wrote:
> Changelog:
> v5 -> v6:
> - Change `pinned_drop` macro to allow `mut self` in the signature.
> - Change statement fragment to tt fragemnt in `pinned_drop` to prevent
>   parsing errors.
> - Move evaluation of the value in `stack_pin_init!`/`stack_try_pin_init!`
>   to the beginning.

Could you elaborate why? To make sure the $val evaluation happens
unconditionally?

> - Move setting uninitialized flag in front of dropping the value in
>   `StackInit::init`.
> - Remove `Unpin` requirement on `zeroed()`.
> - Add note about `Pointee` to the `Zeroable` impl on raw pointers.
> 

Regards,
Boqun
