Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33693D86
	for <patches@lists.linux.dev>; Wed, 21 Sep 2022 14:19:44 +0000 (UTC)
Received: by mail-qt1-f177.google.com with SMTP id h21so4170679qta.3
        for <patches@lists.linux.dev>; Wed, 21 Sep 2022 07:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :feedback-id:from:to:cc:subject:date;
        bh=T4MRIg2amNPk0okRjieG1Oas8X2+PWIKZP+dt1BOYDM=;
        b=ax3vK7A0nQGNEl+2IzvUxm5YxtqY18wTTmzis0YY7UzXCQKkrdvAxEqSr3N2chScn6
         3wckYD+lnepynBeAPfgkYvLMS15cq91myqV1sJSVU6d7j+/oTtg7PQalnWxMJKNMo9Ca
         kYbUf/iHNdem9CcYQxXFscD43n9VVn029QhAkDNOO1Lj9yqwFrpAYI0OHJk+CunWAfy6
         cHU9bQSH87w7YMisS4+Eoe4aQC4w6n5ZlWm50lAElbRGZQJZnOH2flDNtWlOG0C/l3Lo
         vCuF2ELz7wuMaqT/DCzIgsN7ZQF/ADvC1CEePrjYrNX5IMN8+XRWO5IinL80syhcVC7d
         wQrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :feedback-id:x-gm-message-state:from:to:cc:subject:date;
        bh=T4MRIg2amNPk0okRjieG1Oas8X2+PWIKZP+dt1BOYDM=;
        b=rLSNxDxdBtLVAtPSZNnFmRVgEa7NZ1hDD0K1rMYRIeyiagVO78fsfcY2W7ppNg3BU9
         +x5FVnMfhu91oyxvUozoeZOk421l5zI+Crl7I738PxRxZEt5tC+8uuyHkQWJsgqPgz9C
         5z3pmZavxHombxRlDWE4dzW8IJuvLWGQOztOWE86z7ZsqKxobHxh97g95UKAQtyHkem+
         NhXt86u+E+iKpRq2uolDfGnBG7wBhwA575x/O6RuZhuzS5Z2yQ6iKsfBN2ai0Xx8Z85q
         d1ERQLjUH8kzsTQ75WCoDTKmmnjwN9PFu1NLc4x2Ir/+HR3kZGif5J72oABebqydPm8Q
         g7Ag==
X-Gm-Message-State: ACrzQf2L6ff2oybqg3x7RrpcblgjmpNubEBQm9laa6T4YQVIAFcw8CIq
	1TXsKIFnSbbAs6f6UzO/C9s=
X-Google-Smtp-Source: AMsMyM5NlAkPbsiylhafIJTvP01gEn00rCmob8ynWjS6qTsX71vjvh2xisYRg7gT3DcXeAK0TjUTOA==
X-Received: by 2002:a05:622a:60f:b0:35b:b737:bcbe with SMTP id z15-20020a05622a060f00b0035bb737bcbemr23985839qta.149.1663769983741;
        Wed, 21 Sep 2022 07:19:43 -0700 (PDT)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id u22-20020a05620a431600b006b929a56a2bsm1977010qko.3.2022.09.21.07.19.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 07:19:42 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailauth.nyi.internal (Postfix) with ESMTP id DC7F627C0054;
	Wed, 21 Sep 2022 10:19:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Wed, 21 Sep 2022 10:19:41 -0400
X-ME-Sender: <xms:ex0rY7rjAUpVaSmHrpz3VGEhQjwchQKcjVgDAxneomc_14OtlfkL5A>
    <xme:ex0rY1ou1bgrwzPC9BcY9FXwObWcsHC3x4PrQf_Rqq_DvSIiWbqFzPy0Mo-yKzY5h
    dyd97-7ZvJmTXRUow>
X-ME-Received: <xmr:ex0rY4Pwwfj6kMYAoFxWfz9C7NJ8BDIK2FvgOimi_7sixjlEeLTmCQgB-g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeefuddgjeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpeeuohhq
    uhhnucfhvghnghcuoegsohhquhhnrdhfvghnghesghhmrghilhdrtghomheqnecuggftrf
    grthhtvghrnhepvefghfeuveekudetgfevudeuudejfeeltdfhgfehgeekkeeigfdukefh
    gfegleefnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epsghoqhhunhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqieelvdeghedt
    ieegqddujeejkeehheehvddqsghoqhhunhdrfhgvnhhgpeepghhmrghilhdrtghomhesfh
    higihmvgdrnhgrmhgv
X-ME-Proxy: <xmx:ex0rY-6FUMAIRWb0DDqh1bcU6MMxoc7XnvUoLgUkwONVlauXSIbG-g>
    <xmx:ex0rY66eSFKi0qz-qpNnEEyRrVrdCRfALWfA1JUj9yimTKmmzRKQxw>
    <xmx:ex0rY2iAyvTQZtrddFOhb2qJ0XDiUh0xi2BJYC8iCr9z-7rJPaBGoQ>
    <xmx:fR0rYxJuRspc60dj9TBf7Deu37lxiSg49JcZgq7lRrOHPf-l15UG0w>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 21 Sep 2022 10:19:39 -0400 (EDT)
Date: Wed, 21 Sep 2022 07:19:16 -0700
From: Boqun Feng <boqun.feng@gmail.com>
To: comex <comexk@gmail.com>
Cc: Gary Guo <gary@garyguo.net>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Kees Cook <keescook@chromium.org>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Konstantin Shelekhin <k.shelekhin@yadro.com>, ojeda@kernel.org,
	ark.email@gmail.com, bjorn3_gh@protonmail.com, bobo1239@web.de,
	bonifaido@gmail.com, davidgow@google.com, dev@niklasmohrin.de,
	dsosnowski@dsosnowski.pl, foxhlchen@gmail.com, geofft@ldpreload.com,
	gregkh@linuxfoundation.org, jarkko@kernel.org,
	john.m.baublitz@gmail.com, leseulartichaut@gmail.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	me@kloenk.de, milan@mdaverde.com, mjmouse9999@gmail.com,
	patches@lists.linux.dev, rust-for-linux@vger.kernel.org,
	thesven73@gmail.com, viktor@v-gar.de,
	Andreas Hindborg <andreas.hindborg@wdc.com>
Subject: Re: [PATCH v9 12/27] rust: add `kernel` crate
Message-ID: <YysdZIGp13ye0D4z@boqun-archlinux>
References: <YyivY6WIl/ahZQqy@wedsonaf-dev>
 <CAHk-=whm5Ujw-yroDPZWRsHK76XxZWF1E9806jNOicVTcQC6jw@mail.gmail.com>
 <Yyjut3MHooCwzHRc@wedsonaf-dev>
 <CAHk-=wityPWw4YkHeMNU4iGanyiC3UwDRhbOHYCJrhB2paCGwA@mail.gmail.com>
 <CAFRnB2VPpLSMqQwFPEjZhde8+-c6LLms54QkMt+wZPjOTULESw@mail.gmail.com>
 <CAHk-=wiyD6KqZN8jFkMHPRPxrbyJEUDRP6+WaH9Q9hjDB5i1zg@mail.gmail.com>
 <CAHk-=wj6sDFk8ZXSEKUMj-J9zfrMSSO3jhBEaveVaJSUpr=O=w@mail.gmail.com>
 <87a66uxcpc.fsf@email.froward.int.ebiederm.org>
 <20220920233947.0000345c@garyguo.net>
 <C85081E7-99CB-421F-AA3D-60326A5181EB@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <C85081E7-99CB-421F-AA3D-60326A5181EB@gmail.com>

On Wed, Sep 21, 2022 at 02:42:18AM -0400, comex wrote:
> 
> 
> > On Sep 20, 2022, at 6:39 PM, Gary Guo <gary@garyguo.net> wrote:
> > 
> > It should be noted however, atomic context is not something that a
> > token can represent. You can only use tokens to restrict what you *can*
> > do, but not what you *can't* do. There is no negative reasoning with
> > tokens, you can't create a function that can only be called when you
> > don't have token.
> 
> On the other hand, it ought to be feasible to implement that kind of
> ’negative reasoning' as a custom lint.  It might not work as well as
> something built into the language, but it should work decently well,
> and could serve as a prototype for a future built-in feature.

Interesting, do you have an example somewhere?

Regards,
Boqun
